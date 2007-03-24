Return-Path: <linux-kernel-owner+w=401wt.eu-S2992630AbXCXAOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992630AbXCXAOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992640AbXCXAOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:14:41 -0400
Received: from tapsys.com ([72.36.178.242]:37990 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992630AbXCXAOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:14:40 -0400
Message-ID: <46046D6D.3030202@madrabbit.org>
Date: Fri, 23 Mar 2007 17:14:37 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: tglx@linutronix.de, Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	 <20070323184828.GP752@stusta.de>
In-Reply-To: <20070323184828.GP752@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2007-03-23 at 19:48 +0100, Adrian Bunk wrote:
>> Subject    : x86_64: ACPI regression with noapic  (APICTIMER_STOPS_ON_C3?)
>> References : http://lkml.org/lkml/2007/3/8/468
>>              http://lkml.org/lkml/2007/3/22/156
>> Submitter  : Ray Lee <ray-lk@madrabbit.org>
>> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>> Status     : problem is being debugged
> 
> Ray,
> 
> can you please test the patch below ?
> 
> Thanks,
> 
> 	tglx

(I wondered about the IPI on a UP system, seemed a bit weird :-).)

Works great, booting both with NOAPIC and without. *Much* thanks for
debugging this while you're also handling a bunch of other issues at
the same time.

Patch reproduced below, with an acked-by (and, uhm, a couple of spelling
fixes in the description -- don't hate me, 'kay?). Please apply before
2.6.21 final.

------------------>
Subject: [PATCH] x86_64: avoid sending LOCAL_TIMER_VECTOR IPI to itself

Ray Lee reported, that on an UP kernel with "noapic" command line option
set, the box locks hard during boot.

Adding some debug printks revealed, that the last action on the box
before stalling was "Send IPI" - a debug printk which was put into
smp_send_timer_broadcast_ipi().

It seems that send_IPI_mask(mask, LOCAL_TIMER_VECTOR) fails when
"noapic" is set on the command line on an UP kernel.

Aside of that it does not make much sense to trigger an interrupt
instead of calling the function directly on the CPU which gets the
PIT/HPET interrupt in case of broadcasting.

Reported-by: Ray Lee <ray-lk@madrabbit.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by:  Ray Lee <ray-lk@madrabbit.org>

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 723417d..83328e1 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -930,9 +930,17 @@ EXPORT_SYMBOL(switch_APIC_timer_to_ipi);

 void smp_send_timer_broadcast_ipi(void)
 {
+	int cpu = smp_processor_id();
 	cpumask_t mask;

 	cpus_and(mask, cpu_online_map, timer_interrupt_broadcast_ipi_mask);
+
+	if (cpu_isset(cpu, mask)) {
+		cpu_clear(cpu, mask);
+		add_pda(apic_timer_irqs, 1);
+		smp_local_timer_interrupt();
+	}
+
 	if (!cpus_empty(mask)) {
 		send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 	}


