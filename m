Return-Path: <linux-kernel-owner+w=401wt.eu-S933361AbYD3VuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbYD3VuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763882AbYD3VtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:49:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762696AbYD3VtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:49:14 -0400
Date: Wed, 30 Apr 2008 14:48:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] power_supply: Support serial number and ACR in
 olpc_battery
Message-Id: <20080430144836.3ac3b808.akpm@linux-foundation.org>
In-Reply-To: <20080430163002.3c768ae0@ephemeral>
References: <20080430163002.3c768ae0@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:30:02 -0400
Andres Salomon <dilinger@queued.net> wrote:

> From: David Woodhouse <dwmw2@infradead.org>
> 
> This adds serial number and accumulated current support to the OLPC
> battery driver.
> 
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
> +#define EC_BAT_ACR	0x12	/* int16_t,	*416.667,    __Ah  */
>  #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   __C  */
>  #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   __C  */
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

It would be cleaner to give ec_word the __be16 type and do

	val->intval = be16_to_cpu(ec_word);

However I suspect that if that conversion were done fully, things would get
rather involved.

It's a shame that we didn't design the endianness suypport in a way which
the compiler could enforce - gcc's handling of small structs is (or was)
suboptimal.  sparse should do it for us, but few run it, I expect.

