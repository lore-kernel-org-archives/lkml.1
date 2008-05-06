Return-Path: <linux-kernel-owner+w=401wt.eu-S1765749AbYEFRpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765749AbYEFRpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbYEFRmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:42:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:62031 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbYEFRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=PGk7oMXGUF8Oky7G+PGKIreJ/aEfayn/Yqy5125aPz89LRjm7Pxs4/a6B+iz44bVr7c/iKngGOY7Og0t3TiID/MX/qPrJ9kjjJP5h2gzCq+40lhi7MjYkvNRnS31IF9bNwUxifGrY0z7ThJW1UHthzHo+/lMei0yv3LEEiJHRdw=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: update mptable
Date: Tue, 6 May 2008 10:38:57 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com>
In-Reply-To: <200805041823.57198.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061038.58023.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make mptable to be consistent to acpi routing, so we could
1. kexec kernel with acpi=off
2. workaround BIOS that acpi routing is working, but mptable is not right.
   so can use kernel/kexec to start other os that doesn't have good acpi support

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/drivers/acpi/pci_irq.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_irq.c
+++ linux-2.6/drivers/acpi/pci_irq.c
@@ -474,6 +474,8 @@ acpi_pci_irq_derive(struct pci_dev *dev,
 	return irq;
 }
 
+int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin, u32 gsi, int triggering, int polarity);
+
 /*
  * acpi_pci_irq_enable
  * success: return 0
@@ -570,6 +572,8 @@ int acpi_pci_irq_enable(struct pci_dev *
 	       (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
 	       (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
+	mp_config_acpi_gsi(dev->bus->number, dev->devfn, dev->pin, irq, triggering, polarity);
+
 	return 0;
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -180,14 +180,26 @@ static void __init MP_ioapic_info(struct
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
@@ -281,12 +293,9 @@ static inline void mps_oem_check(struct 
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
@@ -314,13 +323,28 @@ static int __init smp_read_mpc(struct mp
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
@@ -1082,5 +1106,225 @@ int mp_register_gsi(u32 gsi, int trigger
 	return gsi;
 }
 
+int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin, u32 gsi, int triggering, int polarity)
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
+static int  __init replace_intsrc_all(struct mp_config_table *mpc)
+{
+	int i;
+	int nr_m_spare = 0;
+
+	int count = sizeof(*mpc);
+	unsigned char *mpt = ((unsigned char *)mpc) + count;
+
+	printk("mpc_length %x\n", mpc->mpc_length);
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
+				/* we can not fill blank, so just duplicate last one if needed */
+				printk("OLD ");
+				print_MP_intsrc_info(m);
+				i = get_MP_intsrc_index(m);
+				if (i > 0) {
+					memcpy(m, &mp_irqs[i], sizeof(*m));
+					printk("NEW ");
+					print_MP_intsrc_info(&mp_irqs[i]);
+				} else if (!i) {
+					/* legacy, do nothing */
+				} else if (nr_m_spare < SPARE_SLOT_NUM) {
+					/* -1, -2 */
+					/* not found, or duplicated ==> invalid entry, we need to use the slot  later*/
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
+			printk("*NEW* found ");
+			nr_m_spare--;
+			memcpy(m_spare[nr_m_spare], &mp_irqs[i], sizeof(mp_irqs[i]));
+			m_spare[nr_m_spare] = NULL;
+		} else {
+			struct mpc_config_intsrc *m =
+			    (struct mpc_config_intsrc *)mpt;
+			count += sizeof(struct mpc_config_intsrc);
+			mpc->mpc_length = count;
+			printk("No spare slots, try to append...take your risk, new mpc_length %x\n", count);
+			memcpy(m, &mp_irqs[i], sizeof(mp_irqs[i]));
+			mpt += sizeof(struct mpc_config_intsrc);
+		}
+		print_MP_intsrc_info(&mp_irqs[i]);
+	}
+#endif
+out:
+	/* update checksum */
+	mpc->mpc_checksum = 0;
+	mpc->mpc_checksum -= mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
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
+static int __init update_mp_table(void)
+{
+	char str[16];
+	char oem[10];
+	struct intel_mp_floating *mpf;
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
+	if (!smp_check_mpc(phys_to_virt(mpf->mpf_physptr), oem, str))
+		return 0;
+
+	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
+
+	/* only replace the one with mp_INT, MP_IRQ_TRIGGER_LEVEL|MP_IRQ_POLARITY_LOW,
+	 already in mp_irqs , stored by ... and mp_config_acpi_gsi ... need pci=routeirq   */
+	replace_intsrc_all(phys_to_virt(mpf->mpf_physptr));
+
+	return 0;
+}
+
+late_initcall(update_mp_table);
