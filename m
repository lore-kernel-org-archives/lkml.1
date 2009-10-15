Return-Path: <linux-kernel-owner+w=401wt.eu-S935549AbZJOUaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549AbZJOUaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935541AbZJOUaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:30:04 -0400
Received: from www.tglx.de ([62.245.132.106]:52505 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935540AbZJOUaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:30:02 -0400
Message-Id: <20091015202758.400949170@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 20:28:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ALan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       lm-sensors@lm-sensors.org
Subject: [patch 1/5] hwmon: Convert fschmd to unlocked_ioctl
References: <20091015202722.372890083@linutronix.de>
Content-Disposition: inline;
	filename=hwmon-convert-fschmd-to-unlocked-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion of fschmd watchdog ioctl to unlocked_ioctl needs to
protect the static watchdog_info variable for the WDIOC_GETSUPPORT
command.

All other commands are safe w/o BKL as the called watchdog functions
are already serialized with watchdog_lock of the sensor.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: lm-sensors@lm-sensors.org
---
 drivers/hwmon/fschmd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/drivers/hwmon/fschmd.c
===================================================================
--- linux-2.6-tip.orig/drivers/hwmon/fschmd.c
+++ linux-2.6-tip/drivers/hwmon/fschmd.c
@@ -844,8 +844,8 @@ static ssize_t watchdog_write(struct fil
 	return count;
 }
 
-static int watchdog_ioctl(struct inode *inode, struct file *filp,
-	unsigned int cmd, unsigned long arg)
+static long watchdog_ioctl(struct file *filp, unsigned int cmd,
+			   unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
@@ -857,11 +857,13 @@ static int watchdog_ioctl(struct inode *
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
+		mutex_lock(&watchdog_data_mutex);
 		ident.firmware_version = data->revision;
 		if (!nowayout)
 			ident.options |= WDIOF_MAGICCLOSE;
 		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
 			ret = -EFAULT;
+		mutex_unlock(&watchdog_data_mutex);
 		break;
 
 	case WDIOC_GETSTATUS:
@@ -921,7 +923,7 @@ static const struct file_operations watc
 	.open = watchdog_open,
 	.release = watchdog_release,
 	.write = watchdog_write,
-	.ioctl = watchdog_ioctl,
+	.unlocked_ioctl = watchdog_ioctl,
 };
 
 


