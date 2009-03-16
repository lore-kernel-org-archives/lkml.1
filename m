Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbZCPNTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbZCPNTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZCPNTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:19:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZCPNTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:19:04 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1237205895.6638.38.camel@localhost.localdomain>
References: <1237047188.4546.31.camel@ht.satnam>
	 <20090314170355.GE31930@elte.hu>
	 <1237205895.6638.38.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 18:48:22 +0530
Message-Id: <1237209502.15711.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 17:48 +0530, Jaswinder Singh Rajput wrote:
>  
> 
> Here is the patch for skip_entry, I cannot check this patch on my side,
> so please check it and let me know the feedbacks:
> >From ff5a4d728b42af867dc8f6aef43107c7a015a5b4 Mon Sep 17 00:00:00 2001
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 16 Mar 2009 17:06:49 +0530
> Subject: [PATCH] x86: mpparse cleanup
> 
> Impact: cleanup
> 
> Introduced helper function skip_entry and check_irq_src

hmm, this one seems much better:

Subject: [PATCH] x86: mpparse cleanup

Impact: cleanup

Introduced helper function skip_entry and check_irq_src

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/mpparse.c |  202 ++++++++++++++++++++-------------------------
 1 files changed, 88 insertions(+), 114 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 47673e0..9347602 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -7,29 +7,29 @@
  *      (c) 2008 Alexey Starikovskiy <astarikovskiy@suse.de>
  */
 
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/bootmem.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
+#include <linux/bootmem.h>
 #include <linux/bitops.h>
-#include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/acpi.h>
+#include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/mm.h>
 
-#include <asm/mtrr.h>
-#include <asm/mpspec.h>
+#include <asm/trampoline.h>
+#include <asm/bios_ebda.h>
 #include <asm/pgalloc.h>
 #include <asm/io_apic.h>
+#include <asm/mpspec.h>
 #include <asm/proto.h>
-#include <asm/bios_ebda.h>
-#include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/e820.h>
+#include <asm/mtrr.h>
 #include <asm/smp.h>
 
-#include <asm/apic.h>
 /*
  * Checksum an MP configuration block.
  */
@@ -109,9 +109,6 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
 }
-#endif
-
-#ifdef CONFIG_X86_IO_APIC
 
 static int bad_ioapic(unsigned long address)
 {
@@ -224,8 +221,12 @@ static void __init MP_intsrc_info(struct mpc_intsrc *m)
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
 }
+#else /* CONFIG_X86_IO_APIC */
+static inline void __init MP_bus_info(struct mpc_bus *m) {}
+static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
+static inline void __init MP_intsrc_info(struct mpc_intsrc *m) {}
+#endif /* CONFIG_X86_IO_APIC */
 
-#endif
 
 static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
@@ -275,6 +276,12 @@ static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 	return 1;
 }
 
+static void skip_entry(unsigned char **ptr, int *count, int size)
+{
+	*ptr += size;
+	*count += size;
+}
+
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -310,55 +317,27 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
-			{
-				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-				/* ACPI may have already provided this data */
-				if (!acpi_lapic)
-					MP_processor_info(m);
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			/* ACPI may have already provided this data */
+			if (!acpi_lapic)
+				MP_processor_info((struct mpc_cpu *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
 		case MP_BUS:
-			{
-				struct mpc_bus *m = (struct mpc_bus *)mpt;
-#ifdef CONFIG_X86_IO_APIC
-				MP_bus_info(m);
-#endif
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			MP_bus_info((struct mpc_bus *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
 		case MP_IOAPIC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_ioapic *m = (struct mpc_ioapic *)mpt;
-				MP_ioapic_info(m);
-#endif
-				mpt += sizeof(struct mpc_ioapic);
-				count += sizeof(struct mpc_ioapic);
-				break;
-			}
+			MP_ioapic_info((struct mpc_ioapic *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
 		case MP_INTSRC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-
-				MP_intsrc_info(m);
-#endif
-				mpt += sizeof(struct mpc_intsrc);
-				count += sizeof(struct mpc_intsrc);
-				break;
-			}
+			MP_intsrc_info((struct mpc_intsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
 		case MP_LINTSRC:
-			{
-				struct mpc_lintsrc *m =
-				    (struct mpc_lintsrc *)mpt;
-				MP_lintsrc_info(m);
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			MP_lintsrc_info((struct mpc_lintsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
 		default:
 			/* wrong mptable */
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
@@ -848,7 +827,43 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 #define SPARE_SLOT_NUM 20
 
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
-#endif
+
+static int check_irq_src(struct mpc_intsrc *m)
+{
+	int nr_m_spare = 0;
+	int i;
+
+	apic_printk(APIC_VERBOSE, "OLD ");
+	print_MP_intsrc_info(m);
+
+	i = get_MP_intsrc_index(m);
+	if (i > 0) {
+		assign_to_mpc_intsrc(&mp_irqs[i], m);
+		apic_printk(APIC_VERBOSE, "NEW ");
+		print_mp_irq_info(&mp_irqs[i]);
+		return 0;
+	}
+	if (!i) {
+		/* legacy, do nothing */
+		return 0;
+	}
+
+	/*
+	 * not found (-1), or duplicated (-2)
+	 * are invalid entries,
+	 * we need to use the slot  later
+	 */
+	m_spare[nr_m_spare] = m;
+	nr_m_spare++;
+
+	return nr_m_spare;
+}
+#else /* CONFIG_X86_IO_APIC */
+static inline int check_irq_src(struct mpc_intsrc *m)
+{
+	return 0;
+}
+#endif /* CONFIG_X86_IO_APIC */
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
@@ -856,9 +871,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 {
 #ifdef CONFIG_X86_IO_APIC
 	int i;
-	int nr_m_spare = 0;
 #endif
-
+	int nr_m_spare = 0;
 	int count = sizeof(*mpc);
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
@@ -866,61 +880,21 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
-			{
-				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
 		case MP_BUS:
-			{
-				struct mpc_bus *m = (struct mpc_bus *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
 		case MP_IOAPIC:
-			{
-				mpt += sizeof(struct mpc_ioapic);
-				count += sizeof(struct mpc_ioapic);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
 		case MP_INTSRC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-
-				apic_printk(APIC_VERBOSE, "OLD ");
-				print_MP_intsrc_info(m);
-				i = get_MP_intsrc_index(m);
-				if (i > 0) {
-					assign_to_mpc_intsrc(&mp_irqs[i], m);
-					apic_printk(APIC_VERBOSE, "NEW ");
-					print_mp_irq_info(&mp_irqs[i]);
-				} else if (!i) {
-					/* legacy, do nothing */
-				} else if (nr_m_spare < SPARE_SLOT_NUM) {
-					/*
-					 * not found (-1), or duplicated (-2)
-					 * are invalid entries,
-					 * we need to use the slot  later
-					 */
-					m_spare[nr_m_spare] = m;
-					nr_m_spare++;
-				}
-#endif
-				mpt += sizeof(struct mpc_intsrc);
-				count += sizeof(struct mpc_intsrc);
-				break;
-			}
+			nr_m_spare = check_irq_src((struct mpc_intsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
 		case MP_LINTSRC:
-			{
-				struct mpc_lintsrc *m =
-				    (struct mpc_lintsrc *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
 		default:
 			/* wrong mptable */
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
-- 
1.6.0.6



