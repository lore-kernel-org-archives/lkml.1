Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYAGDEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYAGDEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYAGDEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:04:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43911 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYAGDEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:04:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WBtSzMfoI/B3Afof3eQy5ZMsJxPuRSABUraE3G9IinyzxmUaC5j6qYXAchpnhNVysvBTpooieZeDs+l1KvjWHUE56N8Y+BYiuMahOY3FYzmyfyNRdrxIgHPdP1hIwjlmpngzUToqdhzVrteonUIn2/snW61mkVzZvm4G/idSe2Y=
Date: Mon, 7 Jan 2008 05:50:54 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 3/3] apm_power: Support using VOLTAGE_* properties for
	apm calculations
Message-ID: <20080107025054.GA6268@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080106123016.GA13324@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080106123016.GA13324@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 03:30:16PM +0300, Dmitry Baryshkov wrote:
> Support using VOLTAGE_* properties for apm calculations. It's pretty
> dummy, but useful for batteries for which we can only get voltages.

By the way...

> diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
> index bbf3ee1..526c96e 100644
> --- a/drivers/power/apm_power.c
> +++ b/drivers/power/apm_power.c
[...]
> -static int calculate_time(int status, int using_charge)
> +static int calculate_time(int status, apm_source source)
[...]
> +	case SOURCE_VOLTAGE:
> +		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
> +		full_design_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN;
> +		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
> +		empty_design_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN;
> +		cur_avg_prop = POWER_SUPPLY_PROP_VOLTAGE_AVG;
> +		cur_now_prop = POWER_SUPPLY_PROP_VOLTAGE_NOW;
> +		break;
[...]
>  		return -((cur.intval - empty.intval) * 60L) / I.intval;

This formula will return nonsense if you'll feed it with voltage:
Ohms * 60 minutes? ;-)

I'd suppose you can get better accuracy if you'll divide it by
some constant (resistance, we can define new property for it),
but I still doubt it, because this formula doesn't work good
enough even for batteries reporting charge. ;-)

It's interesting what actual values you're getting and how they
accurate.

There is another option though: if you know battery charge
full/empty thresholds (usually you know design values, they
should be written on the battery pack), then you can use this
formula to calculate "charge_now":

((voltage_now - voltage_min) * (charge_full - charge_empty)) /
(voltage_max - voltage_min)

And then you can calculate time as usual, using
charge_{now,full,empty} and current_now. But still, this is
very inaccurate, there isn't direct correlation between
charge and voltage. Oh well, power_supply_class.txt already
states about apm_power.c limitations.


So, with few cosmetic corrections I applied all your patches to
git://git.infradead.org/battery-2.6.git

I also applied few my patches I sent here earlier, hope they
don't break anything (at least they survived my tests).

Good luck,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
