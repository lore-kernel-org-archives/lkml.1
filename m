Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbXHMWsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbXHMWsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXHMWsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:48:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:45829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbXHMWsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:48:08 -0400
Date: Tue, 14 Aug 2007 01:42:17 +0200
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070813234217.GI3406@bingen.suse.de>
References: <200708102013.49170.ak@suse.de> <Pine.LNX.4.64.0708101201240.17549@schroedinger.engr.sgi.com> <200708110304.55433.ak@suse.de> <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com> <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com> <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131518320.28626@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708131518320.28626@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 03:22:25PM -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Andi Kleen wrote:
> 
> > > x86_64 is the only platforms that uses ZONE_DMA32. Ia64 and other 64 bit 
> > > platforms use ZONE_DMA for <4GB allocs.
> > 
> > Yes, but ZONE_DMA32 == ZONE_DMA.
> 
> I am not sure what you mean by that. Ia64 ZONE_DMA == x86_84 ZONE_DMA32?

Hmm, when I wrote GFP_DMA32 it was a #define GFP_DMA32 GFP_DMA 
on ia64 so that drivers not need to ifdef.  Someone nasty
seems to have removed that too. I guess it would be best
to readd.

> 
> > Also when the slab users of GFP_DMA are all gone ia64 won't need
> > the slab support anymore. So either you change your ifdef in slub or 
> > switch to ZONE_DMA32 for IA64.
> 
> If you have gotten rid of all slab users of GFP_DMA (and also all arch 
> uses of it) then we can drop the code in SLAB.

No, e.g. s390 and some other architectures still use it.
You'll need to bug their respective maintainers.


> 1. Drop sl?b support for GFP_DMA.

Not yet.

> 
> 2. Drop GFP_DMA32 support.
> 
> Then we only allow page allocator allocs using GFP_DMA? That may be the 

Kind of yes.

> least invasive for arch code.

I would prefer for GFP_DMA to go away on x86 (but GFP_DMA32 stay). This way
we get clean compile errors instead of subtle breakage. Silently
changing the semantics would be bad.

But then it wouldn't make sense to have GFP_DMA on ia64 and GFP_DMA32
on x86. Since driver writers are more likely to test on x86
I would recommend ia64 having compatible semantics. It'll
save everybody trouble long term. This means it wouldn't 
help on IA64 machines that don't have a DMA zone -- they
would still need to validate drivers especially -- but at least
the others.

Also from my driver review driver authors often seem to have
trouble understanding what GFP_DMA really does. With GFP_DMA32 it 
is clearer that it applies to a address range and is not
some synonym for pci_map_*

-Andi

