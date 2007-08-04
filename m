Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbXHDWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbXHDWAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761622AbXHDWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:00:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761291AbXHDWAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:00:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION
Date: Sun, 5 Aug 2007 00:09:09 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
References: <200708032359.37677.rjw@sisk.pl> <200708032345.32262.lenb@kernel.org> <200708041148.48357.rjw@sisk.pl>
In-Reply-To: <200708041148.48357.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708050009.10769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 August 2007 11:48, Rafael J. Wysocki wrote:
> On Saturday, 4 August 2007 05:45, Len Brown wrote:
> > On Friday 03 August 2007 18:47, Rafael J. Wysocki wrote:
> > > On Saturday, 4 August 2007 00:01, Linus Torvalds wrote:
> > > > On Fri, 3 Aug 2007, Rafael J. Wysocki wrote:
> [--snip--]
> > >  
> > > +config SUSPEND_UP_POSSIBLE
> > > +	bool
> > > +	depends on BLACKFIN || MIPS || SUPERH || FRV || (PPC32 && PPC_MPC52xx)
> > 
> > please include (X86 && !X86_VOYAGER) here -- else you'll disable
> > SUSPEND from all X86 when built UP.
> 
> Right.  I think I should include everything that can do SMP suspend here.
> 
> Updated patch is appended.

Well, unfortunately, the patch below is buggy, because I need to change
CONFIG_SUSPEND_SMP into CONFIG_PM_SLEEP_SMP in some more places.

I'll send an updated version in a new thread.

Greetings,
Rafael


> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
> 296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
> suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
> (1) not all architectures support suspend and (2) SMP hibernation is only
> possible on X86 and PPC64 (if PPC64_SWSUSP is set).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/Kconfig |   42 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 32 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/power/Kconfig
> +++ linux-2.6/kernel/power/Kconfig
> @@ -72,15 +72,10 @@ config PM_TRACE
>  	CAUTION: this option will cause your machine's real-time clock to be
>  	set to an invalid time after a resume.
>  
> -config SUSPEND_SMP_POSSIBLE
> -	bool
> -	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
> -	depends on SMP
> -	default y
> -
> -config SUSPEND_SMP
> +config PM_SLEEP_SMP
>  	bool
> -	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
> +	depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
> +	depends on PM_SLEEP
>  	select HOTPLUG_CPU
>  	default y
>  
> @@ -89,20 +84,47 @@ config PM_SLEEP
>  	depends on SUSPEND || HIBERNATION
>  	default y
>  
> +config SUSPEND_UP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) || (PPC32 && PPC_MPC52xx) \
> +		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM || BLACKFIN \
> +		   || MIPS || SUPERH || FRV
> +	depends on !SMP
> +	default y
> +
> +config SUSPEND_SMP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) \
> +		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM
> +	depends on SMP
> +	default y
> +
>  config SUSPEND
>  	bool "Suspend to RAM and standby"
>  	depends on PM
> -	depends on !SMP || SUSPEND_SMP_POSSIBLE
> +	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
>  	default y
>  	---help---
>  	  Allow the system to enter sleep states in which main memory is
>  	  powered and thus its contents are preserved, such as the
>  	  suspend-to-RAM state (i.e. the ACPI S3 state).
>  
> +config HIBERNATION_UP_POSSIBLE
> +	bool
> +	depends on X86 || PPC64_SWSUSP || FRV || PPC32
> +	depends on !SMP
> +	default y
> +
> +config HIBERNATION_SMP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) || PPC64_SWSUSP
> +	depends on SMP
> +	default y
> +
>  config HIBERNATION
>  	bool "Hibernation (aka 'suspend to disk')"
>  	depends on PM && SWAP
> -	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND_SMP_POSSIBLE
> +	depends on HIBERNATION_UP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
>  	---help---
>  	  Enable the suspend to disk (STD) functionality, which is usually
>  	  called "hibernation" in user interfaces.  STD checkpoints the
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
