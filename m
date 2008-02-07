Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYBGGSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYBGGSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYBGGSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 04/16] dlm: do not byteswap rcom_config
Date: Thu,  7 Feb 2008 00:09:07 -0600
Message-Id: <1202364559-9201-5-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |    6 +++---
 fs/dlm/rcom.c         |   15 ++++++++-------
 fs/dlm/util.c         |   20 --------------------
 3 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index e73b988..187a5b5 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -410,9 +410,9 @@ union dlm_packet {
 };
 
 struct rcom_config {
-	uint32_t		rf_lvblen;
-	uint32_t		rf_lsflags;
-	uint64_t		rf_unused;
+	__le32			rf_lvblen;
+	__le32			rf_lsflags;
+	__le64			rf_unused;
 };
 
 struct rcom_lock {
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 86c1ab9..fb07762 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -78,8 +78,8 @@ static void send_rcom(struct dlm_ls *ls, struct dlm_mhandle *mh,
 
 static void make_config(struct dlm_ls *ls, struct rcom_config *rf)
 {
-	rf->rf_lvblen = ls->ls_lvblen;
-	rf->rf_lsflags = ls->ls_exflags;
+	rf->rf_lvblen = cpu_to_le32(ls->ls_lvblen);
+	rf->rf_lsflags = cpu_to_le32(ls->ls_exflags);
 }
 
 static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
@@ -93,11 +93,12 @@ static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		return -EPROTO;
 	}
 
-	if (rf->rf_lvblen != ls->ls_lvblen ||
-	    rf->rf_lsflags != ls->ls_exflags) {
+	if (le32_to_cpu(rf->rf_lvblen) != ls->ls_lvblen ||
+	    le32_to_cpu(rf->rf_lsflags) != ls->ls_exflags) {
 		log_error(ls, "config mismatch: %d,%x nodeid %d: %d,%x",
-			  ls->ls_lvblen, ls->ls_exflags,
-			  nodeid, rf->rf_lvblen, rf->rf_lsflags);
+			  ls->ls_lvblen, ls->ls_exflags, nodeid,
+			  le32_to_cpu(rf->rf_lvblen),
+			  le32_to_cpu(rf->rf_lsflags));
 		return -EPROTO;
 	}
 	return 0;
@@ -401,7 +402,7 @@ int dlm_send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
 	rc->rc_result = -ESRCH;
 
 	rf = (struct rcom_config *) rc->rc_buf;
-	rf->rf_lvblen = -1;
+	rf->rf_lvblen = cpu_to_le32(~0U);
 
 	dlm_rcom_out(rc);
 	dlm_lowcomms_commit_buffer(mh);
diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index d3ed6da..e36520a 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -131,22 +131,8 @@ void dlm_message_in(struct dlm_message *ms)
 	ms->m_result		= from_dlm_errno(le32_to_cpu(ms->m_result));
 }
 
-static void rcom_config_out(struct rcom_config *rf)
-{
-	rf->rf_lvblen		= cpu_to_le32(rf->rf_lvblen);
-	rf->rf_lsflags		= cpu_to_le32(rf->rf_lsflags);
-}
-
-static void rcom_config_in(struct rcom_config *rf)
-{
-	rf->rf_lvblen		= le32_to_cpu(rf->rf_lvblen);
-	rf->rf_lsflags		= le32_to_cpu(rf->rf_lsflags);
-}
-
 void dlm_rcom_out(struct dlm_rcom *rc)
 {
-	int type = rc->rc_type;
-
 	header_out(&rc->rc_header);
 
 	rc->rc_type		= cpu_to_le32(rc->rc_type);
@@ -154,9 +140,6 @@ void dlm_rcom_out(struct dlm_rcom *rc)
 	rc->rc_id		= cpu_to_le64(rc->rc_id);
 	rc->rc_seq		= cpu_to_le64(rc->rc_seq);
 	rc->rc_seq_reply	= cpu_to_le64(rc->rc_seq_reply);
-
-	if (type == DLM_RCOM_STATUS_REPLY)
-		rcom_config_out((struct rcom_config *) rc->rc_buf);
 }
 
 void dlm_rcom_in(struct dlm_rcom *rc)
@@ -168,7 +151,4 @@ void dlm_rcom_in(struct dlm_rcom *rc)
 	rc->rc_id		= le64_to_cpu(rc->rc_id);
 	rc->rc_seq		= le64_to_cpu(rc->rc_seq);
 	rc->rc_seq_reply	= le64_to_cpu(rc->rc_seq_reply);
-
-	if (rc->rc_type == DLM_RCOM_STATUS_REPLY)
-		rcom_config_in((struct rcom_config *) rc->rc_buf);
 }
-- 
1.5.3.3

