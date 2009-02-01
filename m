Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZBAPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZBAPQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 10:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZBAPQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 10:16:07 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48698 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbZBAPQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 10:16:06 -0500
Subject: Re: [PATCH] x86/Voyager: make it build and boot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090131190525.GA10088@elte.hu>
References: <1233340524.3248.45.camel@localhost.localdomain>
	 <20090130185411.GA9984@elte.hu>
	 <1233341963.3248.48.camel@localhost.localdomain>
	 <20090130193849.GC32705@elte.hu>
	 <1233344509.3248.58.camel@localhost.localdomain>
	 <20090131190525.GA10088@elte.hu>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 09:16:05 -0600
Message-Id: <1233501365.3477.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 20:05 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > > [...] However, this patch is needed now to get 2.6.29-rc3 to boot.
> > > 
> > > and there's also the other ones. We can put them in now that we've got 
> > > the new subarch code. Could you send a pull request with all the 
> > > voyager fixes collected into one tree?
> > 
> > Sure, they're currently all here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/voyager-2.6.git
> 
> I couldnt pull this tree as it had nearly as many problems as commits:

> 1) The tree was rebased freshly, losing history.

?  Rebasing doesn't lose any history ... just read the manual page.  It
also tends to be required operating procedure constructing a patch set
against a moving target

> 2) Commit febf1fe ("[VOYAGER] x86: fix voyager QIC interrupt controller") 
>    is bogus as it adds only comment but claims to be an ioremap_cache() 
>    fix. Probably a rebasing artifact.

No it's still required.  That was the problem that occurred when ioremap
was switched from cached to uncached.  You were just trigger happy when
I explained the problem and how to fix it.  The ioremap_cached needs a
comment explaining why it has to be cached.

> 4) Commit 569a588 is bogus as it introduces a duplicate Kconfig entry.
>    Probably a rebasing/merging artifact.

Yes, good catch ... when they go in in different places rebasing doesn't
always catch the updates.

> 3) The standard x86 commit log format is not:
> 
>        [VOYAGER] fix cpu bootmaps
> 
>    But something like:
> 
>        x86/Voyager: fix cpu bootmaps

Well, you actually have to say what you want.  A simple git log will
tell you that [VOYAGER] has been the standard form for years.

>    You even mixed them inconsistently:
> 
>        [VOYAGER] fix cpu bootmaps
>        [VOYAGER] x86: fix voyager QIC interrupt controller

So if I understand, you want x86 and voyager?

> 5) Commit 78543b1 ("[VOYAGER] x86: add ability to test for boot CPU") is 
>    ugly and possibly breaks the standard build:
> 
>     +#ifdef CONFIG_ACPI
>      #include <asm/acpi.h>
>     +#endif

Really nothing should be including asm/acpi.h ... it should be including
linux/acpi.h, which would resolve the issue ... but I didn't understand
why it wanted the asm version in the first place, so I was reluctant to
try fixing it properly in case there was large breakage in
configurations I don't check.  If fixmap.h wants to continue using the
asm version, the ifdef hedging is about the best way: it duplicates what
linux/acpi.h does, if you look (asm/acpi is gated by the same ifdef).

>    If then such conditionals should be added to the acpi.h header itself 
>    and any knock-on build breakages addressed. The construct you used are 
>    magnets for standard kernel build breakages.

Because you're planning to put non-ACPI symbols in asm/acpi.h?  Since
linux/acpi.h works in the same way, you'll break a lot of other things
if you do that.

> 6) Neither did i like the commit logs berating x86 developers for breaking 
>    voyager - while in reality there's only a single Linux developer on the 
>    planet who _can_ test Voyager and its assumptions (and that is you).

They're pretty neutral to my point of view.  They identify the commit
causing the problem and describe the fix.  This is standard changelog
behaviour.  If you identify problem language, I can fix it, but I think
just saying this commit broke and it was fixed by doing that is about as
neutral as you can get.

As I keep explaining, there are two other voyager users, one in Italy
and one in Argentina.  Both institutions with virtually no IT budget
that happened to be stuck with an inventory of the systems.  It might
not be massive, but I bet it's bigger than some other architectures user
bases.

>    Unless you take part in the x86 development process fully (which you
>    havent for a long time - you always came one stuff hit upstream and 
>    sometimes in late rcs jumping months of x86 development), you cannot 
>    expect special treatment nor can you expect people to even be aware of 
>    the quirks of Voyager. Development is complex already without a 
>    constant distraction from a subarch that is not used by any developer
>    but you.

OK, How?

For example: If you want to be involved in SCSI development, you follow
linux-scsi:  every patch that ever makes it into any tree goes over that
list for comment (this includes every patch I do).  If I look at your
x86/apic branch for instance, most of the patches appear to have gone
straight from your fancy into your git tree without ever traversing a
mailing list (or at least not one indexed by google).

If you develop by banging stuff into a git tree as soon as you think of
it, it's a bit hard to participate in that process (I gave up telepathy
in favour of contact sports a while ago).  The best method is, in fact,
to wait until your stuff gets into mainline and then fix it all up,
which, by co-incidence is the way the voyager tree currently operates.

> Anyway, to move forward i consolidated the acceptable bits into a single 
> low-impact commit and queued it up in x86/urgent - see it below. The 
> acpi.h bit you probably still need to build Voyager but it needs 
> reworking. Please submit it separately.

Thanks.

I really would recommend the fix I proposed:  all it does, as I said, is
precisely what linux/acpi.h does.  The problem with trying to include
linux/acpi.h in asm/fixmap.h is that fixmap is an early include and gets
us into all sorts of nasty circular tangles that will be very invasive
to sort out.

James


