Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbXJAMfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbXJAMfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 08:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXJAMfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 08:35:23 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1719 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXJAMfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:35:21 -0400
Date: Mon, 1 Oct 2007 13:34:52 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071001123452.GF13737@shadowen.org>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001003007.4e90143b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:30:07AM -0700, Andrew Morton wrote:
> On Mon, 1 Oct 2007 08:44:48 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > (lkml Cc:-ed - this might be of interest to others too)
> > 
> > * Andy Whitcroft <apw@shadowen.org> wrote:
> > 
> > > WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> > > #411: FILE: home/apw/git/linux-2.6/kernel/sched.c:408:
> > > +EXPORT_SYMBOL_GPL(cpu_clock);
> > 
> > yes, this is a legit warning and i fix it every time i see it. (I cannot 
> > fix this one now because mainline does not have an EXPORT_SYMBOL_GPL for 
> > cpu_clock(), it's added in -mm? But i cannot find it in mm either. I'll 
> > fix it once i find the patch :)
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/make-rcutorture-rng-use-temporal-entropy.patch
> 
> > > WARNING: printk() should include KERN_ facility level
> > > #4838: FILE: home/apw/git/linux-2.6/kernel/sched.c:4835:
> > > +	printk("%-13.13s %c", p->comm,
> > > 
> > > WARNING: printk() should include KERN_ facility level
> > > #5622: FILE: home/apw/git/linux-2.6/kernel/sched.c:5619:
> > > +				printk("\n");
> > > 
> > > WARNING: printk() should include KERN_ facility level
> > > #5633: FILE: home/apw/git/linux-2.6/kernel/sched.c:5630:
> > > +				printk("\n");
> > > 
> > > WARNING: printk() should include KERN_ facility level
> > > #5640: FILE: home/apw/git/linux-2.6/kernel/sched.c:5637:
> > > +			printk(" %s", str);
> > > 
> > > These are actually only in debug code and so are unimportant, but 
> > > technically they are wrong.  This check is a very difficult one in the 
> > > face of these constructs.  But in this case I think it has got the 
> > > report right.
> > 
> > this is actually a false positive - as the debug code constructs a 
> > printk output _without_ \n. So the script should check whether there's 
> > any \n in the printk string - if there is none, do not emit a warning. 
> > (if you implement that then i think it can remain a warning and does not 
> > need to move to CHECK.)
> 
> Yeah, it does that sometimes.  I don't think it's fixable within the scope
> of checkpatch.  It needs to check whether some preceding printk which might
> not even be in the patch has a \n:
> 
> 	printk(KERN_ERR "foo");
> 	<100 lines of whatever>
> +	printk("bar\n");
> 
> we're screwed...

Actually checkpatch does take that into account.  If the printk has no
precceding printk ending in a newline, within the scope of the diff
then the warning is suppressed.

However, in this mm/sched.c case there are paths through the code which
do violate the "every line starts with KERN_" mantra.  Now checkpatch is
actually not clever enough to spot that these are conditional, but in
this case there is an error.  Its not important as it is debug.  But I
contend there is an erorr.  When an error is thrown we close the
unfinished line, emit a line at KERN_ERR and then continue to emit the
previous line without switching to KERN_DEBUG again.

> > > At this point _if_ we took an error we would not have _DEBUG open and so
> > > a start would be required, otherwise not.
> > > 
> > >                         printk(" %s", str);
> > > 
> > > To be 100% correct I assume it would need to have a 
> > > printk(KERN_DEBUG); after each of the KERN_ERR printk's.
> > 
> > i've fixed this in my tree. But i dont think checkpatch.pl notices this 
> > level of bug - it just detects the missing KERN_ prefix in printk(), 
> > right?
> > 
> > > WARNING: braces {} are not necessary for single statement blocks
> > > #5706: FILE: home/apw/git/linux-2.6/kernel/sched.c:5703:
> > > +	if (parent->groups == parent->groups->next) {
> > > +		pflags &= ~(SD_LOAD_BALANCE |
> > > +				SD_BALANCE_NEWIDLE |
> > > +				SD_BALANCE_FORK |
> > > +				SD_BALANCE_EXEC |
> > > +				SD_SHARE_CPUPOWER |
> > > +				SD_SHARE_PKG_RESOURCES);
> > > +	}
> > > 
> > > Ok, this one is "correct" at least for the rules as I have them.
> > > Perhaps the message should not be emitted for very long blocks?
> > 
> > If a statement is not single-line, then braces _are_ fine. Where does 
> > CodingStyle say that it's not fine?
> 
> I'd disagree with checkpatch there.  Again, it might be hard to fix.  Wanna
> rename it to checkpatch-and-suggest-stuff-to-think-about.pl?

Checkpatch is capable of making the determination as at the time we
emit the warning we have all of the block in question.  We already allow
a number of other exceptions.  Just I think what I think the "rule" is
and its actuallity are not the same.

Are we saying the rule is "braces are not required for single _line_
blocks?

> > > WARNING: no space between function name and open parenthesis '('
> > > #5768: FILE: home/apw/git/linux-2.6/kernel/sched.c:5765:
> > > +__setup ("isolcpus=", isolated_cpu_setup);
> > > 
> > > Almost all other instances of __setup do not have a space, so I assume
> > > this is a reasonable report.
> > 
> > yes. I have just fixed it in my tree.
> > 
> > > WARNING: externs should be avoided in .c files
> > > #6545: FILE: home/apw/git/linux-2.6/kernel/sched.c:6542:
> > > +	extern char __sched_text_start[], __sched_text_end[];
> > > 
> > > That one ... dunno.  This check is a difficult one.  Should it be a 
> > > CHECK?
> > 
> > no, this is a legitimate warning - externs in .c files should move into 
> > the proper .h file. So i'd suggest to keep this a WARNING.
> 
> Yes.  When the symbol is defined in .S or vmlinux.lds we have
> traditionally declared it in .c.
> 
> But why?  It _is_ a global symbol.  We might as well declare it in .h. 
> That's consistent, and prevents duplicated declarations from popping up
> later on.

-apw
