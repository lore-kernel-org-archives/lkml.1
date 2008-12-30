Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYL3LRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYL3LRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 06:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYL3LQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 06:16:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:58566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYL3LQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:16:48 -0500
Subject: [PATCH -net-next 2/4] firmware: convert acenic driver to
	request_firmware() -- without firmware data
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: davem@redhat.com, netdev <netdev@vger.kernel.org>, jes@sgi.com,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=utf8
Date: Tue, 30 Dec 2008 16:44:54 +0530
Message-Id: <1230635694.10603.20.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿acenic is having huge firmware data so mailing lists are rejecting complete patch.

So I removed acenic firmware data from this patch.

and data is available in:
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=e39c0e190f52331b35931fbe5e34a07114d66171


Subject: [PATCH] firmware: convert acenic driver to request_firmware()

We store the firmware in its native big-endian form now, so the loop in
ace_copy() is modified to use be32_to_cpup() when writing it out.

We can forget the BSS,SBSS sections of the firmware, since we were
clearing all the device's RAM anyway. And the text,rodata,data sections
can all be loaded as a single chunk since they're contiguous (give or
take a few dozen bytes in between).

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/acenic.c          |  122 +-
 drivers/net/acenic.h          |    4 +
 drivers/net/acenic_firmware.h | 9456 -----------------------------------------
 firmware/Makefile             |    7 +
 firmware/WHENCE               |   12 +
 firmware/acenic/tg1.bin.ihex  | 4573 ++++++++++++++++++++
 firmware/acenic/tg2.bin.ihex  | 4844 +++++++++++++++++++++
 7 files changed, 9516 insertions(+), 9502 deletions(-)
 delete mode 100644 drivers/net/acenic_firmware.h
 create mode 100644 firmware/acenic/tg1.bin.ihex
 create mode 100644 firmware/acenic/tg2.bin.ihex

diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index 517fce4..4835eee 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -66,6 +66,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/sockios.h>
+#include <linux/firmware.h>
 
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 #include <linux/if_vlan.h>
@@ -95,8 +96,11 @@
 #else
 #define ACE_IS_TIGON_I(ap)	(ap->version == 1)
 #define ACE_TX_RING_ENTRIES(ap)	ap->tx_ring_entries
+#define FIRMWARE_TG1		"acenic/tg1.bin"
 #endif
 
+#define FIRMWARE_TG2		"acenic/tg2.bin"
+
 #ifndef PCI_VENDOR_ID_ALTEON
 #define PCI_VENDOR_ID_ALTEON		0x12ae
 #endif
@@ -186,8 +190,6 @@ MODULE_DEVICE_TABLE(pci, acenic_pci_tbl);
 #define MAX_RODATA_LEN	8*1024
 #define MAX_DATA_LEN	2*1024
 
-#include "acenic_firmware.h"
-
 #ifndef tigon2FwReleaseLocal
 #define tigon2FwReleaseLocal 0
 #endif
@@ -417,6 +419,10 @@ static int dis_pci_mem_inval[ACE_MAX_MOD_PARMS] = {1, 1, 1, 1, 1, 1, 1, 1};
 MODULE_AUTHOR("Jes Sorensen <jes@trained-monkey.org>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AceNIC/3C985/GA620 Gigabit Ethernet driver");
+#ifndef CONFIG_ACENIC_OMIT_TIGON_I
+MODULE_FIRMWARE(FIRMWARE_TG1);
+#endif
+MODULE_FIRMWARE(FIRMWARE_TG2);
 
 module_param_array_named(link, link_state, int, NULL, 0);
 module_param_array(trace, int, NULL, 0);
@@ -943,8 +949,8 @@ static int __devinit ace_init(struct net_device *dev)
 	case 4:
 	case 5:
 		printk(KERN_INFO "  Tigon I  (Rev. %i), Firmware: %i.%i.%i, ",
-		       tig_ver, tigonFwReleaseMajor, tigonFwReleaseMinor,
-		       tigonFwReleaseFix);
+		       tig_ver, ap->firmware_major, ap->firmware_minor,
+		       ap->firmware_fix);
 		writel(0, &regs->LocalCtrl);
 		ap->version = 1;
 		ap->tx_ring_entries = TIGON_I_TX_RING_ENTRIES;
@@ -952,8 +958,8 @@ static int __devinit ace_init(struct net_device *dev)
 #endif
 	case 6:
 		printk(KERN_INFO "  Tigon II (Rev. %i), Firmware: %i.%i.%i, ",
-		       tig_ver, tigon2FwReleaseMajor, tigon2FwReleaseMinor,
-		       tigon2FwReleaseFix);
+		       tig_ver, ap->firmware_major, ap->firmware_minor,
+		       ap->firmware_fix);
 		writel(readl(&regs->CpuBCtrl) | CPU_HALT, &regs->CpuBCtrl);
 		readl(&regs->CpuBCtrl);		/* PCI write posting */
 		/*
@@ -1205,7 +1211,9 @@ static int __devinit ace_init(struct net_device *dev)
 	memset(ap->info, 0, sizeof(struct ace_info));
 	memset(ap->skb, 0, sizeof(struct ace_skb));
 
-	ace_load_firmware(dev);
+	if (ace_load_firmware(dev))
+		goto init_error;
+
 	ap->fw_running = 0;
 
 	tmp_ptr = ap->info_dma;
@@ -1441,10 +1449,7 @@ static int __devinit ace_init(struct net_device *dev)
 	if (ap->version >= 2)
 		writel(tmp, &regs->TuneFastLink);
 
-	if (ACE_IS_TIGON_I(ap))
-		writel(tigonFwStartAddr, &regs->Pc);
-	if (ap->version == 2)
-		writel(tigon2FwStartAddr, &regs->Pc);
+	writel(ap->firmware_start, &regs->Pc);
 
 	writel(0, &regs->Mb0Lo);
 
@@ -2761,8 +2766,8 @@ static void ace_get_drvinfo(struct net_device *dev,
 
 	strlcpy(info->driver, "acenic", sizeof(info->driver));
 	snprintf(info->version, sizeof(info->version), "%i.%i.%i",
-		tigonFwReleaseMajor, tigonFwReleaseMinor,
-		tigonFwReleaseFix);
+		 ap->firmware_major, ap->firmware_minor,
+		 ap->firmware_fix);
 
 	if (ap->pdev)
 		strlcpy(info->bus_info, pci_name(ap->pdev),
@@ -2869,11 +2874,10 @@ static struct net_device_stats *ace_get_stats(struct net_device *dev)
 }
 

-static void __devinit ace_copy(struct ace_regs __iomem *regs, void *src,
-			    u32 dest, int size)
+static void __devinit ace_copy(struct ace_regs __iomem *regs, const __be32 *src,
+			       u32 dest, int size)
 {
 	void __iomem *tdest;
-	u32 *wsrc;
 	short tsize, i;
 
 	if (size <= 0)
@@ -2885,20 +2889,15 @@ static void __devinit ace_copy(struct ace_regs __iomem *regs, void *src,
 		tdest = (void __iomem *) &regs->Window +
 			(dest & (ACE_WINDOW_SIZE - 1));
 		writel(dest & ~(ACE_WINDOW_SIZE - 1), &regs->WinBase);
-		/*
-		 * This requires byte swapping on big endian, however
-		 * writel does that for us
-		 */
-		wsrc = src;
 		for (i = 0; i < (tsize / 4); i++) {
-			writel(wsrc[i], tdest + i*4);
+			/* Firmware is big-endian */
+			writel(be32_to_cpup(src), tdest);
+			src++;
+			tdest += 4;
+			dest += 4;
+			size -= 4;
 		}
-		dest += tsize;
-		src += tsize;
-		size -= tsize;
 	}
-
-	return;
 }
 

@@ -2937,8 +2936,13 @@ static void __devinit ace_clear(struct ace_regs __iomem *regs, u32 dest, int siz
  */
 static int __devinit ace_load_firmware(struct net_device *dev)
 {
+	const struct firmware *fw;
+	const char *fw_name = FIRMWARE_TG2;
 	struct ace_private *ap = netdev_priv(dev);
 	struct ace_regs __iomem *regs = ap->regs;
+	const __be32 *fw_data;
+	u32 load_addr;
+	int ret;
 
 	if (!(readl(&regs->CpuCtrl) & CPU_HALTED)) {
 		printk(KERN_ERR "%s: trying to download firmware while the "
@@ -2946,28 +2950,54 @@ static int __devinit ace_load_firmware(struct net_device *dev)
 		return -EFAULT;
 	}
 
+#ifndef CONFIG_ACENIC_OMIT_TIGON_I
+	if (ACE_IS_TIGON_I(ap))
+		fw_name = FIRMWARE_TG1;
+#endif
+
+	ret = request_firmware(&fw, fw_name, &ap->pdev->dev);
+	if (ret) {
+		printk(KERN_ERR "%s: Failed to load firmware \"%s\"\n",
+		       ap->name, fw_name);
+		return ret;
+	}
+
+	fw_data = (void *)fw->data;
+
+	/* Firmware blob starts with version numbers, followed by
+	   load and start address. Remainder is the blob to be loaded
+	   contiguously from load address. We don't bother to represent
+	   the BSS/SBSS sections any more, since we were clearing the
+	   whole thing anyway. */
+	ap->firmware_major = fw->data[0];
+	ap->firmware_minor = fw->data[1];
+	ap->firmware_fix = fw->data[2];
+
+	ap->firmware_start = be32_to_cpu(fw_data[1]);
+	if (ap->firmware_start < 0x4000 || ap->firmware_start >= 0x80000) {
+		printk(KERN_ERR "%s: bogus load address %08x in \"%s\"\n",
+		       ap->name, ap->firmware_start, fw_name);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	load_addr = be32_to_cpu(fw_data[2]);
+	if (load_addr < 0x4000 || load_addr >= 0x80000) {
+		printk(KERN_ERR "%s: bogus load address %08x in \"%s\"\n",
+		       ap->name, load_addr, fw_name);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/*
-	 * Do not try to clear more than 512KB or we end up seeing
-	 * funny things on NICs with only 512KB SRAM
+	 * Do not try to clear more than 512KiB or we end up seeing
+	 * funny things on NICs with only 512KiB SRAM
 	 */
 	ace_clear(regs, 0x2000, 0x80000-0x2000);
-	if (ACE_IS_TIGON_I(ap)) {
-		ace_copy(regs, tigonFwText, tigonFwTextAddr, tigonFwTextLen);
-		ace_copy(regs, tigonFwData, tigonFwDataAddr, tigonFwDataLen);
-		ace_copy(regs, tigonFwRodata, tigonFwRodataAddr,
-			 tigonFwRodataLen);
-		ace_clear(regs, tigonFwBssAddr, tigonFwBssLen);
-		ace_clear(regs, tigonFwSbssAddr, tigonFwSbssLen);
-	}else if (ap->version == 2) {
-		ace_clear(regs, tigon2FwBssAddr, tigon2FwBssLen);
-		ace_clear(regs, tigon2FwSbssAddr, tigon2FwSbssLen);
-		ace_copy(regs, tigon2FwText, tigon2FwTextAddr,tigon2FwTextLen);
-		ace_copy(regs, tigon2FwRodata, tigon2FwRodataAddr,
-			 tigon2FwRodataLen);
-		ace_copy(regs, tigon2FwData, tigon2FwDataAddr,tigon2FwDataLen);
-	}
-
-	return 0;
+	ace_copy(regs, &fw_data[3], load_addr, fw->size - 12);
+out:
+	release_firmware(fw);
+	return ret;
 }
 

diff --git a/drivers/net/acenic.h b/drivers/net/acenic.h
index 4487f32..c987c9b 100644
--- a/drivers/net/acenic.h
+++ b/drivers/net/acenic.h
@@ -694,6 +694,10 @@ struct ace_private
 	u32			last_tx, last_std_rx, last_mini_rx;
 #endif
 	int			pci_using_dac;
+	u8			firmware_major;
+	u8			firmware_minor;
+	u8			firmware_fix;
+	u32			firmware_start;
 };
 

diff --git a/firmware/Makefile b/firmware/Makefile
index d99000d..8a9eba2 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -20,6 +20,13 @@ fw-external-y := $(subst ",,$(CONFIG_EXTRA_FIRMWARE))
 # accurate. In the latter case it doesn't matter -- it'll use $(fw-shipped-all).
 # But be aware that the config file might not be included at all.
 
+ifdef CONFIG_ACENIC_OMIT_TIGON_I
+acenic-objs := acenic/tg2.bin
+fw-shipped- += acenic/tg1.bin
+else
+acenic-objs := acenic/tg1.bin acenic/tg2.bin
+endif
+fw-shipped-$(CONFIG_ACENIC) += $(acenic-objs)
 fw-shipped-$(CONFIG_ATARI_DSP56K) += dsp56k/bootstrap.bin
 fw-shipped-$(CONFIG_ATM_AMBASSADOR) += atmsar11.fw
 fw-shipped-$(CONFIG_CASSINI) += sun/cassini.bin
diff --git a/firmware/WHENCE b/firmware/WHENCE
index 040967f..e315a33 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -371,3 +371,15 @@ Licence: Unknown
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
+
+Driver: acenic -- Alteon AceNIC Gigabit Ethernet card
+
+File: acenic/tg1.bin
+File: acenic/tg2.bin
+
+Licence: Unknown
+
+Found in hex form in kernel source, but source allegedly available at
+http://alteon.shareable.org/
+
+--------------------------------------------------------------------------


