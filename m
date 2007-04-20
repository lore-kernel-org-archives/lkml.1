Return-Path: <linux-kernel-owner+w=401wt.eu-S2992824AbXDTK27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992824AbXDTK27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992786AbXDTK2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:28:14 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40609 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423046AbXDTK14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:27:56 -0400
Message-Id: <20070420102656.364689151@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 20 Apr 2007 12:25:40 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 8/8] allow unprivileged fuse mounts
Content-Disposition: inline; filename=fuse_safe.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use FS_SAFE for "fuse" fs type, but not for "fuseblk".

FUSE was designed from the beginning to be safe for unprivileged
users.  This has also been verified in practice over many years.  In
addition unprivileged mounts require the parent mount to be owned by
the user, which is more strict than the current userspace policy.

This will enable future installations to remove the suid-root
fusermount utility.

Don't require the "user_id=" and "group_id=" options for unprivileged
mounts, but if they are present, verify them for sanity.

Disallow the "allow_other" option for unprivileged mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-04-20 11:55:01.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-04-20 11:55:14.000000000 +0200
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
