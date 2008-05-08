Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbYEHK6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbYEHK6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbYEHK63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:58:29 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:36335 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1753238AbYEHK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:58:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 06:58:27 EDT
Date: Thu, 8 May 2008 14:51:45 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, cbou@mail.ru,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: support CHARGE_NOW in OLPC battery
Message-ID: <20080508105145.GA32017@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080508003454.722ba511@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080508003454.722ba511@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 12:34:54AM -0400, Andres Salomon wrote:
> 
> This is originally based on a patch by
> David Woodhouse <dwmw2@infradead.org>.  Add support for PROP_CHARGE_NOW
> by querying the ACR (accumulated current register) from the EC.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Hi Andres,

>  drivers/power/olpc_battery.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index e3f6ec8..517dacd 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -19,7 +19,7 @@
>  
>  #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
>  #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
> -#define EC_BAT_ACR	0x12
> +#define EC_BAT_ACR	0x12	/* int16_t,	*416.667,    µAh  */

The hardware reports uAh * 416.667..?

>  #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   °C  */
>  #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   °C  */
>  #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
> @@ -289,6 +289,13 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  		ec_word = be16_to_cpu(ec_word);
>  		val->intval = ec_word * 100 / 256;
>  		break;
> +	case POWER_SUPPLY_PROP_CHARGE_NOW:
> +		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
> +		if (ret)
> +			return ret;
> +
> +		val->intval = be16_to_cpu(ec_word);

But you didn't convert it to the uAh, I think you should.

> +		break;
>  	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
>  		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
>  		if (ret)
> @@ -317,6 +324,7 @@ static enum power_supply_property olpc_bat_props[] = {
>  	POWER_SUPPLY_PROP_TEMP_AMBIENT,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
>  	POWER_SUPPLY_PROP_SERIAL_NUMBER,
> +	POWER_SUPPLY_PROP_CHARGE_NOW,
>  };
>  
>  /* EEPROM reading goes completely around the power_supply API, sadly */

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
