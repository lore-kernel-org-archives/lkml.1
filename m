Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZDTGFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZDTGFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZDTGFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:05:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34703 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZDTGFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:05:01 -0400
Message-ID: <49EC1001.50905@redhat.com>
Date: Mon, 20 Apr 2009 09:02:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>	 <20090408145440.GN12931@elte.hu> <1239203512.4557.2575.camel@laptop> <49EAF9D6.1010600@redhat.com> <49EBB96F.60300@goop.org>
In-Reply-To: <49EBB96F.60300@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>> What are the slight differences in requirements?
>>
>> KVM wants to run in non-preemptible, interrupts-enabled context.
>
> There are two hooks: arch_start_context_switch() in 
> kernel/sched:context_switch(), and arch_end_context_switch() in 
> arch/x86/kernel/process_(32|64).c.  They bound the heart of the 
> context switch in which various bits of core state is changes, like 
> the cr3 reload, fpu TS flag, iopl, tls slots, etc.  All things which 
> require a hypercall in a paravirtualized environment, and so can be 
> batched together into a multicall (or whatever) to minimize the number 
> of context-switch time hypercalls.  The placement of 
> end_context_switch is particularly sensitive because it needs to be in 
> the right place relative to fpu context reload and segment register 
> reloading.
>
> Preemption is definitely disabled, and interrupts as well, I think.  
> So perhaps these won't work for you.
>
> However, looking at the fire_sched_out_preempt_notifiers() is almost 
> in the same position as arch_start_context_switch(), so I think they 
> could be unified one way or the other.  The sched_in notifier happens 
> way too late though.  Does KVM just use both in and out, or just one?

Both.  sched_out loads the host MSR_STAR and friends, sched_in loads the 
guest values.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

