Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZHCBt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZHCBt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZHCBt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:49:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:39246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZHCBt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:49:56 -0400
Message-ID: <4A76421E.3040005@kernel.org>
Date: Mon, 03 Aug 2009 10:49:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 01:49:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
> I just noticed another issue on x86 code generation, since I was looking 
> at assembly language generation due to the do_sigaltstack() kernel stack 
> info leak thing.
> 
> Our "get_current()" seriously sucks now that it's a per-cpu variable.
> 
> Look at the code generated for something like
> 
> 	current->sas_ss_sp = (unsigned long) ss_sp;
> 	current->sas_ss_size = ss_size;
> 
> and notice how the code really really sucks:
> 
>         movq %gs:per_cpu__current_task,%rcx
>         movq    %rdx, 1152(%rcx)
>         movq %gs:per_cpu__current_task,%rdx
>         movq    %rax, 1160(%rdx)

Right.  This isn't new tho.  In practive, the current percpu_read()
thingies behave identically to the original x86_read_percpu().  2.6.29
generates about the same code.

(This is from the object file so the offsets haven't been set yet)

(gdb) disassemble block_all_signals
Dump of assembler code for function block_all_signals:
...
0x000000000000168a <block_all_signals+74>:      mov    %gs:0x0,%rax
0x0000000000001693 <block_all_signals+83>:      mov    %r12,0x4e0(%rax)
0x000000000000169a <block_all_signals+90>:      mov    %gs:0x0,%rax
0x00000000000016a3 <block_all_signals+99>:      mov    %r13,0x4d8(%rax)
0x00000000000016aa <block_all_signals+106>:     mov    %gs:0x0,%rax
0x00000000000016b3 <block_all_signals+115>:     mov    %r14,0x4d0(%rax)
0x00000000000016ba <block_all_signals+122>:     mov    %gs:0x0,%rax
0x00000000000016c3 <block_all_signals+131>:     mov    0x488(%rax),%rdi
...

...
> End result: the above horror becomes a more reasonable
> 
>         movq %gs:per_cpu__current_task,%rax
>         movq    %rcx, 1152(%rax)
>         movq    %rdx, 1160(%rax)
> 
> instead (it still doesn't cache it over the whole function, but it's 
> certainly better).
>
> NOTE! I did not test that it all worked. I only looked at the asm, and 
> checked out the improvements. All the ones I looked at looked reasonable.

Cool.  I'm currently testing the kernel.  It has booted fine on 8-core
2-way NUMA machine and repetetively compiling kernel w/ -j16.
Everything seems to work fine till now.

> Worthwhile? You be the judge.

I think it's definitely worthwhile.  The gain is significant compared
to the added miniscule complexity.

"current" is a per-thread variable implemented as a per-cpu variable.
Given that we don't have many of them yet and they're accessed via
arch-specific accessors, percpu_read_stable() seems like a pretty good
solution to me.

If we ever need more thread variables, we might venture into using %fs
and maybe __thread if other archs can be converted similarly but I
think we're better off with packing such things in task_struct -
per-thread is far scarier than per-cpu scalability-wise.

> There's another detail that may be worth looking at: we often get 
> 'current' and 'thread_info' together, and they are _not_ in the same 
> cache-line. It might be worth defining them together in the per-cpu data, 
> and making sure they are in the same cacheline too. In general, we should 
> probably look at which per-pcu variables are hot and read-only, and try to 
> gathe them all together.

Yeap, putting hot ones together would be great.  I'm a bit curious why
it should be hot _and_ read-only tho.  For variables which aren't
accessed too often by other cpus, read-onlyness shouldn't matter too
much, right?

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 1 Aug 2009 11:50:54 -0700
> Subject: [PATCH] x86-64: Add 'percpu_read_stable()' interface for cacheable accesses
> 
> This is very useful for some common things like 'get_current()' and
> 'get_thread_info()', which can be used multiple times in a function, and
> where the result is cacheable.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Do you want to queue it for 2.6.31?  Given that the generated code
changes compared to the previous kernels (both pre and post percpu
stuff), I think it would be safer to queue it for 2.6.32 window.  I
would be happy to carry it in the percpu tree.

Thanks.

-- 
tejun
