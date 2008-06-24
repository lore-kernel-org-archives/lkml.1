Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYFXG1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYFXG1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYFXG1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:27:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:31123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYFXG1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:27:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,694,1204531200"; 
   d="scan'208";a="581278653"
Subject: Re: [PATCH] RTC: Fix CMOS time error after writing /proc/acpi/alarm
From: Zhao Yakui <yakui.zhao@intel.com>
To: "Chen, Huacai" <huacai.chen@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rtc-linux@googlegroups.com, lenb@kernel.org, p_gortmaker@yahoo.com,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org
In-Reply-To: <42DFA526FC41B1429CE7279EF83C6BDC014E42D5@pdsmsx415.ccr.corp.intel.com>
References: <42DFA526FC41B1429CE7279EF83C6BDC014E42D5@pdsmsx415.ccr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 14:37:53 +0800
Message-Id: <1214289473.31069.1.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 18:52 +0800, Chen, Huacai wrote:
> From: Huacai Chen <huacai.chen@intel.com>
> 
> When writing /proc/acpi/alarm in adjust mode, e.g. 
> 	echo "+0000-00-00 00:00:15" >/proc/acpi/alarm 
> The "century" field should be read and added to "year" field before
> writing, otherwise the CMOS time will go back to 2000 years ago, e.g.
> 	# cat /proc/acpi/alarm
> 	0008-06-21 11:38:46 
> Then the system time may be reset to the date of manufacture after
> rebooting. This patch fixed this issue.
> Signed-off-by: Huacai Chen <huacai.chen@intel.com>
> Acked-by: Pavel Machek <pavel@suse.cz>
> ---
> diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
> index 224c57c..c9fdf7b 100644
> --- a/drivers/acpi/sleep/proc.c
> +++ b/drivers/acpi/sleep/proc.c
> @@ -315,8 +315,11 @@ acpi_system_write_alarm(struct file *file,
>  		cmos_bcd_write(day, acpi_gbl_FADT.day_alarm,
> rtc_control);
>  	if (acpi_gbl_FADT.month_alarm)
>  		cmos_bcd_write(mo, acpi_gbl_FADT.month_alarm,
> rtc_control);
> -	if (acpi_gbl_FADT.century)
> +	if (acpi_gbl_FADT.century) {
> +		if (adjust) 
> +			yr += cmos_bcd_read(acpi_gbl_FADT.century,
> rtc_control) * 100;
>  		cmos_bcd_write(yr / 100, acpi_gbl_FADT.century,
> rtc_control);
> +	}
this is OK. 
>  	/* enable the rtc alarm interrupt */
>  	rtc_control |= RTC_AIE;
>  	CMOS_WRITE(rtc_control, RTC_CONTROL);
> ---
> This is for Linux 2.6.26-rc7.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

