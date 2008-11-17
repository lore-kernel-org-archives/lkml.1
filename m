Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYKQXUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYKQXUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYKQXU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:20:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:56281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYKQXU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:20:27 -0500
Message-ID: <4921FC19.1080803@kernel.org>
Date: Mon, 17 Nov 2008 15:19:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu>
In-Reply-To: <20081117173728.GA7384@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, one of my testboxes is rather unhappy about your patch:


please check

if you agree, will update update_genapic to autodetect other functions or etc.

YH

---

[PATCH] x86: fix wakeup_cpu with numaq/es7000 v2 - fix

Impact: fix wakeup_secondary_cpu with hotplug

We can not put that in x86_quirks, because that is __initdata.
So try to move that to genapic, and add update_genapic in x86_quirks.

later we even could use that stub to
1. autodetect CONFIG_ES7000_CLUSTERED_APIC
2. more correct inquire_remote_apic with apic_verbosity setting.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/genapic_32.h             |    1 +
 arch/x86/include/asm/genapic_64.h             |    2 ++
 arch/x86/include/asm/mach-default/mach_apic.h |    2 ++
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 +
 arch/x86/include/asm/setup.h                  |    3 ++-
 arch/x86/kernel/es7000_32.c                   |   11 ++++++++++-
 arch/x86/kernel/genapic_64.c                  |    4 ++++
 arch/x86/kernel/numaq_32.c                    |   11 +++++++++--
 arch/x86/kernel/setup.c                       |   13 ++++++++++++-
 arch/x86/kernel/smpboot.c                     |   11 +----------
 arch/x86/mach-generic/probe.c                 |    4 ++++
 11 files changed, 48 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/include/asm/genapic_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic_32.h
+++ linux-2.6/arch/x86/include/asm/genapic_32.h
@@ -66,6 +66,7 @@ struct genapic {
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
+	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
 	int trampoline_phys_low;
 	int trampoline_phys_high;
 	void (*wait_for_init_deassert)(atomic_t *deassert);
Index: linux-2.6/arch/x86/include/asm/genapic_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic_64.h
+++ linux-2.6/arch/x86/include/asm/genapic_64.h
@@ -32,6 +32,8 @@ struct genapic {
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
 	unsigned long apic_id_mask;
+	/* wakeup_secondary_cpu */
+	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
 };
 
 extern struct genapic *genapic;
Index: linux-2.6/arch/x86/include/asm/mach-default/mach_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mach-default/mach_apic.h
+++ linux-2.6/arch/x86/include/asm/mach-default/mach_apic.h
@@ -32,11 +32,13 @@ static inline cpumask_t target_cpus(void
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
 #define send_IPI_self (genapic->send_IPI_self)
+#define wakeup_secondary_cpu (genapic->wakeup_cpu)
 extern void setup_apic_routing(void);
 #else
 #define INT_DELIVERY_MODE dest_LowestPrio
 #define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
 #define TARGET_CPUS (target_cpus())
+#define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
  * Set up the logical destination ID.
  *
Index: linux-2.6/arch/x86/include/asm/mach-generic/mach_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mach-generic/mach_apic.h
+++ linux-2.6/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -27,6 +27,7 @@
 #define vector_allocation_domain (genapic->vector_allocation_domain)
 #define enable_apic_mode (genapic->enable_apic_mode)
 #define phys_pkg_id (genapic->phys_pkg_id)
+#define wakeup_secondary_cpu (genapic->wakeup_cpu)
 
 extern void generic_bigsmp_probe(void);
 
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -21,6 +21,7 @@ static inline int is_visws_box(void) { r
 #endif
 
 extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
+extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
@@ -44,7 +45,7 @@ struct x86_quirks {
 	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
                                     unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
-	int (*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
+	int (*update_genapic)(void);
 };
 
 extern struct x86_quirks *x86_quirks;
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -40,6 +40,7 @@
 #include <asm/smp.h>
 #include <asm/apicdef.h>
 #include <mach_mpparse.h>
+#include <asm/genapic.h>
 #include <asm/setup.h>
 
 /*
@@ -180,6 +181,13 @@ static int wakeup_secondary_cpu_via_mip(
 
 	return 0;
 }
+
+static int __init es7000_update_genapic(void)
+{
+	genapic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
+
+	return 0;
+}
 #endif
 
 void __init
@@ -197,8 +205,9 @@ setup_unisys(void)
 	else
 		es7000_plat = ES7000_CLASSIC;
 	ioapic_renumber_irq = es7000_rename_gsi;
+
 #ifdef CONFIG_ES7000_CLUSTERED_APIC
-	x86_quirks->wakeup_secondary_cpu = wakeup_secondary_cpu_via_mip;
+	x86_quirks->update_genapic = es7000_update_genapic;
 #endif
 }
 
Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -21,6 +21,7 @@
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <asm/setup.h>
 
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
@@ -53,6 +54,9 @@ void __init setup_apic_routing(void)
 			genapic = &apic_physflat;
 		printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
 	}
+
+	if (x86_quirks->update_genapic)
+		x86_quirks->update_genapic();
 }
 
 /* Same for both flat and physical. */
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -31,7 +31,7 @@
 #include <asm/numaq.h>
 #include <asm/topology.h>
 #include <asm/processor.h>
-#include <asm/mpspec.h>
+#include <asm/genapic.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
 
@@ -235,6 +235,13 @@ static int __init numaq_setup_ioapic_ids
 	return 1;
 }
 
+static int __init numaq_update_genapic(void)
+{
+	genapic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
+
+	return 0;
+}
+
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init	= numaq_pre_time_init,
 	.arch_time_init		= NULL,
@@ -250,7 +257,7 @@ static struct x86_quirks numaq_x86_quirk
 	.mpc_oem_pci_bus	= mpc_oem_pci_bus,
 	.smp_read_mpc_oem	= smp_read_mpc_oem,
 	.setup_ioapic_ids	= numaq_setup_ioapic_ids,
-	.wakeup_secondary_cpu	= wakeup_secondary_cpu_via_nmi,
+	.update_genapic		= numaq_update_genapic,
 };
 
 void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -584,7 +584,18 @@ static int __init setup_elfcorehdr(char
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
-static struct x86_quirks default_x86_quirks __initdata;
+static int __init default_update_genapic(void)
+{
+#if defined(CONFIG_X86_GENERICARCH) || defined(CONFIG_X86_64)
+	genapic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
+#endif
+
+	return 0;
+}
+
+static struct x86_quirks default_x86_quirks __initdata = {
+	.update_genapic         = default_update_genapic,
+};
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -615,7 +615,7 @@ wakeup_secondary_cpu_via_nmi(int logical
 	return (send_status | accept_status);
 }
 
-static int __devinit
+int __devinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -736,15 +736,6 @@ wakeup_secondary_cpu_via_init(int phys_a
 	return (send_status | accept_status);
 }
 
-static int __devinit
-wakeup_secondary_cpu(int apicid, unsigned long start_eip)
-{
-	if (x86_quirks->wakeup_secondary_cpu)
-		return x86_quirks->wakeup_secondary_cpu(apicid, start_eip);
-
-	return wakeup_secondary_cpu_via_init(apicid, start_eip);
-}
-
 struct create_idle {
 	struct work_struct work;
 	struct task_struct *idle;
Index: linux-2.6/arch/x86/mach-generic/probe.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/probe.c
+++ linux-2.6/arch/x86/mach-generic/probe.c
@@ -15,6 +15,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/genapic.h>
+#include <asm/setup.h>
 
 extern struct genapic apic_numaq;
 extern struct genapic apic_summit;
@@ -57,6 +58,9 @@ static int __init parse_apic(char *arg)
 		}
 	}
 
+	if (x86_quirks->update_genapic)
+		x86_quirks->update_genapic();
+
 	/* Parsed again by __setup for debug/verbose */
 	return 0;
 }
