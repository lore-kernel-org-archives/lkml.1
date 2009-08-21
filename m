Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbZHUVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbZHUVb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932875AbZHUVbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:25 -0400
Received: from www.tglx.de ([62.245.132.106]:51495 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870AbZHUVbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:24 -0400
Message-Id: <20090821205602.100726938@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 06/32] x86: Sanitize smp_record and move it to
	platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-and-sanitize-smp-record.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 quirkification introduced an extra ugly hackery with a
variable pointer in the mpparse code. If the pointer is initialized
then it is dereferenced and the variable set to 0 or incremented.

Create a platform_setup quirk function and let the affected numaq code
hold the function. Default init is a setup noop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h  |    3 +++
 arch/x86/include/asm/setup.h     |    1 -
 arch/x86/kernel/apic/numaq_32.c  |   19 ++++++++++++++++---
 arch/x86/kernel/mpparse.c        |    6 ++----
 arch/x86/kernel/platform_setup.c |    5 +++++
 5 files changed, 26 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -3,9 +3,11 @@
 
 /**
  * struct platform_setup_quirks - platform specific quirks
+ * @mpc_record:			platform specific mpc record accounting
  *
  */
 struct platform_setup_quirks {
+	void (*mpc_record)(unsigned int mode);
 };
 
 /**
@@ -36,5 +38,6 @@ struct platform_setup_ops {
 extern struct platform_setup_ops platform_setup;
 
 extern void platform_setup_noop(void);
+extern void platform_setup_uint_noop(unsigned int unused);
 
 #endif
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -25,7 +25,6 @@ struct x86_quirks {
 	int (*mach_get_smp_config)(unsigned int early);
 	int (*mach_find_smp_config)(unsigned int reserve);
 
-	int *mpc_record;
 	int (*mpc_apic_id)(struct mpc_cpu *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -66,7 +66,6 @@ struct mpc_trans {
 	unsigned short			trans_reserved;
 };
 
-/* x86_quirks member */
 static int				mpc_record;
 
 static struct mpc_trans			*translation_table[MAX_MPC_ENTRY];
@@ -177,6 +176,19 @@ static void mpc_oem_pci_bus(struct mpc_b
 	quad_local_to_mp_bus_id[quad][local] = m->busid;
 }
 
+/*
+ * Called from mpparse code.
+ * mode = 0: prescan
+ * mode = 1: one mpc entry scanned
+ */
+static void numaq_mpc_record(unsigned int mode)
+{
+	if (!mode)
+		mpc_record = 0;
+	else
+		mpc_record++;
+}
+
 static void __init MP_translation_info(struct mpc_trans *m)
 {
 	printk(KERN_INFO
@@ -264,7 +276,6 @@ static struct x86_quirks numaq_x86_quirk
 	.arch_trap_init			= NULL,
 	.mach_get_smp_config		= NULL,
 	.mach_find_smp_config		= NULL,
-	.mpc_record			= &mpc_record,
 	.mpc_apic_id			= mpc_apic_id,
 	.mpc_oem_bus_info		= mpc_oem_bus_info,
 	.mpc_oem_pci_bus		= mpc_oem_pci_bus,
@@ -285,8 +296,10 @@ static __init void early_check_numaq(voi
 	if (smp_found_config)
 		early_get_smp_config();
 
-	if (found_numaq)
+	if (found_numaq) {
 		x86_quirks = &numaq_x86_quirks;
+		platform_setup.quirks.mpc_record = numaq_mpc_record;
+	}
 }
 
 int __init get_memcfg_numaq(void)
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -320,8 +320,7 @@ static int __init smp_read_mpc(struct mp
 	/*
 	 *      Now process the configuration blocks.
 	 */
-	if (x86_quirks->mpc_record)
-		*x86_quirks->mpc_record = 0;
+	platform_setup.quirks.mpc_record(0);
 
 	while (count < mpc->length) {
 		switch (*mpt) {
@@ -353,8 +352,7 @@ static int __init smp_read_mpc(struct mp
 			count = mpc->length;
 			break;
 		}
-		if (x86_quirks->mpc_record)
-			(*x86_quirks->mpc_record)++;
+		platform_setup.quirks.mpc_record(1);
 	}
 
 #ifdef CONFIG_X86_BIGSMP
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -10,6 +10,7 @@
 #include <asm/e820.h>
 
 void __cpuinit platform_setup_noop(void) { }
+void __init platform_setup_uint_noop(unsigned int unused) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -23,4 +24,8 @@ struct __initdata platform_setup_ops pla
 		.reserve_ebda_region = reserve_ebda_region,
 		.memory_setup = default_machine_specific_memory_setup,
 	},
+
+	.quirks = {
+		.mpc_record = platform_setup_uint_noop,
+	},
 };


