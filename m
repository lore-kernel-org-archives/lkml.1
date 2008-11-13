Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbYKMHuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbYKMHuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbYKMHu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:50:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:55998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYKMHu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:50:26 -0500
Date: Thu, 13 Nov 2008 08:50:22 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081113075022.GC2946@wotan.suse.de>
References: <20081113072821.GB2946@wotan.suse.de> <20081113074109.GB1723@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113074109.GB1723@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 08:41:09AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi,
> > 
> > I was just looking around the page fault code for any obvious 
> > performance improvements. I noticed do_page_fault is rather big, 
> > uses a lot of stack, and generates some branch mispredicts.
> > 
> > It's only about 1.1% on the profile of the workload I'm looking at, 
> > so my improvement is pretty close to in the noise, but I wonder if 
> > micro optimisations like the following would be welcome?
> 
> it's definitely welcome!
> 
> > This patch adds branch hints and moves error condition code out of 
> > line. It shrinks do_page_fault from 2410 bytes to 603 bytes, and 
> > from 352 to 64 bytes of stack. Total text size does grow by about 
> > 500 bytes due to the additional functions added.
> 
> Some small cleanliness nits:
> 
> > +/* TODO: match order of arguments */
> 
> please fix TODO ;)

OK, I actually already fixed it but forgot to remove that. Basically just
checking whether keeping regs,error_code,address always passed in the
same order reduces code size (there were one or two places already that
did different order for no good reason). Not surprisingly, it saved a
few bytes.

 
> > +static noinline void no_context(struct pt_regs *regs,
> > +			unsigned long error_code, unsigned long address)
> > +{
> > +	struct task_struct *tsk = current;
> > +#ifdef CONFIG_X86_64
> > +	unsigned long flags;
> > +#endif
> 
> we should just do this unconditionally on 32-bit too.
> 
> > +	/*
> > +	 * Oops. The kernel tried to access some bad page. We'll have to
> > +	 * terminate things with extreme prejudice.
> > +	 */
> > +#ifdef CONFIG_X86_32
> > +	bust_spinlocks(1);
> > +#else
> > +	flags = oops_begin();
> > +#endif
> 
> 32-bit should use oops_begin() too. Solves the previous comment as 
> well.
> 
> > +#ifdef CONFIG_X86_32
> > +	die("Oops", regs, error_code);
> > +	bust_spinlocks(0);
> > +	do_exit(SIGKILL);
> > +#else
> > +	if (__die("Oops", regs, error_code))
> > +		regs = NULL;
> > +	/* Executive summary in case the body of the oops scrolled away */
> > +	printk(KERN_EMERG "CR2: %016lx\n", address);
> > +	oops_end(flags, regs, SIGKILL);
> > +#endif
> 
> this difference seems unnecessary too - 32-bit should use oops_end() 
> too.

Probably all 3 good comments, but I didn't want to be tempted into changing
behaviour (modulo adding bugs). Easy to merge them up in a subsequent patch,
however...

 
> > +/* TODO: fixup for oom handling */
> 
> please fix todo ;-)

Oh... actually it's OK (we don't loop back again, but that's OK, the init
task will just retry the fault). The comment was actually just in relation
to my oom-killer page fault patches that are in -mm. I'm not proposing
this for merge just yet, but will wait for Andrew.

 
> this flow could be cleaned up further:
> 
> [...]
> > +		bad_area(regs, error_code, address);
> > +		return;
> [...]
> > +		bad_area(regs, error_code, address);
> > +		return;
> [...]
> > +			bad_area(regs, error_code, address);
> > +			return;
> [...]
> > +		bad_area(regs, error_code, address);
> > +		return;
> 
> Any reason why that pattern shouldnt be changed to an appropriate goto 
> bad_area? (probably the same goes for the nosemaphore error paths too)

No... not really any reason. gcc effectively turns the code into a goto
anyway. Some days I can't make up my mind which one is better :)

