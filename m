Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbXDOWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbXDOWN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXDOWN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:13:58 -0400
Received: from mx6.mail.ru ([194.67.23.26]:29839 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbXDOWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:13:57 -0400
Date: Mon, 16 Apr 2007 02:10:05 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Pavel Machek <pavel@ucw.cz>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070415221005.GA26320@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070415195655.GG10097@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070415195655.GG10097@ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pavel,

On Sun, Apr 15, 2007 at 07:56:56PM +0000, Pavel Machek wrote:
> Hi!
> 
> > * It insists on reusing its predefined attributes *and* their units.
> >   So, userspace getting expected values for any battery.
> >   
> >   Also common units is required for APM/ACPI emulation.
> >   
> >   Though our battery class insisting on re-usage, but not forces it. If some
> >   battery driver can't convert its own raw values (can't imagine why), then
> >   driver is free to implement its own attributes *and* additional _units
> >   attribute. Though, this scheme is discouraged.
> > 
> > * LEDs support. Each battery register its trigger, and gadgets with LEDs
> >   can quickly bind to battery-charging / battery-full triggers.
> > 
> > Here how it looks like from user space:
> > 
> > # ls /sys/class/battery/main-battery/
> > capacity  max_capacity  max_voltage   min_current  power   subsystem  uevent
> > current   max_current   min_capacity  min_voltage  status  temp       voltage
> > # cat /sys/class/battery/main-battery/status
> > Full
> > # cat /sys/class/leds/h5400\:green-right/trigger
> > none h5400-radio timer hwtimer main-battery-charging [main-battery-full]
> > # cat /sys/class/leds/h5400\:green-right/brightness
> > 255
> 
> Can we get few lines in Documentation?

Yes, sure.

> I guess min_capacity is
> shutdown capacity at current temperature, but its surely non-obvious.
> 
> Will min_capacity increase as batery gets old? Or will max_capacity
> decrease? 

min_capacity and max_capacity depend on temperature. But some drivers
can/want to interpolate, others can't/don't want. It's driver's matter.

ds2760_battery just remembers last capacity when current was < 10 mA
(i.e. battery charged full at given temperature) as max_capacity, and
takes this as reference for calculations.

> (Should we introduce design_capacity for ACPI systems that
> know the difference?)

Yup, I've introduced it in [take2] (it's in this thread, thus it's hard
to find). Will resend it as separate thread soon, along with few other
changes.

> What is min_current? Granularity of amper meter?
> 
> And min_voltage is shutdown voltage?

Yes, should be. But, for example, ds2760 battery can't remember this
value in its eeprom (iirc), thus this value passed by platform code,
i.e. in our case (iPaqs) it's machine dependent value. Probably we
should not even export this attribute in ds2760_battery driver, as it
does not take any part in calculations. Plus this attribute highly
depend on battery chemistry and temperature. Thus it's hardly anyhow
useful, except if hardware itself reports it (not ds2760 case).

> Otherwise it looks good to me. Something like this is really needed.

Thanks!

> > + * All voltages, currents, capacities and temperatures in mV, mA, mAh and
> > + * tenths of a degree unless otherwise stated. It's driver's job to convert
> 
> tenths of degree Celsius?

Yup, fixed in [take2].

> > +#define BATTERY_STATUS_UNKNOWN      0
> > +#define BATTERY_STATUS_CHARGING     1
> > +#define BATTERY_STATUS_DISCHARGING  2
> > +#define BATTERY_STATUS_NOT_CHARGING 3
> > +#define BATTERY_STATUS_FULL         4
> 
> Perhaps we need STATUS_ERROR? At least on some machines it is
> different from STATUS_NOT_CHARGING.

I'm unsure about this. BATTERY_STATUS_* is mostly about charging process
status (should I rename it to more verbose BATTERY_CHARGING_STATUS_, or just
mention it in Documentation?).

For errors things it might be better to create "health" attribute.

> > +	/* private */
> > +	struct power_supplicant pst;
> > +
> > +	#ifdef CONFIG_LEDS_TRIGGERS
> > +	struct led_trigger *charging_trig;
> > +	char *charging_trig_name;
> > +	struct led_trigger *full_trig;
> > +	char *full_trig_name;
> > +	#endif
> > +};
> 
> #ifdefs need to be at column 0?

Yup, fixed in [take2].

> > +/* 
> > + * This is recommended structure to specify static battery parameters.
> > + * Generic one, parametrizable for different batteries. Battery device
> > + * itself does bot use it, but that's what implementing most drivers,
> 
> 'does not'?

Thanks, will fix!

> 							Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
