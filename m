Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbXE3ObX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbXE3ObX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXE3Oaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:30:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:36511 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754190AbXE3Oao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:30:44 -0400
Message-Id: <20070530143043.216024061@suse.cz>
References: <20070530125954.706423971@suse.cz>
User-Agent: quilt/0.46-36
Date: Wed, 30 May 2007 14:59:55 +0200
From: Michal Marek <mmarek@suse.cz>
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
 fs/xfs/linux-2.6/xfs_ioctl32.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -75,6 +75,40 @@ xfs_ioctl32_flock(
 	return (unsigned long)p;
 }
 
+typedef struct xfs_fsop_geom_v132 {
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
+} __attribute__((packed)) xfs_fsop_geom_v132_t;
+#define XFS_IOC_FSGEOMETRY_V1_32     _IOR ('X', 100, struct xfs_fsop_geom_v132)
+
+STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
+{
+	xfs_fsop_geom_v132_t __user *p32 = (void __user *)arg;
+	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(p, p32, sizeof(*p32)))
+		return -EFAULT;
+	return (unsigned long)p;
+}
+
 #else
 
 typedef struct xfs_fsop_bulkreq32 {
@@ -118,7 +152,6 @@ xfs_compat_ioctl(
 
 	switch (cmd) {
 	case XFS_IOC_DIOINFO:
-	case XFS_IOC_FSGEOMETRY_V1:
 	case XFS_IOC_FSGEOMETRY:
 	case XFS_IOC_GETVERSION:
 	case XFS_IOC_GETXFLAGS:
@@ -166,6 +199,10 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_flock(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		break;
+	case XFS_IOC_FSGEOMETRY_V1_32:
+		arg = xfs_ioctl32_geom_v1(arg);
+		cmd = XFS_IOC_FSGEOMETRY_V1;
+		break;
 
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
@@ -176,6 +213,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FREESP64:
 	case XFS_IOC_RESVSP64:
 	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_FSGEOMETRY_V1:
 		break;
 
 	/* xfs_bstat_t still has wrong u32 vs u64 alignment */

-- 
