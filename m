Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXGJT74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXGJT74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXGJT7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:59:48 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:50726 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXGJT7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:59:47 -0400
Subject: [PATCH] 2.6.22-rc6-mm1:  hugetlbfs handle empty options string
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Randy.dunlap@oracle.com, wli@holomorphy.org,
       Eric Whitney <eric.whitney@hp.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 10 Jul 2007 15:59:00 -0400
Message-Id: <1184097540.5727.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] 2.6.22-rc6-mm1 - hugetlbfs handle empty options string

I was seeing a null pointer deref in fs/super.c:vfs_kern_mount().
Some file system get_sb() handler was returning NULL mnt_sb with
a non-negative return value.  I also noticed a "hugetlbfs: Bad
mount option:" message in the log.

Turns out that hugetlbfs_parse_options() was not checking for an
empty option string after call to strsep().  On failure,
hugetlbfs_parse_options() returns 1.  hugetlbfs_fill_super() just
passed this return code back up the call stack where
vfs_kern_mount() missed the error and proceeded with a NULL mnt_sb.

Apparently introduced by patch:
	hugetlbfs-use-lib-parser-fix-docs.patch

The problem was exposed by this line in my fstab:

none        /huge       hugetlbfs   defaults    0 0

It can also be demonstrated by invoking mount of hugetlbfs
directly with no options or a bogus option.

This patch:

1) adds the check for empty option to hugetlbfs_parse_options(),
2) enhances the error message to bracket any unrecognized
   option with quotes ,
3) modifies hugetlbfs_parse_options() to return -EINVAL on any
   unrecognized option,
4) adds a BUG_ON() to vfs_kern_mount() to catch any get_sb()
   handler that returns a NULL mnt->mnt_sb with a return value
   >= 0.

Signed-off-by:  Lee Schermerhorn  <lee.schermerhorn@hp.com>

 fs/hugetlbfs/inode.c |    8 +++++---
 fs/super.c           |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

Index: Linux/fs/hugetlbfs/inode.c
===================================================================
--- Linux.orig/fs/hugetlbfs/inode.c	2007-07-10 14:49:31.000000000 -0400
+++ Linux/fs/hugetlbfs/inode.c	2007-07-10 15:10:28.000000000 -0400
@@ -625,6 +625,8 @@ hugetlbfs_parse_options(char *options, s
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+		if (!*p)
+			continue;
 
 		token = match_token(p, tokens, args);
 		switch (token) {
@@ -669,8 +671,9 @@ hugetlbfs_parse_options(char *options, s
 			break;
 
 		default:
-			printk(KERN_ERR "hugetlbfs: Bad mount option: %s\n", p);
- 			return 1;
+			printk(KERN_ERR "hugetlbfs: Bad mount option: \"%s\"\n",
+				 p);
+			return -EINVAL;
 			break;
 		}
 	}
@@ -697,7 +700,6 @@ hugetlbfs_fill_super(struct super_block 
 	config.gid = current->fsgid;
 	config.mode = 0755;
 	ret = hugetlbfs_parse_options(data, &config);
-
 	if (ret)
 		return ret;
 
Index: Linux/fs/super.c
===================================================================
--- Linux.orig/fs/super.c	2007-07-10 14:49:32.000000000 -0400
+++ Linux/fs/super.c	2007-07-10 15:00:46.000000000 -0400
@@ -880,6 +880,7 @@ vfs_kern_mount(struct file_system_type *
 	error = type->get_sb(type, flags, name, data, mnt);
 	if (error < 0)
 		goto out_free_secdata;
+	BUG_ON(!mnt->mnt_sb);
 
  	error = security_sb_kern_mount(mnt->mnt_sb, secdata);
  	if (error)


