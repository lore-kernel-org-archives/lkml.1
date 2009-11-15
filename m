Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZKOQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZKOQES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 11:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZKOQEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 11:04:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZKOQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 11:04:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 4/4] compat_ioctl: pass compat pointer directly to handlers
Date: Sun, 15 Nov 2009 16:04:10 +0000
Message-Id: <1258301050-26900-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258301050-26900-1-git-send-email-arnd@arndb.de>
References: <1258301050-26900-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Azp8T/cSdx6hewVUBOK//bOCTXXxhnSyQQ71
 wGHputsXe9PUTDt0ntSFTXYmaVuJy5oBE8GG0MRFrczhATyobl
 Sfb9IUh+s0d87haDcfWeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having each handler call compat_ptr, we can now
convert the pointer once and pass that to each handler.
This saves a little bit of both source and object code size.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |  211 +++++++++++++++++++++--------------------------------
 1 files changed, 83 insertions(+), 128 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 61ce31f..bd8d4e9 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -117,33 +117,34 @@
 #include <asm/fbio.h>
 #endif
 
-static int w_long(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int w_long(unsigned int fd, unsigned int cmd,
+		compat_ulong_t __user *argp)
 {
 	mm_segment_t old_fs = get_fs();
 	int err;
 	unsigned long val;
-	
+
 	set_fs (KERNEL_DS);
 	err = sys_ioctl(fd, cmd, (unsigned long)&val);
 	set_fs (old_fs);
-	if (!err && put_user(val, (u32 __user *)compat_ptr(arg)))
+	if (!err && put_user(val, argp))
 		return -EFAULT;
 	return err;
 }
- 
-static int rw_long(unsigned int fd, unsigned int cmd, unsigned long arg)
+
+static int rw_long(unsigned int fd, unsigned int cmd,
+		compat_ulong_t __user *argp)
 {
 	mm_segment_t old_fs = get_fs();
-	u32 __user *argptr = compat_ptr(arg);
 	int err;
 	unsigned long val;
-	
-	if(get_user(val, argptr))
+
+	if(get_user(val, argp))
 		return -EFAULT;
 	set_fs (KERNEL_DS);
 	err = sys_ioctl(fd, cmd, (unsigned long)&val);
 	set_fs (old_fs);
-	if (!err && put_user(val, argptr))
+	if (!err && put_user(val, argp))
 		return -EFAULT;
 	return err;
 }
@@ -157,7 +158,8 @@ struct compat_video_event {
 	} u;
 };
 
-static int do_video_get_event(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_video_get_event(unsigned int fd, unsigned int cmd,
+		struct compat_video_event __user *up)
 {
 	struct video_event kevent;
 	mm_segment_t old_fs = get_fs();
@@ -168,8 +170,6 @@ static int do_video_get_event(unsigned int fd, unsigned int cmd, unsigned long a
 	set_fs(old_fs);
 
 	if (!err) {
-		struct compat_video_event __user *up = compat_ptr(arg);
-
 		err  = put_user(kevent.type, &up->type);
 		err |= put_user(kevent.timestamp, &up->timestamp);
 		err |= put_user(kevent.u.size.w, &up->u.size.w);
@@ -188,15 +188,14 @@ struct compat_video_still_picture {
         int32_t size;
 };
 
-static int do_video_stillpicture(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_video_stillpicture(unsigned int fd, unsigned int cmd,
+	struct compat_video_still_picture __user *up)
 {
-	struct compat_video_still_picture __user *up;
 	struct video_still_picture __user *up_native;
 	compat_uptr_t fp;
 	int32_t size;
 	int err;
 
-	up = (struct compat_video_still_picture __user *) arg;
 	err  = get_user(fp, &up->iFrame);
 	err |= get_user(size, &up->size);
 	if (err)
@@ -220,14 +219,13 @@ struct compat_video_spu_palette {
 	compat_uptr_t palette;
 };
 
-static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd,
+		struct compat_video_spu_palette __user *up)
 {
-	struct compat_video_spu_palette __user *up;
 	struct video_spu_palette __user *up_native;
 	compat_uptr_t palp;
 	int length, err;
 
-	up = (struct compat_video_spu_palette __user *) arg;
 	err  = get_user(palp, &up->palette);
 	err |= get_user(length, &up->length);
 
@@ -295,16 +293,15 @@ static int sg_build_iovec(sg_io_hdr_t __user *sgio, void __user *dxferp, u16 iov
 	return 0;
 }
 
-static int sg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
+			sg_io_hdr32_t __user *sgio32)
 {
 	sg_io_hdr_t __user *sgio;
-	sg_io_hdr32_t __user *sgio32;
 	u16 iovec_count;
 	u32 data;
 	void __user *dxferp;
 	int err;
 
-	sgio32 = compat_ptr(arg);
 	if (get_user(iovec_count, &sgio32->iovec_count))
 		return -EFAULT;
 
@@ -394,11 +391,11 @@ struct compat_sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 	int unused;
 };
 
-static int sg_grt_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int sg_grt_trans(unsigned int fd, unsigned int cmd, struct
+			compat_sg_req_info __user *o)
 {
 	int err, i;
 	sg_req_info_t __user *r;
-	struct compat_sg_req_info __user *o = (void __user *)arg;
 	r = compat_alloc_user_space(sizeof(sg_req_info_t)*SG_MAX_QUEUE);
 	err = sys_ioctl(fd,cmd,(unsigned long)r);
 	if (err < 0)
@@ -426,9 +423,9 @@ struct sock_fprog32 {
 #define PPPIOCSPASS32	_IOW('t', 71, struct sock_fprog32)
 #define PPPIOCSACTIVE32	_IOW('t', 70, struct sock_fprog32)
 
-static int ppp_sock_fprog_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int ppp_sock_fprog_ioctl_trans(unsigned int fd, unsigned int cmd,
+			struct sock_fprog32 __user *u_fprog32)
 {
-	struct sock_fprog32 __user *u_fprog32 = compat_ptr(arg);
 	struct sock_fprog __user *u_fprog64 = compat_alloc_user_space(sizeof(struct sock_fprog));
 	void __user *fptr64;
 	u32 fptr32;
@@ -465,15 +462,14 @@ struct ppp_idle32 {
 };
 #define PPPIOCGIDLE32		_IOR('t', 63, struct ppp_idle32)
 
-static int ppp_gidle(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int ppp_gidle(unsigned int fd, unsigned int cmd,
+		struct ppp_idle32 __user *idle32)
 {
 	struct ppp_idle __user *idle;
-	struct ppp_idle32 __user *idle32;
 	__kernel_time_t xmit, recv;
 	int err;
 
 	idle = compat_alloc_user_space(sizeof(*idle));
-	idle32 = compat_ptr(arg);
 
 	err = sys_ioctl(fd, PPPIOCGIDLE, (unsigned long) idle);
 
@@ -487,15 +483,14 @@ static int ppp_gidle(unsigned int fd, unsigned int cmd, unsigned long arg)
 	return err;
 }
 
-static int ppp_scompress(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int ppp_scompress(unsigned int fd, unsigned int cmd,
+	struct ppp_option_data32 __user *odata32)
 {
 	struct ppp_option_data __user *odata;
-	struct ppp_option_data32 __user *odata32;
 	__u32 data;
 	void __user *datap;
 
 	odata = compat_alloc_user_space(sizeof(*odata));
-	odata32 = compat_ptr(arg);
 
 	if (get_user(data, &odata32->ptr))
 		return -EFAULT;
@@ -511,35 +506,6 @@ static int ppp_scompress(unsigned int fd, unsigned int cmd, unsigned long arg)
 	return sys_ioctl(fd, PPPIOCSCOMPRESS, (unsigned long) odata);
 }
 
-static int ppp_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	int err;
-
-	switch (cmd) {
-	case PPPIOCGIDLE32:
-		err = ppp_gidle(fd, cmd, arg);
-		break;
-
-	case PPPIOCSCOMPRESS32:
-		err = ppp_scompress(fd, cmd, arg);
-		break;
-
-	default:
-		do {
-			static int count;
-			if (++count <= 20)
-				printk("ppp_ioctl: Unknown cmd fd(%d) "
-				       "cmd(%08x) arg(%08x)\n",
-				       (int)fd, (unsigned int)cmd, (unsigned int)arg);
-		} while(0);
-		err = -EINVAL;
-		break;
-	};
-
-	return err;
-}
-
-
 #ifdef CONFIG_BLOCK
 struct mtget32 {
 	compat_long_t	mt_type;
@@ -557,7 +523,7 @@ struct mtpos32 {
 };
 #define MTIOCPOS32	_IOR('m', 3, struct mtpos32)
 
-static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, void __user *argp)
 {
 	mm_segment_t old_fs = get_fs();
 	struct mtget get;
@@ -577,15 +543,6 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
 		kcmd = MTIOCGET;
 		karg = &get;
 		break;
-	default:
-		do {
-			static int count;
-			if (++count <= 20)
-				printk("mt_ioctl: Unknown cmd fd(%d) "
-				       "cmd(%08x) arg(%08x)\n",
-				       (int)fd, (unsigned int)cmd, (unsigned int)arg);
-		} while(0);
-		return -EINVAL;
 	}
 	set_fs (KERNEL_DS);
 	err = sys_ioctl (fd, kcmd, (unsigned long)karg);
@@ -594,11 +551,11 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
 		return err;
 	switch (cmd) {
 	case MTIOCPOS32:
-		upos32 = compat_ptr(arg);
+		upos32 = argp;
 		err = __put_user(pos.mt_blkno, &upos32->mt_blkno);
 		break;
 	case MTIOCGET32:
-		umget32 = compat_ptr(arg);
+		umget32 = argp;
 		err = __put_user(get.mt_type, &umget32->mt_type);
 		err |= __put_user(get.mt_resid, &umget32->mt_resid);
 		err |= __put_user(get.mt_dsreg, &umget32->mt_dsreg);
@@ -613,7 +570,8 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
 
 #endif /* CONFIG_BLOCK */
 
-static int do_smb_getmountuid(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
+			compat_uid_t __user *argp)
 {
 	mm_segment_t old_fs = get_fs();
 	__kernel_uid_t kuid;
@@ -626,14 +584,15 @@ static int do_smb_getmountuid(unsigned int fd, unsigned int cmd, unsigned long a
 	set_fs(old_fs);
 
 	if (err >= 0)
-		err = put_user(kuid, (compat_uid_t __user *)compat_ptr(arg));
+		err = put_user(kuid, argp);
 
 	return err;
 }
 
-static int ioc_settimeout(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int ioc_settimeout(unsigned int fd, unsigned int cmd,
+		compat_ulong_t __user *argp)
 {
-	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, arg);
+	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, argp);
 }
 
 /* Bluetooth ioctls */
@@ -691,7 +650,8 @@ static int set_raw32_request(struct raw_config_request *req, struct raw32_config
         return ret ? -EFAULT : 0;
 }
 
-static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
+static int raw_ioctl(unsigned fd, unsigned cmd,
+		struct raw32_config_request __user *user_req)
 {
         int ret;
 
@@ -699,7 +659,6 @@ static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
         case RAW_SETBIND:
         case RAW_GETBIND: {
                 struct raw_config_request req;
-                struct raw32_config_request __user *user_req = compat_ptr(arg);
                 mm_segment_t oldfs = get_fs();
 
                 if ((ret = get_raw32_request(&req, user_req)))
@@ -714,9 +673,6 @@ static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
                 }
                 break;
         }
-        default:
-                ret = sys_ioctl(fd, cmd, arg);
-                break;
         }
         return ret;
 }
@@ -744,11 +700,11 @@ struct serial_struct32 {
         compat_int_t    reserved[1];
 };
 
-static int serial_struct_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
+static int serial_struct_ioctl(unsigned fd, unsigned cmd,
+			struct serial_struct32 __user *ss32)
 {
         typedef struct serial_struct SS;
         typedef struct serial_struct32 SS32;
-        struct serial_struct32 __user *ss32 = compat_ptr(arg);
         int err;
         struct serial_struct ss;
         mm_segment_t oldseg = get_fs();
@@ -798,9 +754,9 @@ struct usbdevfs_ctrltransfer32 {
 
 #define USBDEVFS_CONTROL32           _IOWR('U', 0, struct usbdevfs_ctrltransfer32)
 
-static int do_usbdevfs_control(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_usbdevfs_control(unsigned int fd, unsigned int cmd,
+			struct usbdevfs_ctrltransfer32 __user *p32)
 {
-        struct usbdevfs_ctrltransfer32 __user *p32 = compat_ptr(arg);
         struct usbdevfs_ctrltransfer __user *p;
         __u32 udata;
         p = compat_alloc_user_space(sizeof(*p));
@@ -821,9 +777,9 @@ struct usbdevfs_bulktransfer32 {
 
 #define USBDEVFS_BULK32              _IOWR('U', 2, struct usbdevfs_bulktransfer32)
 
-static int do_usbdevfs_bulk(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_usbdevfs_bulk(unsigned int fd, unsigned int cmd,
+			struct usbdevfs_bulktransfer32 __user *p32)
 {
-        struct usbdevfs_bulktransfer32 __user *p32 = compat_ptr(arg);
         struct usbdevfs_bulktransfer __user *p;
         compat_uint_t n;
         compat_caddr_t addr;
@@ -852,16 +808,14 @@ struct usbdevfs_disconnectsignal32 {
 
 #define USBDEVFS_DISCSIGNAL32      _IOR('U', 14, struct usbdevfs_disconnectsignal32)
 
-static int do_usbdevfs_discsignal(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_usbdevfs_discsignal(unsigned int fd, unsigned int cmd,
+			struct usbdevfs_disconnectsignal32 __user *udis)
 {
         struct usbdevfs_disconnectsignal kdis;
-        struct usbdevfs_disconnectsignal32 __user *udis;
         mm_segment_t old_fs;
         u32 uctx;
         int err;
 
-        udis = compat_ptr(arg);
-
         if (get_user(kdis.signr, &udis->signr) ||
             __get_user(uctx, &udis->context))
                 return -EFAULT;
@@ -904,9 +858,9 @@ struct i2c_rdwr_aligned {
 	struct i2c_msg msgs[0];
 };
 
-static int do_i2c_rdwr_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_i2c_rdwr_ioctl(unsigned int fd, unsigned int cmd,
+			struct i2c_rdwr_ioctl_data32    __user *udata)
 {
-	struct i2c_rdwr_ioctl_data32	__user *udata = compat_ptr(arg);
 	struct i2c_rdwr_aligned		__user *tdata;
 	struct i2c_msg			__user *tmsgs;
 	struct i2c_msg32		__user *umsgs;
@@ -940,10 +894,10 @@ static int do_i2c_rdwr_ioctl(unsigned int fd, unsigned int cmd, unsigned long ar
 	return sys_ioctl(fd, cmd, (unsigned long)tdata);
 }
 
-static int do_i2c_smbus_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int do_i2c_smbus_ioctl(unsigned int fd, unsigned int cmd,
+			struct i2c_smbus_ioctl_data32   __user *udata)
 {
 	struct i2c_smbus_ioctl_data	__user *tdata;
-	struct i2c_smbus_ioctl_data32	__user *udata;
 	compat_caddr_t			datap;
 
 	tdata = compat_alloc_user_space(sizeof(*tdata));
@@ -952,7 +906,6 @@ static int do_i2c_smbus_ioctl(unsigned int fd, unsigned int cmd, unsigned long a
 	if (!access_ok(VERIFY_WRITE, tdata, sizeof(*tdata)))
 		return -EFAULT;
 
-	udata = compat_ptr(arg);
 	if (!access_ok(VERIFY_READ, udata, sizeof(*udata)))
 		return -EFAULT;
 
@@ -972,7 +925,7 @@ static int do_i2c_smbus_ioctl(unsigned int fd, unsigned int cmd, unsigned long a
 #define RTC_EPOCH_READ32	_IOR('p', 0x0d, compat_ulong_t)
 #define RTC_EPOCH_SET32		_IOW('p', 0x0e, compat_ulong_t)
 
-static int rtc_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
+static int rtc_ioctl(unsigned fd, unsigned cmd, void __user *argp)
 {
 	mm_segment_t oldfs = get_fs();
 	compat_ulong_t val32;
@@ -990,21 +943,20 @@ static int rtc_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
 		if (ret)
 			return ret;
 		val32 = kval;
-		return put_user(val32, (unsigned int __user *)arg);
+		return put_user(val32, (unsigned int __user *)argp);
 	case RTC_IRQP_SET32:
-		return sys_ioctl(fd, RTC_IRQP_SET, arg); 
+		return sys_ioctl(fd, RTC_IRQP_SET, (unsigned long)argp);
 	case RTC_EPOCH_SET32:
-		return sys_ioctl(fd, RTC_EPOCH_SET, arg);
-	default:
-		/* unreached */
-		return -ENOIOCTLCMD;
+		return sys_ioctl(fd, RTC_EPOCH_SET, (unsigned long)argp);
 	}
+
+	return -ENOIOCTLCMD;
 }
 
 static int
-lp_timeout_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
+lp_timeout_trans(unsigned int fd, unsigned int cmd,
+			struct compat_timeval __user *tc)
 {
-	struct compat_timeval __user *tc = (struct compat_timeval __user *)arg;
 	struct timeval __user *tn = compat_alloc_user_space(sizeof(struct timeval));
 	struct timeval ts;
 	if (get_user(ts.tv_sec, &tc->tv_sec) ||
@@ -1032,9 +984,9 @@ struct space_resv_32 {
 #define FS_IOC_RESVSP64_32	_IOW ('X', 42, struct space_resv_32)
 
 /* just account for different alignment */
-static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
+static int compat_ioctl_preallocate(struct file *file,
+			struct space_resv_32    __user *p32)
 {
-	struct space_resv_32	__user *p32 = compat_ptr(arg);
 	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
@@ -1720,69 +1672,72 @@ IGNORE_IOCTL(FBIOGCURSOR32)
 static long do_ioctl_trans(int fd, unsigned int cmd,
 		 unsigned long arg, struct file *file)
 {
+	void __user *argp = compat_ptr(arg);
+
 	switch (cmd) {
 	case PPPIOCGIDLE32:
+		return ppp_gidle(fd, cmd, argp);
 	case PPPIOCSCOMPRESS32:
-		return ppp_ioctl_trans(fd, cmd, arg);
+		return ppp_scompress(fd, cmd, argp);
 	case PPPIOCSPASS32:
 	case PPPIOCSACTIVE32:
-		return ppp_sock_fprog_ioctl_trans(fd, cmd, arg);
+		return ppp_sock_fprog_ioctl_trans(fd, cmd, argp);
 #ifdef CONFIG_BLOCK
 	case SG_IO:
-		return sg_ioctl_trans(fd, cmd, arg);
+		return sg_ioctl_trans(fd, cmd, argp);
 	case SG_GET_REQUEST_TABLE:
-		return sg_grt_trans(fd, cmd, arg);
+		return sg_grt_trans(fd, cmd, argp);
 	case MTIOCGET32:
 	case MTIOCPOS32:
-		return mt_ioctl_trans(fd, cmd, arg);
+		return mt_ioctl_trans(fd, cmd, argp);
 	/* Raw devices */
 	case RAW_SETBIND:
 	case RAW_GETBIND:
-		return raw_ioctl(fd, cmd, arg);
+		return raw_ioctl(fd, cmd, argp);
 #endif
 #define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
 	case AUTOFS_IOC_SETTIMEOUT32:
-		return ioc_settimeout(fd, cmd, arg);
+		return ioc_settimeout(fd, cmd, argp);
 	/* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
 	case SMB_IOC_GETMOUNTUID_32:
-		return do_smb_getmountuid(fd, cmd, arg);
+		return do_smb_getmountuid(fd, cmd, argp);
 	/* Serial */
 	case TIOCGSERIAL:
 	case TIOCSSERIAL:
-		return serial_struct_ioctl(fd, cmd, arg);
+		return serial_struct_ioctl(fd, cmd, argp);
 	/* Usbdevfs */
 	case USBDEVFS_CONTROL32:
-		return do_usbdevfs_control(fd, cmd, arg);
+		return do_usbdevfs_control(fd, cmd, argp);
 	case USBDEVFS_BULK32:
-		return do_usbdevfs_bulk(fd, cmd, arg);
+		return do_usbdevfs_bulk(fd, cmd, argp);
 	case USBDEVFS_DISCSIGNAL32:
-		return do_usbdevfs_discsignal(fd, cmd, arg);
+		return do_usbdevfs_discsignal(fd, cmd, argp);
 	/* i2c */
 	case I2C_FUNCS:
-		return w_long(fd, cmd, arg);
+		return w_long(fd, cmd, argp);
 	case I2C_RDWR:
-		return do_i2c_rdwr_ioctl(fd, cmd, arg);
+		return do_i2c_rdwr_ioctl(fd, cmd, argp);
 	case I2C_SMBUS:
-		return do_i2c_smbus_ioctl(fd, cmd, arg);
+		return do_i2c_smbus_ioctl(fd, cmd, argp);
 	/* Not implemented in the native kernel */
 	case RTC_IRQP_READ32:
 	case RTC_IRQP_SET32:
 	case RTC_EPOCH_READ32:
 	case RTC_EPOCH_SET32:
-		return rtc_ioctl(fd, cmd, arg);
+		return rtc_ioctl(fd, cmd, argp);
 
 	/* dvb */
 	case VIDEO_GET_EVENT:
-		return do_video_get_event(fd, cmd, arg);
+		return do_video_get_event(fd, cmd, argp);
 	case VIDEO_STILLPICTURE:
-		return do_video_stillpicture(fd, cmd, arg);
+		return do_video_stillpicture(fd, cmd, argp);
 	case VIDEO_SET_SPU_PALETTE:
-		return do_video_set_spu_palette(fd, cmd, arg);
+		return do_video_set_spu_palette(fd, cmd, argp);
 
 	/* lp */
 	case LPSETTIMEOUT:
-		return lp_timeout_trans(fd, cmd, arg);
+		return lp_timeout_trans(fd, cmd, argp);
 	}
 
 	/*
@@ -1907,7 +1862,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 	case FS_IOC_RESVSP_32:
 	case FS_IOC_RESVSP64_32:
-		error = compat_ioctl_preallocate(filp, arg);
+		error = compat_ioctl_preallocate(filp, compat_ptr(arg));
 		goto out_fput;
 #else
 	case FS_IOC_RESVSP:
-- 
1.6.3.3

