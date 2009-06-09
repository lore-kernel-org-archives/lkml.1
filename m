Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZFIWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZFIWup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZFIWui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:50:38 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:49929 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZFIWuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:50:37 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 18:50:36 EDT
Date: Wed, 10 Jun 2009 00:41:45 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Pierre Ossman <pierre@ossman.eu>
Cc: SDHCI development <sdhci-devel@lists.ossman.eu>,
       linux-kernel@vger.kernel.org
Subject: QUIRK_FORCE_HISPD (was: Re: Ricoh R5C822 and QUIRK_FORCE_DMA)
Message-ID: <20090609224145.GA11001@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Pierre Ossman <pierre@ossman.eu>,
	SDHCI development <sdhci-devel@lists.ossman.eu>,
	linux-kernel@vger.kernel.org
References: <20090430224524.GA9487@yamamaya.is-a-geek.org> <20090513195956.30f78012@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513195956.30f78012@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Might be a system problem so it's Lenovo that disabled it. You're the
> first report I've seen on this since the DMA logic was reworked so that
> DMA didn't have to be forced for most cases.

FWIW, so far I haven't had any errors due to dma being enabled.

I tried changing the CAPS using setpci, but they seem to be
read-only (unless theres are write-protect bit somewhere in the
config space).

On a related note, I had a little time to play a bit more with my
R5C822 and found that I can also force-enable HISPD mode, which
boost performance further.

And the kernel controlled LED toggling does not work at all.
(SDHCI_USE_LEDS_CLASS).

I had a look at the HOST_CONTROL register and found that while the
HISPD bit can be toggled, I can't toggle the LED bit.

With the patched sdhci I now get 14 MB/s reading a hispeed card:


USB:    Reading: 19.8 MB/s  Writing: 13.8 MB/s
patched
SDHCI:  Reading: 14.5 MB/s  Writing:  3.5 MB/s
unpatched
SDHCI:  Reading:  3.4 MB/s  Writing:  6.6 MB/s

Interestingly PIO write seems to be faster than DMA write.
Also interesting:
With unpatched SDHCI (PIO), reading hogs the CPU and makes the system
very unresponsive (jumping X cursor, slow terminal refresh).
However writing is not as bad, about 25% system usage, still
responsive (and also faster than reads!?).

For some reason enabling HISPD did not improve write speed at all,
only the read speed doubled.

I tried improving the write speed by adding support for
APP_CMD_SET_WR_BLOCK_COUNT to the block driver, but did not see any
improvement.
It's still in the patch, in case you are interested.

dmesg, unpatched:
[ 5295.130010] sdhci: Secure Digital Host Controller Interface driver
[ 5295.130010] sdhci: Copyright(c) Pierre Ossman
[ 5295.140012] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:0822] (rev 13)
[ 5295.140012] sdhci-pci 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 5295.140012] Registered led device: mmc0::
[ 5295.140012] mmc0: SDHCI controller on PCI [0000:04:00.1] using PIO
[ 5295.380271] mmc0: new SDHC card at address b368
[ 5295.380271] mmcblk0: mmc0:b368 SDC   14.9 GiB 
[ 5295.380271]  mmcblk0: p1

dmesg, patched:
[ 5906.950010] sdhci: Secure Digital Host Controller Interface driver
[ 5906.950010] sdhci: Copyright(c) Pierre Ossman
[ 5906.960011] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:0822] (rev 13)
[ 5906.960011] sdhci-pci 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 5906.960011] mmc0: Controller vendor_ver=02 sdhci_ver=00.
[ 5906.960011] mmc0: Controller caps=018021a1.
[ 5906.960011] DMA forced on (host quirk)
[ 5906.960011] sdhci-pci 0000:04:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[ 5906.960011] HISPD forced on (host quirk)
[ 5906.960011] Verified that HOST_CONTROL bit SDHCI_CTRL_HISPD can be toggled
[ 5906.960011] Could not set SDHCI_CTRL_LED to 1!
[ 5906.960011] mmc0: SDHCI controller on PCI [0000:04:00.1] using DMA
[ 5907.211304] mmc0: new high speed SDHC card at address b368
[ 5907.211304] mmcblk0: mmc0:b368 SDC   14.9 GiB 
[ 5907.211304]  mmcblk0: p1



Index: linux-2.6.30-rc8/drivers/mmc/host/sdhci.c
===================================================================
--- linux-2.6.30-rc8.orig/drivers/mmc/host/sdhci.c	2009-06-09 23:11:43.329261011 +0200
+++ linux-2.6.30-rc8/drivers/mmc/host/sdhci.c	2009-06-09 23:12:11.489274926 +0200
@@ -1614,6 +1614,10 @@
 	sdhci_reset(host, SDHCI_RESET_ALL);
 
 	host->version = sdhci_readw(host, SDHCI_HOST_VERSION);
+	printk(KERN_ERR "%s: Controller vendor_ver=%02x sdhci_ver=%02x.\n",
+	       mmc_hostname(mmc),
+	       (host->version & SDHCI_VENDOR_VER_MASK) >> SDHCI_VENDOR_VER_SHIFT,
+	       (host->version & SDHCI_SPEC_VER_MASK) >> SDHCI_SPEC_VER_SHIFT);
 	host->version = (host->version & SDHCI_SPEC_VER_MASK)
 				>> SDHCI_SPEC_VER_SHIFT;
 	if (host->version > SDHCI_SPEC_200) {
@@ -1623,11 +1627,14 @@
 	}
 
 	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
+	printk(KERN_ERR "%s: Controller caps=%08x.\n",
+	       mmc_hostname(mmc), caps);
 
-	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
+	if (host->quirks & SDHCI_QUIRK_FORCE_DMA) {
+		printk(KERN_WARNING "DMA forced on (host quirk)\n");
 		host->flags |= SDHCI_USE_DMA;
-	else if (!(caps & SDHCI_CAN_DO_DMA))
-		DBG("Controller doesn't have DMA capability\n");
+	} else if (!(caps & SDHCI_CAN_DO_DMA))
+		printk(KERN_WARNING "Controller doesn't have DMA capability\n");
 	else
 		host->flags |= SDHCI_USE_DMA;
 
@@ -1723,7 +1730,34 @@
 	mmc->f_max = host->max_clk;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 
-	if (caps & SDHCI_CAN_DO_HISPD)
+
+	if (host->quirks & SDHCI_QUIRK_FORCE_HISPD) {
+		unsigned char ctrl;
+		int toggle_ok = 1;
+
+		printk(KERN_WARNING "HISPD forced on (host quirk)\n");
+
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		ctrl |= SDHCI_CTRL_HISPD;
+		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		if (!(ctrl & SDHCI_CTRL_HISPD)) {
+			printk(KERN_WARNING "Could not set SDHCI_CTRL_HISPD to 1!\n");
+			toggle_ok = 0;
+		}
+		ctrl &= ~SDHCI_CTRL_HISPD;
+		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		if (ctrl & SDHCI_CTRL_HISPD) {
+			printk(KERN_WARNING "Could not set SDHCI_CTRL_HISPD to 0!\n");
+			toggle_ok = 0;
+		}
+		if (toggle_ok) {
+			printk(KERN_WARNING "Verified that HOST_CONTROL bit SDHCI_CTRL_HISPD can be toggled\n");
+		}
+
+		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
+	} else if (caps & SDHCI_CAN_DO_HISPD)
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 
 	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
@@ -1818,16 +1852,41 @@
 #endif
 
 #ifdef SDHCI_USE_LEDS_CLASS
-	snprintf(host->led_name, sizeof(host->led_name),
-		"%s::", mmc_hostname(mmc));
-	host->led.name = host->led_name;
-	host->led.brightness = LED_OFF;
-	host->led.default_trigger = mmc_hostname(mmc);
-	host->led.brightness_set = sdhci_led_control;
-
-	ret = led_classdev_register(mmc_dev(mmc), &host->led);
-	if (ret)
-		goto reset;
+	{
+		unsigned char ctrl;
+		int toggle_ok = 1;
+
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		ctrl |= SDHCI_CTRL_LED;
+		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		if (!(ctrl & SDHCI_CTRL_LED)) {
+			printk(KERN_WARNING "Could not set SDHCI_CTRL_LED to 1!\n");
+			toggle_ok = 0;
+		}
+		ctrl &= ~SDHCI_CTRL_LED;
+		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		if (ctrl & SDHCI_CTRL_LED) {
+			printk(KERN_WARNING "Could not set SDHCI_CTRL_LED to 0!\n");
+			toggle_ok = 0;
+		}
+		if (toggle_ok) {
+			printk(KERN_WARNING "Verified that HOST_CONTROL bit SDHCI_CTRL_LED can be toggled\n");
+			snprintf(host->led_name, sizeof(host->led_name),
+				"%s::", mmc_hostname(mmc));
+			host->led.name = host->led_name;
+			host->led.brightness = LED_OFF;
+			host->led.default_trigger = mmc_hostname(mmc);
+			host->led.brightness_set = sdhci_led_control;
+
+			ret = led_classdev_register(mmc_dev(mmc), &host->led);
+			if (ret)
+				goto reset;
+		} else {
+			host->led.name = NULL;
+		}
+	}
 #endif
 
 	mmiowb();
@@ -1882,7 +1941,8 @@
 	mmc_remove_host(host->mmc);
 
 #ifdef SDHCI_USE_LEDS_CLASS
-	led_classdev_unregister(&host->led);
+	if (host->led.name) /* name is NULL if LED can not be controlled */
+		led_classdev_unregister(&host->led);
 #endif
 
 	if (!dead)
Index: linux-2.6.30-rc8/drivers/mmc/host/sdhci-pci.c
===================================================================
--- linux-2.6.30-rc8.orig/drivers/mmc/host/sdhci-pci.c	2009-06-09 23:11:43.349260831 +0200
+++ linux-2.6.30-rc8/drivers/mmc/host/sdhci-pci.c	2009-06-09 23:12:11.489274926 +0200
@@ -91,7 +91,9 @@
 
 static const struct sdhci_pci_fixes sdhci_ricoh = {
 	.probe		= ricoh_probe,
-	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR,
+	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
+			  SDHCI_QUIRK_FORCE_DMA |
+			  SDHCI_QUIRK_FORCE_HISPD,
 };
 
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
Index: linux-2.6.30-rc8/drivers/mmc/host/sdhci.h
===================================================================
--- linux-2.6.30-rc8.orig/drivers/mmc/host/sdhci.h	2009-06-09 23:11:43.309261052 +0200
+++ linux-2.6.30-rc8/drivers/mmc/host/sdhci.h	2009-06-09 23:12:11.489274926 +0200
@@ -226,6 +226,8 @@
 #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<19)
 /* Controller has to be forced to use block size of 2048 bytes */
 #define SDHCI_QUIRK_FORCE_BLK_SZ_2048			(1<<20)
+/* Controller has bad caps bits, but really supports HISPD */
+#define SDHCI_QUIRK_FORCE_HISPD				(1<<21)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
Index: linux-2.6.30-rc8/drivers/mmc/card/block.c
===================================================================
--- linux-2.6.30-rc8.orig/drivers/mmc/card/block.c	2009-06-09 23:11:43.369261139 +0200
+++ linux-2.6.30-rc8/drivers/mmc/card/block.c	2009-06-09 23:12:11.499260622 +0200
@@ -40,6 +40,7 @@
 #include <asm/uaccess.h>
 
 #include "queue.h"
+#include "../core/sd_ops.h"
 
 MODULE_ALIAS("mmc:block");
 
@@ -262,6 +263,22 @@
 			brq.data.blocks = card->host->max_blk_count;
 
 		/*
+		 * Inform the card about the number of blocks to be written.
+		 */
+		if (card->type == MMC_TYPE_SD &&
+		    rq_data_dir(req) == WRITE) {
+			int err;
+
+			err = mmc_app_set_wr_blk_erase_cnt(card, brq.data.blocks);
+			if (err)
+				printk(KERN_WARNING
+				       "%s: mmc_app_set_wr_blk_erase_cnt "
+				       "failed: %d\n",
+				       req->rq_disk->disk_name,
+				       err);
+		}
+
+		/*
 		 * After a read error, we redo the request one sector at a time
 		 * in order to accurately determine which sectors can be read
 		 * successfully.
Index: linux-2.6.30-rc8/drivers/mmc/core/sd_ops.c
===================================================================
--- linux-2.6.30-rc8.orig/drivers/mmc/core/sd_ops.c	2009-06-09 23:11:43.409260079 +0200
+++ linux-2.6.30-rc8/drivers/mmc/core/sd_ops.c	2009-06-09 23:12:11.499260622 +0200
@@ -299,6 +299,28 @@
 	return 0;
 }
 
+int mmc_app_set_wr_blk_erase_cnt(struct mmc_card *card, int count)
+{
+	int err;
+	struct mmc_command cmd;
+
+	BUG_ON(!card);
+	BUG_ON(!card->host);
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+
+	cmd.opcode = SD_APP_SET_WR_BLK_ERASE_CNT;
+	cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+	cmd.arg = count;
+
+	err = mmc_wait_for_app_cmd(card->host, card, &cmd, MMC_CMD_RETRIES);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL(mmc_app_set_wr_blk_erase_cnt);
+
 int mmc_sd_switch(struct mmc_card *card, int mode, int group,
 	u8 value, u8 *resp)
 {
Index: linux-2.6.30-rc8/drivers/mmc/core/sd_ops.h
===================================================================
--- linux-2.6.30-rc8.orig/drivers/mmc/core/sd_ops.h	2009-06-09 23:11:43.389260399 +0200
+++ linux-2.6.30-rc8/drivers/mmc/core/sd_ops.h	2009-06-09 23:12:11.499260622 +0200
@@ -13,6 +13,7 @@
 #define _MMC_SD_OPS_H
 
 int mmc_app_set_bus_width(struct mmc_card *card, int width);
+int mmc_app_set_wr_blk_erase_cnt(struct mmc_card *card, int count);
 int mmc_send_app_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_send_if_cond(struct mmc_host *host, u32 ocr);
 int mmc_send_relative_addr(struct mmc_host *host, unsigned int *rca);
Index: linux-2.6.30-rc8/include/linux/mmc/sd.h
===================================================================
--- linux-2.6.30-rc8.orig/include/linux/mmc/sd.h	2009-06-09 23:11:43.439260121 +0200
+++ linux-2.6.30-rc8/include/linux/mmc/sd.h	2009-06-09 23:13:35.834952507 +0200
@@ -12,20 +12,21 @@
 #ifndef MMC_SD_H
 #define MMC_SD_H
 
-/* SD commands                           type  argument     response */
+/* SD commands                               type  argument     response */
   /* class 0 */
 /* This is basically the same command as for MMC with some quirks. */
-#define SD_SEND_RELATIVE_ADDR     3   /* bcr                     R6  */
-#define SD_SEND_IF_COND           8   /* bcr  [11:0] See below   R7  */
+#define SD_SEND_RELATIVE_ADDR        3    /* bcr                     R6  */
+#define SD_SEND_IF_COND              8    /* bcr  [11:0] See below   R7  */
 
   /* class 10 */
-#define SD_SWITCH                 6   /* adtc [31:0] See below   R1  */
+#define SD_SWITCH                    6    /* adtc [31:0] See below   R1  */
 
   /* Application commands */
-#define SD_APP_SET_BUS_WIDTH      6   /* ac   [1:0] bus width    R1  */
-#define SD_APP_SEND_NUM_WR_BLKS  22   /* adtc                    R1  */
-#define SD_APP_OP_COND           41   /* bcr  [31:0] OCR         R3  */
-#define SD_APP_SEND_SCR          51   /* adtc                    R1  */
+#define SD_APP_SET_BUS_WIDTH         6    /* ac   [1:0] bus width    R1  */
+#define SD_APP_SEND_NUM_WR_BLKS     22    /* adtc                    R1  */
+#define SD_APP_SET_WR_BLK_ERASE_CNT 23    /* adtc                    R1  */
+#define SD_APP_OP_COND              41    /* bcr  [31:0] OCR         R3  */
+#define SD_APP_SEND_SCR             51    /* adtc                    R1  */
 
 /*
  * SD_SWITCH argument format:

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
