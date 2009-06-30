Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZF3XCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZF3XCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbZF3XCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:02:08 -0400
Received: from ru.mvista.com ([213.79.90.228]:22434 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756213AbZF3XCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:02:07 -0400
Date: Wed, 1 Jul 2009 03:02:08 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 1/5] Revert "power: remove
 POWER_SUPPLY_PROP_CAPACITY_LEVEL"
Message-ID: <20090630230208.GC12076@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021301.3652f8f4@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090630021301.3652f8f4@mycelium.queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:13:01AM -0400, Andres Salomon wrote:
> 
> This reverts commit 8efe444038a205e79b38b7ad03878824901849a8 and
> 4cbc76eadf56399cd11fb736b33c53aec9caab8c.
> 
> Richard@laptop.org was apparently using CAPACITY_LEVEL for debugging
> battery/EC problems, and was upset that it was removed.  This readds it.
> 
> Conflicts:
> 
> 	Documentation/power_supply_class.txt
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> ---

1/5 and 3/5 applied to battery-2.6.git (i.e. -next).

Thanks for your work Andres!

>  Documentation/power/power_supply_class.txt |    2 ++
>  drivers/power/olpc_battery.c               |    9 +++++++++
>  drivers/power/power_supply_sysfs.c         |    7 +++++++
>  include/linux/power_supply.h               |   10 ++++++++++
>  4 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
> index c6cd495..709d955 100644
> --- a/Documentation/power/power_supply_class.txt
> +++ b/Documentation/power/power_supply_class.txt
> @@ -108,6 +108,8 @@ relative, time-based measurements.
>  ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
>  
>  CAPACITY - capacity in percents.
> +CAPACITY_LEVEL - capacity level. This corresponds to
> +POWER_SUPPLY_CAPACITY_LEVEL_*.
>  
>  TEMP - temperature of the power supply.
>  TEMP_AMBIENT - ambient temperature.
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index 5fbca26..0d1928d 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -272,6 +272,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  			return ret;
>  		val->intval = ec_byte;
>  		break;
> +	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
> +		if (ec_byte & BAT_STAT_FULL)
> +			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
> +		else if (ec_byte & BAT_STAT_LOW)
> +			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
> +		else
> +			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
> +		break;
>  	case POWER_SUPPLY_PROP_TEMP:
>  		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
>  		if (ret)
> @@ -317,6 +325,7 @@ static enum power_supply_property olpc_bat_props[] = {
>  	POWER_SUPPLY_PROP_VOLTAGE_AVG,
>  	POWER_SUPPLY_PROP_CURRENT_AVG,
>  	POWER_SUPPLY_PROP_CAPACITY,
> +	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
>  	POWER_SUPPLY_PROP_TEMP,
>  	POWER_SUPPLY_PROP_TEMP_AMBIENT,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index da73591..d30e591 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -51,6 +51,9 @@ static ssize_t power_supply_show_property(struct device *dev,
>  		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
>  		"LiMn"
>  	};
> +	static char *capacity_level_text[] = {
> +		"Unknown", "Critical", "Low", "Normal", "High", "Full"
> +	};
>  	ssize_t ret;
>  	struct power_supply *psy = dev_get_drvdata(dev);
>  	const ptrdiff_t off = attr - power_supply_attrs;
> @@ -71,6 +74,9 @@ static ssize_t power_supply_show_property(struct device *dev,
>  		return sprintf(buf, "%s\n", health_text[value.intval]);
>  	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
>  		return sprintf(buf, "%s\n", technology_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
> +		return sprintf(buf, "%s\n",
> +			       capacity_level_text[value.intval]);
>  	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
>  		return sprintf(buf, "%s\n", value.strval);
>  
> @@ -109,6 +115,7 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(energy_now),
>  	POWER_SUPPLY_ATTR(energy_avg),
>  	POWER_SUPPLY_ATTR(capacity),
> +	POWER_SUPPLY_ATTR(capacity_level),
>  	POWER_SUPPLY_ATTR(temp),
>  	POWER_SUPPLY_ATTR(temp_ambient),
>  	POWER_SUPPLY_ATTR(time_to_empty_now),
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 594c494..0ab6aa1 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -58,6 +58,15 @@ enum {
>  	POWER_SUPPLY_TECHNOLOGY_LiMn,
>  };
>  
> +enum {
> +	POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN = 0,
> +	POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL,
> +	POWER_SUPPLY_CAPACITY_LEVEL_LOW,
> +	POWER_SUPPLY_CAPACITY_LEVEL_NORMAL,
> +	POWER_SUPPLY_CAPACITY_LEVEL_HIGH,
> +	POWER_SUPPLY_CAPACITY_LEVEL_FULL,
> +};
> +
>  enum power_supply_property {
>  	/* Properties of type `int' */
>  	POWER_SUPPLY_PROP_STATUS = 0,
> @@ -89,6 +98,7 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_ENERGY_NOW,
>  	POWER_SUPPLY_PROP_ENERGY_AVG,
>  	POWER_SUPPLY_PROP_CAPACITY, /* in percents! */
> +	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
>  	POWER_SUPPLY_PROP_TEMP,
>  	POWER_SUPPLY_PROP_TEMP_AMBIENT,
>  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
> -- 
> 1.5.6.5
> 
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
