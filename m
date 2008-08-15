Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYHOOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYHOOWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYHOOWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:22:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYHOOWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:22:44 -0400
Date: Fri, 15 Aug 2008 16:22:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080815142218.GC12954@elte.hu>
References: <48972EA8.8040001@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48972EA8.8040001@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(more people Cc:-ed)

* Rene Herman <rene.herman@keyaccess.nl> wrote:

> Hi Dave.
>
> A while ago I sent a message about long AGP delays upon starting and 
> exiting X:
>
> http://marc.info/?l=linux-kernel&m=121647129632110&w=2
>
> There was no reply (if that was due to the linux.ie address, could you  
> perhaps update it in MAINTAINERS?) but today Shaohua Li posted a patch  
> that made me wonder about PAT in this context:
>
> http://marc.info/?l=linux-kernel&m=121783222306075&w=2
> http://marc.info/?l=linux-kernel&m=121783222406078&w=2
> http://marc.info/?l=linux-kernel&m=121783222406081&w=2
>
> His patch does not solve anything appreciable for me -- the delays are  
> still as described in that previous post, with an exception for (with  
> Option "AGSize" "64") delays upon exiting X that are now sometimes as  
> bad as a full 12 seconds.
>
> What _does_ solve this though is booting with the "nopat" command line  
> parameter. I'm on 2.6.26.1 and have enabled PAT for my AMD Duron myself.  
> With "nopat", there's no problem to be seen anymore -- exiting X  
> specifically is instantaneous.
>
> With or without PAT, my /proc/mtrr is always:
>
> reg00: base=0x00000000 (   0MB), size= 512MB: write-back, count=1
> reg01: base=0x20000000 ( 512MB), size= 256MB: write-back, count=1
> reg02: base=0xe8000000 (3712MB), size=  64MB: write-combining, count=1
>
> under X joined by:
>
> reg03: base=0xe4000000 (3648MB), size=  32MB: write-combining, count=2
>
> This is a machine with 768M, the AGP aperture set to 64MB and a 32MB  
> Matrox Millenium G550 AGP card. More detail in previous post.
>
> Is this something inherent to PAT? Inherent to PAT on AMD family 6?  
> Inherent to DRM/AGP with PAT? On AMD family 6?
>
> This is probably fairly important to get sorted because although I don't  
> know what's where at the moment, last I saw was a patch in x86/tip that  
> enabled PAT on many more models including all of AMD.
>
> For reference, /proc/cpuinfo:
>
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 6
> model		: 7
> model name	: AMD Duron(tm) Processor
> stepping	: 1
> cpu MHz		: 1313.094
> cache size	: 64 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov  
> pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
> bogomips	: 2628.89
> clflush size	: 32
> power management: ts
>
> and the PAT enabler patch that I apply locally to 2.6.26:
>
> diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c  
> b/arch/x86/kernel/cpu/addon_cpuid_features.c
> index c2e1ce3..8992282 100644
> --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -55,7 +55,7 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
>  {
>         switch (c->x86_vendor) {
>         case X86_VENDOR_AMD:
> -               if (c->x86 >= 0xf && c->x86 <= 0x11)
> +               if (c->x86 == 6 || c->x86 >= 0xf)
>                         return;
>                 break;
>         case X86_VENDOR_INTEL:

agreed - +12 seconds wait suggest some rather fundamental breakage. Did 
we go back to uncached for some critical display area that makes X start 
up (shut down) that slowly? Did we mark the BIOS uncacheable perhaps, 
causing X to execute BIOS code very slowly?

	Ingo
