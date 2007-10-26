Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbXJZXm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbXJZXm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXJZXjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:39:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764223AbXJZXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:date:from:to:cc:subject:content-disposition;
	b=ubaMHTI2XTiIik9vh4V3NYTnMJTZyZYe3MAczlvHl2FaucPv+w5BLx7OKsT6CcrRy
	bVuaz/jvam2+ZALKra7OQ==
Message-Id: <20071026233848.939953744@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:37 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: [patch 5/6][RFC] Introduce FIBMAP64
Content-Disposition: inline; filename=add_fibmap64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce FIBMAP64.  This is the same as FIBMAP, but takes a u64.

This new routine requires filesystems to implement bmap64 if they want to support > 2^31 blocks in a logical file.  We do this to give time for filesystems to be properly audited.

Signed-off-by: Mike Waychison <mikew@google.com>

 fs/compat_ioctl.c  |    2 ++
 fs/ioctl.c         |   34 +++++++++++++++++++++++++++++++++-
 include/linux/fs.h |    7 +++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:28:28.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-26 16:16:28.000000000 -0700
@@ -44,11 +44,24 @@ static int do_fibmap(struct address_spac
 		     sector_t *phys_block)
 {
 	struct inode *inode = mapping->host;
+	sector_t (*bmap)(struct address_space *, sector_t);
 
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	if (!mapping->a_ops->bmap)
+
+	if (mapping->a_ops->bmap64) {
+		/* Filesystem has bmap path audited for 64bit. */
+		bmap = mapping->a_ops->bmap64;
+	} else if (mapping->a_ops->bmap) {
+		bmap = mapping->a_ops->bmap;
+		/* Need to verify that the input looks sane when sector_t is
+		 * 64bit and the filesystem has only been audited for 32bit. */
+		if ((s32)block < 0)
+			return -EFBIG;
+	} else {
+		/* no FIBMAP support */
 		return -EINVAL;
+	}
 
 	lock_kernel();
 	/* Avoid races with truncate */
@@ -95,6 +108,25 @@ static int file_ioctl(struct file *filp,
 			res = phys_block;
 			return put_user(res, p);
 		}
+		case FIBMAP64:
+		{
+			struct address_space *mapping = filp->f_mapping;
+			sector_t phys_block;
+			u64 block;
+
+			if ((error = get_user(block, p)) != 0)
+				return error;
+
+			/* Make sure that the logical block fits in sector_t */
+			if ((sector_t)-1 < block)
+				return -EFBIG;
+
+			error = do_fibmap(mapping, block, &phys_block);
+			if (error)
+				return error;
+
+			return put_user(block, p);
+		}
 		case FIGETBSZ:
 			return put_user(inode->i_sb->s_blocksize, p);
 		case FIONREAD:
Index: linux-2.6.23/include/linux/fs.h
===================================================================
--- linux-2.6.23.orig/include/linux/fs.h	2007-10-26 15:25:47.000000000 -0700
+++ linux-2.6.23/include/linux/fs.h	2007-10-26 15:29:00.000000000 -0700
@@ -220,6 +220,7 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIBMAP64   _IO(0x00,3)	/* bmap access - 64 bit sector numbers */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -423,6 +424,12 @@ struct address_space_operations {
 	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
+	/*
+	 * Version of bmap for filesystems that can safely handle 64bit
+	 * sector_t.  Once all filesystems are converted to this, we can drop
+	 * bmap().
+	 */
+	sector_t (*bmap64)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, gfp_t);
 	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
Index: linux-2.6.23/fs/compat_ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/compat_ioctl.c	2007-10-26 15:25:47.000000000 -0700
+++ linux-2.6.23/fs/compat_ioctl.c	2007-10-26 15:29:00.000000000 -0700
@@ -2506,6 +2506,7 @@ COMPATIBLE_IOCTL(FIONREAD)  /* This is a
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
+COMPATIBLE_IOCTL(FIBMAP64)
 /* 0x03 -- HD/IDE ioctl's used by hdparm and friends.
  *         Some need translations, these do not.
  */
@@ -3597,6 +3598,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 
 	case FIBMAP:
 	case FIGETBSZ:
+	case FIBMAP64:
 	case FIONREAD:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			break;

--
