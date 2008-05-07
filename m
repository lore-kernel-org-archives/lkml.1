Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYEGMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYEGMsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYEGMsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:48:12 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52879 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbYEGMsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:48:09 -0400
Date: Wed, 7 May 2008 15:46:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       hpa@zytor.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Undocumented and duplicated code
Message-ID: <20080507124650.GD29935@cs181133002.pp.htv.fi>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 07:39:44PM -0700, Yinghai Lu wrote:
> On Tue, May 6, 2008 at 6:48 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> > Good day.
> >
> >  On 2.6.25 and below, my /proc/cpuinfo looks like:
> >
> >  processor       : 0
> >  vendor_id       : AuthenticAMD
> >  cpu family      : 6
> >  model           : 7
> >  model name      : AMD Duron(tm) Processor
> >  stepping        : 1
> >  cpu MHz         : 1312.969
> >  cache size      : 64 KB
> >  fdiv_bug        : no
> >  hlt_bug         : no
> >  f00f_bug        : no
> >  coma_bug        : no
> >  fpu             : yes
> >  fpu_exception   : yes
> >  cpuid level     : 1
> >  wp              : yes
> >  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov
> > pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
> >  bogomips        : 2628.68
> >  clflush size    : 32
> >
> >  while on current mainline PAT and TS (Temperature Sensor) drop from the
> > feature flags:
> >
> >  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov
> > pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
> >
> >  With respect to PAT, I guess it's 9307cacad0dfe3749f00303125c6f7f0523e5616,
> > "x86: pat cpu feature bit setting for known cpus" but what's this about?
> >
> >  Did my cpuinfo lie upto this point or shouldn't the flag be cleared? The
> > commit message for that change is completely and totally unhelpful.
> 
> others like to to whitebox methods, ..., please try attach patch to
> see if duron support PAT.


There surely is documentation available covering this?

And why do we need this clear_cpu_cap(c, X86_FEATURE_PAT) and then 
manual setting of X86_FEATURE_PAT at all?

There's no indication in the code, and as Rene already says there's even
no description at all in commit 9307cacad0dfe3749f00303125c6f7f0523e5616

Such code really needs a comment explaining why we have to do this at all.

There must be some CPUs with the "pat" flag set but not being usable?
Which?

According to the linux-kernel discussions there might not be any broken 
CPU at all - but in this case the whitelist will not fill itself, and 
expecting people to note that their flags changed and complaining is not 
really a good approach.

And that your commit added the same clear/set code in three different 
places doesn't look good - this really deserved from the beginning being 
factored out into an own function to avoid future problems when CPUs get 
added (like what happens with your patch here - it touches only one 
place, and since the same context is present in two places in the same 
file "patch" might even choose freely where it gets applied...).

Pavel even made a similar comment on linux-kernel before the patch 
got merged into Linus' tree. [1]

Guys, even if it compiles in all randconfig configurations and works on 
all test machines this is exactly the kind of stuff that causes 
headaches in the future.

And this patch (by the author of the code himself) is the first time 
where it breaks.


> YH

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index a428ffc..81483ec 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -314,6 +314,8 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
>  	case X86_VENDOR_AMD:
>  		if (c->x86 >= 0xf && c->x86 <= 0x11)
>  			set_cpu_cap(c, X86_FEATURE_PAT);
> +		if (c->x86 == 6 && c->x86_modes == 7)
> +			set_cpu_cap(c, X86_FEATURE_PAT);
>  		break;
>  	case X86_VENDOR_INTEL:
>  		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))


cu
Adrian

[1] http://lkml.org/lkml/2008/3/28/184

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

