Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYFEJxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYFEJxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbYFEJwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:52:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYFEJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:52:37 -0400
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080605.foo@pmac.infradead.org>
References: <20080605.foo@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
Date: Fri, 23 May 2008 13:52:42 +0100
Subject: [PATCH 01/18] firmware: allow firmware files to be built into kernel image
Message-Id: <E1K4C96-0001c9-Kg@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers have their own hacks to bypass the kernel's firmware loader
and build their firmware into the kernel; this renders those unnecessary.

Other drivers don't use the firmware loader at all, because they always
want the firmware to be available. This allows them to start using the
firmware loader.

A third set of drivers already use the firmware loader, but can't be
used without help from userspace, which sometimes requires an initrd.
This allows them to work in a static kernel.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/base/firmware_class.c     |   33 +++++++++++++++++++++++++++++++--
 include/asm-generic/vmlinux.lds.h |    7 +++++++
 include/linux/firmware.h          |   21 +++++++++++++++++++++
 3 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 264b3a2..b0be1d1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -49,6 +49,14 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
+#ifdef CONFIG_FW_LOADER
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+#else /* Module case. Avoid ifdefs later; it'll all optimise out */
+static struct builtin_fw *__start_builtin_fw;
+static struct builtin_fw *__end_builtin_fw;
+#endif
+
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
@@ -391,13 +399,12 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
+	struct builtin_fw *builtin;
 	int retval;
 
 	if (!firmware_p)
 		return -EINVAL;
 
-	printk(KERN_INFO "firmware: requesting %s\n", name);
-
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
@@ -406,6 +413,20 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
+	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+	     builtin++) {
+		if (strcmp(name, builtin->name))
+			continue;
+		printk(KERN_INFO "firmware: using built-in firmware %s\n",
+		       name);
+		firmware->size = builtin->size;
+		firmware->data = builtin->data;
+		return 0;
+	}
+
+	if (uevent)
+		printk(KERN_INFO "firmware: requesting %s\n", name);
+
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
 		goto error_kfree_fw;
@@ -473,8 +494,16 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 void
 release_firmware(const struct firmware *fw)
 {
+	struct builtin_fw *builtin;
+
 	if (fw) {
+		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+		     builtin++) {
+			if (fw->data == builtin->data)
+				goto free_fw;
+		}
 		vfree(fw->data);
+	free_fw:
 		kfree(fw);
 	}
 }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..8d71a40 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -86,6 +86,13 @@
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
 	}								\
 									\
+	/* Built-in firmware blobs */					\
+	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
+		*(.builtin_fw)						\
+		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
+	}								\
+									\
 	/* RapidIO route ops */						\
 	.rio_route        : AT(ADDR(.rio_route) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_rio_route_ops) = .;		\
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5e73f3f..785accf 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -1,7 +1,10 @@
 #ifndef _LINUX_FIRMWARE_H
 #define _LINUX_FIRMWARE_H
+
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/compiler.h>
+
 #define FIRMWARE_NAME_MAX 30 
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
@@ -13,6 +16,24 @@ struct firmware {
 
 struct device;
 
+struct builtin_fw {
+	char *name;
+	void *data;
+	unsigned long size;
+};
+
+/* We have to play tricks here much like stringify() to get the
+   __COUNTER__ macro to be expanded as we want it */
+#define __fw_concat1(x, y) x##y
+#define __fw_concat(x, y) __fw_concat1(x, y)
+
+#define DECLARE_BUILTIN_FIRMWARE(name, blob)				     \
+	DECLARE_BUILTIN_FIRMWARE_SIZE(name, &(blob), sizeof(blob))
+
+#define DECLARE_BUILTIN_FIRMWARE_SIZE(name, blob, size)			     \
+	static const struct builtin_fw __fw_concat(__builtin_fw,__COUNTER__) \
+	__used __section(.builtin_fw) = { name, blob, size }
+
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
-- 
1.5.4.5

