Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZCRRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZCRRPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZCRRPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:15:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:41061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbZCRRPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:15:17 -0400
Subject: Re: [git-pull -tip] x86: mpparse cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20090318163933.GA29854@elte.hu>
References: <1237314836.3212.10.camel@localhost.localdomain>
	 <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu>
	 <1237392355.12866.2.camel@ht.satnam> <20090318161829.GC21331@elte.hu>
	 <20090318163933.GA29854@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 22:44:47 +0530
Message-Id: <1237396487.22438.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 17:39 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >  1 files changed, 120 insertions(+), 141 deletions(-)
> > 
> > Looks good - pulled, thanks Jaswinder!
> > 
> > Would you be interested in resurrecting the more mechanic cleanups 
> > you did as well, on top of this patch?
> > 
> > They are still valuable, we just have to keep them separate from a 
> > potential breakage-causing change like the above one, so that if a 
> > tester bisects to it, we have an as single-purpose and focused 
> > commit to look at as possible.
> 
> So it's helpful to have a small commit when we have a regression.
> 
> Such as in this case - a -tip testbox crashed with:
> 
> weird, boot CPU (#0) not listed by the BIOS.
> Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (0 vs 4)
> Pid: 1, comm: swapper Not tainted 
> 2.6.29-rc8-tip-02595-g170ae27-dirty #21111
> Call Trace:
>  [<c0599964>] ? printk+0x14/0x18
>  [<c05998a6>] panic+0x3e/0xe8
>  [<c08fc9e4>] native_smp_prepare_cpus+0x13e/0x1f8
>  [<c08f335a>] kernel_init+0x47/0xd8
>  [<c08f3313>] ? kernel_init+0x0/0xd8
>  [<c0103ea3>] kernel_thread_helper+0x7/0x10
> 
> config and full crashlog attached.
> 

As I told you earlier, I cannot check this on my side. Only suspect will
be check_irq_src() please test this patch if this does not work I will
revert check_irq_src():

Subject: [PATCH] x86: mpparse introduced few helper functions

Introduced helper functions:
skip_entry, smp_reserve_bootmem, check_irq_src and check_slot

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/mpparse.c |  261 +++++++++++++++++++++------------------------
 1 files changed, 120 insertions(+), 141 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 47673e0..d2f5cd5 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
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
@@ -689,6 +668,31 @@ void __init get_smp_config(void)
 	__get_smp_config(0);
 }
 
+static void smp_reserve_bootmem(struct mpf_intel *mpf)
+{
+	unsigned long size = get_mpc_size(mpf->physptr);
+#ifdef CONFIG_X86_32
+	/*
+	 * We cannot access to MPC table to compute table size yet,
+	 * as only few megabytes from the bottom is mapped now.
+	 * PC-9800's MPC table places on the very last of physical
+	 * memory; so that simply reserving PAGE_SIZE from mpf->physptr
+	 * yields BUG() in reserve_bootmem.
+	 * also need to make sure physptr is below than max_low_pfn
+	 * we don't need reserve the area above max_low_pfn
+	 */
+	unsigned long end = max_low_pfn * PAGE_SIZE;
+
+	if (mpf->physptr < end) {
+		if (mpf->physptr + size > end)
+			size = end - mpf->physptr;
+		reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
+	}
+#else
+	reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
+#endif
+}
+
 static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
@@ -717,35 +721,9 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 			if (!reserve)
 				return 1;
 			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
-					BOOTMEM_DEFAULT);
-			if (mpf->physptr) {
-				unsigned long size = get_mpc_size(mpf->physptr);
-#ifdef CONFIG_X86_32
-				/*
-				 * We cannot access to MPC table to compute
-				 * table size yet, as only few megabytes from
-				 * the bottom is mapped now.
-				 * PC-9800's MPC table places on the very last
-				 * of physical memory; so that simply reserving
-				 * PAGE_SIZE from mpf->physptr yields BUG()
-				 * in reserve_bootmem.
-				 * also need to make sure physptr is below than
-				 * max_low_pfn
-				 * we don't need reserve the area above max_low_pfn
-				 */
-				unsigned long end = max_low_pfn * PAGE_SIZE;
-
-				if (mpf->physptr < end) {
-					if (mpf->physptr + size > end)
-						size = end - mpf->physptr;
-					reserve_bootmem_generic(mpf->physptr, size,
-							BOOTMEM_DEFAULT);
-				}
-#else
-				reserve_bootmem_generic(mpf->physptr, size,
 						BOOTMEM_DEFAULT);
-#endif
-			}
+			if (mpf->physptr)
+				smp_reserve_bootmem(mpf);
 
 			return 1;
 		}
@@ -848,7 +826,57 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 #define SPARE_SLOT_NUM 20
 
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
-#endif
+
+static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
+{
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
+		return;
+	}
+	if (!i) {
+		/* legacy, do nothing */
+		return;
+	}
+	if (*nr_m_spare < SPARE_SLOT_NUM) {
+		/*
+		 * not found (-1), or duplicated (-2) are invalid entries,
+		 * we need to use the slot later
+		 */
+		m_spare[*nr_m_spare] = m;
+		*nr_m_spare += 1;
+	}
+}
+#else /* CONFIG_X86_IO_APIC */
+static inline void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+#endif /* CONFIG_X86_IO_APIC */
+
+static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
+		      int count)
+{
+	if (!mpc_new_phys) {
+		pr_info("No spare slots, try to append...take your risk, "
+			"new mpc_length %x\n", count);
+	} else {
+		if (count <= mpc_new_length)
+			pr_info("No spare slots, try to append..., "
+				"new mpc_length %x\n", count);
+		else {
+			pr_err("mpc_new_length %lx is too small\n",
+				mpc_new_length);
+			return -1;
+		}
+	}
+
+	return 0;
+}
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
@@ -856,71 +884,30 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 {
 #ifdef CONFIG_X86_IO_APIC
 	int i;
-	int nr_m_spare = 0;
 #endif
-
 	int count = sizeof(*mpc);
+	int nr_m_spare = 0;
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
 	printk(KERN_INFO "mpc_length %x\n", mpc->length);
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
+			check_irq_src((struct mpc_intsrc *)mpt, &nr_m_spare);
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
@@ -950,16 +937,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
-			if (!mpc_new_phys) {
-				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
-			} else {
-				if (count <= mpc_new_length)
-					printk(KERN_INFO "No spare slots, try to append..., new mpc_length %x\n", count);
-				else {
-					printk(KERN_ERR "mpc_new_length %lx is too small\n", mpc_new_length);
-					goto out;
-				}
-			}
+			if (!check_slot(mpc_new_phys, mpc_new_length, count))
+				goto out;
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->length = count;
 			mpt += sizeof(struct mpc_intsrc);
-- 
1.6.0.6



