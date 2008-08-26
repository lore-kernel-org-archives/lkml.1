Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYHZVKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYHZVKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYHZVKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:10:21 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:51508 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652AbYHZVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:10:20 -0400
Date: Wed, 27 Aug 2008 01:10:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power-supply: Add function to return system-wide power
	state
Message-ID: <20080826211019.GA21682@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080826200849.GA26114@srcf.ucam.org> <20080826200959.GB26114@srcf.ucam.org> <20080826202542.GA10090@oksana.dev.rtsoft.ru> <20080826203327.GA26691@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080826203327.GA26691@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:33:27PM +0100, Matthew Garrett wrote:
> Something like this?

Yup, except that I forgot 'inline' in my example. ;-) I'll add it
before applying, thanks!

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
> index ea96ead..304df22 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -164,11 +164,16 @@ struct power_supply_info {
>  
>  extern void power_supply_changed(struct power_supply *psy);
>  extern int power_supply_am_i_supplied(struct power_supply *psy);
> -
>  extern int power_supply_register(struct device *parent,
>  				 struct power_supply *psy);
>  extern void power_supply_unregister(struct power_supply *psy);
>  
> +#ifdef CONFIG_POWER_SUPPLY
> +extern int power_supply_is_system_supplied(void);
> +#else
> +static int power_supply_is_system_supplied(void) { return -ENOSYS; }
> +#endif
> +
>  /* For APM emulation, think legacy userspace. */
>  extern struct class *power_supply_class;

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
