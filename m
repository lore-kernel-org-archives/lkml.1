Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYKEN6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYKEN6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYKEN6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:58:46 -0500
Received: from verein.lst.de ([213.95.11.210]:52744 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbYKEN6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:58:45 -0500
Date: Wed, 5 Nov 2008 14:58:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kill FMODE_NDELAY_NOW
Message-ID: <20081105135842.GB4393@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update FMODE_NDELAY before each ioctl call so that we can kill the
magic FMODE_NDELAY_NOW.  It would be even better to do this directly
in setfl(), but for that we'd need to have FMODE_NDELAY for all files,
not just block special files.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c	2008-11-02 19:47:40.000000000 +0100
+++ linux-2.6/block/compat_ioctl.c	2008-11-02 19:48:07.000000000 +0100
@@ -699,8 +699,14 @@ long compat_blkdev_ioctl(struct file *fi
 	struct backing_dev_info *bdi;
 	loff_t size;
 
+	/*
+	 * O_NDELAY can be altered using fcntl(.., F_SETFL, ..), so we have
+	 * to updated it before every ioctl.
+	 */
 	if (file->f_flags & O_NDELAY)
-		mode |= FMODE_NDELAY_NOW;
+		mode |= FMODE_NDELAY;
+	else
+		mode &= ~FMODE_NDELAY;
 
 	switch (cmd) {
 	case HDIO_GETGEO:
Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2008-11-02 19:47:20.000000000 +0100
+++ linux-2.6/drivers/scsi/sd.c	2008-11-02 19:48:11.000000000 +0100
@@ -757,7 +757,7 @@ static int sd_ioctl(struct block_device 
 	 * access to the device is prohibited.
 	 */
 	error = scsi_nonblockable_ioctl(sdp, cmd, p,
-					(mode & FMODE_NDELAY_NOW) != 0);
+					(mode & FMODE_NDELAY) != 0);
 	if (!scsi_block_when_processing_errors(sdp) || !error)
 		return error;
 
Index: linux-2.6/drivers/scsi/sr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sr.c	2008-11-02 19:47:03.000000000 +0100
+++ linux-2.6/drivers/scsi/sr.c	2008-11-02 19:47:18.000000000 +0100
@@ -521,7 +521,7 @@ static int sr_block_ioctl(struct block_d
 	 * if it doesn't recognise the ioctl
 	 */
 	ret = scsi_nonblockable_ioctl(sdev, cmd, argp,
-					(mode & FMODE_NDELAY_NOW) != 0);
+					(mode & FMODE_NDELAY) != 0);
 	if (ret != -ENODEV)
 		return ret;
 	return scsi_ioctl(sdev, cmd, argp);
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2008-11-02 19:45:01.000000000 +0100
+++ linux-2.6/fs/block_dev.c	2008-11-02 19:48:05.000000000 +0100
@@ -1207,8 +1207,16 @@ static long block_ioctl(struct file *fil
 {
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	fmode_t mode = file->f_mode;
+
+	/*
+	 * O_NDELAY can be altered using fcntl(.., F_SETFL, ..), so we have
+	 * to updated it before every ioctl.
+	 */
 	if (file->f_flags & O_NDELAY)
-		mode |= FMODE_NDELAY_NOW;
+		mode |= FMODE_NDELAY;
+	else
+		mode &= ~FMODE_NDELAY;
+
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-11-02 19:48:13.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2008-11-02 19:48:24.000000000 +0100
@@ -79,7 +79,6 @@ extern int dir_notify_enable;
 #define FMODE_NDELAY	((__force fmode_t)32)
 #define FMODE_EXCL	((__force fmode_t)64)
 #define FMODE_WRITE_IOCTL	((__force fmode_t)128)
-#define FMODE_NDELAY_NOW	((__force fmode_t)256)
 
 #define RW_MASK		1
 #define RWA_MASK	2
