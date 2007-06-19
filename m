Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbXFSN22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbXFSN22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbXFSN1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:27:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:59799 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757854AbXFSN13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:27:29 -0400
Message-Id: <20070619132726.360453113@suse.cz>
References: <20070619132549.266927601@suse.cz>
User-Agent: quilt/0.46-42
Date: Tue, 19 Jun 2007 15:25:50 +0200
From: mmarek@suse.cz
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Content-Disposition: inline; filename=xfs-compat-ioctl-fsgeometry.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 struct xfs_fsop_geom_v1 has no padding after the last member, so
the size is different.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/xfs/linux-2.6/xfs_ioctl32.c |   42 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -75,6 +75,42 @@ xfs_ioctl32_flock(
 	return (unsigned long)p;
 }
 
+typedef struct compat_xfs_fsop_geom_v1 {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		rtextsize;	/* realtime extent size		*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		sectsize;	/* (data) sector size, bytes	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		imaxpct;	/* max allowed inode space(%)	*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
+	__u64		rtextents;	/* rt extents in realtime subvol*/
+	__u64		logstart;	/* starting fsblock of the log	*/
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		logsectsize;	/* log sector size, bytes	*/
+	__u32		rtsectsize;	/* realtime sector size, bytes	*/
+	__u32		dirblocksize;	/* directory block size, bytes	*/
+} __attribute__((packed)) compat_xfs_fsop_geom_v1_t;
+
+#define XFS_IOC_FSGEOMETRY_V1_32  \
+	_IOR ('X', 100, struct compat_xfs_fsop_geom_v1)
+
+STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
+{
+	compat_xfs_fsop_geom_v1_t __user *p32 = (void __user *)arg;
+	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(p, p32, sizeof(*p32)))
+		return -EFAULT;
+	return (unsigned long)p;
+}
+
 #else
 
 typedef struct xfs_fsop_bulkreq32 {
@@ -118,7 +154,6 @@ xfs_compat_ioctl(
 
 	switch (cmd) {
 	case XFS_IOC_DIOINFO:
-	case XFS_IOC_FSGEOMETRY_V1:
 	case XFS_IOC_FSGEOMETRY:
 	case XFS_IOC_GETVERSION:
 	case XFS_IOC_GETXFLAGS:
@@ -166,6 +201,10 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_flock(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		break;
+	case XFS_IOC_FSGEOMETRY_V1_32:
+		arg = xfs_ioctl32_geom_v1(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);
+		break;
 
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
@@ -176,6 +215,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FREESP64:
 	case XFS_IOC_RESVSP64:
 	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_FSGEOMETRY_V1:
 		break;
 
 	/* xfs_bstat_t still has wrong u32 vs u64 alignment */

-- 
