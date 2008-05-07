Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbYEGHtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbYEGHtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762298AbYEGHsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:48:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:44572 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbYEGHsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=IGLuw/keFU6Ah4EpY854X8l9cj/QZgRR73r/Sk7SZdeGEzQn+mGiKqowRq1pfhLHOcE8GA/Ql+7VhJ7X8iY4bmoRFD/21s3aXTwaFKaGbrEoi0p34+EidnZXLugU+7oiOymjuoXR7kBvdqUbLyirgChbrQuvSU30i6b0Q/rlYL0=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: update mptable v2
Date: Wed, 7 May 2008 00:48:46 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805061038.58023.yhlu.kernel@gmail.com>
In-Reply-To: <200805061038.58023.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070048.46957.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make mptable to be consistent to acpi routing, so we could
1. kexec kernel with acpi=off
2. workaround BIOS that acpi routing is working, but mptable is not right.
   so can use kernel/kexec to start other os that doesn't have good acpi support

command line: update_mptable

v2: add alloc_mptable for mptable that can not be changed.
    new command line: alloc_mptable

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -301,6 +301,35 @@ unsigned long __init find_e820_area_size
 	return -1UL;
 
 }
+
+/*
+ * pre allocated 4k and reserved it in e820
+ */
+unsigned long __init early_reserve_e820(unsigned long sizet,
+					unsigned long align)
+{
+	unsigned long start = 0, size = 0;
+	unsigned long addr;
+
+#ifdef CONFIG_X86_TRAMPOLINE
+	start = TRAMPOLINE_BASE;
+#endif
+	while (size < sizet)
+		start = find_e820_area_size(start, &size, align);
+
+	if (size < sizet)
+		return 0;
+
+	addr = start + size - sizet;
+
+	update_memory_range(addr, sizet, E820_RAM, E820_RESERVED);
+
+	printk(KERN_INFO "update e820 for early_reserve_e820\n");
+	update_e820();
+
+	return addr;
+}
+
 /*
  * Find the highest page frame number we have available
  */
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -25,6 +25,7 @@
 #include <asm/proto.h>
 #include <asm/acpi.h>
 #include <asm/bios_ebda.h>
+#include <asm/e820.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
@@ -180,14 +181,26 @@ static void __init MP_ioapic_info(struct
 	nr_ioapics++;
 }
 
-static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
+static void __init print_MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	mp_irqs[mp_irq_entries] = *m;
 	printk(KERN_INFO "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
 		m->mpc_srcbusirq, m->mpc_dstapic, m->mpc_dstirq);
+}
+
+static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
+{
+	int i;
+
+	print_MP_intsrc_info(m);
+
+	for (i = 0; i < mp_irq_entries; i++)
+		if (!memcmp(m, &mp_irqs[i], sizeof(*m)))
+			return;
+
+	mp_irqs[mp_irq_entries] = *m;
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
 }
@@ -281,12 +294,9 @@ static inline void mps_oem_check(struct 
  * Read/parse the MPC
  */
 
-static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
+static int __init smp_check_mpc(struct mp_config_table *mpc, char *oem,
+				char *str)
 {
-	char str[16];
-	char oem[10];
-	int count = sizeof(*mpc);
-	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
 	if (memcmp(mpc->mpc_signature, MPC_SIGNATURE, 4)) {
 		printk(KERN_ERR "MPTABLE: bad signature [%c%c%c%c]!\n",
@@ -314,13 +324,28 @@ static int __init smp_read_mpc(struct mp
 	memcpy(str, mpc->mpc_productid, 12);
 	str[12] = 0;
 
-#ifdef CONFIG_X86_32
-	mps_oem_check(mpc, oem, str);
-#endif
 	printk(KERN_INFO "MPTABLE: Product ID: %s\n", str);
 
 	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->mpc_lapic);
 
+	return 1;
+}
+
+static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
+{
+	char str[16];
+	char oem[10];
+
+	int count = sizeof(*mpc);
+	unsigned char *mpt = ((unsigned char *)mpc) + count;
+
+	if (!smp_check_mpc(mpc, oem, str))
+		return 0;
+
+#ifdef CONFIG_X86_32
+	mps_oem_check(mpc, oem, str);
+#endif
+
 	/* save the local APIC address, it might be non-default */
 	if (!acpi_lapic)
 		mp_lapic_addr = mpc->mpc_lapic;
@@ -1082,5 +1107,316 @@ int mp_register_gsi(u32 gsi, int trigger
 	return gsi;
 }
 
+int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
+			u32 gsi, int triggering, int polarity)
+{
+	struct mpc_config_intsrc intsrc;
+	int ioapic;
+
+	/* print the entry should happen on mptable identically */
+	intsrc.mpc_type = MP_INTSRC;
+	intsrc.mpc_irqtype = mp_INT;
+	intsrc.mpc_irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
+	intsrc.mpc_srcbus = number;
+	intsrc.mpc_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	ioapic = mp_find_ioapic(gsi);
+	intsrc.mpc_dstapic = mp_ioapic_routing[ioapic].apic_id;
+	intsrc.mpc_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
+
+	MP_intsrc_info(&intsrc);
+
+	return 0;
+}
 #endif /* CONFIG_X86_IO_APIC */
 #endif /* CONFIG_ACPI */
+
+static u8 __initdata irq_used[MAX_IRQ_SOURCES];
+
+static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
+{
+	int i;
+
+	if (m->mpc_irqtype != mp_INT)
+		return 0;
+
+	if (m->mpc_irqflag != 0x0f)
+		return 0;
+
+	/* not legacy */
+
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (mp_irqs[i].mpc_irqtype != mp_INT)
+			continue;
+
+		if (mp_irqs[i].mpc_irqflag != 0x0f)
+			continue;
+
+		if (mp_irqs[i].mpc_srcbus != m->mpc_srcbus)
+			continue;
+		if (mp_irqs[i].mpc_srcbusirq != m->mpc_srcbusirq)
+			continue;
+		if (irq_used[i]) {
+			/* already claimed */
+			return -2;
+		}
+		irq_used[i] = 1;
+		return i;
+	}
+
+	/* not found */
+	return -1;
+}
+
+#define SPARE_SLOT_NUM 20
+
+static struct mpc_config_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
+
+static int  __init replace_intsrc_all(struct mp_config_table *mpc,
+					unsigned long mpc_new_phys,
+					unsigned long mpc_new_length)
+{
+	int i;
+	int nr_m_spare = 0;
+
+	int count = sizeof(*mpc);
+	unsigned char *mpt = ((unsigned char *)mpc) + count;
+
+	printk(KERN_INFO "mpc_length %x\n", mpc->mpc_length);
+	while (count < mpc->mpc_length) {
+		switch (*mpt) {
+		case MP_PROCESSOR:
+			{
+				struct mpc_config_processor *m =
+				    (struct mpc_config_processor *)mpt;
+				mpt += sizeof(*m);
+				count += sizeof(*m);
+				break;
+			}
+		case MP_BUS:
+			{
+				struct mpc_config_bus *m =
+				    (struct mpc_config_bus *)mpt;
+				mpt += sizeof(*m);
+				count += sizeof(*m);
+				break;
+			}
+		case MP_IOAPIC:
+			{
+				mpt += sizeof(struct mpc_config_ioapic);
+				count += sizeof(struct mpc_config_ioapic);
+				break;
+			}
+		case MP_INTSRC:
+			{
+#ifdef CONFIG_X86_IO_APIC
+				struct mpc_config_intsrc *m =
+				    (struct mpc_config_intsrc *)mpt;
+
+				printk(KERN_CONT "OLD ");
+				print_MP_intsrc_info(m);
+				i = get_MP_intsrc_index(m);
+				if (i > 0) {
+					memcpy(m, &mp_irqs[i], sizeof(*m));
+					printk(KERN_CONT "NEW ");
+					print_MP_intsrc_info(&mp_irqs[i]);
+				} else if (!i) {
+					/* legacy, do nothing */
+				} else if (nr_m_spare < SPARE_SLOT_NUM) {
+					/*
+					 * not found (-1), or duplicated (-2)
+					 * are invalid entries,
+					 * we need to use the slot  later
+					 */
+					m_spare[nr_m_spare] = m;
+					nr_m_spare++;
+				}
+#endif
+				mpt += sizeof(struct mpc_config_intsrc);
+				count += sizeof(struct mpc_config_intsrc);
+				break;
+			}
+		case MP_LINTSRC:
+			{
+				struct mpc_config_lintsrc *m =
+				    (struct mpc_config_lintsrc *)mpt;
+				mpt += sizeof(*m);
+				count += sizeof(*m);
+				break;
+			}
+		default:
+			/* wrong mptable */
+			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
+			printk(KERN_ERR "type %x\n", *mpt);
+			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
+					1, mpc, mpc->mpc_length, 1);
+			goto out;
+		}
+	}
+
+#ifdef CONFIG_X86_IO_APIC
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (irq_used[i])
+			continue;
+
+		if (mp_irqs[i].mpc_irqtype != mp_INT)
+			continue;
+
+		if (mp_irqs[i].mpc_irqflag != 0x0f)
+			continue;
+
+		if (nr_m_spare > 0) {
+			printk(KERN_INFO "*NEW* found ");
+			nr_m_spare--;
+			memcpy(m_spare[nr_m_spare], &mp_irqs[i],
+				sizeof(mp_irqs[i]));
+			m_spare[nr_m_spare] = NULL;
+		} else {
+			struct mpc_config_intsrc *m =
+			    (struct mpc_config_intsrc *)mpt;
+			count += sizeof(struct mpc_config_intsrc);
+			if (!mpc_new_phys) {
+				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
+			} else {
+				if (count <= mpc_new_length)
+					printk(KERN_INFO "No spare slots, try to append..., new mpc_length %x\n", count);
+				else {
+					printk(KERN_ERR "mpc_new_length %lx is too small\n", mpc_new_length);
+					goto out;
+				}
+			}
+			memcpy(m, &mp_irqs[i], sizeof(mp_irqs[i]));
+			mpc->mpc_length = count;
+			mpt += sizeof(struct mpc_config_intsrc);
+		}
+		print_MP_intsrc_info(&mp_irqs[i]);
+	}
+#endif
+out:
+	/* update checksum */
+	mpc->mpc_checksum = 0;
+	mpc->mpc_checksum -= mpf_checksum((unsigned char *)mpc,
+					   mpc->mpc_length);
+
+	return 0;
+}
+
+int __initdata enable_update_mptable;
+
+static int __init update_mptable_setup(char *str)
+{
+	enable_update_mptable = 1;
+	return 0;
+}
+early_param("update_mptable", update_mptable_setup);
+
+static unsigned long __initdata mpc_new_phys;
+static unsigned long mpc_new_length __initdata = 4096;
+
+#ifdef CONFIG_X86_64
+/* alloc_mptable or alloc_mptable=4k */
+static int __initdata alloc_mptable;
+static int __init parse_alloc_mptable_opt(char *p)
+{
+	enable_update_mptable = 1;
+	alloc_mptable = 1;
+	if (!p)
+		return 0;
+	mpc_new_length = memparse(p, &p);
+	return 0;
+}
+early_param("alloc_mptable", parse_alloc_mptable_opt);
+
+void __init early_reserve_e820_mpc_new(void)
+{
+	if (enable_update_mptable && alloc_mptable)
+		mpc_new_phys = early_reserve_e820(mpc_new_length, 4);
+}
+#else
+void __init early_reserve_e820_mpc_new(void)
+{
+}
+#endif
+
+static int __init update_mp_table(void)
+{
+	char str[16];
+	char oem[10];
+	struct intel_mp_floating *mpf;
+	struct mp_config_table *mpc;
+	struct mp_config_table *mpc_new;
+
+	if (!enable_update_mptable)
+		return 0;
+
+	mpf = mpf_found;
+	if (!mpf)
+		return 0;
+
+	/*
+	 * Now see if we need to go further.
+	 */
+	if (mpf->mpf_feature1 != 0)
+		return 0;
+
+	if (!mpf->mpf_physptr)
+		return 0;
+
+	mpc = phys_to_virt(mpf->mpf_physptr);
+
+	if (!smp_check_mpc(mpc, oem, str))
+		return 0;
+
+	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
+	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
+
+	if (mpc_new_phys && mpc->mpc_length > mpc_new_length) {
+		mpc_new_phys = 0;
+		printk(KERN_INFO "mpc_new_length is %ld, please use alloc_mptable=8k\n",
+			 mpc_new_length);
+	}
+
+	if (!mpc_new_phys) {
+		unsigned char old, new;
+		/* check if we can change the postion */
+		mpc->mpc_checksum = 0;
+		old = mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
+		mpc->mpc_checksum = 0xff;
+		new = mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
+		if (old == new) {
+			printk(KERN_INFO "mpc is readonly, please try alloc_mptable instead\n");
+			return 0;
+		}
+		printk(KERN_INFO "use in-positon replacing\n");
+	} else {
+		mpf->mpf_physptr = mpc_new_phys;
+		mpc_new = phys_to_virt(mpc_new_phys);
+		memcpy(mpc_new, mpc, mpc->mpc_length);
+		mpc = mpc_new;
+		/* check if we can modify that */
+		if (mpc_new_phys - mpf->mpf_physptr) {
+			struct intel_mp_floating *mpf_new;
+			/* steal 16 bytes from [0, 1k) */
+			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
+			mpf_new = phys_to_virt(0x400 - 16);
+			memcpy(mpf_new, mpf, 16);
+			mpf = mpf_new;
+			mpf->mpf_physptr = mpc_new_phys;
+		}
+		mpf->mpf_checksum = 0;
+		mpf->mpf_checksum -= mpf_checksum((unsigned char *)mpf, 16);
+		printk(KERN_INFO "mpf_physptr new: %x\n", mpf->mpf_physptr);
+	}
+
+	/*
+	 * only replace the one with mp_INT and
+	 *	 MP_IRQ_TRIGGER_LEVEL|MP_IRQ_POLARITY_LOW,
+	 * already in mp_irqs , stored by ... and mp_config_acpi_gsi,
+	 * may need pci=routeirq for all coverage
+	 */
+	replace_intsrc_all(mpc, mpc_new_phys, mpc_new_length);
+
+	return 0;
+}
+
+late_initcall(update_mp_table);
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -56,6 +56,7 @@
 #include <asm/desc.h>
 #include <video/edid.h>
 #include <asm/e820.h>
+#include <asm/mpspec.h>
 #include <asm/dma.h>
 #include <asm/gart.h>
 #include <asm/mpspec.h>
@@ -372,6 +373,9 @@ void __init setup_arch(char **cmdline_p)
 	 * we are rounding upwards:
 	 */
 	end_pfn = e820_end_of_ram();
+
+	/* pre allocte 4k for mptable mpc */
+	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(end_pfn)) {
Index: linux-2.6/drivers/acpi/pci_irq.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_irq.c
+++ linux-2.6/drivers/acpi/pci_irq.c
@@ -570,6 +570,9 @@ int acpi_pci_irq_enable(struct pci_dev *
 	       (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
 	       (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
+	mp_config_acpi_gsi(dev->bus->number, dev->devfn, dev->pin, irq,
+				 triggering, polarity);
+
 	return 0;
 }
 
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -50,6 +50,8 @@ extern void update_e820(void);
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
 extern void free_early(unsigned long start, unsigned long end);
 extern void early_res_to_bootmem(unsigned long start, unsigned long end);
+extern unsigned long early_reserve_e820(unsigned long sizet,
+					unsigned long align);
 
 #endif/*!__ASSEMBLY__*/
 
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -41,6 +41,7 @@ extern unsigned long mp_lapic_addr;
 
 extern void find_smp_config(void);
 extern void get_smp_config(void);
+extern void early_reserve_e820_mpc_new(void);
 
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
@@ -49,6 +50,8 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
+				u32 gsi, int triggering, int polarity);
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
