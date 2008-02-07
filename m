Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYBGGTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYBGGTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYBGGSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 02/16] dlm: dlm_process_incoming_buffer() fixes
Date: Thu,  7 Feb 2008 00:09:05 -0600
Message-Id: <1202364559-9201-3-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

* check that length is large enough to cover the non-variable part of message or
  rcom resp. (after checking that it's large enough to cover the header, of
  course).

* kill more pointless casts

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |    6 ++++++
 fs/dlm/lock.c         |   19 +++++++++----------
 fs/dlm/lock.h         |    2 +-
 fs/dlm/midcomms.c     |   33 ++++++++++++++++++++-------------
 4 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index ec61bba..65499ce 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -403,6 +403,12 @@ struct dlm_rcom {
 	char			rc_buf[0];
 };
 
+union dlm_packet {
+	struct dlm_header	header;		/* common to other two */
+	struct dlm_message	message;
+	struct dlm_rcom		rcom;
+};
+
 struct rcom_config {
 	uint32_t		rf_lvblen;
 	uint32_t		rf_lsflags;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index d9f07a4..2a28048 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3822,21 +3822,20 @@ void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms)
    standard locking activity) or an RCOM (recovery message sent as part of
    lockspace recovery). */
 
-void dlm_receive_buffer(struct dlm_header *hd, int nodeid)
+void dlm_receive_buffer(union dlm_packet *p, int nodeid)
 {
-	struct dlm_message *ms = (struct dlm_message *) hd;
-	struct dlm_rcom *rc = (struct dlm_rcom *) hd;
+	struct dlm_header *hd = &p->header;
 	struct dlm_ls *ls;
 	int type = 0;
 
 	switch (hd->h_cmd) {
 	case DLM_MSG:
-		dlm_message_in(ms);
-		type = ms->m_type;
+		dlm_message_in(&p->message);
+		type = p->message.m_type;
 		break;
 	case DLM_RCOM:
-		dlm_rcom_in(rc);
-		type = rc->rc_type;
+		dlm_rcom_in(&p->rcom);
+		type = p->rcom.rc_type;
 		break;
 	default:
 		log_print("invalid h_cmd %d from %u", hd->h_cmd, nodeid);
@@ -3856,7 +3855,7 @@ void dlm_receive_buffer(struct dlm_header *hd, int nodeid)
 				  hd->h_lockspace, nodeid, hd->h_cmd, type);
 
 		if (hd->h_cmd == DLM_RCOM && type == DLM_RCOM_STATUS)
-			dlm_send_ls_not_ready(nodeid, rc);
+			dlm_send_ls_not_ready(nodeid, &p->rcom);
 		return;
 	}
 
@@ -3865,9 +3864,9 @@ void dlm_receive_buffer(struct dlm_header *hd, int nodeid)
 
 	down_read(&ls->ls_recv_active);
 	if (hd->h_cmd == DLM_MSG)
-		dlm_receive_message(ls, ms, nodeid);
+		dlm_receive_message(ls, &p->message, nodeid);
 	else
-		dlm_receive_rcom(ls, rc, nodeid);
+		dlm_receive_rcom(ls, &p->rcom, nodeid);
 	up_read(&ls->ls_recv_active);
 
 	dlm_put_lockspace(ls);
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 27b6ed3..05d9c82 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -17,7 +17,7 @@ void dlm_print_rsb(struct dlm_rsb *r);
 void dlm_dump_rsb(struct dlm_rsb *r);
 void dlm_print_lkb(struct dlm_lkb *lkb);
 void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms);
-void dlm_receive_buffer(struct dlm_header *hd, int nodeid);
+void dlm_receive_buffer(union dlm_packet *p, int nodeid);
 int dlm_modes_compat(int mode1, int mode2);
 void dlm_put_rsb(struct dlm_rsb *r);
 void dlm_hold_rsb(struct dlm_rsb *r);
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index e69926e..07ac709 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -61,9 +61,9 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
 	union {
 		unsigned char __buf[DLM_INBUF_LEN];
 		/* this is to force proper alignment on some arches */
-		struct dlm_header dlm;
+		union dlm_packet p;
 	} __tmp;
-	struct dlm_header *msg = &__tmp.dlm;
+	union dlm_packet *p = &__tmp.p;
 	int ret = 0;
 	int err = 0;
 	uint16_t msglen;
@@ -75,15 +75,22 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
 		   message may wrap around the end of the buffer back to the
 		   start, so we need to use a temp buffer and copy_from_cb. */
 
-		copy_from_cb(msg, base, offset, sizeof(struct dlm_header),
+		copy_from_cb(p, base, offset, sizeof(struct dlm_header),
 			     limit);
 
-		msglen = le16_to_cpu(msg->h_length);
-		lockspace = msg->h_lockspace;
+		msglen = le16_to_cpu(p->header.h_length);
+		lockspace = p->header.h_lockspace;
 
 		err = -EINVAL;
 		if (msglen < sizeof(struct dlm_header))
 			break;
+		if (p->header.h_cmd == DLM_MSG) {
+			if (msglen < sizeof(struct dlm_message))
+				break;
+		} else {
+			if (msglen < sizeof(struct dlm_rcom))
+				break;
+		}
 		err = -E2BIG;
 		if (msglen > dlm_config.ci_buffer_size) {
 			log_print("message size %d from %d too big, buf len %d",
@@ -104,26 +111,26 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
 		   in the buffer on the stack (which should work for most
 		   ordinary messages). */
 
-		if (msglen > DLM_INBUF_LEN && msg == &__tmp.dlm) {
-			msg = kmalloc(dlm_config.ci_buffer_size, GFP_KERNEL);
-			if (msg == NULL)
+		if (msglen > sizeof(__tmp) && p == &__tmp.p) {
+			p = kmalloc(dlm_config.ci_buffer_size, GFP_KERNEL);
+			if (p == NULL)
 				return ret;
 		}
 
-		copy_from_cb(msg, base, offset, msglen, limit);
+		copy_from_cb(p, base, offset, msglen, limit);
 
-		BUG_ON(lockspace != msg->h_lockspace);
+		BUG_ON(lockspace != p->header.h_lockspace);
 
 		ret += msglen;
 		offset += msglen;
 		offset &= (limit - 1);
 		len -= msglen;
 
-		dlm_receive_buffer(msg, nodeid);
+		dlm_receive_buffer(p, nodeid);
 	}
 
-	if (msg != &__tmp.dlm)
-		kfree(msg);
+	if (p != &__tmp.p)
+		kfree(p);
 
 	return err ? err : ret;
 }
-- 
1.5.3.3

