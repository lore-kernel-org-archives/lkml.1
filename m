Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYJESSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYJESSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYJESSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:18:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbYJESSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:18:39 -0400
Date: Sun, 5 Oct 2008 11:18:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
In-Reply-To: <20081004215225.2444d54b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810051114480.3208@nehalem.linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Oct 2008, Andrew Morton wrote:
> > Pid: 9591, comm: hwclock Tainted: G        W 2.6.27-0.372.rc8.fc10.i686 #1 
> >  [<c0427a53>] __might_sleep+0xd1/0xd6 
> >  [<c0479a8b>] lock_page+0x1a/0x34
> >  [<c0479cfa>] find_lock_page+0x23/0x48
> >  [<c047a215>] filemap_fault+0x9b/0x330
> >  [<c0486493>] __do_fault+0x40/0x2e6
> >  [<c0487d63>] handle_mm_fault+0x2ec/0x6d2
> >  [<c06e8260>] do_page_fault+0x2e5/0x693
> 
> Looks like `hwclock' disabled interrupts in userspace with sys_iopl()?

We probably should enable interrupts in the page fault code. We already do

	#ifdef CONFIG_X86_32
	        /* It's safe to allow irq's after cr2 has been saved and the vmalloc
	           fault has been handled. */
	        if (regs->flags & (X86_EFLAGS_IF | X86_VM_MASK))
	                local_irq_enable();

	        /*
	         * If we're in an interrupt, have no user context or are running in an
	         * atomic region then we must not take the fault.
	         */
	        if (in_atomic() || !mm)
	                goto bad_area_nosemaphore;
	#endif
	...

so we have code to do so, it's just that we don't do it if the page fault 
happened in an interrupt. But that's for the _kernel_ having interrupts 
disabled and us needing to fix up the vmalloc area lazily (do we ever even 
do that any more.. I dunno).

So we could easily add a check for 'user_space_vm(regs)' instead of 
checking the VM_MASK, and fix it that way. Hmm?

		Linus
