Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbYBGGXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbYBGGXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYBGGSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYBGGSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:06 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] dlm: eliminate astparam type casting
Date: Thu,  7 Feb 2008 00:09:18 -0600
Message-Id: <1202364559-9201-16-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put lkb_astparam in a union with a dlm_user_args pointer to
eliminate a lot of type casting.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/debug_fs.c     |    6 ++----
 fs/dlm/dlm_internal.h |    5 ++++-
 fs/dlm/lock.c         |   14 ++++++--------
 fs/dlm/memory.c       |    2 +-
 fs/dlm/netlink.c      |    5 ++---
 fs/dlm/user.c         |    8 +++-----
 6 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 12c3bfd..52b1196 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -162,14 +162,12 @@ static int print_resource(struct dlm_rsb *res, struct seq_file *s)
 
 static void print_lock(struct seq_file *s, struct dlm_lkb *lkb, struct dlm_rsb *r)
 {
-	struct dlm_user_args *ua;
 	unsigned int waiting = 0;
 	uint64_t xid = 0;
 
 	if (lkb->lkb_flags & DLM_IFL_USER) {
-		ua = (struct dlm_user_args *) lkb->lkb_astparam;
-		if (ua)
-			xid = ua->xid;
+		if (lkb->lkb_ua)
+			xid = lkb->lkb_ua->xid;
 	}
 
 	if (lkb->lkb_timestamp)
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index a53c237..d30ea8b 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -253,7 +253,10 @@ struct dlm_lkb {
 	struct dlm_lksb		*lkb_lksb;      /* caller's status block */
 	void			(*lkb_astfn) (void *astparam);
 	void			(*lkb_bastfn) (void *astparam, int mode);
-	void			*lkb_astparam;	/* caller's ast arg */
+	union {
+		void			*lkb_astparam;	/* caller's ast arg */
+		struct dlm_user_args	*lkb_ua;
+	};
 };
 
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 94f8cbd..8f250ac 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4533,7 +4533,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	/* user can change the params on its lock when it converts it, or
 	   add an lvb that didn't exist before */
 
-	ua = (struct dlm_user_args *)lkb->lkb_astparam;
+	ua = lkb->lkb_ua;
 
 	if (flags & DLM_LKF_VALBLK && !ua->lksb.sb_lvbptr) {
 		ua->lksb.sb_lvbptr = kzalloc(DLM_USER_LVB_LEN, GFP_KERNEL);
@@ -4584,7 +4584,7 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error)
 		goto out;
 
-	ua = (struct dlm_user_args *)lkb->lkb_astparam;
+	ua = lkb->lkb_ua;
 
 	if (lvb_in && ua->lksb.sb_lvbptr)
 		memcpy(ua->lksb.sb_lvbptr, lvb_in, DLM_USER_LVB_LEN);
@@ -4633,7 +4633,7 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error)
 		goto out;
 
-	ua = (struct dlm_user_args *)lkb->lkb_astparam;
+	ua = lkb->lkb_ua;
 	if (ua_tmp->castparam)
 		ua->castparam = ua_tmp->castparam;
 	ua->user_lksb = ua_tmp->user_lksb;
@@ -4671,7 +4671,7 @@ int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid)
 	if (error)
 		goto out;
 
-	ua = (struct dlm_user_args *)lkb->lkb_astparam;
+	ua = lkb->lkb_ua;
 
 	error = set_unlock_args(flags, ua, &args);
 	if (error)
@@ -4710,7 +4710,6 @@ int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid)
 
 static int orphan_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 {
-	struct dlm_user_args *ua = (struct dlm_user_args *)lkb->lkb_astparam;
 	struct dlm_args args;
 	int error;
 
@@ -4719,7 +4718,7 @@ static int orphan_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 	list_add_tail(&lkb->lkb_ownqueue, &ls->ls_orphans);
 	mutex_unlock(&ls->ls_orphans_mutex);
 
-	set_unlock_args(0, ua, &args);
+	set_unlock_args(0, lkb->lkb_ua, &args);
 
 	error = cancel_lock(ls, lkb, &args);
 	if (error == -DLM_ECANCEL)
@@ -4732,11 +4731,10 @@ static int orphan_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 
 static int unlock_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 {
-	struct dlm_user_args *ua = (struct dlm_user_args *)lkb->lkb_astparam;
 	struct dlm_args args;
 	int error;
 
-	set_unlock_args(DLM_LKF_FORCEUNLOCK, ua, &args);
+	set_unlock_args(DLM_LKF_FORCEUNLOCK, lkb->lkb_ua, &args);
 
 	error = unlock_lock(ls, lkb, &args);
 	if (error == -DLM_EUNLOCK)
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index f778386..65e41e5 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -80,7 +80,7 @@ void dlm_free_lkb(struct dlm_lkb *lkb)
 {
 	if (lkb->lkb_flags & DLM_IFL_USER) {
 		struct dlm_user_args *ua;
-		ua = (struct dlm_user_args *)lkb->lkb_astparam;
+		ua = lkb->lkb_ua;
 		if (ua) {
 			if (ua->lksb.sb_lvbptr)
 				kfree(ua->lksb.sb_lvbptr);
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 863b87d..90374b8 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -104,7 +104,6 @@ void dlm_netlink_exit(void)
 static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 {
 	struct dlm_rsb *r = lkb->lkb_resource;
-	struct dlm_user_args *ua = (struct dlm_user_args *) lkb->lkb_astparam;
 
 	memset(data, 0, sizeof(struct dlm_lock_data));
 
@@ -117,8 +116,8 @@ static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 	data->grmode = lkb->lkb_grmode;
 	data->rqmode = lkb->lkb_rqmode;
 	data->timestamp = lkb->lkb_timestamp;
-	if (ua)
-		data->xid = ua->xid;
+	if (lkb->lkb_ua)
+		data->xid = lkb->lkb_ua->xid;
 	if (r) {
 		data->lockspace_id = r->res_ls->ls_global_id;
 		data->resource_namelen = r->res_length;
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index c306045..70b31b9 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -195,8 +195,8 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type)
 	if (lkb->lkb_flags & (DLM_IFL_ORPHAN | DLM_IFL_DEAD))
 		goto out;
 
-	DLM_ASSERT(lkb->lkb_astparam, dlm_print_lkb(lkb););
-	ua = (struct dlm_user_args *)lkb->lkb_astparam;
+	DLM_ASSERT(lkb->lkb_ua, dlm_print_lkb(lkb););
+	ua = lkb->lkb_ua;
 	proc = ua->proc;
 
 	if (type == AST_BAST && ua->bastaddr == NULL)
@@ -771,7 +771,6 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 {
 	struct dlm_user_proc *proc = file->private_data;
 	struct dlm_lkb *lkb;
-	struct dlm_user_args *ua;
 	DECLARE_WAITQUEUE(wait, current);
 	int error, type=0, bmode=0, removed = 0;
 
@@ -842,8 +841,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	}
 	spin_unlock(&proc->asts_spin);
 
-	ua = (struct dlm_user_args *)lkb->lkb_astparam;
-	error = copy_result_to_user(ua,
+	error = copy_result_to_user(lkb->lkb_ua,
 			 	test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
 				type, bmode, buf, count);
 
-- 
1.5.3.3

