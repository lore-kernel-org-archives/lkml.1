Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYJPWI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYJPWI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYJPWIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:08:11 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:41959 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbYJPWIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:08:09 -0400
Date: Thu, 16 Oct 2008 18:08:01 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] i7300_idle driver v1.55
In-reply-to: <20081011083347.GA31918@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>
Message-id: <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
 <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
 <20081011083347.GA31918@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Henroid <andrew.d.henroid@intel.com>

The Intel 7300 Memory Controller supports dynamic throttling of memory which can
be used to save power when system is idle. This driver does the memory
throttling when all CPUs are idle on such a system.

Refer to "Intel 7300 Memory Controller Hub (MCH)" datasheet
for the config space description.

Signed-off-by: Andy Henroid <andrew.d.henroid@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 MAINTAINERS               |    6 +
 arch/x86/Kconfig          |    2 +
 drivers/Makefile          |    1 +
 drivers/dma/ioat_dma.c    |    3 +
 drivers/idle/Kconfig      |   16 +
 drivers/idle/Makefile     |    2 +
 drivers/idle/i7300_idle.c |  674 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/idle.h    |    1 +
 include/linux/pci_ids.h   |    1 +
 9 files changed, 706 insertions(+), 0 deletions(-)
 create mode 100644 drivers/idle/Kconfig
 create mode 100644 drivers/idle/Makefile
 create mode 100644 drivers/idle/i7300_idle.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dae455..43f71b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2078,6 +2078,12 @@ L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
+IDLE-I7300
+P:	Andy Henroid
+M:	andrew.d.henroid@intel.com
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
 IEEE 1394 SUBSYSTEM (drivers/ieee1394)
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..19cdfe1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1536,6 +1536,8 @@ source "arch/x86/kernel/cpu/cpufreq/Kconfig"
 
 source "drivers/cpuidle/Kconfig"
 
+source "drivers/idle/Kconfig"
+
 endmenu
 
 
diff --git a/drivers/Makefile b/drivers/Makefile
index 2735bde..f443a8a 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
+obj-y				+= idle/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index bc8c6e3..f8396ca 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -171,6 +171,9 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
+#if CONFIG_I7300_IDLE_IOAT_CHANNEL
+	device->common.chancnt--;
+#endif
 	for (i = 0; i < device->common.chancnt; i++) {
 		ioat_chan = kzalloc(sizeof(*ioat_chan), GFP_KERNEL);
 		if (!ioat_chan) {
diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
new file mode 100644
index 0000000..f5b26dd
--- /dev/null
+++ b/drivers/idle/Kconfig
@@ -0,0 +1,16 @@
+
+menu "Memory power savings"
+
+config I7300_IDLE_IOAT_CHANNEL
+	bool
+
+config I7300_IDLE
+	tristate "Intel chipset idle power saving driver"
+	select I7300_IDLE_IOAT_CHANNEL
+	depends on X86_64
+	help
+	  Enable idle power savings with certain Intel server chipsets.
+	  The chipset must have I/O AT support, such as the Intel 7300.
+	  The power savings depends on the type and quantity of DRAM devices.
+
+endmenu
diff --git a/drivers/idle/Makefile b/drivers/idle/Makefile
new file mode 100644
index 0000000..5f68fc3
--- /dev/null
+++ b/drivers/idle/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_I7300_IDLE)			+= i7300_idle.o
+
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
new file mode 100644
index 0000000..59d1bbc
--- /dev/null
+++ b/drivers/idle/i7300_idle.c
@@ -0,0 +1,674 @@
+/*
+ * (C) Copyright 2008 Intel Corporation
+ * Authors:
+ * Andy Henroid <andrew.d.henroid@intel.com>
+ * Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ */
+
+/*
+ * Save DIMM power on Intel 7300-based platforms when all CPUs/cores
+ * are idle, using the DIMM thermal throttling capability.
+ *
+ * This driver depends on the Intel integrated DMA controller (I/O AT).
+ * If the driver for I/O AT (drivers/dma/ioatdma*) is also enabled,
+ * this driver should work cooperatively.
+ */
+
+/* #define DEBUG */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/notifier.h>
+#include <linux/cpumask.h>
+#include <linux/ktime.h>
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/stop_machine.h>
+
+#include <asm/idle.h>
+
+#include "../dma/ioatdma_hw.h"
+#include "../dma/ioatdma_registers.h"
+
+#define I7300_IDLE_DRIVER_VERSION	"1.55"
+#define I7300_PRINT			"i7300_idle:"
+
+static int debug;
+module_param_named(debug, debug, uint, 0644);
+MODULE_PARM_DESC(debug, "Enable debug printks in this driver");
+
+#define dprintk(fmt, arg...) \
+	do { if (debug) printk(KERN_INFO I7300_PRINT fmt, ##arg); } while (0)
+
+/*
+ * Value to set THRTLOW to when initiating throttling
+ *  0 = No throttling
+ *  1 = Throttle when > 4 activations per eval window (Maximum throttling)
+ *  2 = Throttle when > 8 activations
+ *  168 = Throttle when > 168 activations (Minimum throttling)
+ */
+#define MAX_THRTLWLIMIT		168
+static uint i7300_idle_thrtlowlm = 1;
+module_param_named(thrtlwlimit, i7300_idle_thrtlowlm, uint, 0644);
+MODULE_PARM_DESC(thrtlwlimit,
+		"Value for THRTLOWLM activation field "
+		"(0 = disable throttle, 1 = Max throttle, 168 = Min throttle)");
+
+/*
+ * simple invocation and duration statistics
+ */
+static unsigned long total_starts;
+static unsigned long total_us;
+
+#ifdef DEBUG
+static unsigned long past_skip;
+#endif
+
+static struct pci_dev *fbd_dev;
+
+static spinlock_t i7300_idle_lock;
+static int i7300_idle_active;
+
+static u8 i7300_idle_thrtctl_saved;
+static u8 i7300_idle_thrtlow_saved;
+static u32 i7300_idle_mc_saved;
+
+static cpumask_t idle_cpumask;
+static ktime_t start_ktime;
+static unsigned long avg_idle_us;
+
+static struct dentry *debugfs_dir;
+
+/* Begin: I/O AT Helper routines */
+
+#define IOAT_CHANBASE(ioat_ctl, chan) (ioat_ctl + 0x80 + 0x80 * chan)
+/* Snoop control (disable snoops when coherency is not important) */
+#define IOAT_DESC_SADDR_SNP_CTL (1UL << 1)
+#define IOAT_DESC_DADDR_SNP_CTL (1UL << 2)
+
+static struct pci_dev *ioat_dev;
+static struct ioat_dma_descriptor *ioat_desc; /* I/O AT desc & data (1 page) */
+static unsigned long ioat_desc_phys;
+static u8 *ioat_iomap; /* I/O AT memory-mapped control regs (aka CB_BAR) */
+static u8 *ioat_chanbase;
+
+/* Start I/O AT memory copy */
+static int i7300_idle_ioat_start(void)
+{
+	u32 err;
+	/* Clear error (due to circular descriptor pointer) */
+	err = readl(ioat_chanbase + IOAT_CHANERR_OFFSET);
+	if (err)
+		writel(err, ioat_chanbase + IOAT_CHANERR_OFFSET);
+
+	writeb(IOAT_CHANCMD_START, ioat_chanbase + IOAT1_CHANCMD_OFFSET);
+	return 0;
+}
+
+/* Stop I/O AT memory copy */
+static void i7300_idle_ioat_stop(void)
+{
+	int i;
+	u8 sts;
+
+	for (i = 0; i < 5; i++) {
+		writeb(IOAT_CHANCMD_RESET,
+			ioat_chanbase + IOAT1_CHANCMD_OFFSET);
+
+		udelay(10);
+
+		sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
+			IOAT_CHANSTS_DMA_TRANSFER_STATUS;
+
+		if (sts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_ACTIVE)
+			break;
+
+	}
+
+	if (i == 5)
+		dprintk("failed to suspend+reset I/O AT after 5 retries\n");
+
+}
+
+/* Test I/O AT by copying 1024 byte from 2k to 1k */
+static int __init i7300_idle_ioat_selftest(u8 *ctl,
+		struct ioat_dma_descriptor *desc, unsigned long desc_phys)
+{
+	u64 chan_sts;
+
+	memset(desc, 0, 2048);
+	memset((u8 *) desc + 2048, 0xab, 1024);
+
+	desc[0].size = 1024;
+	desc[0].ctl = 0;
+	desc[0].src_addr = desc_phys + 2048;
+	desc[0].dst_addr = desc_phys + 1024;
+	desc[0].next = 0;
+
+	writeb(IOAT_CHANCMD_RESET, ioat_chanbase + IOAT1_CHANCMD_OFFSET);
+	writeb(IOAT_CHANCMD_START, ioat_chanbase + IOAT1_CHANCMD_OFFSET);
+
+	udelay(1000);
+
+	chan_sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
+			IOAT_CHANSTS_DMA_TRANSFER_STATUS;
+
+	if (chan_sts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_DONE) {
+		/* Not complete, reset the channel */
+		writeb(IOAT_CHANCMD_RESET,
+		       ioat_chanbase + IOAT1_CHANCMD_OFFSET);
+		return -1;
+	}
+
+	if (*(u32 *) ((u8 *) desc + 3068) != 0xabababab ||
+	    *(u32 *) ((u8 *) desc + 2044) != 0xabababab) {
+		dprintk("Data values src 0x%x, dest 0x%x, memset 0x%x\n",
+			*(u32 *) ((u8 *) desc + 2048),
+			*(u32 *) ((u8 *) desc + 1024),
+			*(u32 *) ((u8 *) desc + 3072));
+		return -1;
+	}
+	return 0;
+}
+
+static struct device dummy_dma_dev = {
+	.bus_id = "fallback device",
+	.coherent_dma_mask = DMA_64BIT_MASK,
+	.dma_mask = &dummy_dma_dev.coherent_dma_mask,
+};
+
+/* Setup and initialize I/O AT */
+/* This driver needs I/O AT as the throttling takes effect only when there is
+ * some memory activity. We use I/O AT to set up a dummy copy, while all CPUs
+ * go idle and memory is throttled.
+ */
+static int __init i7300_idle_ioat_init(void)
+{
+	u8 ver, chan_count, ioat_chan;
+	u16 chan_ctl;
+
+	ioat_iomap = (u8 *) ioremap_nocache(pci_resource_start(ioat_dev, 0),
+					    pci_resource_len(ioat_dev, 0));
+
+	if (!ioat_iomap) {
+		printk(KERN_ERR I7300_PRINT "failed to map I/O AT registers\n");
+		goto err_ret;
+	}
+
+	ver = readb(ioat_iomap + IOAT_VER_OFFSET);
+	if (ver != IOAT_VER_1_2) {
+		printk(KERN_ERR I7300_PRINT "unknown I/O AT version (%u.%u)\n",
+			ver >> 4, ver & 0xf);
+		goto err_unmap;
+	}
+
+	chan_count = readb(ioat_iomap + IOAT_CHANCNT_OFFSET);
+	if (!chan_count) {
+		printk(KERN_ERR I7300_PRINT "unexpected # of I/O AT channels "
+			"(%u)\n",
+			chan_count);
+		goto err_unmap;
+	}
+
+	ioat_chan = chan_count - 1;
+	ioat_chanbase = IOAT_CHANBASE(ioat_iomap, ioat_chan);
+
+	chan_ctl = readw(ioat_chanbase + IOAT_CHANCTRL_OFFSET);
+	if (chan_ctl & IOAT_CHANCTRL_CHANNEL_IN_USE) {
+		printk(KERN_ERR I7300_PRINT "channel %d in use\n", ioat_chan);
+		goto err_unmap;
+	}
+
+	writew(IOAT_CHANCTRL_CHANNEL_IN_USE,
+		ioat_chanbase + IOAT_CHANCTRL_OFFSET);
+
+	ioat_desc = (struct ioat_dma_descriptor *)dma_alloc_coherent(
+			&dummy_dma_dev, 4096,
+			(dma_addr_t *)&ioat_desc_phys, GFP_KERNEL);
+	if (!ioat_desc) {
+		printk(KERN_ERR I7300_PRINT "failed to allocate I/O AT desc\n");
+		goto err_mark_unused;
+	}
+
+	writel(ioat_desc_phys & 0xffffffffUL,
+	       ioat_chanbase + IOAT1_CHAINADDR_OFFSET_LOW);
+	writel(ioat_desc_phys >> 32,
+	       ioat_chanbase + IOAT1_CHAINADDR_OFFSET_HIGH);
+
+	if (i7300_idle_ioat_selftest(ioat_iomap, ioat_desc, ioat_desc_phys)) {
+		printk(KERN_ERR I7300_PRINT "I/O AT self-test failed\n");
+		goto err_free;
+	}
+
+	/* Setup circular I/O AT descriptor chain */
+	ioat_desc[0].ctl = IOAT_DESC_SADDR_SNP_CTL | IOAT_DESC_DADDR_SNP_CTL;
+	ioat_desc[0].src_addr = ioat_desc_phys + 2048;
+	ioat_desc[0].dst_addr = ioat_desc_phys + 3072;
+	ioat_desc[0].size = 128;
+	ioat_desc[0].next = ioat_desc_phys + sizeof(struct ioat_dma_descriptor);
+
+	ioat_desc[1].ctl = ioat_desc[0].ctl;
+	ioat_desc[1].src_addr = ioat_desc[0].src_addr;
+	ioat_desc[1].dst_addr = ioat_desc[0].dst_addr;
+	ioat_desc[1].size = ioat_desc[0].size;
+	ioat_desc[1].next = ioat_desc_phys;
+
+	return 0;
+
+err_free:
+	dma_free_coherent(&dummy_dma_dev, 4096, (void *)ioat_desc, 0);
+err_mark_unused:
+	writew(0, ioat_chanbase + IOAT_CHANCTRL_OFFSET);
+err_unmap:
+	iounmap(ioat_iomap);
+err_ret:
+	return -ENODEV;
+}
+
+/* Cleanup I/O AT */
+static void __exit i7300_idle_ioat_exit(void)
+{
+	int i;
+	u64 chan_sts;
+
+	i7300_idle_ioat_stop();
+
+	/* Wait for a while for the channel to halt before releasing */
+	for (i = 0; i < 10; i++) {
+		writeb(IOAT_CHANCMD_RESET,
+		       ioat_chanbase + IOAT1_CHANCMD_OFFSET);
+
+		chan_sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
+			IOAT_CHANSTS_DMA_TRANSFER_STATUS;
+
+		if (chan_sts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_ACTIVE) {
+			writew(0, ioat_chanbase + IOAT_CHANCTRL_OFFSET);
+			break;
+		}
+		udelay(1000);
+	}
+
+	chan_sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
+			IOAT_CHANSTS_DMA_TRANSFER_STATUS;
+
+	/*
+	 * We tried to reset multiple times. If IO A/T channel is still active
+	 * flag an error and return without cleanup. Memory leak is better
+	 * than random corruption in that extreme error situation.
+	 */
+	if (chan_sts == IOAT_CHANSTS_DMA_TRANSFER_STATUS_ACTIVE) {
+		printk(KERN_ERR I7300_PRINT "Unable to stop IO A/T channels."
+			" Not freeing resources\n");
+		return;
+	}
+
+	dma_free_coherent(&dummy_dma_dev, 4096, (void *)ioat_desc, 0);
+	iounmap(ioat_iomap);
+}
+
+/* End: I/O AT Helper routines */
+
+#define DIMM_THRTLOW 0x64
+#define DIMM_THRTCTL 0x67
+#define DIMM_THRTCTL_THRMHUNT (1UL << 0)
+#define DIMM_MC 0x40
+#define DIMM_GTW_MODE (1UL << 17)
+#define DIMM_GBLACT 0x60
+
+/*
+ * Keep track of an exponential-decaying average of recent idle durations.
+ * The latest duration gets DURATION_WEIGHT_PCT percentage weight
+ * in this average, with the old average getting the remaining weight.
+ *
+ * High weights emphasize recent history, low weights include long history.
+ */
+#define DURATION_WEIGHT_PCT 55
+
+/*
+ * When the decaying average of recent durations or the predicted duration
+ * of the next timer interrupt is shorter than duration_threshold, the
+ * driver will decline to throttle.
+ */
+#define DURATION_THRESHOLD_US 100
+
+
+/* Store DIMM thermal throttle configuration */
+static int i7300_idle_thrt_save(void)
+{
+	u32 new_mc_val;
+	u8 gblactlm;
+
+	pci_read_config_byte(fbd_dev, DIMM_THRTCTL, &i7300_idle_thrtctl_saved);
+	pci_read_config_byte(fbd_dev, DIMM_THRTLOW, &i7300_idle_thrtlow_saved);
+	pci_read_config_dword(fbd_dev, DIMM_MC, &i7300_idle_mc_saved);
+	/*
+	 * Make sure we have Global Throttling Window Mode set to have a
+	 * "short" window. This (mostly) works around an issue where
+	 * throttling persists until the end of the global throttling window
+	 * size. On the tested system, this was resulting in a maximum of
+	 * 64 ms to exit throttling (average 32 ms). The actual numbers
+	 * depends on system frequencies. Setting the short window reduces
+	 * this by a factor of 4096.
+	 *
+	 * We will only do this only if the system is set for
+	 * unlimited-activations while in open-loop throttling (i.e., when
+	 * Global Activation Throttle Limit is zero).
+	 */
+	pci_read_config_byte(fbd_dev, DIMM_GBLACT, &gblactlm);
+	dprintk("thrtctl_saved = 0x%02x, thrtlow_saved = 0x%02x\n",
+		i7300_idle_thrtctl_saved,
+		i7300_idle_thrtlow_saved);
+	dprintk("mc_saved = 0x%08x, gblactlm = 0x%02x\n",
+		i7300_idle_mc_saved,
+		gblactlm);
+	if (gblactlm == 0) {
+		new_mc_val = i7300_idle_mc_saved | DIMM_GTW_MODE;
+		pci_write_config_dword(fbd_dev, DIMM_MC, new_mc_val);
+		return 0;
+	} else {
+		dprintk("could not set GTW_MODE = 1 (OLTT enabled)\n");
+		return -ENODEV;
+	}
+}
+
+/* Restore DIMM thermal throttle configuration */
+static void i7300_idle_thrt_restore(void)
+{
+	pci_write_config_dword(fbd_dev, DIMM_MC, i7300_idle_mc_saved);
+	pci_write_config_byte(fbd_dev, DIMM_THRTLOW, i7300_idle_thrtlow_saved);
+	pci_write_config_byte(fbd_dev, DIMM_THRTCTL, i7300_idle_thrtctl_saved);
+}
+
+/* Enable DIMM thermal throttling */
+static void i7300_idle_start(void)
+{
+	u8 new_ctl;
+	u8 limit;
+
+	new_ctl = i7300_idle_thrtctl_saved & ~DIMM_THRTCTL_THRMHUNT;
+	pci_write_config_byte(fbd_dev, DIMM_THRTCTL, new_ctl);
+
+	limit = i7300_idle_thrtlowlm;
+	if (unlikely(limit > MAX_THRTLWLIMIT))
+		limit = MAX_THRTLWLIMIT;
+
+	pci_write_config_byte(fbd_dev, DIMM_THRTLOW, limit);
+
+	new_ctl = i7300_idle_thrtctl_saved | DIMM_THRTCTL_THRMHUNT;
+	pci_write_config_byte(fbd_dev, DIMM_THRTCTL, new_ctl);
+}
+
+/* Disable DIMM thermal throttling */
+static void i7300_idle_stop(void)
+{
+	u8 new_ctl;
+	u8 got_ctl;
+
+	new_ctl = i7300_idle_thrtctl_saved & ~DIMM_THRTCTL_THRMHUNT;
+	pci_write_config_byte(fbd_dev, DIMM_THRTCTL, new_ctl);
+
+	pci_write_config_byte(fbd_dev, DIMM_THRTLOW, i7300_idle_thrtlow_saved);
+	pci_write_config_byte(fbd_dev, DIMM_THRTCTL, i7300_idle_thrtctl_saved);
+	pci_read_config_byte(fbd_dev, DIMM_THRTCTL, &got_ctl);
+	WARN_ON_ONCE(got_ctl != i7300_idle_thrtctl_saved);
+}
+
+
+/*
+ * i7300_avg_duration_check()
+ * return 0 if the decaying average of recent idle durations is
+ * more than DURATION_THRESHOLD_US
+ */
+static int i7300_avg_duration_check(void)
+{
+	if (avg_idle_us >= DURATION_THRESHOLD_US)
+		return 0;
+
+#ifdef DEBUG
+	past_skip++;
+#endif
+	return 1;
+}
+
+/* Idle notifier to look at idle CPUs */
+static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
+				void *data)
+{
+	unsigned long flags;
+	ktime_t now_ktime;
+	static ktime_t idle_begin_time;
+	static int time_init = 1;
+
+	if (!i7300_idle_thrtlowlm)
+		return 0;
+
+	if (unlikely(time_init)) {
+		time_init = 0;
+		idle_begin_time = ktime_get();
+	}
+
+	spin_lock_irqsave(&i7300_idle_lock, flags);
+	if (val == IDLE_START) {
+
+		cpu_set(smp_processor_id(), idle_cpumask);
+
+		if (cpus_weight(idle_cpumask) != num_online_cpus())
+			goto end;
+
+		now_ktime = ktime_get();
+		idle_begin_time = now_ktime;
+
+		if (i7300_avg_duration_check())
+			goto end;
+
+		i7300_idle_active = 1;
+		total_starts++;
+		start_ktime = now_ktime;
+
+		i7300_idle_start();
+		i7300_idle_ioat_start();
+
+	} else if (val == IDLE_END) {
+		cpu_clear(smp_processor_id(), idle_cpumask);
+		if (cpus_weight(idle_cpumask) == (num_online_cpus() - 1)) {
+			/* First CPU coming out of idle */
+			u64 idle_duration_us;
+
+			now_ktime = ktime_get();
+
+			idle_duration_us = ktime_to_us(ktime_sub
+						(now_ktime, idle_begin_time));
+
+			avg_idle_us =
+				((100 - DURATION_WEIGHT_PCT) * avg_idle_us +
+				 DURATION_WEIGHT_PCT * idle_duration_us) / 100;
+
+			if (i7300_idle_active) {
+				ktime_t idle_ktime;
+
+				idle_ktime = ktime_sub(now_ktime, start_ktime);
+				total_us += ktime_to_us(idle_ktime);
+
+				i7300_idle_ioat_stop();
+				i7300_idle_stop();
+				i7300_idle_active = 0;
+			}
+		}
+	}
+end:
+	spin_unlock_irqrestore(&i7300_idle_lock, flags);
+	return 0;
+}
+
+static struct notifier_block i7300_idle_nb = {
+	.notifier_call = i7300_idle_notifier,
+};
+
+/*
+ * I/O AT controls (PCI bus 0 device 8 function 0)
+ * DIMM controls (PCI bus 0 device 16 function 1)
+ */
+#define IOAT_BUS 0
+#define IOAT_DEVFN PCI_DEVFN(8, 0)
+#define MEMCTL_BUS 0
+#define MEMCTL_DEVFN PCI_DEVFN(16, 1)
+
+struct fbd_ioat {
+	unsigned int vendor;
+	unsigned int ioat_dev;
+};
+
+/*
+ * The i5000 chip-set has the same hooks as the i7300
+ * but support is disabled by default because this driver
+ * has not been validated on that platform.
+ */
+#define SUPPORT_I5000 0
+
+static const struct fbd_ioat fbd_ioat_list[] = {
+	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB},
+#if SUPPORT_I5000
+	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT},
+#endif
+	{0, 0}
+};
+
+/* table of devices that work with this driver */
+static const struct pci_device_id pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_FBD_CNB) },
+#if SUPPORT_I5000
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
+#endif
+	{ } /* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(pci, pci_tbl);
+
+/* Check for known platforms with I/O-AT */
+static int __init i7300_idle_platform_probe(void)
+{
+	int i;
+
+	fbd_dev = pci_get_bus_and_slot(MEMCTL_BUS, MEMCTL_DEVFN);
+	if (!fbd_dev)
+		return -ENODEV;
+
+	for (i = 0; pci_tbl[i].vendor != 0; i++) {
+		if (fbd_dev->vendor == pci_tbl[i].vendor &&
+		    fbd_dev->device == pci_tbl[i].device) {
+			break;
+		}
+	}
+	if (pci_tbl[i].vendor == 0)
+		return -ENODEV;
+
+	ioat_dev = pci_get_bus_and_slot(IOAT_BUS, IOAT_DEVFN);
+	if (!ioat_dev)
+		return -ENODEV;
+
+	for (i = 0; fbd_ioat_list[i].vendor != 0; i++) {
+		if (ioat_dev->vendor == fbd_ioat_list[i].vendor &&
+		    ioat_dev->device == fbd_ioat_list[i].ioat_dev) {
+			return 0;
+		}
+	}
+	return -ENODEV;
+}
+
+int stats_open_generic(struct inode *inode, struct file *fp)
+{
+	fp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t stats_read_ul(struct file *fp, char __user *ubuf, size_t count,
+				loff_t *off)
+{
+	unsigned long *p = fp->private_data;
+	char buf[32];
+	int len;
+
+	len = snprintf(buf, 32, "%lu\n", *p);
+	return simple_read_from_buffer(ubuf, count, off, buf, len);
+}
+
+static const struct file_operations idle_fops = {
+	.open	= stats_open_generic,
+	.read	= stats_read_ul,
+};
+
+struct debugfs_file_info {
+	void *ptr;
+	char name[32];
+	struct dentry *file;
+} debugfs_file_list[] = {
+				{&total_starts, "total_starts", NULL},
+				{&total_us, "total_us", NULL},
+#ifdef DEBUG
+				{&past_skip, "past_skip", NULL},
+#endif
+				{NULL, "", NULL}
+			};
+
+static int __init i7300_idle_init(void)
+{
+	spin_lock_init(&i7300_idle_lock);
+	cpus_clear(idle_cpumask);
+	total_us = 0;
+
+	if (i7300_idle_platform_probe())
+		return -ENODEV;
+
+	if (i7300_idle_thrt_save())
+		return -ENODEV;
+
+	if (i7300_idle_ioat_init())
+		return -ENODEV;
+
+	debugfs_dir = debugfs_create_dir("i7300_idle", NULL);
+	if (debugfs_dir) {
+		int i = 0;
+
+		while (debugfs_file_list[i].ptr != NULL) {
+			debugfs_file_list[i].file = debugfs_create_file(
+					debugfs_file_list[i].name,
+					S_IRUSR,
+					debugfs_dir,
+					debugfs_file_list[i].ptr,
+					&idle_fops);
+			i++;
+		}
+	}
+
+	idle_notifier_register(&i7300_idle_nb);
+
+	printk(KERN_INFO "i7300_idle: loaded v%s\n", I7300_IDLE_DRIVER_VERSION);
+	return 0;
+}
+
+static void __exit i7300_idle_exit(void)
+{
+	idle_notifier_unregister(&i7300_idle_nb);
+
+	if (debugfs_dir) {
+		int i = 0;
+
+		while (debugfs_file_list[i].file != NULL) {
+			debugfs_remove(debugfs_file_list[i].file);
+			i++;
+		}
+
+		debugfs_remove(debugfs_dir);
+	}
+	i7300_idle_thrt_restore();
+	i7300_idle_ioat_exit();
+}
+
+module_init(i7300_idle_init);
+module_exit(i7300_idle_exit);
+
+MODULE_AUTHOR("Andy Henroid <andrew.d.henroid@intel.com>");
+MODULE_DESCRIPTION("Intel Chipset DIMM Idle Power Saving Driver v"
+			I7300_IDLE_DRIVER_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/include/asm-x86/idle.h b/include/asm-x86/idle.h
index cbb6491..54ce018 100644
--- a/include/asm-x86/idle.h
+++ b/include/asm-x86/idle.h
@@ -6,6 +6,7 @@
 
 struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
+void idle_notifier_unregister(struct notifier_block *n);
 
 void enter_idle(void);
 void exit_idle(void);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..efb786d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2422,6 +2422,7 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_FBD_CNB	0x360c
 #define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
 #define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
 #define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
-- 
1.6.0.2.532.g84ed4c

