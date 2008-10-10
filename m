Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYJJALz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYJJALz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYJJALp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:11:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYJJALo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:11:44 -0400
Date: Fri, 10 Oct 2008 02:11:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #8, hpet
Message-ID: <20081010001131.GA12529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-v28-for-linus-phase8 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase8

HPET updates part 1. (part two will be the per-CPU MSI HPET feature)

out-of-topic modifications in x86-v28-for-linus-phase8:
-------------------------------------------------------
drivers/char/hpet.c                # f92a789: hpet: /dev/hpet - fixes and clean
                                   # 64a76f6: hpet: /dev/hpet - fixes and clean
                                   # 70ef6d5: x86: get irq for hpet timer
include/linux/hpet.h               # 64a76f6: hpet: /dev/hpet - fixes and clean
                                   # 70ef6d5: x86: get irq for hpet timer

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: hpet: modify IXP400 quirk to enable interrupts

David Brownell (2):
      hpet: /dev/hpet - fixes and cleanup
      hpet: /dev/hpet - fixes and cleanup, fix

Joe Buehler (1):
      x86: add PCI ID for 6300ESB force hpet

Jordan Crouse (1):
      x86, hpet: SB600 - remove HPET resources from PCI device

Kevin Hao (1):
      x86: get irq for hpet timer

Krzysztof Oledzki (1):
      x86: add another PCI ID for ICH6 force-hpet

Randy Dunlap (1):
      documentation: move hpet.txt to timers/ subdirectory


 Documentation/00-INDEX              |    2 -
 Documentation/timers/00-INDEX       |   10 ++
 Documentation/{ => timers}/hpet.txt |   43 +++++-----
 arch/x86/kernel/hpet.c              |    6 +-
 arch/x86/kernel/quirks.c            |   41 +++++++++-
 arch/x86/pci/fixup.c                |   28 ++++++
 drivers/char/hpet.c                 |  155 ++++++++++++++++++++---------------
 include/linux/hpet.h                |   14 +---
 8 files changed, 195 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/timers/00-INDEX
 rename Documentation/{ => timers}/hpet.txt (81%)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 7306081..4382778 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -159,8 +159,6 @@ hayes-esp.txt
 	- info on using the Hayes ESP serial driver.
 highuid.txt
 	- notes on the change from 16 bit to 32 bit user/group IDs.
-hpet.txt
-	- High Precision Event Timer Driver for Linux.
 timers/
 	- info on the timer related topics
 hw_random.txt
diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
new file mode 100644
index 0000000..397dc35
--- /dev/null
+++ b/Documentation/timers/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file
+highres.txt
+	- High resolution timers and dynamic ticks design notes
+hpet.txt
+	- High Precision Event Timer Driver for Linux
+hrtimers.txt
+	- subsystem for high-resolution kernel timers
+timer_stats.txt
+	- timer usage statistics
diff --git a/Documentation/hpet.txt b/Documentation/timers/hpet.txt
similarity index 81%
rename from Documentation/hpet.txt
rename to Documentation/timers/hpet.txt
index 6ad52d9..e7c09ab 100644
--- a/Documentation/hpet.txt
+++ b/Documentation/timers/hpet.txt
@@ -1,21 +1,32 @@
 		High Precision Event Timer Driver for Linux
 
-The High Precision Event Timer (HPET) hardware is the future replacement
-for the 8254 and Real Time Clock (RTC) periodic timer functionality.
-Each HPET can have up to 32 timers.  It is possible to configure the
-first two timers as legacy replacements for 8254 and RTC periodic timers.
-A specification done by Intel and Microsoft can be found at
-<http://www.intel.com/technology/architecture/hpetspec.htm>.
+The High Precision Event Timer (HPET) hardware follows a specification
+by Intel and Microsoft which can be found at
+
+	http://www.intel.com/technology/architecture/hpetspec.htm
+
+Each HPET has one fixed-rate counter (at 10+ MHz, hence "High Precision")
+and up to 32 comparators.  Normally three or more comparators are provided,
+each of which can generate oneshot interupts and at least one of which has
+additional hardware to support periodic interrupts.  The comparators are
+also called "timers", which can be misleading since usually timers are
+independent of each other ... these share a counter, complicating resets.
+
+HPET devices can support two interrupt routing modes.  In one mode, the
+comparators are additional interrupt sources with no particular system
+role.  Many x86 BIOS writers don't route HPET interrupts at all, which
+prevents use of that mode.  They support the other "legacy replacement"
+mode where the first two comparators block interrupts from 8254 timers
+and from the RTC.
 
 The driver supports detection of HPET driver allocation and initialization
 of the HPET before the driver module_init routine is called.  This enables
 platform code which uses timer 0 or 1 as the main timer to intercept HPET
 initialization.  An example of this initialization can be found in
-arch/i386/kernel/time_hpet.c.
+arch/x86/kernel/hpet.c.
 
-The driver provides two APIs which are very similar to the API found in
-the rtc.c driver.  There is a user space API and a kernel space API.
-An example user space program is provided below.
+The driver provides a userspace API which resembles the API found in the
+RTC driver framework.  An example user space program is provided below.
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -286,15 +297,3 @@ out:
 
 	return;
 }
-
-The kernel API has three interfaces exported from the driver:
-
-	hpet_register(struct hpet_task *tp, int periodic)
-	hpet_unregister(struct hpet_task *tp)
-	hpet_control(struct hpet_task *tp, unsigned int cmd, unsigned long arg)
-
-The kernel module using this interface fills in the ht_func and ht_data
-members of the hpet_task structure before calling hpet_register.
-hpet_control simply vectors to the hpet_ioctl routine and has the same
-commands and respective arguments as the user API.  hpet_unregister
-is used to terminate usage of the HPET timer reserved by hpet_register.
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 73deaff..acf62fc 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -115,13 +115,17 @@ static void hpet_reserve_platform_timers(unsigned long id)
 	hd.hd_phys_address = hpet_address;
 	hd.hd_address = hpet;
 	hd.hd_nirqs = nrtimers;
-	hd.hd_flags = HPET_DATA_PLATFORM;
 	hpet_reserve_timer(&hd, 0);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	hpet_reserve_timer(&hd, 1);
 #endif
 
+	/*
+	 * NOTE that hd_irq[] reflects IOAPIC input pins (LEGACY_8254
+	 * is wrong for i8259!) not the output IRQ.  Many BIOS writers
+	 * don't bother configuring *any* comparator interrupts.
+	 */
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d138588..f6a11b9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,9 +354,27 @@ static void ati_force_hpet_resume(void)
 	printk(KERN_DEBUG "Force enabled HPET at resume\n");
 }
 
+static u32 ati_ixp4x0_rev(struct pci_dev *dev)
+{
+	u32 d;
+	u8  b;
+
+	pci_read_config_byte(dev, 0xac, &b);
+	b &= ~(1<<5);
+	pci_write_config_byte(dev, 0xac, b);
+	pci_read_config_dword(dev, 0x70, &d);
+	d |= 1<<8;
+	pci_write_config_dword(dev, 0x70, d);
+	pci_read_config_dword(dev, 0x8, &d);
+	d &= 0xff;
+	dev_printk(KERN_DEBUG, &dev->dev, "SB4X0 revision 0x%x\n", d);
+	return d;
+}
+
 static void ati_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 d, val;
+	u8  b;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -366,14 +384,33 @@ static void ati_force_enable_hpet(struct pci_dev *dev)
 		return;
 	}
 
+	d = ati_ixp4x0_rev(dev);
+	if (d  < 0x82)
+		return;
+
+	/* base address */
 	pci_write_config_dword(dev, 0x14, 0xfed00000);
 	pci_read_config_dword(dev, 0x14, &val);
+
+	/* enable interrupt */
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	b |= 0x1;
+	outb(0x72, 0xcd6); outb(b, 0xcd7);
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	if (!(b & 0x1))
+		return;
+	pci_read_config_dword(dev, 0x64, &d);
+	d |= (1<<10);
+	pci_write_config_dword(dev, 0x64, d);
+	pci_read_config_dword(dev, 0x64, &d);
+	if (!(d & (1<<10)))
+		return;
+
 	force_hpet_address = val;
 	force_hpet_resume_type = ATI_FORCE_HPET_RESUME;
 	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		   force_hpet_address);
 	cached_dev = dev;
-	return;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 			 ati_force_enable_hpet);
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 4bdaa59..3c27a80 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -511,3 +511,31 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
+
+/*
+ * SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
+ * confusing the PCI engine:
+ */
+static void sb600_disable_hpet_bar(struct pci_dev *dev)
+{
+	u8 val;
+
+	/*
+	 * The SB600 and SB700 both share the same device
+	 * ID, but the PM register 0x55 does something different
+	 * for the SB700, so make sure we are dealing with the
+	 * SB600 before touching the bit:
+	 */
+
+	pci_read_config_byte(dev, 0x08, &val);
+
+	if (val < 0x2F) {
+		outb(0x55, 0xCD6);
+		val = inb(0xCD7);
+
+		/* Set bit 7 in PM register 0x55 */
+		outb(0x55, 0xCD6);
+		outb(val | 0x80, 0xCD7);
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..2908a0e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -53,6 +53,11 @@
 
 #define HPET_RANGE_SIZE		1024	/* from HPET spec */
 
+
+/* WARNING -- don't get confused.  These macros are never used
+ * to write the (single) counter, and rarely to read it.
+ * They're badly named; to fix, someday.
+ */
 #if BITS_PER_LONG == 64
 #define	write_counter(V, MC)	writeq(V, MC)
 #define	read_counter(MC)	readq(MC)
@@ -77,7 +82,7 @@ static struct clocksource clocksource_hpet = {
         .rating         = 250,
         .read           = read_hpet,
         .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
+	.mult		= 0, /* to be calculated */
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -86,8 +91,6 @@ static struct clocksource *hpet_clocksource;
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
-/* A lock for concurrent intermodule access to hpet and isr hpet activity. */
-static DEFINE_SPINLOCK(hpet_task_lock);
 
 #define	HPET_DEV_NAME	(7)
 
@@ -99,7 +102,6 @@ struct hpet_dev {
 	unsigned long hd_irqdata;
 	wait_queue_head_t hd_waitqueue;
 	struct fasync_struct *hd_async_queue;
-	struct hpet_task *hd_task;
 	unsigned int hd_flags;
 	unsigned int hd_irq;
 	unsigned int hd_hdwirq;
@@ -173,11 +175,6 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 		writel(isr, &devp->hd_hpet->hpet_isr);
 	spin_unlock(&hpet_lock);
 
-	spin_lock(&hpet_task_lock);
-	if (devp->hd_task)
-		devp->hd_task->ht_func(devp->hd_task->ht_data);
-	spin_unlock(&hpet_task_lock);
-
 	wake_up_interruptible(&devp->hd_waitqueue);
 
 	kill_fasync(&devp->hd_async_queue, SIGIO, POLL_IN);
@@ -185,6 +182,67 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void hpet_timer_set_irq(struct hpet_dev *devp)
+{
+	unsigned long v;
+	int irq, gsi;
+	struct hpet_timer __iomem *timer;
+
+	spin_lock_irq(&hpet_lock);
+	if (devp->hd_hdwirq) {
+		spin_unlock_irq(&hpet_lock);
+		return;
+	}
+
+	timer = devp->hd_timer;
+
+	/* we prefer level triggered mode */
+	v = readl(&timer->hpet_config);
+	if (!(v & Tn_INT_TYPE_CNF_MASK)) {
+		v |= Tn_INT_TYPE_CNF_MASK;
+		writel(v, &timer->hpet_config);
+	}
+	spin_unlock_irq(&hpet_lock);
+
+	v = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK) >>
+				 Tn_INT_ROUTE_CAP_SHIFT;
+
+	/*
+	 * In PIC mode, skip IRQ0-4, IRQ6-9, IRQ12-15 which is always used by
+	 * legacy device. In IO APIC mode, we skip all the legacy IRQS.
+	 */
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC)
+		v &= ~0xf3df;
+	else
+		v &= ~0xffff;
+
+	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
+		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
+
+		if (irq >= NR_IRQS) {
+			irq = HPET_MAX_IRQ;
+			break;
+		}
+
+		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
+					ACPI_ACTIVE_LOW);
+		if (gsi > 0)
+			break;
+
+		/* FIXME: Setup interrupt source table */
+	}
+
+	if (irq < HPET_MAX_IRQ) {
+		spin_lock_irq(&hpet_lock);
+		v = readl(&timer->hpet_config);
+		v |= irq << Tn_INT_ROUTE_CNF_SHIFT;
+		writel(v, &timer->hpet_config);
+		devp->hd_hdwirq = gsi;
+		spin_unlock_irq(&hpet_lock);
+	}
+	return;
+}
+
 static int hpet_open(struct inode *inode, struct file *file)
 {
 	struct hpet_dev *devp;
@@ -199,8 +257,7 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
-			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN
-			    || hpetp->hp_dev[i].hd_task)
+			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
 				continue;
 			else {
 				devp = &hpetp->hp_dev[i];
@@ -219,6 +276,8 @@ static int hpet_open(struct inode *inode, struct file *file)
 	spin_unlock_irq(&hpet_lock);
 	unlock_kernel();
 
+	hpet_timer_set_irq(devp);
+
 	return 0;
 }
 
@@ -441,7 +500,11 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	devp->hd_irq = irq;
 	t = devp->hd_ireqfreq;
 	v = readq(&timer->hpet_config);
-	g = v | Tn_INT_ENB_CNF_MASK;
+
+	/* 64-bit comparators are not yet supported through the ioctls,
+	 * so force this into 32-bit mode if it supports both modes
+	 */
+	g = v | Tn_32MODE_CNF_MASK | Tn_INT_ENB_CNF_MASK;
 
 	if (devp->hd_flags & HPET_PERIODIC) {
 		write_counter(t, &timer->hpet_compare);
@@ -451,6 +514,12 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 		v |= Tn_VAL_SET_CNF_MASK;
 		writeq(v, &timer->hpet_config);
 		local_irq_save(flags);
+
+		/* NOTE:  what we modify here is a hidden accumulator
+		 * register supported by periodic-capable comparators.
+		 * We never want to modify the (single) counter; that
+		 * would affect all the comparators.
+		 */
 		m = read_counter(&hpet->hpet_mc);
 		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
 	} else {
@@ -604,57 +673,6 @@ static int hpet_is_known(struct hpet_data *hdp)
 	return 0;
 }
 
-static inline int hpet_tpcheck(struct hpet_task *tp)
-{
-	struct hpet_dev *devp;
-	struct hpets *hpetp;
-
-	devp = tp->ht_opaque;
-
-	if (!devp)
-		return -ENXIO;
-
-	for (hpetp = hpets; hpetp; hpetp = hpetp->hp_next)
-		if (devp >= hpetp->hp_dev
-		    && devp < (hpetp->hp_dev + hpetp->hp_ntimer)
-		    && devp->hd_hpet == hpetp->hp_hpet)
-			return 0;
-
-	return -ENXIO;
-}
-
-#if 0
-int hpet_unregister(struct hpet_task *tp)
-{
-	struct hpet_dev *devp;
-	struct hpet_timer __iomem *timer;
-	int err;
-
-	if ((err = hpet_tpcheck(tp)))
-		return err;
-
-	spin_lock_irq(&hpet_task_lock);
-	spin_lock(&hpet_lock);
-
-	devp = tp->ht_opaque;
-	if (devp->hd_task != tp) {
-		spin_unlock(&hpet_lock);
-		spin_unlock_irq(&hpet_task_lock);
-		return -ENXIO;
-	}
-
-	timer = devp->hd_timer;
-	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
-	       &timer->hpet_config);
-	devp->hd_flags &= ~(HPET_IE | HPET_PERIODIC);
-	devp->hd_task = NULL;
-	spin_unlock(&hpet_lock);
-	spin_unlock_irq(&hpet_task_lock);
-
-	return 0;
-}
-#endif  /*  0  */
-
 static ctl_table hpet_table[] = {
 	{
 	 .ctl_name = CTL_UNNUMBERED,
@@ -746,6 +764,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	static struct hpets *last = NULL;
 	unsigned long period;
 	unsigned long long temp;
+	u32 remainder;
 
 	/*
 	 * hpet_alloc can be called by platform dependent code.
@@ -809,9 +828,13 @@ int hpet_alloc(struct hpet_data *hdp)
 		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
 	printk("\n");
 
-	printk(KERN_INFO "hpet%u: %u %d-bit timers, %Lu Hz\n",
-	       hpetp->hp_which, hpetp->hp_ntimer,
-	       cap & HPET_COUNTER_SIZE_MASK ? 64 : 32, hpetp->hp_tick_freq);
+	temp = hpetp->hp_tick_freq;
+	remainder = do_div(temp, 1000000);
+	printk(KERN_INFO
+		"hpet%u: %u comparators, %d-bit %u.%06u MHz counter\n",
+		hpetp->hp_which, hpetp->hp_ntimer,
+		cap & HPET_COUNTER_SIZE_MASK ? 64 : 32,
+		(unsigned) temp, remainder);
 
 	mcfg = readq(&hpet->hpet_config);
 	if ((mcfg & HPET_ENABLE_CNF_MASK) == 0) {
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 2dc29ce..79f63a2 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -37,6 +37,7 @@ struct hpet {
 #define	hpet_compare	_u1._hpet_compare
 
 #define	HPET_MAX_TIMERS	(32)
+#define	HPET_MAX_IRQ	(32)
 
 /*
  * HPET general capabilities register
@@ -64,7 +65,7 @@ struct hpet {
  */
 
 #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
-#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
+#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
 #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
 #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
 #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)
@@ -91,23 +92,14 @@ struct hpet {
  * exported interfaces
  */
 
-struct hpet_task {
-	void (*ht_func) (void *);
-	void *ht_data;
-	void *ht_opaque;
-};
-
 struct hpet_data {
 	unsigned long hd_phys_address;
 	void __iomem *hd_address;
 	unsigned short hd_nirqs;
-	unsigned short hd_flags;
 	unsigned int hd_state;	/* timer allocated */
 	unsigned int hd_irq[HPET_MAX_TIMERS];
 };
 
-#define	HPET_DATA_PLATFORM	0x0001	/* platform call to hpet_alloc */
-
 static inline void hpet_reserve_timer(struct hpet_data *hd, int timer)
 {
 	hd->hd_state |= (1 << timer);
@@ -125,7 +117,7 @@ struct hpet_info {
 	unsigned short hi_timer;
 };
 
-#define	HPET_INFO_PERIODIC	0x0001	/* timer is periodic */
+#define HPET_INFO_PERIODIC	0x0010	/* periodic-capable comparator */
 
 #define	HPET_IE_ON	_IO('h', 0x01)	/* interrupt on */
 #define	HPET_IE_OFF	_IO('h', 0x02)	/* interrupt off */
