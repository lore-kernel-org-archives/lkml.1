Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYHYSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYHYSBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYHYSBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:01:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbYHYSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:01:02 -0400
Date: Mon, 25 Aug 2008 11:00:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <48B2A421.7080705@hp.com>
Message-ID: <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com>
 <48B2A421.7080705@hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Aug 2008, Alan D. Brunelle wrote:
>
> Before adding any more debugging, this is the status of my kernel boots:
> 3 times in a row w/ this same error. (Primary problem is the same,
> secondary stacks differ of course.)

Ok, so I took a closer look, and the oops really is suggestive..

> [    6.482953] busybox used greatest stack depth: 4840 bytes left

Ok, 4840 bytes left out of 8kB.

> [    6.521876] all_generic_ide used greatest stack depth: 4784 bytes left

.. and this one is 4784 bytes left..

> Begin: Loading essential drivers... ...
> [    6.625509] fuse init (API version 7.9)
> [    6.625509] modprobe used greatest stack depth: 1720 bytes left

Uhhuh! The previous "modprobe" uses stack like mad.  It could be 
"fuse_init()" that has done it, but looking at fuse, I seriously doubt it. 
It doesn't seem to do anything particularly bad.

So something has used over 6kB of stack, and it may well be the module 
loading code itself.

The next stage is the actual oops itself:

> [    6.644854] ACPI: SSDT CFFD0D0A, 08C4 (r1 HPQOEM  CPU_TM2        1 MSFT  100000E)
> [    6.651489] BUG: unable to handle kernel NULL pointer dereference at 0000000000000858

This really looks like

	ti->task->blocked_on = waiter;

where "ti->task" is NULL. You probably have almost everything enabled in 
order to turn "struct task_struct" that big, but judging by your register 
state it's really an offset off a NULL pointer, not some small integer.

Now, there is no way "ti->task" can _possibly_ be NULL. No way.

Well, except that "ti" is just below the stack, and if you had a stack 
overflow that overwrote it.

So I seriously do believe that you have run out of stack. If that is true, 
then it's quite likely that with DEBUG_PAGE_ALLOC you'll actually get a 
double fault, which in turn is fairly hard to debug (you look at it wrong 
and it turns into a triple fault which is going to just reboot your 
machine immediately).

Now, the stack oveflow probably happened a few calls earlier (and just 
left your thread_info corrupted), but there is more reason to believe you 
have stack overflow and thread_info corruption later in your output:

> [    7.024992] modprobe used greatest stack depth: 408 bytes left  
> [    7.030988] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> [    7.031053] IP: [<ffffffff8023f39c>] do_exit+0x28c/0xa10

Here there is only 408 bytes left, which is _way_ too little, but it's 
also an optimistic measure. What the stack code usage code does is to just 
see how many zeroes it can find on the stack. If you have a big stack 
frame somewhere, it's quite possible that it actually used all your stack 
and then some, but left a bunch of zeroes around.

And the do_exit() oops is simply because once the thread_info is 
corrupted, all the basic thread data structures are crap, and yes, you're 
almost guaranteed to oops at that point.

Could you make your kernel image available somewhere, and we can take a 
look at it? Some versions of gcc are total pigs when it comes to stack 
usage, and your exact configuration matters too.  But yes, module loading 
is a bad case, for me "sys_init_module()" contains

	subq    $392, %rsp      #,

which is probably mostly because of the insane inlining gcc does (ie it 
will likely have inlined every single function in that file that is only 
called once, and then it will make all local variables of all those 
functions alive over the whole function and allocate stack-space for them 
ALL AT THE SAME TIME).

Gcc sometimes drives me mad. It's inlining decisions are almost always 
pure and utter sh*t. But clearly something changed for you to start 
triggering this, and I think that also explains why you bisected things to 
the merge commit rather than to any individual change - because it was 
probably not any individual change that pushed it over the limit, but two 
different changes that made for bigger stack pressure, and _together_ they 
pushed you over the limit.

So it also explains why the merge you found had no possible merge errors 
on a source level - there were no actual clashes anywhere. Just a slow 
growth of stack that combined to something that overflowed.

And yes, I bet the change by Arjan to use do_one_initcall() was _part_ of 
it. It adds roughly 112 bytes of stack pressure to that module loading 
path, because of the 64-byte array and the extra function call (8 bytes 
for return address) with at least 5 quad-words saved (40 bytes) for 
register spills.

But there were probably other things happening too that made things worse.

So if there is some place where you can upload your 'vmlinux' binary, it 
would be good.

			Linus
