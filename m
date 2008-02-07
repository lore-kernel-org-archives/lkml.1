Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbYBGGXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbYBGGXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYBGGS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] dlm: proper types for asts and basts
Date: Thu,  7 Feb 2008 00:09:17 -0600
Message-Id: <1202364559-9201-15-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper types for ast and bast functions, and use
consistent type for ast param.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c          |    9 +++----
 fs/dlm/dlm_internal.h |   14 +++++-------
 fs/dlm/lock.c         |   50 +++++++++++++++++++++++++++++++-----------------
 fs/dlm/rcom.c         |    4 +-
 4 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 6308122..8bf31e3 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -39,7 +39,6 @@ void dlm_add_ast(struct dlm_lkb *lkb, int type)
 		dlm_user_add_ast(lkb, type);
 		return;
 	}
-	DLM_ASSERT(lkb->lkb_astaddr != DLM_FAKE_USER_AST, dlm_print_lkb(lkb););
 
 	spin_lock(&ast_queue_lock);
 	if (!(lkb->lkb_ast_type & (AST_COMP | AST_BAST))) {
@@ -58,8 +57,8 @@ static void process_asts(void)
 	struct dlm_ls *ls = NULL;
 	struct dlm_rsb *r = NULL;
 	struct dlm_lkb *lkb;
-	void (*cast) (long param);
-	void (*bast) (long param, int mode);
+	void (*cast) (void *astparam);
+	void (*bast) (void *astparam, int mode);
 	int type = 0, found, bmode;
 
 	for (;;) {
@@ -83,8 +82,8 @@ static void process_asts(void)
 		if (!found)
 			break;
 
-		cast = lkb->lkb_astaddr;
-		bast = lkb->lkb_bastaddr;
+		cast = lkb->lkb_astfn;
+		bast = lkb->lkb_bastfn;
 		bmode = lkb->lkb_bastmode;
 
 		if ((type & AST_COMP) && cast)
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index f7fbaec..a53c237 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -92,8 +92,6 @@ do { \
   } \
 }
 
-#define DLM_FAKE_USER_AST ERR_PTR(-EINVAL)
-
 
 struct dlm_direntry {
 	struct list_head	list;
@@ -146,9 +144,9 @@ struct dlm_recover {
 
 struct dlm_args {
 	uint32_t		flags;
-	void			*astaddr;
-	long			astparam;
-	void			*bastaddr;
+	void			(*astfn) (void *astparam);
+	void			*astparam;
+	void			(*bastfn) (void *astparam, int mode);
 	int			mode;
 	struct dlm_lksb		*lksb;
 	unsigned long		timeout;
@@ -253,9 +251,9 @@ struct dlm_lkb {
 
 	char			*lkb_lvbptr;
 	struct dlm_lksb		*lkb_lksb;      /* caller's status block */
-	void			*lkb_astaddr;	/* caller's ast function */
-	void			*lkb_bastaddr;	/* caller's bast function */
-	long			lkb_astparam;	/* caller's ast arg */
+	void			(*lkb_astfn) (void *astparam);
+	void			(*lkb_bastfn) (void *astparam, int mode);
+	void			*lkb_astparam;	/* caller's ast arg */
 };
 
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 5b82187..94f8cbd 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1781,7 +1781,7 @@ static void grant_pending_locks(struct dlm_rsb *r)
 	 */
 
 	list_for_each_entry_safe(lkb, s, &r->res_grantqueue, lkb_statequeue) {
-		if (lkb->lkb_bastaddr && lock_requires_bast(lkb, high, cw)) {
+		if (lkb->lkb_bastfn && lock_requires_bast(lkb, high, cw)) {
 			if (cw && high == DLM_LOCK_PR)
 				queue_bast(r, lkb, DLM_LOCK_CW);
 			else
@@ -1811,7 +1811,7 @@ static void send_bast_queue(struct dlm_rsb *r, struct list_head *head,
 	struct dlm_lkb *gr;
 
 	list_for_each_entry(gr, head, lkb_statequeue) {
-		if (gr->lkb_bastaddr && modes_require_bast(gr, lkb)) {
+		if (gr->lkb_bastfn && modes_require_bast(gr, lkb)) {
 			queue_bast(r, gr, lkb->lkb_rqmode);
 			gr->lkb_highbast = lkb->lkb_rqmode;
 		}
@@ -1966,8 +1966,11 @@ static void confirm_master(struct dlm_rsb *r, int error)
 }
 
 static int set_lock_args(int mode, struct dlm_lksb *lksb, uint32_t flags,
-			 int namelen, unsigned long timeout_cs, void *ast,
-			 void *astarg, void *bast, struct dlm_args *args)
+			 int namelen, unsigned long timeout_cs,
+			 void (*ast) (void *astparam),
+			 void *astparam,
+			 void (*bast) (void *astparam, int mode),
+			 struct dlm_args *args)
 {
 	int rv = -EINVAL;
 
@@ -2017,9 +2020,9 @@ static int set_lock_args(int mode, struct dlm_lksb *lksb, uint32_t flags,
 	   an active lkb cannot be modified before locking the rsb */
 
 	args->flags = flags;
-	args->astaddr = ast;
-	args->astparam = (long) astarg;
-	args->bastaddr = bast;
+	args->astfn = ast;
+	args->astparam = astparam;
+	args->bastfn = bast;
 	args->timeout = timeout_cs;
 	args->mode = mode;
 	args->lksb = lksb;
@@ -2038,7 +2041,7 @@ static int set_unlock_args(uint32_t flags, void *astarg, struct dlm_args *args)
 		return -EINVAL;
 
 	args->flags = flags;
-	args->astparam = (long) astarg;
+	args->astparam = astarg;
 	return 0;
 }
 
@@ -2068,9 +2071,9 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 	lkb->lkb_exflags = args->flags;
 	lkb->lkb_sbflags = 0;
-	lkb->lkb_astaddr = args->astaddr;
+	lkb->lkb_astfn = args->astfn;
 	lkb->lkb_astparam = args->astparam;
-	lkb->lkb_bastaddr = args->bastaddr;
+	lkb->lkb_bastfn = args->bastfn;
 	lkb->lkb_rqmode = args->mode;
 	lkb->lkb_lksb = args->lksb;
 	lkb->lkb_lvbptr = args->lksb->sb_lvbptr;
@@ -2717,9 +2720,9 @@ static void send_args(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	/* m_result and m_bastmode are set from function args,
 	   not from lkb fields */
 
-	if (lkb->lkb_bastaddr)
+	if (lkb->lkb_bastfn)
 		ms->m_asts |= AST_BAST;
-	if (lkb->lkb_astaddr)
+	if (lkb->lkb_astfn)
 		ms->m_asts |= AST_COMP;
 
 	/* compare with switch in create_message; send_remove() doesn't
@@ -3002,6 +3005,16 @@ static int receive_lvb(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	return 0;
 }
 
+static void fake_bastfn(void *astparam, int mode)
+{
+	log_print("fake_bastfn should not be called");
+}
+
+static void fake_astfn(void *astparam)
+{
+	log_print("fake_astfn should not be called");
+}
+
 static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				struct dlm_message *ms)
 {
@@ -3010,8 +3023,9 @@ static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_remid = ms->m_lkid;
 	lkb->lkb_grmode = DLM_LOCK_IV;
 	lkb->lkb_rqmode = ms->m_rqmode;
-	lkb->lkb_bastaddr = (void *) (long) (ms->m_asts & AST_BAST);
-	lkb->lkb_astaddr = (void *) (long) (ms->m_asts & AST_COMP);
+
+	lkb->lkb_bastfn = (ms->m_asts & AST_BAST) ? &fake_bastfn : NULL;
+	lkb->lkb_astfn = (ms->m_asts & AST_COMP) ? &fake_astfn : NULL;
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		/* lkb was just created so there won't be an lvb yet */
@@ -4291,8 +4305,8 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_grmode = rl->rl_grmode;
 	/* don't set lkb_status because add_lkb wants to itself */
 
-	lkb->lkb_bastaddr = (void *) (long) (rl->rl_asts & AST_BAST);
-	lkb->lkb_astaddr = (void *) (long) (rl->rl_asts & AST_COMP);
+	lkb->lkb_bastfn = (rl->rl_asts & AST_BAST) ? &fake_bastfn : NULL;
+	lkb->lkb_astfn = (rl->rl_asts & AST_COMP) ? &fake_astfn : NULL;
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		int lvblen = rc->rc_header.h_length - sizeof(struct dlm_rcom) -
@@ -4466,7 +4480,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	   lock and that lkb_astparam is the dlm_user_args structure. */
 
 	error = set_lock_args(mode, &ua->lksb, flags, namelen, timeout_cs,
-			      DLM_FAKE_USER_AST, ua, DLM_FAKE_USER_AST, &args);
+			      fake_astfn, ua, fake_bastfn, &args);
 	lkb->lkb_flags |= DLM_IFL_USER;
 	ua->old_mode = DLM_LOCK_IV;
 
@@ -4540,7 +4554,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	ua->old_mode = lkb->lkb_grmode;
 
 	error = set_lock_args(mode, &ua->lksb, flags, 0, timeout_cs,
-			      DLM_FAKE_USER_AST, ua, DLM_FAKE_USER_AST, &args);
+			      fake_astfn, ua, fake_bastfn, &args);
 	if (error)
 		goto out_put;
 
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index ef9d0f9..035e6f9 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -318,9 +318,9 @@ static void pack_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	rl->rl_status = lkb->lkb_status;
 	rl->rl_wait_type = cpu_to_le16(lkb->lkb_wait_type);
 
-	if (lkb->lkb_bastaddr)
+	if (lkb->lkb_bastfn)
 		rl->rl_asts |= AST_BAST;
-	if (lkb->lkb_astaddr)
+	if (lkb->lkb_astfn)
 		rl->rl_asts |= AST_COMP;
 
 	rl->rl_namelen = cpu_to_le16(r->res_length);
-- 
1.5.3.3

