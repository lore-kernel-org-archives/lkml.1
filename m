Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZH1VxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZH1VxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZH1VxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:53:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:1334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZH1VxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:53:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208,223";a="545725347"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Date: Fri, 28 Aug 2009 14:53:10 -0700
Subject: [RFC PATCH 6/7] x86/apic: Early setup IOAPIC for APB timer
Thread-Topic: [RFC PATCH 6/7] x86/apic: Early setup IOAPIC for APB timer
Thread-Index: Acoir9vx9XaYijQEQY+7z9INN3fH8AFeSSaQ
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA878@orsmsx508.amr.corp.intel.com>
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

>From 9438ac713c0175e975ef3d0013e6bf2b46883dd0 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 15 Jul 2009 11:30:40 -0700
Subject: [PATCH] x86/apic: Early setup IOAPIC for APB timer

Intel Moorestown platform uses APB system timers which rely
on IOAPIC to deliver its interrupts. Early setup the APIC
system is necessary to allow timer interrupts.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/apic.h    |    1 +
 arch/x86/kernel/apic/io_apic.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 8b542f4..4f2d26d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -84,6 +84,7 @@ extern void xapic_wait_icr_idle(void);
 extern u32 safe_xapic_wait_icr_idle(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
+extern void pre_init_apic_IRQ(void);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ccc746f..25a5b72 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -36,6 +36,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
+#include <linux/sfi.h>
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -63,6 +64,7 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 #include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
@@ -4211,3 +4213,18 @@ void __init ioapic_insert_resources(void)
 		r++;
 	}
 }
+
+/* Enable IOAPIC early just for system timer */
+void __init pre_init_apic_IRQ(void)
+{
+	struct irq_cfg *cfg;
+
+	printk(KERN_INFO "Early APIC setup for system timer\n");
+#ifndef CONFIG_SMP
+	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+#endif
+	setup_local_APIC();
+	cfg = irq_cfg(0);
+	add_pin_to_irq_node(cfg, 0, 0, 0);
+	setup_timer_IRQ0_pin(0, 0, cfg->vector);
+}
-- 
1.5.6.5

