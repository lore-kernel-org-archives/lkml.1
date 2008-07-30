Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbYG3Ao1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbYG3Ao1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYG3AoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:44:18 -0400
Received: from gw.goop.org ([64.81.55.164]:51491 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbYG3AoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:44:17 -0400
Message-ID: <488FB95A.1000402@goop.org>
Date: Tue, 29 Jul 2008 17:44:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function call
 IPIs
References: <488FA8A9.6000005@goop.org> <20080730001358.GA23938@one.firstfloor.org>
In-Reply-To: <20080730001358.GA23938@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Jul 29, 2008 at 04:32:57PM -0700, Jeremy Fitzhardinge wrote:
>   
>> This adds 8 queues for smp_call_function(), in order to avoid a
>>     
>
> Now that we have per CPU IDT and there's no global bottleneck anymore
> I think it would be actually fine to use
> more than 8 vectors. 32 or 64 might be a better default.
>   

Well, there's no point in having more vectors than CPUs, and a bit of 
doubling up doesn't hurt too much.  So I think 8 is a good default for 
normal sized machines.  But I can see that being able to add more 
vectors for large machines might be helpful.  I guess it really depends 
on what the fan-out is for multicast messages.

I dunno, maybe it makes sense to take numa topology into account, on the 
assumption that 1) most cross-cpu function calls will be tlb flushes now 
(or at least, sending to mm->cpu_vm_mask), and 2) most tlb flushes will 
be between cpus within one node.

>> void native_send_call_func_ipi(cpumask_t mask)
>> {
>> 	cpumask_t allbutself;
>> +	unsigned queue = smp_processor_id() % CONFIG_GENERIC_SMP_QUEUES;
>>     
>
> Does this really always run with preemption disabled?

Think so, but I'll check again.  One of my TODO list items is to check 
whether smp_call_function_mask should disable preemption for itself, or 
at least WARN_ON if its called with preemption enabled.

    J
