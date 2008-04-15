Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbYDOJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbYDOJgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYDOJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:36:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34065 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbYDOJgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:36:31 -0400
Date: Tue, 15 Apr 2008 10:36:28 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Message-ID: <20080415093628.GD20316@csn.ul.ie>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080411092452.GE10801@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080411092452.GE10801@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/04/08 11:24), Ingo Molnar didst pronounce:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Fri, Apr 11, 2008 at 12:05 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > >  >  Right. Then you probably want to look into any changes in arch/x86/
> > >  >  related to setting up the zonelists. I'm fairly certain this is not a
> > >  >  slab bug and I don't see any recent changes to the page allocator
> > >  >  either that would explain this.
> > >
> > >  I'd be willing to put some money on this:
> > >
> > >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b7ad149d62ffffaccb9f565dfe7e5bae739d6836
> > 
> > And I'd lose as you're 32-bit. Oh well, that's the price to pay for 
> > pretending to know x86 arch internals.
> 
> yeah, sorry - we are working hard to unify generic bits like that, but 
> it's a huge architecture.
> 
> btw., i always felt that the zone/memory setup is rather fragile and 
> ad-hoc in places and it trusts the architecture code too much. Just in 
> the .25 cycle i've seen about a dozen bugs all around that thing. I 
> believe we should work on making the info that an architecture feeds to 
> the MM "fool proof" - i.e. sanity-check for overlaps and other common 
> setup errors.

I hadn't realised that such setup errors were common. It should be already able
to handle some overlapping problems in add_active_range().

I'm playing catch-up here but looking at your dmesg output, I see the
following snippets.

[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000efff8000 (usable)
[    0.000000]  BIOS-e820: 00000000efff8000 - 00000000f0000000 (ACPI data)

There are two portions of usable memory with a few holes there.

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000110000000 (usable)

And is memory over the 4GB boundary but....

[    0.000000] Warning only 4GB will be used.
[    0.000000] Use a HIGHMEM64G enabled kernel.
[    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used

It's recognised and only memory below 4GB is registered and it's all on
node 0. However, I do note that it also registers all the holes as valid
memory. The memory should never get freed because it should be reserved
during boot by reserve_bootmem() but it still raises an eyebrow.

[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 6400 pages used for memmap
[    0.000000]   HighMem zone: 812800 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap

And from this, it looks like memmap is getting setup. So far, it looks
like basic initialisation was ok.

> It is easy for an architecture to mess up those things... 
> Especially on oddball systems that are too large or too small to be 
> normally tested. It's a common, reoccuring bug pattern that we could 
> avoid by being a bit more resilient.
> 
> if this is a zone setup bug then a sanity-check could catch it right 
> where it happens - not much later in the slab code or so.
> 
> 	Ingo
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
