Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbZJMULs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbZJMULs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934325AbZJMULf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:26320 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbZJMULd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=ni+PsPViCBRXKSC2JYRYEvXcweeFRIEuYitMcLW2d9hAUNvRht2kXAKlCws3EI04zz
         N5Jddj8vPdUJAXFJNTau4tMfhj+VMLrWre/90jvN7X19RpmOg+x/TnP/wagCwFdLmCBj
         3u8pqSBHfEBhHhmS3QzuKHKgZ4/DH0z2gn8Wo=
Message-Id: <20091013201022.926793122@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 00:07:05 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic setup option
References: <20091013200702.019870576@openvz.org>
Content-Disposition: inline; filename=x86-apic-show-apic-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if a system has a large number of cpus printing apics
contents may consume a long time period.

We limit such an output by 1 apic by default. But to have an
ability to see all apics or some part of them we introduce
"show_lapic" setup option which allow us to limit/unlimit
the number of APICs being dumped.

Example: apic=debug show_lapic=5, or apic=debug show_lapic=all

Also move apic_verbosity checking upper that way so helper routines
do not need to inspect it at all.

Suggested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/io_apic.c |   47 +++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 15 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -1599,9 +1599,6 @@ __apicdebuginit(void) print_IO_APIC(void
 	struct irq_desc *desc;
 	unsigned int irq;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
@@ -1708,9 +1705,6 @@ __apicdebuginit(void) print_APIC_field(i
 {
 	int i;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG);
 
 	for (i = 0; i < 8; i++)
@@ -1724,9 +1718,6 @@ __apicdebuginit(void) print_local_APIC(v
 	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
@@ -1824,13 +1815,19 @@ __apicdebuginit(void) print_local_APIC(v
 	printk("\n");
 }
 
-__apicdebuginit(void) print_all_local_APICs(void)
+__apicdebuginit(void) print_local_APICs(int maxcpu)
 {
 	int cpu;
 
+	if (!maxcpu)
+		return;
+
 	preempt_disable();
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
+		if (cpu >= maxcpu)
+			break;
 		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
+	}
 	preempt_enable();
 }
 
@@ -1839,7 +1836,7 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (apic_verbosity == APIC_QUIET || !nr_legacy_irqs)
+	if (!nr_legacy_irqs)
 		return;
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1866,21 +1863,41 @@ __apicdebuginit(void) print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-__apicdebuginit(int) print_all_ICs(void)
+static int __initdata show_lapic = 1;
+static __init int setup_show_lapic(char *arg)
+{
+	int num = -1;
+
+	if (strcmp(arg, "all") == 0) {
+		show_lapic = CONFIG_NR_CPUS;
+	} else {
+		get_option(&arg, &num);
+		if (num >= 0)
+			show_lapic = num;
+	}
+
+	return 1;
+}
+__setup("show_lapic=", setup_show_lapic);
+
+__apicdebuginit(int) print_ICs(void)
 {
+	if (apic_verbosity == APIC_QUIET)
+		return 0;
+
 	print_PIC();
 
 	/* don't print out if apic is not there */
 	if (!cpu_has_apic && !apic_from_smp_config())
 		return 0;
 
-	print_all_local_APICs();
+	print_local_APICs(show_lapic);
 	print_IO_APIC();
 
 	return 0;
 }
 
-fs_initcall(print_all_ICs);
+fs_initcall(print_ICs);
 
 
 /* Where if anywhere is the i8259 connect in external int mode */

