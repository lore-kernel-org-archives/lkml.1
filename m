Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYAQTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYAQTxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYAQTxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:53:24 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:58513 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751238AbYAQTxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:53:22 -0500
Message-ID: <478FB255.5040001@i4.informatik.rwth-aachen.de>
Date: Thu, 17 Jan 2008 20:53:57 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <478E4267.7020509@i4.informatik.rwth-aachen.de> <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral>
In-Reply-To: <20080117134032.4cc1a1cf@ephemeral>
Content-Type: multipart/mixed;
 boundary="------------000006000207020107050206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000006000207020107050206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andres Salomon schrieb:
> On Thu, 17 Jan 2008 10:54:30 +0100
> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
> 
>> Andres Salomon schrieb:
>>> On Wed, 16 Jan 2008 16:19:12 -0500
>>> Andres Salomon <dilinger@queued.net> wrote:
>>>
>>>> On Wed, 16 Jan 2008 18:44:07 +0100
>>>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
>>>>> and it hangs during boot:
>>>>>
>>>>> [   12.689971] NET: Registered protocol family 16
>>>>> [   12.703329] geode-mfgpt:  Registered timer 0
>>>>> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
>>>>>
>>>> What BIOS are you using?  It's possible that our detection code is
>>>> failing to detect in-use timers.
>> I'm using v0.99 (latest available).
> 
> 
> v0.99 of what?  Jordan seems to think it's an Award BIOS, but I'd like
> to make sure.

Its an ALIX board from PCEngines, they have their own BIOS
implementation (tinyBios).
http://www.pcengines.ch/alix.htm

> 
>> Also note when I do enable the mysterios "MFGPT workaround" option in
>> the bios the machine hangs directly after:
>> [   36.780990] NET: Registered protocol family 16
> 
> 
> "MFGPT workaround"?  That sounds a bit frightening.
> 
> Presumably, the BIOS is using the MFGPTs, but we're not detecting them as
> being in use.
Yes I think so too, for the fun of it I compiled a 2.6.16.29 kernel with
the attached patch from fi4l.

relevant output is this:
[   31.015425] geode-mfgpt:  7 timers available.
...
[   31.245875] geode-mfgpt:  Registered timer 0

So the above kernel detects only 7 timers not 8, and it works. But note
that timer 0 is not used as a clock event source but as a watchdog,
which btw actually works fine :-)
The funny thing is the #define workaround part of this dubious patch and
its interaction with the bios:

#ifdef WORKAROUND:
 I have to turn the "MFPGT workaround" option in the bios ON, to boot
the kernel probably.

#ifndef WORKAROUND:
 I have to turn the "MFPGT workaround" option in the bios OFF, to boot
the kernel probably.

All other combinations will hang the system.

Doest it make sense to try to boot older release candidates of 2.6.24 ?

> 
> I'm assuming that booting with 'nomfgpt' works for you?
In fact it does.
It just says:
geode-mfgpt:  Skipping MFGPT setup
and boots.

> 
>>>
>>> Also, could you provide a log with the following (untested) patch?  I'm
>>> curious how many MFGPTs we're actually detecting as being available, and
>>> the existing code is backwards.
>> The relevant part would be:
>> [   23.092507] NET: Registered protocol family 16
>> [   23.105875] geode-mfgpt:  8 MFGPT timers available
>> [   23.120247] geode-mfgpt:  Registered timer 0
>> [   23.133076] mfgpt-timer:  registering the MFGT timer as a clock event.


--------------000006000207020107050206
Content-Type: text/plain;
 name="patch_12_cs5535_gpt_wdt_alix_2.6.16"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_12_cs5535_gpt_wdt_alix_2.6.16"

diff -uNr linux-2.6.16.56/arch/i386/kernel/geode-mfgpt.c linux-2.6.16.56.patched/arch/i386/kernel/geode-mfgpt.c
--- linux-2.6.16.56/arch/i386/kernel/geode-mfgpt.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.16.56.patched/arch/i386/kernel/geode-mfgpt.c	2007-12-11 14:57:36.000000000 +0100
@@ -0,0 +1,312 @@
+/*     Driver/API for AMD Geode Multi-Function General Purpose Timers (MFGPT)
+ *
+ *     Copyright (C) 2006, Advanced Micro Devices, Inc.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <asm/geode-mfgpt.h>
+#include <asm/io.h>
+#include <asm/msr.h>
+
+#define WORKAROUND
+
+#define MFGPT_IRQ_MSR 0x51400028
+#define MFGPT_NR_MSR  0x51400029
+
+#define MFGPT_MAX_TIMERS 7
+#define MFGPT_PCI_BAR 2
+
+#define F_AVAIL    0x01
+#define F_RESERVED 0x02
+
+static void *mfgpt_iobase;
+static int reserved_mask = 0;
+static struct class *mfgpt_class;
+
+static struct mfgpt_timer_t {
+	int index;
+	int flags;
+	struct module *owner;
+	struct class_device *cdev;
+} mfgpt_timers[MFGPT_MAX_TIMERS];
+
+void
+geode_mfgpt_write(int i, u16 r, u16 v)
+{
+	iowrite16(v, mfgpt_iobase + (r + (i * 8)));
+}
+
+EXPORT_SYMBOL(geode_mfgpt_write);
+
+u16
+geode_mfgpt_read(int i, u16 r)
+{
+	return ioread16(mfgpt_iobase + (r + (i * 8)));
+}
+
+EXPORT_SYMBOL(geode_mfgpt_read);
+
+static ssize_t
+sys_print_register(struct class_device *dev, char *buf, int reg)
+{
+	struct mfgpt_timer_t *timer = class_get_devdata(dev);
+	u16 val = geode_mfgpt_read(timer->index, reg);
+
+	return sprintf(buf, "%4.4X\n", val);
+}
+
+static ssize_t
+sys_show_setup(struct class_device *dev, char *buf)
+{
+	return sys_print_register(dev, buf, MFGPT_REG_SETUP);
+}
+
+static ssize_t
+sys_show_counter(struct class_device *dev, char *buf)
+{
+	return sys_print_register(dev, buf, MFGPT_REG_COUNTER);
+}
+
+static ssize_t
+sys_show_cmp1(struct class_device *dev, char *buf)
+{
+	return sys_print_register(dev, buf, MFGPT_REG_CMP1);
+}
+
+static ssize_t
+sys_show_cmp2(struct class_device *dev, char *buf)
+{
+	return sys_print_register(dev, buf, MFGPT_REG_CMP2);
+}
+
+static struct class_device_attribute mfgpt_attrs[] = {
+	__ATTR(setup, S_IRUGO, sys_show_setup, NULL),
+	__ATTR(counter, S_IRUGO, sys_show_counter, NULL),
+	__ATTR(cmp1, S_IRUGO, sys_show_cmp1, NULL),
+	__ATTR(cmp2, S_IRUGO, sys_show_cmp2, NULL),
+};
+
+void
+geode_mfgpt_toggle_event(int timer, int cmp, int event, int setup)
+{
+	u32 msr, mask, value, dummy;
+	int shift = (cmp == MFGPT_CMP1) ? 0 : 8;
+
+	switch(event) {
+	case MFGPT_EVENT_RESET:
+		msr = MFGPT_NR_MSR;
+		mask = 1 << (timer + 24);
+		break;
+
+	case MFGPT_EVENT_NMI:
+		msr = MFGPT_NR_MSR;
+		mask = 1 << (timer + shift);
+		break;
+
+	case MFGPT_EVENT_IRQ:
+		msr = MFGPT_IRQ_MSR;
+		mask = 1 << (timer + shift);
+		break;
+
+	default:
+		return;
+	}
+
+	rdmsr(msr, value, dummy);
+
+	if (setup)
+		value |= mask;
+	else
+		value &= ~mask;
+
+	wrmsr(msr, value, dummy);
+}
+
+EXPORT_SYMBOL(geode_mfgpt_toggle_event);
+
+void
+geode_mfgpt_set_irq(int timer, int cmp, int irq, int setup)
+{
+	u32 val, dummy;
+	int offset;
+
+	geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, setup);
+
+	rdmsr(0x51400022, val, dummy);
+
+	offset = (timer % 4) * 4;
+
+	val &= ~((0xF << offset) | (0xF << (offset + 16)));
+
+	if (setup) {
+		val |= (irq & 0x0F) << (offset);
+		val |= (irq & 0x0F) << (offset + 16);
+	}
+
+	wrmsr(0x51400022, val, dummy);
+}
+
+int
+geode_mfgpt_alloc_timer(int timer, int domain, struct module *owner)
+{
+	int i;
+
+	/* If they requested a specific timer, try to honor that */
+	if (mfgpt_iobase == NULL)
+		return -ENODEV;
+
+	if (timer != MFGPT_TIMER_ANY) {
+		if (mfgpt_timers[timer].flags & F_AVAIL) {
+			mfgpt_timers[timer].flags &= ~F_AVAIL;
+			mfgpt_timers[timer].owner = owner;
+
+			printk("geode-mfgpt:  Registered timer %d\n", timer);
+			return timer;
+		}
+		else if (mfgpt_timers[timer].owner == owner)
+			return timer;
+
+		/* Request failed - somebody else owns it */
+		return -1;
+	}
+
+	/* Try to find an available timer */
+
+	for(i = 0; i < MFGPT_MAX_TIMERS; i++) {
+
+		if ((mfgpt_timers[i].flags & F_AVAIL) &&
+		    !(mfgpt_timers[i].flags & F_RESERVED)) {
+			mfgpt_timers[i].flags &= ~F_AVAIL;
+			mfgpt_timers[i].owner = owner;
+			
+			printk("geode-mfgpt:  Registered timer %d\n", i);
+			return i;
+		}
+
+		if (i == 5 && domain == MFGPT_DOMAIN_WORKING)
+			break;
+	}
+
+	/* No timers available - too bad */
+	return -1;
+}
+
+EXPORT_SYMBOL(geode_mfgpt_alloc_timer);
+
+static int
+mfgpt_setup_timer(struct pci_dev *pdev, int timer)
+{
+	dev_t devid = MKDEV(0, 0);
+	u16 val = geode_mfgpt_read(timer, MFGPT_REG_SETUP);
+	mfgpt_timers[timer].index = timer;
+
+	if (reserved_mask & (1 << timer))
+		mfgpt_timers[timer].flags |= F_RESERVED;
+
+	if (!(val & MFGPT_SETUP_SETUP)) {
+		int v;
+
+		mfgpt_timers[timer].flags = F_AVAIL;
+
+		/* Add the class device */
+		mfgpt_timers[timer].cdev =
+			class_device_create(mfgpt_class, NULL, devid,
+				&pdev->dev, "mfgpt%d", timer);
+
+	        class_set_devdata(mfgpt_timers[timer].cdev, &mfgpt_timers[timer]);
+
+		for(v = 0; v < ARRAY_SIZE(mfgpt_attrs); v++)
+			if (class_device_create_file(mfgpt_timers[timer].cdev,
+				&mfgpt_attrs[v]))
+				printk(KERN_ERR "geode-mfpgt:  Couldn't create %s\n",
+				mfgpt_attrs[v].attr.name);
+
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct pci_device_id geode_sbdevs[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) }
+};
+
+static int __init
+geode_mfgpt_init(void)
+{
+	struct pci_dev *pdev = NULL;
+	int i, ret, dev, count = 0;
+
+#ifdef WORKAROUND
+	u32 val, dummy;
+
+	/* The following udocumented bit resets the MFGPT timers */
+
+	val = 0xFF;
+	wrmsr(0x5140002B, val, dummy);
+#endif
+
+	for (dev = 0; dev < ARRAY_SIZE(geode_sbdevs); dev++) {
+		pdev = pci_get_device(geode_sbdevs[dev].vendor,
+				      geode_sbdevs[dev].device, NULL);
+
+		if (pdev != NULL)
+			break;
+	}
+
+	if (pdev == NULL) {
+		printk(KERN_ERR "geode-mfgpt:  No PCI devices found\n");
+		goto err;
+	}
+
+	if ((ret = pci_enable_device_bars(pdev, 1 << MFGPT_PCI_BAR)))
+		goto err;
+
+	if ((ret = pci_request_region(pdev, MFGPT_PCI_BAR, "geode-mfgpt")))
+		goto err;
+
+	mfgpt_iobase = pci_iomap(pdev, MFGPT_PCI_BAR, 64);
+
+	if (mfgpt_iobase == NULL)
+		goto ereq;
+
+	mfgpt_class = class_create(THIS_MODULE, "mfgpt");
+
+	if (IS_ERR(mfgpt_class)) {
+		printk(KERN_ERR "geode-mfgpt: Unable to allocate the class.\n");
+		goto eiobase;
+	}
+
+	for(i = 0; i < MFGPT_MAX_TIMERS; i++)
+		count += mfgpt_setup_timer(pdev, i);
+
+	printk("geode-mfgpt:  %d timers available.\n", count);
+	return 0;
+
+ eiobase:
+	pci_iounmap(pdev, mfgpt_iobase);
+	mfgpt_iobase = NULL;
+
+ ereq:
+	pci_release_region(pdev, MFGPT_PCI_BAR);
+
+ err:
+ 	printk("geode-mfgpt:  Error initalizing the timers\n");
+	return -1;
+}
+
+device_initcall(geode_mfgpt_init);
+MODULE_AUTHOR("Advanced Micro Devices, Inc");
+MODULE_DESCRIPTION("Geode GX/LX MFGPT Driver");
+MODULE_LICENSE("GPL");
diff -uNr linux-2.6.16.56/arch/i386/kernel/Makefile linux-2.6.16.56.patched/arch/i386/kernel/Makefile
--- linux-2.6.16.56/arch/i386/kernel/Makefile	2007-11-01 03:23:29.000000000 +0100
+++ linux-2.6.16.56.patched/arch/i386/kernel/Makefile	2007-12-12 15:18:48.000000000 +0100
@@ -37,6 +37,7 @@
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-m         += geode-mfgpt.o
 
 EXTRA_AFLAGS   := -traditional
 
diff -uNr linux-2.6.16.56/drivers/char/watchdog/geodewdt.c linux-2.6.16.56.patched/drivers/char/watchdog/geodewdt.c
--- linux-2.6.16.56/drivers/char/watchdog/geodewdt.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.16.56.patched/drivers/char/watchdog/geodewdt.c	2007-12-12 15:22:31.000000000 +0100
@@ -0,0 +1,247 @@
+/* Watchdog timer for the Geode GX/LX
+ *
+ * Copyright (C) 2006, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+
+#include <asm/uaccess.h>
+#include <asm/geode-mfgpt.h>
+
+#define GEODEWDT_HZ 500
+#define GEODEWDT_SCALE 6
+#define GEODEWDT_MAX_SECONDS 131
+
+#define WDT_FLAGS_OPEN 1
+#define WDT_FLAGS_ORPHAN 2
+
+/* The defaults for the other timers are 60, so we'll use that too */
+
+static int cur_interval = 60;
+static int wdt_timer;
+static unsigned long wdt_flags;
+static int safe_close;
+
+static void geodewdt_ping(void)
+{
+	printk("PING\n");
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+}
+
+static void geodewdt_stop(void)
+{
+	printk("STOP\n");
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+}
+
+static int geodewdt_set_heartbeat(int val)
+{
+	if (val < 1 || val > GEODEWDT_MAX_SECONDS)
+		return -EINVAL;
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2, val * GEODEWDT_HZ);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+
+	printk("HEARTBEAT %d\n", val);
+	cur_interval = val;
+	return 0;
+}
+
+static int
+geodewdt_open(struct inode *inode, struct file *file)
+{
+        if (test_and_set_bit(WDT_FLAGS_OPEN, &wdt_flags))
+                return -EBUSY;
+
+        if (!test_and_clear_bit(WDT_FLAGS_ORPHAN, &wdt_flags))
+                __module_get(THIS_MODULE);
+
+	geodewdt_ping();
+        return nonseekable_open(inode, file);
+}
+
+static int
+geodewdt_release(struct inode *inode, struct file *file)
+{
+	if (safe_close) {
+		geodewdt_stop();
+		module_put(THIS_MODULE);
+	}
+	else {
+		printk(KERN_CRIT "Unexpected close - watchdog is not stopping.\n");
+		geodewdt_ping();
+
+		set_bit(WDT_FLAGS_ORPHAN, &wdt_flags);
+	}
+
+	clear_bit(WDT_FLAGS_OPEN, &wdt_flags);
+	safe_close = 0;
+	return 0;
+}
+
+static ssize_t
+geodewdt_write(struct file *file, const char __user *data, size_t len,
+	       loff_t *ppos)
+{
+        if(len) {
+		size_t i;
+                safe_close = 0;
+
+                for (i = 0; i != len; i++) {
+			char c;
+
+			if (get_user(c, data + i))
+				return -EFAULT;
+
+			if (c == 'V')
+				safe_close = 1;
+		}
+	}
+
+	geodewdt_ping();
+	return len;
+}
+
+static int
+geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+	       unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int interval;
+
+	static struct watchdog_info ident = {
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
+		| WDIOF_MAGICCLOSE,
+		.firmware_version =     0,
+		.identity =             "Geode Watchdog",
+        };
+
+	switch(cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		geodewdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(interval, p))
+			return -EFAULT;
+
+		if (geodewdt_set_heartbeat(interval))
+			return -EINVAL;
+
+/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(cur_interval, p);
+	}
+
+	return -ENOTTY;
+}
+
+static int geodewdt_notify_sys(struct notifier_block *this,
+			       unsigned long code, void *unused)
+{
+        if(code==SYS_DOWN || code==SYS_HALT)
+		geodewdt_stop();
+
+        return NOTIFY_DONE;
+}
+
+static const struct file_operations geodewdt_fops = {
+        .owner          = THIS_MODULE,
+        .llseek         = no_llseek,
+        .write          = geodewdt_write,
+        .ioctl          = geodewdt_ioctl,
+        .open           = geodewdt_open,
+        .release        = geodewdt_release,
+};
+
+static struct miscdevice geodewdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "geode-watchdog",
+	.fops = &geodewdt_fops
+};
+
+static struct notifier_block geodewdt_notifier = {
+	.notifier_call = geodewdt_notify_sys
+};
+
+static int __init geodewdt_init(void)
+{
+	int ret, timer;
+
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
+					MFGPT_DOMAIN_ANY, THIS_MODULE);
+
+	if (timer == -1) {
+		printk(KERN_ERR "geodewdt:  No timers were available\n");
+		return -ENODEV;
+	}
+
+	wdt_timer = timer;
+
+	/* Set up the timer */
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
+			  GEODEWDT_SCALE | (3 << 8));
+
+	/* Set up comparator 2 to reset when the event fires */
+	geode_mfgpt_set_event(wdt_timer, MFGPT_CMP2, MFGPT_EVENT_RESET);
+
+	/* Set up the initial timeout */
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2,
+		cur_interval * GEODEWDT_HZ);
+
+	ret = misc_register(&geodewdt_miscdev);
+	if (ret)
+		return ret;
+
+	ret = register_reboot_notifier(&geodewdt_notifier);
+
+	if (ret)
+		misc_deregister(&geodewdt_miscdev);
+
+	return ret;
+}
+
+static void __exit
+geodewdt_exit(void)
+{
+	misc_deregister(&geodewdt_miscdev);
+	unregister_reboot_notifier(&geodewdt_notifier);
+}
+
+module_init(geodewdt_init);
+module_exit(geodewdt_exit);
+
+MODULE_AUTHOR("Advanced Micro Devices, Inc");
+MODULE_DESCRIPTION("Geode GX/LX Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff -uNr linux-2.6.16.56/drivers/char/watchdog/Kconfig linux-2.6.16.56.patched/drivers/char/watchdog/Kconfig
--- linux-2.6.16.56/drivers/char/watchdog/Kconfig	2007-11-01 03:23:29.000000000 +0100
+++ linux-2.6.16.56.patched/drivers/char/watchdog/Kconfig	2007-12-12 15:22:31.000000000 +0100
@@ -209,6 +209,14 @@
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called sc520_wdt.
 
+config GEODE_WDT
+	tristate "AMD Geode GX/LX Watchdog Timer"
+	depends on WATCHDOG && X86
+	help
+	  Enable support for a hardware based watchdog timer running 
+	  on the MFGPT timers available on AMD Geode GX and LX based
+	  platforms.
+
 config EUROTECH_WDT
 	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
 	depends on WATCHDOG && X86
diff -uNr linux-2.6.16.56/drivers/char/watchdog/Makefile linux-2.6.16.56.patched/drivers/char/watchdog/Makefile
--- linux-2.6.16.56/drivers/char/watchdog/Makefile	2007-11-01 03:23:29.000000000 +0100
+++ linux-2.6.16.56.patched/drivers/char/watchdog/Makefile	2007-12-12 15:22:31.000000000 +0100
@@ -38,6 +38,7 @@
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
+obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
diff -uNr linux-2.6.16.56/include/asm-i386/geode-mfgpt.h linux-2.6.16.56.patched/include/asm-i386/geode-mfgpt.h
--- linux-2.6.16.56/include/asm-i386/geode-mfgpt.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.16.56.patched/include/asm-i386/geode-mfgpt.h	2007-12-11 14:57:37.000000000 +0100
@@ -0,0 +1,57 @@
+/*     Driver/API for AMD Geode Multi-Function General Purpose Timers (MFGPT)
+ *
+ *     Copyright (C) 2006, Advanced Micro Devices, Inc.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ */
+
+#ifndef MFGPT_GEODE_H_
+#define MFGPT_GEODE_H_
+
+#define MFGPT_TIMER_ANY -1
+
+#define MFGPT_DOMAIN_WORKING 1
+#define MFGPT_DOMAIN_STANDBY 2
+#define MFGPT_DOMAIN_ANY (MFGPT_DOMAIN_WORKING | MFGPT_DOMAIN_STANDBY)
+
+#define MFGPT_CMP1 0
+#define MFGPT_CMP2 1
+
+#define MFGPT_EVENT_IRQ   0
+#define MFGPT_EVENT_NMI   1
+#define MFGPT_EVENT_RESET 3
+
+#define MFGPT_REG_CMP1    0
+#define MFGPT_REG_CMP2    2
+#define MFGPT_REG_COUNTER 4
+#define MFGPT_REG_SETUP   6
+
+#define MFGPT_SETUP_CNTEN  (1 << 15)
+#define MFGPT_SETUP_CMP2   (1 << 14)
+#define MFGPT_SETUP_CMP1   (1 << 13)
+#define MFGPT_SETUP_SETUP  (1 << 12)
+#define MFGPT_SETUP_STOPEN (1 << 11)
+#define MFGPT_SETUP_EXTEN  (1 << 10)
+#define MFGPT_SETUP_REVEN  (1 << 5)
+#define MFGPT_SETUP_CLKSEL (1 << 4)
+
+extern void geode_mfgpt_toggle_event(int, int, int, int);
+
+#define geode_mfgpt_set_event(t,c,e) geode_mfgpt_toggle_event(t,c,e,1)
+#define geode_mfgpt_clear_event(t,c,e) geode_mfgpt_toggle_event(t,c,e,0)
+
+extern void geode_mfgpt_set_irq(int, int, int, int);
+
+#define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq(t,c,i,1)
+#define geode_mfgpt_release_irq(t, c, i) geode_mfgpt_set_irq(t,c,i,0)
+
+extern void geode_mfgpt_write(int, u16, u16);
+extern u16 geode_mfgpt_read(int, u16);
+
+extern int geode_mfgpt_alloc_timer(int, int, struct module *);
+
+#endif

--------------000006000207020107050206--
