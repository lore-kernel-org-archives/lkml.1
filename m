Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbXLSEEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbXLSEEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 23:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXLSEEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 23:04:30 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34088 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbXLSEE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 23:04:29 -0500
Date: Tue, 18 Dec 2007 23:04:18 -0500
Message-Id: <200712190404.lBJ44IOf003182@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] XFS: don't expose sysv device encoding in inode->i_rdev
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did some testing on special-file copyup in unionfs, whereby unionfs calls
vfs_mknod on a lower f/s to create (copyup) a device.  The copyup
functionality worked fine when unionfs was stacked on top of all file
systems other than xfs.  I found out that when I create a device with
<maj,min> on xfs, then I stat(1) through the union, I get the sysv encoding
of the <maj,min>.

The problem appears to be in the xfs_vn_mknod() function in xfs_iops.c: the
code changes the rdev value using rdev = sysv_encode_dev(rdev); so it can
fall through that case of the first switch statement in that function, and
onto xfs_create().  Later in that function, however, it copies the
sysv_encode'd rdev value into the inode that is going to be d_instantiate'd,
thus exposing the sysv encoding to the VFS -- and to any stackable file
system that may be using fsstack_copy_attr_all() to copy lower inode
attributes to an upper inode.

The following small patch seems to fix the problem.  Bug and fix were
verified on v2.6.24-rc5-245-gc63a119.  Someone with better understanding of
XFS's internals should verify this patch.


Andrew, a related question: kdev_t.h defines several device <maj,min>
encoding formats, which different file systems seems to use.  Assuming that
a file system can choose whatever internal encoding it wants, is there a
uniform standard for what the VFS-level inode->i_rdev format should be?
(vfs.txt is silent about the issue.)


Thanks,
Erez.


XFS: don't expose internal sysv encoding to VFS inode->i_rdev

Signed:-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 37e1167..daaa060 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -333,7 +333,8 @@ xfs_vn_mknod(
 		ip = vn_to_inode(vp);
 
 		if (S_ISCHR(mode) || S_ISBLK(mode))
-			ip->i_rdev = rdev;
+			ip->i_rdev = MKDEV(sysv_major(rdev) & 0x1ff,
+					   sysv_minor(rdev));
 		else if (S_ISDIR(mode))
 			xfs_validate_fields(ip);
 		d_instantiate(dentry, ip);
