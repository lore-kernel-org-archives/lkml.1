Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYJVS7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYJVS7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYJVS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:59:21 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:40569 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYJVS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:59:19 -0400
Date: Wed, 22 Oct 2008 14:58:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI suspend: Fix CONFIG_ACPI_SLEEP dependence and some
 compilation warnings (was: Re: [announce] new tree:
 "fix all build warnings, on all configs")
In-reply-to: <200810221423.44216.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Message-id: <alpine.LFD.1.10.0810221458510.3010@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Nq7q/LjSYOaibcUpFcXwVw)"
References: <20081017171139.GA1792@elte.hu> <200810212137.58020.rjw@sisk.pl>
 <alpine.LFD.1.10.0810220008050.2984@localhost.localdomain>
 <200810221423.44216.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_Nq7q/LjSYOaibcUpFcXwVw)
Content-type: TEXT/PLAIN; charset=utf-8
Content-transfer-encoding: 8BIT

applied.

thanks,
-Len

On Wed, 22 Oct 2008, Rafael J. Wysocki wrote:

> On Wednesday, 22 of October 2008, Len Brown wrote:
> > 
> > > >   drivers/acpi/sleep/main.c:67: warning: ‘acpi_pm_disable_gpes’ defined but not used
> > 
> > > > 
> > > > Shows that this code has an identity crisis due to a maze of #ifdefs, in
> > > > the PM_SLEEP && !SUSPEND && !HIBERNATION case for example.
> > > 
> > > This case is invalid, because PM_SLEEP == SUSPEND || HIBERNATION !
> > 
> > I though so too, but 2.6.27 appears to have added XEN to the mix:
> > 
> > config PM_SLEEP
> >         bool
> >         depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
> 
> Yeah, which breaks things. :-(
> 
> The patch below should fix it and BTW I think ACPI_SLEEP should not depend
> on XEN_SAVE_RESTORE anyway, so this is a bug fix really (please consider as
> .28 material, probably -stable too).
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACPI suspend: Fix CONFIG_ACPI_SLEEP dependence and some compilation warnings
> 
> Initially CONFIG_PM_SLEEP was defined as
> CONFIG_SUSPEND || CONFIG_HIBERNATION and some ACPI code, most
> importantly the code in drivers/acpi/main.c, was written with this
> assumption.  Currently, however, CONFIG_PM_SLEEP is also set when
> CONFIG_XEN_SAVE_RESTORE is set.
> 
> This causes some compilation warnings to appear in
> drivers/acpi/main.c if both CONFIG_SUSPEND and CONFIG_HIBERNATION
> are unset and CONFIG_PM_SLEEP is set (this was impossible before).
> To fix this problem, redefine CONFIG_ACPI_SLEEP do depend directly
> on CONFIG_SUSPEND || CONFIG_HIBERNATION, as originally intended, and
> use it instead of CONFIG_PM_SLEEP in drivers/acpi/main.c, wherever
> appropriate.
> 
> Additionally, move the acpi_target_sleep_state definition from under
> the #ifdef to prevent compilation from failing in some cases. 
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/acpi/Kconfig      |    2 +-
>  drivers/acpi/sleep/main.c |    7 +++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/Kconfig
> +++ linux-2.6/drivers/acpi/Kconfig
> @@ -42,7 +42,7 @@ if ACPI
>  
>  config ACPI_SLEEP
>  	bool
> -	depends on PM_SLEEP
> +	depends on SUSPEND || HIBERNATION
>  	default y
>  
>  config ACPI_PROCFS
> Index: linux-2.6/drivers/acpi/sleep/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/sleep/main.c
> +++ linux-2.6/drivers/acpi/sleep/main.c
> @@ -23,6 +23,7 @@
>  #include "sleep.h"
>  
>  u8 sleep_states[ACPI_S_STATE_COUNT];
> +static u32 acpi_target_sleep_state = ACPI_STATE_S0;
>  
>  static int acpi_sleep_prepare(u32 acpi_state)
>  {
> @@ -45,9 +46,7 @@ static int acpi_sleep_prepare(u32 acpi_s
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
> -static u32 acpi_target_sleep_state = ACPI_STATE_S0;
> -
> +#ifdef CONFIG_ACPI_SLEEP
>  /*
>   * ACPI 1.0 wants us to execute _PTS before suspending devices, so we allow the
>   * user to request that behavior by using the 'acpi_old_suspend_ordering'
> @@ -132,7 +131,7 @@ static void acpi_pm_end(void)
>  	 */
>  	acpi_target_sleep_state = ACPI_STATE_S0;
>  }
> -#endif /* CONFIG_PM_SLEEP */
> +#endif /* CONFIG_ACPI_SLEEP */
>  
>  #ifdef CONFIG_SUSPEND
>  extern void do_suspend_lowlevel(void);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--Boundary_(ID_Nq7q/LjSYOaibcUpFcXwVw)--
