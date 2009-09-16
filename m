Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZIPInC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZIPInC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbZIPIm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:42:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:5499 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789AbZIPImz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="727396332"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 07/10] xen/hybrid: Add PV timer support
Date: Wed, 16 Sep 2009 16:42:28 +0800
Message-Id: <1253090551-7969-8-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have event channel, we can use VIRQ_TIMER to deliver timer interrupt,
otherwise we would reuse IRQ0.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c |   14 ++++++++++++++
 arch/x86/xen/time.c      |   18 +++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b6751ed..18aba22 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -53,6 +53,8 @@
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
 
+#include <xen/hvm.h>
+
 #include "xen-ops.h"
 #include "mmu.h"
 #include "multicalls.h"
@@ -1050,6 +1052,9 @@ static void __init xen_hybrid_banner(void)
 	printk(KERN_INFO "Booting hybrid kernel on %s\n", pv_info.name);
 	printk(KERN_INFO "Xen version: %d.%d%s\n",
 	       version >> 16, version & 0xffff, extra.extraversion);
+
+	if (xen_hybrid_timer_enabled())
+		printk(KERN_INFO "Hybrid feature: PV Timer enabled\n");
 }
 
 static int xen_para_available(void)
@@ -1093,6 +1098,10 @@ static int init_hybrid_info(void)
 		return -ENODEV;
 
 	xen_hybrid_status = XEN_HYBRID_ENABLED;
+	if (edx & XEN_CPUID_FEAT2_HYBRID_TIMER) {
+		xen_hybrid_status |= XEN_HYBRID_TIMER_ENABLED;
+		flags |= HVM_HYBRID_TIMER;
+	}
 
 	/* We only support 1 page of hypercall for now */
 	if (pages != 1)
@@ -1149,5 +1158,10 @@ void __init xen_start_hybrid(void)
 	xen_hybrid_init_irq_ops();
 
 	init_shared_info();
+
+	if (xen_hybrid_timer_enabled()) {
+		pv_time_ops = xen_time_ops;
+		pv_apic_ops = xen_apic_ops;
+	}
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0a5aa44..381f135 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -421,6 +421,13 @@ static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
+static struct irqaction xen_timer_irq0 = {
+	.handler	= xen_timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL |
+			  IRQF_NOBALANCING | IRQF_TIMER,
+	.name		= "timer"
+};
+
 void xen_setup_timer(int cpu)
 {
 	const char *name;
@@ -433,9 +440,14 @@ void xen_setup_timer(int cpu)
 	if (!name)
 		name = "<timer kasprintf failed>";
 
-	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
-				      name, NULL);
+	if (xen_hybrid_timer_enabled() && !xen_hybrid_evtchn_enabled()) {
+		irq = 0;
+		setup_irq(0, &xen_timer_irq0);
+	} else
+		irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu,
+				xen_timer_interrupt,
+				IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);
 	memcpy(evt, xen_clockevent, sizeof(*evt));
-- 
1.5.4.5

