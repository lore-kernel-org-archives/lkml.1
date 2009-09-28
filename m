Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbZI1QIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbZI1QIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZI1QIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:08:04 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41149 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZI1QIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=delmGjh/MVoOpjTCzXqGAkL8hD9kGefx6J8+U9b9pcQh4QGwB19LW8Lsk3+mxJTpI7
         nzz05K4mbF1JGf1Q4C+rfpMRhWlqoxq7rxyH+eJNGUT63QsRgf5lMagKX4cw5l5stbRr
         6NfSQo/gvf3sYY590L2be8nqsjO9z2xr+XmMI=
Date: Mon, 28 Sep 2009 20:07:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add show_lapic=
Message-ID: <20090928160757.GD5264@lenovo>
References: <4ABF0DE0.1030400@kernel.org> <20090927080605.GA4984@lenovo> <4ABF2262.3090905@kernel.org> <20090927085406.GB4984@lenovo> <20090927102805.GC4984@lenovo> <20090927144008.GD4984@lenovo> <20090927174219.GA14280@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927174219.GA14280@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai, if you still need show_lapic=1 by default the
acceptable solution (I guess) could be that we accept
show_lapic=all as well. So a user may safely put it without
knowing how many apics he has.

Does it look acceptable for you? Something like (tested) below.
Also I think maybe we should better extend apic= option itself instead
of intruducing new one?

Anyway, what you think? (again, if you like this patch -- SOB it, Ack it,
or whatever you want).
---
[PATCH -tip] x86,apic: limit apic dumping, introduce show_lapic setup option

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
