Return-Path: <linux-kernel-owner+w=401wt.eu-S964843AbYDQJoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbYDQJoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763490AbYDQJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933683AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/48] [GFS2] Remove lm.[ch] and distribute content
Date: Thu, 17 Apr 2008 09:38:53 +0100
Message-Id: <12084216044123-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216023999-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The functions in lm.c were just wrappers which were mostly
only used in one other file. By moving the functions to
the files where they are being used, they can be marked
static and also this will usually result in them being inlined
since they are often only used from one point in the code.

A couple of really trivial functions have been inlined by hand
into the function which called them as it makes the code clearer
to do that.

We also gain from one fewer function call in the glock lock and
unlock paths.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 8fff110..e2350df 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o daemon.o dir.o eaops.o eattr.o glock.o \
-	glops.o inode.o lm.o log.o lops.o locking.o main.o meta_io.o \
+	glops.o inode.o log.o lops.o locking.o main.o meta_io.o \
 	mount.o ops_address.o ops_dentry.o ops_export.o ops_file.o \
 	ops_fstype.o ops_inode.o ops_super.o quota.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a8387e0..611f84d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -35,7 +35,6 @@
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
-#include "lm.h"
 #include "lops.h"
 #include "meta_io.h"
 #include "quota.h"
@@ -183,7 +182,8 @@ static void glock_free(struct gfs2_glock *gl)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct inode *aspace = gl->gl_aspace;
 
-	gfs2_lm_put_lock(sdp, gl->gl_lock);
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		sdp->sd_lockstruct.ls_ops->lm_put_lock(gl->gl_lock);
 
 	if (aspace)
 		gfs2_aspace_put(aspace);
@@ -293,6 +293,16 @@ static void glock_work_func(struct work_struct *work)
 	gfs2_glock_put(gl);
 }
 
+static int gfs2_lm_get_lock(struct gfs2_sbd *sdp, struct lm_lockname *name,
+		     void **lockp)
+{
+	int error = -EIO;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		error = sdp->sd_lockstruct.ls_ops->lm_get_lock(
+				sdp->sd_lockstruct.ls_lockspace, name, lockp);
+	return error;
+}
+
 /**
  * gfs2_glock_get() - Get a glock, or create one if one doesn't exist
  * @sdp: The GFS2 superblock
@@ -882,6 +892,17 @@ out:
 		gfs2_holder_wake(gh);
 }
 
+static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
+				 unsigned int cur_state, unsigned int req_state,
+				 unsigned int flags)
+{
+	int ret = 0;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock, cur_state,
+							 req_state, flags);
+	return ret;
+}
+
 /**
  * gfs2_glock_xmote_th - Call into the lock module to acquire or change a glock
  * @gl: The glock in question
@@ -922,6 +943,15 @@ static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
 		xmote_bh(gl, lck_ret);
 }
 
+static unsigned int gfs2_lm_unlock(struct gfs2_sbd *sdp, void *lock,
+				   unsigned int cur_state)
+{
+	int ret = 0;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		ret =  sdp->sd_lockstruct.ls_ops->lm_unlock(lock, cur_state);
+	return ret;
+}
+
 /**
  * gfs2_glock_drop_th - call into the lock module to unlock a lock
  * @gl: the glock
@@ -964,6 +994,7 @@ static void gfs2_glock_drop_th(struct gfs2_glock *gl)
 static void do_cancels(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	spin_lock(&gl->gl_spin);
 
@@ -972,7 +1003,8 @@ static void do_cancels(struct gfs2_holder *gh)
 	       !list_empty(&gh->gh_list)) {
 		if (!(gl->gl_req_gh && (gl->gl_req_gh->gh_flags & GL_NOCANCEL))) {
 			spin_unlock(&gl->gl_spin);
-			gfs2_lm_cancel(gl->gl_sbd, gl->gl_lock);
+			if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+				sdp->sd_lockstruct.ls_ops->lm_cancel(gl->gl_lock);
 			msleep(100);
 			spin_lock(&gl->gl_spin);
 		} else {
@@ -1426,6 +1458,14 @@ void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs)
 		gfs2_glock_dq_uninit(&ghs[x]);
 }
 
+static int gfs2_lm_hold_lvb(struct gfs2_sbd *sdp, void *lock, char **lvbp)
+{
+	int error = -EIO;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		error = sdp->sd_lockstruct.ls_ops->lm_hold_lvb(lock, lvbp);
+	return error;
+}
+
 /**
  * gfs2_lvb_hold - attach a LVB from a glock
  * @gl: The glock in question
@@ -1461,12 +1501,15 @@ int gfs2_lvb_hold(struct gfs2_glock *gl)
 
 void gfs2_lvb_unhold(struct gfs2_glock *gl)
 {
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+
 	gfs2_glock_hold(gl);
 	gfs2_glmutex_lock(gl);
 
 	gfs2_assert(gl->gl_sbd, atomic_read(&gl->gl_lvb_count) > 0);
 	if (atomic_dec_and_test(&gl->gl_lvb_count)) {
-		gfs2_lm_unhold_lvb(gl->gl_sbd, gl->gl_lock, gl->gl_lvb);
+		if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+			sdp->sd_lockstruct.ls_ops->lm_unhold_lvb(gl->gl_lock, gl->gl_lvb);
 		gl->gl_lvb = NULL;
 		gfs2_glock_put(gl);
 	}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 65aa46a..8dee467 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -211,6 +211,8 @@ struct gfs2_glock {
 	struct delayed_work gl_work;
 };
 
+#define GFS2_MIN_LVB_SIZE 32	/* Min size of LVB that gfs2 supports */
+
 struct gfs2_alloc {
 	/* Quota stuff */
 
diff --git a/fs/gfs2/lm.c b/fs/gfs2/lm.c
deleted file mode 100644
index cfcc39b..0000000
--- a/fs/gfs2/lm.c
+++ /dev/null
@@ -1,210 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/delay.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "glock.h"
-#include "lm.h"
-#include "super.h"
-#include "util.h"
-
-/**
- * gfs2_lm_mount - mount a locking protocol
- * @sdp: the filesystem
- * @args: mount arguements
- * @silent: if 1, don't complain if the FS isn't a GFS2 fs
- *
- * Returns: errno
- */
-
-int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
-{
-	char *proto = sdp->sd_proto_name;
-	char *table = sdp->sd_table_name;
-	int flags = 0;
-	int error;
-
-	if (sdp->sd_args.ar_spectator)
-		flags |= LM_MFLAG_SPECTATOR;
-
-	fs_info(sdp, "Trying to join cluster \"%s\", \"%s\"\n", proto, table);
-
-	error = gfs2_mount_lockproto(proto, table, sdp->sd_args.ar_hostdata,
-				     gfs2_glock_cb, sdp,
-				     GFS2_MIN_LVB_SIZE, flags,
-				     &sdp->sd_lockstruct, &sdp->sd_kobj);
-	if (error) {
-		fs_info(sdp, "can't mount proto=%s, table=%s, hostdata=%s\n",
-			proto, table, sdp->sd_args.ar_hostdata);
-		goto out;
-	}
-
-	if (gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lockspace) ||
-	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_ops) ||
-	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lvb_size >=
-				  GFS2_MIN_LVB_SIZE)) {
-		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
-		goto out;
-	}
-
-	if (sdp->sd_args.ar_spectator)
-		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.s", table);
-	else
-		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.%u", table,
-			 sdp->sd_lockstruct.ls_jid);
-
-	fs_info(sdp, "Joined cluster. Now mounting FS...\n");
-
-	if ((sdp->sd_lockstruct.ls_flags & LM_LSFLAG_LOCAL) &&
-	    !sdp->sd_args.ar_ignore_local_fs) {
-		sdp->sd_args.ar_localflocks = 1;
-		sdp->sd_args.ar_localcaching = 1;
-	}
-
-out:
-	return error;
-}
-
-void gfs2_lm_others_may_mount(struct gfs2_sbd *sdp)
-{
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_others_may_mount(
-					sdp->sd_lockstruct.ls_lockspace);
-}
-
-void gfs2_lm_unmount(struct gfs2_sbd *sdp)
-{
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
-}
-
-int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
-{
-	va_list args;
-
-	if (test_and_set_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return 0;
-
-	va_start(args, fmt);
-	vprintk(fmt, args);
-	va_end(args);
-
-	fs_err(sdp, "about to withdraw this file system\n");
-	BUG_ON(sdp->sd_args.ar_debug);
-
-	fs_err(sdp, "telling LM to withdraw\n");
-	gfs2_withdraw_lockproto(&sdp->sd_lockstruct);
-	fs_err(sdp, "withdrawn\n");
-	dump_stack();
-
-	return -1;
-}
-
-int gfs2_lm_get_lock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		     void **lockp)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_get_lock(
-				sdp->sd_lockstruct.ls_lockspace, name, lockp);
-	return error;
-}
-
-void gfs2_lm_put_lock(struct gfs2_sbd *sdp, void *lock)
-{
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_put_lock(lock);
-}
-
-unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
-			  unsigned int cur_state, unsigned int req_state,
-			  unsigned int flags)
-{
-	int ret = 0;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock, cur_state,
-							 req_state, flags);
-	return ret;
-}
-
-unsigned int gfs2_lm_unlock(struct gfs2_sbd *sdp, void *lock,
-			    unsigned int cur_state)
-{
-	int ret = 0;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret =  sdp->sd_lockstruct.ls_ops->lm_unlock(lock, cur_state);
-	return ret;
-}
-
-void gfs2_lm_cancel(struct gfs2_sbd *sdp, void *lock)
-{
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_cancel(lock);
-}
-
-int gfs2_lm_hold_lvb(struct gfs2_sbd *sdp, void *lock, char **lvbp)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_hold_lvb(lock, lvbp);
-	return error;
-}
-
-void gfs2_lm_unhold_lvb(struct gfs2_sbd *sdp, void *lock, char *lvb)
-{
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_unhold_lvb(lock, lvb);
-}
-
-int gfs2_lm_plock_get(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		      struct file *file, struct file_lock *fl)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_plock_get(
-				sdp->sd_lockstruct.ls_lockspace, name, file, fl);
-	return error;
-}
-
-int gfs2_lm_plock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		  struct file *file, int cmd, struct file_lock *fl)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_plock(
-				sdp->sd_lockstruct.ls_lockspace, name, file, cmd, fl);
-	return error;
-}
-
-int gfs2_lm_punlock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		    struct file *file, struct file_lock *fl)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_punlock(
-				sdp->sd_lockstruct.ls_lockspace, name, file, fl);
-	return error;
-}
-
-void gfs2_lm_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
-			   unsigned int message)
-{
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_recovery_done(
-			sdp->sd_lockstruct.ls_lockspace, jid, message);
-}
-
diff --git a/fs/gfs2/lm.h b/fs/gfs2/lm.h
deleted file mode 100644
index 21cdc30..0000000
--- a/fs/gfs2/lm.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __LM_DOT_H__
-#define __LM_DOT_H__
-
-struct gfs2_sbd;
-
-#define GFS2_MIN_LVB_SIZE 32
-
-int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent);
-void gfs2_lm_others_may_mount(struct gfs2_sbd *sdp);
-void gfs2_lm_unmount(struct gfs2_sbd *sdp);
-int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
-				__attribute__ ((format(printf, 2, 3)));
-int gfs2_lm_get_lock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		     void **lockp);
-void gfs2_lm_put_lock(struct gfs2_sbd *sdp, void *lock);
-unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
-			 unsigned int cur_state, unsigned int req_state,
-			 unsigned int flags);
-unsigned int gfs2_lm_unlock(struct gfs2_sbd *sdp, void *lock,
-			   unsigned int cur_state);
-void gfs2_lm_cancel(struct gfs2_sbd *sdp, void *lock);
-int gfs2_lm_hold_lvb(struct gfs2_sbd *sdp, void *lock, char **lvbp);
-void gfs2_lm_unhold_lvb(struct gfs2_sbd *sdp, void *lock, char *lvb);
-int gfs2_lm_plock_get(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		      struct file *file, struct file_lock *fl);
-int gfs2_lm_plock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		  struct file *file, int cmd, struct file_lock *fl);
-int gfs2_lm_punlock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		    struct file *file, struct file_lock *fl);
-void gfs2_lm_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
-			   unsigned int message);
-
-#endif /* __LM_DOT_H__ */
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index f4842f2..f97a8b8 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -30,7 +30,6 @@
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
-#include "lm.h"
 #include "log.h"
 #include "meta_io.h"
 #include "quota.h"
@@ -596,6 +595,36 @@ static int gfs2_setlease(struct file *file, long arg, struct file_lock **fl)
 	return generic_setlease(file, arg, fl);
 }
 
+static int gfs2_lm_plock_get(struct gfs2_sbd *sdp, struct lm_lockname *name,
+		      struct file *file, struct file_lock *fl)
+{
+	int error = -EIO;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		error = sdp->sd_lockstruct.ls_ops->lm_plock_get(
+				sdp->sd_lockstruct.ls_lockspace, name, file, fl);
+	return error;
+}
+
+static int gfs2_lm_plock(struct gfs2_sbd *sdp, struct lm_lockname *name,
+		  struct file *file, int cmd, struct file_lock *fl)
+{
+	int error = -EIO;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		error = sdp->sd_lockstruct.ls_ops->lm_plock(
+				sdp->sd_lockstruct.ls_lockspace, name, file, cmd, fl);
+	return error;
+}
+
+static int gfs2_lm_punlock(struct gfs2_sbd *sdp, struct lm_lockname *name,
+		    struct file *file, struct file_lock *fl)
+{
+	int error = -EIO;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		error = sdp->sd_lockstruct.ls_ops->lm_punlock(
+				sdp->sd_lockstruct.ls_lockspace, name, file, fl);
+	return error;
+}
+
 /**
  * gfs2_lock - acquire/release a posix lock on a file
  * @file: the file pointer
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 4bee6aa..5b6a345 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -26,7 +26,6 @@
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
-#include "lm.h"
 #include "mount.h"
 #include "ops_fstype.h"
 #include "ops_dentry.h"
@@ -363,6 +362,13 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
 	return rc;
 }
 
+static void gfs2_lm_others_may_mount(struct gfs2_sbd *sdp)
+{
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		sdp->sd_lockstruct.ls_ops->lm_others_may_mount(
+					sdp->sd_lockstruct.ls_lockspace);
+}
+
 static int init_journal(struct gfs2_sbd *sdp, int undo)
 {
 	struct gfs2_holder ji_gh;
@@ -705,6 +711,69 @@ fail:
 }
 
 /**
+ * gfs2_lm_mount - mount a locking protocol
+ * @sdp: the filesystem
+ * @args: mount arguements
+ * @silent: if 1, don't complain if the FS isn't a GFS2 fs
+ *
+ * Returns: errno
+ */
+
+static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
+{
+	char *proto = sdp->sd_proto_name;
+	char *table = sdp->sd_table_name;
+	int flags = 0;
+	int error;
+
+	if (sdp->sd_args.ar_spectator)
+		flags |= LM_MFLAG_SPECTATOR;
+
+	fs_info(sdp, "Trying to join cluster \"%s\", \"%s\"\n", proto, table);
+
+	error = gfs2_mount_lockproto(proto, table, sdp->sd_args.ar_hostdata,
+				     gfs2_glock_cb, sdp,
+				     GFS2_MIN_LVB_SIZE, flags,
+				     &sdp->sd_lockstruct, &sdp->sd_kobj);
+	if (error) {
+		fs_info(sdp, "can't mount proto=%s, table=%s, hostdata=%s\n",
+			proto, table, sdp->sd_args.ar_hostdata);
+		goto out;
+	}
+
+	if (gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lockspace) ||
+	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_ops) ||
+	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lvb_size >=
+				  GFS2_MIN_LVB_SIZE)) {
+		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
+		goto out;
+	}
+
+	if (sdp->sd_args.ar_spectator)
+		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.s", table);
+	else
+		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.%u", table,
+			 sdp->sd_lockstruct.ls_jid);
+
+	fs_info(sdp, "Joined cluster. Now mounting FS...\n");
+
+	if ((sdp->sd_lockstruct.ls_flags & LM_LSFLAG_LOCAL) &&
+	    !sdp->sd_args.ar_ignore_local_fs) {
+		sdp->sd_args.ar_localflocks = 1;
+		sdp->sd_args.ar_localcaching = 1;
+	}
+
+out:
+	return error;
+}
+
+void gfs2_lm_unmount(struct gfs2_sbd *sdp)
+{
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
+}
+
+/**
  * fill_super - Read in superblock
  * @sb: The VFS superblock
  * @data: Mount options
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 5e52421..2278c68 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -25,7 +25,6 @@
 #include "incore.h"
 #include "glock.h"
 #include "inode.h"
-#include "lm.h"
 #include "log.h"
 #include "mount.h"
 #include "ops_super.h"
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 6fb07d6..b17d3b8 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -20,7 +20,6 @@
 #include "bmap.h"
 #include "glock.h"
 #include "glops.h"
-#include "lm.h"
 #include "lops.h"
 #include "meta_io.h"
 #include "recovery.h"
@@ -425,6 +424,16 @@ static int clean_journal(struct gfs2_jdesc *jd, struct gfs2_log_header_host *hea
 	return error;
 }
 
+
+static void gfs2_lm_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
+				  unsigned int message)
+{
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		sdp->sd_lockstruct.ls_ops->lm_recovery_done(
+			sdp->sd_lockstruct.ls_lockspace, jid, message);
+}
+
+
 /**
  * gfs2_recover_journal - recovery a given journal
  * @jd: the struct gfs2_jdesc describing the journal
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index 60a870e..44361ec 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -17,6 +17,7 @@ void gfs2_tune_init(struct gfs2_tune *gt);
 int gfs2_check_sb(struct gfs2_sbd *sdp, struct gfs2_sb_host *sb, int silent);
 int gfs2_read_sb(struct gfs2_sbd *sdp, struct gfs2_glock *gl, int silent);
 int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector);
+void gfs2_lm_unmount(struct gfs2_sbd *sdp);
 
 static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 {
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index eaa3b7b..cc35ec8 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -20,7 +20,6 @@
 
 #include "gfs2.h"
 #include "incore.h"
-#include "lm.h"
 #include "sys.h"
 #include "super.h"
 #include "glock.h"
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index fe9c28e..d31e355 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -19,7 +19,6 @@
 #include "gfs2.h"
 #include "incore.h"
 #include "glock.h"
-#include "lm.h"
 #include "util.h"
 
 struct kmem_cache *gfs2_glock_cachep __read_mostly;
@@ -33,6 +32,28 @@ void gfs2_assert_i(struct gfs2_sbd *sdp)
 	       sdp->sd_fsname);
 }
 
+int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
+{
+	va_list args;
+
+	if (test_and_set_bit(SDF_SHUTDOWN, &sdp->sd_flags))
+		return 0;
+
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+
+	fs_err(sdp, "about to withdraw this file system\n");
+	BUG_ON(sdp->sd_args.ar_debug);
+
+	fs_err(sdp, "telling LM to withdraw\n");
+	gfs2_withdraw_lockproto(&sdp->sd_lockstruct);
+	fs_err(sdp, "withdrawn\n");
+	dump_stack();
+
+	return -1;
+}
+
 /**
  * gfs2_assert_withdraw_i - Cause the machine to withdraw if @assertion is false
  * Returns: -1 if this call withdrew the machine,
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index ac0c567..509c5d6 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -164,6 +164,7 @@ gfs2_tune_get_i(&(sdp)->sd_tune, &(sdp)->sd_tune.field)
 
 void gfs2_icbit_munge(struct gfs2_sbd *sdp, unsigned char **bitmap,
 		      unsigned int bit, int new_value);
+int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...);
 
 #endif /* __UTIL_DOT_H__ */
 
-- 
1.5.1.2

