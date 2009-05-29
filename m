Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZE2DPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZE2DPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZE2DPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:15:40 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52089 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZE2DPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:15:38 -0400
Date: Fri, 29 May 2009 13:15:34 +1000
From: David Gibson <dwg@au1.ibm.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 03/12] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090529031534.GA8621@yookeroo.seuss>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@au1.ibm.com>,
	maneesh@linux.vnet.ibm.com, Roland McGrath <roland@redhat.com>,
	Masami Hiramatsu <mhiramat@redhat.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115303.GD25673@in.ibm.com> <20090528063515.GB3091@yookeroo.seuss> <20090528134151.GA4257@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528134151.GA4257@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 07:11:51PM +0530, K.Prasad wrote:
> On Thu, May 28, 2009 at 04:35:15PM +1000, David Gibson wrote:
> > On Mon, May 11, 2009 at 05:23:03PM +0530, K.Prasad wrote:
> > > This patch introduces the arch-specific implementation of
> > > hw_breakpoint.c inside x86 specific directories. They contain
> > > functions which help validate and serve requests for using Hardware
> > > Breakpoint registers on x86 processors.
> > 
> > [snip]
> > > +static int get_hbp_len(u8 hbp_len)
> > > +{
> > > +	unsigned int len_in_bytes = 0;
> > > +
> > > +	switch (hbp_len) {
> > > +	case HW_BREAKPOINT_LEN_1:
> > > +		len_in_bytes = 1;
> > > +		break;
> > > +	case HW_BREAKPOINT_LEN_2:
> > > +		len_in_bytes = 2;
> > > +		break;
> > > +	case HW_BREAKPOINT_LEN_4:
> > > +		len_in_bytes = 4;
> > > +		break;
> > > +#ifdef CONFIG_X86_64
> > > +	case HW_BREAKPOINT_LEN_8:
> > > +		len_in_bytes = 8;
> > > +		break;
> > > +#endif
> > 
> > Hrm, the fact that you have to do this nasty back-conversion again
> > makes me wonder at the wisdom of having per-arch encodings for
> > breakpoint length.
> 
> If you're suggesting that users would specify the length of the requested
> breakpoint directly as numerals (like 2, 4 or 8 bytes) and not
> pre-defined constants such as HW_BREAKPOINT_LEN, it has two implications
> to it. By defining the permissible values for breakpoint length, the
> user is assured that the request for breakpoint registration is valid
> (atleast in terms of length) and does not have to refer the
> code/processor manual for supported address lengths on the host
> processor.

I don't see why looking up permitted breakpoint lengths in the
processor manual (or a summary thereof) is any harder than looking up
the permitted breakpoint length constants for this arch in the headers
or breakpoint interface documentation.

Changing the length to be specified as integers would move enforcement
of this check from compile time to runtime.  It's not yet clear to me
which is better.  Compile time checking is often good.  But I think
we'll need runtime checking as well for architectures where different
cpu generations have different debug facilities with different
capabilities.

> On the other hand, it may be perceived as being less user-friendly
> as you cited above.
> 
> Given the above reasoning, do you prefer to allow numeric values
> specified by the user?

I'm not sure yet.

> > > +	}
> > > +	return len_in_bytes;
> > > +}
> > > +
> > > +/*
> > > + * Check for virtual address in user space.
> > > + */
> > > +int arch_check_va_in_userspace(unsigned long va, u8 hbp_len)
> > > +{
> > > +	unsigned int len;
> > > +
> > > +	len = get_hbp_len(hbp_len);
> > > +
> > > +	return (va <= TASK_SIZE - len);
> > > +}
> > > +
> > > +/*
> > > + * Check for virtual address in kernel space.
> > > + */
> > > +int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
> > > +{
> > > +	unsigned int len;
> > > +
> > > +	len = get_hbp_len(hbp_len);
> > > +
> > > +	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> > > +}
> > > +
> > > +/*
> > > + * Store a breakpoint's encoded address, length, and type.
> > > + */
> > > +static int arch_store_info(struct hw_breakpoint *bp)
> > 
> > This function doesn't look very arch specific.  Nor is the name very
> > meaningful.
> > 
> 
> The function populates arch-specific fields and hence the arch_ prefix.
> I am open to any suggestions that will be incorporated in future
> enhancements.

Hrm, I suppose.  I guess the name lookup looks as if it ought to be
possible to make generic.

[snip]
> > > +/*
> > > + * Handle debug exception notifications.
> > > + */
> > > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > > +{
> > > +	int i, cpu, rc = NOTIFY_STOP;
> > > +	struct hw_breakpoint *bp;
> > > +	/* The DR6 value is stored in args->err */
> > > +	unsigned long dr7, dr6 = args->err;
> > > +
> > > +	/* Do an early return if no trap bits are set in DR6 */
> > > +	if ((dr6 & DR_TRAP_BITS) == 0)
> > > +		return NOTIFY_DONE;
> > > +
> > > +	/* Lazy debug register switching */
> > > +	if (!test_tsk_thread_flag(current, TIF_DEBUG))
> > > +		switch_to_none_hw_breakpoint();
> > 
> > Shouldn't you also drop out of the handler here, rather than having to
> > again check for a false alarm below.
> 
> No. We could be inside the handler because of a kernel-space breakpoint
> and still have the above condition true.

Ah, yes, missed that.

But.. if it's a kernel breakpoint, surely the debug state of the
current thread shouldn't affect its actions at all.  So shouldn't you
be checking whether it's a kernel or user breakpoint first?

> > It's also not immediately clear to me how lazy switching buys you
> > anything here, since it's only lazy switching off, not lazy switching
> > on.
> 
> In this code-snippet from __switch_to() in arch/x86/kernel/process_32.c,
> 
>         if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
>                 arch_install_thread_hw_breakpoint(next_p);
> 
> we only check if 'next_p' has TIF_DEBUG flag set in order to enable
> breakpoints, but don't clear the physical debug registers if 'prev'
> process had used them (can be detected by testing for TIF_DEBUG).
> This saves us one additional check in the hot-path but we might
> encounter stray exceptions due to lazy debug register switching.
> 
> Such exceptions are detected in the above code, resulting in the
> physical debug registers being cleared-off their stale values and the
> exception being ignored.

Right, I understand what it does, just not whether it really buys
anything.  It smells of premature optimization, since I don't think
the context switch path is actually hot enough to be bothered by one
flag check.  But whatever.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
