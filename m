Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYGKLCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYGKLCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYGKLBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYGKLBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:30 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       David Teigland <teigland@redhat.com>
Subject: [PATCH 03/18] [GFS2] No lock_nolock
Date: Fri, 11 Jul 2008 11:11:04 +0100
Message-Id: <1215771091790-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1215771089769-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch merges the lock_nolock module into GFS2 itself. As well as removing
some of the overhead of the module, it also means that its now impossible to
build GFS2 without a lock module (which would be a pointless thing to do
anyway).

We also plan to merge lock_dlm into GFS2 in the future, but that is a more
tricky task, and will therefore be a separate patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 7f7947e..ab2f57e 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -14,23 +14,11 @@ config GFS2_FS
 	  GFS is perfect consistency -- changes made to the filesystem on one
 	  machine show up immediately on all other machines in the cluster.
 
-	  To use the GFS2 filesystem, you will need to enable one or more of
-	  the below locking modules. Documentation and utilities for GFS2 can
+	  To use the GFS2 filesystem in a cluster, you will need to enable
+	  the locking module below. Documentation and utilities for GFS2 can
 	  be found here: http://sources.redhat.com/cluster
 
-config GFS2_FS_LOCKING_NOLOCK
-	tristate "GFS2 \"nolock\" locking module"
-	depends on GFS2_FS
-	help
-	  Single node locking module for GFS2.
-
-	  Use this module if you want to use GFS2 on a single node without
-	  its clustering features. You can still take advantage of the
-	  large file support, and upgrade to running a full cluster later on
-	  if required.
-
-	  If you will only be using GFS2 in cluster mode, you do not need this
-	  module.
+	  The "nolock" lock module is now built in to GFS2 by default.
 
 config GFS2_FS_LOCKING_DLM
 	tristate "GFS2 DLM locking module"
diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index e2350df..ec65851 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -5,6 +5,5 @@ gfs2-y := acl.o bmap.o daemon.o dir.o eaops.o eattr.o glock.o \
 	ops_fstype.o ops_inode.o ops_super.o quota.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
 
-obj-$(CONFIG_GFS2_FS_LOCKING_NOLOCK) += locking/nolock/
 obj-$(CONFIG_GFS2_FS_LOCKING_DLM) += locking/dlm/
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 519a54c..be7ed50 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -153,7 +153,7 @@ static void glock_free(struct gfs2_glock *gl)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct inode *aspace = gl->gl_aspace;
 
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+	if (sdp->sd_lockstruct.ls_ops->lm_put_lock)
 		sdp->sd_lockstruct.ls_ops->lm_put_lock(gl->gl_lock);
 
 	if (aspace)
@@ -488,6 +488,10 @@ static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
 				 unsigned int flags)
 {
 	int ret = LM_OUT_ERROR;
+
+	if (!sdp->sd_lockstruct.ls_ops->lm_lock)
+		return req_state == LM_ST_UNLOCKED ? 0 : req_state;
+
 	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock, cur_state,
 							 req_state, flags);
@@ -631,6 +635,8 @@ static int gfs2_lm_get_lock(struct gfs2_sbd *sdp, struct lm_lockname *name,
 		     void **lockp)
 {
 	int error = -EIO;
+	if (!sdp->sd_lockstruct.ls_ops->lm_get_lock)
+		return 0;
 	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		error = sdp->sd_lockstruct.ls_ops->lm_get_lock(
 				sdp->sd_lockstruct.ls_lockspace, name, lockp);
@@ -910,7 +916,8 @@ do_cancel:
 	gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
 	if (!(gh->gh_flags & LM_FLAG_PRIORITY)) {
 		spin_unlock(&gl->gl_spin);
-		sdp->sd_lockstruct.ls_ops->lm_cancel(gl->gl_lock);
+		if (sdp->sd_lockstruct.ls_ops->lm_cancel)
+			sdp->sd_lockstruct.ls_ops->lm_cancel(gl->gl_lock);
 		spin_lock(&gl->gl_spin);
 	}
 	return;
@@ -1187,6 +1194,8 @@ void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs)
 static int gfs2_lm_hold_lvb(struct gfs2_sbd *sdp, void *lock, char **lvbp)
 {
 	int error = -EIO;
+	if (!sdp->sd_lockstruct.ls_ops->lm_hold_lvb)
+		return 0;
 	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		error = sdp->sd_lockstruct.ls_ops->lm_hold_lvb(lock, lvbp);
 	return error;
@@ -1226,7 +1235,7 @@ void gfs2_lvb_unhold(struct gfs2_glock *gl)
 	gfs2_glock_hold(gl);
 	gfs2_assert(gl->gl_sbd, atomic_read(&gl->gl_lvb_count) > 0);
 	if (atomic_dec_and_test(&gl->gl_lvb_count)) {
-		if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		if (sdp->sd_lockstruct.ls_ops->lm_unhold_lvb)
 			sdp->sd_lockstruct.ls_ops->lm_unhold_lvb(gl->gl_lock, gl->gl_lvb);
 		gl->gl_lvb = NULL;
 		gfs2_glock_put(gl);
diff --git a/fs/gfs2/locking.c b/fs/gfs2/locking.c
index 663fee7..a4a367a 100644
--- a/fs/gfs2/locking.c
+++ b/fs/gfs2/locking.c
@@ -23,12 +23,54 @@ struct lmh_wrapper {
 	const struct lm_lockops *lw_ops;
 };
 
+static int nolock_mount(char *table_name, char *host_data,
+			lm_callback_t cb, void *cb_data,
+			unsigned int min_lvb_size, int flags,
+			struct lm_lockstruct *lockstruct,
+			struct kobject *fskobj);
+
 /* List of registered low-level locking protocols.  A file system selects one
    of them by name at mount time, e.g. lock_nolock, lock_dlm. */
 
+static const struct lm_lockops nolock_ops = {
+	.lm_proto_name = "lock_nolock",
+	.lm_mount = nolock_mount,
+};
+
+static struct lmh_wrapper nolock_proto  = {
+	.lw_list = LIST_HEAD_INIT(nolock_proto.lw_list),
+	.lw_ops = &nolock_ops,
+};
+
 static LIST_HEAD(lmh_list);
 static DEFINE_MUTEX(lmh_lock);
 
+static int nolock_mount(char *table_name, char *host_data,
+			lm_callback_t cb, void *cb_data,
+			unsigned int min_lvb_size, int flags,
+			struct lm_lockstruct *lockstruct,
+			struct kobject *fskobj)
+{
+	char *c;
+	unsigned int jid;
+
+	c = strstr(host_data, "jid=");
+	if (!c)
+		jid = 0;
+	else {
+		c += 4;
+		sscanf(c, "%u", &jid);
+	}
+
+	lockstruct->ls_jid = jid;
+	lockstruct->ls_first = 1;
+	lockstruct->ls_lvb_size = min_lvb_size;
+	lockstruct->ls_ops = &nolock_ops;
+	lockstruct->ls_flags = LM_LSFLAG_LOCAL;
+
+	return 0;
+}
+
 /**
  * gfs2_register_lockproto - Register a low-level locking protocol
  * @proto: the protocol definition
@@ -116,9 +158,13 @@ int gfs2_mount_lockproto(char *proto_name, char *table_name, char *host_data,
 	int try = 0;
 	int error, found;
 
+
 retry:
 	mutex_lock(&lmh_lock);
 
+	if (list_empty(&nolock_proto.lw_list))
+		list_add(&lmh_list, &nolock_proto.lw_list);
+
 	found = 0;
 	list_for_each_entry(lw, &lmh_list, lw_list) {
 		if (!strcmp(lw->lw_ops->lm_proto_name, proto_name)) {
@@ -139,7 +185,8 @@ retry:
 		goto out;
 	}
 
-	if (!try_module_get(lw->lw_ops->lm_owner)) {
+	if (lw->lw_ops->lm_owner &&
+	    !try_module_get(lw->lw_ops->lm_owner)) {
 		try = 0;
 		mutex_unlock(&lmh_lock);
 		msleep(1000);
@@ -158,7 +205,8 @@ out:
 void gfs2_unmount_lockproto(struct lm_lockstruct *lockstruct)
 {
 	mutex_lock(&lmh_lock);
-	lockstruct->ls_ops->lm_unmount(lockstruct->ls_lockspace);
+	if (lockstruct->ls_ops->lm_unmount)
+		lockstruct->ls_ops->lm_unmount(lockstruct->ls_lockspace);
 	if (lockstruct->ls_ops->lm_owner)
 		module_put(lockstruct->ls_ops->lm_owner);
 	mutex_unlock(&lmh_lock);
diff --git a/fs/gfs2/locking/nolock/Makefile b/fs/gfs2/locking/nolock/Makefile
deleted file mode 100644
index 35e9730..0000000
--- a/fs/gfs2/locking/nolock/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_GFS2_FS_LOCKING_NOLOCK) += lock_nolock.o
-lock_nolock-y := main.o
-
diff --git a/fs/gfs2/locking/nolock/main.c b/fs/gfs2/locking/nolock/main.c
deleted file mode 100644
index 627bfb7..0000000
--- a/fs/gfs2/locking/nolock/main.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/fs.h>
-#include <linux/lm_interface.h>
-
-struct nolock_lockspace {
-	unsigned int nl_lvb_size;
-};
-
-static const struct lm_lockops nolock_ops;
-
-static int nolock_mount(char *table_name, char *host_data,
-			lm_callback_t cb, void *cb_data,
-			unsigned int min_lvb_size, int flags,
-			struct lm_lockstruct *lockstruct,
-			struct kobject *fskobj)
-{
-	char *c;
-	unsigned int jid;
-	struct nolock_lockspace *nl;
-
-	c = strstr(host_data, "jid=");
-	if (!c)
-		jid = 0;
-	else {
-		c += 4;
-		sscanf(c, "%u", &jid);
-	}
-
-	nl = kzalloc(sizeof(struct nolock_lockspace), GFP_KERNEL);
-	if (!nl)
-		return -ENOMEM;
-
-	nl->nl_lvb_size = min_lvb_size;
-
-	lockstruct->ls_jid = jid;
-	lockstruct->ls_first = 1;
-	lockstruct->ls_lvb_size = min_lvb_size;
-	lockstruct->ls_lockspace = nl;
-	lockstruct->ls_ops = &nolock_ops;
-	lockstruct->ls_flags = LM_LSFLAG_LOCAL;
-
-	return 0;
-}
-
-static void nolock_others_may_mount(void *lockspace)
-{
-}
-
-static void nolock_unmount(void *lockspace)
-{
-	struct nolock_lockspace *nl = lockspace;
-	kfree(nl);
-}
-
-static void nolock_withdraw(void *lockspace)
-{
-}
-
-/**
- * nolock_get_lock - get a lm_lock_t given a descripton of the lock
- * @lockspace: the lockspace the lock lives in
- * @name: the name of the lock
- * @lockp: return the lm_lock_t here
- *
- * Returns: 0 on success, -EXXX on failure
- */
-
-static int nolock_get_lock(void *lockspace, struct lm_lockname *name,
-			   void **lockp)
-{
-	*lockp = lockspace;
-	return 0;
-}
-
-/**
- * nolock_put_lock - get rid of a lock structure
- * @lock: the lock to throw away
- *
- */
-
-static void nolock_put_lock(void *lock)
-{
-}
-
-/**
- * nolock_lock - acquire a lock
- * @lock: the lock to manipulate
- * @cur_state: the current state
- * @req_state: the requested state
- * @flags: modifier flags
- *
- * Returns: A bitmap of LM_OUT_*
- */
-
-static unsigned int nolock_lock(void *lock, unsigned int cur_state,
-				unsigned int req_state, unsigned int flags)
-{
-	if (req_state == LM_ST_UNLOCKED)
-		return 0;
-	return req_state | LM_OUT_CACHEABLE;
-}
-
-/**
- * nolock_unlock - unlock a lock
- * @lock: the lock to manipulate
- * @cur_state: the current state
- *
- * Returns: 0
- */
-
-static unsigned int nolock_unlock(void *lock, unsigned int cur_state)
-{
-	return 0;
-}
-
-static void nolock_cancel(void *lock)
-{
-}
-
-/**
- * nolock_hold_lvb - hold on to a lock value block
- * @lock: the lock the LVB is associated with
- * @lvbp: return the lm_lvb_t here
- *
- * Returns: 0 on success, -EXXX on failure
- */
-
-static int nolock_hold_lvb(void *lock, char **lvbp)
-{
-	struct nolock_lockspace *nl = lock;
-	int error = 0;
-
-	*lvbp = kzalloc(nl->nl_lvb_size, GFP_NOFS);
-	if (!*lvbp)
-		error = -ENOMEM;
-
-	return error;
-}
-
-/**
- * nolock_unhold_lvb - release a LVB
- * @lock: the lock the LVB is associated with
- * @lvb: the lock value block
- *
- */
-
-static void nolock_unhold_lvb(void *lock, char *lvb)
-{
-	kfree(lvb);
-}
-
-static int nolock_plock_get(void *lockspace, struct lm_lockname *name,
-			    struct file *file, struct file_lock *fl)
-{
-	posix_test_lock(file, fl);
-
-	return 0;
-}
-
-static int nolock_plock(void *lockspace, struct lm_lockname *name,
-			struct file *file, int cmd, struct file_lock *fl)
-{
-	int error;
-	error = posix_lock_file_wait(file, fl);
-	return error;
-}
-
-static int nolock_punlock(void *lockspace, struct lm_lockname *name,
-			  struct file *file, struct file_lock *fl)
-{
-	int error;
-	error = posix_lock_file_wait(file, fl);
-	return error;
-}
-
-static void nolock_recovery_done(void *lockspace, unsigned int jid,
-				 unsigned int message)
-{
-}
-
-static const struct lm_lockops nolock_ops = {
-	.lm_proto_name = "lock_nolock",
-	.lm_mount = nolock_mount,
-	.lm_others_may_mount = nolock_others_may_mount,
-	.lm_unmount = nolock_unmount,
-	.lm_withdraw = nolock_withdraw,
-	.lm_get_lock = nolock_get_lock,
-	.lm_put_lock = nolock_put_lock,
-	.lm_lock = nolock_lock,
-	.lm_unlock = nolock_unlock,
-	.lm_cancel = nolock_cancel,
-	.lm_hold_lvb = nolock_hold_lvb,
-	.lm_unhold_lvb = nolock_unhold_lvb,
-	.lm_plock_get = nolock_plock_get,
-	.lm_plock = nolock_plock,
-	.lm_punlock = nolock_punlock,
-	.lm_recovery_done = nolock_recovery_done,
-	.lm_owner = THIS_MODULE,
-};
-
-static int __init init_nolock(void)
-{
-	int error;
-
-	error = gfs2_register_lockproto(&nolock_ops);
-	if (error) {
-		printk(KERN_WARNING
-		       "lock_nolock: can't register protocol: %d\n", error);
-		return error;
-	}
-
-	printk(KERN_INFO
-	       "Lock_Nolock (built %s %s) installed\n", __DATE__, __TIME__);
-	return 0;
-}
-
-static void __exit exit_nolock(void)
-{
-	gfs2_unregister_lockproto(&nolock_ops);
-}
-
-module_init(init_nolock);
-module_exit(exit_nolock);
-
-MODULE_DESCRIPTION("GFS Nolock Locking Module");
-MODULE_AUTHOR("Red Hat, Inc.");
-MODULE_LICENSE("GPL");
-
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b2028c8..9bd97c5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -364,6 +364,8 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
 
 static void gfs2_lm_others_may_mount(struct gfs2_sbd *sdp)
 {
+	if (!sdp->sd_lockstruct.ls_ops->lm_others_may_mount)
+		return;
 	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		sdp->sd_lockstruct.ls_ops->lm_others_may_mount(
 					sdp->sd_lockstruct.ls_lockspace);
@@ -741,8 +743,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 		goto out;
 	}
 
-	if (gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lockspace) ||
-	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_ops) ||
+	if (gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_ops) ||
 	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lvb_size >=
 				  GFS2_MIN_LVB_SIZE)) {
 		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index fdd3f0f..d5e91f4 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -428,6 +428,9 @@ static int clean_journal(struct gfs2_jdesc *jd, struct gfs2_log_header_host *hea
 static void gfs2_lm_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
 				  unsigned int message)
 {
+	if (!sdp->sd_lockstruct.ls_ops->lm_recovery_done)
+		return;
+
 	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		sdp->sd_lockstruct.ls_ops->lm_recovery_done(
 			sdp->sd_lockstruct.ls_lockspace, jid, message);
-- 
1.5.1.2

