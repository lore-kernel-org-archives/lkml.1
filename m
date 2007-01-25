Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbXAYEIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbXAYEIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXAYEIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:08:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:56040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbXAYEIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:08:37 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.20-rc3 3/3] export ACPI info to rtc_cmos platform data
Date: Wed, 24 Jan 2007 23:07:10 -0500
User-Agent: KMail/1.9.5
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com, "Brown, Len" <len.brown@intel.com>
References: <200701051003.43808.david-b@pacbell.net>
In-Reply-To: <200701051003.43808.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701242307.10791.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eventually we may bundle ACPI/PNP/PNPACPI, so the #else !CONFIG_PNPACPI part
here can go away.

Acked-by: Len Brown <len.brown@intel.com>

On Friday 05 January 2007 13:03, David Brownell wrote:
> Update ACPI to export its RTC extension information through platform_data
> to the PNPACPI or platform bus device node used on the system being set up.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> ====
>  drivers/acpi/glue.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+)
> 
> This will probably need to be updated later to provide a firmware hook
> to handle system suspend with an alarm pending, with ACPI_EVENT_RTC.
> The same hook could eventually need to handle EFI.
> 
> Index: g26/drivers/acpi/glue.c
> ===================================================================
> --- g26.orig/drivers/acpi/glue.c	2007-01-02 20:05:31.000000000 -0800
> +++ g26/drivers/acpi/glue.c	2007-01-02 23:35:44.000000000 -0800
> @@ -364,3 +364,92 @@ static int __init init_acpi_device_notif
>  }
>  
>  arch_initcall(init_acpi_device_notify);
> +
> +
> +#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
> +
> +/* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
> + * its device node and pass extra config data.  This helps its driver use
> + * capabilities that the now-obsolete mc146818 didn't have, and informs it
> + * that this board's RTC is wakeup-capable (per ACPI spec).
> + */
> +#include <linux/mc146818rtc.h>
> +
> +static struct cmos_rtc_board_info rtc_info;
> +
> +
> +#ifdef CONFIG_PNPACPI
> +
> +/* PNP devices are registered in a subsys_initcall();
> + * ACPI specifies the PNP IDs to use.
> + */
> +#include <linux/pnp.h>
> +
> +static int __init pnp_match(struct device *dev, void *data)
> +{
> +	static const char *ids[] = { "PNP0b00", "PNP0b01", "PNP0b02", };
> +	struct pnp_dev *pnp = to_pnp_dev(dev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ids); i++) {
> +		if (compare_pnp_id(pnp->id, ids[i]) != 0)
> +			return 1;
> +	}
> +	return 0;
> +}
> +
> +static struct device *__init get_rtc_dev(void)
> +{
> +	return bus_find_device(&pnp_bus_type, NULL, NULL, pnp_match);
> +}
> +
> +#else
> +
> +/* We expect non-PNPACPI platforms to register an RTC device, usually
> + * at or near arch_initcall().  That also helps for example PCs that
> + * aren't configured with ACPI (where this code wouldn't run, but the
> + * RTC would still be available).  The device name matches the driver;
> + * that's how the platform bus works.
> + */
> +#include <linux/platform_device.h>
> +
> +static int __init platform_match(struct device *dev, void *data)
> +{
> +	struct platform_device	*pdev;
> +
> +	pdev = container_of(dev, struct platform_device, dev);
> +	return strcmp(pdev->name, "rtc_cmos") == 0;
> +}
> +
> +static struct device *__init get_rtc_dev(void)
> +{
> +	return bus_find_device(&platform_bus_type, NULL, NULL, platform_match);
> +}
> +
> +#endif
> +
> +static int __init acpi_rtc_init(void)
> +{
> +	struct device *dev = get_rtc_dev();
> +
> +	if (dev) {
> +		rtc_info.rtc_day_alarm = acpi_gbl_FADT->day_alrm;
> +		rtc_info.rtc_mon_alarm = acpi_gbl_FADT->mon_alrm;
> +		rtc_info.rtc_century = acpi_gbl_FADT->century;
> +
> +		/* NOTE:  acpi_gbl_FADT->rtcs4 is currently useful */
> +
> +		dev->platform_data = &rtc_info;
> +
> +		/* RTC always wakes from S1/S2/S3, and often S4/STD */
> +		device_init_wakeup(dev, 1);
> +
> +		put_device(dev);
> +	} else
> +		pr_debug("ACPI: RTC unavailable?\n");
> +	return 0;
> +}
> +/* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
> +fs_initcall(acpi_rtc_init);
> +
> +#endif
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
