Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYAXTfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYAXTfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbYAXTep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:45 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46518 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYAXTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:24 -0500
Message-Id: <20080124193420.453190590@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:45 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 04/26] mount options: fix affs
Content-Disposition: inline; filename=affs_opts.patch
Cc: Roman Zippel <zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to affs.

Use generic_show_options() and save the complete option string in
affs_fill_super() and affs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/affs/super.c
===================================================================
--- linux.orig/fs/affs/super.c	2008-01-24 18:57:19.000000000 +0100
+++ linux/fs/affs/super.c	2008-01-24 19:01:21.000000000 +0100
@@ -122,6 +122,7 @@ static const struct super_operations aff
 	.write_super	= affs_write_super,
 	.statfs		= affs_statfs,
 	.remount_fs	= affs_remount,
+	.show_options	= generic_show_options,
 };
 
 enum {
@@ -272,6 +273,8 @@ static int affs_fill_super(struct super_
 	u8			 sig[4];
 	int			 ret = -EINVAL;
 
+	save_mount_options(sb, data);
+
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
 
 	sb->s_magic             = AFFS_SUPER_MAGIC;
@@ -487,14 +490,21 @@ affs_remount(struct super_block *sb, int
 	int			 root_block;
 	unsigned long		 mount_flags;
 	int			 res = 0;
+	char			*new_opts = kstrdup(data, GFP_KERNEL);
 
 	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
 
 	*flags |= MS_NODIRATIME;
 
-	if (!parse_options(data,&uid,&gid,&mode,&reserved,&root_block,
-	    &blocksize,&sbi->s_prefix,sbi->s_volume,&mount_flags))
+	if (!parse_options(data, &uid, &gid, &mode, &reserved, &root_block,
+			   &blocksize, &sbi->s_prefix, sbi->s_volume,
+			   &mount_flags)) {
+		kfree(new_opts);
 		return -EINVAL;
+	}
+	kfree(sb->s_options);
+	sb->s_options = new_opts;
+
 	sbi->s_flags = mount_flags;
 	sbi->s_mode  = mode;
 	sbi->s_uid   = uid;

--
