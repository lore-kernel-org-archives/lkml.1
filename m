Return-Path: <linux-kernel-owner+w=401wt.eu-S1031028AbXDRDM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031028AbXDRDM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031025AbXDRDM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:12:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:36897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030851AbXDRDM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:12:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.21-rc6-git] workaround rtc-related acpi table bugs
Date: Tue, 17 Apr 2007 23:10:33 -0400
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200704121414.01828.david-b@pacbell.net>
In-Reply-To: <200704121414.01828.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704172310.33284.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 17:14, David Brownell wrote:
> This works around a bug seen in some RTC-related ACPI table entries, and
> tweaks related diagnostics to follow the ACPI convention.
> 
> The bug prevents misleading boot-time messages:  platforms affected by this
> bug wrongly report they can support alarms up to one year in the future,
> when in fact the longest alarm is just 24 hours.  That will surprise anyone
> trying to use those extended alarms.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  glue.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> --- g26.orig/drivers/acpi/glue.c	2007-04-12 10:56:35.000000000 -0700
> +++ g26/drivers/acpi/glue.c	2007-04-12 10:56:35.000000000 -0700
> @@ -316,13 +316,19 @@ static int __init acpi_rtc_init(void)
>  		rtc_info.wake_on = rtc_wake_on;
>  		rtc_info.wake_off = rtc_wake_off;

probably worth a comment right here that this clause is a BIOS workaround.
Unclear what value the DBG statement adds, since only somebody
editing this file will ever enable it.

-Len

> +		if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
> +			DBG("bogus FADT month_alarm\n");
> +			acpi_gbl_FADT.month_alarm = 0;
> +		}
> +
>  		rtc_info.rtc_day_alarm = acpi_gbl_FADT.day_alarm;
>  		rtc_info.rtc_mon_alarm = acpi_gbl_FADT.month_alarm;
>  		rtc_info.rtc_century = acpi_gbl_FADT.century;
>  
>  		/* NOTE:  S4_RTC_WAKE is NOT currently useful to Linux */
>  		if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
> -			printk("ACPI: RTC can wake from S4\n");
> +			printk(PREFIX "RTC can wake from S4\n");
> +
>  
>  		dev->platform_data = &rtc_info;
>  
> @@ -331,7 +337,7 @@ static int __init acpi_rtc_init(void)
>  
>  		put_device(dev);
>  	} else
> -		pr_debug("ACPI: RTC unavailable?\n");
> +		DBG("RTC unavailable?\n");
>  	return 0;
>  }
>  /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
