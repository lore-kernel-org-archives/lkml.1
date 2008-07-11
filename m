Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYGKLEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYGKLEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYGKLBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYGKLBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:42 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/18] [GFS2] Remove all_list from lock_dlm
Date: Fri, 11 Jul 2008 11:11:11 +0100
Message-Id: <12157711041157-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711023743-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

I discovered that we had a list onto which every lock_dlm
lock was being put. Its only function was to discover whether
we'd got any locks left after umount. Since there was already
a counter for that purpose as well, I removed the list. The
saving is sizeof(struct list_head) per glock - well worth
having.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index 894df45..2482c90 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -58,9 +58,6 @@ static void gdlm_delete_lp(struct gdlm_lock *lp)
 	spin_lock(&ls->async_lock);
 	if (!list_empty(&lp->delay_list))
 		list_del_init(&lp->delay_list);
-	gdlm_assert(!list_empty(&lp->all_list), "%x,%llx", lp->lockname.ln_type,
-		    (unsigned long long)lp->lockname.ln_number);
-	list_del_init(&lp->all_list);
 	ls->all_locks_count--;
 	spin_unlock(&ls->async_lock);
 
@@ -397,7 +394,6 @@ static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
 	INIT_LIST_HEAD(&lp->delay_list);
 
 	spin_lock(&ls->async_lock);
-	list_add(&lp->all_list, &ls->all_locks);
 	ls->all_locks_count++;
 	spin_unlock(&ls->async_lock);
 
@@ -710,22 +706,3 @@ void gdlm_submit_delayed(struct gdlm_ls *ls)
 	wake_up(&ls->thread_wait);
 }
 
-int gdlm_release_all_locks(struct gdlm_ls *ls)
-{
-	struct gdlm_lock *lp, *safe;
-	int count = 0;
-
-	spin_lock(&ls->async_lock);
-	list_for_each_entry_safe(lp, safe, &ls->all_locks, all_list) {
-		list_del_init(&lp->all_list);
-
-		if (lp->lvb && lp->lvb != junk_lvb)
-			kfree(lp->lvb);
-		kfree(lp);
-		count++;
-	}
-	spin_unlock(&ls->async_lock);
-
-	return count;
-}
-
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 845a27f..21cf466 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -74,7 +74,6 @@ struct gdlm_ls {
 	spinlock_t		async_lock;
 	struct list_head	delayed;
 	struct list_head	submit;
-	struct list_head	all_locks;
 	u32		all_locks_count;
 	wait_queue_head_t	wait_control;
 	struct task_struct	*thread;
@@ -112,7 +111,6 @@ struct gdlm_lock {
 	unsigned long		flags;		/* lock_dlm flags LFL_ */
 
 	struct list_head	delay_list;	/* delayed */
-	struct list_head	all_list;	/* all locks for the fs */
 	struct gdlm_lock	*hold_null;	/* NL lock for hold_lvb */
 };
 
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index fa31c54..947e706 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -28,7 +28,6 @@ static struct gdlm_ls *init_gdlm(lm_callback_t cb, struct gfs2_sbd *sdp,
 	spin_lock_init(&ls->async_lock);
 	INIT_LIST_HEAD(&ls->delayed);
 	INIT_LIST_HEAD(&ls->submit);
-	INIT_LIST_HEAD(&ls->all_locks);
 	init_waitqueue_head(&ls->thread_wait);
 	init_waitqueue_head(&ls->wait_control);
 	ls->jid = -1;
@@ -173,7 +172,6 @@ out:
 static void gdlm_unmount(void *lockspace)
 {
 	struct gdlm_ls *ls = lockspace;
-	int rv;
 
 	log_debug("unmount flags %lx", ls->flags);
 
@@ -187,9 +185,7 @@ static void gdlm_unmount(void *lockspace)
 	gdlm_kobject_release(ls);
 	dlm_release_lockspace(ls->dlm_lockspace, 2);
 	gdlm_release_threads(ls);
-	rv = gdlm_release_all_locks(ls);
-	if (rv)
-		log_info("gdlm_unmount: %d stray locks freed", rv);
+	BUG_ON(ls->all_locks_count);
 out:
 	kfree(ls);
 }
-- 
1.5.1.2

