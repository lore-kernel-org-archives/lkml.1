Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYHZUZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYHZUZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYHZUZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:25:44 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:51403 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751149AbYHZUZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:25:44 -0400
Date: Wed, 27 Aug 2008 00:25:42 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power-supply: Add function to return system-wide power
	state
Message-ID: <20080826202542.GA10090@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080826200849.GA26114@srcf.ucam.org> <20080826200959.GB26114@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080826200959.GB26114@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:09:59PM +0100, Matthew Garrett wrote:
> (resend, I screwed up the Cc)
> 
> Certain drivers benefit from knowing whether the system is on ac or 
> battery, for instance when determining which backlight registers to 
> read. This adds a simple call to determine whether there's an online 
> power supply other than any batteries.

I like the patch, much thanks!

One comment below.

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> The name is a bit odd, but seems to fit in with the existing naming 
> scheme.
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index cb1ccb4..6a687da 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -87,6 +87,31 @@ int power_supply_am_i_supplied(struct power_supply *psy)
>  	return error;
>  }
>  
> +static int __power_supply_is_system_supplied(struct device *dev, void *data)
> +{
> +	union power_supply_propval ret = {0,};
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +
> +	if (psy->type != POWER_SUPPLY_TYPE_BATTERY) {
> +		if (psy->get_property(psy,
> +				       POWER_SUPPLY_PROP_ONLINE, &ret))
> +			return 0;
> +		if (ret.intval)
> +			return ret.intval;
> +	}
> +	return 0;
> +}
> +
> +int power_supply_is_system_supplied()
> +{
> +	int error;
> +
> +	error = class_for_each_device(power_supply_class, NULL, NULL,
> +				      __power_supply_is_system_supplied);
> +
> +	return error;
> +}
> +
>  int power_supply_register(struct device *parent, struct power_supply *psy)
>  {
>  	int rc = 0;
> @@ -148,6 +173,7 @@ static void __exit power_supply_class_exit(void)
>  
>  EXPORT_SYMBOL_GPL(power_supply_changed);
>  EXPORT_SYMBOL_GPL(power_supply_am_i_supplied);
> +EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
>  EXPORT_SYMBOL_GPL(power_supply_register);
>  EXPORT_SYMBOL_GPL(power_supply_unregister);
>  
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index ea96ead..3e67d0c 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -164,6 +164,7 @@ struct power_supply_info {
>  
>  extern void power_supply_changed(struct power_supply *psy);
>  extern int power_supply_am_i_supplied(struct power_supply *psy);
> +extern int power_supply_is_system_supplied(void);

May I suggest adding
static int power_supply_is_system_supplied(void) { return -ENOSYS; }
in case of !CONFIG_POWER_SUPPLY? This way drivers may not strictly
depend on power supply class.

And "if (power_supply_is_system_supplied())" will assume that we're
always supplied, which good assumption, I think.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
