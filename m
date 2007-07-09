Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbXGIQ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbXGIQ1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbXGIQXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757556AbXGIQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:32 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] dlm_device interface changes [3/6]
Date: Mon,  9 Jul 2007 17:02:19 +0100
Message-Id: <11839970162125-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970143164-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Change the user/kernel device interface used by libdlm:
- Add ability for userspace to check the version of the interface.  libdlm
  can now adapt to different versions of the kernel interface.
- Increase the size of the flags passed in a lock request so all possible
  flags can be used from userspace.
- Add an opaque "xid" value for each lock.  This "transaction id" will be
  used later to associate locks with each other during deadlock detection.
- Add a "timeout" value for each lock.  This is used along with the
  DLM_LKF_TIMEOUT flag.

Also, remove a fragment of unused code in device_read().

This patch requires updating libdlm which is backward compatible with
older kernels.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 65a5fc0..a8d6e99 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -151,6 +151,7 @@ struct dlm_args {
 	void			*bastaddr;
 	int			mode;
 	struct dlm_lksb		*lksb;
+	unsigned long		timeout;
 };
 
 
@@ -528,6 +529,7 @@ struct dlm_user_args {
 	void __user		*castaddr;
 	void __user		*bastparam;
 	void __user		*bastaddr;
+	uint64_t		xid;
 };
 
 #define DLM_PROC_FLAGS_CLOSING 1
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ab986df..ad3797a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1098,6 +1098,8 @@ void dlm_scan_timeout(struct dlm_ls *ls)
 		}
 
 		if (do_cancel) {
+			log_debug("timeout cancel %x node %d %s", lkb->lkb_id,
+				  lkb->lkb_nodeid, r->res_name);
 			lkb->lkb_flags &= ~DLM_IFL_WATCH_TIMEWARN;
 			lkb->lkb_flags |= DLM_IFL_TIMEOUT_CANCEL;
 			del_timeout(lkb);
@@ -1864,7 +1866,7 @@ static void confirm_master(struct dlm_rsb *r, int error)
 }
 
 static int set_lock_args(int mode, struct dlm_lksb *lksb, uint32_t flags,
-			 int namelen, uint32_t parent_lkid, void *ast,
+			 int namelen, unsigned long timeout_cs, void *ast,
 			 void *astarg, void *bast, struct dlm_args *args)
 {
 	int rv = -EINVAL;
@@ -1907,10 +1909,6 @@ static int set_lock_args(int mode, struct dlm_lksb *lksb, uint32_t flags,
 	if (flags & DLM_LKF_VALBLK && !lksb->sb_lvbptr)
 		goto out;
 
-	/* parent/child locks not yet supported */
-	if (parent_lkid)
-		goto out;
-
 	if (flags & DLM_LKF_CONVERT && !lksb->sb_lkid)
 		goto out;
 
@@ -1922,6 +1920,7 @@ static int set_lock_args(int mode, struct dlm_lksb *lksb, uint32_t flags,
 	args->astaddr = ast;
 	args->astparam = (long) astarg;
 	args->bastaddr = bast;
+	args->timeout = timeout_cs;
 	args->mode = mode;
 	args->lksb = lksb;
 	rv = 0;
@@ -1976,6 +1975,7 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_lksb = args->lksb;
 	lkb->lkb_lvbptr = args->lksb->sb_lvbptr;
 	lkb->lkb_ownpid = (int) current->pid;
+	lkb->lkb_timeout_cs = args->timeout;
 	rv = 0;
  out:
 	return rv;
@@ -2423,7 +2423,7 @@ int dlm_lock(dlm_lockspace_t *lockspace,
 	if (error)
 		goto out;
 
-	error = set_lock_args(mode, lksb, flags, namelen, parent_lkid, ast,
+	error = set_lock_args(mode, lksb, flags, namelen, 0, ast,
 			      astarg, bast, &args);
 	if (error)
 		goto out_put;
@@ -4175,7 +4175,7 @@ int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 
 int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		     int mode, uint32_t flags, void *name, unsigned int namelen,
-		     uint32_t parent_lkid)
+		     unsigned long timeout_cs)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_args args;
@@ -4203,7 +4203,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	   When DLM_IFL_USER is set, the dlm knows that this is a userspace
 	   lock and that lkb_astparam is the dlm_user_args structure. */
 
-	error = set_lock_args(mode, &ua->lksb, flags, namelen, parent_lkid,
+	error = set_lock_args(mode, &ua->lksb, flags, namelen, timeout_cs,
 			      DLM_FAKE_USER_AST, ua, DLM_FAKE_USER_AST, &args);
 	lkb->lkb_flags |= DLM_IFL_USER;
 	ua->old_mode = DLM_LOCK_IV;
@@ -4240,7 +4240,8 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 }
 
 int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
-		     int mode, uint32_t flags, uint32_t lkid, char *lvb_in)
+		     int mode, uint32_t flags, uint32_t lkid, char *lvb_in,
+		     unsigned long timeout_cs)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_args args;
@@ -4268,6 +4269,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (lvb_in && ua->lksb.sb_lvbptr)
 		memcpy(ua->lksb.sb_lvbptr, lvb_in, DLM_USER_LVB_LEN);
 
+	ua->xid = ua_tmp->xid;
 	ua->castparam = ua_tmp->castparam;
 	ua->castaddr = ua_tmp->castaddr;
 	ua->bastparam = ua_tmp->bastparam;
@@ -4275,8 +4277,8 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	ua->user_lksb = ua_tmp->user_lksb;
 	ua->old_mode = lkb->lkb_grmode;
 
-	error = set_lock_args(mode, &ua->lksb, flags, 0, 0, DLM_FAKE_USER_AST,
-			      ua, DLM_FAKE_USER_AST, &args);
+	error = set_lock_args(mode, &ua->lksb, flags, 0, timeout_cs,
+			      DLM_FAKE_USER_AST, ua, DLM_FAKE_USER_AST, &args);
 	if (error)
 		goto out_put;
 
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 6b5b71f..99ab463 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -38,9 +38,11 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc);
 int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc);
 
 int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua, int mode,
-	uint32_t flags, void *name, unsigned int namelen, uint32_t parent_lkid);
+	uint32_t flags, void *name, unsigned int namelen,
+	unsigned long timeout_cs);
 int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
-	int mode, uint32_t flags, uint32_t lkid, char *lvb_in);
+	int mode, uint32_t flags, uint32_t lkid, char *lvb_in,
+	unsigned long timeout_cs);
 int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	uint32_t flags, uint32_t lkid, char *lvb_in);
 int dlm_user_cancel(struct dlm_ls *ls,  struct dlm_user_args *ua_tmp,
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index c7612da..37aad3f 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -33,16 +33,17 @@ static const struct file_operations device_fops;
 struct dlm_lock_params32 {
 	__u8 mode;
 	__u8 namelen;
-	__u16 flags;
+	__u16 unused;
+	__u32 flags;
 	__u32 lkid;
 	__u32 parent;
-
+	__u64 xid;
+	__u64 timeout;
 	__u32 castparam;
 	__u32 castaddr;
 	__u32 bastparam;
 	__u32 bastaddr;
 	__u32 lksb;
-
 	char lvb[DLM_USER_LVB_LEN];
 	char name[0];
 };
@@ -68,6 +69,7 @@ struct dlm_lksb32 {
 };
 
 struct dlm_lock_result32 {
+	__u32 version[3];
 	__u32 length;
 	__u32 user_astaddr;
 	__u32 user_astparam;
@@ -102,6 +104,8 @@ static void compat_input(struct dlm_write_request *kb,
 		kb->i.lock.flags = kb32->i.lock.flags;
 		kb->i.lock.lkid = kb32->i.lock.lkid;
 		kb->i.lock.parent = kb32->i.lock.parent;
+		kb->i.lock.xid = kb32->i.lock.xid;
+		kb->i.lock.timeout = kb32->i.lock.timeout;
 		kb->i.lock.castparam = (void *)(long)kb32->i.lock.castparam;
 		kb->i.lock.castaddr = (void *)(long)kb32->i.lock.castaddr;
 		kb->i.lock.bastparam = (void *)(long)kb32->i.lock.bastparam;
@@ -115,6 +119,10 @@ static void compat_input(struct dlm_write_request *kb,
 static void compat_output(struct dlm_lock_result *res,
 			  struct dlm_lock_result32 *res32)
 {
+	res32->version[0] = res->version[0];
+	res32->version[1] = res->version[1];
+	res32->version[2] = res->version[2];
+
 	res32->user_astaddr = (__u32)(long)res->user_astaddr;
 	res32->user_astparam = (__u32)(long)res->user_astparam;
 	res32->user_lksb = (__u32)(long)res->user_lksb;
@@ -252,16 +260,18 @@ static int device_user_lock(struct dlm_user_proc *proc,
 	ua->castaddr = params->castaddr;
 	ua->bastparam = params->bastparam;
 	ua->bastaddr = params->bastaddr;
+	ua->xid = params->xid;
 
 	if (params->flags & DLM_LKF_CONVERT)
 		error = dlm_user_convert(ls, ua,
 				         params->mode, params->flags,
-				         params->lkid, params->lvb);
+				         params->lkid, params->lvb,
+					 (unsigned long) params->timeout);
 	else {
 		error = dlm_user_request(ls, ua,
 					 params->mode, params->flags,
 					 params->name, params->namelen,
-					 params->parent);
+					 (unsigned long) params->timeout);
 		if (!error)
 			error = ua->lksb.sb_lkid;
 	}
@@ -641,6 +651,9 @@ static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
 	int struct_len;
 
 	memset(&result, 0, sizeof(struct dlm_lock_result));
+	result.version[0] = DLM_DEVICE_VERSION_MAJOR;
+	result.version[1] = DLM_DEVICE_VERSION_MINOR;
+	result.version[2] = DLM_DEVICE_VERSION_PATCH;
 	memcpy(&result.lksb, &ua->lksb, sizeof(struct dlm_lksb));
 	result.user_lksb = ua->user_lksb;
 
@@ -699,6 +712,20 @@ static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
 	return error;
 }
 
+static int copy_version_to_user(char __user *buf, size_t count)
+{
+	struct dlm_device_version ver;
+
+	memset(&ver, 0, sizeof(struct dlm_device_version));
+	ver.version[0] = DLM_DEVICE_VERSION_MAJOR;
+	ver.version[1] = DLM_DEVICE_VERSION_MINOR;
+	ver.version[2] = DLM_DEVICE_VERSION_PATCH;
+
+	if (copy_to_user(buf, &ver, sizeof(struct dlm_device_version)))
+		return -EFAULT;
+	return sizeof(struct dlm_device_version);
+}
+
 /* a read returns a single ast described in a struct dlm_lock_result */
 
 static ssize_t device_read(struct file *file, char __user *buf, size_t count,
@@ -710,6 +737,16 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	DECLARE_WAITQUEUE(wait, current);
 	int error, type=0, bmode=0, removed = 0;
 
+	if (count == sizeof(struct dlm_device_version)) {
+		error = copy_version_to_user(buf, count);
+		return error;
+	}
+
+	if (!proc) {
+		log_print("non-version read from control device %zu", count);
+		return -EINVAL;
+	}
+
 #ifdef CONFIG_COMPAT
 	if (count < sizeof(struct dlm_lock_result32))
 #else
@@ -747,11 +784,6 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 		}
 	}
 
-	if (list_empty(&proc->asts)) {
-		spin_unlock(&proc->asts_spin);
-		return -EAGAIN;
-	}
-
 	/* there may be both completion and blocking asts to return for
 	   the lkb, don't remove lkb from asts list unless no asts remain */
 
@@ -823,6 +855,7 @@ static const struct file_operations device_fops = {
 static const struct file_operations ctl_device_fops = {
 	.open    = ctl_device_open,
 	.release = ctl_device_close,
+	.read    = device_read,
 	.write   = device_write,
 	.owner   = THIS_MODULE,
 };
diff --git a/include/linux/dlm_device.h b/include/linux/dlm_device.h
index c2735ca..f7b9b57 100644
--- a/include/linux/dlm_device.h
+++ b/include/linux/dlm_device.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -18,21 +18,24 @@
 #define DLM_USER_LVB_LEN	32
 
 /* Version of the device interface */
-#define DLM_DEVICE_VERSION_MAJOR 5
-#define DLM_DEVICE_VERSION_MINOR 1
+#define DLM_DEVICE_VERSION_MAJOR 6
+#define DLM_DEVICE_VERSION_MINOR 0
 #define DLM_DEVICE_VERSION_PATCH 0
 
 /* struct passed to the lock write */
 struct dlm_lock_params {
 	__u8 mode;
 	__u8 namelen;
-	__u16 flags;
+	__u16 unused;
+	__u32 flags;
 	__u32 lkid;
 	__u32 parent;
-        void __user *castparam;
+	__u64 xid;
+	__u64 timeout;
+	void __user *castparam;
 	void __user *castaddr;
 	void __user *bastparam;
-        void __user *bastaddr;
+	void __user *bastaddr;
 	struct dlm_lksb __user *lksb;
 	char lvb[DLM_USER_LVB_LEN];
 	char name[0];
@@ -62,9 +65,15 @@ struct dlm_write_request {
 	} i;
 };
 
+struct dlm_device_version {
+	__u32 version[3];
+};
+
 /* struct read from the "device" fd,
    consists mainly of userspace pointers for the library to use */
+
 struct dlm_lock_result {
+	__u32 version[3];
 	__u32 length;
 	void __user * user_astaddr;
 	void __user * user_astparam;
-- 
1.5.1.2

