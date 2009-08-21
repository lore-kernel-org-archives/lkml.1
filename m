Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbZHUVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbZHUVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932902AbZHUVbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:53 -0400
Received: from www.tglx.de ([62.245.132.106]:51607 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbZHUVbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:52 -0400
Message-Id: <20090821205602.303406250@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 10/32] x86: Move mpc_oem_pci_bus to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-move-mpc_oem_pci_bus-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h |    3 +++
 arch/x86/include/asm/setup.h    |    1 -
 arch/x86/kernel/apic/numaq_32.c |    2 +-
 arch/x86/kernel/mpparse.c       |    4 ++--
 4 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_PLATFORM_H
 #define _ASM_X86_PLATFORM_H
 
+struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
 
@@ -17,11 +18,13 @@ struct platform_setup_quirks {
  * @setup_ioapic_ids:		platform specific ioapic id override
  * @mpc_apic_id:		platform specific mpc apic id assignment
  * @smp_read_mpc_oem:		platform specific oem mpc table setup
+ * @mpc_oem_pci_bus:		platform specific pci bus setup (default NULL)
  */
 struct platform_setup_mpparse {
 	void (*setup_ioapic_ids)(void);
 	int (*mpc_apic_id)(struct mpc_cpu *m);
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
+	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -24,7 +24,6 @@ struct x86_quirks {
 	int (*mach_find_smp_config)(unsigned int reserve);
 
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
-	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 };
 
 extern void x86_quirk_intr_init(void);
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -271,7 +271,6 @@ static struct x86_quirks numaq_x86_quirk
 	.mach_get_smp_config		= NULL,
 	.mach_find_smp_config		= NULL,
 	.mpc_oem_bus_info		= mpc_oem_bus_info,
-	.mpc_oem_pci_bus		= mpc_oem_pci_bus,
 };
 
 static __init void early_check_numaq(void)
@@ -293,6 +292,7 @@ static __init void early_check_numaq(voi
 		platform_setup.mpparse.setup_ioapic_ids = platform_setup_noop;
 		platform_setup.mpparse.mpc_apic_id = mpc_apic_id;
 		platform_setup.mpparse.smp_read_mpc_oem	= smp_read_mpc_oem;
+		platform_setup.mpparse.mpc_oem_pci_bus = mpc_oem_pci_bus;
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -98,8 +98,8 @@ static void __init MP_bus_info(struct mp
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
-		if (x86_quirks->mpc_oem_pci_bus)
-			x86_quirks->mpc_oem_pci_bus(m);
+		if (platform_setup.mpparse.mpc_oem_pci_bus)
+			platform_setup.mpparse.mpc_oem_pci_bus(m);
 
 		clear_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)


