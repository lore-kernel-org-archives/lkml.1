Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZCRN1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZCRN1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZCRN0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbZCRN0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:35 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/18] GFS2: Fix remount argument parsing
Date: Wed, 18 Mar 2009 12:23:36 +0000
Message-Id: <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The following patch fixes an issue relating to remount and argument
parsing. After this fix is applied, remount becomes atomic in that
it either succeeds changing the mount to the new state, or it fails
and leaves it in the old state. Previously it was possible for the
parsing of options to fail part way though and for the fs to be left
in a state where some of the new arguments had been applied, but some
had not.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 3cb0a44..3524ae8 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -17,7 +17,7 @@
 
 #include "gfs2.h"
 #include "incore.h"
-#include "mount.h"
+#include "super.h"
 #include "sys.h"
 #include "util.h"
 
@@ -77,101 +77,46 @@ static const match_table_t tokens = {
  * Return: errno
  */
 
-int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
+int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 {
-	struct gfs2_args *args = &sdp->sd_args;
-	char *data = data_arg;
-	char *options, *o, *v;
-	int error = 0;
-
-	if (!remount) {
-		/*  Set some defaults  */
-		args->ar_quota = GFS2_QUOTA_DEFAULT;
-		args->ar_data = GFS2_DATA_DEFAULT;
-	}
+	char *o;
+	int token;
+	substring_t tmp[MAX_OPT_ARGS];
 
 	/* Split the options into tokens with the "," character and
 	   process them */
 
-	for (options = data; (o = strsep(&options, ",")); ) {
-		int token;
-		substring_t tmp[MAX_OPT_ARGS];
-
-		if (!*o)
+	while (1) {
+		o = strsep(&options, ",");
+		if (o == NULL)
+			break;
+		if (*o == '\0')
 			continue;
 
 		token = match_token(o, tokens, tmp);
 		switch (token) {
 		case Opt_lockproto:
-			v = match_strdup(&tmp[0]);
-			if (!v) {
-				fs_info(sdp, "no memory for lockproto\n");
-				error = -ENOMEM;
-				goto out_error;
-			}
-
-			if (remount && strcmp(v, args->ar_lockproto)) {
-				kfree(v);
-				goto cant_remount;
-			}
-			
-			strncpy(args->ar_lockproto, v, GFS2_LOCKNAME_LEN);
-			args->ar_lockproto[GFS2_LOCKNAME_LEN - 1] = 0;
-			kfree(v);
+			match_strlcpy(args->ar_lockproto, &tmp[0],
+				      GFS2_LOCKNAME_LEN);
 			break;
 		case Opt_locktable:
-			v = match_strdup(&tmp[0]);
-			if (!v) {
-				fs_info(sdp, "no memory for locktable\n");
-				error = -ENOMEM;
-				goto out_error;
-			}
-
-			if (remount && strcmp(v, args->ar_locktable)) {
-				kfree(v);
-				goto cant_remount;
-			}
-
-			strncpy(args->ar_locktable, v, GFS2_LOCKNAME_LEN);
-			args->ar_locktable[GFS2_LOCKNAME_LEN - 1]  = 0;
-			kfree(v);
+			match_strlcpy(args->ar_locktable, &tmp[0],
+				      GFS2_LOCKNAME_LEN);
 			break;
 		case Opt_hostdata:
-			v = match_strdup(&tmp[0]);
-			if (!v) {
-				fs_info(sdp, "no memory for hostdata\n");
-				error = -ENOMEM;
-				goto out_error;
-			}
-
-			if (remount && strcmp(v, args->ar_hostdata)) {
-				kfree(v);
-				goto cant_remount;
-			}
-
-			strncpy(args->ar_hostdata, v, GFS2_LOCKNAME_LEN);
-			args->ar_hostdata[GFS2_LOCKNAME_LEN - 1] = 0;
-			kfree(v);
+			match_strlcpy(args->ar_hostdata, &tmp[0],
+				      GFS2_LOCKNAME_LEN);
 			break;
 		case Opt_spectator:
-			if (remount && !args->ar_spectator)
-				goto cant_remount;
 			args->ar_spectator = 1;
-			sdp->sd_vfs->s_flags |= MS_RDONLY;
 			break;
 		case Opt_ignore_local_fs:
-			if (remount && !args->ar_ignore_local_fs)
-				goto cant_remount;
 			args->ar_ignore_local_fs = 1;
 			break;
 		case Opt_localflocks:
-			if (remount && !args->ar_localflocks)
-				goto cant_remount;
 			args->ar_localflocks = 1;
 			break;
 		case Opt_localcaching:
-			if (remount && !args->ar_localcaching)
-				goto cant_remount;
 			args->ar_localcaching = 1;
 			break;
 		case Opt_debug:
@@ -181,17 +126,13 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 			args->ar_debug = 0;
 			break;
 		case Opt_upgrade:
-			if (remount && !args->ar_upgrade)
-				goto cant_remount;
 			args->ar_upgrade = 1;
 			break;
 		case Opt_acl:
 			args->ar_posix_acl = 1;
-			sdp->sd_vfs->s_flags |= MS_POSIXACL;
 			break;
 		case Opt_noacl:
 			args->ar_posix_acl = 0;
-			sdp->sd_vfs->s_flags &= ~MS_POSIXACL;
 			break;
 		case Opt_quota_off:
 			args->ar_quota = GFS2_QUOTA_OFF;
@@ -215,29 +156,15 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 			args->ar_data = GFS2_DATA_ORDERED;
 			break;
 		case Opt_meta:
-			if (remount && args->ar_meta != 1)
-				goto cant_remount;
 			args->ar_meta = 1;
 			break;
 		case Opt_err:
 		default:
-			fs_info(sdp, "unknown option: %s\n", o);
-			error = -EINVAL;
-			goto out_error;
+			fs_info(sdp, "invalid mount option: %s\n", o);
+			return -EINVAL;
 		}
 	}
 
-out_error:
-	if (error)
-		fs_info(sdp, "invalid mount option(s)\n");
-
-	if (data != data_arg)
-		kfree(data);
-
-	return error;
-
-cant_remount:
-	fs_info(sdp, "can't remount with option %s\n", o);
-	return -EINVAL;
+	return 0;
 }
 
diff --git a/fs/gfs2/mount.h b/fs/gfs2/mount.h
deleted file mode 100644
index 401288a..0000000
--- a/fs/gfs2/mount.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __MOUNT_DOT_H__
-#define __MOUNT_DOT_H__
-
-struct gfs2_sbd;
-
-int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount);
-
-#endif /* __MOUNT_DOT_H__ */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index f91eebd..3eb49ed 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -25,7 +25,6 @@
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
-#include "mount.h"
 #include "recovery.h"
 #include "rgrp.h"
 #include "super.h"
@@ -1116,12 +1115,20 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 	}
 
-	error = gfs2_mount_args(sdp, (char *)data, 0);
+	sdp->sd_args.ar_quota = GFS2_QUOTA_DEFAULT;
+	sdp->sd_args.ar_data = GFS2_DATA_DEFAULT;
+
+	error = gfs2_mount_args(sdp, &sdp->sd_args, data);
 	if (error) {
 		printk(KERN_WARNING "GFS2: can't parse mount arguments\n");
 		goto fail;
 	}
 
+	if (sdp->sd_args.ar_spectator)
+                sb->s_flags |= MS_RDONLY;
+	if (sdp->sd_args.ar_posix_acl)
+		sb->s_flags |= MS_POSIXACL;
+
 	sb->s_magic = GFS2_MAGIC;
 	sb->s_op = &gfs2_super_ops;
 	sb->s_export_op = &gfs2_export_ops;
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 320323d..f0699ac 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -27,7 +27,6 @@
 #include "glock.h"
 #include "inode.h"
 #include "log.h"
-#include "mount.h"
 #include "quota.h"
 #include "recovery.h"
 #include "rgrp.h"
@@ -40,6 +39,8 @@
 #include "bmap.h"
 #include "meta_io.h"
 
+#define args_neq(a1, a2, x) ((a1)->ar_##x != (a2)->ar_##x)
+
 /**
  * gfs2_write_inode - Make sure the inode is stable on the disk
  * @inode: The inode
@@ -435,25 +436,45 @@ static int gfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
+	struct gfs2_args args = sdp->sd_args; /* Default to current settings */
 	int error;
 
-	error = gfs2_mount_args(sdp, data, 1);
+	error = gfs2_mount_args(sdp, &args, data);
 	if (error)
 		return error;
 
+	/* Not allowed to change locking details */
+	if (strcmp(args.ar_lockproto, sdp->sd_args.ar_lockproto) ||
+	    strcmp(args.ar_locktable, sdp->sd_args.ar_locktable) ||
+	    strcmp(args.ar_hostdata, sdp->sd_args.ar_hostdata))
+		return -EINVAL;
+
+	/* Some flags must not be changed */
+	if (args_neq(&args, &sdp->sd_args, spectator) ||
+	    args_neq(&args, &sdp->sd_args, ignore_local_fs) ||
+	    args_neq(&args, &sdp->sd_args, localflocks) ||
+	    args_neq(&args, &sdp->sd_args, localcaching) ||
+	    args_neq(&args, &sdp->sd_args, meta))
+		return -EINVAL;
+
 	if (sdp->sd_args.ar_spectator)
 		*flags |= MS_RDONLY;
-	else {
-		if (*flags & MS_RDONLY) {
-			if (!(sb->s_flags & MS_RDONLY))
-				error = gfs2_make_fs_ro(sdp);
-		} else if (!(*flags & MS_RDONLY) &&
-			   (sb->s_flags & MS_RDONLY)) {
+
+	if ((sb->s_flags ^ *flags) & MS_RDONLY) {
+		if (*flags & MS_RDONLY)
+			error = gfs2_make_fs_ro(sdp);
+		else
 			error = gfs2_make_fs_rw(sdp);
-		}
+		if (error)
+			return error;
 	}
 
-	return error;
+	sdp->sd_args = args;
+	if (sdp->sd_args.ar_posix_acl)
+		sb->s_flags |= MS_POSIXACL;
+	else
+		sb->s_flags &= ~MS_POSIXACL;
+	return 0;
 }
 
 /**
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index f6b8b00..91abdbe 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -14,7 +14,7 @@
 #include <linux/dcache.h>
 #include "incore.h"
 
-void gfs2_lm_unmount(struct gfs2_sbd *sdp);
+extern void gfs2_lm_unmount(struct gfs2_sbd *sdp);
 
 static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 {
@@ -27,21 +27,23 @@ static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 
 void gfs2_jindex_free(struct gfs2_sbd *sdp);
 
-struct gfs2_jdesc *gfs2_jdesc_find(struct gfs2_sbd *sdp, unsigned int jid);
-int gfs2_jdesc_check(struct gfs2_jdesc *jd);
+extern int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *data);
 
-int gfs2_lookup_in_master_dir(struct gfs2_sbd *sdp, char *filename,
-			      struct gfs2_inode **ipp);
+extern struct gfs2_jdesc *gfs2_jdesc_find(struct gfs2_sbd *sdp, unsigned int jid);
+extern int gfs2_jdesc_check(struct gfs2_jdesc *jd);
 
-int gfs2_make_fs_rw(struct gfs2_sbd *sdp);
+extern int gfs2_lookup_in_master_dir(struct gfs2_sbd *sdp, char *filename,
+				     struct gfs2_inode **ipp);
 
-int gfs2_statfs_init(struct gfs2_sbd *sdp);
-void gfs2_statfs_change(struct gfs2_sbd *sdp,
-			s64 total, s64 free, s64 dinodes);
-int gfs2_statfs_sync(struct gfs2_sbd *sdp);
+extern int gfs2_make_fs_rw(struct gfs2_sbd *sdp);
 
-int gfs2_freeze_fs(struct gfs2_sbd *sdp);
-void gfs2_unfreeze_fs(struct gfs2_sbd *sdp);
+extern int gfs2_statfs_init(struct gfs2_sbd *sdp);
+extern void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
+			       s64 dinodes);
+extern int gfs2_statfs_sync(struct gfs2_sbd *sdp);
+
+extern int gfs2_freeze_fs(struct gfs2_sbd *sdp);
+extern void gfs2_unfreeze_fs(struct gfs2_sbd *sdp);
 
 extern struct file_system_type gfs2_fs_type;
 extern struct file_system_type gfs2meta_fs_type;
-- 
1.6.0.3

