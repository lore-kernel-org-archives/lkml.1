Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZDWXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZDWXVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759675AbZDWXVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:21:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:61006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455AbZDWXVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,237,1239001200"; 
   d="scan'208";a="450899764"
Subject: Re: [PATCH] ACPI/hpet: prevent boot hang when hpet=force used on
 ICH-4M
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
	 <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 16:18:15 -0700
Message-Id: <1240528695.4529.9152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

On Thu, 2009-04-23 at 16:18 -0700, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> Linux tells ICH4 users that they can (manually) invoke
> "hpet=force" to enable the undocumented ICH-4M HPET.
> The HPET becomes available for both clocksource and clockevents.
> 
> But as of ff69f2bba67bd45514923aaedbf40fe351787c59
> (acpi: fix of pmtimer overflow that make Cx states time incorrect)
> the HPET may be used via clocksource for idle accounting, and
> hpet=force on an ICH4 box hangs boot.
> 
> It turns out that touching the MMIO HPET withing
> the ARB_DIS part of C3 will hang the hardware.
> 
> The fix is to simply move the timer access outside
> the ARB_DIS region.  This is a no-op on modern hardware
> because ARB_DIS is no longer used.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13087
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/processor_idle.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 6fe1214..ea23c64 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -955,6 +955,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  	 */
>  	acpi_state_timer_broadcast(pr, cx, 1);
>  
> +	kt1 = ktime_get_real();
>  	/*
>  	 * disable bus master
>  	 * bm_check implies we need ARB_DIS
> @@ -976,10 +977,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  		ACPI_FLUSH_CPU_CACHE();
>  	}
>  
> -	kt1 = ktime_get_real();
>  	acpi_idle_do_entry(cx);
> -	kt2 = ktime_get_real();
> -	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>  
>  	/* Re-enable bus master arbitration */
>  	if (pr->flags.bm_check && pr->flags.bm_control) {
> @@ -988,6 +986,8 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  		c3_cpu_count--;
>  		spin_unlock(&c3_lock);
>  	}
> +	kt2 = ktime_get_real();
> +	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>  
>  #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>  	/* TSC could halt in idle, so notify users */

