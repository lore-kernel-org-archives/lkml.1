Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYAXThx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYAXThx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbYAXTe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:59 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46538 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbYAXTed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:33 -0500
Message-Id: <20080124193429.480166399@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:51 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 10/26] mount options: fix devpts
Content-Disposition: inline; filename=devpts_opts.patch
Cc: "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to devpts.

Also add minor fix: when parsing the "mode" option, mask with
S_IALLUGO instead of ~S_IFMT, which could leave unsed bits in the
mask.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/devpts/inode.c
===================================================================
--- linux.orig/fs/devpts/inode.c	2008-01-22 23:43:12.000000000 +0100
+++ linux/fs/devpts/inode.c	2008-01-23 13:01:05.000000000 +0100
@@ -20,9 +20,12 @@
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
+#include <linux/seq_file.h>
 
 #define DEVPTS_SUPER_MAGIC 0x1cd1
 
+#define DEVPTS_DEFAULT_MODE 0600
+
 static struct vfsmount *devpts_mnt;
 static struct dentry *devpts_root;
 
@@ -32,7 +35,7 @@ static struct {
 	uid_t   uid;
 	gid_t   gid;
 	umode_t mode;
-} config = {.mode = 0600};
+} config = {.mode = DEVPTS_DEFAULT_MODE};
 
 enum {
 	Opt_uid, Opt_gid, Opt_mode,
@@ -54,7 +57,7 @@ static int devpts_remount(struct super_b
 	config.setgid  = 0;
 	config.uid     = 0;
 	config.gid     = 0;
-	config.mode    = 0600;
+	config.mode    = DEVPTS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -81,7 +84,7 @@ static int devpts_remount(struct super_b
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
 				return -EINVAL;
-			config.mode = option & ~S_IFMT;
+			config.mode = option & S_IALLUGO;
 			break;
 		default:
 			printk(KERN_ERR "devpts: called with bogus options\n");
@@ -92,9 +95,22 @@ static int devpts_remount(struct super_b
 	return 0;
 }
 
+static int devpts_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	if (config.setuid)
+		seq_printf(seq, ",uid=%u", config.uid);
+	if (config.setgid)
+		seq_printf(seq, ",gid=%u", config.gid);
+	if (config.mode != DEVPTS_DEFAULT_MODE)
+		seq_printf(seq, ",mode=%03o", config.mode);
+
+	return 0;
+}
+
 static const struct super_operations devpts_sops = {
 	.statfs		= simple_statfs,
 	.remount_fs	= devpts_remount,
+	.show_options	= devpts_show_options,
 };
 
 static int

--
