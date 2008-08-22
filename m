Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYHVCOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYHVCOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYHVCN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:13:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYHVCN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:13:59 -0400
Message-ID: <48AE20B8.9000204@kernel.org>
Date: Thu, 21 Aug 2008 19:13:12 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123	send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com>
In-Reply-To: <20080822003659.GA7581@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------090308090007080704010701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090308090007080704010701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dave Jones wrote:
>  > 
>  > Hm. What you say is true, but this one in particular has nothing to do
>  > with oprofile! It has something to do with reading /dev/cpu/*/msr
>  > while hot-unplugging cpu1:
>  > 
>  >  [<c011733e>] msr_read+0x6e/0xa0
>  >  [<c01a87b4>] vfs_read+0x94/0x130
>  > 
>  > I wasn't using oprofile when this happened. So I think it should also
>  > be considered a separate issue. Though yes -- CPU hotplug in general
>  > tends to break a lot of things.
> 
> From my reading of the msr code, we check that the cpu is online in ->open,
> but we never check it again, and also, we make no guarantees that it
> won't go away before we ->read or even ->close it.
> 
> Would adding a get_cpu/put_cpu across the open/close solve this?
> Peter?
> 

A get_cpu/put_cpu across the whole open..close sequence would seem to 
be, ahem, rude, since userspace could hold it for an arbitrary amount of 
time (plus, there is no guarantee that they are invoked on the same CPU.)

The cpuid driver has the same problem, obviously.

get_online_cpus() and put_online_cpus() around the call to 
{rd,wr}msr_safe_on_cpu() should work; and the CPU hotplug documentation 
seems to claim that we can just disable preemption around those calls, 
which is exactly what get_cpu()..put_cpu() does, so I guess 
get_cpu()..put_cpu() here is fine.  Now, the big question is: should 
this really be done in the MSR/CPUID drivers, or should it be done in
smp_call_function_single(), which is the generic code invoked by this?

It seems to be that doing it in smp_call_function_single() would be more 
correct as it's already protected by get_cpu()..put_cpu() and a 
cpu_online() test in there should not be expensive in comparison to the 
whole rest of the code.

You may want to see if this patch fixes the problem; it does *NOT* have 
the correct error behaviour (some of the intervening layers don't 
propagate errors), but it should make the fault go away.

	-hpa


--------------090308090007080704010701
Content-Type: text/x-patch;
 name="smp-unplug-fault.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smp-unplug-fault.patch"

diff --git a/kernel/smp.c b/kernel/smp.c
index 782e2b9..f362a85 100644
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
@@ -236,10 +238,12 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 		data->func = func;
 		data->info = info;
 		generic_exec_single(cpu, data);
+	} else {
+		err = -ENXIO;	/* CPU not online */
 	}
 
 	put_cpu();
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(smp_call_function_single);
 

--------------090308090007080704010701--
