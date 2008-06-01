Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYFAURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYFAURw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYFAURd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:17:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:36544 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYFAURb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VIi3dt+x5O4EBwrHDufL6lTgJpB1ciIIhlRT9z0+Eh6lsVsWLeApKHiPa0DYENQgOC4jFPoQpFtolG53ZG0oDaGRDRAtWVnv9RrWxV3n3SKPnkULvnu9pBuWsXB3weF5vKyxW8RrP9GG6R5m9KkI+GbskRg17LZMK0ccRr3R4Y4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] x86: update mptable v7
Date: Sun, 1 Jun 2008 13:17:38 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805191252.36814.yhlu.kernel@gmail.com> <200805251600.26325.yhlu.kernel@gmail.com>
In-Reply-To: <200805251600.26325.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011317.38622.yhlu.kernel@gmail.com>
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
v3: adjust for patch that move some mp_xxx to acpi..., and mpc_ to mp_
v4: fix i386 without IO_APIC support compiling
v5: make it could be applied after
	x86: extend e820 ealy_res support 32bit
v6: 32bit support alloc_mptable too
    fix ia64 compilation
v7: fix driver in module to call mp_config_acpi_gsi

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -25,6 +25,8 @@
 #include <asm/proto.h>
 #include <asm/acpi.h>
 #include <asm/bios_ebda.h>
+#include <asm/e820.h>
+#include <asm/trampoline.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
@@ -161,20 +163,81 @@ static void __init MP_ioapic_info(struct
 	nr_ioapics++;
 }
 
-static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
+static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	printk(KERN_INFO "Int: type %d, pol %d, trig %d, bus %02x,"
+	printk(KERN_CONT "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
 		m->mpc_srcbusirq, m->mpc_dstapic, m->mpc_dstirq);
-	mp_irqs[mp_irq_entries].mp_dstapic = m->mpc_dstapic;
-	mp_irqs[mp_irq_entries].mp_type = m->mpc_type;
-	mp_irqs[mp_irq_entries].mp_irqtype = m->mpc_irqtype;
-	mp_irqs[mp_irq_entries].mp_irqflag = m->mpc_irqflag;
-	mp_irqs[mp_irq_entries].mp_srcbus = m->mpc_srcbus;
-	mp_irqs[mp_irq_entries].mp_srcbusirq = m->mpc_srcbusirq;
-	mp_irqs[mp_irq_entries].mp_dstirq = m->mpc_dstirq;
+}
+
+static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
+{
+	printk(KERN_CONT "Int: type %d, pol %d, trig %d, bus %02x,"
+		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
+		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
+		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
+		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
+}
+
+static void assign_to_mp_irq(struct mpc_config_intsrc *m,
+				    struct mp_config_intsrc *mp_irq)
+{
+	mp_irq->mp_dstapic = m->mpc_dstapic;
+	mp_irq->mp_type = m->mpc_type;
+	mp_irq->mp_irqtype = m->mpc_irqtype;
+	mp_irq->mp_irqflag = m->mpc_irqflag;
+	mp_irq->mp_srcbus = m->mpc_srcbus;
+	mp_irq->mp_srcbusirq = m->mpc_srcbusirq;
+	mp_irq->mp_dstirq = m->mpc_dstirq;
+}
+
+static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
+					struct mpc_config_intsrc *m)
+{
+	m->mpc_dstapic = mp_irq->mp_dstapic;
+	m->mpc_type = mp_irq->mp_type;
+	m->mpc_irqtype = mp_irq->mp_irqtype;
+	m->mpc_irqflag = mp_irq->mp_irqflag;
+	m->mpc_srcbus = mp_irq->mp_srcbus;
+	m->mpc_srcbusirq = mp_irq->mp_srcbusirq;
+	m->mpc_dstirq = mp_irq->mp_dstirq;
+}
+
+static int mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
+					struct mpc_config_intsrc *m)
+{
+	if (mp_irq->mp_dstapic != m->mpc_dstapic)
+		return 1;
+	if (mp_irq->mp_type != m->mpc_type)
+		return 2;
+	if (mp_irq->mp_irqtype != m->mpc_irqtype)
+		return 3;
+	if (mp_irq->mp_irqflag != m->mpc_irqflag)
+		return 4;
+	if (mp_irq->mp_srcbus != m->mpc_srcbus)
+		return 5;
+	if (mp_irq->mp_srcbusirq != m->mpc_srcbusirq)
+		return 6;
+	if (mp_irq->mp_dstirq != m->mpc_dstirq)
+		return 7;
+
+	return 0;
+}
+
+void MP_intsrc_info(struct mpc_config_intsrc *m)
+{
+	int i;
+
+	print_MP_intsrc_info(m);
+
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
+			return;
+	}
+
+	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
 }
@@ -268,12 +331,9 @@ static inline void mps_oem_check(struct 
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
@@ -301,13 +361,28 @@ static int __init smp_read_mpc(struct mp
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
@@ -785,3 +860,295 @@ void __init find_smp_config(void)
 {
 	__find_smp_config(1);
 }
+
+#ifdef CONFIG_X86_IO_APIC
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
+		if (mp_irqs[i].mp_irqtype != mp_INT)
+			continue;
+
+		if (mp_irqs[i].mp_irqflag != 0x0f)
+			continue;
+
+		if (mp_irqs[i].mp_srcbus != m->mpc_srcbus)
+			continue;
+		if (mp_irqs[i].mp_srcbusirq != m->mpc_srcbusirq)
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
+#endif
+
+static int  __init replace_intsrc_all(struct mp_config_table *mpc,
+					unsigned long mpc_new_phys,
+					unsigned long mpc_new_length)
+{
+#ifdef CONFIG_X86_IO_APIC
+	int i;
+	int nr_m_spare = 0;
+#endif
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
+				printk(KERN_INFO "OLD ");
+				print_MP_intsrc_info(m);
+				i = get_MP_intsrc_index(m);
+				if (i > 0) {
+					assign_to_mpc_intsrc(&mp_irqs[i], m);
+					printk(KERN_INFO "NEW ");
+					print_mp_irq_info(&mp_irqs[i]);
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
+		if (mp_irqs[i].mp_irqtype != mp_INT)
+			continue;
+
+		if (mp_irqs[i].mp_irqflag != 0x0f)
+			continue;
+
+		if (nr_m_spare > 0) {
+			printk(KERN_INFO "*NEW* found ");
+			nr_m_spare--;
+			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
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
+			assign_to_mpc_intsrc(&mp_irqs[i], m);
+			mpc->mpc_length = count;
+			mpt += sizeof(struct mpc_config_intsrc);
+		}
+		print_mp_irq_info(&mp_irqs[i]);
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
+	if (enable_update_mptable && alloc_mptable) {
+		u64 startt = 0;
+#ifdef CONFIG_X86_TRAMPOLINE
+		startt = TRAMPOLINE_BASE;
+#endif
+		mpc_new_phys = early_reserve_e820(startt, mpc_new_length, 4);
+	}
+}
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
@@ -373,6 +374,9 @@ void __init setup_arch(char **cmdline_p)
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
@@ -570,6 +570,11 @@ int acpi_pci_irq_enable(struct pci_dev *
 	       (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
 	       (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
+#ifdef CONFIG_X86
+	mp_config_acpi_gsi(dev->bus->number, dev->devfn, dev->pin, irq,
+				 triggering, polarity);
+#endif
+
 	return 0;
 }
 
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -39,6 +39,7 @@ extern unsigned long mp_lapic_addr;
 
 extern void find_smp_config(void);
 extern void get_smp_config(void);
+extern void early_reserve_e820_mpc_new(void);
 
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
@@ -47,6 +48,9 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern void MP_intsrc_info(struct mpc_config_intsrc *m);
+extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
+				u32 gsi, int triggering, int polarity);
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1164,6 +1164,28 @@ int mp_register_gsi(u32 gsi, int trigger
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
+
 /*
  * Parse IOAPIC related entries in MADT
  * returns 0 on success, < 0 on error
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -739,3 +739,28 @@ u64 __init find_e820_area_size(u64 start
 	return -1UL;
 
 }
+
+/*
+ * pre allocated 4k and reserved it in e820
+ */
+u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
+{
+	u64 size = 0;
+	u64 addr;
+	u64 start;
+
+	start = startt;
+	while (size < sizet)
+		start = find_e820_area_size(start, &size, align);
+
+	if (size < sizet)
+		return 0;
+
+	addr = round_down(start + size - sizet, align);
+	update_memory_range(addr, sizet, E820_RAM, E820_RESERVED);
+	printk(KERN_INFO "update e820 for early_reserve_e820\n");
+	update_e820();
+
+	return addr;
+}
+
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -84,6 +84,7 @@ extern u64 find_e820_area_size(u64 start
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
+extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
 #endif /* __ASSEMBLY__ */
 
