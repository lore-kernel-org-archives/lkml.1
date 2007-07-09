Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbXGIQab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbXGIQab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXGIQXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101AbXGIQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:49 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] canceling deadlocked lock
Date: Mon,  9 Jul 2007 17:02:27 +0100
Message-Id: <11839970324005-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970302426-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Add a function that can be used through libdlm by a system daemon to cancel
another process's deadlocked lock.  A completion ast with EDEADLK is returned
to the process waiting for the lock.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index a7435a8..a006fa5 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -216,6 +216,7 @@ struct dlm_args {
 #define DLM_IFL_ENDOFLIFE	0x00200000
 #define DLM_IFL_WATCH_TIMEWARN	0x00400000
 #define DLM_IFL_TIMEOUT_CANCEL	0x00800000
+#define DLM_IFL_DEADLOCK_CANCEL	0x01000000
 #define DLM_IFL_USER		0x00000001
 #define DLM_IFL_ORPHAN		0x00000002
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index df91578..de943af 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -300,6 +300,11 @@ static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 		rv = -ETIMEDOUT;
 	}
 
+	if (rv == -DLM_ECANCEL && (lkb->lkb_flags & DLM_IFL_DEADLOCK_CANCEL)) {
+		lkb->lkb_flags &= ~DLM_IFL_DEADLOCK_CANCEL;
+		rv = -EDEADLK;
+	}
+
 	lkb->lkb_lksb->sb_status = rv;
 	lkb->lkb_lksb->sb_flags = lkb->lkb_sbflags;
 
@@ -4450,6 +4455,54 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	return error;
 }
 
+int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid)
+{
+	struct dlm_lkb *lkb;
+	struct dlm_args args;
+	struct dlm_user_args *ua;
+	struct dlm_rsb *r;
+	int error;
+
+	dlm_lock_recovery(ls);
+
+	error = find_lkb(ls, lkid, &lkb);
+	if (error)
+		goto out;
+
+	ua = (struct dlm_user_args *)lkb->lkb_astparam;
+
+	error = set_unlock_args(flags, ua, &args);
+	if (error)
+		goto out_put;
+
+	/* same as cancel_lock(), but set DEADLOCK_CANCEL after lock_rsb */
+
+	r = lkb->lkb_resource;
+	hold_rsb(r);
+	lock_rsb(r);
+
+	error = validate_unlock_args(lkb, &args);
+	if (error)
+		goto out_r;
+	lkb->lkb_flags |= DLM_IFL_DEADLOCK_CANCEL;
+
+	error = _cancel_lock(r, lkb);
+ out_r:
+	unlock_rsb(r);
+	put_rsb(r);
+
+	if (error == -DLM_ECANCEL)
+		error = 0;
+	/* from validate_unlock_args() */
+	if (error == -EBUSY)
+		error = 0;
+ out_put:
+	dlm_put_lkb(lkb);
+ out:
+	dlm_unlock_recovery(ls);
+	return error;
+}
+
 /* lkb's that are removed from the waiters list by revert are just left on the
    orphans list with the granted orphan locks, to be freed by purge */
 
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 99ab463..1720313 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -49,6 +49,7 @@ int dlm_user_cancel(struct dlm_ls *ls,  struct dlm_user_args *ua_tmp,
 	uint32_t flags, uint32_t lkid);
 int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
 	int nodeid, int pid);
+int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid);
 void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc);
 
 static inline int is_master(struct dlm_rsb *r)
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 329da1b..6438941 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -156,6 +156,7 @@ static int lkb_is_endoflife(struct dlm_lkb *lkb, int sb_status, int type)
 		return 1;
 	case -DLM_ECANCEL:
 	case -ETIMEDOUT:
+	case -EDEADLK:
 		if (lkb->lkb_grmode == DLM_LOCK_IV)
 			return 1;
 		break;
@@ -320,6 +321,22 @@ static int device_user_unlock(struct dlm_user_proc *proc,
 	return error;
 }
 
+static int device_user_deadlock(struct dlm_user_proc *proc,
+				struct dlm_lock_params *params)
+{
+	struct dlm_ls *ls;
+	int error;
+
+	ls = dlm_find_lockspace_local(proc->lockspace);
+	if (!ls)
+		return -ENOENT;
+
+	error = dlm_user_deadlock(ls, params->flags, params->lkid);
+
+	dlm_put_lockspace(ls);
+	return error;
+}
+
 static int create_misc_device(struct dlm_ls *ls, char *name)
 {
 	int error, len;
@@ -545,6 +562,14 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 		error = device_user_unlock(proc, &kbuf->i.lock);
 		break;
 
+	case DLM_USER_DEADLOCK:
+		if (!proc) {
+			log_print("no locking on control device");
+			goto out_sig;
+		}
+		error = device_user_deadlock(proc, &kbuf->i.lock);
+		break;
+
 	case DLM_USER_CREATE_LOCKSPACE:
 		if (proc) {
 			log_print("create/remove only on control device");
diff --git a/include/linux/dlm_device.h b/include/linux/dlm_device.h
index f7b9b57..9642277 100644
--- a/include/linux/dlm_device.h
+++ b/include/linux/dlm_device.h
@@ -92,6 +92,7 @@ struct dlm_lock_result {
 #define DLM_USER_CREATE_LOCKSPACE  4
 #define DLM_USER_REMOVE_LOCKSPACE  5
 #define DLM_USER_PURGE        6
+#define DLM_USER_DEADLOCK     7
 
 /* Arbitrary length restriction */
 #define MAX_LS_NAME_LEN 64
-- 
1.5.1.2

