Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXEIQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXEIQTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXEIQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:19:18 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43029
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbXEIQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:19:17 -0400
Subject: [PATCH] synclink_gt add compat_ioctl
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 09 May 2007 11:19:09 -0500
Message-Id: <1178727549.3771.3.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for 32 bit ioctl on 64 bit systems for synclink_gt

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/include/linux/Kbuild	2007-04-25 22:08:32.000000000 -0500
+++ b/include/linux/Kbuild	2007-05-09 10:11:22.000000000 -0500
@@ -140,7 +140,6 @@ header-y += snmp.h
 header-y += sockios.h
 header-y += som.h
 header-y += sound.h
-header-y += synclink.h
 header-y += telephony.h
 header-y += termios.h
 header-y += ticable.h
@@ -315,6 +314,7 @@ unifdef-y += sonypi.h
 unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
+unifdef-y += synclink.h
 unifdef-y += sysctl.h
 unifdef-y += tcp.h
 unifdef-y += time.h
--- a/include/linux/synclink.h	2007-04-25 22:08:32.000000000 -0500
+++ b/include/linux/synclink.h	2007-05-09 10:37:20.000000000 -0500
@@ -291,4 +291,29 @@ struct gpio_desc {
 #define MGSL_IOCGGPIO		_IOR(MGSL_MAGIC_IOC,17,struct gpio_desc)
 #define MGSL_IOCWAITGPIO	_IOWR(MGSL_MAGIC_IOC,18,struct gpio_desc)
 
+#ifdef __KERNEL__
+/* provide 32 bit ioctl compatibility on 64 bit systems */
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+struct MGSL_PARAMS32
+{
+	compat_ulong_t	mode;
+	unsigned char	loopback;
+	unsigned short	flags;
+	unsigned char	encoding;
+	compat_ulong_t	clock_speed;
+	unsigned char	addr_filter;
+	unsigned short	crc_type;
+	unsigned char	preamble_length;
+	unsigned char	preamble;
+	compat_ulong_t	data_rate;
+	unsigned char	data_bits;
+	unsigned char	stop_bits;
+	unsigned char	parity;
+};
+#define MGSL_IOCSPARAMS32 _IOW(MGSL_MAGIC_IOC,0,struct MGSL_PARAMS32)
+#define MGSL_IOCGPARAMS32 _IOR(MGSL_MAGIC_IOC,1,struct MGSL_PARAMS32)
+#endif
+#endif
+
 #endif /* _SYNCLINK_H_ */
--- a/drivers/char/synclink_gt.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2007-05-09 10:12:29.000000000 -0500
@@ -1171,6 +1171,112 @@ static int ioctl(struct tty_struct *tty,
 }
 
 /*
+ * support for 32 bit ioctl calls on 64 bit systems
+ */
+#ifdef CONFIG_COMPAT
+static long get_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *user_params)
+{
+	struct MGSL_PARAMS32 tmp_params;
+
+	DBGINFO(("%s get_params32\n", info->device_name));
+	tmp_params.mode            = (compat_ulong_t)info->params.mode;
+	tmp_params.loopback        = info->params.loopback;
+	tmp_params.flags           = info->params.flags;
+	tmp_params.encoding        = info->params.encoding;
+	tmp_params.clock_speed     = (compat_ulong_t)info->params.clock_speed;
+	tmp_params.addr_filter     = info->params.addr_filter;
+	tmp_params.crc_type        = info->params.crc_type;
+	tmp_params.preamble_length = info->params.preamble_length;
+	tmp_params.preamble        = info->params.preamble;
+	tmp_params.data_rate       = (compat_ulong_t)info->params.data_rate;
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
+	struct MGSL_PARAMS32 tmp_params;
+
+	DBGINFO(("%s set_params32\n", info->device_name));
+	if (copy_from_user(&tmp_params, new_params, sizeof(struct MGSL_PARAMS32)))
+		return -EFAULT;
+
+	spin_lock(&info->lock);
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
+	spin_unlock(&info->lock);
+
+ 	change_params(info);
+
+	return 0;
+}
+
+static long slgt_compat_ioctl(struct tty_struct *tty, struct file *file,
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
+		rc = set_params32(info, compat_ptr(arg));
+		break;
+
+	case MGSL_IOCGPARAMS32:
+		rc = get_params32(info, compat_ptr(arg));
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
+#else
+#define slgt_compat_ioctl NULL
+#endif /* ifdef CONFIG_COMPAT */
+
+/*
  * proc fs support
  */
 static inline int line_info(char *buf, struct slgt_info *info)
@@ -3443,6 +3549,7 @@ static const struct tty_operations ops =
 	.chars_in_buffer = chars_in_buffer,
 	.flush_buffer = flush_buffer,
 	.ioctl = ioctl,
+	.compat_ioctl = slgt_compat_ioctl,
 	.throttle = throttle,
 	.unthrottle = unthrottle,
 	.send_xchar = send_xchar,



