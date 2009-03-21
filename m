Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZCULqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZCULqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZCULqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:46:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZCULqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:46:09 -0400
Subject: [git-pull -tip] x86: cleanup patches 20090321
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 17:15:31 +0530
Message-Id: <1237635931.2409.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log files are available at:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tiptop.git;a=shortlog;h=x86/core

The following changes since commit 7f00a2495bf5b98b097c47be5d6e2d4114ec39bf:
  Ingo Molnar (1):
        Merge branches 'x86/cleanups', 'x86/mm', 'x86/setup' and 'linus' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git x86/core

Jaswinder Singh Rajput (6):
      x86: topology.c cleanup
      x86: kdebugfs.c cleanup
      x86: i8253 cleanup
      x86: rtc.c cleanup
      x86: io_delay.c cleanup
      x86: pci-nommu.c cleanup

 arch/x86/kernel/i8253.c     |   68 +++++++++++++++++------------------
 arch/x86/kernel/io_delay.c  |   27 +++++++-------
 arch/x86/kernel/kdebugfs.c  |   82 +++++++++++++++++++------------------------
 arch/x86/kernel/pci-nommu.c |   20 +++++-----
 arch/x86/kernel/rtc.c       |   20 ++++++-----
 arch/x86/kernel/topology.c  |   14 ++++---
 6 files changed, 111 insertions(+), 120 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 10f92fb..3475440 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -3,17 +3,17 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
 
-#include <asm/smp.h>
-#include <asm/delay.h>
 #include <asm/i8253.h>
-#include <asm/io.h>
 #include <asm/hpet.h>
+#include <asm/smp.h>
 
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
@@ -40,7 +40,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 {
 	spin_lock(&i8253_lock);
 
-	switch(mode) {
+	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_pit(0x34, PIT_MODE);
@@ -95,7 +95,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
-static struct clock_event_device pit_clockevent = {
+static struct clock_event_device pit_ce = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
@@ -114,15 +114,13 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	pit_clockevent.cpumask = cpumask_of(smp_processor_id());
-	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
-				     pit_clockevent.shift);
-	pit_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFF, &pit_clockevent);
-	pit_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xF, &pit_clockevent);
-	clockevents_register_device(&pit_clockevent);
-	global_clock_event = &pit_clockevent;
+	pit_ce.cpumask = cpumask_of(smp_processor_id());
+	pit_ce.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
+	pit_ce.max_delta_ns = clockevent_delta2ns(0x7FFF, &pit_ce);
+	pit_ce.min_delta_ns = clockevent_delta2ns(0xF, &pit_ce);
+
+	clockevents_register_device(&pit_ce);
+	global_clock_event = &pit_ce;
 }
 
 #ifndef CONFIG_X86_64
@@ -133,11 +131,11 @@ void __init setup_pit_timer(void)
  */
 static cycle_t pit_read(void)
 {
+	static int old_count;
+	static u32 old_jifs;
 	unsigned long flags;
 	int count;
 	u32 jifs;
-	static int old_count;
-	static u32 old_jifs;
 
 	spin_lock_irqsave(&i8253_lock, flags);
 	/*
@@ -179,9 +177,9 @@ static cycle_t pit_read(void)
 	 * Previous attempts to handle these cases intelligently were
 	 * buggy, so we just do the simple thing now.
 	 */
-	if (count > old_count && jifs == old_jifs) {
+	if (count > old_count && jifs == old_jifs)
 		count = old_count;
-	}
+
 	old_count = count;
 	old_jifs = jifs;
 
@@ -192,13 +190,13 @@ static cycle_t pit_read(void)
 	return (cycle_t)(jifs * LATCH) + count;
 }
 
-static struct clocksource clocksource_pit = {
-	.name	= "pit",
-	.rating = 110,
-	.read	= pit_read,
-	.mask	= CLOCKSOURCE_MASK(32),
-	.mult	= 0,
-	.shift	= 20,
+static struct clocksource pit_cs = {
+	.name		= "pit",
+	.rating		= 110,
+	.read		= pit_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.mult		= 0,
+	.shift		= 20,
 };
 
 static void pit_disable_clocksource(void)
@@ -206,9 +204,9 @@ static void pit_disable_clocksource(void)
 	/*
 	 * Use mult to check whether it is registered or not
 	 */
-	if (clocksource_pit.mult) {
-		clocksource_unregister(&clocksource_pit);
-		clocksource_pit.mult = 0;
+	if (pit_cs.mult) {
+		clocksource_unregister(&pit_cs);
+		pit_cs.mult = 0;
 	}
 }
 
@@ -222,13 +220,13 @@ static int __init init_pit_clocksource(void)
 	  * - when local APIC timer is active (PIT is switched off)
 	  */
 	if (num_possible_cpus() > 1 || is_hpet_enabled() ||
-	    pit_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
+	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE,
-						   clocksource_pit.shift);
-	return clocksource_register(&clocksource_pit);
+	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
+
+	return clocksource_register(&pit_cs);
 }
 arch_initcall(init_pit_clocksource);
 
-#endif
+#endif /* !CONFIG_X86_64 */
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index 720d260..a979b5b 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -7,10 +7,10 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
 
@@ -47,8 +47,7 @@ EXPORT_SYMBOL(native_io_delay);
 static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
 {
 	if (io_delay_type == CONFIG_IO_DELAY_TYPE_0X80) {
-		printk(KERN_NOTICE "%s: using 0xed I/O delay port\n",
-			id->ident);
+		pr_notice("%s: using 0xed I/O delay port\n", id->ident);
 		io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
 	}
 
@@ -64,40 +63,40 @@ static struct dmi_system_id __initdata io_delay_0xed_port_dmi_table[] = {
 		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "Compaq Presario V6000",
 		.matches	= {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
-			DMI_MATCH(DMI_BOARD_NAME, "30B7")
+			DMI_MATCH(DMI_BOARD_VENDOR,	"Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME,	"30B7")
 		}
 	},
 	{
 		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "HP Pavilion dv9000z",
 		.matches	= {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
-			DMI_MATCH(DMI_BOARD_NAME, "30B9")
+			DMI_MATCH(DMI_BOARD_VENDOR,	"Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME,	"30B9")
 		}
 	},
 	{
 		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "HP Pavilion dv6000",
 		.matches	= {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
-			DMI_MATCH(DMI_BOARD_NAME, "30B8")
+			DMI_MATCH(DMI_BOARD_VENDOR,	"Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME,	"30B8")
 		}
 	},
 	{
 		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "HP Pavilion tx1000",
 		.matches	= {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
-			DMI_MATCH(DMI_BOARD_NAME, "30BF")
+			DMI_MATCH(DMI_BOARD_VENDOR,	"Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME,	"30BF")
 		}
 	},
 	{
 		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "Presario F700",
 		.matches	= {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
-			DMI_MATCH(DMI_BOARD_NAME, "30D3")
+			DMI_MATCH(DMI_BOARD_VENDOR,	"Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME,	"30D3")
 		}
 	},
 	{ }
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index ff7d3b0..e444357 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -8,11 +8,11 @@
  */
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
-#include <linux/stat.h>
+#include <linux/module.h>
 #include <linux/init.h>
+#include <linux/stat.h>
 #include <linux/io.h>
 #include <linux/mm.h>
-#include <linux/module.h>
 
 #include <asm/setup.h>
 
@@ -26,9 +26,8 @@ struct setup_data_node {
 	u32 len;
 };
 
-static ssize_t
-setup_data_read(struct file *file, char __user *user_buf, size_t count,
-		loff_t *ppos)
+static ssize_t setup_data_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
 {
 	struct setup_data_node *node = file->private_data;
 	unsigned long remain;
@@ -39,20 +38,21 @@ setup_data_read(struct file *file, char __user *user_buf, size_t count,
 
 	if (pos < 0)
 		return -EINVAL;
+
 	if (pos >= node->len)
 		return 0;
 
 	if (count > node->len - pos)
 		count = node->len - pos;
+
 	pa = node->paddr + sizeof(struct setup_data) + pos;
 	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
 	if (PageHighMem(pg)) {
 		p = ioremap_cache(pa, count);
 		if (!p)
 			return -ENXIO;
-	} else {
+	} else
 		p = __va(pa);
-	}
 
 	remain = copy_to_user(user_buf, p, count);
 
@@ -70,12 +70,13 @@ setup_data_read(struct file *file, char __user *user_buf, size_t count,
 static int setup_data_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
+
 	return 0;
 }
 
 static const struct file_operations fops_setup_data = {
-	.read =		setup_data_read,
-	.open =		setup_data_open,
+	.read		= setup_data_read,
+	.open		= setup_data_open,
 };
 
 static int __init
@@ -84,57 +85,50 @@ create_setup_data_node(struct dentry *parent, int no,
 {
 	struct dentry *d, *type, *data;
 	char buf[16];
-	int error;
 
 	sprintf(buf, "%d", no);
 	d = debugfs_create_dir(buf, parent);
-	if (!d) {
-		error = -ENOMEM;
-		goto err_return;
-	}
+	if (!d)
+		return -ENOMEM;
+
 	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
-	if (!type) {
-		error = -ENOMEM;
+	if (!type)
 		goto err_dir;
-	}
+
 	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
-	if (!data) {
-		error = -ENOMEM;
+	if (!data)
 		goto err_type;
-	}
+
 	return 0;
 
 err_type:
 	debugfs_remove(type);
 err_dir:
 	debugfs_remove(d);
-err_return:
-	return error;
+	return -ENOMEM;
 }
 
 static int __init create_setup_data_nodes(struct dentry *parent)
 {
 	struct setup_data_node *node;
 	struct setup_data *data;
-	int error, no = 0;
+	int error = -ENOMEM;
 	struct dentry *d;
 	struct page *pg;
 	u64 pa_data;
+	int no = 0;
 
 	d = debugfs_create_dir("setup_data", parent);
-	if (!d) {
-		error = -ENOMEM;
-		goto err_return;
-	}
+	if (!d)
+		return -ENOMEM;
 
 	pa_data = boot_params.hdr.setup_data;
 
 	while (pa_data) {
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
-		if (!node) {
-			error = -ENOMEM;
+		if (!node)
 			goto err_dir;
-		}
+
 		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
 		if (PageHighMem(pg)) {
 			data = ioremap_cache(pa_data, sizeof(*data));
@@ -143,9 +137,8 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 				error = -ENXIO;
 				goto err_dir;
 			}
-		} else {
+		} else
 			data = __va(pa_data);
-		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -159,11 +152,11 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 			goto err_dir;
 		no++;
 	}
+
 	return 0;
 
 err_dir:
 	debugfs_remove(d);
-err_return:
 	return error;
 }
 
@@ -175,28 +168,26 @@ static struct debugfs_blob_wrapper boot_params_blob = {
 static int __init boot_params_kdebugfs_init(void)
 {
 	struct dentry *dbp, *version, *data;
-	int error;
+	int error = -ENOMEM;
 
 	dbp = debugfs_create_dir("boot_params", NULL);
-	if (!dbp) {
-		error = -ENOMEM;
-		goto err_return;
-	}
+	if (!dbp)
+		return -ENOMEM;
+
 	version = debugfs_create_x16("version", S_IRUGO, dbp,
 				     &boot_params.hdr.version);
-	if (!version) {
-		error = -ENOMEM;
+	if (!version)
 		goto err_dir;
-	}
+
 	data = debugfs_create_blob("data", S_IRUGO, dbp,
 				   &boot_params_blob);
-	if (!data) {
-		error = -ENOMEM;
+	if (!data)
 		goto err_version;
-	}
+
 	error = create_setup_data_nodes(dbp);
 	if (error)
 		goto err_data;
+
 	return 0;
 
 err_data:
@@ -205,10 +196,9 @@ err_version:
 	debugfs_remove(version);
 err_dir:
 	debugfs_remove(dbp);
-err_return:
 	return error;
 }
-#endif
+#endif /* CONFIG_DEBUG_BOOT_PARAMS */
 
 static int __init arch_kdebugfs_init(void)
 {
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index c70ab5a..8b02a39 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -1,14 +1,14 @@
 /* Fallback functions when the main IOMMU code is not compiled in. This
    code is roughly equivalent to i386. */
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/mm.h>
 
-#include <asm/iommu.h>
 #include <asm/processor.h>
+#include <asm/iommu.h>
 #include <asm/dma.h>
 
 static int
@@ -79,11 +79,11 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 }
 
 struct dma_mapping_ops nommu_dma_ops = {
-	.alloc_coherent = dma_generic_alloc_coherent,
-	.free_coherent = nommu_free_coherent,
-	.map_single = nommu_map_single,
-	.map_sg = nommu_map_sg,
-	.is_phys = 1,
+	.alloc_coherent	= dma_generic_alloc_coherent,
+	.free_coherent	= nommu_free_coherent,
+	.map_single	= nommu_map_single,
+	.map_sg		= nommu_map_sg,
+	.is_phys	= 1,
 };
 
 void __init no_iommu_init(void)
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index dd6f2b7..5d465b2 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -1,14 +1,14 @@
 /*
  * RTC related functions
  */
+#include <linux/platform_device.h>
+#include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
 #include <linux/bcd.h>
-#include <linux/mc146818rtc.h>
-#include <linux/platform_device.h>
 #include <linux/pnp.h>
 
-#include <asm/time.h>
 #include <asm/vsyscall.h>
+#include <asm/time.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -16,9 +16,9 @@
  * register we are working with.  It is required for NMI access to the
  * CMOS/RTC registers.  See include/asm-i386/mc146818rtc.h for details.
  */
-volatile unsigned long cmos_lock = 0;
+volatile unsigned long cmos_lock;
 EXPORT_SYMBOL(cmos_lock);
-#endif
+#endif /* CONFIG_X86_32 */
 
 /* For two digit years assume time is always after that */
 #define CMOS_YEARS_OFFS 2000
@@ -38,9 +38,9 @@ EXPORT_SYMBOL(rtc_lock);
  */
 int mach_set_rtc_mmss(unsigned long nowtime)
 {
-	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char save_control, save_freq_select;
+	int retval = 0;
 
 	 /* tell the clock it's being set */
 	save_control = CMOS_READ(RTC_CONTROL);
@@ -72,8 +72,8 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 			real_seconds = bin2bcd(real_seconds);
 			real_minutes = bin2bcd(real_minutes);
 		}
-		CMOS_WRITE(real_seconds,RTC_SECONDS);
-		CMOS_WRITE(real_minutes,RTC_MINUTES);
+		CMOS_WRITE(real_seconds, RTC_SECONDS);
+		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
 		printk(KERN_WARNING
 		       "set_rtc_mmss: can't update from %d to %d\n",
@@ -151,6 +151,7 @@ unsigned char rtc_cmos_read(unsigned char addr)
 	outb(addr, RTC_PORT(0));
 	val = inb(RTC_PORT(1));
 	lock_cmos_suffix(addr);
+
 	return val;
 }
 EXPORT_SYMBOL(rtc_cmos_read);
@@ -166,8 +167,8 @@ EXPORT_SYMBOL(rtc_cmos_write);
 
 static int set_rtc_mmss(unsigned long nowtime)
 {
-	int retval;
 	unsigned long flags;
+	int retval;
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	retval = set_wallclock(nowtime);
@@ -242,6 +243,7 @@ static __init int add_rtc_cmos(void)
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
+
 	return 0;
 }
 device_initcall(add_rtc_cmos);
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 0fcc95a..7e45159 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -25,10 +25,10 @@
  *
  * Send feedback to <colpatch@us.ibm.com>
  */
-#include <linux/init.h>
-#include <linux/smp.h>
 #include <linux/nodemask.h>
 #include <linux/mmzone.h>
+#include <linux/init.h>
+#include <linux/smp.h>
 #include <asm/cpu.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
@@ -47,6 +47,7 @@ int __ref arch_register_cpu(int num)
 	 */
 	if (num)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
+
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
 EXPORT_SYMBOL(arch_register_cpu);
@@ -56,12 +57,13 @@ void arch_unregister_cpu(int num)
 	unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
-#else
+#else /* CONFIG_HOTPLUG_CPU */
+
 static int __init arch_register_cpu(int num)
 {
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
-#endif /*CONFIG_HOTPLUG_CPU*/
+#endif /* CONFIG_HOTPLUG_CPU */
 
 static int __init topology_init(void)
 {
@@ -70,11 +72,11 @@ static int __init topology_init(void)
 #ifdef CONFIG_NUMA
 	for_each_online_node(i)
 		register_one_node(i);
-#endif /* CONFIG_NUMA */
+#endif
 
 	for_each_present_cpu(i)
 		arch_register_cpu(i);
+
 	return 0;
 }
-
 subsys_initcall(topology_init);


