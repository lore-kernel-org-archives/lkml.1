Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYEPJy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYEPJy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYEPJys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:54:48 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49871 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752563AbYEPJyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:54:47 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 09/10] HID: add compat support
Date: Fri, 16 May 2008 11:49:22 +0200
Message-Id: <1210931362-18422-9-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compat option to hid code to allow loading of all modules on
systems which don't allow autoloading because of old userspace.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    7 +++++++
 drivers/hid/Kconfig                        |   11 +++++++++++
 drivers/hid/Makefile                       |    4 ++++
 drivers/hid/hid-apple.c                    |    2 ++
 drivers/hid/hid-core.c                     |   12 ++++++++++++
 drivers/hid/hid-dummy.c                    |   13 +++++++++++++
 drivers/hid/hid-logitech.c                 |    2 ++
 include/linux/hid.h                        |   17 +++++++++++++++--
 8 files changed, 66 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hid/hid-dummy.c

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3c35d45..1564e87 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -289,6 +289,13 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
 ---------------------------
 
+What:	remove HID compat support
+When:	2.6.29
+Why:	needed only as a temporary solution until distros fix themselves up
+Who:	Jiri Slaby <jirislaby@gmail.com>
+
+---------------------------
+
 What:	/sys/o2cb symlink
 When:	January 2010
 Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 9a9fd7d..ba9ca39 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -70,6 +70,17 @@ source "drivers/hid/usbhid/Kconfig"
 menu "Special HID drivers"
 	depends on HID
 
+config HID_COMPAT
+	bool "Load all HID drivers on hid core load"
+	---help---
+	Compatible option for older userspace. If you have system without udev
+	support of module loading through aliases and also old
+	module-init-tools which can't handle hid bus, choose Y here. Otherwise
+	say N. If you say N and your userspace is old enough, the only
+	functionality you loose is modules autoloading.
+
+	If unsure, say N.
+
 config HID_LOGITECH
 	tristate "Logitech"
 	default m
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 8a5cbbe..ccc169d 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -8,6 +8,10 @@ obj-$(CONFIG_HID)		+= hid.o
 hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
+ifdef CONFIG_HID_COMPAT
+obj-m				+= hid-dummy.o
+endif
+
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index b39d25c..325d27f 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -464,3 +464,5 @@ static void apple_exit(void)
 module_init(apple_init);
 module_exit(apple_exit);
 MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(hid_apple);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index be080d4..5134d41 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1565,6 +1565,14 @@ void hid_unregister_driver(struct hid_driver *hdrv)
 }
 EXPORT_SYMBOL_GPL(hid_unregister_driver);
 
+#ifdef CONFIG_HID_COMPAT
+static void hid_compat_load(struct work_struct *ws)
+{
+	request_module("hid-dummy");
+}
+static DECLARE_WORK(hid_compat_work, hid_compat_load);
+#endif
+
 static int __init hid_init(void)
 {
 	int ret;
@@ -1579,6 +1587,10 @@ static int __init hid_init(void)
 	if (ret)
 		goto err_bus;
 
+#ifdef CONFIG_HID_COMPAT
+	schedule_work(&hid_compat_work);
+#endif
+
 	return 0;
 err_bus:
 	bus_unregister(&hid_bus_type);
diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
new file mode 100644
index 0000000..b426134
--- /dev/null
+++ b/drivers/hid/hid-dummy.c
@@ -0,0 +1,13 @@
+#include <linux/module.h>
+#include <linux/hid.h>
+
+static int __init hid_dummy_init(void)
+{
+	HID_COMPAT_CALL_DRIVER(hid_logitech);
+	HID_COMPAT_CALL_DRIVER(hid_apple);
+
+	return -EIO;
+}
+module_init(hid_dummy_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-logitech.c b/drivers/hid/hid-logitech.c
index 5b145c9..6a70ca9 100644
--- a/drivers/hid/hid-logitech.c
+++ b/drivers/hid/hid-logitech.c
@@ -72,3 +72,5 @@ static void lg_exit(void)
 module_init(lg_init);
 module_exit(lg_exit);
 MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(hid_logitech);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c67e5fe..447aed9 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -784,10 +784,23 @@ dbg_hid(const char *fmt, ...)
 	return 0;
 }
 #define dbg_hid_line dbg_hid
-#endif
+#endif /* HID_DEBUG */
 
 #define err_hid(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
 		__FILE__ , ## arg)
-#endif
+#endif /* HID_FF */
+
+#ifdef CONFIG_HID_COMPAT
+#define HID_COMPAT_LOAD_DRIVER(name)	\
+void hid_compat_##name(void) { }	\
+EXPORT_SYMBOL(hid_compat_##name)
+#else
+#define HID_COMPAT_LOAD_DRIVER(name)
+#endif /* HID_COMPAT */
+#define HID_COMPAT_CALL_DRIVER(name)	do {	\
+	extern void hid_compat_##name(void);	\
+	hid_compat_##name();			\
+} while (0)
+
 #endif
 
-- 
1.5.4.5

