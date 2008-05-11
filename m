Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbYEKUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbYEKUHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYEKUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:07:15 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:45624 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757653AbYEKUHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:07:13 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 9/9] HID: add compat support
Date: Sun, 11 May 2008 22:00:43 +0200
Message-Id: <1210536043-19812-9-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210536043-19812-8-git-send-email-jirislaby@gmail.com>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-3-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-4-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-5-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-6-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-7-git-send-email-jirislaby@gmail.com>
 <1210536043-19812-8-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compat option to hid code to allow loading of all modules on
systems which don't allow autoloading because of old userspace.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 drivers/hid/Kconfig        |   11 +++++++++++
 drivers/hid/Makefile       |   22 ++++++++++++++++++++++
 drivers/hid/hid-apple.c    |    2 ++
 drivers/hid/hid-core.c     |   12 ++++++++++++
 drivers/hid/hid-dummy.c    |   11 +++++++++++
 drivers/hid/hid-logitech.c |    2 ++
 include/linux/hid.h        |   13 +++++++++++--
 7 files changed, 71 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hid/hid-dummy.c

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
index 8a5cbbe..c5bca8f 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -15,3 +15,25 @@ obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
 obj-$(CONFIG_USB_KBD)		+= usbhid/
 
+targets := hid-dummy.h
+
+ifdef CONFIG_HID_COMPAT
+
+obj-m		+= hid-dummy.o
+
+$(srctree)/$(src)/hid-dummy.c: $(obj)/hid-dummy.h
+
+$(obj)/hid-dummy.h: $(filter-out $(srctree)/drivers/hid/hid-dummy.c,$(wildcard $(srctree)/drivers/hid/*.c))
+	@echo -e 'static void __always_inline hid_dummy_load(void)\n{' > $@
+	@FUNS=`grep -h 'HID_COMPAT_LOAD_DRIVER(' $(srctree)/drivers/hid/*.c | \
+	sed -e 's/HID_COMPAT_LOAD_DRIVER( *\([^ ]*\) *) *;/\1/'`; \
+	for FUN in $$FUNS; do \
+		echo -e "\textern void hid_compat_$$FUN(void);"; \
+	done >> $@; \
+	echo >> $@; \
+	for FUN in $$FUNS; do \
+		echo -e "\thid_compat_$$FUN();"; \
+	done >> $@
+	@echo "}" >> $@
+
+endif
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index ce1c21f..b9f4b35 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -469,3 +469,5 @@ static void apple_exit(void)
 module_init(apple_init);
 module_exit(apple_exit);
 MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(hid_apple);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 07676f2..e6532ec 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1570,6 +1570,14 @@ void hid_unregister_driver(struct hid_driver *hdrv)
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
@@ -1584,6 +1592,10 @@ static int __init hid_init(void)
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
index 0000000..8887188
--- /dev/null
+++ b/drivers/hid/hid-dummy.c
@@ -0,0 +1,11 @@
+#include <linux/module.h>
+#include "hid-dummy.h"
+
+static int __init hid_dummy_init(void)
+{
+	hid_dummy_load();
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
index b3669da..4dca3cc 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -784,10 +784,19 @@ dbg_hid(const char *fmt, ...)
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
+
 #endif
 
-- 
1.5.4.5

