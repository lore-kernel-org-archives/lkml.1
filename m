Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbYDUQXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbYDUQXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYDUQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:23:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48636 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbYDUQXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:23:35 -0400
Date: Mon, 21 Apr 2008 18:22:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PCI MAINTAINER change
Message-ID: <20080421162258.GA13319@elte.hu>
References: <20080421062139.GA4901@suse.de> <20080421062806.GA4919@suse.de> <200804210855.28405.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0804210914030.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804210914030.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 21 Apr 2008, Jesse Barnes wrote:
> > 
> > And now I get to figure out just how much trouble I've gotten myself into...
> 
> Mwhahahaaa! Sucker. You'll find out.
> 
> The good news is that most of the time, the PCI code works fine. The 
> bad news is that when it doesn't work, it's usually due to something 
> *really* odd, like some magic motherboard device that has magic 
> resources that aren't part of the standard PCI resource set and that 
> clash with some of our resource allocation.
> 
> And they don't show up in the PnP lists because Windows never put 
> anything that could clash with them, so there was no reason for the 
> BIOS engineers to bother.
> 
> IOW, it's usually almost totally undebuggable crud like "driver X 
> doesn't work on my machine", and then it turns out that it only 
> happens on that particular motherboard that is totally identical to 
> all other motherboards _except_ for that BIOS table not having the 
> right reserved IO regions.
> 
> .. and then there's the pluggable PCI stuff, of course. I'm not sure 
> whether you took that over too. That's a whole different set of 
> issues.

that reminds me of the observations about differences between Linux's 
and Windows's PCI resource allocation stategies, see the bugzilla entry 
from today below.

	Ingo

----------------->

http://bugzilla.kernel.org/show_bug.cgi?id=10461

------- Comment #6 from linux@tjworld.net  2008-04-18 11:03 -------
After a few debug printk() runs watching the allocation strategy I wondered why
the PCI resources region doesn't start at the beginning of the largest gap:

[    0.000000] Allocating PCI resources starting at c2000000 (gap:
c0000000:20000000)

since, when 3GB RAM is installed, the gap starts at 0xC0000000 but the
allocation region begins at 0xC2000000.

The other issue is that only the largest gap seems to be used for allocations,
which explains why smaller allocations for other devices effectively choke off
use of the range in 32-bit address space.

In contrast, from looking at the addresses in the allocation comparison with
Windows, it looks as if Windows uses *all* gaps for allocation rather than just
the largest. It is noticeable that Windows allocates smaller regions in the
gaps between the various 'high' e820 reservations.

In looking for the origins of the gap-rounding code I eventually found commit
f0eca9626c6becb6fc56106b2e4287c6c784af3d from 2005-09-09:

[PATCH] Update PCI IOMEM allocation start

    This fixes the problem with "Averatec 6240 pcmcia_socket0: unable to
    apply power", which was due to the CardBus IOMEM register region being
    allocated at an address that was actually inside the RAM window that had
    been reserved for video frame-buffers in an UMA setup.

This introduces a simple 'rounding up' algorithm to create a 'gap' between top
of system RAM and beginning of PCI IOMEM as a guard against unintentional
over-writes.

The algorithm used was suggested in an example by Linus Torvalds with some
provisos but was adopted verbatim in the patch for the Averatec bug. In his
email, Linus went on to say:

"The other alternative is to make PCI allocations generally start at the
high range of the allowable - judging by the lspci listings I've seem from
people under Windows, that seems to be what Windows does, which might be a
good idea (ie the closer we match windows allocation patterns, the more
likely we're to not hit some unmarked region - because windows testing
would have hit it too)."

See:
http://lists.infradead.org/pipermail/linux-pcmcia/2005-September/002625.html

That comment reflects my findings in dealing with this bug. Looking at the bug
there are four issues:

1. No 256MB region on a 256MB boundary available for the GFX IOMEM in the
single largest PCI IOMEM region.

2. The first available 256MB region on a 256MB boundary is unusable because
pci_mem_start is being 'rounded up' to gap_start + round.

3. Multiple gaps higher in the address space are left unused whereas Windows
uses them for smaller allocations thus keeping the largest gap free for the
devices with large requirements.

4. Resources aren't being allocated top-down (subtractive decode) as
recommended in PCI specs and Intel chipset datasheets, and done by Windows.

If [3] was implemented in addition to [4] the smaller allocations would be at
the top of the 32-bit address space much like Windows.

Implementing [3] and [4] together should avoid the need for commit f0eca962
(Cardbus IOMEM in shared video RAM space) since the Cardbus IOMEM would be in a
'high' gap (as it would be with Windws).

Dropping commit f0eca962 would solve [2] since the GFX could allocate 256MB on
the 256MB boundary at 0xC0000000 in the largest gap.

There might be an issue if a system has an undeclared shared video memory
region *and* another PCI device that needs a large allocation.

Also, Linus' mention of maintaining an unused gap between top-of-RAM and
bottom-of-PCI-IOMEM needs to be considered. Would implementation of [2] and [3]
negate the need for it? 
Windows doesn't maintain a similar gap - is there a reason that Linux should?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
