Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYAXTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYAXTm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYAXTfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46601 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbYAXTfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:35:05 -0500
Message-Id: <20080124193457.628524720@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:07 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 26/26] mount options: fix usbfs
Content-Disposition: inline; filename=usbfs_opts.patch
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to usbfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/drivers/usb/core/inode.c
===================================================================
--- linux.orig/drivers/usb/core/inode.c	2008-01-24 13:48:37.000000000 +0100
+++ linux/drivers/usb/core/inode.c	2008-01-24 16:00:03.000000000 +0100
@@ -38,10 +38,15 @@
 #include <linux/usbdevice_fs.h>
 #include <linux/parser.h>
 #include <linux/notifier.h>
+#include <linux/seq_file.h>
 #include <asm/byteorder.h>
 #include "usb.h"
 #include "hcd.h"
 
+#define USBFS_DEFAULT_DEVMODE (S_IWUSR | S_IRUGO)
+#define USBFS_DEFAULT_BUSMODE (S_IXUGO | S_IRUGO)
+#define USBFS_DEFAULT_LISTMODE S_IRUGO
+
 static struct super_operations usbfs_ops;
 static const struct file_operations default_file_operations;
 static struct vfsmount *usbfs_mount;
@@ -57,9 +62,33 @@ static uid_t listuid;	/* = 0 */
 static gid_t devgid;	/* = 0 */
 static gid_t busgid;	/* = 0 */
 static gid_t listgid;	/* = 0 */
-static umode_t devmode = S_IWUSR | S_IRUGO;
-static umode_t busmode = S_IXUGO | S_IRUGO;
-static umode_t listmode = S_IRUGO;
+static umode_t devmode = USBFS_DEFAULT_DEVMODE;
+static umode_t busmode = USBFS_DEFAULT_BUSMODE;
+static umode_t listmode = USBFS_DEFAULT_LISTMODE;
+
+static int usbfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
+{
+	if (devuid != 0)
+		seq_printf(seq, ",devuid=%u", devuid);
+	if (devgid != 0)
+		seq_printf(seq, ",devgid=%u", devgid);
+	if (devmode != USBFS_DEFAULT_DEVMODE)
+		seq_printf(seq, ",devmode=%o", devmode);
+	if (busuid != 0)
+		seq_printf(seq, ",busuid=%u", busuid);
+	if (busgid != 0)
+		seq_printf(seq, ",busgid=%u", busgid);
+	if (busmode != USBFS_DEFAULT_BUSMODE)
+		seq_printf(seq, ",busmode=%o", busmode);
+	if (listuid != 0)
+		seq_printf(seq, ",listuid=%u", listuid);
+	if (listgid != 0)
+		seq_printf(seq, ",listgid=%u", listgid);
+	if (listmode != USBFS_DEFAULT_LISTMODE)
+		seq_printf(seq, ",listmode=%o", listmode);
+
+	return 0;
+}
 
 enum {
 	Opt_devuid, Opt_devgid, Opt_devmode,
@@ -93,9 +122,9 @@ static int parse_options(struct super_bl
 	devgid = 0;
 	busgid = 0;
 	listgid = 0;
-	devmode = S_IWUSR | S_IRUGO;
-	busmode = S_IXUGO | S_IRUGO;
-	listmode = S_IRUGO;
+	devmode = USBFS_DEFAULT_DEVMODE;
+	busmode = USBFS_DEFAULT_BUSMODE;
+	listmode = USBFS_DEFAULT_LISTMODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -418,6 +447,7 @@ static struct super_operations usbfs_ops
 	.statfs =	simple_statfs,
 	.drop_inode =	generic_delete_inode,
 	.remount_fs =	remount,
+	.show_options = usbfs_show_options,
 };
 
 static int usbfs_fill_super(struct super_block *sb, void *data, int silent)

--
