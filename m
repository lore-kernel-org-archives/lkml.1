Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYERVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYERVrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYERVrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:47:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:58683 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYERVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=VTZUxgdOacF5FD+vPTVP6eQGr725hL1Bn/NwBEu6CS3UZWAXK8kUSCbmWH8sXUi6/Sj2BJqsYmZ/+8kIIHi12/aZHgrCko3lNgwMTadeNXg/8JI3rMN23jkH2lcHX+d6qGUR7u3+Yb/vKKV2VTJbpdSVRoUuYO3EBWn7MbR06Xc=
Date: Mon, 19 May 2008 01:46:56 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: richard@laptop.org, avorontsov@ru.mvista.com,
       Andrew Morton <akpm@linux-foundation.org>, cbou@mail.ru,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: add CHARGE_COUNTER property and
	olpc_battery support for it
Message-ID: <20080518214656.GA16808@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080508003454.722ba511@ephemeral> <20080508105145.GA32017@polina.dev.rtsoft.ru> <20080508130102.3218f1e9@ephemeral> <20080508171320.GA8226@polina.dev.rtsoft.ru> <48234C25.4040807@laptop.org> <20080508193614.GA31188@polina.dev.rtsoft.ru> <4823663B.6060409@laptop.org> <20080512214629.443a5999@ephemeral> <4829A39F.7050308@laptop.org> <20080513122330.4c81e289@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080513122330.4c81e289@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 12:23:30PM -0400, Andres Salomon wrote:
> On Tue, 13 May 2008 10:20:15 -0400
> "Richard A. Smith" <richard@laptop.org> wrote:
> 
> > Andres Salomon wrote:
> > 
> > > +		ec_word = be16_to_cpu(ec_word);
> > > +		val->intval = ec_word * 4167 / 10;
> > 
> > Whats wrong with:
> > 
> >  > +		val->intval = ((int)ec_word) * 6250 / 15;
> > 
> > Which does not have overflow problems and keeps more precision.
> > 
> 
> You're right, of course.  Anton, can you please apply the following?

Sorry for the delay... Applied, thanks!

> Subject: [PATCH] power_supply: fix up CHARGE_COUNTER output to be more precise
> 
> As Richard Smith pointed out, ACR * 6250 / 15  provides for less precision
> loss than ACR * 4167 / 10, _and_ it doesn't overflow.  Switch to using
> that equation for CHARGE_COUNTER.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/power/olpc_battery.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index a928165..f5d712a 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -19,7 +19,7 @@
>  
>  #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
>  #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
> -#define EC_BAT_ACR	0x12	/* int16_t,	*416.7,      µAh  */
> +#define EC_BAT_ACR	0x12	/* int16_t,	*6250/15,    µAh  */
>  #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   °C  */
>  #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   °C  */
>  #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
> @@ -295,7 +295,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
>  			return ret;
>  
>  		ec_word = be16_to_cpu(ec_word);
> -		val->intval = ec_word * 4167 / 10;
> +		val->intval = ec_word * 6250 / 15;
>  		break;
>  	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
>  		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
> -- 
> 1.5.5.1

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
