Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYAXTfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYAXTfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYAXTe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:29 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46515 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYAXTeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:22 -0500
Message-Id: <20080124193419.142002297@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:44 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 03/26] mount options: fix adfs
Content-Disposition: inline; filename=adfs_opts.patch
Cc: Russell King <rmk@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to adfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/adfs/super.c
===================================================================
--- linux.orig/fs/adfs/super.c	2008-01-24 13:48:43.000000000 +0100
+++ linux/fs/adfs/super.c	2008-01-24 15:55:26.000000000 +0100
@@ -20,6 +20,8 @@
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/bitops.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -30,6 +32,9 @@
 #include "dir_f.h"
 #include "dir_fplus.h"
 
+#define ADFS_DEFAULT_OWNER_MASK S_IRWXU
+#define ADFS_DEFAULT_OTHER_MASK (S_IRWXG | S_IRWXO)
+
 void __adfs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 {
 	char error_buf[128];
@@ -134,6 +139,22 @@ static void adfs_put_super(struct super_
 	sb->s_fs_info = NULL;
 }
 
+static int adfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
+{
+	struct adfs_sb_info *asb = ADFS_SB(mnt->mnt_sb);
+
+	if (asb->s_uid != 0)
+		seq_printf(seq, ",uid=%u", asb->s_uid);
+	if (asb->s_gid != 0)
+		seq_printf(seq, ",gid=%u", asb->s_gid);
+	if (asb->s_owner_mask != ADFS_DEFAULT_OWNER_MASK)
+		seq_printf(seq, ",ownmask=%o", asb->s_owner_mask);
+	if (asb->s_other_mask != ADFS_DEFAULT_OTHER_MASK)
+		seq_printf(seq, ",othmask=%o", asb->s_other_mask);
+
+	return 0;
+}
+
 enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_err};
 
 static match_table_t tokens = {
@@ -259,6 +280,7 @@ static const struct super_operations adf
 	.put_super	= adfs_put_super,
 	.statfs		= adfs_statfs,
 	.remount_fs	= adfs_remount,
+	.show_options	= adfs_show_options,
 };
 
 static struct adfs_discmap *adfs_read_map(struct super_block *sb, struct adfs_discrecord *dr)
@@ -344,8 +366,8 @@ static int adfs_fill_super(struct super_
 	/* set default options */
 	asb->s_uid = 0;
 	asb->s_gid = 0;
-	asb->s_owner_mask = S_IRWXU;
-	asb->s_other_mask = S_IRWXG | S_IRWXO;
+	asb->s_owner_mask = ADFS_DEFAULT_OWNER_MASK;
+	asb->s_other_mask = ADFS_DEFAULT_OTHER_MASK;
 
 	if (parse_options(sb, data))
 		goto error;

--
