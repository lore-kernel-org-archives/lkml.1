Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbXLYNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbXLYNRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXLYNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 08:17:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbXLYNRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 08:17:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: ACPI:  _PTS ordering needs fixing for pre ACPI 3.0 systems (was: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM)
Date: Tue, 25 Dec 2007 14:36:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-acpi@vger.kernel.org
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <200712250003.27570.carlos@strangeworlds.co.uk> <200712250241.49753.carlos@strangeworlds.co.uk>
In-Reply-To: <200712250241.49753.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251436.52246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of December 2007, Carlos Corbacho wrote:
> Adding Linux-ACPI to CC.
> 
> On Tuesday 25 December 2007 00:03:25 Carlos Corbacho wrote:
> > According to the earlier versions of the ACPI spec, Linux is doing the
> > wrong thing - we should call _PTS() before we start powerding down devices,
> > or notifying device drivers to start suspending.
> >
> > So, my limited understanding of what we currently do for ACPI
> > suspend-to-RAM is:
> >
> > 1) Freeze processes/ devices
> > 2) Put all devices into low power mode
> > 3) Execute _PTS()
> > 4) Suspend system
> >
> > So the problem is - our current suspend order is fine for ACPI 3.0 and
> > above, but for pre-3.0 systems, this violates the older specs, where 2) and
> > 3) should be reversed.
> 
> The following is a hack to illustrate what I'm getting at (this is
> tested on x86-64) (it's a hack since it does all the ACPI prepare bits
> during set_target() for the pre ACPI 3.0 systems, rather than prepare() -
> whether this can be cleaned up to move out just the _PTS() call, I don't
> know).
> 
> It abuses suspend_ops->set_target(), but was the easiest way to quickly
> demonstrate this (since the kerneldoc for set_target() says it will always
> be executed before we suspend the devices).

Please, don't do that.

The current code is following the ACPI 2.0 specification (and later) quite
closely and while we can add a special case for the 1.0-copmpilant systems,
the failing ones tend to be supposed to follow ACPI 2.0 (or later).


>  drivers/acpi/sleep/main.c |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
> index 96d23b3..89e708b 100644
> --- a/drivers/acpi/sleep/main.c
> +++ b/drivers/acpi/sleep/main.c
> @@ -77,8 +77,19 @@ static int acpi_pm_set_target(suspend_state_t pm_state)
>  	} else {
>  		printk(KERN_ERR "ACPI does not support this state: %d\n",
>  			pm_state);
> -		error = -ENOSYS;
> +		return -ENOSYS;
>  	}
> +
> +	/*
> +	 * For ACPI 1.0 and 2.0 systems, we must run the preparation methods
> +	 * before we put the devices into low power mode.
> +	 */
> +	if (acpi_gbl_FADT.header.revision < 3) {

acpi_gbl_FADT.header.revision is equal to 3 for ACPI 2.0-compilant systems
(section 5.2.8 of the specification).

> +		error = acpi_sleep_prepare(acpi_target_sleep_state);
> +		if (error)
> +			acpi_target_sleep_state = ACPI_STATE_S0;
> +	}
> +
>  	return error;
>  }
>  
> @@ -91,10 +102,17 @@ static int acpi_pm_set_target(suspend_state_t pm_state)
>  
>  static int acpi_pm_prepare(void)
>  {
> -	int error = acpi_sleep_prepare(acpi_target_sleep_state);
> +	int error = 0;
>  
> -	if (error)
> -		acpi_target_sleep_state = ACPI_STATE_S0;
> +	/*
> +	 * For ACPI 3.0 or newer systems, we must run the preparation methods
> +	 * after we put the devices into low power mode.
> +	 */
> +	if (acpi_gbl_FADT.header.revision >= 3) {

Same here (so the comment is wrong).

> +		error = acpi_sleep_prepare(acpi_target_sleep_state);
> +		if (error)
> +			acpi_target_sleep_state = ACPI_STATE_S0;
> +	}
>  
>  	return error;
>  }

Thanks,
Rafael
