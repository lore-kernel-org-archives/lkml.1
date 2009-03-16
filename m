Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbZCPMS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbZCPMS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZCPMSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:18:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:58388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbZCPMSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:18:49 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090314170355.GE31930@elte.hu>
References: <1237047188.4546.31.camel@ht.satnam>
	 <20090314170355.GE31930@elte.hu>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 17:48:15 +0530
Message-Id: <1237205895.6638.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 18:03 +0100, Ingo Molnar wrote:

> ----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----
> 
> Date: Fri, 2 Jan 2009 18:21:50 +0100
> From: Ingo Molnar <mingo@elte.hu>
> To: Jaswinder Singh Rajput <jaswinder@infradead.org>
> Subject: Re: [PATCH] x86: mpparse.c fix style problems
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
> 	LKML <linux-kernel@vger.kernel.org>
> 
> 
> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> 
> > Impact: cleanup, fix style problems, more readable
> 
> > @@ -314,7 +314,9 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
> >  		return 1;
> >  
> >  	if (mpc->mpc_oemptr && x86_quirks->smp_read_mpc_oem) {
> > -		struct mp_config_oemtable *oem_table = (struct mp_config_oemtable *)(unsigned long)mpc->mpc_oemptr;
> > +		struct mp_config_oemtable *oem_table;
> > +		oem_table = (struct mp_config_oemtable *)
> > +			     (unsigned long)mpc->mpc_oemptr;
> >  		x86_quirks->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
> >  	}
> 
> i think it would be cleaner to rename all the the mpc->mpc_X fields to 
> mpc->X - that alone would give 4 characters per usage site. (we already 
> know that it's an 'mpc' entity - no need to duplicate that in the field 
> too)
> 

Already fixed earlier.

> likewise, mp_config_oemtable should be renamed to mpc_oemtable to make it 
> all more compact.
> 
> also, instead of:
> 
> > +		struct mp_config_oemtable *oem_table;
> > +		oem_table = (struct mp_config_oemtable *)
> > +			     (unsigned long)mpc->mpc_oemptr;
> 
> we can do this oneliner:
> 
> > +		struct mpc_oemtable oem_table = (void *)(long)mpc->mpc_oemptr;
> 

Already fixed earlier.

> these types of printk string tweaks:
> 
> > -				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
> > +				printk(KERN_INFO "No spare slots, try to append"
> > +				       "...take your risk, new mpc_length %x\n",
> > +				       count);
> 
> do not actually improve the result - as they break the string in about 40 
> columns - making grepping harder and making it less readable. So it's a 
> step backwards.
> 
> To solve the 80 columns wrap problem, the following could be and should be 
> done instead.
> 
> 1) get the type names right - they should be expressive but short - like a 
>    good Huffman encoding:
> 
> See the mpc_ suggestion above, but there are more examples as well:
> 
> 				struct mpc_config_processor *m =
> 				    (struct mpc_config_processor *)mpt;
> 
> mpc_config_processor should be renamed to mpc_cpu. The reason: the 'c' in 
> MPC already means 'config' - no need to repeat that in the type name. Plus 
> 'processor' is a lot longer than 'cpu' - so we try to use 'cpu' in all 
> type names, as much as possible.
> 

Already fixed earlier.

> 2) get the code flow granularity right. Use small but expressive 
>    functions, where each function does one well-defined thing that is easy 
>    to think about as one unit of activity.
> 
> For example observe that replace_intsrc_all() is too big and not 
> particularly well structured.
> 
> furthermore, the whole function could be split up with a few helper 
> functions. Most of the loops could be split up by doing something like:
> 
>         while (count < mpc->mpc_length) {
> 		switch (*mpt) {
> 
> 		case MP_PROCESSOR:
> 			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
> 			continue;
> 
> 		case MP_BUS:
> 			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
> 			continue;
> 
> 		[...]
> 		case MP_INTSRC:
> 			parse_mpc_irq_entry(&mpt, &count);
> 			continue;
> 
> 		default:
> 			...
> 			goto out;
> 	}
> 
> The whole thing is way more readable, and it's immediately obvious that 
> the real work is done by MP_INTSRC - in a separate helper function. The 
> skip_entry() helper function just skips over
> 

Here is the patch for skip_entry, I cannot check this patch on my side,
so please check it and let me know the feedbacks:
>From ff5a4d728b42af867dc8f6aef43107c7a015a5b4 Mon Sep 17 00:00:00 2001
From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Mon, 16 Mar 2009 17:06:49 +0530
Subject: [PATCH] x86: mpparse cleanup

Impact: cleanup

Introduced helper function skip_entry and check_irq_src

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/mpparse.c |  179 ++++++++++++++++++++-------------------------
 1 files changed, 78 insertions(+), 101 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 47673e0..f1cf457 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -68,9 +68,9 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	generic_processor_info(apicid, m->apicver);
 }
 
-#ifdef CONFIG_X86_IO_APIC
 static void __init MP_bus_info(struct mpc_bus *m)
 {
+#ifdef CONFIG_X86_IO_APIC
 	char str[7];
 	memcpy(str, m->bustype, 6);
 	str[6] = 0;
@@ -108,11 +108,10 @@ static void __init MP_bus_info(struct mpc_bus *m)
 #endif
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
+#endif /* CONFIG_X86_IO_APIC */
 }
-#endif
 
 #ifdef CONFIG_X86_IO_APIC
-
 static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
@@ -127,9 +126,11 @@ static int bad_ioapic(unsigned long address)
 	}
 	return 0;
 }
+#endif /* CONFIG_X86_IO_APIC */
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
+#ifdef CONFIG_X86_IO_APIC
 	if (!(m->flags & MPC_APIC_USABLE))
 		return;
 
@@ -145,25 +146,32 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	mp_ioapics[nr_ioapics].apicver = m->apicver;
 	mp_ioapics[nr_ioapics].flags = m->flags;
 	nr_ioapics++;
+#endif /* CONFIG_X86_IO_APIC */
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
 {
+#ifdef CONFIG_X86_IO_APIC
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
 		m->srcbusirq, m->dstapic, m->dstirq);
+#endif /* CONFIG_X86_IO_APIC */
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
+#ifdef CONFIG_X86_IO_APIC
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->irqtype, mp_irq->irqflag & 3,
 		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
+#endif /* CONFIG_X86_IO_APIC */
 }
 
+#ifdef CONFIG_X86_IO_APIC
+
 static void __init assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
@@ -275,6 +283,12 @@ static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
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
@@ -310,55 +324,27 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
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
@@ -850,15 +836,46 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 #endif
 
+static int check_irq_src(struct mpc_intsrc *m)
+{
+#ifdef CONFIG_X86_IO_APIC
+	int i, nr_m_spare = 0;
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
+#endif /* CONFIG_X86_IO_APIC */
+}
+
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
 					unsigned long mpc_new_length)
 {
 #ifdef CONFIG_X86_IO_APIC
 	int i;
-	int nr_m_spare = 0;
 #endif
-
+	int nr_m_spare = 0;
 	int count = sizeof(*mpc);
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
@@ -866,61 +883,21 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
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

> 3) Get the details right. Look at the source code - should that code be
>    done like that and does it look as compact as it could be?
> 
> for example these bits:
> 
> 	while (count < mpc->mpc_length) {
> 		switch (*mpt) {
> 		case MP_PROCESSOR:
> 			{
> 				struct mpc_config_processor *m =
> 				    (struct mpc_config_processor *)mpt;
> 				mpt += sizeof(*m);
> 				count += sizeof(*m);
> 				break;
> 			}
> 		case MP_BUS:
> 
> are _way_ too wasteful with tabs - and that is causing the 80 cols 
> problems. (we'd fix this if we hadnt fixed it at step 2 already ;-)
> 
> Or these bits:
> 
> ---------------->
> static int  __init replace_intsrc_all(struct mp_config_table *mpc,
> 					unsigned long mpc_new_phys,
> 					unsigned long mpc_new_length)
> {
> #ifdef CONFIG_X86_IO_APIC
> 	int i;
> 	int nr_m_spare = 0;
> #endif
> 
> 	int count = sizeof(*mpc);
> 	unsigned char *mpt = ((unsigned char *)mpc) + count;
> <----------------
> 
> are more readable as:
> 
> ---------------->
> static int  __init
> replace_intsrc_all(struct mpc_table *mpc,
> 		   unsigned long mpc_new_phys,
> 		   unsigned long mpc_new_length)
> {
> 	unsigned char *mpt = (void *)mpc;
> 	int count = 0;
> 
> 	skip_entry(&mpt, &count, sizeof(struct mpc_table));
> <----------------
> 

Already fixed earlier.

Thanks,
--
JSR

