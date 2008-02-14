Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYBNQec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYBNQec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYBNQeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:34:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44937 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYBNQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:34:23 -0500
Date: Thu, 14 Feb 2008 18:10:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
Message-ID: <20080214171002.GA16255@one.firstfloor.org>
References: <20080213155725.GA19523@elte.hu> <p73ir0r25t4.fsf@bingen.suse.de> <20080214151953.GA22068@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214151953.GA22068@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 04:19:53PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > >
> > > Thomas Gleixner (1):
> > >       x86: EFI: fix use of unitialized variable and the cache logic
> > 
> > Your honor, I would like to register a differing opinion...
> 
> As i mentioned it (in the portion of my email that you clipped), there 
> are other pending CPA patches in x86.git:
> 
> > > [there are more CPA cleanups still brewing but none of that is 
> > > urgent.]
> 
> We didnt plan to push these secondary alias fixes out yet with 
> yesterday's push, and i disagree with you about their urgency.
> 
> > I submitted that fix originally in a different form, but it got 
> > finally stripped down to this. However in my opinion the full version 
> > of the patch is still needed, otherwise EFI still does the mapping 
> > wrong.
> 
> well, not really. Firtly, and most importantly, can you see any failures 
> on any real boxes?

I don't have any EFI boxes.

However with the one bug I found recently (set_memory_uc passed
in bytes for numpages) I doubt it was ever tested in the current
form in tree (perhaps it came from some merge mistake?)

> have little practical relevance today. Getting the _primary_ 

The original motivation for pageattr.c back in 2002 was a very real
problem with AGP cache corruption coming from the direct mapping aliases.

Also while I was still maintaining that code and occasionally broke
it :-] I usually got reports after 1-2 releases from people who were hitting 
real failures from the breakage (given a lot of that was the proprietary Nvidia
driver, but I see no reason it won't hit on completely free software too) 

So from practical experience I beg to disagree.


> alias right is the most important task of CPA and -git does that all 
> correctly. (we'd be seeing crashes left and right in -rc1 if it didnt)


No you don't see quick crashes left and right from alias attributes,
but subtle cache corruptions after a long time. That is because
it only causes problems when the CPU does some prefetching on
the wrong address and that typically takes some time to happen.

The typical symptom is that at some point (after many hours) 
someone's 3d driver errors out with some internal inconsistency when the 
3d card happened to be feed a corrupted cache line.

But I have no doubts that non 3d workloads will hit it eventually
too (just takes longer because they tend to move much less data) 

 
> Firstly, what we do currently incorrectly (and which is fixed in 
> x86.git) is that we do a __pa() on a vmalloc/ioremap-range address on 
> 64-bit in secondary alias discovery. But as i showed it to you days ago 

First before you started rewriting ioremap that all worked correctly[1]
since quite some releases. I fixed this originally long ago
(it was already in 2.6.12; I'm too lazy to search back further) 

So 2.6.25 would be the first kernel since at least 2.6.12 that 
would not do this correctly.

I polititely request that you do something about this regression
for .25.  Either apply my patches or fix it yourself in whatever
way you want. Just fix it.

[1] modulo the relatively minor problem of end_pfn_map sometimes
being a few pages off I recently sent a patch for.

> in my reply, while it will yield a "random" looking address, but that 
> address is a guaranteed-high physical address in the higher than 
> 0x410000000000 (i.e. 65TB+) physical range, so we'll just return 

Again 64bit efi_ioremap passes in a fixmap address.
And fixmap is >= the kernel mapping so __pa() will resolve it
to a physical address <= 2GB.

Your 65TB analysis assumed it passed in the vmalloc/ioremap range.
The analysis would be fine for that (although still dubious code).
Unfortunately it had a faulty starting point.

For 32bit it also was wrong I think for the more obscure __PAGE_OFFSET
splits. This is it likely was ok[1] for the default 3:1 but not e.g.
for 1:3.

[1] ok as in not clearly broken; not clean code.
 
> Secondly, your suggestion that inconsistent caching attribute aliases 
> are not permitted is incorrect. They are very much not allowed under 
> PAT, 

_PCD is PAT!!!! Even if you don't change the PAT MSRs ever setting
_PCD anywhere makes you a PAT user. And ioremap definitely sets
_PCD.

> and they are "nice to avoid" even on non-PAT (early CPU iterations 

It's not "nice to avoid". It's "if you don't avoid it your cache
will be eventually corrupted". And yes we've had this case 
in the past where it broke real setups.

> Anyway, please take a look at today's x86.git#mm:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
> 
> it should handle secondary aliases correctly - but we are still working 
> on some other cleanups to make it complete.

Ok cpa_check_alias seems to be gone again. That's at least some progress.
And all the __pas are gone too. That's good.

I see you started to follow 
http://marc.info/?l=linux-kernel&m=120290203315953&w=2
too which is also good although I haven't checked if it's ok
for all cases.

Doing it this way is probably fine for .26 but you still need
a quicker regression fix for .25.

Also it would be nice if someone would apply the remaining CPA
patches I posted earlier this week. Some of them went uncommented
so far and should be not controversal. 

> If anyone proves us wrong (with a specific example - what is mapped 
> where, and what bad effect does it have, or if it's available a 
> crashlog, etc.) we'll certainly reconsider.

Right now first priority should be getting .25 right. This means you 
should fix at least EFI (see my earlier patch today) and
fix the (imho serious) ioremap() alias regression (see other patch) 
EFI is a regression too for 32bit BTW.

Still putting the end_pfn_map fixes into .25 would be nice too, although
they're at least not regression fixes. 

The ioremap patch would be obsolete with the #mm pageattr.c
(assuming you got the alias cases right this time), from the EFI
patch at least the numpages<->size fix is still needed even for #mm

-Andi


