Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbXJ0Sov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbXJ0Sov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ0Som
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:44:42 -0400
Received: from mx27.mail.ru ([194.67.23.23]:13852 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXJ0Sol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:44:41 -0400
X-Greylist: delayed 14720 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2007 14:44:41 EDT
Date: Sat, 27 Oct 2007 22:42:49 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if
	battery is absent
Message-ID: <20071027184249.GA2982@zarina>
Reply-To: cbou@mail.ru
References: <200710272054.31160.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200710272054.31160.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 08:54:30PM +0400, Andrey Borzenkov wrote:
> I am not exactly sure about this one ... what other power_supply class drivers 
> do? Should I fix HAL instead (but then, I do not know whether HAL is the only 
> application that is using this interface).

Well, PROP_PRESENT wasn't my idea, currently it's used by pmu and
olpc drivers becuase it's not trivial to register/unregister their
batteries on physical insertion/removal. I have some plans to teach
at least pmu batteries to not use PROP_PRESENT. I don't have any
OLPC, thus I can't convert it.

To sum this: the good way to handle "missing" batteries is to
unregister them, so they'll not show up in the /sys/class/power_supply.
Is that possible with the ACPI?

The good example is ds2760 batteries:

drivers/power/ds2760_battery.c - is platform device
drivers/w1/slaves/w1_ds2760.c - is w1 slave, which
registers/unregisters pdevs on the detection/removal.

> Subject: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if battery is absent

Bad idea. Don't use present attribute, if possible.

> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Ensure that we always have "present" attribute in sysfs. This is compatible
> with procfs case where we had "present: no" if battery was not available.
> 
> This fixes HAL battery detection where it does pretend battery is present
> but canot provide any value for it.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> ---
> 
>  drivers/acpi/battery.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 681e26b..6e67fcd 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -187,6 +187,10 @@ static int acpi_battery_get_property(struct power_supply *psy,
>  	return 0;
>  }
>  
> +static enum power_supply_property missing_battery_props[] = {
> +	POWER_SUPPLY_PROP_PRESENT,
> +};
> +
>  static enum power_supply_property charge_battery_props[] = {
>  	POWER_SUPPLY_PROP_STATUS,
>  	POWER_SUPPLY_PROP_PRESENT,
> @@ -389,8 +393,13 @@ static int acpi_battery_update(struct acpi_battery *battery)
>  {
>  	int saved_present = acpi_battery_present(battery);
>  	int result = acpi_battery_get_status(battery);
> -	if (result || !acpi_battery_present(battery))
> +	if (result)
>  		return result;
> +	if (!acpi_battery_present(battery)) {
> +		battery->bat.properties = missing_battery_props;
> +		battery->bat.num_properties = ARRAY_SIZE(missing_battery_props);
> +		return result;
> +	}
>  	if (saved_present != acpi_battery_present(battery) ||
>  	    !battery->update_time) {
>  		battery->update_time = 0;

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
