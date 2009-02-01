Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZBARFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZBARFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZBARFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:05:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59819 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZBARFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:05:05 -0500
Date: Sun, 1 Feb 2009 18:04:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/Voyager: make it build and boot
Message-ID: <20090201170449.GA30892@elte.hu>
References: <1233340524.3248.45.camel@localhost.localdomain> <20090130185411.GA9984@elte.hu> <1233341963.3248.48.camel@localhost.localdomain> <20090130193849.GC32705@elte.hu> <1233344509.3248.58.camel@localhost.localdomain> <20090131190525.GA10088@elte.hu> <1233501365.3477.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233501365.3477.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2009-01-31 at 20:05 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > > > [...] However, this patch is needed now to get 2.6.29-rc3 to boot.
> > > > 
> > > > and there's also the other ones. We can put them in now that we've got 
> > > > the new subarch code. Could you send a pull request with all the 
> > > > voyager fixes collected into one tree?
> > > 
> > > Sure, they're currently all here:
> > > 
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/voyager-2.6.git
> > 
> > I couldnt pull this tree as it had nearly as many problems as commits:
> 
> > 1) The tree was rebased freshly, losing history.
> 
> ?  Rebasing doesn't lose any history ... just read the manual page.  It 
> also tends to be required operating procedure constructing a patch set 
> against a moving target

That is nonsense - rebasing loses a lot of history: it loses the precise 
place of the commit and re-anchors the commit to another place. It hides the 
cases where you did conflict resolution in a rebase, and it also hides the 
cases where Git auto-merged something. It makes it hard to trust the dates 
in the tree because literally, according to the timestamps, the tree you 
sent me was just a few hours hold.

We dont ever rebase maintainer Git trees - only in the most exceptional 
circumstances. Rebasing is fine for certain situations during development, 
but it is considered evil as a maintenance model.

> > 2) Commit febf1fe ("[VOYAGER] x86: fix voyager QIC interrupt controller") 
> >    is bogus as it adds only comment but claims to be an ioremap_cache() 
> >    fix. Probably a rebasing artifact.
> 
> No it's still required.  That was the problem that occurred when ioremap 
> was switched from cached to uncached.  You were just trigger happy when I 
> explained the problem and how to fix it.  The ioremap_cached needs a 
> comment explaining why it has to be cached.

Have you considered to _take a look_ at the commit i pointed out to you? The 
commit does this:

| From febf1fee10022544674aa01f518a7603b2231191 Mon Sep 17 00:00:00 2001
| From: James Bottomley <James.Bottomley@HansenPartnership.com>
| Date: Fri, 25 Apr 2008 09:02:51 -0500
|
|
| [...] 
| +		/* The QIC address is really special.  QIC does cross
| +		 * CPU interrupts via cache line states, so if there's
| +		 * no caching on these addresses the interrupts stop
| +		 * working.  If ever the QIC stops booting but VIC is
| +		 * fine, suspect that the ioremap here is no longer
| +		 * producing cached memory */
| 		qic_addr = (unsigned long)ioremap_cache(qic_addr, 0x400);

This commit _only adds a comment_. We fixed the ioremap bug upstream eons 
ago (when you pointed it out), and you probably did a conflict resolution in 
a rebase and then perhaps forgot about this.

> > 4) Commit 569a588 is bogus as it introduces a duplicate Kconfig entry.
> >    Probably a rebasing/merging artifact.
> 
> Yes, good catch ... when they go in in different places rebasing doesn't 
> always catch the updates.

Yes, this is one of the typical dangers of rebasing. Besides losing true 
history, you also risk mishaps like that.

That is why the kernel maintainer 101 is: "never rebase". I'm surprised you 
never even heard about that... Does this mean that you frequently rebase the 
SCSI tree?

> > 3) The standard x86 commit log format is not:
> > 
> >        [VOYAGER] fix cpu bootmaps
> > 
> >    But something like:
> > 
> >        x86/Voyager: fix cpu bootmaps
> 
> Well, you actually have to say what you want.  A simple git log will
> tell you that [VOYAGER] has been the standard form for years.
>
> >    You even mixed them inconsistently:
> > 
> >        [VOYAGER] fix cpu bootmaps
> >        [VOYAGER] x86: fix voyager QIC interrupt controller
> 
> So if I understand, you want x86 and voyager?

The format i suggested above would be fine.

> > 5) Commit 78543b1 ("[VOYAGER] x86: add ability to test for boot CPU") is 
> >    ugly and possibly breaks the standard build:
> > 
> >     +#ifdef CONFIG_ACPI
> >      #include <asm/acpi.h>
> >     +#endif
> 
> Really nothing should be including asm/acpi.h ... it should be including
> linux/acpi.h, which would resolve the issue ... but I didn't understand
> why it wanted the asm version in the first place, so I was reluctant to
> try fixing it properly in case there was large breakage in
> configurations I don't check.  If fixmap.h wants to continue using the
> asm version, the ifdef hedging is about the best way: it duplicates what
> linux/acpi.h does, if you look (asm/acpi is gated by the same ifdef).
> 
> >    If then such conditionals should be added to the acpi.h header itself 
> >    and any knock-on build breakages addressed. The construct you used are 
> >    magnets for standard kernel build breakages.
> 
> Because you're planning to put non-ACPI symbols in asm/acpi.h?  Since 
> linux/acpi.h works in the same way, you'll break a lot of other things if 
> you do that.
> 
> > 6) Neither did i like the commit logs berating x86 developers for breaking 
> >    voyager - while in reality there's only a single Linux developer on the 
> >    planet who _can_ test Voyager and its assumptions (and that is you).
> 
> They're pretty neutral to my point of view.  They identify the commit
> causing the problem and describe the fix.  This is standard changelog
> behaviour.  If you identify problem language, I can fix it, but I think
> just saying this commit broke and it was fixed by doing that is about as
> neutral as you can get.
> 
> As I keep explaining, there are two other voyager users, one in Italy and 
> one in Argentina.  Both institutions with virtually no IT budget that 
> happened to be stuck with an inventory of the systems.  It might not be 
> massive, but I bet it's bigger than some other architectures user bases.

What development kernels are they using? I never heard any bugreport from 
them.

> >    Unless you take part in the x86 development process fully (which you
> >    havent for a long time - you always came one stuff hit upstream and 
> >    sometimes in late rcs jumping months of x86 development), you cannot 
> >    expect special treatment nor can you expect people to even be aware of 
> >    the quirks of Voyager. Development is complex already without a 
> >    constant distraction from a subarch that is not used by any developer
> >    but you.
> 
> OK, How?
> 
> For example: If you want to be involved in SCSI development, you follow 
> linux-scsi: every patch that ever makes it into any tree goes over that 
> list for comment (this includes every patch I do).  If I look at your 
> x86/apic branch for instance, most of the patches appear to have gone 
> straight from your fancy into your git tree without ever traversing a 
> mailing list (or at least not one indexed by google).

Regarding the changes in the x86/apic branch, see this thread in your lkml 
folder:

  x86: unify genapic code, unify subarchitectures, remove old subarchitecture code

  http://lwn.net/Articles/317050/
  http://thread.gmane.org/gmane.linux.kernel/786890

With 114 patches submitted to lkml. (there's ~10 more in the works that i'll 
submit to lkml once i'm happy with them)

All patches to the x86 tree are submitted to lkml (including my patches and 
that of other maintainers) and all development is done there.

So i dont get it how you can claim it credibly that you cannot take part in 
x86 development.

> If you develop by banging stuff into a git tree as soon as you think of 
> it, it's a bit hard to participate in that process (I gave up telepathy in 
> favour of contact sports a while ago).  The best method is, in fact, to 
> wait until your stuff gets into mainline and then fix it all up, which, by 
> co-incidence is the way the voyager tree currently operates.

Nice rant which ignores the fact that i submitted those patches to lkml.

> > Anyway, to move forward i consolidated the acceptable bits into a single 
> > low-impact commit and queued it up in x86/urgent - see it below. The 
> > acpi.h bit you probably still need to build Voyager but it needs 
> > reworking. Please submit it separately.
> 
> Thanks.
> 
> I really would recommend the fix I proposed: all it does, as I said, is 
> precisely what linux/acpi.h does.  The problem with trying to include 
> linux/acpi.h in asm/fixmap.h is that fixmap is an early include and gets 
> us into all sorts of nasty circular tangles that will be very invasive to 
> sort out.

Well, the #ifdef hack you did is out of question. The clean approach would 
be to remove the acpi.h include from asm/fixmap.h and fix the dependency 
fallout. The hack you did deepens the spaghetti and makes it 
config-conditional as well - which is even worse than plain header 
dependency mess and which is a step backwards.

	Ingo
