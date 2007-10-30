Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbXJ3KcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbXJ3KcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXJ3Kb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:31:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50941 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXJ3Kb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:31:58 -0400
Message-ID: <4727081B.7020508@garzik.org>
Date: Tue, 30 Oct 2007 06:31:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
CC: akpm@linux-foundation.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [PATCH 3/12] ACPI sbs: fix retval warning
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223636.D6D6B1F81A2@havoc.gtf.org>
In-Reply-To: <20071023223636.D6D6B1F81A2@havoc.gtf.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> drivers/acpi/sbs.c: In function ‘acpi_battery_add’:
> drivers/acpi/sbs.c:811: warning: ignoring return value of ‘device_create_file’, declared with attribute warn_unused_result
> 
> Additional cleanups:
> * use struct acpi_battery in acpi_battery_remove() to clean up function
> calls, just like acpi_battery_add() already does.
> 
> * un-indent unregister call, as it mistakenly gives the impression that
> it belongs inside the 'if' test
> 
> * remove unneeded braces
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> 
> diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
> index 90fd09c..c5c011b 100644
> --- a/drivers/acpi/sbs.c
> +++ b/drivers/acpi/sbs.c
> @@ -113,6 +113,7 @@ struct acpi_battery {
>  	u16 spec;
>  	u8 id;
>  	u8 present:1;
> +	u8 have_sysfs:1;
>  };
>  
>  #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
> @@ -808,7 +809,8 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
>  	}
>  	battery->bat.get_property = acpi_sbs_battery_get_property;
>  	result = power_supply_register(&sbs->device->dev, &battery->bat);
> -	device_create_file(battery->bat.dev, &alarm_attr);
> +	if (device_create_file(battery->bat.dev, &alarm_attr) == 0)
> +		battery->have_sysfs = 1;
>  	printk(KERN_INFO PREFIX "%s [%s]: Battery Slot [%s] (battery %s)\n",
>  	       ACPI_SBS_DEVICE_NAME, acpi_device_bid(sbs->device),
>  	       battery->name, sbs->battery->present ? "present" : "absent");
> @@ -817,14 +819,16 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
>  
>  static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
>  {
> -	if (sbs->battery[id].bat.dev)
> -		device_remove_file(sbs->battery[id].bat.dev, &alarm_attr);
> -		power_supply_unregister(&sbs->battery[id].bat);
> +	struct acpi_battery *battery = &sbs->battery[id];
> +
> +	if (battery->have_sysfs)
> +		device_remove_file(battery->bat.dev, &alarm_attr);
> +
> +	power_supply_unregister(&battery->bat);
> +
>  #ifdef CONFIG_ACPI_PROCFS
> -	if (sbs->battery[id].proc_entry) {
> -		acpi_sbs_remove_fs(&(sbs->battery[id].proc_entry),
> -				   acpi_battery_dir);
> -	}
> +	if (sbs->battery[id].proc_entry)
> +		acpi_sbs_remove_fs(&battery->proc_entry, acpi_battery_dir);

Len, this seems to have been missed in the recent ACPI push.

Can you queue this, or a similar fix, for the recently-added compiler 
warning (at the top of this email)?

	Jeff


