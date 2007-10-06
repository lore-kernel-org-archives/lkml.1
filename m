Return-Path: <linux-kernel-owner+w=401wt.eu-S1764940AbXJFSay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764940AbXJFSay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761748AbXJFSam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:30:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764245AbXJFSal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:30:41 -0400
Message-Id: <20071006182343.354463064@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:08 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 6/9] compat_ioctl: move cdrom handlers to block/compat_ioctl.c
Content-Disposition: inline; filename=compat-cdrom-ioctl.diff
X-Provags-ID: V01U2FsdGVkX18+2HcFmg8EN8xErlz4vcxluUPRSEvrbbh5WZd
 DFcUHNyXepVA7DlVBN2v1ed/Xd+m07E5pGlZ6PP4UqCk/UlhGG
 IhBiLk3S4s2MgnMxDb+rg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are shared by all cd-rom drivers and should have common
handlers. Do slight cosmetic cleanups in the process.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -92,6 +92,84 @@ static int compat_hdio_ioctl(struct inod
 	return error;
 }
 
+struct compat_cdrom_read_audio {
+	union cdrom_addr	addr;
+	u8			addr_format;
+	compat_int_t		nframes;
+	compat_caddr_t		buf;
+};
+
+struct compat_cdrom_generic_command {
+	unsigned char	cmd[CDROM_PACKET_SIZE];
+	compat_caddr_t	buffer;
+	compat_uint_t	buflen;
+	compat_int_t	stat;
+	compat_caddr_t	sense;
+	unsigned char	data_direction;
+	compat_int_t	quiet;
+	compat_int_t	timeout;
+	compat_caddr_t	reserved[1];
+};
+
+static int compat_cdrom_read_audio(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	struct cdrom_read_audio __user *cdread_audio;
+	struct compat_cdrom_read_audio __user *cdread_audio32;
+	__u32 data;
+	void __user *datap;
+
+	cdread_audio = compat_alloc_user_space(sizeof(*cdread_audio));
+	cdread_audio32 = compat_ptr(arg);
+
+	if (copy_in_user(&cdread_audio->addr,
+			 &cdread_audio32->addr,
+			 (sizeof(*cdread_audio32) -
+			  sizeof(compat_caddr_t))))
+		return -EFAULT;
+
+	if (get_user(data, &cdread_audio32->buf))
+		return -EFAULT;
+	datap = compat_ptr(data);
+	if (put_user(datap, &cdread_audio->buf))
+		return -EFAULT;
+
+	return blkdev_driver_ioctl(inode, file, disk, cmd,
+			(unsigned long)cdread_audio);
+}
+
+static int compat_cdrom_generic_command(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	struct cdrom_generic_command __user *cgc;
+	struct compat_cdrom_generic_command __user *cgc32;
+	u32 data;
+	unsigned char dir;
+	int itmp;
+
+	cgc = compat_alloc_user_space(sizeof(*cgc));
+	cgc32 = compat_ptr(arg);
+
+	if (copy_in_user(&cgc->cmd, &cgc32->cmd, sizeof(cgc->cmd)) ||
+	    get_user(data, &cgc32->buffer) ||
+	    put_user(compat_ptr(data), &cgc->buffer) ||
+	    copy_in_user(&cgc->buflen, &cgc32->buflen,
+			 (sizeof(unsigned int) + sizeof(int))) ||
+	    get_user(data, &cgc32->sense) ||
+	    put_user(compat_ptr(data), &cgc->sense) ||
+	    get_user(dir, &cgc32->data_direction) ||
+	    put_user(dir, &cgc->data_direction) ||
+	    get_user(itmp, &cgc32->quiet) ||
+	    put_user(itmp, &cgc->quiet) ||
+	    get_user(itmp, &cgc32->timeout) ||
+	    put_user(itmp, &cgc->timeout) ||
+	    get_user(data, &cgc32->reserved[0]) ||
+	    put_user(compat_ptr(data), &cgc->reserved[0]))
+		return -EFAULT;
+
+	return blkdev_driver_ioctl(inode, file, disk, cmd, (unsigned long)cgc);
+}
+
 struct compat_blkpg_ioctl_arg {
 	compat_int_t op;
 	compat_int_t flags;
@@ -190,6 +268,11 @@ static int compat_blkdev_driver_ioctl(st
 	case HDIO_GET_ADDRESS:
 	case HDIO_GET_BUSSTATE:
 		return compat_hdio_ioctl(inode, file, disk, cmd, arg);
+	case CDROMREADAUDIO:
+		return compat_cdrom_read_audio(inode, file, disk, cmd, arg);
+	case CDROM_SEND_PACKET:
+		return compat_cdrom_generic_command(inode, file, disk, cmd, arg);
+
 	/*
 	 * No handler required for the ones below, we just need to
 	 * convert arg to a 64 bit pointer.
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -37,7 +37,6 @@
 #include <linux/if_ppp.h>
 #include <linux/if_pppox.h>
 #include <linux/mtio.h>
-#include <linux/cdrom.h>
 #include <linux/auto_fs.h>
 #include <linux/auto_fs4.h>
 #include <linux/tty.h>
@@ -1039,108 +1038,6 @@ static int mt_ioctl_trans(unsigned int f
 	return err ? -EFAULT: 0;
 }
 
-struct cdrom_read_audio32 {
-	union cdrom_addr	addr;
-	u8			addr_format;
-	compat_int_t		nframes;
-	compat_caddr_t		buf;
-};
-
-struct cdrom_generic_command32 {
-	unsigned char	cmd[CDROM_PACKET_SIZE];
-	compat_caddr_t	buffer;
-	compat_uint_t	buflen;
-	compat_int_t	stat;
-	compat_caddr_t	sense;
-	unsigned char	data_direction;
-	compat_int_t	quiet;
-	compat_int_t	timeout;
-	compat_caddr_t	reserved[1];
-};
-  
-static int cdrom_do_read_audio(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct cdrom_read_audio __user *cdread_audio;
-	struct cdrom_read_audio32 __user *cdread_audio32;
-	__u32 data;
-	void __user *datap;
-
-	cdread_audio = compat_alloc_user_space(sizeof(*cdread_audio));
-	cdread_audio32 = compat_ptr(arg);
-
-	if (copy_in_user(&cdread_audio->addr,
-			 &cdread_audio32->addr,
-			 (sizeof(*cdread_audio32) -
-			  sizeof(compat_caddr_t))))
-	 	return -EFAULT;
-
-	if (get_user(data, &cdread_audio32->buf))
-		return -EFAULT;
-	datap = compat_ptr(data);
-	if (put_user(datap, &cdread_audio->buf))
-		return -EFAULT;
-
-	return sys_ioctl(fd, cmd, (unsigned long) cdread_audio);
-}
-
-static int cdrom_do_generic_command(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct cdrom_generic_command __user *cgc;
-	struct cdrom_generic_command32 __user *cgc32;
-	u32 data;
-	unsigned char dir;
-	int itmp;
-
-	cgc = compat_alloc_user_space(sizeof(*cgc));
-	cgc32 = compat_ptr(arg);
-
-	if (copy_in_user(&cgc->cmd, &cgc32->cmd, sizeof(cgc->cmd)) ||
-	    get_user(data, &cgc32->buffer) ||
-	    put_user(compat_ptr(data), &cgc->buffer) ||
-	    copy_in_user(&cgc->buflen, &cgc32->buflen,
-			 (sizeof(unsigned int) + sizeof(int))) ||
-	    get_user(data, &cgc32->sense) ||
-	    put_user(compat_ptr(data), &cgc->sense) ||
-	    get_user(dir, &cgc32->data_direction) ||
-	    put_user(dir, &cgc->data_direction) ||
-	    get_user(itmp, &cgc32->quiet) ||
-	    put_user(itmp, &cgc->quiet) ||
-	    get_user(itmp, &cgc32->timeout) ||
-	    put_user(itmp, &cgc->timeout) ||
-	    get_user(data, &cgc32->reserved[0]) ||
-	    put_user(compat_ptr(data), &cgc->reserved[0]))
-		return -EFAULT;
-
-	return sys_ioctl(fd, cmd, (unsigned long) cgc);
-}
-
-static int cdrom_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	int err;
-
-	switch(cmd) {
-	case CDROMREADAUDIO:
-		err = cdrom_do_read_audio(fd, cmd, arg);
-		break;
-
-	case CDROM_SEND_PACKET:
-		err = cdrom_do_generic_command(fd, cmd, arg);
-		break;
-
-	default:
-		do {
-			static int count;
-			if (++count <= 20)
-				printk("cdrom_ioctl: Unknown cmd fd(%d) "
-				       "cmd(%08x) arg(%08x)\n",
-				       (int)fd, (unsigned int)cmd, (unsigned int)arg);
-		} while(0);
-		err = -EINVAL;
-		break;
-	};
-
-	return err;
-}
 #endif /* CONFIG_BLOCK */
 
 #ifdef CONFIG_VT
@@ -3147,8 +3044,6 @@ HANDLE_IOCTL(PPPIOCSACTIVE32, ppp_sock_f
 #ifdef CONFIG_BLOCK
 HANDLE_IOCTL(MTIOCGET32, mt_ioctl_trans)
 HANDLE_IOCTL(MTIOCPOS32, mt_ioctl_trans)
-HANDLE_IOCTL(CDROMREADAUDIO, cdrom_ioctl_trans)
-HANDLE_IOCTL(CDROM_SEND_PACKET, cdrom_ioctl_trans)
 #endif
 #define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
 HANDLE_IOCTL(AUTOFS_IOC_SETTIMEOUT32, ioc_settimeout)

-- 

