Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbZHUVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbZHUVby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbZHUVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:51 -0400
Received: from www.tglx.de ([62.245.132.106]:51584 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbZHUVbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:47 -0400
Message-Id: <20090821205602.247707923@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 09/32] x86: Move smp_read_mpc_oem to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-move-smp_read_mpc_oem-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move smp_read_mpc_oem from quirks to platform_setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/mpspec.h    |    2 ++
 arch/x86/include/asm/platform.h  |    3 +++
 arch/x86/include/asm/setup.h     |    3 ---
 arch/x86/kernel/apic/numaq_32.c  |    6 +++---
 arch/x86/kernel/mpparse.c        |    8 ++++----
 arch/x86/kernel/platform_setup.c |    1 +
 6 files changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -63,11 +63,13 @@ extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
 extern int enable_update_mptable;
 extern int default_mpc_apic_id(struct mpc_cpu *m);
+extern void default_smp_read_mpc_oem(struct mpc_table *mpc);
 #else
 static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
 #define enable_update_mptable 0
 #define default_mpc_apic_id NULL
+#define default_smp_read_mpc_oem NULL
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PLATFORM_H
 
 struct mpc_cpu;
+struct mpc_table;
 
 /**
  * struct platform_setup_quirks - platform specific quirks
@@ -15,10 +16,12 @@ struct platform_setup_quirks {
  * struct platform_setup_mpparse - platform specific mpparse ops
  * @setup_ioapic_ids:		platform specific ioapic id override
  * @mpc_apic_id:		platform specific mpc apic id assignment
+ * @smp_read_mpc_oem:		platform specific oem mpc table setup
  */
 struct platform_setup_mpparse {
 	void (*setup_ioapic_ids)(void);
 	int (*mpc_apic_id)(struct mpc_cpu *m);
+	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -13,7 +13,6 @@
  * Any setup quirks to be performed?
  */
 struct mpc_bus;
-struct mpc_oemtable;
 
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
@@ -26,8 +25,6 @@ struct x86_quirks {
 
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
-	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
-				unsigned short oemsize);
 };
 
 extern void x86_quirk_intr_init(void);
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -218,9 +218,9 @@ static int __init mpf_checksum(unsigned 
 /*
  * Read/parse the MPC oem tables
  */
-static void __init
- smp_read_mpc_oem(struct mpc_oemtable *oemtable, unsigned short oemsize)
+static void __init smp_read_mpc_oem(struct mpc_table *mpc)
 {
+	struct mpc_oemtable *oem_table = (void *)(long)mpc->oemptr;
 	int count = sizeof(*oemtable);	/* the header size */
 	unsigned char *oemptr = ((unsigned char *)oemtable) + count;
 
@@ -272,7 +272,6 @@ static struct x86_quirks numaq_x86_quirk
 	.mach_find_smp_config		= NULL,
 	.mpc_oem_bus_info		= mpc_oem_bus_info,
 	.mpc_oem_pci_bus		= mpc_oem_pci_bus,
-	.smp_read_mpc_oem		= smp_read_mpc_oem,
 };
 
 static __init void early_check_numaq(void)
@@ -293,6 +292,7 @@ static __init void early_check_numaq(voi
 		platform_setup.quirks.mpc_record = numaq_mpc_record;
 		platform_setup.mpparse.setup_ioapic_ids = platform_setup_noop;
 		platform_setup.mpparse.mpc_apic_id = mpc_apic_id;
+		platform_setup.mpparse.smp_read_mpc_oem	= smp_read_mpc_oem;
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -293,6 +293,8 @@ static void __init smp_dump_mptable(stru
 			1, mpc, mpc->length, 1);
 }
 
+void __init default_smp_read_mpc_oem(struct mpc_table *mpc) { }
+
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -314,10 +316,8 @@ static int __init smp_read_mpc(struct mp
 	if (early)
 		return 1;
 
-	if (mpc->oemptr && x86_quirks->smp_read_mpc_oem) {
-		struct mpc_oemtable *oem_table = (void *)(long)mpc->oemptr;
-		x86_quirks->smp_read_mpc_oem(oem_table, mpc->oemsize);
-	}
+	if (mpc->oemptr)
+		platform_setup.mpparse.smp_read_mpc_oem(mpc);
 
 	/*
 	 *      Now process the configuration blocks.
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -29,6 +29,7 @@ struct __initdata platform_setup_ops pla
 	.mpparse = {
 		.setup_ioapic_ids = platform_setup_noop,
 		.mpc_apic_id = default_mpc_apic_id,
+		.smp_read_mpc_oem = default_smp_read_mpc_oem,
 	},
 
 	.quirks = {


