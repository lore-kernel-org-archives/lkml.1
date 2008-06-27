Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYF0Iku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYF0Iku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYF0Ikn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:40:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:61904 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbYF0Ikl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pE5zWaTxznO+p+tVe2Qi8mzud5q1f4Qbl8IWyrwkBJXP8bLPN6y6OqobCcHHjqQT6/
         feOtqpOouQqWG7+E+Um9lm9PfKwKh/dbqASdd1rPO5abssf+WTANcbvZljpSzEqcF+Ya
         FXcsIitKEvGNhdiC5mh5S00Wqos7NtddNvyf4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: let setup_arch call init_apic_mappings for 32bit
Date: Fri, 27 Jun 2008 01:41:56 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com> <200806262317.48716.yhlu.kernel@gmail.com>
In-Reply-To: <200806262317.48716.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806270141.56409.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


instead of calling it from trap_init()

also move init ioapic mapping out of apic_32.c

so 32 bit do same as 64 bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic_32.c    |   30 ------------------------------
 arch/x86/kernel/io_apic_32.c |   32 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c      |    6 ++----
 arch/x86/kernel/traps_32.c   |    4 ----
 include/asm-x86/apic.h       |    1 +
 include/asm-x86/io_apic.h    |    1 +
 6 files changed, 36 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -1197,36 +1197,6 @@ void __init init_apic_mappings(void)
 	if (boot_cpu_physical_apicid == -1U)
 		boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
 
-#ifdef CONFIG_X86_IO_APIC
-	{
-		unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
-		int i;
-
-		for (i = 0; i < nr_ioapics; i++) {
-			if (smp_found_config) {
-				ioapic_phys = mp_ioapics[i].mp_apicaddr;
-				if (!ioapic_phys) {
-					printk(KERN_ERR
-					       "WARNING: bogus zero IO-APIC "
-					       "address found in MPTABLE, "
-					       "disabling IO/APIC support!\n");
-					smp_found_config = 0;
-					skip_ioapic_setup = 1;
-					goto fake_ioapic_page;
-				}
-			} else {
-fake_ioapic_page:
-				ioapic_phys = (unsigned long)
-					      alloc_bootmem_pages(PAGE_SIZE);
-				ioapic_phys = __pa(ioapic_phys);
-			}
-			set_fixmap_nocache(idx, ioapic_phys);
-			printk(KERN_DEBUG "mapped IOAPIC to %08lx (%08lx)\n",
-			       __fix_to_virt(idx), ioapic_phys);
-			idx++;
-		}
-	}
-#endif
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
+#include <linux/bootmem.h>
 #include <linux/mc146818rtc.h>
 #include <linux/compiler.h>
 #include <linux/acpi.h>
@@ -2854,3 +2855,34 @@ static int __init parse_noapic(char *arg
 	return 0;
 }
 early_param("noapic", parse_noapic);
+
+void __init ioapic_init_mappings(void)
+{
+	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
+	int i;
+
+	for (i = 0; i < nr_ioapics; i++) {
+		if (smp_found_config) {
+			ioapic_phys = mp_ioapics[i].mp_apicaddr;
+			if (!ioapic_phys) {
+				printk(KERN_ERR
+				       "WARNING: bogus zero IO-APIC "
+				       "address found in MPTABLE, "
+				       "disabling IO/APIC support!\n");
+				smp_found_config = 0;
+				skip_ioapic_setup = 1;
+				goto fake_ioapic_page;
+			}
+		} else {
+fake_ioapic_page:
+			ioapic_phys = (unsigned long)
+				      alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = __pa(ioapic_phys);
+		}
+		set_fixmap_nocache(idx, ioapic_phys);
+		printk(KERN_DEBUG "mapped IOAPIC to %08lx (%08lx)\n",
+		       __fix_to_virt(idx), ioapic_phys);
+		idx++;
+	}
+}
+
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -771,16 +771,14 @@ void __init setup_arch(char **cmdline_p)
 		get_smp_config();
 #endif
 
-#ifdef CONFIG_X86_64
 	init_apic_mappings();
 	ioapic_init_mappings();
-#else
-# if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
+
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
 	if (def_to_bigsmp)
 		printk(KERN_WARNING "More than 8 CPUs detected and "
 			"CONFIG_X86_PC cannot handle it.\nUse "
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
-# endif
 #endif
 	kvm_guest_init();
 
Index: linux-2.6/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6/arch/x86/kernel/traps_32.c
@@ -1210,10 +1210,6 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-#ifdef CONFIG_X86_LOCAL_APIC
-	init_apic_mappings();
-#endif
-	set_trap_gate(0,  &divide_error);
 	set_intr_gate(1,  &debug);
 	set_intr_gate(2,  &nmi);
 	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -135,6 +135,7 @@ extern int apic_is_clustered_box(void);
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
+static inline void init_apic_mappings(void) { }
 
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
Index: linux-2.6/include/asm-x86/io_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/io_apic.h
+++ linux-2.6/include/asm-x86/io_apic.h
@@ -196,6 +196,7 @@ extern void ioapic_init_mappings(void);
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
+static inline void ioapic_init_mappings(void) { }
 #endif
 
 #endif
