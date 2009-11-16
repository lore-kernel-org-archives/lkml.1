Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZKPA2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZKPA2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZKPA2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:28:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbZKPA16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Alon Bar-Lev <alon.barlev@gmail.com>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org
Subject: [PATCH 10/12] usbdevfs: move compat_ioctl handling to devio.c
Date: Mon, 16 Nov 2009 00:27:05 +0000
Message-Id: <1258331227-1694-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+vsPIoUfQ8dfk7AHcn+ufIHxfzzHSii6+nXTr
 y6yYNWP6wqK5pq7m+P/h1Du7dlVCt+OiOZXf6oh1HUCseXE1hO
 sqLcKgcAO+ypP4BAO/wqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Half the compat_ioctl handling is in devio.c, the other
half is in fs/compat_ioctl.c. This moves everything into
one place for consistency.

As a positive side-effect, push down the BKL into the
ioctl methods.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/core/devio.c     |  110 ++++++++++++++++++++++++++++++++++++----
 fs/compat_ioctl.c            |  113 +-----------------------------------------
 include/linux/usbdevice_fs.h |   26 ++++++++++
 3 files changed, 126 insertions(+), 123 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 181f78c..6e8bcdf 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1388,6 +1388,46 @@ static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 }
 
 #ifdef CONFIG_COMPAT
+static int proc_control_compat(struct dev_state *ps,
+				struct usbdevfs_ctrltransfer32 __user *p32)
+{
+        struct usbdevfs_ctrltransfer __user *p;
+        __u32 udata;
+        p = compat_alloc_user_space(sizeof(*p));
+        if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
+            get_user(udata, &p32->data) ||
+	    put_user(compat_ptr(udata), &p->data))
+		return -EFAULT;
+        return proc_control(ps, p);
+}
+
+static int proc_bulk_compat(struct dev_state *ps,
+			struct usbdevfs_bulktransfer32 __user *p32)
+{
+        struct usbdevfs_bulktransfer __user *p;
+        compat_uint_t n;
+        compat_caddr_t addr;
+
+        p = compat_alloc_user_space(sizeof(*p));
+
+        if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
+            get_user(n, &p32->len) || put_user(n, &p->len) ||
+            get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
+            get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
+                return -EFAULT;
+
+        return proc_bulk(ps, p);
+}
+static int proc_disconnectsignal_compat(struct dev_state *ps, void __user *arg)
+{
+	struct usbdevfs_disconnectsignal32 ds;
+
+	if (copy_from_user(&ds, arg, sizeof(ds)))
+		return -EFAULT;
+	ps->discsignr = ds.signr;
+	ps->disccontext = compat_ptr(ds.context);
+	return 0;
+}
 
 static int get_urb32(struct usbdevfs_urb *kurb,
 		     struct usbdevfs_urb32 __user *uurb)
@@ -1482,6 +1522,7 @@ static int proc_reapurbnonblock_compat(struct dev_state *ps, void __user *arg)
 	return processcompl_compat(as, (void __user * __user *)arg);
 }
 
+
 #endif
 
 static int proc_disconnectsignal(struct dev_state *ps, void __user *arg)
@@ -1648,12 +1689,12 @@ static int proc_release_port(struct dev_state *ps, void __user *arg)
  * are assuming that somehow the configuration has been prevented from
  * changing.  But there's no mechanism to ensure that...
  */
-static int usbdev_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long usbdev_do_ioctl(struct file *file, unsigned int cmd,
+				void __user *p)
 {
 	struct dev_state *ps = file->private_data;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct usb_device *dev = ps->dev;
-	void __user *p = (void __user *)arg;
 	int ret = -ENOTTY;
 
 	if (!(file->f_mode & FMODE_WRITE))
@@ -1726,6 +1767,24 @@ static int usbdev_ioctl(struct inode *inode, struct file *file,
 		break;
 
 #ifdef CONFIG_COMPAT
+	case USBDEVFS_CONTROL32:
+		snoop(&dev->dev, "%s: CONTROL32\n", __func__);
+		ret = proc_control_compat(ps, p);
+		if (ret >= 0)
+			inode->i_mtime = CURRENT_TIME;
+		break;
+
+	case USBDEVFS_BULK32:
+		snoop(&dev->dev, "%s: BULK32\n", __func__);
+		ret = proc_bulk_compat(ps, p);
+		if (ret >= 0)
+			inode->i_mtime = CURRENT_TIME;
+		break;
+
+	case USBDEVFS_DISCSIGNAL32:
+		snoop(&dev->dev, "%s: DISCSIGNAL32\n", __func__);
+		ret = proc_disconnectsignal_compat(ps, p);
+		break;
 
 	case USBDEVFS_SUBMITURB32:
 		snoop(&dev->dev, "%s: SUBMITURB32\n", __func__);
@@ -1745,7 +1804,7 @@ static int usbdev_ioctl(struct inode *inode, struct file *file,
 		break;
 
 	case USBDEVFS_IOCTL32:
-		snoop(&dev->dev, "%s: IOCTL\n", __func__);
+		snoop(&dev->dev, "%s: IOCTL32\n", __func__);
 		ret = proc_ioctl_compat(ps, ptr_to_compat(p));
 		break;
 #endif
@@ -1801,6 +1860,32 @@ static int usbdev_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
+static long usbdev_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = usbdev_do_ioctl(file, cmd, (void __user *)arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long usbdev_compat_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = usbdev_do_ioctl(file, cmd, compat_ptr(arg));
+	unlock_kernel();
+
+	return ret;
+}
+#endif
+
 /* No kernel lock - fine */
 static unsigned int usbdev_poll(struct file *file,
 				struct poll_table_struct *wait)
@@ -1817,13 +1902,16 @@ static unsigned int usbdev_poll(struct file *file,
 }
 
 const struct file_operations usbdev_file_operations = {
-	.owner = 	THIS_MODULE,
-	.llseek =	usbdev_lseek,
-	.read =		usbdev_read,
-	.poll =		usbdev_poll,
-	.ioctl =	usbdev_ioctl,
-	.open =		usbdev_open,
-	.release =	usbdev_release,
+	.owner =	  THIS_MODULE,
+	.llseek =	  usbdev_lseek,
+	.read =		  usbdev_read,
+	.poll =		  usbdev_poll,
+	.unlocked_ioctl = usbdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =   usbdev_compat_ioctl,
+#endif
+	.open =		  usbdev_open,
+	.release =	  usbdev_release,
 };
 
 static void usbdev_remove(struct usb_device *udev)
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 68929a2..1fef181 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -588,94 +588,6 @@ static int serial_struct_ioctl(unsigned fd, unsigned cmd,
         return err;
 }
 
-struct usbdevfs_ctrltransfer32 {
-        u8 bRequestType;
-        u8 bRequest;
-        u16 wValue;
-        u16 wIndex;
-        u16 wLength;
-        u32 timeout;  /* in milliseconds */
-        compat_caddr_t data;
-};
-
-#define USBDEVFS_CONTROL32           _IOWR('U', 0, struct usbdevfs_ctrltransfer32)
-
-static int do_usbdevfs_control(unsigned int fd, unsigned int cmd,
-			struct usbdevfs_ctrltransfer32 __user *p32)
-{
-        struct usbdevfs_ctrltransfer __user *p;
-        __u32 udata;
-        p = compat_alloc_user_space(sizeof(*p));
-        if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
-            get_user(udata, &p32->data) ||
-	    put_user(compat_ptr(udata), &p->data))
-		return -EFAULT;
-        return sys_ioctl(fd, USBDEVFS_CONTROL, (unsigned long)p);
-}
-
-
-struct usbdevfs_bulktransfer32 {
-        compat_uint_t ep;
-        compat_uint_t len;
-        compat_uint_t timeout; /* in milliseconds */
-        compat_caddr_t data;
-};
-
-#define USBDEVFS_BULK32              _IOWR('U', 2, struct usbdevfs_bulktransfer32)
-
-static int do_usbdevfs_bulk(unsigned int fd, unsigned int cmd,
-			struct usbdevfs_bulktransfer32 __user *p32)
-{
-        struct usbdevfs_bulktransfer __user *p;
-        compat_uint_t n;
-        compat_caddr_t addr;
-
-        p = compat_alloc_user_space(sizeof(*p));
-
-        if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
-            get_user(n, &p32->len) || put_user(n, &p->len) ||
-            get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
-            get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
-                return -EFAULT;
-
-        return sys_ioctl(fd, USBDEVFS_BULK, (unsigned long)p);
-}
-
-
-/*
- *  USBDEVFS_SUBMITURB, USBDEVFS_REAPURB and USBDEVFS_REAPURBNDELAY
- *  are handled in usbdevfs core.			-Christopher Li
- */
-
-struct usbdevfs_disconnectsignal32 {
-        compat_int_t signr;
-        compat_caddr_t context;
-};
-
-#define USBDEVFS_DISCSIGNAL32      _IOR('U', 14, struct usbdevfs_disconnectsignal32)
-
-static int do_usbdevfs_discsignal(unsigned int fd, unsigned int cmd,
-			struct usbdevfs_disconnectsignal32 __user *udis)
-{
-        struct usbdevfs_disconnectsignal kdis;
-        mm_segment_t old_fs;
-        u32 uctx;
-        int err;
-
-        if (get_user(kdis.signr, &udis->signr) ||
-            __get_user(uctx, &udis->context))
-                return -EFAULT;
-
-        kdis.context = compat_ptr(uctx);
-
-        old_fs = get_fs();
-        set_fs(KERNEL_DS);
-        err = sys_ioctl(fd, USBDEVFS_DISCSIGNAL, (unsigned long) &kdis);
-        set_fs(old_fs);
-
-        return err;
-}
-
 #define RTC_IRQP_READ32		_IOR('p', 0x0b, compat_ulong_t)
 #define RTC_IRQP_SET32		_IOW('p', 0x0c, compat_ulong_t)
 #define RTC_EPOCH_READ32	_IOR('p', 0x0d, compat_ulong_t)
@@ -1187,21 +1099,6 @@ COMPATIBLE_IOCTL(PCIIOC_CONTROLLER)
 COMPATIBLE_IOCTL(PCIIOC_MMAP_IS_IO)
 COMPATIBLE_IOCTL(PCIIOC_MMAP_IS_MEM)
 COMPATIBLE_IOCTL(PCIIOC_WRITE_COMBINE)
-/* USB */
-COMPATIBLE_IOCTL(USBDEVFS_RESETEP)
-COMPATIBLE_IOCTL(USBDEVFS_SETINTERFACE)
-COMPATIBLE_IOCTL(USBDEVFS_SETCONFIGURATION)
-COMPATIBLE_IOCTL(USBDEVFS_GETDRIVER)
-COMPATIBLE_IOCTL(USBDEVFS_DISCARDURB)
-COMPATIBLE_IOCTL(USBDEVFS_CLAIMINTERFACE)
-COMPATIBLE_IOCTL(USBDEVFS_RELEASEINTERFACE)
-COMPATIBLE_IOCTL(USBDEVFS_CONNECTINFO)
-COMPATIBLE_IOCTL(USBDEVFS_HUB_PORTINFO)
-COMPATIBLE_IOCTL(USBDEVFS_RESET)
-COMPATIBLE_IOCTL(USBDEVFS_SUBMITURB32)
-COMPATIBLE_IOCTL(USBDEVFS_REAPURB32)
-COMPATIBLE_IOCTL(USBDEVFS_REAPURBNDELAY32)
-COMPATIBLE_IOCTL(USBDEVFS_CLEAR_HALT)
 /* hiddev */
 COMPATIBLE_IOCTL(HIDIOCGVERSION)
 COMPATIBLE_IOCTL(HIDIOCAPPLICATION)
@@ -1307,8 +1204,6 @@ COMPATIBLE_IOCTL(TIOCSLTC)
 COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
-/* Usbdevfs */
-COMPATIBLE_IOCTL(USBDEVFS_IOCTL32)
 
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
@@ -1367,13 +1262,7 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case TIOCGSERIAL:
 	case TIOCSSERIAL:
 		return serial_struct_ioctl(fd, cmd, argp);
-	/* Usbdevfs */
-	case USBDEVFS_CONTROL32:
-		return do_usbdevfs_control(fd, cmd, argp);
-	case USBDEVFS_BULK32:
-		return do_usbdevfs_bulk(fd, cmd, argp);
-	case USBDEVFS_DISCSIGNAL32:
-		return do_usbdevfs_discsignal(fd, cmd, argp);
+
 	/* Not implemented in the native kernel */
 	case RTC_IRQP_READ32:
 	case RTC_IRQP_SET32:
diff --git a/include/linux/usbdevice_fs.h b/include/linux/usbdevice_fs.h
index b2a7d8b..15591d2 100644
--- a/include/linux/usbdevice_fs.h
+++ b/include/linux/usbdevice_fs.h
@@ -128,6 +128,29 @@ struct usbdevfs_hub_portinfo {
 #ifdef __KERNEL__
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
+
+struct usbdevfs_ctrltransfer32 {
+        u8 bRequestType;
+        u8 bRequest;
+        u16 wValue;
+        u16 wIndex;
+        u16 wLength;
+        u32 timeout;  /* in milliseconds */
+        compat_caddr_t data;
+};
+
+struct usbdevfs_bulktransfer32 {
+        compat_uint_t ep;
+        compat_uint_t len;
+        compat_uint_t timeout; /* in milliseconds */
+        compat_caddr_t data;
+};
+
+struct usbdevfs_disconnectsignal32 {
+        compat_int_t signr;
+        compat_caddr_t context;
+};
+
 struct usbdevfs_urb32 {
 	unsigned char type;
 	unsigned char endpoint;
@@ -153,7 +176,9 @@ struct usbdevfs_ioctl32 {
 #endif /* __KERNEL__ */
 
 #define USBDEVFS_CONTROL           _IOWR('U', 0, struct usbdevfs_ctrltransfer)
+#define USBDEVFS_CONTROL32           _IOWR('U', 0, struct usbdevfs_ctrltransfer32)
 #define USBDEVFS_BULK              _IOWR('U', 2, struct usbdevfs_bulktransfer)
+#define USBDEVFS_BULK32              _IOWR('U', 2, struct usbdevfs_bulktransfer32)
 #define USBDEVFS_RESETEP           _IOR('U', 3, unsigned int)
 #define USBDEVFS_SETINTERFACE      _IOR('U', 4, struct usbdevfs_setinterface)
 #define USBDEVFS_SETCONFIGURATION  _IOR('U', 5, unsigned int)
@@ -166,6 +191,7 @@ struct usbdevfs_ioctl32 {
 #define USBDEVFS_REAPURBNDELAY     _IOW('U', 13, void *)
 #define USBDEVFS_REAPURBNDELAY32   _IOW('U', 13, __u32)
 #define USBDEVFS_DISCSIGNAL        _IOR('U', 14, struct usbdevfs_disconnectsignal)
+#define USBDEVFS_DISCSIGNAL32      _IOR('U', 14, struct usbdevfs_disconnectsignal32)
 #define USBDEVFS_CLAIMINTERFACE    _IOR('U', 15, unsigned int)
 #define USBDEVFS_RELEASEINTERFACE  _IOR('U', 16, unsigned int)
 #define USBDEVFS_CONNECTINFO       _IOW('U', 17, struct usbdevfs_connectinfo)
-- 
1.6.3.3

