Return-Path: <linux-kernel-owner+w=401wt.eu-S937144AbYEBW7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937144AbYEBW7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934262AbYEBW7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:59:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:41887 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412AbYEBW7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=K00X/SvauLe3CDnv8R7B1qw+t13UWKQaT7BE7JX/ajbz7qhVGe7kCuOVO70CE1dxBnPGipjV3115DCRzdYMg3xZs0P5gYeT7cTqIyOvwMa9ABJmoJzim6+Mawi/LKqXVQU2qB6CN8hJz3Llgy5xbdfOIpT8JbtZfjyrt3yBICc0=
Date: Sat, 3 May 2008 02:58:49 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] power_supply: Support serial number and ACR in
	olpc_battery
Message-ID: <20080502225849.GA26024@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080430163002.3c768ae0@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430163002.3c768ae0@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:30:02PM -0400, Andres Salomon wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> This adds serial number and accumulated current support to the OLPC
> battery driver.

How PROP_ACCUM_CURRENT is different from PROP_CHARGE_NOW (uAh)?

The DS2760 is already using the later to report its ACR register...

> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/power/olpc_battery.c       |   23 ++++++++++++++++++++++-
>  drivers/power/power_supply_sysfs.c |    1 +
>  include/linux/power_supply.h       |    1 +
>  3 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index ab1e828..9d9dd09 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -19,7 +19,7 @@
>  
>  #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
>  #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
> -#define EC_BAT_ACR	0x12
> +#define EC_BAT_ACR	0x12	/* int16_t,	*416.667,    µAh  */
>  #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   °C  */
>  #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   °C  */
>  #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
> @@ -84,6 +84,8 @@ static struct power_supply olpc_ac = {
>  	.get_property = olpc_ac_get_prop,
>  };
>  
> +static char bat_serial[17]; /* Ick */
> +
>  /*********************************************************************
>   *		Battery properties
>   *********************************************************************/
> @@ -94,6 +96,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  	int ret = 0;
>  	int16_t ec_word;
>  	uint8_t ec_byte;
> +	uint64_t ser_buf;
>  
>  	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
>  	if (ret)
> @@ -241,6 +244,22 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  		ec_word = be16_to_cpu(ec_word);
>  		val->intval = ec_word * 100 / 256;
>  		break;
> +	case POWER_SUPPLY_PROP_ACCUM_CURRENT:
> +		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
> +		if (ret)
> +			return ret;
> +
> +		ec_word = be16_to_cpu(ec_word);
> +		val->intval = ec_word;
> +		break;
> +	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
> +		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
> +		if (ret)
> +			return ret;
> +
> +		sprintf(bat_serial, "%016llx", (long long)be64_to_cpu(ser_buf));
> +		val->strval = bat_serial;
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -259,7 +278,9 @@ static enum power_supply_property olpc_bat_props[] = {
>  	POWER_SUPPLY_PROP_CAPACITY,
>  	POWER_SUPPLY_PROP_TEMP,
>  	POWER_SUPPLY_PROP_TEMP_AMBIENT,
> +	POWER_SUPPLY_PROP_ACCUM_CURRENT,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
> +	POWER_SUPPLY_PROP_SERIAL_NUMBER,
>  };
>  
>  /*********************************************************************
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index c444d6b..756d4e1 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -112,6 +112,7 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(time_to_empty_avg),
>  	POWER_SUPPLY_ATTR(time_to_full_now),
>  	POWER_SUPPLY_ATTR(time_to_full_avg),
> +	POWER_SUPPLY_ATTR(accum_current),
>  	/* Properties of type `const char *' */
>  	POWER_SUPPLY_ATTR(model_name),
>  	POWER_SUPPLY_ATTR(manufacturer),
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 68ed19c..a699ad2 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -91,6 +91,7 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
>  	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
>  	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
> +	POWER_SUPPLY_PROP_ACCUM_CURRENT,
>  	/* Properties of type `const char *' */
>  	POWER_SUPPLY_PROP_MODEL_NAME,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
> -- 
> 1.5.5
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
