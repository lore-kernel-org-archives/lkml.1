Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXDPLJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXDPLJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXDPLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:06:32 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:60333 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXDPLG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:06:26 -0400
Message-Id: <20070416110444.880888315@szeredi.hu>
References: <20070416110308.739051445@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 16 Apr 2007 13:03:18 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 10/10] allow unprivileged fuse mounts
Content-Disposition: inline; filename=fuse_safe.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use FS_SAFE for "fuse" fs type, but not for "fuseblk".

FUSE was designed from the beginning to be safe for unprivileged
users.  This has also been verified in practice over many years.  In
addition unprivileged fuse mounts require the "usermnt" mount option
to be set on the parent mount, which is more strict than the current
userspace policy.

This will enable future installations to remove the suid-root
fusermount utility.

Don't require the "user_id=" and "group_id=" options for unprivileged
mounts, but if they are present, verify them for sanity.

Disallow the "allow_other" option for unprivileged mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-04-13 14:20:23.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-04-13 14:20:27.000000000 +0200
@@ -311,6 +311,19 @@ static int parse_fuse_opt(char *opt, str
 	d->max_read = ~0;
 	d->blksize = 512;
 
+	/*
+	 * For unprivileged mounts use current uid/gid.  Still allow
+	 * "user_id" and "group_id" options for compatibility, but
+	 * only if they match these values.
+	 */
+	if (!capable(CAP_SYS_ADMIN)) {
+		d->user_id = current->uid;
+		d->user_id_present = 1;
+		d->group_id = current->gid;
+		d->group_id_present = 1;
+
+	}
+
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
 		int value;
@@ -339,6 +352,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_USER_ID:
 			if (match_int(&args[0], &value))
 				return 0;
+			if (d->user_id_present && d->user_id != value)
+				return 0;
 			d->user_id = value;
 			d->user_id_present = 1;
 			break;
@@ -346,6 +361,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_GROUP_ID:
 			if (match_int(&args[0], &value))
 				return 0;
+			if (d->group_id_present && d->group_id != value)
+				return 0;
 			d->group_id = value;
 			d->group_id_present = 1;
 			break;
@@ -536,6 +553,10 @@ static int fuse_fill_super(struct super_
 	if (!parse_fuse_opt((char *) data, &d, is_bdev))
 		return -EINVAL;
 
+	/* This is a privileged option */
+	if ((d.flags & FUSE_ALLOW_OTHER) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (is_bdev) {
 #ifdef CONFIG_BLOCK
 		if (!sb_set_blocksize(sb, d.blksize))
@@ -639,6 +660,7 @@ static struct file_system_type fuse_fs_t
 	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
+	.fs_flags	= FS_SAFE,
 };
 
 #ifdef CONFIG_BLOCK

--
