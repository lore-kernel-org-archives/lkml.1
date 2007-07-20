Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbXGTEYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbXGTEYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXGTEYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:24:24 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:27933 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbXGTEYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:24:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAMzUn0ZKhRO4Rmdsb2JhbACBTYVmiBIBAQEjBgw
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Date: Fri, 20 Jul 2007 00:24:20 -0400
User-Agent: KMail/1.9.3
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <d120d5000707191223s40d58d1bga858357265318371@mail.gmail.com> <200707192152.03321.ak@suse.de>
In-Reply-To: <200707192152.03321.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200024.21467.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 15:52, Andi Kleen wrote:
> 
> > 
> > I was not talking about sysdevs. I was talking about platform devices
> > that are already being created for pcspkr by arch code. Now I want
> > arch code to provide a spinlock for pcspkr driver to use when
> > accessing PIT. What it does it allows to remove arch specific
> > knowledge (i.e. #ifdef CONFIG_X86...) from the pcspkr driver.
> 
> Ok please send a patch.
> 
> -Andi
> 

Here it is...

-- 
Dmitry

Subject: Input: pcspkr - use proper lock
From: Dmitry Torokhov <dtor@insightbb.com>

On i386 and x86_64 the access to the PIT is serialized by a lock
in the architecture code. The separate locking in the PC-speaker
code ignores the global lock and creates a nasty race between the
PC-speaker and the PIT clock source/events code on SMP machines.

To fix this we architecture code attaches proper lock to the
pcspkr platform device and the driver uses it instead of it's
own private lock.

Noticed by Thomas Gleixner <tglx@linutronix.de>

Also resore uevent generation for pcspkr devices so that the
driver can be loaded automatically by udev.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 arch/i386/kernel/pcspeaker.c       |   20 -------------------
 arch/alpha/kernel/setup.c          |    9 +++++++-
 arch/i386/kernel/Makefile          |    1 
 arch/i386/kernel/i8253.c           |   23 ++++++++++++++++++++++
 arch/mips/kernel/pcspeaker.c       |    9 +++++++-
 arch/powerpc/kernel/setup-common.c |    9 +++++++-
 arch/x86_64/kernel/Makefile        |    2 -
 arch/x86_64/kernel/time.c          |   38 +++++++++++++++++++++++++++++--------
 drivers/input/misc/pcspkr.c        |   10 +++++----
 9 files changed, 83 insertions(+), 38 deletions(-)

Index: work/arch/alpha/kernel/setup.c
===================================================================
--- work.orig/arch/alpha/kernel/setup.c
+++ work/arch/alpha/kernel/setup.c
@@ -1492,6 +1492,8 @@ alpha_panic_event(struct notifier_block 
         return NOTIFY_DONE;
 }
 
+static DEFINE_SPINLOCK(i8253_lock);
+
 static __init int add_pcspkr(void)
 {
 	struct platform_device *pd;
@@ -1501,9 +1503,14 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.platform_data = &i8253_lock;
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
-	if (ret)
+	if (ret) {
+		pd->dev.platform_data = NULL;	/* so we don't try to free it */
 		platform_device_put(pd);
+	}
 
 	return ret;
 }
Index: work/arch/mips/kernel/pcspeaker.c
===================================================================
--- work.orig/arch/mips/kernel/pcspeaker.c
+++ work/arch/mips/kernel/pcspeaker.c
@@ -10,6 +10,8 @@
 
 #include <linux/platform_device.h>
 
+static DEFINE_SPINLOCK(i8253_lock);
+
 static __init int add_pcspkr(void)
 {
 	struct platform_device *pd;
@@ -19,9 +21,14 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.platform_data = &i8253_lock;
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
-	if (ret)
+	if (ret) {
+		pd->dev.platform_data = NULL;	/* so we don't try to free it */
 		platform_device_put(pd);
+	}
 
 	return ret;
 }
Index: work/arch/x86_64/kernel/time.c
===================================================================
--- work.orig/arch/x86_64/kernel/time.c
+++ work/arch/x86_64/kernel/time.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/sysdev.h>
+#include <linux/platform_device.h>
 #include <linux/bcd.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
@@ -185,7 +186,7 @@ void main_timer_handler(void)
 		set_rtc_mmss(xtime.tv_sec);
 		rtc_update = xtime.tv_sec + 660;
 	}
- 
+
 	write_sequnlock(&xtime_lock);
 }
 
@@ -226,7 +227,7 @@ static unsigned long get_cmos_time(void)
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
- 	 */
+	 */
 
 	BCD_TO_BIN(sec);
 	BCD_TO_BIN(min);
@@ -239,11 +240,11 @@ static unsigned long get_cmos_time(void)
 		BCD_TO_BIN(century);
 		year += century * 100;
 		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
-	} else { 
+	} else {
 		/*
 		 * x86-64 systems only exists since 2002.
 		 * This will work up to Dec 31, 2100
-	 	 */
+		 */
 		year += 2000;
 	}
 
@@ -321,7 +322,7 @@ static unsigned int __init pit_calibrate
 	end = get_cycles_sync();
 
 	spin_unlock_irqrestore(&i8253_lock, flags);
-	
+
 	return (end - start) / 50;
 }
 
@@ -366,7 +367,7 @@ static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
-	.name 		= "timer"
+	.name		= "timer"
 };
 
 void __init time_init(void)
@@ -384,7 +385,7 @@ void __init time_init(void)
 
 	if (hpet_use_timer) {
 		/* set tick_nsec to use the proper rate for HPET */
-	  	tick_nsec = TICK_NSEC_HPET;
+		tick_nsec = TICK_NSEC_HPET;
 		tsc_khz = hpet_calibrate_tsc();
 		timename = "HPET";
 	} else {
@@ -485,5 +486,26 @@ static int time_init_device(void)
 		error = sysdev_register(&device_timer);
 	return error;
 }
-
 device_initcall(time_init_device);
+
+static __init int add_pcspkr(void)
+{
+	struct platform_device *pd;
+	int ret;
+
+	pd = platform_device_alloc("pcspkr", -1);
+	if (!pd)
+		return -ENOMEM;
+
+	pd->dev.platform_data = &i8253_lock;
+	pd->dev.uevent_suppress = 0;
+
+	ret = platform_device_add(pd);
+	if (ret) {
+		pd->dev.platform_data = NULL;	/* so we don't try to free it */
+		platform_device_put(pd);
+	}
+
+	return ret;
+}
+device_initcall(add_pcspkr);
Index: work/arch/i386/kernel/i8253.c
===================================================================
--- work.orig/arch/i386/kernel/i8253.c
+++ work/arch/i386/kernel/i8253.c
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/sysdev.h>
+#include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/init.h>
 
@@ -204,3 +205,25 @@ static int __init init_pit_clocksource(v
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
+
+static __init int add_pcspkr(void)
+{
+	struct platform_device *pd;
+	int ret;
+
+	pd = platform_device_alloc("pcspkr", -1);
+	if (!pd)
+		return -ENOMEM;
+
+	pd->dev.platform_data = &i8253_lock;
+	pd->dev.uevent_suppress = 0;
+
+	ret = platform_device_add(pd);
+	if (ret) {
+		pd->dev.platform_data = NULL;	/* so we don't try to free it */
+		platform_device_put(pd);
+	}
+
+	return ret;
+}
+device_initcall(add_pcspkr);
Index: work/arch/x86_64/kernel/Makefile
===================================================================
--- work.orig/arch/x86_64/kernel/Makefile
+++ work/arch/x86_64/kernel/Makefile
@@ -45,7 +45,6 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 obj-y				+= topology.o
 obj-y				+= intel_cacheinfo.o
 obj-y				+= addon_cpuid_features.o
-obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
@@ -61,5 +60,4 @@ quirks-y			+= ../../i386/kernel/quirks.o
 i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
 alternative-y			+= ../../i386/kernel/alternative.o
-pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
 perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
Index: work/arch/i386/kernel/Makefile
===================================================================
--- work.orig/arch/i386/kernel/Makefile
+++ work/arch/i386/kernel/Makefile
@@ -43,7 +43,6 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmiclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
-obj-y				+= pcspeaker.o
 
 obj-$(CONFIG_SCx200)		+= scx200.o
 
Index: work/arch/i386/kernel/pcspeaker.c
===================================================================
--- work.orig/arch/i386/kernel/pcspeaker.c
+++ /dev/null
@@ -1,20 +0,0 @@
-#include <linux/platform_device.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-static __init int add_pcspkr(void)
-{
-	struct platform_device *pd;
-	int ret;
-
-	pd = platform_device_alloc("pcspkr", -1);
-	if (!pd)
-		return -ENOMEM;
-
-	ret = platform_device_add(pd);
-	if (ret)
-		platform_device_put(pd);
-
-	return ret;
-}
-device_initcall(add_pcspkr);
Index: work/drivers/input/misc/pcspkr.c
===================================================================
--- work.orig/drivers/input/misc/pcspkr.c
+++ work/drivers/input/misc/pcspkr.c
@@ -24,10 +24,10 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@u
 MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
 
-static DEFINE_SPINLOCK(i8253_beep_lock);
-
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
+	struct platform_device *pdev = input_get_drvdata(dev);
+	spinlock_t *i8253_lock = pdev->dev.platform_data;
 	unsigned int count = 0;
 	unsigned long flags;
 
@@ -43,7 +43,7 @@ static int pcspkr_event(struct input_dev
 	if (value > 20 && value < 32767)
 		count = PIT_TICK_RATE / value;
 
-	spin_lock_irqsave(&i8253_beep_lock, flags);
+	spin_lock_irqsave(i8253_lock, flags);
 
 	if (count) {
 		/* enable counter 2 */
@@ -58,7 +58,7 @@ static int pcspkr_event(struct input_dev
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_beep_lock, flags);
+	spin_unlock_irqrestore(i8253_lock, flags);
 
 	return 0;
 }
@@ -84,6 +84,8 @@ static int __devinit pcspkr_probe(struct
 	pcspkr_dev->sndbit[0] = BIT(SND_BELL) | BIT(SND_TONE);
 	pcspkr_dev->event = pcspkr_event;
 
+	input_set_drvdata(pcspkr_dev, dev);
+
 	err = input_register_device(pcspkr_dev);
 	if (err) {
 		input_free_device(pcspkr_dev);
Index: work/arch/powerpc/kernel/setup-common.c
===================================================================
--- work.orig/arch/powerpc/kernel/setup-common.c
+++ work/arch/powerpc/kernel/setup-common.c
@@ -425,6 +425,8 @@ void __init smp_setup_cpu_maps(void)
 }
 #endif /* CONFIG_SMP */
 
+static DEFINE_SPINLOCK(i8253_lock);
+
 static __init int add_pcspkr(void)
 {
 	struct device_node *np;
@@ -440,9 +442,14 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.platform_data = &i8253_lock;
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
-	if (ret)
+	if (ret) {
+		pd->dev.platform_data = NULL;	/* so we don't try to free it */
 		platform_device_put(pd);
+	}
 
 	return ret;
 }
