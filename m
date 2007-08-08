Return-Path: <linux-kernel-owner+w=401wt.eu-S937686AbXHHSPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937686AbXHHSPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765398AbXHHSPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:15:38 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:46630 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764281AbXHHSPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:15:37 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=rakfo/eRmFi1+GbI90ZP/7AFKSNCw6vLJNIOqPWvQ2pm4q77cW7UugWztfoyZdBgpBFjR3KrHYDGS0XucT42at6R/11EDp3CmOI5Oqz+oNhapAFl+ujAXGCTjeBOWME7;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,236,1183327200"; 
   d="diff'?scan'208";a="88115950"
Message-ID: <46BA0844.9080703@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 20:15:32 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>
Cc: Chip Coldwell <coldwell@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com> <46B8AECA.7050908@fujitsu-siemens.com> <20070808103603.GC13808@in.ibm.com> <Pine.LNX.4.64.0708081003000.29193@bogart.boston.redhat.com> <20070808144239.GA1499@in.ibm.com>
In-Reply-To: <20070808144239.GA1499@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------040004090407040601060603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040004090407040601060603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Vivek Goyal wrote:

> But the issue here seems to be that LAPIC state got clear but IRR bit
> at IOAPIC bit is not cleared because IOAPIC vector information was deleted
> in first kernel and now upon receiving EOI, it does not know this EOI belongs
> to which vector.

I am making another experiment right now. I check the LAPIC ISR flags in
machine_crash_shutdown() before disabling the LAPIC, trying to send EOI if
I find one ISR bit set. So far, I haven't seen a single case where an ISR bit
was set, but several (9) where the IO-APIC IRR bit was set. OTOH, I know that if
I'd re-enable IRQs, IRQ 225 would be raised. The whole thing is done before
disable_IO_APIC().

Don't ask me for an explanation why I don't see the ISR bits.

The arch/x86_64/kernel/crash.c portion of the patch I am using is attached for
your reference. The rest is the same as for the original patch.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html

--------------040004090407040601060603
Content-Type: text/x-patch;
 name="kdump_23.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kdump_23.diff"

--- 2.6.23-rc1/arch/x86_64/kernel/crash.c.orig	2007-06-05 11:19:07.000000000 +0200
+++ 2.6.23-rc1/arch/x86_64/kernel/crash.c	2007-08-08 18:19:15.000000000 +0200
@@ -18,18 +18,51 @@
 #include <linux/elf.h>
 #include <linux/elfcore.h>
 #include <linux/kdebug.h>
+#include <linux/interrupt.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/mach_apic.h>
+#include <asm/apic.h>
 
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
 
 #ifdef CONFIG_SMP
 static atomic_t waiting_for_crash_ipi;
+static atomic_t crash_ipi_stage2 = ATOMIC_INIT(0);
+
+extern void remove_siblinginfo(int);
+extern void remove_cpu_from_maps(void);
+extern void crash_mask_IO_APIC(int);
+
+static void ack_pending_irqs(int cpu)
+{
+	int i, j, k;
+	unsigned int value;
+	printk("APIC ISR %d:", cpu);
+	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
+		for (k = 0; k < 100; k++) {
+			value = apic_read(APIC_ISR + i*0x10);
+			if (value == 0)
+				break;
+			for (j = 31; j >= 0; j--) {
+				if (value & (1<<j)) {
+					printk (" %x", (i<<5) + j);
+					ack_APIC_irq();
+					goto next_k;
+				}
+			}
+		next_k:
+			continue;
+		}
+		if (k >= 100)
+			printk("!!!!\n");
+	}
+	printk("\n");
+}
 
 static int crash_nmi_callback(struct notifier_block *self,
 				unsigned long val, void *data)
@@ -53,13 +86,27 @@ static int crash_nmi_callback(struct not
 	local_irq_disable();
 
 	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
+	disable_APIC_timer();
+        atomic_dec(&waiting_for_crash_ipi);
+
+	while(atomic_read(&crash_ipi_stage2) == 0)
+		cpu_relax();
+ 
+ 	remove_siblinginfo(cpu);
+ 	cpu_clear(cpu, cpu_online_map);
+ 	remove_cpu_from_maps();
+ 
+	ack_pending_irqs(cpu);
+ 
+ 	disable_local_APIC();
+ 	atomic_dec(&crash_ipi_stage2);
+ 
+
 	/* Assume hlt works */
 	for(;;)
 		halt();
 
-	return 1;
+	return NOTIFY_OK;
 }
 
 static void smp_send_nmi_allbutself(void)
@@ -79,7 +126,7 @@ static struct notifier_block crash_nmi_n
 
 static void nmi_shootdown_cpus(void)
 {
-	unsigned long msecs;
+	unsigned long usecs;
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	if (register_die_notifier(&crash_nmi_nb))
@@ -93,19 +140,33 @@ static void nmi_shootdown_cpus(void)
 
 	smp_send_nmi_allbutself();
 
+	usecs = 1000000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && usecs) {
+		udelay(1);
+		usecs--;
+	}
+}
+
+static void nmi_shootdown_cpus_stage2(void)
+{
+	
+	unsigned long msecs;
+	atomic_set(&crash_ipi_stage2, num_online_cpus());
+
 	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+	while ((atomic_read(&crash_ipi_stage2) > 1) && msecs) {
 		mdelay(1);
 		msecs--;
 	}
-	/* Leave the nmi callback set */
-	disable_local_APIC();
 }
 #else
 static void nmi_shootdown_cpus(void)
 {
 	/* There are no cpus to shootdown */
 }
+static void nmi_shootdown_cpus_stage2(void)
+{
+}
 #endif
 
 void machine_crash_shutdown(struct pt_regs *regs)
@@ -121,15 +182,29 @@ void machine_crash_shutdown(struct pt_re
 	 */
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
-
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
 	crashing_cpu = smp_processor_id();
+	crash_save_cpu(regs, crashing_cpu);
+
+ 	/* disable timer interrupts */
+ 	disable_irq_nosync(0);
+ 	disable_APIC_timer();	
+ 
 	nmi_shootdown_cpus();
 
+ 	/* Mask all IRQs, and make sure they are delivered to this CPU */
+ 	crash_mask_IO_APIC(crashing_cpu);
+ 	nmi_shootdown_cpus_stage2();
+ 
+	ack_pending_irqs(crashing_cpu);
+
 	if(cpu_has_apic)
 		 disable_local_APIC();
 
+ 	/* Send EOI for pending IRQs */
+ 	/* local_irq_enable();
+	   udelay(10000);
+	   local_irq_disable(); */
+ 
 	disable_IO_APIC();
-
-	crash_save_cpu(regs, smp_processor_id());
 }

--------------040004090407040601060603--
