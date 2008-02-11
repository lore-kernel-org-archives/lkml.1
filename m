Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbYBKM2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbYBKM2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYBKM2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:28:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYBKM17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:27:59 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [2/8] CPA: Flush the caches when setting pages not present
Date: Mon, 11 Feb 2008 13:26:31 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <20080211093430.D198A1B41CE@basil.firstfloor.org> <20080211110025.GA15373@elte.hu>
In-Reply-To: <20080211110025.GA15373@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111326.31515.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 12:00:25 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > e.g. the AMD64 pci-gart code sets pages not present to prevent 
> > potential cache coherency problems.  When doing this it is probably 
> > safer to flush the caches too. So consider clearing of the present bit 
> > as a cache flush indicator.
> 
> uhm, but why?  "Probably safer" is not the right kind of technical  
> argument ;-)

It is safer in my opinion, but I have not seen a concrete bug triggered by
it so I qualified it.

Also it is quite common to qualify technical arguments this way BTW.
 
> The PCI-GART quirk which we use on some systems unmaps pages _not_ 
> because of coherency problems (any cache coherency problems would be 
> triggerable before we unmap them anyway),

The GART is unmapped to avoid a cache coherency problem. AGP 
normally requires cache flushes and changing to uncached to map  
pages into the GART. Otherwise you could have cache incoherence
between the original page and the remapped page.
Since it would be very expensive to call cpa on each pci_map_* 
to turn the pages uncached the  IOMMU part of the GART is unmapped instead 
so that the CPU only ever sees the original memory; never the remapped
part.

> but due to _page aliasing_  
> problems: these pages might be in our general e820 map so we must 
> disable them.
> 
> ( in any case, the CPA code does not deal with cache attribute coherency 
>   - that is topic of the upcoming PAT feature. We still largely rely on 
>   MTRRs to get cache coherency right. )

If it wouldn't deal with cache coherency surely it wouldn't need to flush
caches ...

I started pageattr.c originally to deal with a concrete cache coherency
bugs (AGP cache corruptions between GART and original page on Athlon K7).
This is so that when a page is remapped in the GART it is changed in the 
direct mapping to uncached. Without that there was a reproducible cache corruption
on some systems which was very hard to track down and debug.

Even with all your changes it still does that.

All the other uses like DEBUG_RODATA or DEBUG_PAGEALLOC only came later.

 
> furthermore, your patch does not even do what you claim it does, because
> it is an elaborate NOP on most modern CPUs:
> 
> > +static inline int cache_attr(pgprot_t set, pgprot_t clr)
> >  {
> > -	return pgprot_val(attr) &
> > +	/*
> > +	 * Clearing pages is usually done for cache cohereny reasons
> > +	 * (except for pagealloc debug, but that doesn't call this anyways)
> > +	 * It's safer to flush the caches in this case too.
> > +	 */
> > +	if (pgprot_val(clr) & _PAGE_PRESENT)
> > +		return 1;
> 
> as clflush does not work on not present pages...

Hmm, that's true. It needs to force WBINVD for this case. 
I'll revise. Thanks.

-Andi
