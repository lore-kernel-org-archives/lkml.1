Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbXITRhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbXITRhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXITRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:37:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:42535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbXITRhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hOFsJ2uKwDp1jTvU8NTmG9a9sZnYfdeaH/KNkOIfZS5TXFW1jnjBftXYpfTRnKStCTYkQFKnQQzMU5zZlBZjVz2IbQBcxj8FfUBk3NJxXSZGFuuDnccHaG11qWJM94xJWzS18OsETm0QqsjvLHU+9h9ENI5m5k4/0LMATrMRYp8=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [BUG]: ACPI wakup devices (/proc/acpi/wakeup) don't wake the system anymore after hibernation
Date: Thu, 20 Sep 2007 19:37:03 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200709201813.28497.maximlevitsky@gmail.com> <200709201237.27469.lenb@kernel.org>
In-Reply-To: <200709201237.27469.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201937.03492.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 18:37:27 Len Brown wrote:
> On Thursday 20 September 2007 12:13, Maxim Levitsky wrote:
> > Hi,
> > 
> > I had always a issue with wake-up devices after suspend-to disk.
> > 
> > Scenario 1:
> > 1) enable all devices devices: (echo "....." > /proc/acpi/wakeup), I have a script that does that
> > 2) suspend to ram
> > 3) hit a key on keyboard / mouse / send WOL magc packet, and system resumes in all cases
> > 4) repeat the above, and all the same, good.
> > 
> > Scenario 2:
> > 1) enable all devices devices: (echo "....." > /proc/acpi/wakeup)
> > 2) suspend to disk
> > 3) send WOL, doesn't wake the system, but should, and usb can't wake since it is powered off
> > 4) power system on, let system resume from disk, works
> > 5) suspend to ram
> > 6) hit a key on keyboard / mouse / send WOL magic packet, nothing works.
> > 
> > I never got to the bottom of that issue, and just gave up, but not long ago,
> > and I sadly don't remember exactly when / what .config I had, it begin to work
> > I decided that this bug is fixed, and since I suspend to disk rarely, I assumed it works
> > But now, I discovered that this bug is back, and I don't know what to do
> > I tried 2.6.22, 2.6.21-rc7, 2.6.23-rc1, and all fail in same way.
> 
> Yes, please try this one:
> 
> commit ea256a37b093b9c0c0fa639eb9a0bff10df41998
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Wed Sep 12 14:04:32 2007 +0400
> 
>     ACPI: Hibernate erroneously disabled Suspend wakeup devices
>     
>     S4 suspend to disk will disable GPE's permanently
>     because acpi_gpe_sleep_prepare() does not have
>     a counterpart at resume time.  Thus, those devices
>     became unavailable for wakeup from subsequent
>     S3 suspend-to-ram.
>     
>     Here acpi_gpe_sleep_prepare() is removed, and upon suspend
>     acpi_enable_wakeup_device() gets its functionality.
>     Upon resume, acpi_disable_wakeup_device() restores the state.
>     
>     https://bugzilla.novell.com/show_bug.cgi?id=292300
>     
>     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>     Acked-by:  Pavel Machek <pavel@suse.cz>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> diff --git a/drivers/acpi/sleep/poweroff.c b/drivers/acpi/sleep/poweroff.c
> index 39e40d5..2725a60 100644
> --- a/drivers/acpi/sleep/poweroff.c
> +++ b/drivers/acpi/sleep/poweroff.c
> @@ -32,7 +32,6 @@ int acpi_sleep_prepare(u32 acpi_state)
>  	ACPI_FLUSH_CPU_CACHE();
>  	acpi_enable_wakeup_device_prep(acpi_state);
>  #endif
> -	acpi_gpe_sleep_prepare(acpi_state);
>  	acpi_enter_sleep_state_prep(acpi_state);
>  	return 0;
>  }
> diff --git a/drivers/acpi/sleep/sleep.h b/drivers/acpi/sleep/sleep.h
> index ff1f850..a2ea125 100644
> --- a/drivers/acpi/sleep/sleep.h
> +++ b/drivers/acpi/sleep/sleep.h
> @@ -5,6 +5,5 @@ extern int acpi_suspend (u32 state);
>  extern void acpi_enable_wakeup_device_prep(u8 sleep_state);
>  extern void acpi_enable_wakeup_device(u8 sleep_state);
>  extern void acpi_disable_wakeup_device(u8 sleep_state);
> -extern void acpi_gpe_sleep_prepare(u32 sleep_state);
>  
>  extern int acpi_sleep_prepare(u32 acpi_state);
> diff --git a/drivers/acpi/sleep/wakeup.c b/drivers/acpi/sleep/wakeup.c
> index 97c27dd..ed8e41b 100644
> --- a/drivers/acpi/sleep/wakeup.c
> +++ b/drivers/acpi/sleep/wakeup.c
> @@ -64,36 +64,29 @@ void acpi_enable_wakeup_device(u8 sleep_state)
>  	ACPI_FUNCTION_TRACE("acpi_enable_wakeup_device");
>  	spin_lock(&acpi_device_lock);
>  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> -		struct acpi_device *dev = container_of(node,
> -						       struct acpi_device,
> -						       wakeup_list);
> -
> +		struct acpi_device *dev =
> +			container_of(node, struct acpi_device, wakeup_list);
> +		if (!dev->wakeup.flags.valid)
> +			continue;
>  		/* If users want to disable run-wake GPE,
>  		 * we only disable it for wake and leave it for runtime
>  		 */
> -		if (dev->wakeup.flags.run_wake && !dev->wakeup.state.enabled) {
> -			spin_unlock(&acpi_device_lock);
> -			acpi_set_gpe_type(dev->wakeup.gpe_device,
> -					  dev->wakeup.gpe_number,
> -					  ACPI_GPE_TYPE_RUNTIME);
> -			/* Re-enable it, since set_gpe_type will disable it */
> -			acpi_enable_gpe(dev->wakeup.gpe_device,
> -					dev->wakeup.gpe_number, ACPI_ISR);
> -			spin_lock(&acpi_device_lock);
> +		if (!dev->wakeup.state.enabled ||
> +		    sleep_state > (u32) dev->wakeup.sleep_state) {
> +			if (dev->wakeup.flags.run_wake) {
> +				spin_unlock(&acpi_device_lock);
> +				/* set_gpe_type will disable GPE, leave it like that */
> +				acpi_set_gpe_type(dev->wakeup.gpe_device,
> +						  dev->wakeup.gpe_number,
> +						  ACPI_GPE_TYPE_RUNTIME);
> +				spin_lock(&acpi_device_lock);
> +			}
>  			continue;
>  		}
> -
> -		if (!dev->wakeup.flags.valid ||
> -		    !dev->wakeup.state.enabled ||
> -		    (sleep_state > (u32) dev->wakeup.sleep_state))
> -			continue;
> -
>  		spin_unlock(&acpi_device_lock);
> -		/* run-wake GPE has been enabled */
>  		if (!dev->wakeup.flags.run_wake)
>  			acpi_enable_gpe(dev->wakeup.gpe_device,
>  					dev->wakeup.gpe_number, ACPI_ISR);
> -		dev->wakeup.state.active = 1;
>  		spin_lock(&acpi_device_lock);
>  	}
>  	spin_unlock(&acpi_device_lock);
> @@ -112,26 +105,25 @@ void acpi_disable_wakeup_device(u8 sleep_state)
>  
>  	spin_lock(&acpi_device_lock);
>  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> -		struct acpi_device *dev = container_of(node,
> -						       struct acpi_device,
> -						       wakeup_list);
> +		struct acpi_device *dev =
> +			container_of(node, struct acpi_device, wakeup_list);
>  
> -		if (dev->wakeup.flags.run_wake && !dev->wakeup.state.enabled) {
> -			spin_unlock(&acpi_device_lock);
> -			acpi_set_gpe_type(dev->wakeup.gpe_device,
> -					  dev->wakeup.gpe_number,
> -					  ACPI_GPE_TYPE_WAKE_RUN);
> -			/* Re-enable it, since set_gpe_type will disable it */
> -			acpi_enable_gpe(dev->wakeup.gpe_device,
> -					dev->wakeup.gpe_number, ACPI_NOT_ISR);
> -			spin_lock(&acpi_device_lock);
> +		if (!dev->wakeup.flags.valid)
>  			continue;
> -		}
> -
> -		if (!dev->wakeup.flags.valid ||
> -		    !dev->wakeup.state.active ||
> -		    (sleep_state > (u32) dev->wakeup.sleep_state))
> +		if (!dev->wakeup.state.enabled ||
> +		    sleep_state > (u32) dev->wakeup.sleep_state) {
> +			if (dev->wakeup.flags.run_wake) {
> +				spin_unlock(&acpi_device_lock);
> +				acpi_set_gpe_type(dev->wakeup.gpe_device,
> +						  dev->wakeup.gpe_number,
> +						  ACPI_GPE_TYPE_WAKE_RUN);
> +				/* Re-enable it, since set_gpe_type will disable it */
> +				acpi_enable_gpe(dev->wakeup.gpe_device,
> +						dev->wakeup.gpe_number, ACPI_NOT_ISR);
> +				spin_lock(&acpi_device_lock);
> +			}
>  			continue;
> +		}
>  
>  		spin_unlock(&acpi_device_lock);
>  		acpi_disable_wakeup_device_power(dev);
> @@ -142,7 +134,6 @@ void acpi_disable_wakeup_device(u8 sleep_state)
>  			acpi_clear_gpe(dev->wakeup.gpe_device,
>  				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
>  		}
> -		dev->wakeup.state.active = 0;
>  		spin_lock(&acpi_device_lock);
>  	}
>  	spin_unlock(&acpi_device_lock);
> @@ -160,48 +151,20 @@ static int __init acpi_wakeup_device_init(void)
>  		struct acpi_device *dev = container_of(node,
>  						       struct acpi_device,
>  						       wakeup_list);
> -
>  		/* In case user doesn't load button driver */
> -		if (dev->wakeup.flags.run_wake && !dev->wakeup.state.enabled) {
> -			spin_unlock(&acpi_device_lock);
> -			acpi_set_gpe_type(dev->wakeup.gpe_device,
> -					  dev->wakeup.gpe_number,
> -					  ACPI_GPE_TYPE_WAKE_RUN);
> -			acpi_enable_gpe(dev->wakeup.gpe_device,
> -					dev->wakeup.gpe_number, ACPI_NOT_ISR);
> -			dev->wakeup.state.enabled = 1;
> -			spin_lock(&acpi_device_lock);
> -		}
> +		if (!dev->wakeup.flags.run_wake || dev->wakeup.state.enabled)
> +			continue;
> +		spin_unlock(&acpi_device_lock);
> +		acpi_set_gpe_type(dev->wakeup.gpe_device,
> +				  dev->wakeup.gpe_number,
> +				  ACPI_GPE_TYPE_WAKE_RUN);
> +		acpi_enable_gpe(dev->wakeup.gpe_device,
> +				dev->wakeup.gpe_number, ACPI_NOT_ISR);
> +		dev->wakeup.state.enabled = 1;
> +		spin_lock(&acpi_device_lock);
>  	}
>  	spin_unlock(&acpi_device_lock);
> -
>  	return 0;
>  }
>  
>  late_initcall(acpi_wakeup_device_init);
> -
> -/*
> - * Disable all wakeup GPEs before entering requested sleep state.
> - *	@sleep_state:	ACPI state
> - * Since acpi_enter_sleep_state() will disable all
> - * RUNTIME GPEs, we simply mark all GPES that
> - * are not enabled for wakeup from requested state as RUNTIME.
> - */
> -void acpi_gpe_sleep_prepare(u32 sleep_state)
> -{
> -	struct list_head *node, *next;
> -
> -	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> -		struct acpi_device *dev = container_of(node,
> -						       struct acpi_device,
> -						       wakeup_list);
> -
> -		/* The GPE can wakeup system from this state, don't touch it */
> -		if ((u32) dev->wakeup.sleep_state >= sleep_state)
> -			continue;
> -		/* acpi_set_gpe_type will automatically disable GPE */
> -		acpi_set_gpe_type(dev->wakeup.gpe_device,
> -				  dev->wakeup.gpe_number,
> -				  ACPI_GPE_TYPE_RUNTIME);
> -	}
> -}
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 86aea44..17500a1 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -264,7 +264,6 @@ struct acpi_device_wakeup_flags {
>  
>  struct acpi_device_wakeup_state {
>  	u8 enabled:1;
> -	u8 active:1;
>  };
>  
>  struct acpi_device_wakeup {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Hi,

Well, what can I say....
Big big thanks, works perfectly.

All resume device work after suspend to disk, and I was able to WOL the system
while it is suspended to disk.


Big thanks,
	Best regards,
		Maxim Levitsky
