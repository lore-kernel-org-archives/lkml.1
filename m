Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYBKNFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYBKNFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYBKNFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:05:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:43487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYBKNFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:05:08 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Date: Mon, 11 Feb 2008 14:05:04 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <20080211093433.DE4961B41CE@basil.firstfloor.org> <20080211124625.GB23733@elte.hu>
In-Reply-To: <20080211124625.GB23733@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802111405.04423.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 13:46:25 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > The memory hotadd code assumes that the pud always exists already, but 
> > that might be not true. Allocate it if it isn't there.
> 
> ok, this seems an like an ancient memory-hotplug bug.

Yes.

> Does anyone even  
> use memory hotplug currently? 

I don't know.

> Did you find this bug via review, or did  
> it trigger in practice?

Review.

> 
> Also, your fix, while it solves a real bug we want to fix, is not quite 
> right for upstream integration yet. I can see 3 immediate problems with 
> it:
> 
> > +			if (!pud_present(*pud)) {
> > +				pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
> 
> the GFP_ATOMIC here can fail.

The memory hotplug code already uses GFP_ATOMIC elsewhere (spp_getpage) 
 
> The proper solution is to instead extend init_memory_mapping() with a 
> gfp_t parameter and pass in GFP_ATOMIC from the early init code (where 
> we must not schedule and where GFP_ATOMIC will succeed anyway), but do a 
> GFP_KERNEL from arch_add_memory().

The existing code already does GFP_ATOMIC. I admit I haven't double
checked why it does that (didn't read the complete path) but I assume
it takes a spin lock somewhere.

If there is no lock doing a general clean up of all of them would probably
make sense.  But it would be orthogonal to my patch and I don't think
it's needed to fix this concrete bug.

The gfp argument is not needed though because this
case can be already distingushed by checking after_bootmem.

> The proper solution is to extend init_memory_mapping() with a return 
> value, and to check in the caller. arch_add_memory() obviously does not 
> want to panic(), it wants to return -ENOMEM to mm/memory_hotplug.c.

The existing code already panics elsewhere (spp_getpage); i just copied
that.

So in summary the panic&GFP_ATOMIC use are not good (I agree), but it's
not worse than what was in there before.

-Andi
