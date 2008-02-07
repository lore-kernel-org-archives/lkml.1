Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYBGGTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYBGGTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYBGGSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 03/16] dlm: do not byteswap rcom_lock
Date: Thu,  7 Feb 2008 00:09:06 -0600
Message-Id: <1202364559-9201-4-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |   22 +++++++++++-----------
 fs/dlm/lock.c         |   34 +++++++++++++++++++---------------
 fs/dlm/rcom.c         |   14 +++++++-------
 fs/dlm/util.c         |   45 ++-------------------------------------------
 4 files changed, 39 insertions(+), 76 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 65499ce..e73b988 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -416,21 +416,21 @@ struct rcom_config {
 };
 
 struct rcom_lock {
-	uint32_t		rl_ownpid;
-	uint32_t		rl_lkid;
-	uint32_t		rl_remid;
-	uint32_t		rl_parent_lkid;
-	uint32_t		rl_parent_remid;
-	uint32_t		rl_exflags;
-	uint32_t		rl_flags;
-	uint32_t		rl_lvbseq;
-	int			rl_result;
+	__le32			rl_ownpid;
+	__le32			rl_lkid;
+	__le32			rl_remid;
+	__le32			rl_parent_lkid;
+	__le32			rl_parent_remid;
+	__le32			rl_exflags;
+	__le32			rl_flags;
+	__le32			rl_lvbseq;
+	__le32			rl_result;
 	int8_t			rl_rqmode;
 	int8_t			rl_grmode;
 	int8_t			rl_status;
 	int8_t			rl_asts;
-	uint16_t		rl_wait_type;
-	uint16_t		rl_namelen;
+	__le16			rl_wait_type;
+	__le16			rl_namelen;
 	char			rl_name[DLM_RESNAME_MAXLEN];
 	char			rl_lvb[0];
 };
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 2a28048..75176b5 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4273,12 +4273,12 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	int lvblen;
 
 	lkb->lkb_nodeid = rc->rc_header.h_nodeid;
-	lkb->lkb_ownpid = rl->rl_ownpid;
-	lkb->lkb_remid = rl->rl_lkid;
-	lkb->lkb_exflags = rl->rl_exflags;
-	lkb->lkb_flags = rl->rl_flags & 0x0000FFFF;
+	lkb->lkb_ownpid = le32_to_cpu(rl->rl_ownpid);
+	lkb->lkb_remid = le32_to_cpu(rl->rl_lkid);
+	lkb->lkb_exflags = le32_to_cpu(rl->rl_exflags);
+	lkb->lkb_flags = le32_to_cpu(rl->rl_flags) & 0x0000FFFF;
 	lkb->lkb_flags |= DLM_IFL_MSTCPY;
-	lkb->lkb_lvbseq = rl->rl_lvbseq;
+	lkb->lkb_lvbseq = le32_to_cpu(rl->rl_lvbseq);
 	lkb->lkb_rqmode = rl->rl_rqmode;
 	lkb->lkb_grmode = rl->rl_grmode;
 	/* don't set lkb_status because add_lkb wants to itself */
@@ -4299,7 +4299,8 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	   The real granted mode of these converting locks cannot be determined
 	   until all locks have been rebuilt on the rsb (recover_conversion) */
 
-	if (rl->rl_wait_type == DLM_MSG_CONVERT && middle_conversion(lkb)) {
+	if (rl->rl_wait_type == cpu_to_le16(DLM_MSG_CONVERT) &&
+	    middle_conversion(lkb)) {
 		rl->rl_status = DLM_LKSTS_CONVERT;
 		lkb->lkb_grmode = DLM_LOCK_IV;
 		rsb_set_flag(r, RSB_RECOVER_CONVERT);
@@ -4326,13 +4327,14 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 		goto out;
 	}
 
-	error = find_rsb(ls, rl->rl_name, rl->rl_namelen, R_MASTER, &r);
+	error = find_rsb(ls, rl->rl_name, le16_to_cpu(rl->rl_namelen),
+			 R_MASTER, &r);
 	if (error)
 		goto out;
 
 	lock_rsb(r);
 
-	lkb = search_remid(r, rc->rc_header.h_nodeid, rl->rl_lkid);
+	lkb = search_remid(r, rc->rc_header.h_nodeid, le32_to_cpu(rl->rl_lkid));
 	if (lkb) {
 		error = -EEXIST;
 		goto out_remid;
@@ -4355,15 +4357,16 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
  out_remid:
 	/* this is the new value returned to the lock holder for
 	   saving in its process-copy lkb */
-	rl->rl_remid = lkb->lkb_id;
+	rl->rl_remid = cpu_to_le32(lkb->lkb_id);
 
  out_unlock:
 	unlock_rsb(r);
 	put_rsb(r);
  out:
 	if (error)
-		log_debug(ls, "recover_master_copy %d %x", error, rl->rl_lkid);
-	rl->rl_result = error;
+		log_debug(ls, "recover_master_copy %d %x", error,
+			  le32_to_cpu(rl->rl_lkid));
+	rl->rl_result = cpu_to_le32(error);
 	return error;
 }
 
@@ -4374,15 +4377,16 @@ int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	struct dlm_lkb *lkb;
 	int error;
 
-	error = find_lkb(ls, rl->rl_lkid, &lkb);
+	error = find_lkb(ls, le32_to_cpu(rl->rl_lkid), &lkb);
 	if (error) {
-		log_error(ls, "recover_process_copy no lkid %x", rl->rl_lkid);
+		log_error(ls, "recover_process_copy no lkid %x",
+				le32_to_cpu(rl->rl_lkid));
 		return error;
 	}
 
 	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
 
-	error = rl->rl_result;
+	error = le32_to_cpu(rl->rl_result);
 
 	r = lkb->lkb_resource;
 	hold_rsb(r);
@@ -4401,7 +4405,7 @@ int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 		log_debug(ls, "master copy exists %x", lkb->lkb_id);
 		/* fall through */
 	case 0:
-		lkb->lkb_remid = rl->rl_remid;
+		lkb->lkb_remid = le32_to_cpu(rl->rl_remid);
 		break;
 	default:
 		log_error(ls, "dlm_recover_process_copy unknown error %d %x",
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 026824c..86c1ab9 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -299,22 +299,22 @@ static void pack_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb,
 {
 	memset(rl, 0, sizeof(*rl));
 
-	rl->rl_ownpid = lkb->lkb_ownpid;
-	rl->rl_lkid = lkb->lkb_id;
-	rl->rl_exflags = lkb->lkb_exflags;
-	rl->rl_flags = lkb->lkb_flags;
-	rl->rl_lvbseq = lkb->lkb_lvbseq;
+	rl->rl_ownpid = cpu_to_le32(lkb->lkb_ownpid);
+	rl->rl_lkid = cpu_to_le32(lkb->lkb_id);
+	rl->rl_exflags = cpu_to_le32(lkb->lkb_exflags);
+	rl->rl_flags = cpu_to_le32(lkb->lkb_flags);
+	rl->rl_lvbseq = cpu_to_le32(lkb->lkb_lvbseq);
 	rl->rl_rqmode = lkb->lkb_rqmode;
 	rl->rl_grmode = lkb->lkb_grmode;
 	rl->rl_status = lkb->lkb_status;
-	rl->rl_wait_type = lkb->lkb_wait_type;
+	rl->rl_wait_type = cpu_to_le16(lkb->lkb_wait_type);
 
 	if (lkb->lkb_bastaddr)
 		rl->rl_asts |= AST_BAST;
 	if (lkb->lkb_astaddr)
 		rl->rl_asts |= AST_COMP;
 
-	rl->rl_namelen = r->res_length;
+	rl->rl_namelen = cpu_to_le16(r->res_length);
 	memcpy(rl->rl_name, r->res_name, r->res_length);
 
 	/* FIXME: might we have an lvb without DLM_LKF_VALBLK set ?
diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index 4d9c1f4..d3ed6da 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -131,36 +131,6 @@ void dlm_message_in(struct dlm_message *ms)
 	ms->m_result		= from_dlm_errno(le32_to_cpu(ms->m_result));
 }
 
-static void rcom_lock_out(struct rcom_lock *rl)
-{
-	rl->rl_ownpid		= cpu_to_le32(rl->rl_ownpid);
-	rl->rl_lkid		= cpu_to_le32(rl->rl_lkid);
-	rl->rl_remid		= cpu_to_le32(rl->rl_remid);
-	rl->rl_parent_lkid	= cpu_to_le32(rl->rl_parent_lkid);
-	rl->rl_parent_remid	= cpu_to_le32(rl->rl_parent_remid);
-	rl->rl_exflags		= cpu_to_le32(rl->rl_exflags);
-	rl->rl_flags		= cpu_to_le32(rl->rl_flags);
-	rl->rl_lvbseq		= cpu_to_le32(rl->rl_lvbseq);
-	rl->rl_result		= cpu_to_le32(rl->rl_result);
-	rl->rl_wait_type	= cpu_to_le16(rl->rl_wait_type);
-	rl->rl_namelen		= cpu_to_le16(rl->rl_namelen);
-}
-
-static void rcom_lock_in(struct rcom_lock *rl)
-{
-	rl->rl_ownpid		= le32_to_cpu(rl->rl_ownpid);
-	rl->rl_lkid		= le32_to_cpu(rl->rl_lkid);
-	rl->rl_remid		= le32_to_cpu(rl->rl_remid);
-	rl->rl_parent_lkid	= le32_to_cpu(rl->rl_parent_lkid);
-	rl->rl_parent_remid	= le32_to_cpu(rl->rl_parent_remid);
-	rl->rl_exflags		= le32_to_cpu(rl->rl_exflags);
-	rl->rl_flags		= le32_to_cpu(rl->rl_flags);
-	rl->rl_lvbseq		= le32_to_cpu(rl->rl_lvbseq);
-	rl->rl_result		= le32_to_cpu(rl->rl_result);
-	rl->rl_wait_type	= le16_to_cpu(rl->rl_wait_type);
-	rl->rl_namelen		= le16_to_cpu(rl->rl_namelen);
-}
-
 static void rcom_config_out(struct rcom_config *rf)
 {
 	rf->rf_lvblen		= cpu_to_le32(rf->rf_lvblen);
@@ -185,17 +155,12 @@ void dlm_rcom_out(struct dlm_rcom *rc)
 	rc->rc_seq		= cpu_to_le64(rc->rc_seq);
 	rc->rc_seq_reply	= cpu_to_le64(rc->rc_seq_reply);
 
-	if ((type == DLM_RCOM_LOCK) || (type == DLM_RCOM_LOCK_REPLY))
-		rcom_lock_out((struct rcom_lock *) rc->rc_buf);
-
-	else if (type == DLM_RCOM_STATUS_REPLY)
+	if (type == DLM_RCOM_STATUS_REPLY)
 		rcom_config_out((struct rcom_config *) rc->rc_buf);
 }
 
 void dlm_rcom_in(struct dlm_rcom *rc)
 {
-	int type;
-
 	header_in(&rc->rc_header);
 
 	rc->rc_type		= le32_to_cpu(rc->rc_type);
@@ -204,12 +169,6 @@ void dlm_rcom_in(struct dlm_rcom *rc)
 	rc->rc_seq		= le64_to_cpu(rc->rc_seq);
 	rc->rc_seq_reply	= le64_to_cpu(rc->rc_seq_reply);
 
-	type = rc->rc_type;
-
-	if ((type == DLM_RCOM_LOCK) || (type == DLM_RCOM_LOCK_REPLY))
-		rcom_lock_in((struct rcom_lock *) rc->rc_buf);
-
-	else if (type == DLM_RCOM_STATUS_REPLY)
+	if (rc->rc_type == DLM_RCOM_STATUS_REPLY)
 		rcom_config_in((struct rcom_config *) rc->rc_buf);
 }
-
-- 
1.5.3.3

