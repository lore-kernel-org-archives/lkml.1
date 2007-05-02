Return-Path: <linux-kernel-owner+w=401wt.eu-S1766976AbXEBUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766976AbXEBUVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766985AbXEBUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:21:31 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:53069
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766976AbXEBUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:21:30 -0400
Subject: [PATCH] synclink_gt add compat_ioctl
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 02 May 2007 15:21:21 -0500
Message-Id: <1178137281.10111.8.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add compat_ioctl handler to synclink_gt driver.

The one case requiring a separate 32 bit handler could be
removed by redefining the associated structure in
a way compatible with both 32 and 64 bit systems. But that
approach would break existing native 64 bit user applications.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>


--- a/drivers/char/synclink_gt.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2007-05-02 14:52:48.000000000 -0500
@@ -73,6 +73,7 @@
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/hdlc.h>
+#include <linux/compat.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -530,6 +531,10 @@ static int  set_interface(struct slgt_in
 static int  set_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  get_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  wait_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
+#ifdef CONFIG_COMPAT
+static long set_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *new_params);
+static long get_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *new_params);
+#endif
 
 /*
  * driver functions
@@ -1170,6 +1175,55 @@ static int ioctl(struct tty_struct *tty,
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long compat_ioctl(struct tty_struct *tty, struct file *file,
+			 unsigned int cmd, unsigned long arg)
+{
+	struct slgt_info *info = tty->driver_data;
+	int rc = -ENOIOCTLCMD;
+
+	if (sanity_check(info, tty->name, "compat_ioctl"))
+		return -ENODEV;
+	DBGINFO(("%s compat_ioctl() cmd=%08X\n", info->device_name, cmd));
+
+	switch (cmd) {
+
+	case MGSL_IOCSPARAMS32:
+		rc = set_params32(info, (struct MGSL_PARAMS32 __user *)compat_ptr(arg));
+		break;
+
+	case MGSL_IOCGPARAMS32:
+		rc = get_params32(info, (struct MGSL_PARAMS32 __user *)compat_ptr(arg));
+		break;
+
+	case MGSL_IOCGPARAMS:
+	case MGSL_IOCSPARAMS:
+	case MGSL_IOCGTXIDLE:
+	case MGSL_IOCGSTATS:
+	case MGSL_IOCWAITEVENT:
+	case MGSL_IOCGIF:
+	case MGSL_IOCSGPIO:
+	case MGSL_IOCGGPIO:
+	case MGSL_IOCWAITGPIO:
+	case TIOCGICOUNT:
+		rc = ioctl(tty, file, cmd, (unsigned long)(compat_ptr(arg)));
+		break;
+
+	case MGSL_IOCSTXIDLE:
+	case MGSL_IOCTXENABLE:
+	case MGSL_IOCRXENABLE:
+	case MGSL_IOCTXABORT:
+	case TIOCMIWAIT:
+	case MGSL_IOCSIF:
+		rc = ioctl(tty, file, cmd, arg);
+		break;
+	}
+
+	DBGINFO(("%s compat_ioctl() cmd=%08X rc=%d\n", info->device_name, cmd, rc));
+	return rc;
+}
+#endif
+
 /*
  * proc fs support
  */
@@ -2507,6 +2561,61 @@ static int set_params(struct slgt_info *
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long get_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *user_params)
+{
+	struct MGSL_PARAMS32 tmp_params;
+
+	DBGINFO(("%s get_params32\n", info->device_name));
+	tmp_params.mode            = (unsigned int)info->params.mode;
+	tmp_params.loopback        = info->params.loopback;
+	tmp_params.flags           = info->params.flags;
+	tmp_params.encoding        = info->params.encoding;
+	tmp_params.clock_speed     = (unsigned int)info->params.clock_speed;
+	tmp_params.addr_filter     = info->params.addr_filter;
+	tmp_params.crc_type        = info->params.crc_type;
+	tmp_params.preamble_length = info->params.preamble_length;
+	tmp_params.preamble        = info->params.preamble;
+	tmp_params.data_rate       = (unsigned int)info->params.data_rate;
+	tmp_params.data_bits       = info->params.data_bits;
+	tmp_params.stop_bits       = info->params.stop_bits;
+	tmp_params.parity          = info->params.parity;
+	if (copy_to_user(user_params, &tmp_params, sizeof(struct MGSL_PARAMS32)))
+		return -EFAULT;
+	return 0;
+}
+
+static long set_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *new_params)
+{
+ 	unsigned long flags;
+	struct MGSL_PARAMS32 tmp_params;
+
+	DBGINFO(("%s set_params32\n", info->device_name));
+	if (copy_from_user(&tmp_params, new_params, sizeof(struct MGSL_PARAMS32)))
+		return -EFAULT;
+
+	spin_lock_irqsave(&info->lock, flags);
+	info->params.mode            = tmp_params.mode;
+	info->params.loopback        = tmp_params.loopback;
+	info->params.flags           = tmp_params.flags;
+	info->params.encoding        = tmp_params.encoding;
+	info->params.clock_speed     = tmp_params.clock_speed;
+	info->params.addr_filter     = tmp_params.addr_filter;
+	info->params.crc_type        = tmp_params.crc_type;
+	info->params.preamble_length = tmp_params.preamble_length;
+	info->params.preamble        = tmp_params.preamble;
+	info->params.data_rate       = tmp_params.data_rate;
+	info->params.data_bits       = tmp_params.data_bits;
+	info->params.stop_bits       = tmp_params.stop_bits;
+	info->params.parity          = tmp_params.parity;
+	spin_unlock_irqrestore(&info->lock, flags);
+
+ 	change_params(info);
+
+	return 0;
+}
+#endif
+
 static int get_txidle(struct slgt_info *info, int __user *idle_mode)
 {
 	DBGINFO(("%s get_txidle=%d\n", info->device_name, info->idle_mode));
@@ -3443,6 +3552,9 @@ static const struct tty_operations ops =
 	.chars_in_buffer = chars_in_buffer,
 	.flush_buffer = flush_buffer,
 	.ioctl = ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = compat_ioctl,
+#endif
 	.throttle = throttle,
 	.unthrottle = unthrottle,
 	.send_xchar = send_xchar,
--- a/include/linux/synclink.h	2007-04-25 22:08:32.000000000 -0500
+++ b/include/linux/synclink.h	2007-05-02 14:59:17.000000000 -0500
@@ -167,6 +167,24 @@ typedef struct _MGSL_PARAMS
 
 } MGSL_PARAMS, *PMGSL_PARAMS;
 
+/* provide 32 bit ioctl compatibility on 64 bit systems */
+struct MGSL_PARAMS32
+{
+	unsigned int	mode;
+	unsigned char	loopback;
+	unsigned short	flags;
+	unsigned char	encoding;
+	unsigned int	clock_speed;
+	unsigned char	addr_filter;
+	unsigned short	crc_type;
+	unsigned char	preamble_length;
+	unsigned char	preamble;
+	unsigned int	data_rate;
+	unsigned char	data_bits;
+	unsigned char	stop_bits;
+	unsigned char	parity;
+};
+
 #define MICROGATE_VENDOR_ID 0x13c0
 #define SYNCLINK_DEVICE_ID 0x0010
 #define MGSCC_DEVICE_ID 0x0020
@@ -276,6 +294,8 @@ struct gpio_desc {
 #define MGSL_MAGIC_IOC	'm'
 #define MGSL_IOCSPARAMS		_IOW(MGSL_MAGIC_IOC,0,struct _MGSL_PARAMS)
 #define MGSL_IOCGPARAMS		_IOR(MGSL_MAGIC_IOC,1,struct _MGSL_PARAMS)
+#define MGSL_IOCSPARAMS32	_IOW(MGSL_MAGIC_IOC,0,struct MGSL_PARAMS32)
+#define MGSL_IOCGPARAMS32	_IOR(MGSL_MAGIC_IOC,1,struct MGSL_PARAMS32)
 #define MGSL_IOCSTXIDLE		_IO(MGSL_MAGIC_IOC,2)
 #define MGSL_IOCGTXIDLE		_IO(MGSL_MAGIC_IOC,3)
 #define MGSL_IOCTXENABLE	_IO(MGSL_MAGIC_IOC,4)


