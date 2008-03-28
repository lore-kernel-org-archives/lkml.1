Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYC1PBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYC1PBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYC1PBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:01:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:3016 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYC1PBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qkQWAItP4JAoB72fkGv7keyD54LOmq89sm9DDRVTmwWsTwWlZUOwt/v2OQ8RUuSDbati0P6rieTVx3RI82uX/hVijC4orXCldyevVSI4+SLIui7REHeR5rSYnibgnk+nXa6j+J/iCz9BPwiu3jbDnGzxTZiyFzX29WmsmLp3QEA=
Message-ID: <86802c440803280751r7d8d57bel11058ae87cb2990d@mail.gmail.com>
Date: Fri, 28 Mar 2008 07:51:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080328134102.GA4404@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242324.35357.yhlu.kernel@gmail.com>
	 <20080328134102.GA4404@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 6:41 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
>
>  On Mon 2008-03-24 23:24:34, Yinghai Lu wrote:
>  > [PATCH] x86: pat cpu feature bit setting for known cpus
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>  > index eb94460..b186047 100644
>  > --- a/arch/x86/kernel/cpu/common.c
>  > +++ b/arch/x86/kernel/cpu/common.c
>  > @@ -309,6 +309,19 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
>  >
>  >       }
>  >
>  > +     clear_cpu_cap(c, X86_FEATURE_PAT);
>  > +
>  > +     switch (c->x86_vendor) {
>  > +     case X86_VENDOR_AMD:
>  > +             if (c->x86 >= 0xf && c->x86 <= 0x11)
>  > +                     set_cpu_cap(c, X86_FEATURE_PAT);
>  > +             break;
>  > +     case X86_VENDOR_INTEL:
>  > +             if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
>  > +                     set_cpu_cap(c, X86_FEATURE_PAT);
>  > +             break;
>  > +     }
>  > +
>  >  }
>  >
>  >  /*
>  > @@ -397,6 +410,18 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>  >               init_scattered_cpuid_features(c);
>  >       }
>  >
>  > +     clear_cpu_cap(c, X86_FEATURE_PAT);
>  > +
>  > +     switch (c->x86_vendor) {
>  > +     case X86_VENDOR_AMD:
>  > +             if (c->x86 >= 0xf && c->x86 <= 0x11)
>  > +                     set_cpu_cap(c, X86_FEATURE_PAT);
>  > +             break;
>  > +     case X86_VENDOR_INTEL:
>  > +             if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
>  > +                     set_cpu_cap(c, X86_FEATURE_PAT);
>  > +             break;
>  > +     }
>  >  }
>  >
>
>  Cut&paste programming? Can you make it a function?

yes. just want to leave one stub, so could add other cap setting if
needed later in early or late identify_cpu.

>
>
>  > diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
>  > index 3f1dc97..ddaaaaa 100644
>  > --- a/arch/x86/kernel/setup_64.c
>  > +++ b/arch/x86/kernel/setup_64.c
>  > @@ -979,12 +979,19 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
>  >       if (c->extended_cpuid_level >= 0x80000007)
>  >               c->x86_power = cpuid_edx(0x80000007);
>  >
>  > +
>  > +     clear_cpu_cap(c, X86_FEATURE_PAT);
>
>
>
>  >       switch (c->x86_vendor) {
>  >       case X86_VENDOR_AMD:
>  >               early_init_amd(c);
>  > +             if (c->x86 >= 0xf && c->x86 <= 0x11)
>  > +                     set_cpu_cap(c, X86_FEATURE_PAT);
>  >               break;
>  >       case X86_VENDOR_INTEL:
>  >               early_init_intel(c);
>  > +             if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
>  > +                     set_cpu_cap(c, X86_FEATURE_PAT);
>  >               break;
>  >       }
>
>  one more copy...

for 64 bit.

YH
