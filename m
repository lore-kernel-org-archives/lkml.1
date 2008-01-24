Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYAXTj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYAXTj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYAXTfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:19 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46564 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbYAXTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:44 -0500
Message-Id: <20080124193439.058832742@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:57 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 16/26] mount options: fix hpfs
Content-Disposition: inline; filename=hpfs_opts.patch
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to hpfs.

Use generic_show_options() and save the complete option string in
hpfs_fill_super() and hpfs_remount_fs().

Also add a small fix: hpfs_remount_fs() should return -EINVAL on
error, instead of 1, which is not an error value.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/hpfs/super.c
===================================================================
--- linux.orig/fs/hpfs/super.c	2008-01-17 19:00:14.000000000 +0100
+++ linux/fs/hpfs/super.c	2008-01-23 23:36:53.000000000 +0100
@@ -386,6 +386,7 @@ static int hpfs_remount_fs(struct super_
 	int lowercase, conv, eas, chk, errs, chkdsk, timeshift;
 	int o;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	char *new_opts = kstrdup(data, GFP_KERNEL);
 	
 	*flags |= MS_NOATIME;
 	
@@ -398,15 +399,15 @@ static int hpfs_remount_fs(struct super_
 	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase, &conv,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
 		printk("HPFS: bad mount options.\n");
-	    	return 1;
+		goto out_err;
 	}
 	if (o == 2) {
 		hpfs_help();
-		return 1;
+		goto out_err;
 	}
 	if (timeshift != sbi->sb_timeshift) {
 		printk("HPFS: timeshift can't be changed using remount.\n");
-		return 1;
+		goto out_err;
 	}
 
 	unmark_dirty(s);
@@ -419,7 +420,14 @@ static int hpfs_remount_fs(struct super_
 
 	if (!(*flags & MS_RDONLY)) mark_dirty(s);
 
+	kfree(s->s_options);
+	s->s_options = new_opts;
+
 	return 0;
+
+out_err:
+	kfree(new_opts);
+	return -EINVAL;
 }
 
 /* Super operations */
@@ -432,6 +440,7 @@ static const struct super_operations hpf
 	.put_super	= hpfs_put_super,
 	.statfs		= hpfs_statfs,
 	.remount_fs	= hpfs_remount_fs,
+	.show_options	= generic_show_options,
 };
 
 static int hpfs_fill_super(struct super_block *s, void *options, int silent)
@@ -454,6 +463,8 @@ static int hpfs_fill_super(struct super_
 
 	int o;
 
+	save_mount_options(s, options);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;

--
