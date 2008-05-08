Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYEHNNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYEHNNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYEHNNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:13:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49979 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYEHNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:13:12 -0400
Date: Thu, 8 May 2008 16:11:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for
	PAT support
Message-ID: <20080508131149.GB7718@cs181133002.pp.htv.fi>
References: <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com> <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:49:19PM +0200, Thomas Gleixner wrote:
> On Wed, 7 May 2008, H. Peter Anvin wrote:
> > Linus Torvalds wrote:
> > > 
> > > > *Certainly* I don't want anything like this crap:
> > > > 
> > > > > -    if (cpu_has_pat)
> > > > > +    if (cpu_has_pat && cpu_has_pat_good)
> > > 
> > > This in fact is likely the best part of it.
> > > 
> > > Because that at least guarantees that we never say we have a good PAT when
> > > the hardware doesn't even report it.
> > > 
> > > As it is, we seem to just blindly override hardware. It may be correct for
> > > all the models we override, but still..
> > > 
> > 
> > Yah, this is not good.  We should mask out the bit, but never, ever, set it if
> > it was clear to begin with (unless we have it on really, *really*, good
> > authority.)
> > 
> > I'm embarrassed to have let that slink by.
> 
> /me too.
> 
> Fix below.
> 
> Thanks,
> 	tglx
>...
> The white list is kept for now to ensure that we can rely on known to
> work CPU types and concentrate on the software induced problems
> instead of fighthing CPU erratas and subtle wreckage caused by not yet
> verified CPUs. Once the PAT code has stabilized enough, we can remove
> the white list and open the can of worms.
>...
> +#ifdef CONFIG_X86_PAT
> +void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
> +{
> +	switch (c->x86_vendor) {
> +	case X86_VENDOR_AMD:
> +		if (c->x86 >= 0xf && c->x86 <= 0x11)
> +			return;
> +		break;
> +	case X86_VENDOR_INTEL:
> +		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> +			return;
> +		break;
> +	}
>...

This still has the inconsistent handling of future CPUs between AMD
and Intel.

IMHO we should also assume for future AMD CPUs that PAT will work until 
proven otherwise.

Besides this, I didn't spot any problem in the patch. 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

