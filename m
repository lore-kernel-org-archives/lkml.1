Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbZFXO0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbZFXO0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZFXO0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:26:42 -0400
Received: from ru.mvista.com ([213.79.90.228]:5418 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240AbZFXO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:26:41 -0400
Date: Wed, 24 Jun 2009 18:25:38 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 2/5] power_supply: add an ERROR property that displays
	raw errors and use for OLPC
Message-ID: <20090624142538.GB9035@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090622234559.6ca17ab8@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090622234559.6ca17ab8@mycelium.queued.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Mon, Jun 22, 2009 at 11:45:59PM -0400, Andres Salomon wrote:
> Grab the error code from EC_BAT_ERRCODE and let the user see it (rather
> than attempting to decode it as we do with PROP_HEALTH).

I don't think that raw errcode is a good idea. Nobody will able to
interpret the 'raw' err value without a special knowledge about
this particular battery. So it feels like the olpc_battery driver
better register its own sysfs attribute.

Or, you can interpret it in the driver and express it to outside
via some known values (ERROR_FOO, ERROR_BAR).

Thanks,

> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> ---
>  drivers/power/olpc_battery.c       |    8 ++++++++
>  drivers/power/power_supply_sysfs.c |    1 +
>  include/linux/power_supply.h       |    1 +
>  3 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index 8f41733..f8d2d6b 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -242,6 +242,13 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  		}
>  		break;
>  
> +	case POWER_SUPPLY_PROP_ERROR:
> +		ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
> +		if (ret)
> +			return ret;
> +		val->intval = ec_byte;
> +		break;
> +
>  	case POWER_SUPPLY_PROP_MANUFACTURER:
>  		ret = olpc_bat_get_mfr(val);
>  		if (ret)
> @@ -319,6 +326,7 @@ static enum power_supply_property olpc_bat_props[] = {
>  	POWER_SUPPLY_PROP_CAPACITY,
>  	POWER_SUPPLY_PROP_TEMP,
>  	POWER_SUPPLY_PROP_TEMP_AMBIENT,
> +	POWER_SUPPLY_PROP_ERROR,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
>  	POWER_SUPPLY_PROP_SERIAL_NUMBER,
>  	POWER_SUPPLY_PROP_CHARGE_COUNTER,
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index da73591..add5f39 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -115,6 +115,7 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(time_to_empty_avg),
>  	POWER_SUPPLY_ATTR(time_to_full_now),
>  	POWER_SUPPLY_ATTR(time_to_full_avg),
> +	POWER_SUPPLY_ATTR(error),
>  	/* Properties of type `const char *' */
>  	POWER_SUPPLY_ATTR(model_name),
>  	POWER_SUPPLY_ATTR(manufacturer),
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 594c494..1e45cbc 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -95,6 +95,7 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
>  	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
>  	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
> +	POWER_SUPPLY_PROP_ERROR,
>  	/* Properties of type `const char *' */
>  	POWER_SUPPLY_PROP_MODEL_NAME,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
> -- 
> 1.5.6.5
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
