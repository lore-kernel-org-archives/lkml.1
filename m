Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbZGTS14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbZGTS14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZGTS1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:27:55 -0400
Received: from ru.mvista.com ([213.79.90.228]:34036 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752369AbZGTS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:27:54 -0400
Date: Mon, 20 Jul 2009 22:27:52 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Message-ID: <20090720182752.GA20602@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:44:02PM +0200, Daniel Mack wrote:
> This adds a function to let the power supply core know that the battery
> is fully charged now. This can be done by watching a GPIO line, for
> example.
> 
> Some battery drivers might need that information to calibrate
> themselves.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ian Molton <spyro@f2s.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: Matt Reimer <mreimer@vpop.net>
> ---
>  drivers/power/power_supply_core.c |   16 ++++++++++++++++
>  include/linux/power_supply.h      |    3 +++

The patch is missing pda_power.c part?

>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 5520040..7303c45 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -111,6 +111,22 @@ int power_supply_is_system_supplied(void)
>  	return error;
>  }
>  
> +static int __power_supply_set_battery_charged(struct device *dev, void *data)
> +{
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +
> +	if (psy->type == POWER_SUPPLY_TYPE_BATTERY && psy->set_charged)
> +		psy->set_charged(psy);
> +
> +	return 0;
> +}
> +
> +void power_supply_set_battery_charged(void)
> +{
> +	class_for_each_device(power_supply_class, NULL, NULL,
> +				__power_supply_set_battery_charged);
> +}
> +
>  int power_supply_register(struct device *parent, struct power_supply *psy)
>  {
>  	int rc = 0;
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 594c494..b2b39e2 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -126,6 +126,7 @@ struct power_supply {
>  			    enum power_supply_property psp,
>  			    union power_supply_propval *val);
>  	void (*external_power_changed)(struct power_supply *psy);
> +	void (*set_charged)(struct power_supply *psy);
>  
>  	/* For APM emulation, think legacy userspace. */
>  	int use_for_apm;
> @@ -170,8 +171,10 @@ extern int power_supply_am_i_supplied(struct power_supply *psy);
>  
>  #if defined(CONFIG_POWER_SUPPLY) || defined(CONFIG_POWER_SUPPLY_MODULE)
>  extern int power_supply_is_system_supplied(void);
> +extern void power_supply_set_battery_charged(void);

I don't quite like this interface. Note that system might want
to know if it's supplied (hence global is_system_supplied(void) call),
but having set_battery_charged(void) interface makes little sense
(well, it makes sense for small embedded systems that have just
one battery and one charger)...

There is a supplied_to psy field that might help you there...

The cleanup patch looks OK though, I'll apply it.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
