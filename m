Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXBEOCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXBEOCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbXBEOCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:02:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbXBEOCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:02:46 -0500
Subject: [DLM] fix old rcom messages [3/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:10:48 +0000
Message-Id: <1170684648.11001.275.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From e9aa50aa89e1c5338abc0732e972a49be76f8003 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 13 Dec 2006 10:37:16 -0600
Subject: [PATCH] [DLM] fix old rcom messages

A reply to a recovery message will often be received after the relevant
recovery sequence has aborted and the next recovery sequence has begun.
We need to ignore replies to these old messages from the previous
recovery.  There's already a way to do this for synchronous recovery
requests using the rc_id number, but not for async.

Each recovery sequence already has a locally unique sequence number
associated with it.  This patch adds a field to the rcom (recovery
message) structure where this recovery sequence number can be placed,
rc_seq.  When a node sends a reply to a recovery request, it copies the
rc_seq number it received into rc_seq_reply.  When the first node receives
the reply to its recovery message, it will check whether rc_seq_reply
matches the current recovery sequence number, ls_recover_seq, and if not
then it ignores the old reply.

An old, inadequate approach to filtering out old replies (checking if the
current stage of recovery has moved back to the start) has been removed
from two spots.

The protocol version number is changed to reflect the different rcom
structures.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 1ee8195..7185a13 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -309,8 +309,8 @@ static inline int rsb_flag(struct dlm_rsb *r, enum rsb_flags flag)
 
 /* dlm_header is first element of all structs sent between nodes */
 
-#define DLM_HEADER_MAJOR	0x00020000
-#define DLM_HEADER_MINOR	0x00000001
+#define DLM_HEADER_MAJOR	0x00030000
+#define DLM_HEADER_MINOR	0x00000000
 
 #define DLM_MSG			1
 #define DLM_RCOM		2
@@ -386,6 +386,8 @@ struct dlm_rcom {
 	uint32_t		rc_type;	/* DLM_RCOM_ */
 	int			rc_result;	/* multi-purpose */
 	uint64_t		rc_id;		/* match reply with request */
+	uint64_t		rc_seq;		/* sender's ls_recover_seq */
+	uint64_t		rc_seq_reply;	/* remote ls_recover_seq */
 	char			rc_buf[0];
 };
 
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 4cc31be..521ad9b 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -56,6 +56,10 @@ static int create_rcom(struct dlm_ls *ls, int to_nodeid, int type, int len,
 
 	rc->rc_type = type;
 
+	spin_lock(&ls->ls_recover_lock);
+	rc->rc_seq = ls->ls_recover_seq;
+	spin_unlock(&ls->ls_recover_lock);
+
 	*mh_ret = mh;
 	*rc_ret = rc;
 	return 0;
@@ -159,6 +163,7 @@ static void receive_rcom_status(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	if (error)
 		return;
 	rc->rc_id = rc_in->rc_id;
+	rc->rc_seq_reply = rc_in->rc_seq;
 	rc->rc_result = dlm_recover_status(ls);
 	make_config(ls, (struct rcom_config *) rc->rc_buf);
 
@@ -224,21 +229,7 @@ static void receive_rcom_names(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 {
 	struct dlm_rcom *rc;
 	struct dlm_mhandle *mh;
-	int error, inlen, outlen;
-	int nodeid = rc_in->rc_header.h_nodeid;
-	uint32_t status = dlm_recover_status(ls);
-
-	/*
-	 * We can't run dlm_dir_rebuild_send (which uses ls_nodes) while
-	 * dlm_recoverd is running ls_nodes_reconfig (which changes ls_nodes).
-	 * It could only happen in rare cases where we get a late NAMES
-	 * message from a previous instance of recovery.
-	 */
-
-	if (!(status & DLM_RS_NODES)) {
-		log_debug(ls, "ignoring RCOM_NAMES from %u", nodeid);
-		return;
-	}
+	int error, inlen, outlen, nodeid;
 
 	nodeid = rc_in->rc_header.h_nodeid;
 	inlen = rc_in->rc_header.h_length - sizeof(struct dlm_rcom);
@@ -248,6 +239,7 @@ static void receive_rcom_names(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	if (error)
 		return;
 	rc->rc_id = rc_in->rc_id;
+	rc->rc_seq_reply = rc_in->rc_seq;
 
 	dlm_copy_master_names(ls, rc_in->rc_buf, inlen, rc->rc_buf, outlen,
 			      nodeid);
@@ -294,6 +286,7 @@ static void receive_rcom_lookup(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 		ret_nodeid = error;
 	rc->rc_result = ret_nodeid;
 	rc->rc_id = rc_in->rc_id;
+	rc->rc_seq_reply = rc_in->rc_seq;
 
 	send_rcom(ls, mh, rc);
 }
@@ -375,20 +368,13 @@ static void receive_rcom_lock(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 
 	memcpy(rc->rc_buf, rc_in->rc_buf, sizeof(struct rcom_lock));
 	rc->rc_id = rc_in->rc_id;
+	rc->rc_seq_reply = rc_in->rc_seq;
 
 	send_rcom(ls, mh, rc);
 }
 
 static void receive_rcom_lock_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 {
-	uint32_t status = dlm_recover_status(ls);
-
-	if (!(status & DLM_RS_DIR)) {
-		log_debug(ls, "ignoring RCOM_LOCK_REPLY from %u",
-			  rc_in->rc_header.h_nodeid);
-		return;
-	}
-
 	dlm_recover_process_copy(ls, rc_in);
 }
 
@@ -415,6 +401,7 @@ static int send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
 
 	rc->rc_type = DLM_RCOM_STATUS_REPLY;
 	rc->rc_id = rc_in->rc_id;
+	rc->rc_seq_reply = rc_in->rc_seq;
 	rc->rc_result = -ESRCH;
 
 	rf = (struct rcom_config *) rc->rc_buf;
@@ -426,6 +413,31 @@ static int send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
 	return 0;
 }
 
+static int is_old_reply(struct dlm_ls *ls, struct dlm_rcom *rc)
+{
+	uint64_t seq;
+	int rv = 0;
+
+	switch (rc->rc_type) {
+	case DLM_RCOM_STATUS_REPLY:
+	case DLM_RCOM_NAMES_REPLY:
+	case DLM_RCOM_LOOKUP_REPLY:
+	case DLM_RCOM_LOCK_REPLY:
+		spin_lock(&ls->ls_recover_lock);
+		seq = ls->ls_recover_seq;
+		spin_unlock(&ls->ls_recover_lock);
+		if (rc->rc_seq_reply != seq) {
+			log_error(ls, "ignoring old reply %x from %d "
+				      "seq_reply %llx expect %llx",
+				      rc->rc_type, rc->rc_header.h_nodeid,
+				      (unsigned long long)rc->rc_seq_reply,
+				      (unsigned long long)seq);
+			rv = 1;
+		}
+	}
+	return rv;
+}
+
 /* Called by dlm_recvd; corresponds to dlm_receive_message() but special
    recovery-only comms are sent through here. */
 
@@ -454,6 +466,9 @@ void dlm_receive_rcom(struct dlm_header *hd, int nodeid)
 		goto out;
 	}
 
+	if (is_old_reply(ls, rc))
+		goto out;
+
 	if (nodeid != rc->rc_header.h_nodeid) {
 		log_error(ls, "bad rcom nodeid %d from %d",
 			  rc->rc_header.h_nodeid, nodeid);
diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index 767197d..963889c 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -134,6 +134,8 @@ void dlm_rcom_out(struct dlm_rcom *rc)
 	rc->rc_type		= cpu_to_le32(rc->rc_type);
 	rc->rc_result		= cpu_to_le32(rc->rc_result);
 	rc->rc_id		= cpu_to_le64(rc->rc_id);
+	rc->rc_seq		= cpu_to_le64(rc->rc_seq);
+	rc->rc_seq_reply	= cpu_to_le64(rc->rc_seq_reply);
 
 	if (type == DLM_RCOM_LOCK)
 		rcom_lock_out((struct rcom_lock *) rc->rc_buf);
@@ -151,6 +153,8 @@ void dlm_rcom_in(struct dlm_rcom *rc)
 	rc->rc_type		= le32_to_cpu(rc->rc_type);
 	rc->rc_result		= le32_to_cpu(rc->rc_result);
 	rc->rc_id		= le64_to_cpu(rc->rc_id);
+	rc->rc_seq		= le64_to_cpu(rc->rc_seq);
+	rc->rc_seq_reply	= le64_to_cpu(rc->rc_seq_reply);
 
 	if (rc->rc_type == DLM_RCOM_LOCK)
 		rcom_lock_in((struct rcom_lock *) rc->rc_buf);
-- 
1.4.4.2



