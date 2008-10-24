Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYJXJO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYJXJO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYJXJOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:14:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYJXJOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:14:47 -0400
Date: Fri, 24 Oct 2008 11:14:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Keith Packard <keithp@keithp.com>,
       Andrew Morton <akpm@linux-foundation.org>, nickpiggin@yahoo.com.au,
       airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
Message-ID: <20081024091414.GA14844@elte.hu>
References: <20081019175320.GA6442@elte.hu> <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu> <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu> <1224793332.22877.8.camel@koto.keithp.com> <20081023133840.d4eef579.akpm@linux-foundation.org> <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org> <1224813015.22877.51.camel@koto.keithp.com> <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 23 Oct 2008, Keith Packard wrote:
> > 
> > > So I'd much rather create a new <linux/kmap.h> or something. Or just 
> > > expose this from to <asm/fixmap.h> or something. Let's not confuse this 
> > > with highmem, even if the implementation _historically_ was due to that.
> > 
> > Sure, we readily admit that we're abusing the highmem API. So we wrapped
> > that abusive code in a pretty package that can be re-implemented however
> > you desire.
> > 
> > How (and when) would you like to see this fixed?
> 
> I'm not entirely sure who wants to own up to owning that particular 
> part of code, and is willing to make kmap_atomic_prot_pfn() also work 
> in the absense of CONFIG_HIGHMEM.

yeah, that would be the x86 maintainers. (whoever they are)

> I suspect it's Ingo, but I also suspect that he'd like to see a tested 
> patch by somebody who actually _uses_ this code.

yeah. I already asked Keith yesterday to send one coherent bundle of 
patches and i think we've got all the code sent already, you also pulled 
the latest DRM tree - so it all just needs sorting out and testing. 

[ I can possibly test the end result with a bleeding-edge Xorg which 
  supports the new DRI APIs. (Whether X comes up fine is a regular, 
  necessary and 'fun' component of the x86 regression testing we do 
  anyway. We also tend to notice highmem breakages promptly.) ]

> So I would suspect that if you guys actually write a patch, and make 
> sure that it works on x86-32 even _without_ CONFIG_HIGHMEM, and send 
> it to Ingo, good things will happen.
> 
> As to the "without CONFIG_HIGHMEM" part: making all of this work even 
> without HIGHMEM should literally be a matter of:
> 
>  - remove the '#ifdef CONFIG_HIGHMEM' in <asm/fixmap_32.h>, so that we 
>    have fixmap entries for the temporary kernel mappings regardless (ie 
>    FIX_KMAP_BEGIN and FIX_KMAP_END).
> 
>  - move the code for the atomic accesses that use those fixmap entries 
>    into a file that gets compiled regardless of CONFIG_HIGHMEM. Or at 
>    least just kmap_atomic_prot_pfn() and kunmap_atomic().
> 
> and it probably should all work automatically. The kmap_atomic() stuff 
> really should be almost totally independent of CONFIG_HIGHMEM, since 
> it's really much more closely related to fixmaps than HIGHMEM.

yeah.

> I guess there may be some debugging code that depends on HIGHMEM (eg 
> that whole testing for whether a page is a highmem page or not), so it 
> might be a _bit_ more than just moving code around, but I really 
> didn't look closer.
> 
> Then, there's the issue of 64-bit, and just mapping everything there, 
> and the interface to that. I liked the trivial extension to "struct 
> resource" to have a "cached mapping" pointer. So if we can just make 
> it pass resources around and get a page that way (and not even need 
> kmap() on 64-bit architections), that would be good.

hm, the thing that i find the weakest aspect of that (despite having 
suggested this approach) is that the structure and the granularity of 
the resource tree is really controlled by the hardware environment. We 
try to map the hardware circumstances accurately at bootstrap / device 
discovery time, and keep it rather static from that point on. (modulo 
hotplug and dynamic BAR sizing)

And this static property of the resource tree is _good_ IMO, because we 
can think about it as a hardware property - not something tweaked by the 
kernel. (the kernel does tweak it when need to be or when the hardware 
asks for it, but it's more of an exception)

That means that if a driver wants to map just a portion of a BAR, 
(because the hardware itself compresses various different pieces of 
functionality into the same BAR), this abstraction becomes a limitation 
on usage.

And it might even be _impossible_ to use the simplest form of 
resource->mem_cache facility with certain types of hardware: say there's 
a cacheable and an uncacheable window within the same BAR - and we'd map 
the whole thing as cacheable. The CPU is then entitled to (and will most 
likely) prefetch into the uncacheable region as well, causing hw 
lockups, etc. [In this thread it was claimed that S3 chips have such 
properties.]

And tweaking this abstraction to cover those cases, for the ioremap to 
not be a full mapping of the resource looks a bit hacky/limiting as 
well:

 - we'd either have to add 'size', 'offset' properties to the window we 
   cache in the struct resource. (and possibly an array. yuck.)

 - or we'd have to say "dont use this facility with such quirky hardware 
   then".

 - or we'd have to say "split up the struct resource into two pieces 
   artificially", when the driver starts using the resource - which 
   violates the current rather static nature of the resource tree.

Maybe i'm overcomplicating it and maybe this last option isnt all that 
bad after all: as the 'combined' resource in such cases _is_ artificial 
- and i915+ does not have such problematic BARs to begin with. (keeping 
separate BARs for the framebuffer is the sane thing to do anyway)

OTOH, Keith's io-mapping API does look pretty natural too - it wraps 
facilities that are already available to drivers, into a coherent unit. 
A driver has to be aware of it anyway, and drivers have to store their 
ioremap results in the private device structure currently anyway, so it 
fits nicely into current ioremap practices and is a gradual extension of 
it.

Discovering the resource at the driver level might be a bit complicated 
(right now there's no need for any 3D driver to even know about struct 
resource - they just use the PCI APIs) and then using it dynamically 
brings up various lifetime questions.

Hm? Right now i'm leaning slightly towards Keith's code - but no strong 
feelings. (Assuming that the atomic-kmap facilities are separated out 
cleanly and are made independent of any highmem connections - but that 
is just a shuffle-code-around-and-test excercise)

> It's too late for -rc1 (which I'm planning on cutting within the 
> hour), and if it ends up being complex, I guess that it means this 
> will eb a 2.6.29 issue.
> 
> But if it really is just a matter of mostly just some trivial code 
> movement and both the gfx and x86 people are all happy, I'll happily 
> take it for -rc2, and we can just leave this all behind us.

ok. I'm pretty optimistic about it because the risk factor seems 
manageable: only one driver is affected by the changes - and that 
driver's authors wrote this new core kernel facility: which is the best 
of all combinations. We can test the x86 side highmem impact just fine.

Plus this portion of the current upstream code in the DRM driver is 
rather ugly to begin with, so in my book this is a fair cleanup/bugfix 
as well.

	Ingo
