Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZH1VxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZH1VxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZH1VxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:53:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:60014 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZH1Vw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208,223";a="488365432"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Date: Fri, 28 Aug 2009 14:52:58 -0700
Subject: [RFC PATCH 3/7] x86: add moorestown specific platform setup code
Thread-Topic: [RFC PATCH 3/7] x86: add moorestown specific platform setup
 code
Thread-Index: Acoir9vx9XaYijQEQY+7z9INN3fH8AFdww0w
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA874@orsmsx508.amr.corp.intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org>
 <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dbb97928dc27061b56fc86b9b37f71f54bbafb59 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Fri, 28 Aug 2009 08:31:45 -0700
Subject: [PATCH] x86: add moorestown specific platform setup code

This patch fills in platform_setup functions for Moorestown. The abstraction
is used to integarte into pc compaitible boot flow.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/setup.h |    8 ++
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/mrst.c       |  149 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c      |    1 +
 4 files changed, 159 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/mrst.c

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 055b778..2ef1514 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -49,6 +49,14 @@ extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 extern void setup_default_timer_irq(void);
 
+#ifdef CONFIG_MRST
+extern void mrst_early_detect(void);
+extern void setup_mrst_default_feature(void);
+#else
+static inline void mrst_early_detect(void) { }
+static inline void setup_mrst_default_feature(void) { };
+#endif
+
 #ifndef _SETUP
 
 /*
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7aed450..4d0a9cd 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
new file mode 100644
index 0000000..671d8e5
--- /dev/null
+++ b/arch/x86/kernel/mrst.c
@@ -0,0 +1,149 @@
+/*
+ * mrst.c: Intel Moorestown platform specific setup code
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Jacob Pan (jacob.jun.pan@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note:
+ *
+ */
+
+#include <linux/stackprotector.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c.h>
+#include <linux/sfi.h>
+#include <linux/i2c/pca953x.h>
+#include <linux/spi/langwell_pmic_gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
+#include <asm/apic.h>
+#include <asm/hw_irq.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+
+#define LANGWELL_GPIO_ALT_ADDR	0xff12c038
+#define MRST_I2C_BUSNUM		3
+
+static inline void __init mrst_pre_intr_init(void)
+{
+	pre_init_apic_IRQ();
+}
+
+/*
+ * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
+ * APBT but cmdline option can also override it.
+ */
+static void __init mrst_setup_secondary_clock(void)
+{
+	if (disable_apbt_percpu)
+		return setup_secondary_APIC_clock();
+	else {
+#ifdef CONFIG_CC_STACKPROTECTOR
+		/*
+		  * TBD:
+		 * this is to avoid false stack corruption panic since
+		 * request_irq will be called early for secondary apbt clock.
+		*/
+		boot_init_stack_canary();
+#endif
+		apbt_setup_secondary_clock();
+	}
+}
+
+static void __init mrst_check_timer(void)
+{
+	if (timer_irq_works())
+		printk(KERN_INFO "APB timer works\n");
+	else
+		panic("Check APB timer failed\n");
+}
+
+static unsigned long __init mrst_calibrate_tsc(void)
+{
+	unsigned long flags, fast_calibrate;
+
+	local_irq_save(flags);
+	fast_calibrate = apbt_quick_calibrate();
+	local_irq_restore(flags);
+
+	if (fast_calibrate)
+		return fast_calibrate;
+
+	return 0;
+}
+
+static int mrst_pirq_enable_irq(struct pci_dev *dev)
+{
+	u8 pin;
+	struct io_apic_irq_attr irq_attr;
+
+	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+
+	/* For platforms only have IOAPIC, the PCI irq line is 1:1 mapped to
+	 * IOAPIC RTE entries, so we just enable RTE for the device.
+	 */
+	irq_attr.ioapic = mp_sfi_find_ioapic(dev->irq);
+	irq_attr.ioapic_pin = dev->irq;
+	irq_attr.trigger = 1; /* level */
+	irq_attr.polarity = 1; /* active low */
+	io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
+
+	return 0;
+}
+
+
+inline void setup_mrst_default_feature(void)
+{
+	/*
+	 * x86pc default platform setup ops are setup prior to start_kernel
+	 * we override default platform_setup calls for Moorestown
+	 */
+	platform_setup.resources.reserve_ebda_region = platform_setup_noop;
+	platform_setup.resources.probe_roms = platform_setup_noop;
+	platform_setup.resources.reserve_resources = platform_setup_noop;
+
+	platform_setup.irqs.pre_vector_init = mrst_pre_intr_init;
+	platform_setup.irqs.pci_enable_irq = mrst_pirq_enable_irq,
+
+	platform_setup.timers.timer_init = apbt_time_init;
+	platform_setup.timers.check_timers = mrst_check_timer;
+	platform_setup.timers.calibrate_tsc = mrst_calibrate_tsc;
+
+	platform_cpuhotplug_setup.setup_percpu_clockev =
+						mrst_setup_secondary_clock;
+
+
+	/* assign feature flags */
+	clear_all_platform_feature();
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_SFI);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_IOAPIC);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_APBT);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_VRTC);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_PCISHIM);
+
+}
+
+void __init mrst_early_detect(void)
+{
+	int subarch_id = boot_params.hdr.hardware_subarch;
+
+	if ((subarch_id >= 0) && (subarch_id < N_X86_SUBARCHS)) {
+		if (subarch_id == X86_SUBARCH_MRST) {
+			setup_mrst_default_feature();
+			return;
+		}
+	} else {
+		printk(KERN_INFO "Use default X86 platform feature set\n");
+	}
+}
+
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 35c3edc..9fef9d9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -692,6 +692,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
+	mrst_early_detect();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
-- 
1.5.6.5

