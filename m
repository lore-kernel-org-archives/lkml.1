Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbYEWNsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbYEWNsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYEWNov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbYEWNot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:49 -0400
Subject: [PATCH 1/3] firmware: allow firmware files to be built into kernel
	image
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 14:44:42 +0100
Message-Id: <1211550282.28967.8.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
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
 drivers/base/firmware_class.c     |   22 ++++++++++++++++++++--
 include/asm-generic/vmlinux.lds.h |    7 +++++++
 include/linux/firmware.h          |   20 ++++++++++++++++++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 9fd4a85..55b9c80 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -49,6 +49,9 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
@@ -391,13 +394,12 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
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
@@ -406,6 +408,22 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
+	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+	     builtin++) {
+		if (strcmp(name, builtin->name))
+			continue;
+		printk(KERN_INFO "firmware: using built-in firmware %s\n",
+		       name);
+		firmware->data = vmalloc(builtin->size);
+		if (!firmware->data)
+			return -ENOMEM;
+		firmware->size = builtin->size;
+		memcpy(firmware->data, builtin->data, builtin->size);
+		return 0;
+	}
+	if (uevent)
+		printk(KERN_INFO "firmware: requesting %s\n", name);
+
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
 		goto error_kfree_fw;
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
index 4d10c73..d014589 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -13,6 +13,26 @@ struct firmware {
 
 struct device;
 
+struct builtin_fw {
+	char *name;
+	void *data;
+	unsigned long size;
+};
+
+/* We have to play tricks here much like stringify() to get the
+   __COUNTER__ macro to be expanded as we want it */
+#define __fw_concat1(x,y) x##y
+#define __fw_concat(x,y) __fw_concat1(x,y)
+
+#define DECLARE_BUILTIN_FIRMWARE(name, blob)				\
+	DECLARE_BUILTIN_FIRMWARE_SIZE(name, &(blob), sizeof(blob))
+
+
+#define DECLARE_BUILTIN_FIRMWARE_SIZE(name, blob, size)			     \
+	static const struct builtin_fw __fw_concat(__builtin_fw,__COUNTER__) \
+	__used __attribute__((__section__(".builtin_fw"))) =		     \
+	{ name, blob, size }
+
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
-- 
1.5.4.5


-- 
dwmw2
-- 
dwmw2

