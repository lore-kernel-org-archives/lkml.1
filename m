Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbXIEOSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbXIEOSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbXIEORy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:17:54 -0400
Received: from mx12.go2.pl ([193.17.41.142]:55561 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756451AbXIEORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:17:53 -0400
Date: Wed, 5 Sep 2007 16:19:23 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] detect & print stack overruns at oops time
Message-ID: <20070905141923.GB1938@ff.dom.local>
References: <20070905093047.GA1938@ff.dom.local> <46DEA644.4060908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DEA644.4060908@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 07:51:16AM -0500, Eric Sandeen wrote:
> Jarek Poplawski wrote:
> > On 31-08-2007 07:28, Eric Sandeen wrote:
> >> In thinking about the 4KSTACKS + STACKOVERFLOW problems, I thought
> > ...
> >> Thoughts?  This is a separate problem from the piggy dump_stack()
> >> path, but it seems to me it might be useful in looking at stack-related
> >> oopses when they do occur.  With this change, it seems feasible
> >> to turn off DEBUG_STACKOVERFLOW, turn on DEBUG_STACK_USAGE, and just
> >> get the bad news when it's actually happened.  :) 
> > 
> > Very good idea, but maybe, at least for some time, it should be with
> > ifdef CONFIG_4KSTACKS, to check if it's really needed if some other
> > similar checks also set.
> 
> Hi Jarek - thanks for the comments.
> 
> I don't see much, if any, runtime impact to having it on all the time,
> except maybe the end-of-stack zeroing, which would have at least some
> impact.  Everything except that single " = 0;" only runs if you've
> already oopsed...  I'd hate to clutter it with #ifdefs unless there's a
> good reason.

I've meant: with 4KSTACKS there is probably no doubt it's needed, even
at the cost of some impact, which by the way could be more tested (and
there is a way to turn it off for, maybe, some conflicts). But, if you
checked it all enough and think such 'debugging' time is not necessary
then of course, without ifdefs it looks nicer.

> 
> 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>
> >> Index: linux-2.6.22-rc4/arch/i386/mm/fault.c
> >> ===================================================================
> >> --- linux-2.6.22-rc4.orig/arch/i386/mm/fault.c
> >> +++ linux-2.6.22-rc4/arch/i386/mm/fault.c
> >> @@ -525,6 +525,8 @@ no_context:
> >>  
> >>  	if (oops_may_print()) {
> >>  		__typeof__(pte_val(__pte(0))) page;
> >> +		unsigned long *stackend = end_of_stack(tsk);
> >> +		int overrun;
> >>  
> >>  #ifdef CONFIG_X86_PAE
> >>  		if (error_code & 16) {
> >> @@ -543,6 +545,27 @@ no_context:
> >>  			printk(KERN_ALERT "BUG: unable to handle kernel paging"
> >>  					" request");
> >>  		printk(" at virtual address %08lx\n",address);
> >> +
> >> +		overrun = (unsigned long)stackend - (unsigned long)(&regs->esp);
> >> +		if (overrun > 0) {
> >> +			printk(KERN_ALERT "Thread overrunning stack by %d "
> >> +							"bytes\n", overrun);
> >> +		} else {
> >> +#ifdef CONFIG_DEBUG_STACK_USAGE
> >> +			int free;
> >> +			unsigned long *n = stackend;
> >> +			while (!*n)
> >> +				n++;
> >> +			free = (unsigned long)n - (unsigned long)stackend;
> >> +			if (free)
> > 
> > Maybe there should be some min 'free' and max number of printks? There
> > could be also considered if, with some minimal values of 'free', prink
> > is the best thing we can do before stack overruning?
> 
> You mean, don't print unless the free value is in some range?  My
> thought was, if you always print *something*, then you know for sure
> you're looking at an oops from a kernel with this code in place.
> Though, if "all's well" I suppose the bytes remaining isn't so
> important; it would really be enough to just say:
> 
> 	if (!(*stackend))
> 		printk("Thread stayed within stack space\n");
> 	else
> 		printk("Thread overran stack\n");
> 

OOPS! I didn't read the code around enough. Since it's one time event
there should be no problem of too much repeating, sorry! But, there
is probably still a question: if such a printk can overrun the stack
and possibly stuck the machine I would prefer to have some log on the
disk or possibility of sysrq or ctrl-alt-del than to write by hand or
take a picture with this one printk more... Of course, if I missed it
again, and there is choice or risk, then - no question & all correct.

> 
> >> +				printk(KERN_ALERT "Thread used within %d bytes"
> >> +					" of stack end\n", free);
> >> +#endif
> >> +			/* won't catch 100% - stack may have 0s here by chance */
> >> +			if (*stackend)  /* was init'd to 0 */
> > 
> > Isn't a MAGIC number better for this? (Then of course above n should
> > start a bit higher.)
> 
> I thought about that, though really *anything* could legitimately be on
> the stack, so I guess it's a question of probabilities.  And, "0" is
> compatible with CONFIG_DEBUG_STACK_USAGE, which sets the the whole stack
> to 0 and uses that to detect max stack excursion...  I guess that option
> could probably be tweaked to zero the whole stack, and then also set the
> last position to something magic (0xDEAD57AC - deadstack?), and check
> for that as well.  (I had thought about making helper functions for
> DEBUG_STACK_OVERFLOW, right now the checks are open coded in a few places).

IMHO 0 is the worst possible choice for this - I think it's used far
more often than others, there is only a question to stay compatible
with other debug checkers (or ifdef from them...), but anything else
looks much more credible to me.

Thanks,
Jarek P.
