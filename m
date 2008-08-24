Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYHXRRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYHXRRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYHXRRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:17:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYHXRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:17:35 -0400
Message-ID: <48B19799.6090703@kernel.org>
Date: Sun, 24 Aug 2008 10:17:13 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>	 <20080820013930.GN9807@one.firstfloor.org>	 <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>	 <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>
In-Reply-To: <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010807080301070701040809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010807080301070701040809
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Vegard Nossum wrote:
> 
> Hm.
> 
> Kernel fails to detect cpu1 at all.
> 
> I am currently unsure of whether it's your patch or not. But it's the
> same config that I've been booting for ages (and I copy it over for
> each new kernel version I check out).
> 
> Processor #0 (Bootup-CPU)
> I/O APIC #2 Version 32 at 0xFEC00000.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Processors: 1
> SMP: Allowing 1 CPUs, 0 hotplug CPUs
> mapped APIC to ffffb000 (fee00000)
> mapped IOAPIC to ffffa000 (fec00000)
> Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
> PERCPU: Allocating 1221764 bytes of per cpu data
> NR_CPUS: 7, nr_cpu_ids: 1, nr_node_ids 1
> 
> I really don't get it. Is this something that can be caused by your
> patch _at all_ ?
> 

Could you try this patch?  It should (hopefully) tell us if there is any 
such invocations and what the call trace looks like.

	-hpa

--------------010807080301070701040809
Content-Type: text/x-patch;
 name="smp-unplug-fault2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smp-unplug-fault2.patch"

diff --git a/kernel/smp.c b/kernel/smp.c
index 782e2b9..95e1bad 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -210,8 +210,10 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 {
 	struct call_single_data d;
 	unsigned long flags;
-	/* prevent preemption and reschedule on another processor */
+	/* prevent preemption and reschedule on another processor,
+	   as well as CPU removal */
 	int me = get_cpu();
+	int err = 0;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -220,7 +222,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
-	} else {
+	} else if ((unsigned)cpu < NR_CPUS && cpu_online(cpu)) {
 		struct call_single_data *data = NULL;
 
 		if (!wait) {
@@ -236,10 +238,13 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 		data->func = func;
 		data->info = info;
 		generic_exec_single(cpu, data);
+	} else {
+		BUG();
+		err = -ENXIO;	/* CPU not online */
 	}
 
 	put_cpu();
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(smp_call_function_single);
 

--------------010807080301070701040809--
