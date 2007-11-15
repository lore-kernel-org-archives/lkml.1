Return-Path: <linux-kernel-owner+w=401wt.eu-S1765966AbXKOTei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765966AbXKOTei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbXKOTeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:34:31 -0500
Received: from www.tglx.de ([62.245.132.106]:45376 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbXKOTea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:34:30 -0500
Date: Thu, 15 Nov 2007 20:33:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "David P. Reed" <dpreed@reed.com>
cc: linux-kernel@vger.kernel.org, Allessandro Zummo <a.zummo@towertech.it>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] x86: on x86_64, correct reading of PC RTC when update
 in progress in time_64.c
In-Reply-To: <473B9D8A.5000006@reed.com>
Message-ID: <alpine.LFD.0.9999.0711152021270.3112@localhost.localdomain>
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com>
 <1184274754.12353.254.camel@chaos> <473B9D8A.5000006@reed.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, David P. Reed wrote:

Still whitespace wreckage in your patches. I guess the kernel tree you
made your patches against is already white space wrecked.

I fixed that up manually, but please be more careful about that next
time.

> Correct potentially unstable PC RTC time register reading in time_64.c
> 
> Stop the use of an incorrect technique for reading the standard PC RTC
> timer, which is documented to "disconnect" time registers from the bus
> while updates are in progress.  The use of UIP flag while interrupts
> are disabled to protect a 244 microsecond window is one of the
> Motorola spec sheet's documented ways to read the RTC time registers
> reliably.
> 
> The patch updates the misleading comments and also minimizes the amount of
> time that the kernel disables interrupts during the reading.

While I think that the UIP change is correct and a must have, the
locking change is not really useful. read_persistent_clock is called
from exactly three places:

Right after boot, right before suspend and right after resume. None of
those places is a hot path, where we really care about the interrupt
enable/disable. IIRC, this is even called with interrupts disabled
most of the time, so no real gain here.

Another reason not to do the locking change is the paravirt stuff
which is coming for 64bit. I looked into the existing 32bit code and
doing the same lock thing would introduce a real nasty hackery, which
is definitely not worth the trouble.

Thanks,

	tglx

> Signed-off-by: David P. Reed <dpreed@reed.com>
> ---
> Index: linux-2.6/arch/x86/kernel/time_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/time_64.c
> +++ linux-2.6/arch/x86/kernel/time_64.c
> @@ -160,22 +160,30 @@ unsigned long read_persistent_clock(void
>  	unsigned long flags;
>  	unsigned century = 0;
> 
> -	spin_lock_irqsave(&rtc_lock, flags);
> + retry:	spin_lock_irqsave(&rtc_lock, flags);
> +	/* if UIP is clear, then we have >= 244 microseconds before RTC
> +	 * registers will be updated.  Spec sheet says that this is the
> +	 * reliable way to read RTC - registers invalid (off bus) during
> update
> +	 */
> +	if ((CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP)) {
> +	  spin_unlock_irqrestore(&rtc_lock, flags);
> +	  cpu_relax();
> +	  goto retry;
> +	}
> 
> -	do {
> -		sec = CMOS_READ(RTC_SECONDS);
> -		min = CMOS_READ(RTC_MINUTES);
> -		hour = CMOS_READ(RTC_HOURS);
> -		day = CMOS_READ(RTC_DAY_OF_MONTH);
> -		mon = CMOS_READ(RTC_MONTH);
> -		year = CMOS_READ(RTC_YEAR);
> +	/* now read all RTC registers while stable with interrupts disabled */
> +
> +	sec = CMOS_READ(RTC_SECONDS);
> +	min = CMOS_READ(RTC_MINUTES);
> +	hour = CMOS_READ(RTC_HOURS);
> +	day = CMOS_READ(RTC_DAY_OF_MONTH);
> +	mon = CMOS_READ(RTC_MONTH);
> +	year = CMOS_READ(RTC_YEAR);
>  #ifdef CONFIG_ACPI
> -		if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
> -					acpi_gbl_FADT.century)
> -			century = CMOS_READ(acpi_gbl_FADT.century);
> +	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
> +				acpi_gbl_FADT.century)
> +		century = CMOS_READ(acpi_gbl_FADT.century);
>  #endif
> -	} while (sec != CMOS_READ(RTC_SECONDS));
> -
>  	spin_unlock_irqrestore(&rtc_lock, flags);
> 
>  	/*
> 
> 
