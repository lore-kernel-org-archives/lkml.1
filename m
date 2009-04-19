Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZDSXxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZDSXxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZDSXxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:53:24 -0400
Received: from gw.goop.org ([64.81.55.164]:60258 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZDSXxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:53:23 -0400
Message-ID: <49EBB96F.60300@goop.org>
Date: Sun, 19 Apr 2009 16:53:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>	 <20090408145440.GN12931@elte.hu> <1239203512.4557.2575.camel@laptop> <49EAF9D6.1010600@redhat.com>
In-Reply-To: <49EAF9D6.1010600@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> What are the slight differences in requirements?
>
> KVM wants to run in non-preemptible, interrupts-enabled context.

There are two hooks: arch_start_context_switch() in 
kernel/sched:context_switch(), and arch_end_context_switch() in 
arch/x86/kernel/process_(32|64).c.  They bound the heart of the context 
switch in which various bits of core state is changes, like the cr3 
reload, fpu TS flag, iopl, tls slots, etc.  All things which require a 
hypercall in a paravirtualized environment, and so can be batched 
together into a multicall (or whatever) to minimize the number of 
context-switch time hypercalls.  The placement of end_context_switch is 
particularly sensitive because it needs to be in the right place 
relative to fpu context reload and segment register reloading.

Preemption is definitely disabled, and interrupts as well, I think.  So 
perhaps these won't work for you.

However, looking at the fire_sched_out_preempt_notifiers() is almost in 
the same position as arch_start_context_switch(), so I think they could 
be unified one way or the other.  The sched_in notifier happens way too 
late though.  Does KVM just use both in and out, or just one?

    J
