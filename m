Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXGIQ1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXGIQ1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXGIQXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbXGIQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:30 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] block scand during recovery [1/6]
Date: Mon,  9 Jul 2007 17:02:17 +0100
Message-Id: <11839970122624-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970101065-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Don't let dlm_scand run during recovery since it may try to do a resource
directory removal while the directory nodes are changing.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index d8d6e72..09668ec 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -194,17 +194,17 @@ void dlm_dump_rsb(struct dlm_rsb *r)
 
 /* Threads cannot use the lockspace while it's being recovered */
 
-static inline void lock_recovery(struct dlm_ls *ls)
+static inline void dlm_lock_recovery(struct dlm_ls *ls)
 {
 	down_read(&ls->ls_in_recovery);
 }
 
-static inline void unlock_recovery(struct dlm_ls *ls)
+void dlm_unlock_recovery(struct dlm_ls *ls)
 {
 	up_read(&ls->ls_in_recovery);
 }
 
-static inline int lock_recovery_try(struct dlm_ls *ls)
+int dlm_lock_recovery_try(struct dlm_ls *ls)
 {
 	return down_read_trylock(&ls->ls_in_recovery);
 }
@@ -985,11 +985,10 @@ void dlm_scan_rsbs(struct dlm_ls *ls)
 {
 	int i;
 
-	if (dlm_locking_stopped(ls))
-		return;
-
 	for (i = 0; i < ls->ls_rsbtbl_size; i++) {
 		shrink_bucket(ls, i);
+		if (dlm_locking_stopped(ls))
+			break;
 		cond_resched();
 	}
 }
@@ -2274,7 +2273,7 @@ int dlm_lock(dlm_lockspace_t *lockspace,
 	if (!ls)
 		return -EINVAL;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	if (convert)
 		error = find_lkb(ls, lksb->sb_lkid, &lkb);
@@ -2302,7 +2301,7 @@ int dlm_lock(dlm_lockspace_t *lockspace,
 	if (error == -EAGAIN)
 		error = 0;
  out:
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 	dlm_put_lockspace(ls);
 	return error;
 }
@@ -2322,7 +2321,7 @@ int dlm_unlock(dlm_lockspace_t *lockspace,
 	if (!ls)
 		return -EINVAL;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	error = find_lkb(ls, lkid, &lkb);
 	if (error)
@@ -2344,7 +2343,7 @@ int dlm_unlock(dlm_lockspace_t *lockspace,
  out_put:
 	dlm_put_lkb(lkb);
  out:
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 	dlm_put_lockspace(ls);
 	return error;
 }
@@ -3424,7 +3423,7 @@ int dlm_receive_message(struct dlm_header *hd, int nodeid, int recovery)
 			}
 		}
 
-		if (lock_recovery_try(ls))
+		if (dlm_lock_recovery_try(ls))
 			break;
 		schedule();
 	}
@@ -3503,7 +3502,7 @@ int dlm_receive_message(struct dlm_header *hd, int nodeid, int recovery)
 		log_error(ls, "unknown message type %d", ms->m_type);
 	}
 
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
  out:
 	dlm_put_lockspace(ls);
 	dlm_astd_wake();
@@ -4040,7 +4039,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	struct dlm_args args;
 	int error;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	error = create_lkb(ls, &lkb);
 	if (error) {
@@ -4094,7 +4093,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	list_add_tail(&lkb->lkb_ownqueue, &ua->proc->locks);
 	spin_unlock(&ua->proc->locks_spin);
  out:
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 	return error;
 }
 
@@ -4106,7 +4105,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	struct dlm_user_args *ua;
 	int error;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	error = find_lkb(ls, lkid, &lkb);
 	if (error)
@@ -4146,7 +4145,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
  out_put:
 	dlm_put_lkb(lkb);
  out:
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 	kfree(ua_tmp);
 	return error;
 }
@@ -4159,7 +4158,7 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	struct dlm_user_args *ua;
 	int error;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	error = find_lkb(ls, lkid, &lkb);
 	if (error)
@@ -4194,7 +4193,7 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
  out_put:
 	dlm_put_lkb(lkb);
  out:
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 	kfree(ua_tmp);
 	return error;
 }
@@ -4207,7 +4206,7 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	struct dlm_user_args *ua;
 	int error;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	error = find_lkb(ls, lkid, &lkb);
 	if (error)
@@ -4231,7 +4230,7 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
  out_put:
 	dlm_put_lkb(lkb);
  out:
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 	kfree(ua_tmp);
 	return error;
 }
@@ -4314,7 +4313,7 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 {
 	struct dlm_lkb *lkb, *safe;
 
-	lock_recovery(ls);
+	dlm_lock_recovery(ls);
 
 	while (1) {
 		lkb = del_proc_lock(ls, proc);
@@ -4347,7 +4346,7 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 	}
 
 	mutex_unlock(&ls->ls_clear_proc_locks);
-	unlock_recovery(ls);
+	dlm_unlock_recovery(ls);
 }
 
 static void purge_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
@@ -4429,12 +4428,12 @@ int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
 	if (nodeid != dlm_our_nodeid()) {
 		error = send_purge(ls, nodeid, pid);
 	} else {
-		lock_recovery(ls);
+		dlm_lock_recovery(ls);
 		if (pid == current->pid)
 			purge_proc_locks(ls, proc);
 		else
 			do_purge(ls, nodeid, pid);
-		unlock_recovery(ls);
+		dlm_unlock_recovery(ls);
 	}
 	return error;
 }
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 64fc4ec..19403aa 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -24,6 +24,8 @@ void dlm_put_rsb(struct dlm_rsb *r);
 void dlm_hold_rsb(struct dlm_rsb *r);
 int dlm_put_lkb(struct dlm_lkb *lkb);
 void dlm_scan_rsbs(struct dlm_ls *ls);
+int dlm_lock_recovery_try(struct dlm_ls *ls);
+void dlm_unlock_recovery(struct dlm_ls *ls);
 
 int dlm_purge_locks(struct dlm_ls *ls);
 void dlm_purge_mstcpy_locks(struct dlm_rsb *r);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index a677b2a..414a108 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -234,8 +234,12 @@ static int dlm_scand(void *data)
 	struct dlm_ls *ls;
 
 	while (!kthread_should_stop()) {
-		list_for_each_entry(ls, &lslist, ls_list)
-			dlm_scan_rsbs(ls);
+		list_for_each_entry(ls, &lslist, ls_list) {
+			if (dlm_lock_recovery_try(ls)) {
+				dlm_scan_rsbs(ls);
+				dlm_unlock_recovery(ls);
+			}
+		}
 		schedule_timeout_interruptible(dlm_config.ci_scan_secs * HZ);
 	}
 	return 0;
-- 
1.5.1.2

