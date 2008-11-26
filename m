Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYKZVT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYKZVT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYKZVTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:19:17 -0500
Received: from www.tglx.de ([62.245.132.106]:36816 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYKZVTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:19:17 -0500
Date: Wed, 26 Nov 2008 22:18:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <20081126140054.GX6703@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0811262156390.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain> <20081126140054.GX6703@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Andi Kleen wrote:

> On Wed, Nov 26, 2008 at 02:35:18PM +0100, Thomas Gleixner wrote:
> > > +	 * 	  does not work with other types of PMU registers.Thus, no
> > > +	 * 	  address is ever exposed by counters
> > > +	 *
> > > +	 * 	- there is never a dependency between one pmd register and
> > > +	 * 	  another
> > > +	 */
> > > +	for (i = 0; num; i++) {
> > > +		if (likely(pfm_arch_bv_test_bit(i, set->used_pmds))) {
> > > +			pfm_write_pmd(ctx, i, set->pmds[i]);
> > > +			num--;
> > > +		}
> > > +	}
> > 
> >   This loop construct looks scary. It relies on set->nused_pmds >=
> >   bits set in set->used_pmds. I had to look more than once to
> >   understand that. It's used all over the code in variations.
> 
> FWIW this loop style tripped me up during review too.

It's even worse than I thought when looking at it a second time:

All the loops iterate over an array which means in the worst case we
do full array_size iterations. In each iteration we check whether the
corresponding bit in the bitmask is set or not.

What a nonsense. We have a bitmask already. Why not iterate over the
bitmask and be done ?

Thanks,

	tglx
