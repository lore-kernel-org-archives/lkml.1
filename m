Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbXJFS27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbXJFS27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763010AbXJFS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:28:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387AbXJFS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:28:40 -0400
Message-Id: <20071006182342.736330648@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:04 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 2/9] compat_ioctl: add compat_blkdev_driver_ioctl()
Content-Disposition: inline; filename=compat-block-driver-ioctl.diff
X-Provags-ID: V01U2FsdGVkX18f0QUbuO5qZnzhd17Q9LRfJRM7aYZLiEGftQ3
 Nh2wH3cUFUyvs1o3uJN7XXF8aXz3BdcFcff8QzjbiVvc+dH3Ix
 3xJUsLjeSzvyNktZfHHVA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle those blockdev ioctl calls that are compatible
directly from the compat_blkdev_ioctl() function, instead
of having to go through the compat_ioctl hash lookup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -40,6 +40,122 @@ static int compat_put_u64(unsigned long 
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
 
+static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
+			struct gendisk *disk, unsigned cmd, unsigned long arg)
+{
+	int ret;
+
+	switch (arg) {
+	/*
+	 * No handler required for the ones below, we just need to
+	 * convert arg to a 64 bit pointer.
+	 */
+	case BLKSECTSET:
+	/*
+	 * 0x03 -- HD/IDE ioctl's used by hdparm and friends.
+	 *         Some need translations, these do not.
+	 */
+	case HDIO_GET_IDENTITY:
+	case HDIO_DRIVE_TASK:
+	case HDIO_DRIVE_CMD:
+	case HDIO_SCAN_HWIF:
+	/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
+	case 0x330:
+	/* 0x02 -- Floppy ioctls */
+	case FDMSGON:
+	case FDMSGOFF:
+	case FDSETEMSGTRESH:
+	case FDFLUSH:
+	case FDWERRORCLR:
+	case FDSETMAXERRS:
+	case FDGETMAXERRS:
+	case FDGETDRVTYP:
+	case FDEJECT:
+	case FDCLRPRM:
+	case FDFMTBEG:
+	case FDFMTEND:
+	case FDRESET:
+	case FDTWADDLE:
+	case FDFMTTRK:
+	case FDRAWCMD:
+	/* CDROM stuff */
+	case CDROMPAUSE:
+	case CDROMRESUME:
+	case CDROMPLAYMSF:
+	case CDROMPLAYTRKIND:
+	case CDROMREADTOCHDR:
+	case CDROMREADTOCENTRY:
+	case CDROMSTOP:
+	case CDROMSTART:
+	case CDROMEJECT:
+	case CDROMVOLCTRL:
+	case CDROMSUBCHNL:
+	case CDROMMULTISESSION:
+	case CDROM_GET_MCN:
+	case CDROMRESET:
+	case CDROMVOLREAD:
+	case CDROMSEEK:
+	case CDROMPLAYBLK:
+	case CDROMCLOSETRAY:
+	case CDROM_DISC_STATUS:
+	case CDROM_CHANGER_NSLOTS:
+	case CDROM_GET_CAPABILITY:
+	/* Ignore cdrom.h about these next 5 ioctls, they absolutely do
+	 * not take a struct cdrom_read, instead they take a struct cdrom_msf
+	 * which is compatible.
+	 */
+	case CDROMREADMODE2:
+	case CDROMREADMODE1:
+	case CDROMREADRAW:
+	case CDROMREADCOOKED:
+	case CDROMREADALL:
+	/* DVD ioctls */
+	case DVD_READ_STRUCT:
+	case DVD_WRITE_STRUCT:
+	case DVD_AUTH:
+		arg = (unsigned long)compat_ptr(arg);
+	/* These intepret arg as an unsigned long, not as a pointer,
+	 * so we must not do compat_ptr() conversion. */
+	case HDIO_SET_MULTCOUNT:
+	case HDIO_SET_UNMASKINTR:
+	case HDIO_SET_KEEPSETTINGS:
+	case HDIO_SET_32BIT:
+	case HDIO_SET_NOWERR:
+	case HDIO_SET_DMA:
+	case HDIO_SET_PIO_MODE:
+	case HDIO_SET_NICE:
+	case HDIO_SET_WCACHE:
+	case HDIO_SET_ACOUSTIC:
+	case HDIO_SET_BUSSTATE:
+	case HDIO_SET_ADDRESS:
+	case CDROMEJECT_SW:
+	case CDROM_SET_OPTIONS:
+	case CDROM_CLEAR_OPTIONS:
+	case CDROM_SELECT_SPEED:
+	case CDROM_SELECT_DISC:
+	case CDROM_MEDIA_CHANGED:
+	case CDROM_DRIVE_STATUS:
+	case CDROM_LOCKDOOR:
+	case CDROM_DEBUG:
+		break;
+	default:
+		/* unknown ioctl number */
+		return -ENOIOCTLCMD;
+	}
+
+	if (disk->fops->unlocked_ioctl)
+		return disk->fops->unlocked_ioctl(file, cmd, arg);
+
+	if (disk->fops->ioctl) {
+		lock_kernel();
+		ret = disk->fops->ioctl(inode, file, cmd, arg);
+		unlock_kernel();
+		return ret;
+	}
+
+	return -ENOTTY;
+}
+
 static int compat_blkdev_locked_ioctl(struct inode *inode, struct file *file,
 				struct block_device *bdev,
 				unsigned cmd, unsigned long arg)
@@ -119,5 +235,8 @@ long compat_blkdev_ioctl(struct file *fi
 		ret = disk->fops->compat_ioctl(file, cmd, arg);
 	unlock_kernel();
 
-	return ret;
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	return compat_blkdev_driver_ioctl(inode, file, disk, cmd, arg);
 }
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -2477,47 +2477,8 @@ COMPATIBLE_IOCTL(FIONREAD)  /* This is a
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
-/* 0x03 -- HD/IDE ioctl's used by hdparm and friends.
- *         Some need translations, these do not.
- */
-COMPATIBLE_IOCTL(HDIO_GET_IDENTITY)
-COMPATIBLE_IOCTL(HDIO_DRIVE_TASK)
-COMPATIBLE_IOCTL(HDIO_DRIVE_CMD)
-ULONG_IOCTL(HDIO_SET_MULTCOUNT)
-ULONG_IOCTL(HDIO_SET_UNMASKINTR)
-ULONG_IOCTL(HDIO_SET_KEEPSETTINGS)
-ULONG_IOCTL(HDIO_SET_32BIT)
-ULONG_IOCTL(HDIO_SET_NOWERR)
-ULONG_IOCTL(HDIO_SET_DMA)
-ULONG_IOCTL(HDIO_SET_PIO_MODE)
-ULONG_IOCTL(HDIO_SET_NICE)
-ULONG_IOCTL(HDIO_SET_WCACHE)
-ULONG_IOCTL(HDIO_SET_ACOUSTIC)
-ULONG_IOCTL(HDIO_SET_BUSSTATE)
-ULONG_IOCTL(HDIO_SET_ADDRESS)
-COMPATIBLE_IOCTL(HDIO_SCAN_HWIF)
-/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
-COMPATIBLE_IOCTL(0x330)
-/* 0x02 -- Floppy ioctls */
-COMPATIBLE_IOCTL(FDMSGON)
-COMPATIBLE_IOCTL(FDMSGOFF)
-COMPATIBLE_IOCTL(FDSETEMSGTRESH)
-COMPATIBLE_IOCTL(FDFLUSH)
-COMPATIBLE_IOCTL(FDWERRORCLR)
-COMPATIBLE_IOCTL(FDSETMAXERRS)
-COMPATIBLE_IOCTL(FDGETMAXERRS)
-COMPATIBLE_IOCTL(FDGETDRVTYP)
-COMPATIBLE_IOCTL(FDEJECT)
-COMPATIBLE_IOCTL(FDCLRPRM)
-COMPATIBLE_IOCTL(FDFMTBEG)
-COMPATIBLE_IOCTL(FDFMTEND)
-COMPATIBLE_IOCTL(FDRESET)
-COMPATIBLE_IOCTL(FDTWADDLE)
-COMPATIBLE_IOCTL(FDFMTTRK)
-COMPATIBLE_IOCTL(FDRAWCMD)
 /* 0x12 */
 #ifdef CONFIG_BLOCK
-COMPATIBLE_IOCTL(BLKSECTSET)
 COMPATIBLE_IOCTL(BLKTRACESTART)
 COMPATIBLE_IOCTL(BLKTRACESTOP)
 COMPATIBLE_IOCTL(BLKTRACESETUP)
@@ -2770,50 +2731,6 @@ COMPATIBLE_IOCTL(PPGETMODE)
 COMPATIBLE_IOCTL(PPGETPHASE)
 COMPATIBLE_IOCTL(PPGETFLAGS)
 COMPATIBLE_IOCTL(PPSETFLAGS)
-/* CDROM stuff */
-COMPATIBLE_IOCTL(CDROMPAUSE)
-COMPATIBLE_IOCTL(CDROMRESUME)
-COMPATIBLE_IOCTL(CDROMPLAYMSF)
-COMPATIBLE_IOCTL(CDROMPLAYTRKIND)
-COMPATIBLE_IOCTL(CDROMREADTOCHDR)
-COMPATIBLE_IOCTL(CDROMREADTOCENTRY)
-COMPATIBLE_IOCTL(CDROMSTOP)
-COMPATIBLE_IOCTL(CDROMSTART)
-COMPATIBLE_IOCTL(CDROMEJECT)
-COMPATIBLE_IOCTL(CDROMVOLCTRL)
-COMPATIBLE_IOCTL(CDROMSUBCHNL)
-ULONG_IOCTL(CDROMEJECT_SW)
-COMPATIBLE_IOCTL(CDROMMULTISESSION)
-COMPATIBLE_IOCTL(CDROM_GET_MCN)
-COMPATIBLE_IOCTL(CDROMRESET)
-COMPATIBLE_IOCTL(CDROMVOLREAD)
-COMPATIBLE_IOCTL(CDROMSEEK)
-COMPATIBLE_IOCTL(CDROMPLAYBLK)
-COMPATIBLE_IOCTL(CDROMCLOSETRAY)
-ULONG_IOCTL(CDROM_SET_OPTIONS)
-ULONG_IOCTL(CDROM_CLEAR_OPTIONS)
-ULONG_IOCTL(CDROM_SELECT_SPEED)
-ULONG_IOCTL(CDROM_SELECT_DISC)
-ULONG_IOCTL(CDROM_MEDIA_CHANGED)
-ULONG_IOCTL(CDROM_DRIVE_STATUS)
-COMPATIBLE_IOCTL(CDROM_DISC_STATUS)
-COMPATIBLE_IOCTL(CDROM_CHANGER_NSLOTS)
-ULONG_IOCTL(CDROM_LOCKDOOR)
-ULONG_IOCTL(CDROM_DEBUG)
-COMPATIBLE_IOCTL(CDROM_GET_CAPABILITY)
-/* Ignore cdrom.h about these next 5 ioctls, they absolutely do
- * not take a struct cdrom_read, instead they take a struct cdrom_msf
- * which is compatible.
- */
-COMPATIBLE_IOCTL(CDROMREADMODE2)
-COMPATIBLE_IOCTL(CDROMREADMODE1)
-COMPATIBLE_IOCTL(CDROMREADRAW)
-COMPATIBLE_IOCTL(CDROMREADCOOKED)
-COMPATIBLE_IOCTL(CDROMREADALL)
-/* DVD ioctls */
-COMPATIBLE_IOCTL(DVD_READ_STRUCT)
-COMPATIBLE_IOCTL(DVD_WRITE_STRUCT)
-COMPATIBLE_IOCTL(DVD_AUTH)
 /* pktcdvd */
 COMPATIBLE_IOCTL(PACKET_CTRL_CMD)
 /* Big A */

-- 

