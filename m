Return-Path: <linux-kernel-owner+w=401wt.eu-S934622AbZJOGFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622AbZJOGFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbZJOGFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:05:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934208AbZJOGE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:59 -0400
Message-Id: <20091015050047.864813567@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:27 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/6] fs: invalidate sb->s_bdev on remount,ro
References: <20091015044026.319860788@suse.de>
Content-Disposition: inline; filename=fs-remount-coherency.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a problem reported by "Jorge Boncompte [DTI2]" <jorge@dti2.net>
who is seeing corruption trying to snapshot a minix filesystem image.
Some filesystems modify their metadata via a path other than the bdev
buffer cache (eg. they may use a private linear mapping for their
metadata, or implement directories in pagecache, etc). Also, file
data modifications usually go to the bdev via their own mappings.

These updates are not coherent with buffercache IO (eg. via /dev/bdev)
and never have been. However there could be a reasonable expectation
that after a mount -oremount,ro operation then the buffercache should
subsequently be coherent with previous filesystem modifications.

So invalidate the bdev mappings on a remount,ro operation to provide
a coherency point.

The problem was exposed when we switched the old rd to brd because old rd
didn't really function like a normal block device and updates to rd via
mappings other than the buffercache would still end up going into its
buffercache. But the same problem has always affected other "normal" block
devices, including loop.

Reported-by: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Tested-by: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 fs/super.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -568,7 +568,7 @@ out:
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
 	int retval;
-	int remount_rw;
+	int remount_rw, remount_ro;
 
 	if (sb->s_frozen != SB_UNFROZEN)
 		return -EBUSY;
@@ -583,9 +583,12 @@ int do_remount_sb(struct super_block *sb
 	shrink_dcache_sb(sb);
 	sync_filesystem(sb);
 
+	remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
+	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
+
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
-	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
+	if (remount_ro) {
 		if (force)
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
@@ -594,7 +597,6 @@ int do_remount_sb(struct super_block *sb
 		if (retval < 0 && retval != -ENOSYS)
 			return -EBUSY;
 	}
-	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
@@ -604,6 +606,14 @@ int do_remount_sb(struct super_block *sb
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
 		vfs_dq_quota_on_remount(sb);
+	 /* Some filesystems modify their metadata via some other path
+	    than the bdev buffer cache (eg. use a private mapping, or
+	    directories in pagecache, etc). Also file data modifications
+	    go via their own mappings. So If we try to mount readonly
+	    then copy the filesystem from bdev, we could get stale data,
+	    so invalidate it to give a best effort at coherency. */
+	if (remount_ro && sb->s_bdev)
+		invalidate_bdev(sb->s_bdev);
 	return 0;
 }
 


