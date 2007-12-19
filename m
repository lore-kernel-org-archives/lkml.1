Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXLSSss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXLSSss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXLSSsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:48:40 -0500
Received: from mx39.mail.ru ([194.67.23.35]:58222 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXLSSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:48:39 -0500
Date: Wed, 19 Dec 2007 21:50:50 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Andres Salomon <dilinger@queued.net>
Cc: cbouatmailru@gmail.com, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071219185050.GA1570@localhost.localdomain>
Reply-To: cbou@mail.ru
References: <20071216212443.4a1fff3d@ephemeral> <1197858984.3798.201.camel@shinybook.infradead.org> <20071217055123.GA2274@zarina> <20071217024139.2f81e36d@ephemeral> <20071217112416.GA25948@localhost.localdomain> <20071218021001.46783004@ephemeral> <20071219123546.GA6277@localhost.localdomain> <20071219130241.21f0b416@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071219130241.21f0b416@ephemeral>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 01:02:41PM -0500, Andres Salomon wrote:
[...]
> > > Hm.  It occurs to me that there's nothing keeping us from having a
> > > single callback for the driver properties.  Keeping the other patches
> > > the same, do you prefer the following approach versus what was originally
> > > in patch#3?
> > 
> > Why so difficult? Maybe like this:
> > 
> 
> The point is to get rid of 'propval', and having the core driver define
> formats.  That's one of the places where we ran into problems with the
> current API; by having the core driver define what type a property should
> be returning, we limit battery drivers to what they can display, as well

Limiting is:
- I want to do A.
- I won't let you do that.

But you don't want convert and write integer attributes directly to
sysfs.

If you do so, class will end up converting everything back from
strings to integers (as in _leds case. And another example, though
bad one, is drivers/power/apm_power.c).

> as encourage a lot of non-shared code to end up in the core driver.  That's
> the reason why we strcpy into 'buf', rather than val->strval.

When properties are pure integers why you so eager to fill sysfs by
yourself?

You don't want to pad "voltage" property with zeroes. Probably you
want free-form S/N property. Ok, it fits quite well in the purposed
scheme: fill strval.

Can you imagine an use case when this approach doesn't work?

> For transitioning, we could certainly just use val->strval all of the time,
> but there's not much point in doing that in the long term; we might as well
> just pass around 'buf'.

No, we don't need strval for every property. Most of them are integers,
and power_supply_sysfs.c doing its small job: representing internal
structure to sysfs, through strings. Strings aren't there in the
first place.

> > diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> > index c998e68..00f0b71 100644
> > --- a/drivers/power/olpc_battery.c
> > +++ b/drivers/power/olpc_battery.c
> > @@ -176,13 +176,13 @@ static int olpc_bat_get_property(struct power_supply *psy,
> >  
> >  		switch (ec_byte >> 4) {
> >  		case 1:
> > -			val->strval = "Gold Peak";
> > +			ret = sprintf(val->strval, "%s\n", "Gold Peak");
> >  			break;
> >  		case 2:
> > -			val->strval = "BYD";
> > +			ret = sprintf(val->strval, "%s\n", "BYD");
> >  			break;
> >  		default:
> > -			val->strval = "Unknown";
> > +			ret = sprintf(val->strval, "%s\n", "Unknown");
> >  			break;
> >  		}
> >  		break;
> > diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> > index 249f61b..83e127d 100644
> > --- a/drivers/power/power_supply_sysfs.c
> > +++ b/drivers/power/power_supply_sysfs.c
> > @@ -54,7 +54,9 @@ static ssize_t power_supply_show_property(struct device *dev,
> >  	ssize_t ret;
> >  	struct power_supply *psy = dev_get_drvdata(dev);
> >  	const ptrdiff_t off = attr - power_supply_attrs;
> > -	union power_supply_propval value;
> > +	union power_supply_propval value = {
> > +		.strval = buf,
> > +	};
> >  
> >  	ret = psy->get_property(psy, off, &value);
> >  
> > @@ -75,7 +77,7 @@ static ssize_t power_supply_show_property(struct device *dev,
> >  		return sprintf(buf, "%s\n",
> >  			       capacity_level_text[value.intval]);
> >  	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
> > -		return sprintf(buf, "%s\n", value.strval);
> > +		return ret;
> >  
> >  	return sprintf(buf, "%d\n", value.intval);
> >  }
> 

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
