Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYASS5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYASS5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYASS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:57:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:37547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYASS51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:57:27 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH] [4/7] Convert TSC disabling to generic cpuid disable bitmap
Date: Sat, 19 Jan 2008 19:57:21 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
References: <20080118627.198787000@suse.de> <20080118172720.86C4F14AAE@wotan.suse.de> <1200766548.32050.32.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1200766548.32050.32.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801191957.21832.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 19:15:48 Ian Campbell wrote:
> On Fri, 2008-01-18 at 18:27 +0100, Andi Kleen wrote:
> > Index: linux/arch/x86/xen/time.c
> > ===================================================================
> > --- linux.orig/arch/x86/xen/time.c
> > +++ linux/arch/x86/xen/time.c
> > @@ -592,7 +592,7 @@ __init void xen_time_init(void)
> >         set_normalized_timespec(&wall_to_monotonic,
> >                                 -xtime.tv_sec, -xtime.tv_nsec);
> >  
> > -       tsc_disable = 0;
> > +       setup_clear_cpu_cap(X86_FEATURE_TSC);
> >  
> >         xen_setup_timer(cpu);
> >         xen_setup_cpu_clockevents();
> 
> That inverts the meaning, doesn't it? Previously the code force the TSC
> to be on and now it forcefully disables it. Now when booting a Xen guest
> I get:
>         Kernel panic - not syncing: Kernel compiled for Pentium+, requires TSC feature!

You're right -- i was a bit overzealous in search'n'replace with that one.
It's the only place who force enables TSC.


> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 6f5c74a..b3721fd 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -592,7 +592,7 @@ __init void xen_time_init(void)
>  	set_normalized_timespec(&wall_to_monotonic,
>  				-xtime.tv_sec, -xtime.tv_nsec);
>  
> -	setup_clear_cpu_cap(X86_FEATURE_TSC);
> +	setup_force_cpu_cap(X86_FEATURE_TSC);

Actually that would be only needed if someone else disabled TSC explicitely before.

Simply deleting this should be sufficient. Does this patch work for you?

It would break if someone passes notsc to a Xen kernel, but then a lot of options make the kernel
break if you don't know what you're doing so that doesn't seem like a big issue.

-Andi

---

Don't disable TSC in Xen boot

That was a typo in the previous TSC option changes.

TSC shouldn't be disabled at this point, so just don't do anything.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/xen/time.c
===================================================================
--- linux.orig/arch/x86/xen/time.c
+++ linux/arch/x86/xen/time.c
@@ -592,8 +592,6 @@ __init void xen_time_init(void)
 	set_normalized_timespec(&wall_to_monotonic,
 				-xtime.tv_sec, -xtime.tv_nsec);
 
-	setup_clear_cpu_cap(X86_FEATURE_TSC);
-
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
 }
