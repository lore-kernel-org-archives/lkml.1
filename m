Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbXEGGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbXEGGp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXEGGp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:45:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbXEGGpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:45:24 -0400
Date: Sun, 6 May 2007 23:43:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 2/3] ACPI: Keep TSC stable, when lapic_timer_c2_ok is
 set
Message-Id: <20070506234356.da324185.akpm@linux-foundation.org>
In-Reply-To: <20070430102851.987296000@linutronix.de>
References: <20070430102837.748238000@linutronix.de>
	<20070430102851.987296000@linutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 10:43:33 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> The local apic timer stop in C2 resp. C3 states is coupled with the
> stop of the TSC. When the local apic timer is marked stable in C2
> on the kernel commandline, then keep the TSC marked stable in C2 as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  drivers/acpi/processor_idle.c |   19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_idle.c
> +++ linux-2.6/drivers/acpi/processor_idle.c
> @@ -305,18 +305,23 @@ static void acpi_state_timer_broadcast(s
>  				       struct acpi_processor_cx *cx,
>  				       int broadcast)
>  {
> -#ifdef CONFIG_GENERIC_CLOCKEVENTS
> -
>  	int state = cx - pr->power.states;
>  
>  	if (state >= pr->power.timer_broadcast_on_state) {
> +
> +#ifdef CONFIG_GENERIC_CLOCKEVENTS
>  		unsigned long reason;
>  
>  		reason = broadcast ?  CLOCK_EVT_NOTIFY_BROADCAST_ENTER :
>  			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
>  		clockevents_notify(reason, &pr->id);
> -	}
>  #endif
> +
> +#ifdef CONFIG_GENERIC_TIME
> +		/* TSC halts in C2/3, so notify users */
> +		mark_tsc_unstable();
> +#endif
> +	}
>  }
>  
>  #else
> @@ -481,10 +486,6 @@ static void acpi_processor_idle(void)
>  		/* Get end time (ticks) */
>  		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>  
> -#ifdef CONFIG_GENERIC_TIME
> -		/* TSC halts in C2, so notify users */
> -		mark_tsc_unstable();
> -#endif
>  		/* Re-enable interrupts */
>  		local_irq_enable();
>  		current_thread_info()->status |= TS_POLLING;
> @@ -523,10 +524,6 @@ static void acpi_processor_idle(void)
>  			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
>  		}
>  
> -#ifdef CONFIG_GENERIC_TIME
> -		/* TSC halts in C3, so notify users */
> -		mark_tsc_unstable();
> -#endif
>  		/* Re-enable interrupts */
>  		local_irq_enable();
>  		current_thread_info()->status |= TS_POLLING;
> 
> -- 

I'm now up to the third or fourth time where I need to try to repair this
patch against churn in Len's tree.  I'm not sure what I'm doing and that
changelog is of little help to me.

I think I'll drop it.  Please work it with Len.

