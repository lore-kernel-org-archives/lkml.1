Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZBUWZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZBUWZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 17:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZBUWYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 17:24:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:51110 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbZBUWYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 17:24:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,246,1233561600"; 
   d="scan'208";a="113071413"
Subject: Re: [PATCH] x86: enable x2apic early at the first point
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090220095530.GA15186@elte.hu>
References: <499DD40F.40102@kernel.org> <20090220095127.GK24555@elte.hu>
	 <20090220095530.GA15186@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Sat, 21 Feb 2009 14:23:21 -0800
Message-Id: <1235255001.14523.76.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 01:55 -0800, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >  arch/x86/kernel/apic/apic.c           |    3 +--
> > >  arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
> > >  arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
> > >  arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
> > >  drivers/pci/dmar.c                    |    3 ++-
> > >  5 files changed, 14 insertions(+), 6 deletions(-)
> > 
> > I've applied it because it fixes a real bug, but this code 
> > really needs a cleanup. Look at the repeat patterns:
> 
> unapplied it again as it breaks the build:
> 
> arch/x86/kernel/apic/x2apic_cluster.c: In function 'x2apic_acpi_madt_oem_check':
> arch/x86/kernel/apic/x2apic_cluster.c:17: error: 'disable_x2apic' undeclared (first use in this function)
> arch/x86/kernel/apic/x2apic_cluster.c:17: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/apic/x2apic_cluster.c:17: error: for each function it appears in.)
> 
> so please resend the fixed and cleaned up version.

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: select x2apic ops in early apic probe only if x2apic mode is enabled

If BIOS hands over the control to OS in legacy xapic mode, select legacy xapic
related ops in the early apic probe and shift to x2apic ops later in the boot
sequence, only after enabling x2apic mode.

If BIOS hands over the control in x2apic mode, select x2apic related ops
in the early apic probe.

This fixes the early boot panic, where we were selecting x2apic ops,
while the cpu is still in legacy xapic mode.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip/arch/x86/include/asm/apic.h.orig
+++ tip/arch/x86/include/asm/apic.h
@@ -146,7 +146,7 @@ static inline u64 native_x2apic_icr_read
 	return val;
 }
 
-extern int x2apic;
+extern int x2apic, x2apic_phys;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void enable_IR_x2apic(void);
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip/arch/x86/kernel/apic/probe_64.c.orig
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -50,9 +50,16 @@ static struct apic *apic_probe[] __initd
 void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
-	if (apic == &apic_x2apic_phys || apic == &apic_x2apic_cluster) {
-		if (!intr_remapping_enabled)
-			apic = &apic_flat;
+	if (x2apic && (apic != &apic_x2apic_phys &&
+#ifdef CONFIG_X86_UV
+		       apic != &apic_x2apic_uv_x &&
+#endif
+		       apic != &apic_x2apic_cluster)) {
+		if (x2apic_phys)
+			apic = &apic_x2apic_phys;
+		else
+			apic = &apic_x2apic_cluster;
+		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 #endif
 
Index: tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- tip/arch/x86/kernel/apic/x2apic_cluster.c.orig
+++ tip/arch/x86/kernel/apic/x2apic_cluster.c
@@ -14,10 +14,7 @@ DEFINE_PER_CPU(u32, x86_cpu_to_logical_a
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (cpu_has_x2apic)
-		return 1;
-
-	return 0;
+	return x2apic_enabled();
 }
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
Index: tip/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- tip/arch/x86/kernel/apic/x2apic_phys.c.orig
+++ tip/arch/x86/kernel/apic/x2apic_phys.c
@@ -10,7 +10,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
-static int x2apic_phys;
+int x2apic_phys;
 
 static int set_x2apic_phys_mode(char *arg)
 {
@@ -21,10 +21,10 @@ early_param("x2apic_phys", set_x2apic_ph
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (cpu_has_x2apic && x2apic_phys)
-		return 1;
-
-	return 0;
+	if (x2apic_phys)
+		return x2apic_enabled();
+	else
+		return 0;
 }
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip/arch/x86/kernel/apic/apic.c.orig
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1269,14 +1269,7 @@ void __cpuinit end_local_APIC_setup(void
 #ifdef CONFIG_X86_X2APIC
 void check_x2apic(void)
 {
-	int msr, msr2;
-
-	if (!cpu_has_x2apic)
-		return;
-
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
-
-	if (msr & X2APIC_ENABLE) {
+	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
 		x2apic_preenabled = x2apic = 1;
 	}


