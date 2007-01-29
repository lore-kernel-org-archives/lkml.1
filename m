Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbXA2TNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbXA2TNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXA2TNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:13:53 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:18926 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554AbXA2TNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:13:53 -0500
Date: Mon, 29 Jan 2007 22:19:50 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH 1/3] ufs2 write: mount as rw
Message-ID: <20070129191949.GA26489@rain>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These series of patches add UFS2 write-support.
UFS2 - is default file system for recent versions of FreeBSD.

The main differences from UFS1 from write support point of view
are:
1)Not all inodes are allocated during formatation of disk.
2)All meta-data(pointer to data blocks) are 64bit(in UFS1 they
are 32bit).

So patch series consist of
1)make possible mount UFS2 in read-write mode
2)code to write ufs2 inodes and code to initialize inodes chunks.
3)work with 64bit meta-data

I made simple testing like create/deleting/writing/reading/truncating,
also I ran fsx-linux and untar and build kernel on UFS1 and UFS2,
after that FreeBSD fsck do not find any errors in fs.

This patch makes possible to mount ufs2 "rw", and updates
UFS2 documentation: remove note about bug(it fixed by reallocate
blocks on the fly patch) and add me in the list of people who
want receive bug reports.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.20-rc5/fs/ufs/super.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ufs/super.c
+++ linux-2.6.20-rc5/fs/ufs/super.c
@@ -61,6 +61,8 @@
  * UFS2 (of FreeBSD 5.x) support added by
  * Niraj Kumar <niraj17@iitbombay.org>, Jan 2004
  *
+ * UFS2 write support added by
+ * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
 
@@ -674,10 +676,6 @@ static int ufs_fill_super(struct super_b
 		uspi->s_sbsize = super_block_size = 1536;
 		uspi->s_sbbase =  0;
 		flags |= UFS_TYPE_UFS2 | UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
-		if (!(sb->s_flags & MS_RDONLY)) {
-			printk(KERN_INFO "ufstype=ufs2 is supported read-only\n");
-			sb->s_flags |= MS_RDONLY;
- 		}
 		break;
 		
 	case UFS_MOUNT_UFSTYPE_SUN:
@@ -1153,7 +1151,8 @@ static int ufs_remount (struct super_blo
 #else
 		if (ufstype != UFS_MOUNT_UFSTYPE_SUN && 
 		    ufstype != UFS_MOUNT_UFSTYPE_44BSD &&
-		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86) {
+		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
+		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
 			return -EINVAL;
 		}
Index: linux-2.6.20-rc5/Documentation/filesystems/ufs.txt
===================================================================
--- linux-2.6.20-rc5.orig/Documentation/filesystems/ufs.txt
+++ linux-2.6.20-rc5/Documentation/filesystems/ufs.txt
@@ -21,7 +21,7 @@ ufstype=type_of_ufs
 		supported as read-write
 
 	ufs2    used in FreeBSD 5.x
-		supported as read-only
+		supported as read-write
 
 	5xbsd	synonym for ufs2
 
@@ -50,12 +50,11 @@ ufstype=type_of_ufs
 POSSIBLE PROBLEMS
 =================
 
-There is still bug in reallocation of fragment, in file fs/ufs/balloc.c, 
-line 364. But it seems working on current buffer cache configuration.
+See next section, if you have any.
 
 
 BUG REPORTS
 ===========
 
-Any ufs bug report you can send to daniel.pirkl@email.cz (do not send 
-partition tables bug reports.)
+Any ufs bug report you can send to daniel.pirkl@email.cz or
+to dushistov@mail.ru (do not send partition tables bug reports).
-- 
/Evgeniy

