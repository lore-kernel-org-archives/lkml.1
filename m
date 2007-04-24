Return-Path: <linux-kernel-owner+w=401wt.eu-S1423084AbXDXT7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423084AbXDXT7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423081AbXDXT7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:59:39 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35681
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423079AbXDXT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:59:38 -0400
Date: Tue, 24 Apr 2007 22:02:35 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: malattia@linux.it, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in Sony PI driver
Message-ID: <20070424200235.GH6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	malattia@linux.it, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the Sony Programmable I/O Control driver uses a semaphore as
mutex. use the mutex API instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com> 

--

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 7823757..878d8d0 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -477,7 +477,7 @@ static struct sonypi_device {
 	u16 evtype_offset;
 	int camera_power;
 	int bluetooth_power;
-	struct semaphore lock;
+	struct mutex lock;
 	struct kfifo *fifo;
 	spinlock_t fifo_lock;
 	wait_queue_head_t fifo_proc_list;
@@ -884,7 +884,7 @@ int sonypi_camera_command(int command, u8 value)
 	if (!camera)
 		return -EIO;
 
-	down(&sonypi_device.lock);
+	mutex_lock(&sonypi_device.lock);
 
 	switch (command) {
 	case SONYPI_COMMAND_SETCAMERA:
@@ -919,7 +919,7 @@ int sonypi_camera_command(int command, u8 value)
 		       command);
 		break;
 	}
-	up(&sonypi_device.lock);
+	mutex_unlock(&sonypi_device.lock);
 	return 0;
 }
 
@@ -938,20 +938,20 @@ static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 static int sonypi_misc_release(struct inode *inode, struct file *file)
 {
 	sonypi_misc_fasync(-1, file, 0);
-	down(&sonypi_device.lock);
+	mutex_lock(&sonypi_device.lock);
 	sonypi_device.open_count--;
-	up(&sonypi_device.lock);
+	mutex_unlock(&sonypi_device.lock);
 	return 0;
 }
 
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
-	down(&sonypi_device.lock);
+	mutex_lock(&sonypi_device.lock);
 	/* Flush input queue on first open */
 	if (!sonypi_device.open_count)
 		kfifo_reset(sonypi_device.fifo);
 	sonypi_device.open_count++;
-	up(&sonypi_device.lock);
+	mutex_unlock(&sonypi_device.lock);
 	return 0;
 }
 
@@ -1001,7 +1001,7 @@ static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
 	u8 val8;
 	u16 val16;
 
-	down(&sonypi_device.lock);
+	mutex_lock(&sonypi_device.lock);
 	switch (cmd) {
 	case SONYPI_IOCGBRT:
 		if (sonypi_ec_read(SONYPI_LCD_LIGHT, &val8)) {
@@ -1101,7 +1101,7 @@ static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
 	default:
 		ret = -EINVAL;
 	}
-	up(&sonypi_device.lock);
+	mutex_unlock(&sonypi_device.lock);
 	return ret;
 }
 
@@ -1330,7 +1330,7 @@ static int __devinit sonypi_probe(struct platform_device *dev)
 	}
 
 	init_waitqueue_head(&sonypi_device.fifo_proc_list);
-	init_MUTEX(&sonypi_device.lock);
+	mutex_init(&sonypi_device.lock);
 	sonypi_device.bluetooth_power = -1;
 
 	if ((pcidev = pci_get_device(PCI_VENDOR_ID_INTEL,

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             If liberty means anything at all, it means the
           right to tell people what they do not want to hear
                            (George Orwell)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
