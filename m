Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYLDQSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYLDQSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYLDQRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:17:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbYLDQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:17:53 -0500
Date: Thu, 4 Dec 2008 08:17:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812041229.45443.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812040754020.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812031220.36711.rjw@sisk.pl> <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org> <200812041229.45443.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Frans Pop wrote:

> On Wednesday 03 December 2008, Linus Torvalds wrote:
> > Well, I think that what _would_ be generally correct, and actually
> > pretty simple, is a rather different approach: just not sizing things
> > behind a transparent bridge AT ALL, since it really shouldn't matter.
> 
> I've given your patch a try and the few resumes from STR I've done were 
> all successful. That's not 100% conclusive yet, but a nice start.
> Some info from logs etc. below.

Ok, but I thought you had a hard time reproducing this _anyway_, even with 
just plain -rc7. No?

That said, of the various patches posted, the "don't bother allocating 
bridging windows for transparent bridges" one is not just the simplest, 
but the only one that actually makes sense so far.

So I'm happy it's apparently working for you, I'm just wondering about 
whather your success means a lot. It seems that Rafael is the one who had 
more failures?

> > > Also, I would be happy to actually understand _why_ this happens.
> >
> > 100% agreed. I do _not_ see why it should ever matter how we set up a
> > PCI bridging window - whether prefetchable or not - on a bridge that
> > should be transparent. It sounds really odd. I'm wondering if there is
> > something we're missing here.
> 
> The theory that it is really a resume issue and not a device layout issue 
> sounds logical. Especially as everything always works correctly after a 
> normal boot.

Yes, that does sound like a convincing argument. Usually real PCI resource 
clashes result in some kind of run-time problems, and wouldn't necessarily 
be suspend-specific per se.

That said, suspend/resume does a lot of unusual things, so it could still 
be some odd PCI resource clash that only triggers problems in the 
suspend/resume case. But since the exact layouts and the sizing of the 
resources doesn't really seem to matter, a simple PCI resource clash seems 
rather unlikely.

So some kind of resume-time ordering or timing issue does seem like the 
most likely thing. But that still leaves us not knowing what the real 
_root_ cause of this all is - very irritating. Even if not allocating the 
unnecessary bridging windows "fixes" things, it would be really really 
good to know exactly what it is that causes problems.

> Below info from 3 kernels, all based on 2.6.28-rc7-91:
> A) unpatched
> B) with the revert/debug patch
> C) with the oneliner "ignore transparent bridges" patch
> 
> AFAICT all results are probably as expected.
> 
> From lspci -vvxxx:
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge
> - for A)
> 	I/O behind bridge: 00003000-00003fff
> 	Memory behind bridge: e0100000-e03fffff
> 	Prefetchable memory behind bridge: 0000000080000000-0000000083ffffff
> - for B)
> 	I/O behind bridge: 00003000-00003fff
> 	Memory behind bridge: e0100000-e03fffff
> - for C)
> 	Memory behind bridge: e0100000-e03fffff

And this all makes total sense. The e0100000-e03fffff MMIO bridge range is 
apparently set up by the firmware, which is why it shows up in all cases. 
And the (A) case has that prefetchable memory range, because that's the 
only case that finds - and cares about - the prefetch window for the 
CardBus controller. 

And both (A) and (B) have the IO bridging window, because regardless of 
whether we see a valid CardBus prefetchable memory window with good 
alignment, we'll always see the IO ports, so we'll try to allocate that 
bridging window, except in (C) when we decide that due to the transparent 
nature, we simply don't care.

So the PCI resources make sense in all three cases, and we understand 
those. The differences in the actual Cardbus ranges also all make sense. 
So it all still boils down to the PCI layer doing everything right in 
_all_ cases, just making slightly different - but all valid - choices 
depending on essentially random details (eg the revert/debug patch case 
the "random detail" is just enabling a small incorrect alignment).

IOW, it really doesn't look like a PCI resource allocator bug. Quite the 
reverse, I'd say that in the end this whole thread points out just how 
robust the whole PCI and cardbus resource allocation is, with the code 
really very gracefully just adjusting in a sane manner to all these 
different cases.

Of course, none of that helps us with any kind of idea of what the real 
problem is. Device ordering bug in setting up PCI resources at resume? 
Perhaps just a plain bug in PCI bridge resume code (even when you resume 
things in the right order)?

And I still worry that perhaps it's just a timing bug, where having a PCI 
bridging window changes timing of various PCI accesses, and the _real_ bug 
is actually in the sound card or ethernet driver resume, which happens to 
work with one timing and not with another.

Since it's apparently STR, has anybody gotten _anything_ sane out of 
trying to enable PM_TRACE_RTC, and then doing that 

	echo 1 > /sys/power/pm_trace

because even with the (very limited) set of standard trace-points, it 
should still be able to tell which device we were trying to resume last in 
the failure case Maybe that gives some hint?

				Linus
