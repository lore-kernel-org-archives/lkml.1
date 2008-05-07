Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbYEGTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbYEGTks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933154AbYEGTkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:40:22 -0400
Received: from smtp.enter.net ([216.193.128.24]:2126 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765246AbYEGTkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:40:14 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26, PAT and AMD family 6
Date: Wed, 7 May 2008 15:39:30 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <4821A7E2.6080101@keyaccess.nl>
In-Reply-To: <4821A7E2.6080101@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071539.32594.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2008 09:00:18 Rene Herman wrote:
> On 07-05-08 04:39, Yinghai Lu wrote:
> > On Tue, May 6, 2008 at 6:48 PM, Rene Herman <rene.herman@keyaccess.nl> 
wrote:
> >>  On 2.6.25 and below, my /proc/cpuinfo looks like:
> >>
> >>  processor       : 0
> >>  vendor_id       : AuthenticAMD
> >>  cpu family      : 6
> >>  model           : 7
> >>  model name      : AMD Duron(tm) Processor
>
> [ ... ]
>
> >>  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> >> cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
> >>
> >>  while on current mainline PAT and TS (Temperature Sensor) drop from the
> >> feature flags:
> >>
> >>  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> >> cmov pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
> >>
> >>  With respect to PAT, I guess it's
> >> 9307cacad0dfe3749f00303125c6f7f0523e5616, "x86: pat cpu feature bit
> >> setting for known cpus" but what's this about?
> >>
> >> Did my cpuinfo lie upto this point or shouldn't the flag be cleared? The
> >> commit message for that change is completely and totally unhelpful.
> >
> > others like to to whitebox methods, ..., please try attach patch to
> > see if duron support PAT.
> >
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index a428ffc..81483ec 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -314,6 +314,8 @@ static void __cpuinit early_get_cap(struct
> > cpuinfo_x86 *c) case X86_VENDOR_AMD:
> >  		if (c->x86 >= 0xf && c->x86 <= 0x11)
> >  			set_cpu_cap(c, X86_FEATURE_PAT);
> > +		if (c->x86 == 6 && c->x86_modes == 7)
> > +			set_cpu_cap(c, X86_FEATURE_PAT);
> >  		break;
> >  	case X86_VENDOR_INTEL:
> >  		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
>
> s/modes/model/ but, as far as I'm aware, works fine other than that. When I
> boot with CONFIG_X86_PAT after applying that, I see:
>
> 	x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>
> and PAT is retained in the feature flags. However, this I do not consider
> very surprising. Why is this code doing what it is doing in the first
> place?
>
> These feature flags are read from hardware in the CPUID instruction. Why is
> this code then going "ah, this CPU may _claim_ PAT but we won't actually
> believe it unless it's model foo, bar or baz". Is that feature flag buggy?

HPA asked about why they used a whitelist instead of a blacklist in [1]. The 
answer (in [2]) was that those are the CPU's that are guaranteed to properly 
support PAT (no known or potential errata). However in [3] Dean Gaudet 
complained about the AMD detection code having a limit that the Intel 
detection code did not. Perhaps changing the 'c->x86 <= 0x11' test in the 
X86_VENDOR_AMD block to not exist?

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index a428ffc..81483ec 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -314,6 +314,8 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 
*c)
>       case X86_VENDOR_AMD:
>               if (c->x86 >= 0xf && c->x86 <= 0x11)
>                       set_cpu_cap(c, X86_FEATURE_PAT);
> +             if (c->x86 == 6 && c->x86_modes == 7)
> +                     set_cpu_cap(c, X86_FEATURE_PAT);
                     ^^^^^---- Here in Rene's patch...
Wouldn't this be better if written the same as the Intel side, ie:
if (c->x86 >= 0xF && (c->x86 == 6 && c->x86_model == 7))
(or even with c->x86_model >= 7  ?)

>               break;
>       case X86_VENDOR_INTEL:
>               if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))

DRH

[1] http://lkml.org/lkml/2008/3/25/118
[2] http://lkml.org/lkml/2008/3/25/292
[3] http://lkml.org/lkml/2008/3/30/37

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
