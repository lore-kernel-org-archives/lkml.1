Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZI0IGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZI0IGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZI0IGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:06:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:31146 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZI0IGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=glHy8K6fJDrBV3YXIMilAtIQbWh3W+uN1BQuwnxChvx2JNYG+azDYZ2GpV9OyblB2a
         Jdcrm1uLdbNGKHwpDPLbL5FljwcIzwXvj2t2bP9E7mDeL3MtDPhLGdlMooS5r6BHhDyI
         1RC4ShTSaGtCiDXKpD5tEonQ+wev+Nvlkpl+g=
Date: Sun, 27 Sep 2009 12:06:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add show_lapic=
Message-ID: <20090927080605.GA4984@lenovo>
References: <4ABF0DE0.1030400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABF0DE0.1030400@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sun, Sep 27, 2009 at 12:01:52AM -0700]
| 
| so could use that together with apci=debug to print less cpu apic.
| 
| otherwise for system have more cpus will take a while
| 
| also move apic_verbosity check to print_all_ICs
| 
| Signed-off-by: Yinghai Lu <yinghai@kernel.org>
| 
| ---
|  arch/x86/kernel/apic/io_apic.c |   42 ++++++++++++++++++++++++++---------------
|  1 file changed, 27 insertions(+), 15 deletions(-)
...

Hi Yinghai, good idea!

I've tuned your patch a bit together with changelog.

1) show_lapic=1 by default does change current kernel behaviour
   so it should be set to max cpu available.
2) show_lapic contains the max number of lapics being printed
   so we need to count them instead of plain comparation with
   cpu number, as a result I've changed print_local_APICs. Or
   you meant _exactly_ cpuid number? In meaning like
   show_lapic=max_cpuid. Hmm?

Someting like this perhaps?

(I keep you SOB since I've touched a few lines only)

How do you think?
---
[PATCH -tip] x86,apic: introduce show_lapic setup option

In case if a system has a large number of cpus printing apics
contents may consume a long time period. So to control it
we introduce "show_lapic" setup option which allow us to limit
the number of APICs being dumped.

Also move apic_verbosity check up so helpers routine do not
need to check it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/io_apic.c |   43 ++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

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
+__apicdebuginit(void) print_local_APICs(int napics)
 {
 	int cpu;
 
+	if (!napics)
+		return;
+
 	preempt_disable();
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
+		if (!napics--)
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
@@ -1866,21 +1863,37 @@ __apicdebuginit(void) print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-__apicdebuginit(int) print_all_ICs(void)
+static int __initdata show_lapic = NR_CPUS;
+static __init int setup_show_lapic(char *arg)
 {
+	int num;
+
+	get_option(&arg, &num);
+	if (num >= 0)
+		show_lapic = num;
+
+	return 1;
+}
+__setup("show_lapic=", setup_show_lapic);
+
+__apicdebuginit(int) print_ICs(void)
+{
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
