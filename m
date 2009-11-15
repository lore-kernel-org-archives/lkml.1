Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZKOQEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZKOQEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 11:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZKOQEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 11:04:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZKOQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 11:04:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 1/4] compat_ioctl: inline all conversion handlers
Date: Sun, 15 Nov 2009 16:04:07 +0000
Message-Id: <1258301050-26900-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258301050-26900-1-git-send-email-arnd@arndb.de>
References: <1258301050-26900-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UYAVGWi5BiE42xZvBS/3RGrWETmzKECmQHeg
 zpVSST4Jk0TJm2MzDZCxhaiFAqNmyTn7QVKWzqpDoApWQu1GJZ
 ZNFfNbsFGeTjF6MaDNndw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes all ioctl conversion handlers called from
a single switch statement, leaving only COMPATIBLE_IOCTL
and ULONG_IOCTL statements in the table. This is somewhat
more space efficient and also lets us simplify the
handling of the lookup table significantly.

before:
   text    data     bss     dec     hex filename
   7619   14024    2080   23723    5cab obj/fs/compat_ioctl.o
after:
   7567   13352    2080   22999    59d7 obj/fs/compat_ioctl.o

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |  135 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 81 insertions(+), 54 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f83db2a..4fa5313 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -635,12 +635,6 @@ static int do_smb_getmountuid(unsigned int fd, unsigned int cmd, unsigned long a
 	return err;
 }
 
-static __used int
-ret_einval(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	return -EINVAL;
-}
-
 static int ioc_settimeout(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, arg);
@@ -1241,6 +1235,8 @@ COMPATIBLE_IOCTL(MTIOCTOP)
 /* Socket level stuff */
 COMPATIBLE_IOCTL(FIOQSIZE)
 #ifdef CONFIG_BLOCK
+/* loop */
+IGNORE_IOCTL(LOOP_CLR_FD)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
@@ -1699,35 +1695,6 @@ COMPATIBLE_IOCTL(JSIOCGAXES)
 COMPATIBLE_IOCTL(JSIOCGBUTTONS)
 COMPATIBLE_IOCTL(JSIOCGNAME(0))
 
-/* now things that need handlers */
-#ifdef CONFIG_BLOCK
-HANDLE_IOCTL(SG_IO,sg_ioctl_trans)
-HANDLE_IOCTL(SG_GET_REQUEST_TABLE, sg_grt_trans)
-#endif
-HANDLE_IOCTL(PPPIOCGIDLE32, ppp_ioctl_trans)
-HANDLE_IOCTL(PPPIOCSCOMPRESS32, ppp_ioctl_trans)
-HANDLE_IOCTL(PPPIOCSPASS32, ppp_sock_fprog_ioctl_trans)
-HANDLE_IOCTL(PPPIOCSACTIVE32, ppp_sock_fprog_ioctl_trans)
-#ifdef CONFIG_BLOCK
-HANDLE_IOCTL(MTIOCGET32, mt_ioctl_trans)
-HANDLE_IOCTL(MTIOCPOS32, mt_ioctl_trans)
-#endif
-#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
-HANDLE_IOCTL(AUTOFS_IOC_SETTIMEOUT32, ioc_settimeout)
-/* One SMB ioctl needs translations. */
-#define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
-HANDLE_IOCTL(SMB_IOC_GETMOUNTUID_32, do_smb_getmountuid)
-/* block stuff */
-#ifdef CONFIG_BLOCK
-/* loop */
-IGNORE_IOCTL(LOOP_CLR_FD)
-/* Raw devices */
-HANDLE_IOCTL(RAW_SETBIND, raw_ioctl)
-HANDLE_IOCTL(RAW_GETBIND, raw_ioctl)
-#endif
-/* Serial */
-HANDLE_IOCTL(TIOCGSERIAL, serial_struct_ioctl)
-HANDLE_IOCTL(TIOCSSERIAL, serial_struct_ioctl)
 #ifdef TIOCGLTC
 COMPATIBLE_IOCTL(TIOCGLTC)
 COMPATIBLE_IOCTL(TIOCSLTC)
@@ -1743,24 +1710,7 @@ COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
 /* Usbdevfs */
-HANDLE_IOCTL(USBDEVFS_CONTROL32, do_usbdevfs_control)
-HANDLE_IOCTL(USBDEVFS_BULK32, do_usbdevfs_bulk)
-HANDLE_IOCTL(USBDEVFS_DISCSIGNAL32, do_usbdevfs_discsignal)
 COMPATIBLE_IOCTL(USBDEVFS_IOCTL32)
-/* i2c */
-HANDLE_IOCTL(I2C_FUNCS, w_long)
-HANDLE_IOCTL(I2C_RDWR, do_i2c_rdwr_ioctl)
-HANDLE_IOCTL(I2C_SMBUS, do_i2c_smbus_ioctl)
-/* Not implemented in the native kernel */
-HANDLE_IOCTL(RTC_IRQP_READ32, rtc_ioctl)
-HANDLE_IOCTL(RTC_IRQP_SET32, rtc_ioctl)
-HANDLE_IOCTL(RTC_EPOCH_READ32, rtc_ioctl)
-HANDLE_IOCTL(RTC_EPOCH_SET32, rtc_ioctl)
-
-/* dvb */
-HANDLE_IOCTL(VIDEO_GET_EVENT, do_video_get_event)
-HANDLE_IOCTL(VIDEO_STILLPICTURE, do_video_stillpicture)
-HANDLE_IOCTL(VIDEO_SET_SPU_PALETTE, do_video_set_spu_palette)
 
 /* parport */
 COMPATIBLE_IOCTL(LPTIME)
@@ -1774,7 +1724,6 @@ COMPATIBLE_IOCTL(LPGETSTATUS)
 COMPATIBLE_IOCTL(LPRESET)
 /*LPGETSTATS not implemented, but no kernels seem to compile it in anyways*/
 COMPATIBLE_IOCTL(LPGETFLAGS)
-HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_trans)
 
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
@@ -1810,6 +1759,83 @@ static inline unsigned long ioctl32_hash(unsigned long cmd)
 	return (((cmd >> 6) ^ (cmd >> 4) ^ cmd)) % IOCTL_HASHSIZE;
 }
 
+/*
+ * Convert common ioctl arguments based on their command number
+ *
+ * Please do not add any code in here. Instead, implement
+ * a compat_ioctl operation in the place that handleѕ the
+ * ioctl for the native case.
+ */
+static long do_ioctl_trans(int fd, unsigned int cmd,
+		 unsigned long arg, struct file *file)
+{
+	switch (cmd) {
+	case PPPIOCGIDLE32:
+	case PPPIOCSCOMPRESS32:
+		return ppp_ioctl_trans(fd, cmd, arg);
+	case PPPIOCSPASS32:
+	case PPPIOCSACTIVE32:
+		return ppp_sock_fprog_ioctl_trans(fd, cmd, arg);
+#ifdef CONFIG_BLOCK
+	case SG_IO:
+		return sg_ioctl_trans(fd, cmd, arg);
+	case SG_GET_REQUEST_TABLE:
+		return sg_grt_trans(fd, cmd, arg);
+	case MTIOCGET32:
+	case MTIOCPOS32:
+		return mt_ioctl_trans(fd, cmd, arg);
+	/* Raw devices */
+	case RAW_SETBIND:
+	case RAW_GETBIND:
+		return raw_ioctl(fd, cmd, arg);
+#endif
+#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
+	case AUTOFS_IOC_SETTIMEOUT32:
+		return ioc_settimeout(fd, cmd, arg);
+	/* One SMB ioctl needs translations. */
+#define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
+	case SMB_IOC_GETMOUNTUID_32:
+		return do_smb_getmountuid(fd, cmd, arg);
+	/* Serial */
+	case TIOCGSERIAL:
+	case TIOCSSERIAL:
+		return serial_struct_ioctl(fd, cmd, arg);
+	/* Usbdevfs */
+	case USBDEVFS_CONTROL32:
+		return do_usbdevfs_control(fd, cmd, arg);
+	case USBDEVFS_BULK32:
+		return do_usbdevfs_bulk(fd, cmd, arg);
+	case USBDEVFS_DISCSIGNAL32:
+		return do_usbdevfs_discsignal(fd, cmd, arg);
+	/* i2c */
+	case I2C_FUNCS:
+		return w_long(fd, cmd, arg);
+	case I2C_RDWR:
+		return do_i2c_rdwr_ioctl(fd, cmd, arg);
+	case I2C_SMBUS:
+		return do_i2c_smbus_ioctl(fd, cmd, arg);
+	/* Not implemented in the native kernel */
+	case RTC_IRQP_READ32:
+	case RTC_IRQP_SET32:
+	case RTC_EPOCH_READ32:
+	case RTC_EPOCH_SET32:
+		return rtc_ioctl(fd, cmd, arg);
+
+	/* dvb */
+	case VIDEO_GET_EVENT:
+		return do_video_get_event(fd, cmd, arg);
+	case VIDEO_STILLPICTURE:
+		return do_video_stillpicture(fd, cmd, arg);
+	case VIDEO_SET_SPU_PALETTE:
+		return do_video_set_spu_palette(fd, cmd, arg);
+
+	/* lp */
+	case LPSETTIMEOUT:
+		return lp_timeout_trans(fd, cmd, arg);
+	}
+	return -ENOIOCTLCMD;
+}
+
 static void compat_ioctl_error(struct file *filp, unsigned int fd,
 		unsigned int cmd, unsigned long arg)
 {
@@ -1906,7 +1932,8 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 			goto found_handler;
 	}
 
-	{
+	error = do_ioctl_trans(fd, cmd, arg, filp);
+	if (error == -ENOIOCTLCMD) {
 		static int count;
 
 		if (++count <= 50)
-- 
1.6.3.3

