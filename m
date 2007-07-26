Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbXGZE1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbXGZE1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 00:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXGZE1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 00:27:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:59032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXGZE04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 00:26:56 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: david@lang.hm
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Thu, 26 Jul 2007 00:26:08 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200707251238.50218.lenb@kernel.org> <200707251851.22777.lenb@kernel.org> <Pine.LNX.4.64.0707251917320.21378@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707251917320.21378@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707260026.08183.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 22:20, david@lang.hm wrote:
> On Wed, 25 Jul 2007, Len Brown wrote:
> 
> > On Wednesday 25 July 2007 14:48, Linus Torvalds wrote:
> >
> >> ... ACPI now seems to select CPU hotplug. Why?
> >
> > ACPI=y SMP=y systems require SUSPEND_SMP=y for system sleep support,
> > and that requires HOTPLUG_CPU=y.
> >
> > Note that ACPI=y SMP=n systems do not need it,
> > and thus will not select HOTPLUG_CPU=y
> >
> >> That is just *broken*. Sure, if you select STR or hibernation, we need CPU
> >> hotplug, but just for picking ACPI? Why?
> >
> > My assumption is that if somebody selects CONFIG_ACPI,
> > that 99% of the time, they intend that to include support for
> > the ACPI hooks for system sleep states.
> >
> > Conversely, supporting the 1% of people who don't want it
> > isn't worth messing with the 99% who do, nor is
> > the burden of yet another config option to maintain and
> > #ifdefs in the code.
> 
> so you are saying that you know better then we do what we need?

Feel free to share what you know about the benefits vs. the costs
of maintaining CONFIG_ACPI_SLEEP as a build option.

> some people configure ACPI only becouse their system won't work properly 
> without it. they have no intention of ever doing a STR or hibernate.

I agree.

Further, I expect that 100% - (some people %) = 99%

If you feel that your system has been degraded
because it now includes what used to be excluded under
CONFIG_ACPI_SLEEP=n, please let me know how.

> > On UP, they'd get ACPI system sleep support 100% of the time
> > by default, but on SMP this option had become problematic.
> >
> > We used to have this:
> >
> > if ACPI
> > ...
> > config ACPI_SLEEP
> >        bool "Sleep States"
> >        depends on X86 && (!SMP || SUSPEND_SMP)
> >        depends on PM
> >        default y
> >
> > So the poster-child failure was i386/defconfig itself...
> > It couldn't support suspend to RAM because it didn't include
> > CONFIG_ACPI_SLEEP.  Not trivial for a user to select it
> > when it doesn't even appear on the menu.  It doesn't appear
> > because CONFIG_SUSPEND_SMP isn't enabled, but that doesn't
> > appear either -- because CONFIG_HOTPLUG_CPU isn't selected.
> 
> so have something like
> 
> config ACPI_SLEEP
>          select HOTPLUG_CPU if X86 && SMP
>          select SUSPEND_SMP if X86 && SMP
> 
> instead of makeing it dependant on ACPI.

If more config options where better, then this
would indeed be an improvement over 2.6.22.
But more config options isn't better -- except for "some people":-)

thanks.
-Len

> > Most users don't want that.
> >
> > So today we have this:
> >
> > menuconfig ACPI
> > 	...
> >        select HOTPLUG_CPU if X86 && SMP
> >        select SUSPEND_SMP if X86 && SMP
> >
> > Which I think leads to fewer surprises, and less complicated code.
> > (even though using select itself is fraught with peril:-)
> >
> > thanks,
> > -Len
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
