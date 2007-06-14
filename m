Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXFNGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXFNGtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXFNGtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:49:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbXFNGtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:49:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Friday, 1 June 2007 15:39:01 -0400 <Pine.LNX.4.44L0.0706011351010.6920-100000@iolanthe.rowland.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070614064835.8BFBA4D059F@magilla.localdomain>
Date: Wed, 13 Jun 2007 23:48:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I really don't understand your point here.  What's wrong with bp_show?  
> Is it all the preprocessor conditionals?  I thought that was how we had 
> agreed portable code should determine which types and lengths were 
> supported on a particular architecture.

That part is fine.  The problem is fetching the hw_breakpoint.len field
directly and expecting it to contain the API values.  In an implementation
done as I've been referring to, there is no need for any field to contain
the HW_BREAKPOINT_LEN_8 value, and it's a waste to store one.  If it were
hw_breakpoint_get_len(bp), that would be fine.

> Consider that the definition of struct hw_breakpoint is in
> include/asm-generic/.  [...]
> The one thing which makes sense to me is that some architectures might 
> want to store type and/or length bits in along with the address field.  

Indeed, that is the natural thing (and all the bits needed) on several.
I hadn't raised this before since I was having so much trouble already
convincing you about storing things in machine-dependent fashion so that
users cannot just use the struct fields directly.

I really think it would be cleanest all around to use just:

	struct arch_hw_breakpoint info;

in place of address union, len, type in struct hw_breakpoint.  Then each
arch provides hw_breakpoint_get_{kaddr,uaddr,len,type} inlines.  For
storing, each arch can define hw_breakpoint_init(addr, len, type) (or
maybe k/u variants).  This can be used by callers directly if you want to
keep register_hw_breakpoint to one argument, or could just be internal if
register_hw_breakpoint takes the three more args.  If callers use it
directly, there can also be an INIT_ARCH_HW_BREAKPOINT(addr, len, type)
for use in struct hw_breakpoint_init initializers.

On x86 use:

	struct arch_hw_breakpoint_info {
		union {
			const void		*kernel;
			const void	__user	*user;
			unsigned long		va;
		}		address;
		u8		len;
		u8		type;
	} __attribute__((packed));

and the size of struct hw_breakpoint won't increase.

> > What about DR_STEP?  i.e., if DR_STEP was set from a single-step and then
> > there was a DR_TRAPn debug exception, is DR_STEP still set?  If DR_TRAPn
> > was set and then you single-step, is DR_TRAPn cleared?
> 
> I didn't experiment with using DR_STEP.  There wasn't any simple way to
> cause a single-step exception.  Perhaps if I were more familiar with
> kprobes...

It's easy for user mode with gdb.  kprobes is simple to use, and it
always does a single-step to execute (a copy of) the instruction that 
was overwritten with the breakpoint.  So, write a module that does:

	int testvar=0;
	asm(".globl testme; testme: movl $17,testvar; ret");
	void testme();
	testinit() {
		... register kprobe at &testme ...
		... register hw_breakpoint at &testvar ...
		testme()
	}

Your kprobe handlers don't have to actually do anything at all, if you
are just hacking the low-level code so see what %dr6 values you get at
each trap.

> I decided on something simpler than messing around with Kconfig.  

I still think it's the proper thing to make it conditional, not always
built in.  But it's a pedantic point.

> This is getting pretty close to a final form.  The patch below is for 
> 2.6.22-rc3.  See what you think...

Indeed I think we have come nearly as far as we will before we have a few
arch ports get done and some heavy use to find the rough edges.  Thanks
very much for being so accomodating to all my criticism, which I hope has
been constructive.

> +inline const void *hw_breakpoint_get_kaddr(struct hw_breakpoint *bp)

These need to be static inline.  Here you're defining a global function
in every .o file that uses the header.

> +	get_debugreg(dr6, 6);
> +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> +	if (dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
> +		tsk->thread.vdr6 = 0;

Some comment here about this conditional clearing, please.

> +
> +/*
> + * HW breakpoint additions
> + */
> +
> +#define HB_NUM		4	/* Number of hardware breakpoints */

Need #ifdef __KERNEL__ around all these additions to debugreg.h.

> +static inline void arch_update_thbi(struct thread_hw_breakpoint *thbi,

For local functions in a source file (not a header), it's standard form
now just to define them static, not static inline.  For these trivial
ones, the compiler will always inline them.


Thanks,
Roland
