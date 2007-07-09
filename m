Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbXGIQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbXGIQZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXGIQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXGIQXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:18 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Reduce size of struct gdlm_lock
Date: Mon,  9 Jul 2007 17:02:13 +0100
Message-Id: <11839970052865-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970032102-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch removes the completion (which is rather large) from struct
gdlm_lock in favour of using the wait_on_bit() functions. We don't need
to add any extra fields to the structure to do this, so we save 32 bytes
(on x86_64) per structure. This adds up to quite a lot when we may
potentially have millions of these lock structures,

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index c305255..542a797 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -174,7 +174,6 @@ static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
 	lp->cur = DLM_LOCK_IV;
 	lp->lvb = NULL;
 	lp->hold_null = NULL;
-	init_completion(&lp->ast_wait);
 	INIT_LIST_HEAD(&lp->clist);
 	INIT_LIST_HEAD(&lp->blist);
 	INIT_LIST_HEAD(&lp->delay_list);
@@ -399,6 +398,12 @@ static void gdlm_del_lvb(struct gdlm_lock *lp)
 	lp->lksb.sb_lvbptr = NULL;
 }
 
+static int gdlm_ast_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
 /* This can do a synchronous dlm request (requiring a lock_dlm thread to get
    the completion) because gfs won't call hold_lvb() during a callback (from
    the context of a lock_dlm thread). */
@@ -424,10 +429,10 @@ static int hold_null_lock(struct gdlm_lock *lp)
 	lpn->lkf = DLM_LKF_VALBLK | DLM_LKF_EXPEDITE;
 	set_bit(LFL_NOBAST, &lpn->flags);
 	set_bit(LFL_INLOCK, &lpn->flags);
+	set_bit(LFL_AST_WAIT, &lpn->flags);
 
-	init_completion(&lpn->ast_wait);
 	gdlm_do_lock(lpn);
-	wait_for_completion(&lpn->ast_wait);
+	wait_on_bit(&lpn->flags, LFL_AST_WAIT, gdlm_ast_wait, TASK_UNINTERRUPTIBLE);
 	error = lpn->lksb.sb_status;
 	if (error) {
 		printk(KERN_INFO "lock_dlm: hold_null_lock dlm error %d\n",
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index d074c6e..24d70f7 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -101,6 +101,7 @@ enum {
 	LFL_NOBAST		= 10,
 	LFL_HEADQUE		= 11,
 	LFL_UNLOCK_DELETE	= 12,
+	LFL_AST_WAIT		= 13,
 };
 
 struct gdlm_lock {
@@ -117,7 +118,6 @@ struct gdlm_lock {
 	unsigned long		flags;		/* lock_dlm flags LFL_ */
 
 	int			bast_mode;	/* protected by async_lock */
-	struct completion	ast_wait;
 
 	struct list_head	clist;		/* complete */
 	struct list_head	blist;		/* blocking */
diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
index 9cf1f16..1aca51e 100644
--- a/fs/gfs2/locking/dlm/thread.c
+++ b/fs/gfs2/locking/dlm/thread.c
@@ -44,6 +44,13 @@ static void process_blocking(struct gdlm_lock *lp, int bast_mode)
 	ls->fscb(ls->sdp, cb, &lp->lockname);
 }
 
+static void wake_up_ast(struct gdlm_lock *lp)
+{
+	clear_bit(LFL_AST_WAIT, &lp->flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&lp->flags, LFL_AST_WAIT);
+}
+
 static void process_complete(struct gdlm_lock *lp)
 {
 	struct gdlm_ls *ls = lp->ls;
@@ -136,7 +143,7 @@ static void process_complete(struct gdlm_lock *lp)
 	 */
 
 	if (test_and_clear_bit(LFL_SYNC_LVB, &lp->flags)) {
-		complete(&lp->ast_wait);
+		wake_up_ast(lp);
 		return;
 	}
 
@@ -214,7 +221,7 @@ out:
 	if (test_bit(LFL_INLOCK, &lp->flags)) {
 		clear_bit(LFL_NOBLOCK, &lp->flags);
 		lp->cur = lp->req;
-		complete(&lp->ast_wait);
+		wake_up_ast(lp);
 		return;
 	}
 
-- 
1.5.1.2

