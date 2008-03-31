Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYCaAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYCaAHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYCaAGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 20:06:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58311 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752858AbYCaAGt (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 20:06:49 -0400
Date: Mon, 31 Mar 2008 10:06:35 +1000
From: David Chinner <dgc@sgi.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: David Chinner <dgc@sgi.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] Implement generic freeze feature
Message-ID: <20080331000635.GJ108924158@sgi.com>
References: <20080328180522t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328180522t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 06:05:22PM +0900, Takashi Sato wrote:
> The ioctls for the generic freeze feature are below.
> o Freeze the filesystem
>   int ioctl(int fd, int FIFREEZE, arg)
>     fd: The file descriptor of the mountpoint
>     FIFREEZE: request code for the freeze
>     arg: Ignored
>     Return value: 0 if the operation succeeds. Otherwise, -1
> 
> o Unfreeze the filesystem
>   int ioctl(int fd, int FITHAW, arg)
>     fd: The file descriptor of the mountpoint
>     FITHAW: request code for unfreeze
>     arg: Ignored
>     Return value: 0 if the operation succeeds. Otherwise, -1

Patch below to remove the XFS specific ioctl interfaces for this
functionality.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |   15 ---------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |    2 --
 fs/xfs/xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-03-31 08:33:19.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c	2008-03-31 09:06:08.531294896 +1000
@@ -1228,21 +1228,6 @@ xfs_ioctl(
 		return -error;
 	}
 
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev, 0);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
 	case XFS_IOC_GOINGDOWN: {
 		__uint32_t in;
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-11-20 16:12:45.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-03-31 09:06:38.011484411 +1000
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2007-11-20 18:38:49.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2008-03-31 09:09:54.902040723 +1000
@@ -473,8 +473,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
-#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
-#define XFS_IOC_THAW		     _IOWR('X', 120, int)
+/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
+/*	XFS_IOC_THAW		  -- FITHAW     120	 */
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
