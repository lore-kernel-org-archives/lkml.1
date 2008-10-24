Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYJXCtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYJXCtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 22:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJXCsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 22:48:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbYJXCsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 22:48:54 -0400
Date: Thu, 23 Oct 2008 19:48:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Keith Packard <keithp@keithp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       nickpiggin@yahoo.com.au, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
 2.6.27-rc1)
In-Reply-To: <1224813015.22877.51.camel@koto.keithp.com>
Message-ID: <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>  <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>  <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>  <1224398496.5303.7.camel@koto.keithp.com>
 <20081019175320.GA6442@elte.hu>  <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>  <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>  <1224793332.22877.8.camel@koto.keithp.com> 
 <20081023133840.d4eef579.akpm@linux-foundation.org>  <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org> <1224813015.22877.51.camel@koto.keithp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Oct 2008, Keith Packard wrote:
> 
> > So I'd much rather create a new <linux/kmap.h> or something. Or just 
> > expose this from to <asm/fixmap.h> or something. Let's not confuse this 
> > with highmem, even if the implementation _historically_ was due to that.
> 
> Sure, we readily admit that we're abusing the highmem API. So we wrapped
> that abusive code in a pretty package that can be re-implemented however
> you desire.
> 
> How (and when) would you like to see this fixed?

I'm not entirely sure who wants to own up to owning that particular part 
of code, and is willing to make kmap_atomic_prot_pfn() also work in the 
absense of CONFIG_HIGHMEM.

I suspect it's Ingo, but I also suspect that he'd like to see a tested 
patch by somebody who actually _uses_ this code.

So I would suspect that if you guys actually write a patch, and make sure 
that it works on x86-32 even _without_ CONFIG_HIGHMEM, and send it to 
Ingo, good things will happen.

As to the "without CONFIG_HIGHMEM" part: making all of this work even 
without HIGHMEM should literally be a matter of:

 - remove the '#ifdef CONFIG_HIGHMEM' in <asm/fixmap_32.h>, so that we 
   have fixmap entries for the temporary kernel mappings regardless (ie 
   FIX_KMAP_BEGIN and FIX_KMAP_END).

 - move the code for the atomic accesses that use those fixmap entries 
   into a file that gets compiled regardless of CONFIG_HIGHMEM. Or at 
   least just kmap_atomic_prot_pfn() and kunmap_atomic().

and it probably should all work automatically. The kmap_atomic() stuff 
really should be almost totally independent of CONFIG_HIGHMEM, since it's 
really much more closely related to fixmaps than HIGHMEM. 

I guess there may be some debugging code that depends on HIGHMEM (eg that 
whole testing for whether a page is a highmem page or not), so it might be 
a _bit_ more than just moving code around, but I really didn't look 
closer.

Then, there's the issue of 64-bit, and just mapping everything there, and 
the interface to that. I liked the trivial extension to "struct resource" 
to have a "cached mapping" pointer. So if we can just make it pass 
resources around and get a page that way (and not even need kmap() on 
64-bit architections), that would be good.

It's too late for -rc1 (which I'm planning on cutting within the hour), 
and if it ends up being complex, I guess that it means this will eb a 
2.6.29 issue.

But if it really is just a matter of mostly just some trivial code 
movement and both the gfx and x86 people are all happy, I'll happily take 
it for -rc2, and we can just leave this all behind us.

		Linus
