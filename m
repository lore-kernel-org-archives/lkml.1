Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbXGIQeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbXGIQeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXGIQYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896AbXGIQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:08 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] variable allocation
Date: Mon,  9 Jul 2007 17:02:37 +0100
Message-Id: <11839970521835-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997050365-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

Add a new flag, DLM_LSFL_FS, to be used when a file system creates a lockspace.
This flag causes the dlm to use GFP_NOFS for allocations instead of GFP_KERNEL.
(This updated version of the patch uses gfp_t for ls_allocation.)

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-Off-By: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index f2c8549..8ac0818 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -463,6 +463,7 @@ struct dlm_ls {
 	int			ls_low_nodeid;
 	int			ls_total_weight;
 	int			*ls_node_array;
+	gfp_t			ls_allocation;
 
 	struct dlm_rsb		ls_stub_rsb;	/* for returning errors */
 	struct dlm_lkb		ls_stub_lkb;	/* for returning errors */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index de943af..b455919 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2594,7 +2594,7 @@ static int _create_message(struct dlm_ls *ls, int mb_len,
 	   pass into lowcomms_commit and a message buffer (mb) that we
 	   write our data into */
 
-	mh = dlm_lowcomms_get_buffer(to_nodeid, mb_len, GFP_KERNEL, &mb);
+	mh = dlm_lowcomms_get_buffer(to_nodeid, mb_len, ls->ls_allocation, &mb);
 	if (!mh)
 		return -ENOBUFS;
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index c8f0c15..6802653 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -444,6 +444,11 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 		set_bit(LSFL_TIMEWARN, &ls->ls_flags);
 	ls->ls_exflags = (flags & ~DLM_LSFL_TIMEWARN);
 
+	if (flags & DLM_LSFL_FS)
+		ls->ls_allocation = GFP_NOFS;
+	else
+		ls->ls_allocation = GFP_KERNEL;
+
 	size = dlm_config.ci_rsbtbl_size;
 	ls->ls_rsbtbl_size = size;
 
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index f71c235..e3a1527 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -38,7 +38,7 @@ static int create_rcom(struct dlm_ls *ls, int to_nodeid, int type, int len,
 	char *mb;
 	int mb_len = sizeof(struct dlm_rcom) + len;
 
-	mh = dlm_lowcomms_get_buffer(to_nodeid, mb_len, GFP_KERNEL, &mb);
+	mh = dlm_lowcomms_get_buffer(to_nodeid, mb_len, ls->ls_allocation, &mb);
 	if (!mh) {
 		log_print("create_rcom to %d type %d len %d ENOBUFS",
 			  to_nodeid, type, len);
@@ -386,7 +386,8 @@ static void receive_rcom_lock_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	dlm_recover_process_copy(ls, rc_in);
 }
 
-static int send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
+static int send_ls_not_ready(struct dlm_ls *ls, int nodeid,
+			     struct dlm_rcom *rc_in)
 {
 	struct dlm_rcom *rc;
 	struct rcom_config *rf;
@@ -394,7 +395,7 @@ static int send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
 	char *mb;
 	int mb_len = sizeof(struct dlm_rcom) + sizeof(struct rcom_config);
 
-	mh = dlm_lowcomms_get_buffer(nodeid, mb_len, GFP_KERNEL, &mb);
+	mh = dlm_lowcomms_get_buffer(nodeid, mb_len, ls->ls_allocation, &mb);
 	if (!mh)
 		return -ENOBUFS;
 	memset(mb, 0, mb_len);
@@ -464,7 +465,7 @@ void dlm_receive_rcom(struct dlm_header *hd, int nodeid)
 		log_print("lockspace %x from %d type %x not found",
 			  hd->h_lockspace, nodeid, rc->rc_type);
 		if (rc->rc_type == DLM_RCOM_STATUS)
-			send_ls_not_ready(nodeid, rc);
+			send_ls_not_ready(ls, nodeid, rc);
 		return;
 	}
 
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index 1d8faa3..41c5b04 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -147,7 +147,7 @@ static int gdlm_mount(char *table_name, char *host_data,
 
 	error = dlm_new_lockspace(ls->fsname, strlen(ls->fsname),
 				  &ls->dlm_lockspace,
-				  nodir ? DLM_LSFL_NODIR : 0,
+				  DLM_LSFL_FS | (nodir ? DLM_LSFL_NODIR : 0),
 				  GDLM_LVB_SIZE);
 	if (error) {
 		log_error("dlm_new_lockspace error %d", error);
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index 5227a95..be9d278 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -206,6 +206,7 @@ struct dlm_lksb {
 
 #define DLM_LSFL_NODIR		0x00000001
 #define DLM_LSFL_TIMEWARN	0x00000002
+#define DLM_LSFL_FS     	0x00000004
 
 #ifdef __KERNEL__
 
-- 
1.5.1.2

