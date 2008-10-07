Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYJGVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYJGVKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbYJGVJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:09:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:52753 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbYJGVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:09:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="448288179"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C928C0.FCEFA6ED"
Subject: RE: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Date: Tue, 7 Oct 2008 14:09:29 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Thread-Index: AckovCmeoclYfmCFT7uDEeT4M5Iv2wABI1zw
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com>
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 07 Oct 2008 21:09:30.0497 (UTC) FILETIME=[FD483710:01C928C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C928C0.FCEFA6ED
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

(large) Patch inline below (and still attached for those who prefer it).

Linux kernel changes to support tboot and Intel TXT.
=20
Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by:  Gang Wei <gang.wei@intel.com>

diff -r 29cfdc52a076 arch/x86/configs/i386_defconfig
--- a/arch/x86/configs/i386_defconfig	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/configs/i386_defconfig	Tue Oct 07 00:13:02 2008 -0700
@@ -54,6 +54,7 @@ CONFIG_X86_TRAMPOLINE=3Dy
 CONFIG_X86_TRAMPOLINE=3Dy
 CONFIG_KTIME_SCALAR=3Dy
 CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
+# CONFIG_TXT is not set
=20
 #
 # General setup
diff -r 29cfdc52a076 arch/x86/configs/x86_64_defconfig
--- a/arch/x86/configs/x86_64_defconfig	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/configs/x86_64_defconfig	Tue Oct 07 00:13:02 2008 -0700
@@ -54,6 +54,7 @@ CONFIG_X86_TRAMPOLINE=3Dy
 CONFIG_X86_TRAMPOLINE=3Dy
 # CONFIG_KTIME_SCALAR is not set
 CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
+# CONFIG_TXT is not set
=20
 #
 # General setup
diff -r 29cfdc52a076 arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/kernel/Makefile	Tue Oct 07 00:13:02 2008 -0700
@@ -44,6 +44,7 @@ obj-$(CONFIG_X86_32)		+=3D tls.o
 obj-$(CONFIG_X86_32)		+=3D tls.o
 obj-$(CONFIG_IA32_EMULATION)	+=3D tls.o
 obj-y				+=3D step.o
+obj-$(CONFIG_TXT)		+=3D tboot.o
 obj-$(CONFIG_STACKTRACE)	+=3D stacktrace.o
 obj-y				+=3D cpu/
 obj-y				+=3D acpi/
diff -r 29cfdc52a076 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/kernel/reboot.c	Tue Oct 07 00:13:02 2008 -0700
@@ -20,6 +20,8 @@
 #else
 # include <asm/iommu.h>
 #endif
+
+#include <asm/tboot.h>
=20
 /*
  * Power off function, if any
@@ -456,11 +458,13 @@ static void native_machine_restart(char=20
=20
 	if (!reboot_force)
 		machine_shutdown();
+	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 	machine_emergency_restart();
 }
=20
 static void native_machine_halt(void)
 {
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
=20
 static void native_machine_power_off(void)
@@ -470,6 +474,8 @@ static void native_machine_power_off(voi
 			machine_shutdown();
 		pm_power_off();
 	}
+	/* a fallback in case there is no PM info available */
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
=20
 struct machine_ops machine_ops =3D {
diff -r 29cfdc52a076 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/kernel/setup.c	Tue Oct 07 00:13:02 2008 -0700
@@ -115,6 +115,8 @@ struct boot_params __initdata boot_param
 #else
 struct boot_params boot_params;
 #endif
+
+#include <asm/tboot.h>
=20
 /*
  * Machine setup..
@@ -833,6 +835,8 @@ void __init setup_arch(char **cmdline_p)
 	paravirt_pagetable_setup_done(swapper_pg_dir);
 	paravirt_post_allocator_init();
=20
+	tboot_probe();
+
 #ifdef CONFIG_X86_64
 	map_vsyscall();
 #endif
diff -r 29cfdc52a076 arch/x86/kernel/tboot.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/arch/x86/kernel/tboot.c	Tue Oct 07 00:13:02 2008 -0700
@@ -0,0 +1,258 @@
+/*
+ * tboot.c: main implementation of helper functions used by kernel for
+ *          runtime support
+ *
+ * Copyright (c) 2006-2008, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but
WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
along with
+ * this program; if not, write to the Free Software Foundation, Inc.,=20
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/pfn.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/bootparam.h>
+#include <asm/tboot.h>
+
+/* Global pointer to shared data; NULL means no measured launch. */
+struct tboot_shared *tboot_shared;
+
+void __init tboot_probe(void)
+{
+	extern struct boot_params boot_params;
+
+	/* Look for valid page-aligned address for shared page. */
+	if (boot_params.hdr.tboot_shared_addr =3D=3D 0)
+		return;
+
+	/* Map and check for tboot UUID. */
+	set_fixmap(FIX_TBOOT_SHARED_BASE,
boot_params.hdr.tboot_shared_addr);
+	tboot_shared =3D (struct tboot_shared *)
+				fix_to_virt(FIX_TBOOT_SHARED_BASE);
+	if (memcmp(&TBOOT_SHARED_UUID, &tboot_shared->uuid,
+		   sizeof(struct tboot_uuid))) {
+		printk(KERN_WARNING "tboot_shared at %lxP/%pV is
invalid\n",
+		       (unsigned long)boot_params.hdr.tboot_shared_addr,
+		       tboot_shared);
+		tboot_shared =3D NULL;
+		return;
+	}
+	if (tboot_shared->version < 2) {
+		printk(KERN_WARNING "tboot_shared version is invalid:
%d\n",
+		       tboot_shared->version);
+		tboot_shared =3D NULL;
+		return;
+	}
+
+	printk(KERN_INFO "TBOOT: found shared page at phys addr
0x%lx:\n",
+	       (unsigned long)boot_params.hdr.tboot_shared_addr);
+	printk(KERN_DEBUG "  version: %d\n", tboot_shared->version);
+	printk(KERN_DEBUG "  log_addr: 0x%08x\n",
tboot_shared->log_addr);
+	printk(KERN_DEBUG "  shutdown_entry32: 0x%08x\n",
+	       tboot_shared->shutdown_entry32);
+	printk(KERN_DEBUG "  shutdown_entry64: 0x%08x\n",
+	       tboot_shared->shutdown_entry64);
+	printk(KERN_DEBUG "  shutdown_type: %d\n",
tboot_shared->shutdown_type);
+	printk(KERN_DEBUG "  s3_tb_wakeup_entry: 0x%08x\n",
+	       tboot_shared->s3_tb_wakeup_entry);
+	printk(KERN_DEBUG "  s3_k_wakeup_entry: 0x%08x\n",
+	       tboot_shared->s3_k_wakeup_entry);
+	printk(KERN_DEBUG "  &acpi_sinfo: 0x%p\n",
&tboot_shared->acpi_sinfo);
+	printk(KERN_DEBUG "  tboot_base: 0x%08x\n",
tboot_shared->tboot_base);
+	printk(KERN_DEBUG "  tboot_size: 0x%x\n",
tboot_shared->tboot_size);
+}
+
+static pgd_t *tboot_pg_dir;
+static inline void switch_to_tboot_pt(void)
+{
+	native_write_cr3(__pa(tboot_pg_dir));
+}
+
+struct tboot_pgt_struct {
+	unsigned long ptr;
+	struct tboot_pgt_struct *next;
+};
+static struct tboot_pgt_struct *tboot_pgt;
+
+/* Allocate (and save for later release) a page */
+static unsigned long alloc_tboot_page(void)
+{
+	unsigned long ptr;
+	struct tboot_pgt_struct *pgt;
+
+	ptr =3D get_zeroed_page(GFP_ATOMIC);
+	if (ptr) {
+		pgt =3D kmalloc(sizeof(*pgt), GFP_ATOMIC);
+		if (!pgt) {
+			free_page(ptr);
+			return 0;
+		}
+		pgt->ptr =3D ptr;
+		pgt->next =3D tboot_pgt;
+		tboot_pgt =3D pgt;
+	}
+	return ptr;
+}
+
+/* Clean up memory used for tboot mapping */
+void clean_up_tboot_mapping(void)
+{
+	struct tboot_pgt_struct *pgt;
+
+	if (!tboot_in_measured_env())
+		return;
+
+	pgt =3D tboot_pgt;
+	while (pgt) {
+		free_page(pgt->ptr);
+		tboot_pgt =3D pgt->next;
+		kfree(pgt);
+		pgt =3D tboot_pgt;
+	}
+}
+
+static int map_page_for_tboot(unsigned long vaddr, unsigned long pfn,
+				pgprot_t prot)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte, new_pte;
+
+	pgd =3D tboot_pg_dir + pgd_index(vaddr);
+#ifdef __x86_64__
+	if (!pgd_val(*pgd)) {
+		pud =3D (pud_t *)alloc_tboot_page();
+		if (!pud)
+			return -1;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+	pud =3D pud_offset(pgd, vaddr);
+	if (!pud_val(*pud)) {
+		pmd =3D (pmd_t *)alloc_tboot_page();
+		if (!pmd)
+			return -1;
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+	pmd =3D pmd_offset(pud, vaddr);
+#else
+#ifdef CONFIG_X86_PAE
+	if (!pgd_val(*pgd)) {
+		pmd =3D (pmd_t *)alloc_tboot_page();
+		if (!pmd)
+			return -1;
+		set_pgd(pgd, __pgd(__pa(pmd) | _PAGE_PRESENT));
+		pud =3D pud_offset(pgd, 0);
+	}
+	pud =3D pud_offset(pgd, 0);
+	pmd =3D pmd_offset(pud, vaddr);
+#else
+	pud =3D pud_offset(pgd, 0);
+	pmd =3D pmd_offset(pud, 0);
+#endif
+#endif
+	if (!pmd_val(*pmd)) {
+		pte =3D (pte_t *)alloc_tboot_page();
+		if (!pte)
+			return -1;
+		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+	}
+	new_pte =3D pfn_pte(pfn, prot);
+
+	pte =3D pte_offset_kernel(pmd, vaddr);
+
+	if (pte_val(*pte) &&
+#if defined(CONFIG_X86_PAE) || defined(__x86_64__)
+	    pte_val(*pte) !=3D (pte_val(new_pte) & __supported_pte_mask)
+#else
+	    pte_val(*pte) !=3D pte_val(new_pte)
+#endif
+	   ) {
+		pte_ERROR(*pte);
+		return -1;
+	}
+
+	set_pte(pte, new_pte);
+
+	return 0;
+}
+
+static int map_pages_for_tboot(unsigned long vaddr, unsigned long
start_pfn,
+				unsigned long nr)
+{
+	printk(KERN_DEBUG "map_pages_for_tboot %lx to %lx (%lx)\n",
+		vaddr, start_pfn << PAGE_SHIFT, nr << PAGE_SHIFT);
+
+	/* Reuse the original kernel mapping */
+	tboot_pg_dir =3D (pgd_t *)alloc_tboot_page();
+	if (!tboot_pg_dir)
+		return -1;
+
+#ifdef __x86_64__
+	set_pgd(tboot_pg_dir + pgd_index(__START_KERNEL_map),
+		swapper_pg_dir[pgd_index(__START_KERNEL_map)]);
+#else
+	memcpy(tboot_pg_dir + KERNEL_PGD_BOUNDARY,
+		swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+		sizeof(swapper_pg_dir[0]) * KERNEL_PGD_PTRS);
+#endif
+
+	for (; nr > 0; nr--, vaddr +=3D PAGE_SIZE, start_pfn++) {
+		if (map_page_for_tboot(vaddr, start_pfn,
+				       __pgprot(__PAGE_KERNEL_EXEC)))
+			return -1;
+	}
+
+	return 0;
+}
+
+void tboot_shutdown(u32 shutdown_type)
+{
+	u32 map_base, map_size;
+
+	if (!tboot_in_measured_env())
+		return;
+
+	tboot_shared->shutdown_type =3D shutdown_type;
+
+	local_irq_disable();
+
+	/* Create identity map for tboot shutdown code. */
+	if (tboot_shared->version >=3D 0x02) {
+		map_base =3D PFN_DOWN(tboot_shared->tboot_base);
+		map_size =3D PFN_UP(tboot_shared->tboot_size);
+	} else {
+		map_base =3D 0;
+		map_size =3D PFN_UP(0xa0000);
+	}
+
+	if (map_pages_for_tboot(map_base << PAGE_SHIFT, map_base,
map_size)) {
+		printk(KERN_DEBUG "error mapping tboot pages "
+				  "(mfns) @ 0x%x, 0x%x\n", map_base,
map_size);
+		clean_up_tboot_mapping();
+		return;
+	}
+
+	switch_to_tboot_pt();
+
+#ifdef __x86_64__
+	asm volatile ("jmp *%%rdi" : : "D"
(tboot_shared->shutdown_entry64));
+#else
+	asm volatile ("jmp *%%edi" : : "D"
(tboot_shared->shutdown_entry32));
+#endif
+
+	BUG(); /* should not reach here */
+}
diff -r 29cfdc52a076 arch/x86/power/cpu_32.c
--- a/arch/x86/power/cpu_32.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/power/cpu_32.c	Tue Oct 07 00:13:02 2008 -0700
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/tboot.h>
=20
 static struct saved_context saved_context;
=20
@@ -136,5 +137,8 @@ void restore_processor_state(void)
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
+
+	/* Clean up memory mapping for tboot range */
+	clean_up_tboot_mapping();
 }
 EXPORT_SYMBOL(restore_processor_state);
diff -r 29cfdc52a076 arch/x86/power/cpu_64.c
--- a/arch/x86/power/cpu_64.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/power/cpu_64.c	Tue Oct 07 00:13:02 2008 -0700
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/tboot.h>
=20
 static void fix_processor_context(void);
=20
@@ -131,6 +132,9 @@ void restore_processor_state(void)
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
+
+	/* Clean up memory mapping for tboot range */
+	clean_up_tboot_mapping();
 }
=20
 static void fix_processor_context(void)
diff -r 29cfdc52a076 drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/drivers/acpi/hardware/hwsleep.c	Tue Oct 07 00:13:02 2008 -0700
@@ -44,6 +44,7 @@
=20
 #include <acpi/acpi.h>
 #include <acpi/actables.h>
+#include <asm/tboot.h>
=20
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
@@ -77,6 +78,13 @@ acpi_set_firmware_waking_vector(acpi_phy
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
+
+#ifdef CONFIG_TXT
+	if (tboot_in_measured_env()) {
+		tboot_shared->s3_k_wakeup_entry =3D
(uint32_t)physical_address;
+		physical_address =3D tboot_shared->s3_tb_wakeup_entry;
+	}
+#endif
=20
 	/* Set the vector */
=20
@@ -238,6 +246,29 @@ acpi_status acpi_enter_sleep_state_prep(
=20
 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
=20
+#ifdef CONFIG_TXT
+static void tboot_sleep(u8 sleep_state)
+{
+	uint32_t shutdown_type;
+
+	switch (sleep_state) {
+	case ACPI_STATE_S3:
+		shutdown_type =3D TB_SHUTDOWN_S3;
+		break;
+	case ACPI_STATE_S4:
+		shutdown_type =3D TB_SHUTDOWN_S4;
+		break;
+	case ACPI_STATE_S5:
+		shutdown_type =3D TB_SHUTDOWN_S5;
+		break;
+	default:
+		return;
+	}
+
+	tboot_shutdown(shutdown_type);
+}
+#endif
+
=20
/***********************************************************************
********
  *
  * FUNCTION:    acpi_enter_sleep_state
@@ -361,6 +392,20 @@ acpi_status asmlinkage acpi_enter_sleep_
=20
 	PM1Acontrol |=3D sleep_enable_reg_info->access_bit_mask;
 	PM1Bcontrol |=3D sleep_enable_reg_info->access_bit_mask;
+
+#ifdef CONFIG_TXT
+	if (tboot_in_measured_env()) {
+		tboot_shared->acpi_sinfo.pm1a_cnt =3D
+
(uint16_t)acpi_gbl_FADT.xpm1a_control_block.address;
+		tboot_shared->acpi_sinfo.pm1b_cnt =3D
+
(uint16_t)acpi_gbl_FADT.xpm1b_control_block.address;
+		tboot_shared->acpi_sinfo.pm1a_cnt_val =3D PM1Acontrol;
+		tboot_shared->acpi_sinfo.pm1b_cnt_val =3D PM1Bcontrol;
+		tboot_sleep(sleep_state);
+		printk(KERN_DEBUG "TBOOT failed entering s3 state\n");
+		return_ACPI_STATUS(AE_ERROR);
+	}
+#endif
=20
 	/* Write #2: SLP_TYP + SLP_EN */
=20
diff -r 29cfdc52a076 include/asm-x86/bootparam.h
--- a/include/asm-x86/bootparam.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/include/asm-x86/bootparam.h	Tue Oct 07 00:13:02 2008 -0700
@@ -62,6 +62,7 @@ struct setup_header {
 	__u32	payload_offset;
 	__u32	payload_length;
 	__u64	setup_data;
+	__u32   tboot_shared_addr;
 } __attribute__((packed));
=20
 struct sys_desc_table {
diff -r 29cfdc52a076 include/asm-x86/fixmap_32.h
--- a/include/asm-x86/fixmap_32.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/include/asm-x86/fixmap_32.h	Tue Oct 07 00:13:02 2008 -0700
@@ -85,6 +85,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+#ifdef CONFIG_TXT
+	FIX_TBOOT_SHARED_BASE,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
diff -r 29cfdc52a076 include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/include/asm-x86/fixmap_64.h	Tue Oct 07 00:13:02 2008 -0700
@@ -56,6 +56,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
+#ifdef CONFIG_TXT
+	FIX_TBOOT_SHARED_BASE,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
diff -r 29cfdc52a076 include/asm-x86/tboot.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-x86/tboot.h	Tue Oct 07 00:13:02 2008 -0700
@@ -0,0 +1,101 @@
+/*
+ * tboot.h: shared data structure with MLE and kernel and functions
+ *          used by kernel for runtime support
+ *
+ * Copyright (c) 2006-2008, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but
WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
along with
+ * this program; if not, write to the Free Software Foundation, Inc.,=20
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef _ASM_TBOOT_H
+#define _ASM_TBOOT_H
+
+#define TB_SHUTDOWN_REBOOT      0
+#define TB_SHUTDOWN_S5          1
+#define TB_SHUTDOWN_S4          2
+#define TB_SHUTDOWN_S3          3
+#define TB_SHUTDOWN_HALT        4
+
+#ifdef CONFIG_TXT
+struct tboot_uuid {
+	u32    data1;
+	u16    data2;
+	u16    data3;
+	u16    data4;
+	u8     data5[6];
+} __attribute__ ((__packed__));
+
+/* used to communicate between tboot and the launched kernel */
+
+struct tboot_acpi_sleep_info {
+	u16 pm1a_cnt;
+	u16 pm1b_cnt;
+	u16 pm1a_evt;
+	u16 pm1b_evt;
+	u16 pm1a_cnt_val;
+	u16 pm1b_cnt_val;
+}  __attribute__ ((__packed__));
+
+struct tboot_shared {
+	/* version 0x01+ fields: */
+	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
+	u32  version;      	/* Version number: 2 is current */
+	u32  log_addr;     	/* physical addr of tb_log_t log */
+	u32  shutdown_entry32;	/* entry point for tboot shutdown from
32b */
+	u32  shutdown_entry64;	/* entry point for tboot shutdown from
64b */
+	u32  shutdown_type;	/* type of shutdown (TB_SHUTDOWN_*) */
+	u32  s3_tb_wakeup_entry;/* entry point for tboot s3 wake up */
+	u32  s3_k_wakeup_entry;	/* entry point for kernel s3 wake up */
+	struct tboot_acpi_sleep_info
+		  acpi_sinfo;	/* where kernel put acpi sleep info in
Sx */
+	u8   reserved[52];	/* this pad is for compat with old field
*/
+	/* version 0x02+ fields: */
+	u32  tboot_base;	/* starting addr for tboot */
+	u32  tboot_size;	/* size of tboot */
+} __attribute__ ((__packed__));
+
+/* {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} */
+#define TBOOT_SHARED_UUID     \
+		((struct tboot_uuid){ 0x663c8dff, 0xe8b3, 0x4b82,
0xaabf,   \
+				{ 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8 } })
+
+extern struct tboot_shared *tboot_shared;
+
+static inline int tboot_in_measured_env(void)
+{
+	return tboot_shared !=3D NULL;
+}
+
+extern void clean_up_tboot_mapping(void);
+extern void tboot_probe(void);
+extern void tboot_shutdown(u32 shutdown_type);
+
+#else     /* CONFIG_TXT */
+
+static inline void clean_up_tboot_mapping(void)
+{
+}
+
+static inline void tboot_probe(void)
+{
+}
+
+static inline void tboot_shutdown(u32 shutdown_type)
+{
+}
+
+#endif /* !CONFIG_TXT */
+
+#endif /* _ASM_TBOOT_H */
diff -r 29cfdc52a076 security/Kconfig
--- a/security/Kconfig	Mon Oct 06 12:50:47 2008 -0700
+++ b/security/Kconfig	Tue Oct 07 00:13:02 2008 -0700
@@ -115,6 +115,23 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  /proc/sys/vm/mmap_min_addr tunable.
=20
=20
+config TXT
+        bool "Enable Intel(R) Trusted Execution Technology (TXT)"
+        depends on EXPERIMENTAL && X86
+        help
+          This option enables support for booting the kernel with
+          the Trusted Boot (tboot) module. This will utilize
+          Intel(R) Trusted Execution Technology (TXT) to perform a
+          measured launch of the kernel. If the system does not
+          support TXT, this will have no effect.
+
+          See <http://www.intel.com/technology/security/> for more
+          information about Intel(R) TXT.
+          And see <http://tboot.sourceforge.net> for more information
+          about tboot.
+
+          If you are unsure as to whether this is required, answer N.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig


------_=_NextPart_001_01C928C0.FCEFA6ED
Content-Type: application/octet-stream;
	name="txt-linux-tboot.patch"
Content-Transfer-Encoding: base64
Content-Description: txt-linux-tboot.patch
Content-Disposition: attachment;
	filename="txt-linux-tboot.patch"

ZGlmZiAtciAyOWNmZGM1MmEwNzYgYXJjaC94ODYvY29uZmlncy9pMzg2X2RlZmNvbmZpZwotLS0g
YS9hcmNoL3g4Ni9jb25maWdzL2kzODZfZGVmY29uZmlnCU1vbiBPY3QgMDYgMTI6NTA6NDcgMjAw
OCAtMDcwMAorKysgYi9hcmNoL3g4Ni9jb25maWdzL2kzODZfZGVmY29uZmlnCVR1ZSBPY3QgMDcg
MDA6MTM6MDIgMjAwOCAtMDcwMApAQCAtNTQsNiArNTQsNyBAQCBDT05GSUdfWDg2X1RSQU1QT0xJ
TkU9eQogQ09ORklHX1g4Nl9UUkFNUE9MSU5FPXkKIENPTkZJR19LVElNRV9TQ0FMQVI9eQogQ09O
RklHX0RFRkNPTkZJR19MSVNUPSIvbGliL21vZHVsZXMvJFVOQU1FX1JFTEVBU0UvLmNvbmZpZyIK
KyMgQ09ORklHX1RYVCBpcyBub3Qgc2V0CiAKICMKICMgR2VuZXJhbCBzZXR1cApkaWZmIC1yIDI5
Y2ZkYzUyYTA3NiBhcmNoL3g4Ni9jb25maWdzL3g4Nl82NF9kZWZjb25maWcKLS0tIGEvYXJjaC94
ODYvY29uZmlncy94ODZfNjRfZGVmY29uZmlnCU1vbiBPY3QgMDYgMTI6NTA6NDcgMjAwOCAtMDcw
MAorKysgYi9hcmNoL3g4Ni9jb25maWdzL3g4Nl82NF9kZWZjb25maWcJVHVlIE9jdCAwNyAwMDox
MzowMiAyMDA4IC0wNzAwCkBAIC01NCw2ICs1NCw3IEBAIENPTkZJR19YODZfVFJBTVBPTElORT15
CiBDT05GSUdfWDg2X1RSQU1QT0xJTkU9eQogIyBDT05GSUdfS1RJTUVfU0NBTEFSIGlzIG5vdCBz
ZXQKIENPTkZJR19ERUZDT05GSUdfTElTVD0iL2xpYi9tb2R1bGVzLyRVTkFNRV9SRUxFQVNFLy5j
b25maWciCisjIENPTkZJR19UWFQgaXMgbm90IHNldAogCiAjCiAjIEdlbmVyYWwgc2V0dXAKZGlm
ZiAtciAyOWNmZGM1MmEwNzYgYXJjaC94ODYva2VybmVsL01ha2VmaWxlCi0tLSBhL2FyY2gveDg2
L2tlcm5lbC9NYWtlZmlsZQlNb24gT2N0IDA2IDEyOjUwOjQ3IDIwMDggLTA3MDAKKysrIGIvYXJj
aC94ODYva2VybmVsL01ha2VmaWxlCVR1ZSBPY3QgMDcgMDA6MTM6MDIgMjAwOCAtMDcwMApAQCAt
NDQsNiArNDQsNyBAQCBvYmotJChDT05GSUdfWDg2XzMyKQkJKz0gdGxzLm8KIG9iai0kKENPTkZJ
R19YODZfMzIpCQkrPSB0bHMubwogb2JqLSQoQ09ORklHX0lBMzJfRU1VTEFUSU9OKQkrPSB0bHMu
bwogb2JqLXkJCQkJKz0gc3RlcC5vCitvYmotJChDT05GSUdfVFhUKQkJKz0gdGJvb3Qubwogb2Jq
LSQoQ09ORklHX1NUQUNLVFJBQ0UpCSs9IHN0YWNrdHJhY2Uubwogb2JqLXkJCQkJKz0gY3B1Lwog
b2JqLXkJCQkJKz0gYWNwaS8KZGlmZiAtciAyOWNmZGM1MmEwNzYgYXJjaC94ODYva2VybmVsL3Jl
Ym9vdC5jCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYwlNb24gT2N0IDA2IDEyOjUwOjQ3
IDIwMDggLTA3MDAKKysrIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jCVR1ZSBPY3QgMDcgMDA6
MTM6MDIgMjAwOCAtMDcwMApAQCAtMjAsNiArMjAsOCBAQAogI2Vsc2UKICMgaW5jbHVkZSA8YXNt
L2lvbW11Lmg+CiAjZW5kaWYKKworI2luY2x1ZGUgPGFzbS90Ym9vdC5oPgogCiAvKgogICogUG93
ZXIgb2ZmIGZ1bmN0aW9uLCBpZiBhbnkKQEAgLTQ1NiwxMSArNDU4LDEzIEBAIHN0YXRpYyB2b2lk
IG5hdGl2ZV9tYWNoaW5lX3Jlc3RhcnQoY2hhciAKIAogCWlmICghcmVib290X2ZvcmNlKQogCQlt
YWNoaW5lX3NodXRkb3duKCk7CisJdGJvb3Rfc2h1dGRvd24oVEJfU0hVVERPV05fUkVCT09UKTsK
IAltYWNoaW5lX2VtZXJnZW5jeV9yZXN0YXJ0KCk7CiB9CiAKIHN0YXRpYyB2b2lkIG5hdGl2ZV9t
YWNoaW5lX2hhbHQodm9pZCkKIHsKKwl0Ym9vdF9zaHV0ZG93bihUQl9TSFVURE9XTl9IQUxUKTsK
IH0KIAogc3RhdGljIHZvaWQgbmF0aXZlX21hY2hpbmVfcG93ZXJfb2ZmKHZvaWQpCkBAIC00NzAs
NiArNDc0LDggQEAgc3RhdGljIHZvaWQgbmF0aXZlX21hY2hpbmVfcG93ZXJfb2ZmKHZvaQogCQkJ
bWFjaGluZV9zaHV0ZG93bigpOwogCQlwbV9wb3dlcl9vZmYoKTsKIAl9CisJLyogYSBmYWxsYmFj
ayBpbiBjYXNlIHRoZXJlIGlzIG5vIFBNIGluZm8gYXZhaWxhYmxlICovCisJdGJvb3Rfc2h1dGRv
d24oVEJfU0hVVERPV05fSEFMVCk7CiB9CiAKIHN0cnVjdCBtYWNoaW5lX29wcyBtYWNoaW5lX29w
cyA9IHsKZGlmZiAtciAyOWNmZGM1MmEwNzYgYXJjaC94ODYva2VybmVsL3NldHVwLmMKLS0tIGEv
YXJjaC94ODYva2VybmVsL3NldHVwLmMJTW9uIE9jdCAwNiAxMjo1MDo0NyAyMDA4IC0wNzAwCisr
KyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCVR1ZSBPY3QgMDcgMDA6MTM6MDIgMjAwOCAtMDcw
MApAQCAtMTE1LDYgKzExNSw4IEBAIHN0cnVjdCBib290X3BhcmFtcyBfX2luaXRkYXRhIGJvb3Rf
cGFyYW0KICNlbHNlCiBzdHJ1Y3QgYm9vdF9wYXJhbXMgYm9vdF9wYXJhbXM7CiAjZW5kaWYKKwor
I2luY2x1ZGUgPGFzbS90Ym9vdC5oPgogCiAvKgogICogTWFjaGluZSBzZXR1cC4uCkBAIC04MzMs
NiArODM1LDggQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogCXBh
cmF2aXJ0X3BhZ2V0YWJsZV9zZXR1cF9kb25lKHN3YXBwZXJfcGdfZGlyKTsKIAlwYXJhdmlydF9w
b3N0X2FsbG9jYXRvcl9pbml0KCk7CiAKKwl0Ym9vdF9wcm9iZSgpOworCiAjaWZkZWYgQ09ORklH
X1g4Nl82NAogCW1hcF92c3lzY2FsbCgpOwogI2VuZGlmCmRpZmYgLXIgMjljZmRjNTJhMDc2IGFy
Y2gveDg2L2tlcm5lbC90Ym9vdC5jCi0tLSAvZGV2L251bGwJVGh1IEphbiAwMSAwMDowMDowMCAx
OTcwICswMDAwCisrKyBiL2FyY2gveDg2L2tlcm5lbC90Ym9vdC5jCVR1ZSBPY3QgMDcgMDA6MTM6
MDIgMjAwOCAtMDcwMApAQCAtMCwwICsxLDI1OCBAQAorLyoKKyAqIHRib290LmM6IG1haW4gaW1w
bGVtZW50YXRpb24gb2YgaGVscGVyIGZ1bmN0aW9ucyB1c2VkIGJ5IGtlcm5lbCBmb3IKKyAqICAg
ICAgICAgIHJ1bnRpbWUgc3VwcG9ydAorICoKKyAqIENvcHlyaWdodCAoYykgMjAwNi0yMDA4LCBJ
bnRlbCBDb3Jwb3JhdGlvbgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5
b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0CisgKiB1bmRlciB0aGUgdGVy
bXMgYW5kIGNvbmRpdGlvbnMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLAorICog
dmVyc2lvbiAyLCBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4K
KyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgaXQgd2lsbCBi
ZSB1c2VmdWwsIGJ1dCBXSVRIT1VUCisgKiBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUg
aW1wbGllZCB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkgb3IKKyAqIEZJVE5FU1MgRk9SIEEg
UEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBm
b3IKKyAqIG1vcmUgZGV0YWlscy4KKyAqCisgKiBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBj
b3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhbG9uZyB3aXRoCisgKiB0aGlz
IHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwg
SW5jLiwgCisgKiA1MSBGcmFua2xpbiBTdCAtIEZpZnRoIEZsb29yLCBCb3N0b24sIE1BIDAyMTEw
LTEzMDEgVVNBLgorICoKKyAqLworCisjaW5jbHVkZSA8bGludXgvaW5pdC5oPgorI2luY2x1ZGUg
PGxpbnV4L3NjaGVkLmg+CisjaW5jbHVkZSA8bGludXgvcGZuLmg+CisjaW5jbHVkZSA8YXNtL3Bn
dGFibGUuaD4KKyNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLmg+CisjaW5jbHVkZSA8YXNtL2Jvb3Rw
YXJhbS5oPgorI2luY2x1ZGUgPGFzbS90Ym9vdC5oPgorCisvKiBHbG9iYWwgcG9pbnRlciB0byBz
aGFyZWQgZGF0YTsgTlVMTCBtZWFucyBubyBtZWFzdXJlZCBsYXVuY2guICovCitzdHJ1Y3QgdGJv
b3Rfc2hhcmVkICp0Ym9vdF9zaGFyZWQ7CisKK3ZvaWQgX19pbml0IHRib290X3Byb2JlKHZvaWQp
Cit7CisJZXh0ZXJuIHN0cnVjdCBib290X3BhcmFtcyBib290X3BhcmFtczsKKworCS8qIExvb2sg
Zm9yIHZhbGlkIHBhZ2UtYWxpZ25lZCBhZGRyZXNzIGZvciBzaGFyZWQgcGFnZS4gKi8KKwlpZiAo
Ym9vdF9wYXJhbXMuaGRyLnRib290X3NoYXJlZF9hZGRyID09IDApCisJCXJldHVybjsKKworCS8q
IE1hcCBhbmQgY2hlY2sgZm9yIHRib290IFVVSUQuICovCisJc2V0X2ZpeG1hcChGSVhfVEJPT1Rf
U0hBUkVEX0JBU0UsIGJvb3RfcGFyYW1zLmhkci50Ym9vdF9zaGFyZWRfYWRkcik7CisJdGJvb3Rf
c2hhcmVkID0gKHN0cnVjdCB0Ym9vdF9zaGFyZWQgKikKKwkJCQlmaXhfdG9fdmlydChGSVhfVEJP
T1RfU0hBUkVEX0JBU0UpOworCWlmIChtZW1jbXAoJlRCT09UX1NIQVJFRF9VVUlELCAmdGJvb3Rf
c2hhcmVkLT51dWlkLAorCQkgICBzaXplb2Yoc3RydWN0IHRib290X3V1aWQpKSkgeworCQlwcmlu
dGsoS0VSTl9XQVJOSU5HICJ0Ym9vdF9zaGFyZWQgYXQgJWx4UC8lcFYgaXMgaW52YWxpZFxuIiwK
KwkJICAgICAgICh1bnNpZ25lZCBsb25nKWJvb3RfcGFyYW1zLmhkci50Ym9vdF9zaGFyZWRfYWRk
ciwKKwkJICAgICAgIHRib290X3NoYXJlZCk7CisJCXRib290X3NoYXJlZCA9IE5VTEw7CisJCXJl
dHVybjsKKwl9CisJaWYgKHRib290X3NoYXJlZC0+dmVyc2lvbiA8IDIpIHsKKwkJcHJpbnRrKEtF
Uk5fV0FSTklORyAidGJvb3Rfc2hhcmVkIHZlcnNpb24gaXMgaW52YWxpZDogJWRcbiIsCisJCSAg
ICAgICB0Ym9vdF9zaGFyZWQtPnZlcnNpb24pOworCQl0Ym9vdF9zaGFyZWQgPSBOVUxMOworCQly
ZXR1cm47CisJfQorCisJcHJpbnRrKEtFUk5fSU5GTyAiVEJPT1Q6IGZvdW5kIHNoYXJlZCBwYWdl
IGF0IHBoeXMgYWRkciAweCVseDpcbiIsCisJICAgICAgICh1bnNpZ25lZCBsb25nKWJvb3RfcGFy
YW1zLmhkci50Ym9vdF9zaGFyZWRfYWRkcik7CisJcHJpbnRrKEtFUk5fREVCVUcgIiAgdmVyc2lv
bjogJWRcbiIsIHRib290X3NoYXJlZC0+dmVyc2lvbik7CisJcHJpbnRrKEtFUk5fREVCVUcgIiAg
bG9nX2FkZHI6IDB4JTA4eFxuIiwgdGJvb3Rfc2hhcmVkLT5sb2dfYWRkcik7CisJcHJpbnRrKEtF
Uk5fREVCVUcgIiAgc2h1dGRvd25fZW50cnkzMjogMHglMDh4XG4iLAorCSAgICAgICB0Ym9vdF9z
aGFyZWQtPnNodXRkb3duX2VudHJ5MzIpOworCXByaW50ayhLRVJOX0RFQlVHICIgIHNodXRkb3du
X2VudHJ5NjQ6IDB4JTA4eFxuIiwKKwkgICAgICAgdGJvb3Rfc2hhcmVkLT5zaHV0ZG93bl9lbnRy
eTY0KTsKKwlwcmludGsoS0VSTl9ERUJVRyAiICBzaHV0ZG93bl90eXBlOiAlZFxuIiwgdGJvb3Rf
c2hhcmVkLT5zaHV0ZG93bl90eXBlKTsKKwlwcmludGsoS0VSTl9ERUJVRyAiICBzM190Yl93YWtl
dXBfZW50cnk6IDB4JTA4eFxuIiwKKwkgICAgICAgdGJvb3Rfc2hhcmVkLT5zM190Yl93YWtldXBf
ZW50cnkpOworCXByaW50ayhLRVJOX0RFQlVHICIgIHMzX2tfd2FrZXVwX2VudHJ5OiAweCUwOHhc
biIsCisJICAgICAgIHRib290X3NoYXJlZC0+czNfa193YWtldXBfZW50cnkpOworCXByaW50ayhL
RVJOX0RFQlVHICIgICZhY3BpX3NpbmZvOiAweCVwXG4iLCAmdGJvb3Rfc2hhcmVkLT5hY3BpX3Np
bmZvKTsKKwlwcmludGsoS0VSTl9ERUJVRyAiICB0Ym9vdF9iYXNlOiAweCUwOHhcbiIsIHRib290
X3NoYXJlZC0+dGJvb3RfYmFzZSk7CisJcHJpbnRrKEtFUk5fREVCVUcgIiAgdGJvb3Rfc2l6ZTog
MHgleFxuIiwgdGJvb3Rfc2hhcmVkLT50Ym9vdF9zaXplKTsKK30KKworc3RhdGljIHBnZF90ICp0
Ym9vdF9wZ19kaXI7CitzdGF0aWMgaW5saW5lIHZvaWQgc3dpdGNoX3RvX3Rib290X3B0KHZvaWQp
Cit7CisJbmF0aXZlX3dyaXRlX2NyMyhfX3BhKHRib290X3BnX2RpcikpOworfQorCitzdHJ1Y3Qg
dGJvb3RfcGd0X3N0cnVjdCB7CisJdW5zaWduZWQgbG9uZyBwdHI7CisJc3RydWN0IHRib290X3Bn
dF9zdHJ1Y3QgKm5leHQ7Cit9Oworc3RhdGljIHN0cnVjdCB0Ym9vdF9wZ3Rfc3RydWN0ICp0Ym9v
dF9wZ3Q7CisKKy8qIEFsbG9jYXRlIChhbmQgc2F2ZSBmb3IgbGF0ZXIgcmVsZWFzZSkgYSBwYWdl
ICovCitzdGF0aWMgdW5zaWduZWQgbG9uZyBhbGxvY190Ym9vdF9wYWdlKHZvaWQpCit7CisJdW5z
aWduZWQgbG9uZyBwdHI7CisJc3RydWN0IHRib290X3BndF9zdHJ1Y3QgKnBndDsKKworCXB0ciA9
IGdldF96ZXJvZWRfcGFnZShHRlBfQVRPTUlDKTsKKwlpZiAocHRyKSB7CisJCXBndCA9IGttYWxs
b2Moc2l6ZW9mKCpwZ3QpLCBHRlBfQVRPTUlDKTsKKwkJaWYgKCFwZ3QpIHsKKwkJCWZyZWVfcGFn
ZShwdHIpOworCQkJcmV0dXJuIDA7CisJCX0KKwkJcGd0LT5wdHIgPSBwdHI7CisJCXBndC0+bmV4
dCA9IHRib290X3BndDsKKwkJdGJvb3RfcGd0ID0gcGd0OworCX0KKwlyZXR1cm4gcHRyOworfQor
CisvKiBDbGVhbiB1cCBtZW1vcnkgdXNlZCBmb3IgdGJvb3QgbWFwcGluZyAqLwordm9pZCBjbGVh
bl91cF90Ym9vdF9tYXBwaW5nKHZvaWQpCit7CisJc3RydWN0IHRib290X3BndF9zdHJ1Y3QgKnBn
dDsKKworCWlmICghdGJvb3RfaW5fbWVhc3VyZWRfZW52KCkpCisJCXJldHVybjsKKworCXBndCA9
IHRib290X3BndDsKKwl3aGlsZSAocGd0KSB7CisJCWZyZWVfcGFnZShwZ3QtPnB0cik7CisJCXRi
b290X3BndCA9IHBndC0+bmV4dDsKKwkJa2ZyZWUocGd0KTsKKwkJcGd0ID0gdGJvb3RfcGd0Owor
CX0KK30KKworc3RhdGljIGludCBtYXBfcGFnZV9mb3JfdGJvb3QodW5zaWduZWQgbG9uZyB2YWRk
ciwgdW5zaWduZWQgbG9uZyBwZm4sCisJCQkJcGdwcm90X3QgcHJvdCkKK3sKKwlwZ2RfdCAqcGdk
OworCXB1ZF90ICpwdWQ7CisJcG1kX3QgKnBtZDsKKwlwdGVfdCAqcHRlLCBuZXdfcHRlOworCisJ
cGdkID0gdGJvb3RfcGdfZGlyICsgcGdkX2luZGV4KHZhZGRyKTsKKyNpZmRlZiBfX3g4Nl82NF9f
CisJaWYgKCFwZ2RfdmFsKCpwZ2QpKSB7CisJCXB1ZCA9IChwdWRfdCAqKWFsbG9jX3Rib290X3Bh
Z2UoKTsKKwkJaWYgKCFwdWQpCisJCQlyZXR1cm4gLTE7CisJCXNldF9wZ2QocGdkLCBfX3BnZChf
X3BhKHB1ZCkgfCBfS0VSTlBHX1RBQkxFKSk7CisJfQorCXB1ZCA9IHB1ZF9vZmZzZXQocGdkLCB2
YWRkcik7CisJaWYgKCFwdWRfdmFsKCpwdWQpKSB7CisJCXBtZCA9IChwbWRfdCAqKWFsbG9jX3Ri
b290X3BhZ2UoKTsKKwkJaWYgKCFwbWQpCisJCQlyZXR1cm4gLTE7CisJCXNldF9wdWQocHVkLCBf
X3B1ZChfX3BhKHBtZCkgfCBfS0VSTlBHX1RBQkxFKSk7CisJfQorCXBtZCA9IHBtZF9vZmZzZXQo
cHVkLCB2YWRkcik7CisjZWxzZQorI2lmZGVmIENPTkZJR19YODZfUEFFCisJaWYgKCFwZ2RfdmFs
KCpwZ2QpKSB7CisJCXBtZCA9IChwbWRfdCAqKWFsbG9jX3Rib290X3BhZ2UoKTsKKwkJaWYgKCFw
bWQpCisJCQlyZXR1cm4gLTE7CisJCXNldF9wZ2QocGdkLCBfX3BnZChfX3BhKHBtZCkgfCBfUEFH
RV9QUkVTRU5UKSk7CisJCXB1ZCA9IHB1ZF9vZmZzZXQocGdkLCAwKTsKKwl9CisJcHVkID0gcHVk
X29mZnNldChwZ2QsIDApOworCXBtZCA9IHBtZF9vZmZzZXQocHVkLCB2YWRkcik7CisjZWxzZQor
CXB1ZCA9IHB1ZF9vZmZzZXQocGdkLCAwKTsKKwlwbWQgPSBwbWRfb2Zmc2V0KHB1ZCwgMCk7Cisj
ZW5kaWYKKyNlbmRpZgorCWlmICghcG1kX3ZhbCgqcG1kKSkgeworCQlwdGUgPSAocHRlX3QgKilh
bGxvY190Ym9vdF9wYWdlKCk7CisJCWlmICghcHRlKQorCQkJcmV0dXJuIC0xOworCQlzZXRfcG1k
KHBtZCwgX19wbWQoX19wYShwdGUpIHwgX0tFUk5QR19UQUJMRSkpOworCX0KKwluZXdfcHRlID0g
cGZuX3B0ZShwZm4sIHByb3QpOworCisJcHRlID0gcHRlX29mZnNldF9rZXJuZWwocG1kLCB2YWRk
cik7CisKKwlpZiAocHRlX3ZhbCgqcHRlKSAmJgorI2lmIGRlZmluZWQoQ09ORklHX1g4Nl9QQUUp
IHx8IGRlZmluZWQoX194ODZfNjRfXykKKwkgICAgcHRlX3ZhbCgqcHRlKSAhPSAocHRlX3ZhbChu
ZXdfcHRlKSAmIF9fc3VwcG9ydGVkX3B0ZV9tYXNrKQorI2Vsc2UKKwkgICAgcHRlX3ZhbCgqcHRl
KSAhPSBwdGVfdmFsKG5ld19wdGUpCisjZW5kaWYKKwkgICApIHsKKwkJcHRlX0VSUk9SKCpwdGUp
OworCQlyZXR1cm4gLTE7CisJfQorCisJc2V0X3B0ZShwdGUsIG5ld19wdGUpOworCisJcmV0dXJu
IDA7Cit9CisKK3N0YXRpYyBpbnQgbWFwX3BhZ2VzX2Zvcl90Ym9vdCh1bnNpZ25lZCBsb25nIHZh
ZGRyLCB1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwKKwkJCQl1bnNpZ25lZCBsb25nIG5yKQorewor
CXByaW50ayhLRVJOX0RFQlVHICJtYXBfcGFnZXNfZm9yX3Rib290ICVseCB0byAlbHggKCVseClc
biIsCisJCXZhZGRyLCBzdGFydF9wZm4gPDwgUEFHRV9TSElGVCwgbnIgPDwgUEFHRV9TSElGVCk7
CisKKwkvKiBSZXVzZSB0aGUgb3JpZ2luYWwga2VybmVsIG1hcHBpbmcgKi8KKwl0Ym9vdF9wZ19k
aXIgPSAocGdkX3QgKilhbGxvY190Ym9vdF9wYWdlKCk7CisJaWYgKCF0Ym9vdF9wZ19kaXIpCisJ
CXJldHVybiAtMTsKKworI2lmZGVmIF9feDg2XzY0X18KKwlzZXRfcGdkKHRib290X3BnX2RpciAr
IHBnZF9pbmRleChfX1NUQVJUX0tFUk5FTF9tYXApLAorCQlzd2FwcGVyX3BnX2RpcltwZ2RfaW5k
ZXgoX19TVEFSVF9LRVJORUxfbWFwKV0pOworI2Vsc2UKKwltZW1jcHkodGJvb3RfcGdfZGlyICsg
S0VSTkVMX1BHRF9CT1VOREFSWSwKKwkJc3dhcHBlcl9wZ19kaXIgKyBLRVJORUxfUEdEX0JPVU5E
QVJZLAorCQlzaXplb2Yoc3dhcHBlcl9wZ19kaXJbMF0pICogS0VSTkVMX1BHRF9QVFJTKTsKKyNl
bmRpZgorCisJZm9yICg7IG5yID4gMDsgbnItLSwgdmFkZHIgKz0gUEFHRV9TSVpFLCBzdGFydF9w
Zm4rKykgeworCQlpZiAobWFwX3BhZ2VfZm9yX3Rib290KHZhZGRyLCBzdGFydF9wZm4sCisJCQkJ
ICAgICAgIF9fcGdwcm90KF9fUEFHRV9LRVJORUxfRVhFQykpKQorCQkJcmV0dXJuIC0xOworCX0K
KworCXJldHVybiAwOworfQorCit2b2lkIHRib290X3NodXRkb3duKHUzMiBzaHV0ZG93bl90eXBl
KQoreworCXUzMiBtYXBfYmFzZSwgbWFwX3NpemU7CisKKwlpZiAoIXRib290X2luX21lYXN1cmVk
X2VudigpKQorCQlyZXR1cm47CisKKwl0Ym9vdF9zaGFyZWQtPnNodXRkb3duX3R5cGUgPSBzaHV0
ZG93bl90eXBlOworCisJbG9jYWxfaXJxX2Rpc2FibGUoKTsKKworCS8qIENyZWF0ZSBpZGVudGl0
eSBtYXAgZm9yIHRib290IHNodXRkb3duIGNvZGUuICovCisJaWYgKHRib290X3NoYXJlZC0+dmVy
c2lvbiA+PSAweDAyKSB7CisJCW1hcF9iYXNlID0gUEZOX0RPV04odGJvb3Rfc2hhcmVkLT50Ym9v
dF9iYXNlKTsKKwkJbWFwX3NpemUgPSBQRk5fVVAodGJvb3Rfc2hhcmVkLT50Ym9vdF9zaXplKTsK
Kwl9IGVsc2UgeworCQltYXBfYmFzZSA9IDA7CisJCW1hcF9zaXplID0gUEZOX1VQKDB4YTAwMDAp
OworCX0KKworCWlmIChtYXBfcGFnZXNfZm9yX3Rib290KG1hcF9iYXNlIDw8IFBBR0VfU0hJRlQs
IG1hcF9iYXNlLCBtYXBfc2l6ZSkpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgImVycm9yIG1hcHBp
bmcgdGJvb3QgcGFnZXMgIgorCQkJCSAgIihtZm5zKSBAIDB4JXgsIDB4JXhcbiIsIG1hcF9iYXNl
LCBtYXBfc2l6ZSk7CisJCWNsZWFuX3VwX3Rib290X21hcHBpbmcoKTsKKwkJcmV0dXJuOworCX0K
KworCXN3aXRjaF90b190Ym9vdF9wdCgpOworCisjaWZkZWYgX194ODZfNjRfXworCWFzbSB2b2xh
dGlsZSAoImptcCAqJSVyZGkiIDogOiAiRCIgKHRib290X3NoYXJlZC0+c2h1dGRvd25fZW50cnk2
NCkpOworI2Vsc2UKKwlhc20gdm9sYXRpbGUgKCJqbXAgKiUlZWRpIiA6IDogIkQiICh0Ym9vdF9z
aGFyZWQtPnNodXRkb3duX2VudHJ5MzIpKTsKKyNlbmRpZgorCisJQlVHKCk7IC8qIHNob3VsZCBu
b3QgcmVhY2ggaGVyZSAqLworfQpkaWZmIC1yIDI5Y2ZkYzUyYTA3NiBhcmNoL3g4Ni9wb3dlci9j
cHVfMzIuYwotLS0gYS9hcmNoL3g4Ni9wb3dlci9jcHVfMzIuYwlNb24gT2N0IDA2IDEyOjUwOjQ3
IDIwMDggLTA3MDAKKysrIGIvYXJjaC94ODYvcG93ZXIvY3B1XzMyLmMJVHVlIE9jdCAwNyAwMDox
MzowMiAyMDA4IC0wNzAwCkBAIC0xMSw2ICsxMSw3IEBACiAjaW5jbHVkZSA8bGludXgvc3VzcGVu
ZC5oPgogI2luY2x1ZGUgPGFzbS9tdHJyLmg+CiAjaW5jbHVkZSA8YXNtL21jZS5oPgorI2luY2x1
ZGUgPGFzbS90Ym9vdC5oPgogCiBzdGF0aWMgc3RydWN0IHNhdmVkX2NvbnRleHQgc2F2ZWRfY29u
dGV4dDsKIApAQCAtMTM2LDUgKzEzNyw4IEBAIHZvaWQgcmVzdG9yZV9wcm9jZXNzb3Jfc3RhdGUo
dm9pZCkKIHZvaWQgcmVzdG9yZV9wcm9jZXNzb3Jfc3RhdGUodm9pZCkKIHsKIAlfX3Jlc3RvcmVf
cHJvY2Vzc29yX3N0YXRlKCZzYXZlZF9jb250ZXh0KTsKKworCS8qIENsZWFuIHVwIG1lbW9yeSBt
YXBwaW5nIGZvciB0Ym9vdCByYW5nZSAqLworCWNsZWFuX3VwX3Rib290X21hcHBpbmcoKTsKIH0K
IEVYUE9SVF9TWU1CT0wocmVzdG9yZV9wcm9jZXNzb3Jfc3RhdGUpOwpkaWZmIC1yIDI5Y2ZkYzUy
YTA3NiBhcmNoL3g4Ni9wb3dlci9jcHVfNjQuYwotLS0gYS9hcmNoL3g4Ni9wb3dlci9jcHVfNjQu
YwlNb24gT2N0IDA2IDEyOjUwOjQ3IDIwMDggLTA3MDAKKysrIGIvYXJjaC94ODYvcG93ZXIvY3B1
XzY0LmMJVHVlIE9jdCAwNyAwMDoxMzowMiAyMDA4IC0wNzAwCkBAIC0xNCw2ICsxNCw3IEBACiAj
aW5jbHVkZSA8YXNtL3BhZ2UuaD4KICNpbmNsdWRlIDxhc20vcGd0YWJsZS5oPgogI2luY2x1ZGUg
PGFzbS9tdHJyLmg+CisjaW5jbHVkZSA8YXNtL3Rib290Lmg+CiAKIHN0YXRpYyB2b2lkIGZpeF9w
cm9jZXNzb3JfY29udGV4dCh2b2lkKTsKIApAQCAtMTMxLDYgKzEzMiw5IEBAIHZvaWQgcmVzdG9y
ZV9wcm9jZXNzb3Jfc3RhdGUodm9pZCkKIHZvaWQgcmVzdG9yZV9wcm9jZXNzb3Jfc3RhdGUodm9p
ZCkKIHsKIAlfX3Jlc3RvcmVfcHJvY2Vzc29yX3N0YXRlKCZzYXZlZF9jb250ZXh0KTsKKworCS8q
IENsZWFuIHVwIG1lbW9yeSBtYXBwaW5nIGZvciB0Ym9vdCByYW5nZSAqLworCWNsZWFuX3VwX3Ri
b290X21hcHBpbmcoKTsKIH0KIAogc3RhdGljIHZvaWQgZml4X3Byb2Nlc3Nvcl9jb250ZXh0KHZv
aWQpCmRpZmYgLXIgMjljZmRjNTJhMDc2IGRyaXZlcnMvYWNwaS9oYXJkd2FyZS9od3NsZWVwLmMK
LS0tIGEvZHJpdmVycy9hY3BpL2hhcmR3YXJlL2h3c2xlZXAuYwlNb24gT2N0IDA2IDEyOjUwOjQ3
IDIwMDggLTA3MDAKKysrIGIvZHJpdmVycy9hY3BpL2hhcmR3YXJlL2h3c2xlZXAuYwlUdWUgT2N0
IDA3IDAwOjEzOjAyIDIwMDggLTA3MDAKQEAgLTQ0LDYgKzQ0LDcgQEAKIAogI2luY2x1ZGUgPGFj
cGkvYWNwaS5oPgogI2luY2x1ZGUgPGFjcGkvYWN0YWJsZXMuaD4KKyNpbmNsdWRlIDxhc20vdGJv
b3QuaD4KIAogI2RlZmluZSBfQ09NUE9ORU5UICAgICAgICAgIEFDUElfSEFSRFdBUkUKIEFDUElf
TU9EVUxFX05BTUUoImh3c2xlZXAiKQpAQCAtNzcsNiArNzgsMTMgQEAgYWNwaV9zZXRfZmlybXdh
cmVfd2FraW5nX3ZlY3RvcihhY3BpX3BoeQogCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkgewog
CQlyZXR1cm5fQUNQSV9TVEFUVVMoc3RhdHVzKTsKIAl9CisKKyNpZmRlZiBDT05GSUdfVFhUCisJ
aWYgKHRib290X2luX21lYXN1cmVkX2VudigpKSB7CisJCXRib290X3NoYXJlZC0+czNfa193YWtl
dXBfZW50cnkgPSAodWludDMyX3QpcGh5c2ljYWxfYWRkcmVzczsKKwkJcGh5c2ljYWxfYWRkcmVz
cyA9IHRib290X3NoYXJlZC0+czNfdGJfd2FrZXVwX2VudHJ5OworCX0KKyNlbmRpZgogCiAJLyog
U2V0IHRoZSB2ZWN0b3IgKi8KIApAQCAtMjM4LDYgKzI0NiwyOSBAQCBhY3BpX3N0YXR1cyBhY3Bp
X2VudGVyX3NsZWVwX3N0YXRlX3ByZXAoCiAKIEFDUElfRVhQT1JUX1NZTUJPTChhY3BpX2VudGVy
X3NsZWVwX3N0YXRlX3ByZXApCiAKKyNpZmRlZiBDT05GSUdfVFhUCitzdGF0aWMgdm9pZCB0Ym9v
dF9zbGVlcCh1OCBzbGVlcF9zdGF0ZSkKK3sKKwl1aW50MzJfdCBzaHV0ZG93bl90eXBlOworCisJ
c3dpdGNoIChzbGVlcF9zdGF0ZSkgeworCWNhc2UgQUNQSV9TVEFURV9TMzoKKwkJc2h1dGRvd25f
dHlwZSA9IFRCX1NIVVRET1dOX1MzOworCQlicmVhazsKKwljYXNlIEFDUElfU1RBVEVfUzQ6CisJ
CXNodXRkb3duX3R5cGUgPSBUQl9TSFVURE9XTl9TNDsKKwkJYnJlYWs7CisJY2FzZSBBQ1BJX1NU
QVRFX1M1OgorCQlzaHV0ZG93bl90eXBlID0gVEJfU0hVVERPV05fUzU7CisJCWJyZWFrOworCWRl
ZmF1bHQ6CisJCXJldHVybjsKKwl9CisKKwl0Ym9vdF9zaHV0ZG93bihzaHV0ZG93bl90eXBlKTsK
K30KKyNlbmRpZgorCiAvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogICoKICAqIEZVTkNUSU9OOiAg
ICBhY3BpX2VudGVyX3NsZWVwX3N0YXRlCkBAIC0zNjEsNiArMzkyLDIwIEBAIGFjcGlfc3RhdHVz
IGFzbWxpbmthZ2UgYWNwaV9lbnRlcl9zbGVlcF8KIAogCVBNMUFjb250cm9sIHw9IHNsZWVwX2Vu
YWJsZV9yZWdfaW5mby0+YWNjZXNzX2JpdF9tYXNrOwogCVBNMUJjb250cm9sIHw9IHNsZWVwX2Vu
YWJsZV9yZWdfaW5mby0+YWNjZXNzX2JpdF9tYXNrOworCisjaWZkZWYgQ09ORklHX1RYVAorCWlm
ICh0Ym9vdF9pbl9tZWFzdXJlZF9lbnYoKSkgeworCQl0Ym9vdF9zaGFyZWQtPmFjcGlfc2luZm8u
cG0xYV9jbnQgPQorCQkJKHVpbnQxNl90KWFjcGlfZ2JsX0ZBRFQueHBtMWFfY29udHJvbF9ibG9j
ay5hZGRyZXNzOworCQl0Ym9vdF9zaGFyZWQtPmFjcGlfc2luZm8ucG0xYl9jbnQgPQorCQkJKHVp
bnQxNl90KWFjcGlfZ2JsX0ZBRFQueHBtMWJfY29udHJvbF9ibG9jay5hZGRyZXNzOworCQl0Ym9v
dF9zaGFyZWQtPmFjcGlfc2luZm8ucG0xYV9jbnRfdmFsID0gUE0xQWNvbnRyb2w7CisJCXRib290
X3NoYXJlZC0+YWNwaV9zaW5mby5wbTFiX2NudF92YWwgPSBQTTFCY29udHJvbDsKKwkJdGJvb3Rf
c2xlZXAoc2xlZXBfc3RhdGUpOworCQlwcmludGsoS0VSTl9ERUJVRyAiVEJPT1QgZmFpbGVkIGVu
dGVyaW5nIHMzIHN0YXRlXG4iKTsKKwkJcmV0dXJuX0FDUElfU1RBVFVTKEFFX0VSUk9SKTsKKwl9
CisjZW5kaWYKIAogCS8qIFdyaXRlICMyOiBTTFBfVFlQICsgU0xQX0VOICovCiAKZGlmZiAtciAy
OWNmZGM1MmEwNzYgaW5jbHVkZS9hc20teDg2L2Jvb3RwYXJhbS5oCi0tLSBhL2luY2x1ZGUvYXNt
LXg4Ni9ib290cGFyYW0uaAlNb24gT2N0IDA2IDEyOjUwOjQ3IDIwMDggLTA3MDAKKysrIGIvaW5j
bHVkZS9hc20teDg2L2Jvb3RwYXJhbS5oCVR1ZSBPY3QgMDcgMDA6MTM6MDIgMjAwOCAtMDcwMApA
QCAtNjIsNiArNjIsNyBAQCBzdHJ1Y3Qgc2V0dXBfaGVhZGVyIHsKIAlfX3UzMglwYXlsb2FkX29m
ZnNldDsKIAlfX3UzMglwYXlsb2FkX2xlbmd0aDsKIAlfX3U2NAlzZXR1cF9kYXRhOworCV9fdTMy
ICAgdGJvb3Rfc2hhcmVkX2FkZHI7CiB9IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpOwogCiBzdHJ1
Y3Qgc3lzX2Rlc2NfdGFibGUgewpkaWZmIC1yIDI5Y2ZkYzUyYTA3NiBpbmNsdWRlL2FzbS14ODYv
Zml4bWFwXzMyLmgKLS0tIGEvaW5jbHVkZS9hc20teDg2L2ZpeG1hcF8zMi5oCU1vbiBPY3QgMDYg
MTI6NTA6NDcgMjAwOCAtMDcwMAorKysgYi9pbmNsdWRlL2FzbS14ODYvZml4bWFwXzMyLmgJVHVl
IE9jdCAwNyAwMDoxMzowMiAyMDA4IC0wNzAwCkBAIC04NSw2ICs4NSw5IEBAIGVudW0gZml4ZWRf
YWRkcmVzc2VzIHsKICNpZmRlZiBDT05GSUdfUEFSQVZJUlQKIAlGSVhfUEFSQVZJUlRfQk9PVE1B
UCwKICNlbmRpZgorI2lmZGVmIENPTkZJR19UWFQKKwlGSVhfVEJPT1RfU0hBUkVEX0JBU0UsCisj
ZW5kaWYKIAlfX2VuZF9vZl9wZXJtYW5lbnRfZml4ZWRfYWRkcmVzc2VzLAogCS8qCiAJICogMjU2
IHRlbXBvcmFyeSBib290LXRpbWUgbWFwcGluZ3MsIHVzZWQgYnkgZWFybHlfaW9yZW1hcCgpLApk
aWZmIC1yIDI5Y2ZkYzUyYTA3NiBpbmNsdWRlL2FzbS14ODYvZml4bWFwXzY0LmgKLS0tIGEvaW5j
bHVkZS9hc20teDg2L2ZpeG1hcF82NC5oCU1vbiBPY3QgMDYgMTI6NTA6NDcgMjAwOCAtMDcwMAor
KysgYi9pbmNsdWRlL2FzbS14ODYvZml4bWFwXzY0LmgJVHVlIE9jdCAwNyAwMDoxMzowMiAyMDA4
IC0wNzAwCkBAIC01Niw2ICs1Niw5IEBAIGVudW0gZml4ZWRfYWRkcmVzc2VzIHsKICNpZmRlZiBD
T05GSUdfUFJPVklERV9PSENJMTM5NF9ETUFfSU5JVAogCUZJWF9PSENJMTM5NF9CQVNFLAogI2Vu
ZGlmCisjaWZkZWYgQ09ORklHX1RYVAorCUZJWF9UQk9PVF9TSEFSRURfQkFTRSwKKyNlbmRpZgog
CV9fZW5kX29mX3Blcm1hbmVudF9maXhlZF9hZGRyZXNzZXMsCiAJLyoKIAkgKiAyNTYgdGVtcG9y
YXJ5IGJvb3QtdGltZSBtYXBwaW5ncywgdXNlZCBieSBlYXJseV9pb3JlbWFwKCksCmRpZmYgLXIg
MjljZmRjNTJhMDc2IGluY2x1ZGUvYXNtLXg4Ni90Ym9vdC5oCi0tLSAvZGV2L251bGwJVGh1IEph
biAwMSAwMDowMDowMCAxOTcwICswMDAwCisrKyBiL2luY2x1ZGUvYXNtLXg4Ni90Ym9vdC5oCVR1
ZSBPY3QgMDcgMDA6MTM6MDIgMjAwOCAtMDcwMApAQCAtMCwwICsxLDEwMSBAQAorLyoKKyAqIHRi
b290Lmg6IHNoYXJlZCBkYXRhIHN0cnVjdHVyZSB3aXRoIE1MRSBhbmQga2VybmVsIGFuZCBmdW5j
dGlvbnMKKyAqICAgICAgICAgIHVzZWQgYnkga2VybmVsIGZvciBydW50aW1lIHN1cHBvcnQKKyAq
CisgKiBDb3B5cmlnaHQgKGMpIDIwMDYtMjAwOCwgSW50ZWwgQ29ycG9yYXRpb24KKyAqCisgKiBU
aGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5k
L29yIG1vZGlmeSBpdAorICogdW5kZXIgdGhlIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSwKKyAqIHZlcnNpb24gMiwgYXMgcHVibGlzaGVkIGJ5
IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGRp
c3RyaWJ1dGVkIGluIHRoZSBob3BlIGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9VVAorICog
QU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hB
TlRBQklMSVRZIG9yCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0
aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yCisgKiBtb3JlIGRldGFpbHMuCisgKgor
ICogWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgYWxvbmcgd2l0aAorICogdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRv
IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4sIAorICogNTEgRnJhbmtsaW4gU3Qg
LSBGaWZ0aCBGbG9vciwgQm9zdG9uLCBNQSAwMjExMC0xMzAxIFVTQS4KKyAqCisgKi8KKworI2lm
bmRlZiBfQVNNX1RCT09UX0gKKyNkZWZpbmUgX0FTTV9UQk9PVF9ICisKKyNkZWZpbmUgVEJfU0hV
VERPV05fUkVCT09UICAgICAgMAorI2RlZmluZSBUQl9TSFVURE9XTl9TNSAgICAgICAgICAxCisj
ZGVmaW5lIFRCX1NIVVRET1dOX1M0ICAgICAgICAgIDIKKyNkZWZpbmUgVEJfU0hVVERPV05fUzMg
ICAgICAgICAgMworI2RlZmluZSBUQl9TSFVURE9XTl9IQUxUICAgICAgICA0CisKKyNpZmRlZiBD
T05GSUdfVFhUCitzdHJ1Y3QgdGJvb3RfdXVpZCB7CisJdTMyICAgIGRhdGExOworCXUxNiAgICBk
YXRhMjsKKwl1MTYgICAgZGF0YTM7CisJdTE2ICAgIGRhdGE0OworCXU4ICAgICBkYXRhNVs2XTsK
K30gX19hdHRyaWJ1dGVfXyAoKF9fcGFja2VkX18pKTsKKworLyogdXNlZCB0byBjb21tdW5pY2F0
ZSBiZXR3ZWVuIHRib290IGFuZCB0aGUgbGF1bmNoZWQga2VybmVsICovCisKK3N0cnVjdCB0Ym9v
dF9hY3BpX3NsZWVwX2luZm8geworCXUxNiBwbTFhX2NudDsKKwl1MTYgcG0xYl9jbnQ7CisJdTE2
IHBtMWFfZXZ0OworCXUxNiBwbTFiX2V2dDsKKwl1MTYgcG0xYV9jbnRfdmFsOworCXUxNiBwbTFi
X2NudF92YWw7Cit9ICBfX2F0dHJpYnV0ZV9fICgoX19wYWNrZWRfXykpOworCitzdHJ1Y3QgdGJv
b3Rfc2hhcmVkIHsKKwkvKiB2ZXJzaW9uIDB4MDErIGZpZWxkczogKi8KKwlzdHJ1Y3QgdGJvb3Rf
dXVpZCB1dWlkOyAvKiBUQk9PVF9TSEFSRURfVVVJRCAqLworCXUzMiAgdmVyc2lvbjsgICAgICAJ
LyogVmVyc2lvbiBudW1iZXI6IDIgaXMgY3VycmVudCAqLworCXUzMiAgbG9nX2FkZHI7ICAgICAJ
LyogcGh5c2ljYWwgYWRkciBvZiB0Yl9sb2dfdCBsb2cgKi8KKwl1MzIgIHNodXRkb3duX2VudHJ5
MzI7CS8qIGVudHJ5IHBvaW50IGZvciB0Ym9vdCBzaHV0ZG93biBmcm9tIDMyYiAqLworCXUzMiAg
c2h1dGRvd25fZW50cnk2NDsJLyogZW50cnkgcG9pbnQgZm9yIHRib290IHNodXRkb3duIGZyb20g
NjRiICovCisJdTMyICBzaHV0ZG93bl90eXBlOwkvKiB0eXBlIG9mIHNodXRkb3duIChUQl9TSFVU
RE9XTl8qKSAqLworCXUzMiAgczNfdGJfd2FrZXVwX2VudHJ5Oy8qIGVudHJ5IHBvaW50IGZvciB0
Ym9vdCBzMyB3YWtlIHVwICovCisJdTMyICBzM19rX3dha2V1cF9lbnRyeTsJLyogZW50cnkgcG9p
bnQgZm9yIGtlcm5lbCBzMyB3YWtlIHVwICovCisJc3RydWN0IHRib290X2FjcGlfc2xlZXBfaW5m
bworCQkgIGFjcGlfc2luZm87CS8qIHdoZXJlIGtlcm5lbCBwdXQgYWNwaSBzbGVlcCBpbmZvIGlu
IFN4ICovCisJdTggICByZXNlcnZlZFs1Ml07CS8qIHRoaXMgcGFkIGlzIGZvciBjb21wYXQgd2l0
aCBvbGQgZmllbGQgKi8KKwkvKiB2ZXJzaW9uIDB4MDIrIGZpZWxkczogKi8KKwl1MzIgIHRib290
X2Jhc2U7CS8qIHN0YXJ0aW5nIGFkZHIgZm9yIHRib290ICovCisJdTMyICB0Ym9vdF9zaXplOwkv
KiBzaXplIG9mIHRib290ICovCit9IF9fYXR0cmlidXRlX18gKChfX3BhY2tlZF9fKSk7CisKKy8q
IHs2NjNDOERGRi1FOEIzLTRiODItQUFCRi0xOUVBNEQwNTdBMDh9ICovCisjZGVmaW5lIFRCT09U
X1NIQVJFRF9VVUlEICAgICBcCisJCSgoc3RydWN0IHRib290X3V1aWQpeyAweDY2M2M4ZGZmLCAw
eGU4YjMsIDB4NGI4MiwgMHhhYWJmLCAgIFwKKwkJCQl7IDB4MTksIDB4ZWEsIDB4NGQsIDB4NSwg
MHg3YSwgMHg4IH0gfSkKKworZXh0ZXJuIHN0cnVjdCB0Ym9vdF9zaGFyZWQgKnRib290X3NoYXJl
ZDsKKworc3RhdGljIGlubGluZSBpbnQgdGJvb3RfaW5fbWVhc3VyZWRfZW52KHZvaWQpCit7CisJ
cmV0dXJuIHRib290X3NoYXJlZCAhPSBOVUxMOworfQorCitleHRlcm4gdm9pZCBjbGVhbl91cF90
Ym9vdF9tYXBwaW5nKHZvaWQpOworZXh0ZXJuIHZvaWQgdGJvb3RfcHJvYmUodm9pZCk7CitleHRl
cm4gdm9pZCB0Ym9vdF9zaHV0ZG93bih1MzIgc2h1dGRvd25fdHlwZSk7CisKKyNlbHNlICAgICAv
KiBDT05GSUdfVFhUICovCisKK3N0YXRpYyBpbmxpbmUgdm9pZCBjbGVhbl91cF90Ym9vdF9tYXBw
aW5nKHZvaWQpCit7Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCB0Ym9vdF9wcm9iZSh2b2lkKQor
eworfQorCitzdGF0aWMgaW5saW5lIHZvaWQgdGJvb3Rfc2h1dGRvd24odTMyIHNodXRkb3duX3R5
cGUpCit7Cit9CisKKyNlbmRpZiAvKiAhQ09ORklHX1RYVCAqLworCisjZW5kaWYgLyogX0FTTV9U
Qk9PVF9IICovCmRpZmYgLXIgMjljZmRjNTJhMDc2IHNlY3VyaXR5L0tjb25maWcKLS0tIGEvc2Vj
dXJpdHkvS2NvbmZpZwlNb24gT2N0IDA2IDEyOjUwOjQ3IDIwMDggLTA3MDAKKysrIGIvc2VjdXJp
dHkvS2NvbmZpZwlUdWUgT2N0IDA3IDAwOjEzOjAyIDIwMDggLTA3MDAKQEAgLTExNSw2ICsxMTUs
MjMgQEAgY29uZmlnIFNFQ1VSSVRZX0RFRkFVTFRfTU1BUF9NSU5fQUREUgogCSAgL3Byb2Mvc3lz
L3ZtL21tYXBfbWluX2FkZHIgdHVuYWJsZS4KIAogCitjb25maWcgVFhUCisgICAgICAgIGJvb2wg
IkVuYWJsZSBJbnRlbChSKSBUcnVzdGVkIEV4ZWN1dGlvbiBUZWNobm9sb2d5IChUWFQpIgorICAg
ICAgICBkZXBlbmRzIG9uIEVYUEVSSU1FTlRBTCAmJiBYODYKKyAgICAgICAgaGVscAorICAgICAg
ICAgIFRoaXMgb3B0aW9uIGVuYWJsZXMgc3VwcG9ydCBmb3IgYm9vdGluZyB0aGUga2VybmVsIHdp
dGgKKyAgICAgICAgICB0aGUgVHJ1c3RlZCBCb290ICh0Ym9vdCkgbW9kdWxlLiBUaGlzIHdpbGwg
dXRpbGl6ZQorICAgICAgICAgIEludGVsKFIpIFRydXN0ZWQgRXhlY3V0aW9uIFRlY2hub2xvZ3kg
KFRYVCkgdG8gcGVyZm9ybSBhCisgICAgICAgICAgbWVhc3VyZWQgbGF1bmNoIG9mIHRoZSBrZXJu
ZWwuIElmIHRoZSBzeXN0ZW0gZG9lcyBub3QKKyAgICAgICAgICBzdXBwb3J0IFRYVCwgdGhpcyB3
aWxsIGhhdmUgbm8gZWZmZWN0LgorCisgICAgICAgICAgU2VlIDxodHRwOi8vd3d3LmludGVsLmNv
bS90ZWNobm9sb2d5L3NlY3VyaXR5Lz4gZm9yIG1vcmUKKyAgICAgICAgICBpbmZvcm1hdGlvbiBh
Ym91dCBJbnRlbChSKSBUWFQuCisgICAgICAgICAgQW5kIHNlZSA8aHR0cDovL3Rib290LnNvdXJj
ZWZvcmdlLm5ldD4gZm9yIG1vcmUgaW5mb3JtYXRpb24KKyAgICAgICAgICBhYm91dCB0Ym9vdC4K
KworICAgICAgICAgIElmIHlvdSBhcmUgdW5zdXJlIGFzIHRvIHdoZXRoZXIgdGhpcyBpcyByZXF1
aXJlZCwgYW5zd2VyIE4uCisKIHNvdXJjZSBzZWN1cml0eS9zZWxpbnV4L0tjb25maWcKIHNvdXJj
ZSBzZWN1cml0eS9zbWFjay9LY29uZmlnCiAK

------_=_NextPart_001_01C928C0.FCEFA6ED--
