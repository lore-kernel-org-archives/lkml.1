Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYEWTml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYEWTml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYEWTmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:42:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbYEWTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:42:30 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org
In-Reply-To: <1211570047.28967.75.camel@pmac.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
	 <1211554711.28967.25.camel@pmac.infradead.org>
	 <20080523163303.492c89e4@core>
	 <1211570047.28967.75.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 20:42:23 +0100
Message-Id: <1211571743.28967.83.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 20:14 +0100, David Woodhouse wrote:
> On Fri, 2008-05-23 at 16:33 +0100, Alan Cox wrote:
> > > Yeah, I thought about that. I was slightly concerned that drivers might
> > > actually try to _modify_ the firmware they loaded, though. As it is,
> > > there's no fundamental reason why they shouldn't do that.
> > 
> > I've not seen any that do and judicious use of "const" should catch
> > offenders.
> 
> Like this one...

That's fairly much the kind of thing I was expecting we might see, I'm
not sure it's reasonable to suddenly declare that overwriting the
firmware is forbidden. I'd done the version which avoided the extra
vmalloc and copy, but I've just reverted it.

Here's the full patch in the git tree
(git.infradead.org/users/dwmw2/firmware.git) now. Did I miss something?

I think the only think I haven't addressed is the dependency on HOTPLUG.
I'm comfortable leaving that as-is for now. If/when we want to convert a
driver where that dependency is an issue, we can take a closer look.

diff --git a/Makefile b/Makefile
index 20b3235..ac2ab7e 100644
--- a/Makefile
+++ b/Makefile
@@ -450,7 +450,7 @@ scripts: scripts_basic include/config/auto.conf
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
-drivers-y	:= drivers/ sound/
+drivers-y	:= drivers/ sound/ firmware/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d7da109..687f097 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -34,6 +34,18 @@ config FW_LOADER
 	  require userspace firmware loading support, but a module built outside
 	  the kernel tree does.
 
+config BUILTIN_FIRMWARE
+       string "Firmware blobs to build into the kernel binary"
+       depends on FW_LOADER
+       help
+         This option allows firmware to be built into the kernel, for the cases
+	 where the user either cannot or doesn't want to provide it from
+	 userspace at runtime (for example, when the firmware in question is
+	 required for accessing the boot device, and the user doesn't want to
+	 use an initrd). Multiple files should be separated with spaces, and
+	 the required files should exist under the firmware/ directory in
+	 the source tree.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 9fd4a85..3abf57d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -49,6 +49,14 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
+#ifdef CONFIG_FW_LOADER
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+#else /* Module case. Avoid ifdefs later; it'll all optimise out */
+static struct builtin_fw *__start_builtin_fw = NULL;
+static struct builtin_fw *__end_builtin_fw = NULL;
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
@@ -406,6 +413,25 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
+	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+	     builtin++) {
+		if (strcmp(name, builtin->name))
+			continue;
+		printk(KERN_INFO "firmware: using built-in firmware %s\n",
+		       name);
+		firmware->data = vmalloc(builtin->size);
+		if (!firmware->data) {
+			retval = -ENOMEM;
+			goto out;
+		}
+		memcpy(firmware->data, builtin->data, builtin->size);
+		firmware->size = builtin->size;
+		return 0;
+	}
+
+	if (uevent)
+		printk(KERN_INFO "firmware: requesting %s\n", name);
+
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
 		goto error_kfree_fw;
diff --git a/firmware/Makefile b/firmware/Makefile
new file mode 100644
index 0000000..f6b0c3c
--- /dev/null
+++ b/firmware/Makefile
@@ -0,0 +1,24 @@
+#
+# kbuild file for firmware/
+#
+
+firmware_bins := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
+firmware_objs := $(patsubst %,%.o, $(firmware_bins))
+firmware_srcs := $(patsubst %,$(obj)/%.c, $(firmware_bins))
+
+
+quiet_cmd_fwbin = MK_FW   $@
+      cmd_fwbin = echo '/* File automatically generated */' > $@ ;	\
+		  echo '\#include <linux/firmware.h>' >> $@ ;		\
+		  echo 'static const unsigned char fw[] = {' >> $@ ;	\
+		  od -t x1 -A none -v $(srctree)/$(patsubst %.c,%,$@) | \
+		   sed -e 's/ /, 0x/g' -e 's/^,//' -e 's/$$/,/' >> $@ ; \
+		  echo '};' >> $@ ;					\
+		  echo 'DECLARE_BUILTIN_FIRMWARE("$(patsubst firmware/%.c,%,$@)",fw);' >> $@
+
+$(firmware_srcs): $(obj)/%.c: $(srctree)/$(obj)/%
+	$(call cmd,fwbin)
+
+obj-y := $(firmware_objs)
+
+targets := $(firmware_objs)
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
index 4d10c73..a6d5be3 100644
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
+#define __fw_concat1(x,y) x##y
+#define __fw_concat(x,y) __fw_concat1(x,y)
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
diff --git a/sound/pci/korg1212/Makefile b/sound/pci/korg1212/Makefile
index f11ce1b..7a5ebdf 100644
--- a/sound/pci/korg1212/Makefile
+++ b/sound/pci/korg1212/Makefile
@@ -7,3 +7,4 @@ snd-korg1212-objs := korg1212.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_KORG1212) += snd-korg1212.o
+obj-$(CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL) += korg1212-firmware.o
diff --git a/sound/pci/korg1212/korg1212-firmware.h b/sound/pci/korg1212/korg1212-firmware.c
similarity index 99%
rename from sound/pci/korg1212/korg1212-firmware.h
rename to sound/pci/korg1212/korg1212-firmware.c
index f6f5b91..2468ee2 100644
--- a/sound/pci/korg1212/korg1212-firmware.h
+++ b/sound/pci/korg1212/korg1212-firmware.c
@@ -1,3 +1,4 @@
+#include <linux/firmware.h>
 static char dspCode [] = {
 0x01,0xff,0x18,0xff,0xf5,0xff,0xcf,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
 0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
@@ -985,3 +986,6 @@ static char dspCode [] = {
 0x00,0xff,0x40,0xff,0xff,0xff,0xc4,0xff,0x00,0xff,0x0a,0xff,0xff,0xff,0x0f,0xff,
 0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
 0xff,0xff,0xff,0xff };
+
+DECLARE_BUILTIN_FIRMWARE("korg/k1212.dsp", dspCode);
+
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index f4c85b5..4a44c0f 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -260,14 +260,6 @@ enum MonitorModeSelector {
 #define COMMAND_ACK_DELAY   13         // number of RTC ticks to wait for an acknowledgement
                                        //    from the card after sending a command.
 
-#ifdef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
-#include "korg1212-firmware.h"
-static const struct firmware static_dsp_code = {
-	.data = (u8 *)dspCode,
-	.size = sizeof dspCode
-};
-#endif
-
 enum ClockSourceIndex {
    K1212_CLKIDX_AdatAt44_1K = 0,    // selects source as ADAT at 44.1 kHz
    K1212_CLKIDX_AdatAt48K,          // selects source as ADAT at 48 kHz
@@ -412,9 +404,7 @@ struct snd_korg1212 {
 MODULE_DESCRIPTION("korg1212");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{KORG,korg1212}}");
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 MODULE_FIRMWARE("korg/k1212.dsp");
-#endif
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;     /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	   /* ID for this card */
@@ -2348,9 +2338,6 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
         korg1212->AdatTimeCodePhy = korg1212->sharedBufferPhy +
 		offsetof(struct KorgSharedBuffer, AdatTimeCode);
 
-#ifdef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
-	dsp_code = &static_dsp_code;
-#else
 	err = request_firmware(&dsp_code, "korg/k1212.dsp", &pci->dev);
 	if (err < 0) {
 		release_firmware(dsp_code);
@@ -2358,15 +2345,12 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
 		snd_korg1212_free(korg1212);
 		return err;
 	}
-#endif
 
 	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
 				dsp_code->size, &korg1212->dma_dsp) < 0) {
 		snd_printk(KERN_ERR "korg1212: cannot allocate dsp code memory (%zd bytes)\n", dsp_code->size);
                 snd_korg1212_free(korg1212);
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 		release_firmware(dsp_code);
-#endif
                 return -ENOMEM;
         }
 
@@ -2376,9 +2360,7 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
 
 	memcpy(korg1212->dma_dsp.area, dsp_code->data, dsp_code->size);
 
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 	release_firmware(dsp_code);
-#endif
 
 	rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_RebootCard, 0, 0, 0, 0);
 

-- 
dwmw2

