Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0CDAgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:36:49 -0500
Received: from www.tglx.de ([62.245.132.106]:47271 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab0CDAgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:36:42 -0500
Date: Thu, 4 Mar 2010 01:35:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
In-Reply-To: <20100303215314.GC2579@ucw.cz>
Message-ID: <alpine.LFD.2.00.1003032312000.2014@localhost.localdomain>
References: <20100211195614.886724710@sbs-t61.sc.intel.com> <201002271323.14402.rjw@sisk.pl> <20100227124710.GA21164@elte.hu> <201002272007.43042.rjw@sisk.pl> <20100228072357.GB14205@elte.hu> <20100303215314.GC2579@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Wed, 3 Mar 2010, Pavel Machek wrote:
> > Today's stats, done amongst users who are willing to opt in to the Smolt 
> > daemon:
> > 
> >        x86: 99.7%
> >    powerpc: 0.3%
> 
> Lies, bad lies, statistics.

Reality. The vast majority of the feedback we get via LKML, most
subsytems mailinglists, bugzilla and kerneloops comes from x86
machines.

> > And yes, there are millions of ARM (and MIPS) CPUs running Linux as well. 
> > (They are only as present as present their developers are: the users almost 
> > never show up on linux-kernel.)
> 
> It cuts both ways. Maybe obscure architectures like alpha have more
> than their marketshare of interested lkml users...

And that's a valid excuse that such archs are ignoring deprecation
warnings for years ?

I can see that the few users of alpha - or whatever esoteric (sub)arch
you name - who are usually the interested maintainers / developers do
have not the energy to keep up with the changes, but that's simply a
damned maintainence nightmare for the rest of the kernel and
especially the core code in the long run.

Just a few examples from my own experience:
     
 - the generic mutex code was merged in 2.6.16 - 4 years ago
 - the generic timekeeping code was merged in 2.6.18 - 4 years ago
 - the generic interrupt framework was merged in 2.6.18 - 4 years ago
 - the generic clockevents code was merged in 2.6.21 - 3 years ago

and for all four we still drag around workarounds, compatibility
functions and other crap just to keep platforms and drivers alive.

Maintainers happily ignore that the core code has changed simply
because they rely on the "no regressions" rule forever. That _IS_
hilarious.

As a side note: We created checkpatch.pl, to have a tool which helps
us to alert developers about stuff which is deprecated and as a
byproduct the coding style rules. I think it's a useful tool in
general, just the outcome is an utter trainwreck:

We have hordes of whitespace, spelling and codingstyle cleanup
maniacs, while the hard stuff of replacing deprecated interfaces like
semaphore based mutexes / completions, cleaning up the BKL horror,
etc. is left to a few already overworked people who care.

What's even worse is it that developers of new code and the
maintainers who are merging it simply ignore its existance for
whatever reasons. I can accept the whitespace argument, but I have no
grasp why deprecation warnings are ignored at will.

A simple example:

  I'm trying to get rid of init_MUTEX for quite a while just to notice
  that every other kernel release we grow at least one new user of it.

  Latest new user merged in 2.6.33:

    drivers/block/drbd/drbd_bitmap.c:       init_MUTEX(&b->bm_change);

  That crap should not have been merged in the first place. Period. 

  Further the patch to fix that crap has been completely ignored by
  the developers of that very sh*t and the relevant subsystem
  maintainer as well.

Go and grep for the rest of that horror including new users of
lock_kernel() and unlock_kernel() - and I do _not_ mean the ones which
got pushed down by the few people who care.

That's what drives core code maintainers nuts. That's what Ingo is
pointing to:

Core kernel developers/maintainers need to respect every lazy
arch/driver developer/maintainer forever and care about bitrot
themself before getting anything useful done - while at the same time
the very same arch/driver developers impose crap on the kernel forever
and expect that this has to be accepted by the "no regression" rule ?

And _you_ are on the same boat expecting that core code developers
have to fix bitrotted sh*t or take care of removing it:

     "So instead of either fixing those architectures or marking them
      deprecated, you blame Stephen for too much testing?"

No, that's not how it works:

The few people doing core development work _DO NOT_ and _CANNOT_ scale
to fix up all the shit in the kernel. It needs the collaboration of
the whole kernel developer crowd and not finger pointing on those who
make the unmaintained sh*t hit the fan.

> > Plus, a kernel subsystem maintainer like me who does lots of kernel 
> > infrastructure work can have a pretty good gut feeling about which 
> > architectures are actively helping out Linux, and which are just hanging on to 
> > the bandwagon.
> 
> So instead of either fixing those architectures or marking them
> deprecated, you blame Stephen for too much testing?

Ingo did not blame Stephen at all. We all appreciate - and Ingo stated
so explicitly - the work Stephen is taking on to keep linux-next
running.

Ingo merily questioned the complaints about "regressions" from core
code changes resulting in wreckage of barely maintained trainwrecks
and I totally agree with him on that one.

Thanks,

	tglx
