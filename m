Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752709AbYLQM3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYLQM3o (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYLQM3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53726 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYLQM3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:06 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/24] GFS2: Rationalise header files
Date: Wed, 17 Dec 2008 11:30:01 +0000
Message-Id: <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Move the contents of some headers which contained very
little into more sensible places, and remove the original
header files. This should make it easier to find things.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7cee695..9f1e415 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -32,7 +32,6 @@
 #include "log.h"
 #include "meta_io.h"
 #include "ops_address.h"
-#include "ops_inode.h"
 #include "quota.h"
 #include "rgrp.h"
 #include "trans.h"
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 2d43f69..c357790 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -10,6 +10,7 @@
 #ifndef __INODE_DOT_H__
 #define __INODE_DOT_H__
 
+#include <linux/fs.h>
 #include "util.h"
 
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
@@ -97,5 +98,15 @@ struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
 void gfs2_dinode_print(const struct gfs2_inode *ip);
 
+extern const struct inode_operations gfs2_file_iops;
+extern const struct inode_operations gfs2_dir_iops;
+extern const struct inode_operations gfs2_symlink_iops;
+extern const struct file_operations gfs2_file_fops;
+extern const struct file_operations gfs2_dir_fops;
+extern const struct file_operations gfs2_file_fops_nolock;
+extern const struct file_operations gfs2_dir_fops_nolock;
+
+extern void gfs2_set_inode_flags(struct inode *inode);
+
 #endif /* __INODE_DOT_H__ */
 
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index bb2cc30..3eea03c 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -19,7 +19,7 @@
 
 #include "gfs2.h"
 #include "incore.h"
-#include "ops_fstype.h"
+#include "super.h"
 #include "sys.h"
 #include "util.h"
 #include "glock.h"
diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
index 4a5e676..c2ad363 100644
--- a/fs/gfs2/ops_dentry.c
+++ b/fs/gfs2/ops_dentry.c
@@ -19,7 +19,7 @@
 #include "incore.h"
 #include "dir.h"
 #include "glock.h"
-#include "ops_dentry.h"
+#include "super.h"
 #include "util.h"
 #include "inode.h"
 
diff --git a/fs/gfs2/ops_dentry.h b/fs/gfs2/ops_dentry.h
deleted file mode 100644
index 5caa3db..0000000
--- a/fs/gfs2/ops_dentry.h
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
-#ifndef __OPS_DENTRY_DOT_H__
-#define __OPS_DENTRY_DOT_H__
-
-#include <linux/dcache.h>
-
-extern struct dentry_operations gfs2_dops;
-
-#endif /* __OPS_DENTRY_DOT_H__ */
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index bbb8c36..3a9b9b4 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -22,8 +22,7 @@
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
-#include "ops_dentry.h"
-#include "ops_fstype.h"
+#include "super.h"
 #include "rgrp.h"
 #include "util.h"
 
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 3a747f8..fcfaaef 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -39,7 +39,6 @@
 #include "util.h"
 #include "eaops.h"
 #include "ops_address.h"
-#include "ops_inode.h"
 
 /**
  * gfs2_llseek - seek to a location in a file
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b117fcf..ca463a4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -27,9 +27,6 @@
 #include "glops.h"
 #include "inode.h"
 #include "mount.h"
-#include "ops_fstype.h"
-#include "ops_dentry.h"
-#include "ops_super.h"
 #include "recovery.h"
 #include "rgrp.h"
 #include "super.h"
diff --git a/fs/gfs2/ops_fstype.h b/fs/gfs2/ops_fstype.h
deleted file mode 100644
index da84905..0000000
--- a/fs/gfs2/ops_fstype.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __OPS_FSTYPE_DOT_H__
-#define __OPS_FSTYPE_DOT_H__
-
-#include <linux/fs.h>
-
-extern struct file_system_type gfs2_fs_type;
-extern struct file_system_type gfs2meta_fs_type;
-extern const struct export_operations gfs2_export_ops;
-
-#endif /* __OPS_FSTYPE_DOT_H__ */
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1e24b65..98440fe 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -32,12 +32,11 @@
 #include "glock.h"
 #include "inode.h"
 #include "meta_io.h"
-#include "ops_dentry.h"
-#include "ops_inode.h"
 #include "quota.h"
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
+#include "super.h"
 
 /**
  * gfs2_create - Create a file
diff --git a/fs/gfs2/ops_inode.h b/fs/gfs2/ops_inode.h
deleted file mode 100644
index 14b4b79..0000000
--- a/fs/gfs2/ops_inode.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __OPS_INODE_DOT_H__
-#define __OPS_INODE_DOT_H__
-
-#include <linux/fs.h>
-
-extern const struct inode_operations gfs2_file_iops;
-extern const struct inode_operations gfs2_dir_iops;
-extern const struct inode_operations gfs2_symlink_iops;
-extern const struct file_operations gfs2_file_fops;
-extern const struct file_operations gfs2_dir_fops;
-extern const struct file_operations gfs2_file_fops_nolock;
-extern const struct file_operations gfs2_dir_fops_nolock;
-
-extern void gfs2_set_inode_flags(struct inode *inode);
-
-#endif /* __OPS_INODE_DOT_H__ */
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index d5355d9..9c7678d 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -28,7 +28,6 @@
 #include "inode.h"
 #include "log.h"
 #include "mount.h"
-#include "ops_super.h"
 #include "quota.h"
 #include "recovery.h"
 #include "rgrp.h"
diff --git a/fs/gfs2/ops_super.h b/fs/gfs2/ops_super.h
deleted file mode 100644
index 442a274..0000000
--- a/fs/gfs2/ops_super.h
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
-#ifndef __OPS_SUPER_DOT_H__
-#define __OPS_SUPER_DOT_H__
-
-#include <linux/fs.h>
-
-extern const struct super_operations gfs2_super_ops;
-
-#endif /* __OPS_SUPER_DOT_H__ */
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index 50a4c9b..1848dad 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -10,6 +10,8 @@
 #ifndef __SUPER_DOT_H__
 #define __SUPER_DOT_H__
 
+#include <linux/fs.h>
+#include <linux/dcache.h>
 #include "incore.h"
 
 void gfs2_lm_unmount(struct gfs2_sbd *sdp);
@@ -46,5 +48,11 @@ int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc);
 int gfs2_freeze_fs(struct gfs2_sbd *sdp);
 void gfs2_unfreeze_fs(struct gfs2_sbd *sdp);
 
+extern struct file_system_type gfs2_fs_type;
+extern struct file_system_type gfs2meta_fs_type;
+extern const struct export_operations gfs2_export_ops;
+extern const struct super_operations gfs2_super_ops;
+extern struct dentry_operations gfs2_dops;
+
 #endif /* __SUPER_DOT_H__ */
 
-- 
1.6.0.3

