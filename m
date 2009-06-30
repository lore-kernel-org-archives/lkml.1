Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZF3W7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZF3W7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZF3W7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:59:40 -0400
Received: from ru.mvista.com ([213.79.90.228]:22423 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754041AbZF3W7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:59:40 -0400
Date: Wed, 1 Jul 2009 02:59:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 4/5] power_supply: ensure that the TRICKLE bit is
 checked in olpc_battery
Message-ID: <20090630225943.GB12076@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021617.78748e27@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090630021617.78748e27@mycelium.queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:16:17AM -0400, Andres Salomon wrote:
> 
> There are times when the battery is present but trickle charging, and the EC
> sets only the TRICKLE bit.. So we must check for the bit when we're checking
> the charging/present status.
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> ---

Applied to battery-2.6.31.git, plus some cosmetic changes were
made, so please ensure that the patches are still fine.

Thanks.

>  drivers/power/olpc_battery.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index c955a86..af17051 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -35,6 +35,7 @@
>  #define BAT_STAT_AC		0x10
>  #define BAT_STAT_CHARGING	0x20
>  #define BAT_STAT_DISCHARGING	0x40
> +#define BAT_STAT_TRICKLE	0x80
>  
>  #define BAT_ERR_INFOFAIL	0x02
>  #define BAT_ERR_OVERVOLTAGE	0x04
> @@ -89,7 +90,7 @@ static char bat_serial[17]; /* Ick */
>  static int olpc_bat_get_status(union power_supply_propval *val, uint8_t ec_byte)
>  {
>  	if (olpc_platform_info.ecver > 0x44) {
> -		if (ec_byte & BAT_STAT_CHARGING)
> +		if (ec_byte & (BAT_STAT_CHARGING|BAT_STAT_TRICKLE))
>  			val->intval = POWER_SUPPLY_STATUS_CHARGING;
>  		else if (ec_byte & BAT_STAT_DISCHARGING)
>  			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
> @@ -219,7 +220,8 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  	   It doesn't matter though -- the EC will return the last-known
>  	   information, and it's as if we just ran that _little_ bit faster
>  	   and managed to read it out before the battery went away. */
> -	if (!(ec_byte & BAT_STAT_PRESENT) && psp != POWER_SUPPLY_PROP_PRESENT)
> +	if (!(ec_byte & (BAT_STAT_PRESENT|BAT_STAT_TRICKLE)) &&
> +			psp != POWER_SUPPLY_PROP_PRESENT)
>  		return -ENODEV;
>  
>  	switch (psp) {
> @@ -229,7 +231,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  			return ret;
>  		break;
>  	case POWER_SUPPLY_PROP_PRESENT:
> -		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
> +		val->intval = !!(ec_byte & (BAT_STAT_PRESENT|BAT_STAT_TRICKLE));
>  		break;
>  
>  	case POWER_SUPPLY_PROP_HEALTH:
> -- 
> 1.5.6.5
> 
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
