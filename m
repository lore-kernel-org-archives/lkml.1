Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbXECXCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbXECXCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXECXCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:02:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:47288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbXECXCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:02:33 -0400
Date: Thu, 3 May 2007 15:53:46 -0700
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/8] Universal power supply class (was: battery class)
Message-ID: <20070503225346.GA12892@suse.de>
References: <20070503213139.GC20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213139.GC20067@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 01:31:39AM +0400, Anton Vorontsov wrote:
> This class is result of "external power" and "battery" classes merge,
> as suggested by David Woodhouse. He also implemented uevent support.
> 
> Here how userspace seeing it now:
> 
>     	# ls /sys/class/power\ supply/
>     	ac  main-battery  usb

Please don't put a space in a class name.  Yes, we can do it, but some
scripts will bomb.  If you look all of the other classes use a '_'
instead.

>     	# cat /sys/class/power\ supply/
>     	ac/           main-battery/ usb/

Um, shouldn't that be an error?  Isn't /sys/class/power\ supply/ a
directory?

>     	# cat /sys/class/power\ supply/ac/type
>     	AC
> 
>     	# cat /sys/class/power\ supply/usb/type
>     	USB
> 
>     	# cat /sys/class/power\ supply/main-battery/type
>     	Battery
> 
>     	# cat /sys/class/power\ supply/ac/online
>     	1
> 
>     	# cat /sys/class/power\ supply/usb/online
>     	0

I don't really understand, is the 'usb' and 'ac' directories really a
'struct device' here?  Shouldn't there be some symlinks around here?

Can you do a 'tree /sys/class/power\ supply/' and show me the output?


> 
>     	# cat /sys/class/power\ supply/main-battery/status
>     	Charging
> 
>     	# cat /sys/class/leds/h5400\:red-left/trigger
>     	none h5400-radio timer hwtimer ac-online usb-online
>     	main-battery-charging-or-full [main-battery-charging]
>     	main-battery-full

Huh?  What does the led have to do with the battery?


> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> ---
>  Documentation/power_supply_class.txt |  167 ++++++++++++++++++++++
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    1 +
>  drivers/power/Kconfig                |   17 +++
>  drivers/power/Makefile               |   15 ++
>  drivers/power/power_supply.h         |   42 ++++++
>  drivers/power/power_supply_core.c    |  168 ++++++++++++++++++++++
>  drivers/power/power_supply_leds.c    |  176 +++++++++++++++++++++++
>  drivers/power/power_supply_sysfs.c   |  254 ++++++++++++++++++++++++++++++++++
>  include/linux/power_supply.h         |  169 ++++++++++++++++++++++
>  10 files changed, 1011 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/power_supply_class.txt
>  create mode 100644 drivers/power/Kconfig
>  create mode 100644 drivers/power/Makefile
>  create mode 100644 drivers/power/power_supply.h
>  create mode 100644 drivers/power/power_supply_core.c
>  create mode 100644 drivers/power/power_supply_leds.c
>  create mode 100644 drivers/power/power_supply_sysfs.c
>  create mode 100644 include/linux/power_supply.h
> 
> diff --git a/Documentation/power_supply_class.txt b/Documentation/power_supply_class.txt
> new file mode 100644
> index 0000000..666941f
> --- /dev/null
> +++ b/Documentation/power_supply_class.txt
> @@ -0,0 +1,167 @@
> +Linux power supply class
> +========================
> +
> +Synopsis
> +~~~~~~~~
> +Power supply class used to represent battery, UPS, AC or DC power supply
> +properties to user-space.
> +
> +It defines core set of attributes, which should be applicable to (almost)
> +every power supply out there. Attributes are available via sysfs and uevent
> +interfaces.
> +
> +Each attribute has well defined meaning, up to unit of measure used. While
> +the attributes provided are believed to be universally applicable to any
> +power supply, specific monitoring hardware may not be able to provide them
> +all, so any of them may be skipped.
> +
> +Power supply class is extensible, and allows to define drivers own attributes.
> +The core attribute set is subject to the standard Linux evolution (i.e.
> +if it will be found that some attribute is applicable to many power supply
> +types or their drivers, it can be added to the core set).
> +
> +It also integrates with LED framework, for the purpose of providing
> +typically expected feedback of battery charging/fully charged status and
> +AC/USB power supply online status. (Note that specific details of the
> +indication (including whether to use it at all) are fully controllable by
> +user and/or specific machine defaults, per design principles of LED
> +framework).
> +
> +
> +Attributes/properties
> +~~~~~~~~~~~~~~~~~~~~~
> +Power supply class has predefined set of attributes, this eliminates code
> +duplication across drivers. Power supply class insist on reusing its
> +predefined attributes *and* their units.
> +
> +So, userspace gets predictable set of attributes and their units for any
> +kind of power supply, and can process/present them to a user in consistent
> +manner. Results for different power supplies and machines are also directly
> +comparable.
> +
> +See drivers/power/ds2760_battery.c and drivers/power/pda_power.c for the
> +example how to declare and handle attributes.
> +
> +
> +Units
> +~~~~~
> +Quoting include/linux/power_supply.h:
> +
> +  All voltages, currents, charges, energies, time and temperatures in uV,
> +  uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
> +  stated. It's driver's job to convert its raw values to units in which
> +  this class operates.
> +
> +
> +Attributes/properties detailed
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +~ ~ ~ ~ ~ ~ ~  Charge/Energy/Capacity - how to not confuse  ~ ~ ~ ~ ~ ~ ~
> +~                                                                       ~
> +~ Because both "charge" (uAh) and "energy" (uWh) represents "capacity"  ~
> +~ of battery, this class distinguish these terms. Don't mix them!       ~
> +~                                                                       ~
> +~ CHARGE_* attributes represents capacity in uAh only.                  ~
> +~ ENERGY_* attributes represents capacity in uWh only.                  ~
> +~ CAPACITY attribute represents capacity in *percents*, from 0 to 100.  ~
> +~                                                                       ~
> +~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
> +
> +Postfixes:
> +_AVG - *hardware* averaged value, use it if your hardware is really able to
> +report averaged values.
> +_NOW - momentary/instantaneous values.
> +
> +STATUS - this attribute represents operating status (charging, full,
> +discharging (i.e. powering a load), etc.). This corresponds to
> +BATTERY_STATUS_* values, as defined in battery.h.
> +
> +HEALTH - represents health of the battery, values corresponds to
> +POWER_SUPPLY_HEALTH_*, defined in battery.h.
> +
> +VOLTAGE_MAX_DESIGN, VOLTAGE_MIN_DESIGN - design values for maximal and
> +minimal power supply voltages. Maximal/minimal means values of voltages
> +when battery considered "full"/"empty" at normal conditions. Yes, there is
> +no direct relation between voltage and battery capacity, but some dumb
> +batteries use voltage for very approximated calculation of capacity.
> +Battery driver also can use this attribute just to inform userspace
> +about maximal and minimal voltage thresholds of a given battery.
> +
> +CHARGE_FULL_DESIGN, CHARGE_EMPTY_DESIGN - design charge values, when
> +battery considered full/empty.
> +
> +ENERGY_FULL_DESIGN, ENERGY_EMPTY_DESIGN - same as above but for energy.
> +
> +CHARGE_FULL, CHARGE_EMPTY - These attributes means "last remembered value
> +of charge when battery became full/empty". It also could mean "value of
> +charge when battery considered full/empty at given conditions (temperature,
> +age)". I.e. these attributes represents real thresholds, not design values.
> +
> +ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
> +
> +CAPACITY - capacity in percents.
> +CAPACITY_LEVEL - capacity level. This corresponds to
> +POWER_SUPPLY_CAPACITY_LEVEL_*.
> +
> +TEMP - temperature of the power supply.
> +TEMP_AMBIENT - ambient temperature.
> +
> +TIME_TO_EMPTY - seconds left for battery to be considered empty (i.e.
> +while battery powers a load)
> +TIME_TO_FULL - seconds left for battery to be considered full (i.e.
> +while battery is charging)
> +
> +
> +Battery <-> external power supply interaction
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +Often power supplies are acting as supplies and supplicants at the same
> +time. Batteries are good example. So, batteries usually care if they're
> +externally powered or not.
> +
> +For that case, power supply class implements notification mechanism for
> +batteries.
> +
> +External power supply (AC) lists supplicants (batteries) names in
> +"supplied_to" struct member, and each power_supply_changed() call
> +issued by external power supply will notify supplicants via
> +external_power_changed callback.
> +
> +
> +QA
> +~~
> +Q: Where is POWER_SUPPLY_PROP_XYZ attribute?
> +A: If you cannot find attribute suitable for your driver needs, feel free
> +   to add it and send patch along with your driver.
> +
> +   The attributes available currently are the ones currently provided by the
> +   drivers written.
> +
> +   Good candidates to add in future: model/part#, cycle_time, manufacturer,
> +   etc.
> +
> +
> +Q: I have some very specific attribute (e.g. battery color), should I add
> +   this attribute to standard ones?
> +A: Most likely, no. Such attribute can be placed in the driver itself, if
> +   it is useful. Of course, if the attribute in question applicable to
> +   large set of batteries, provided by many drivers, and/or comes from
> +   some general battery specification/standard, it may be a candidate to
> +   be added to the core attribute set.
> +
> +
> +Q: Suppose, my battery monitoring chip/firmware does not provides capacity
> +   in percents, but provides charge_{now,full,empty}. Should I calculate
> +   percentage capacity manually, inside the driver, and register CAPACITY
> +   attribute? The same question about time_to_empty/time_to_full.
> +A: Most likely, no. This class is designed to export properties which are
> +   directly measurable by the specific hardware available.
> +
> +   Inferring not available properties using some heuristics or mathematical
> +   model is not subject of work for a battery driver. Such functionality
> +   should be factored out, and in fact, apm_power, the driver to serve
> +   legacy APM API on top of power supply class, uses a simple heuristic of
> +   approximating remaining battery capacity based on its charge, current,
> +   voltage and so on. But full-fledged battery model is likely not subject
> +   for kernel at all, as it would require floating point calculation to deal
> +   with things like differential equations and Kalman filters. This is
> +   better be handled by batteryd/libbattery, yet to be written.
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 050323f..c546de3 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -54,6 +54,8 @@ source "drivers/spi/Kconfig"
>  
>  source "drivers/w1/Kconfig"
>  
> +source "drivers/power/Kconfig"
> +
>  source "drivers/hwmon/Kconfig"
>  
>  source "drivers/mfd/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 3a718f5..5f41408 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -60,6 +60,7 @@ obj-$(CONFIG_I2O)		+= message/
>  obj-$(CONFIG_RTC_LIB)		+= rtc/
>  obj-$(CONFIG_I2C)		+= i2c/
>  obj-$(CONFIG_W1)		+= w1/
> +obj-$(CONFIG_POWER_SUPPLY)	+= power/
>  obj-$(CONFIG_HWMON)		+= hwmon/
>  obj-$(CONFIG_PHONE)		+= telephony/
>  obj-$(CONFIG_MD)		+= md/
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> new file mode 100644
> index 0000000..7811fa6
> --- /dev/null
> +++ b/drivers/power/Kconfig
> @@ -0,0 +1,17 @@
> +menuconfig POWER_SUPPLY
> +	tristate "Power supply class support"
> +	help
> +	  Say Y here to enable power supply class support. This allows
> +	  power supply (batteries, AC, USB) monitoring by userspace
> +	  via sysfs and uevent (if available) and/or APM kernel interface
> +	  (if selected below).
> +
> +if POWER_SUPPLY
> +
> +config POWER_SUPPLY_DEBUG
> +	bool "Power supply debug"
> +	help
> +	  Say Y here to enable debugging messages for power supply class
> +	  and drivers.
> +
> +endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> new file mode 100644
> index 0000000..95085ba
> --- /dev/null
> +++ b/drivers/power/Makefile
> @@ -0,0 +1,15 @@
> +power_supply-objs := power_supply_core.o
> +
> +ifeq ($(CONFIG_SYSFS),y)
> +power_supply-objs += power_supply_sysfs.o
> +endif

Why would this work at all without sysfs?

> +ifeq ($(CONFIG_LEDS_TRIGGERS),y)
> +power_supply-objs += power_supply_leds.o
> +endif
> +
> +ifeq ($(CONFIG_POWER_SUPPLY_DEBUG),y)
> +EXTRA_CFLAGS += -DDEBUG
> +endif
> +
> +obj-$(CONFIG_POWER_SUPPLY)         += power_supply.o
> diff --git a/drivers/power/power_supply.h b/drivers/power/power_supply.h
> new file mode 100644
> index 0000000..b1cb7c4
> --- /dev/null
> +++ b/drivers/power/power_supply.h
> @@ -0,0 +1,42 @@
> +/*
> + *  Functions private to power supply class
> + *
> + *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
> + *  Copyright (c) 2004  Szabolcs Gyurko
> + *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
> + *
> + *  Modified: 2004, Oct     Szabolcs Gyurko
> + *
> + *  You may use this code as per GPL version 2
> + */
> +
> +#ifdef CONFIG_SYSFS
> +
> +extern int power_supply_create_attrs(struct power_supply *psy);
> +extern void power_supply_remove_attrs(struct power_supply *psy);
> +extern int power_supply_uevent(struct device *dev, char **envp, int num_envp,
> +                               char *buffer, int buffer_size);
> +
> +#else
> +
> +static inline int power_supply_create_attrs(struct power_supply *psy)
> +{ return 0; }
> +static inline void power_supply_remove_attrs(struct power_supply *psy) {}
> +#define power_supply_uevent NULL
> +
> +#endif /* CONFIG_SYSFS */
> +
> +#ifdef CONFIG_LEDS_TRIGGERS
> +
> +extern void power_supply_update_leds(struct power_supply *psy);
> +extern int power_supply_create_triggers(struct power_supply *psy);
> +extern void power_supply_remove_triggers(struct power_supply *psy);
> +
> +#else
> +
> +static inline void power_supply_update_leds(struct power_supply *psy) {}
> +static inline int power_supply_create_triggers(struct power_supply *psy)
> +{ return 0; }
> +static inline void power_supply_remove_triggers(struct power_supply *psy) {}
> +
> +#endif /* CONFIG_LEDS_TRIGGERS */
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> new file mode 100644
> index 0000000..6e28e47
> --- /dev/null
> +++ b/drivers/power/power_supply_core.c
> @@ -0,0 +1,168 @@
> +/*
> + *  Universal power supply monitor class
> + *
> + *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
> + *  Copyright (c) 2004  Szabolcs Gyurko
> + *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
> + *
> + *  Modified: 2004, Oct     Szabolcs Gyurko
> + *
> + *  You may use this code as per GPL version 2
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/power_supply.h>
> +#include "power_supply.h"
> +
> +struct class *power_supply_class;
> +
> +static void power_supply_changed_work(struct work_struct *work)
> +{
> +	struct power_supply *psy = container_of(work, struct power_supply,
> +	                                        changed_work);
> +	int i;
> +
> +	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
> +
> +	for (i = 0; i < psy->num_supplicants; i++) {
> +		struct device *dev;
> +
> +		down(&power_supply_class->sem);
> +		list_for_each_entry(dev, &power_supply_class->devices, node) {
> +			struct power_supply *pst = dev_get_drvdata(dev);
> +
> +			if (!strcmp(psy->supplied_to[i], pst->name)) {
> +				if (pst->external_power_changed)
> +					pst->external_power_changed(pst);
> +			}
> +		}
> +		up(&power_supply_class->sem);
> +	}
> +
> +	power_supply_update_leds(psy);
> +
> +	kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
> +
> +	return;
> +}
> +
> +void power_supply_changed(struct power_supply *psy)
> +{
> +	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
> +
> +	schedule_work(&psy->changed_work);
> +
> +	return;
> +}
> +
> +int power_supply_am_i_supplied(struct power_supply *psy)
> +{
> +	union power_supply_propval ret = {0,};
> +	struct device *dev;
> +
> +	down(&power_supply_class->sem);
> +	list_for_each_entry(dev, &power_supply_class->devices, node) {
> +		struct power_supply *epsy = dev_get_drvdata(dev);
> +		int i;
> +
> +		for (i = 0; i < epsy->num_supplicants; i++) {
> +			if (!strcmp(epsy->supplied_to[i], psy->name)) {
> +				if (epsy->get_property(epsy,
> +				          POWER_SUPPLY_PROP_ONLINE, &ret))
> +					continue;
> +				if (ret.intval)
> +					goto out;
> +			}
> +		}
> +	}
> +out:
> +	up(&power_supply_class->sem);
> +
> +	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret.intval);
> +
> +	return ret.intval;
> +}
> +
> +int power_supply_register(struct device *parent, struct power_supply *psy)
> +{
> +	int rc = 0;
> +
> +	psy->dev = device_create(power_supply_class, parent, 0,
> +	                         "%s", psy->name);
> +	if (IS_ERR(psy->dev)) {
> +		rc = PTR_ERR(psy->dev);
> +		goto dev_create_failed;
> +	}
> +
> +	dev_set_drvdata(psy->dev, psy);
> +
> +	INIT_WORK(&psy->changed_work, power_supply_changed_work);
> +
> +	rc = power_supply_create_attrs(psy);
> +	if (rc)
> +		goto create_attrs_failed;
> +
> +	rc = power_supply_create_triggers(psy);
> +	if (rc)
> +		goto create_triggers_failed;
> +
> +	power_supply_changed(psy);
> +
> +	goto success;
> +
> +create_triggers_failed:
> +	power_supply_remove_attrs(psy);
> +create_attrs_failed:
> +	device_unregister(psy->dev);
> +dev_create_failed:
> +success:
> +	return rc;
> +}
> +
> +void power_supply_unregister(struct power_supply *psy)
> +{
> +	flush_scheduled_work();
> +	power_supply_remove_triggers(psy);
> +	power_supply_remove_attrs(psy);
> +	device_unregister(psy->dev);
> +	return;
> +}
> +
> +static int __init power_supply_class_init(void)
> +{
> +	power_supply_class = class_create(THIS_MODULE, "power supply");

Please use "power_supply" instead as mentioned above.

> --- /dev/null
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -0,0 +1,254 @@
> +/*
> + *  Sysfs interface for the universal power supply monitor class
> + *
> + *  Copyright ??  2007  David Woodhouse <dwmw2@infradead.org>

What's with the ??

> + *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
> + *  Copyright (c) 2004  Szabolcs Gyurko
> + *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
> + *
> + *  Modified: 2004, Oct     Szabolcs Gyurko
> + *
> + *  You may use this code as per GPL version 2
> + */
> +
> +#include <linux/power_supply.h>
> +
> +/*
> + * This is because the name "current" breaks the device attr macro.
> + * The "current" word resolvs to "(get_current())" so instead of
> + * "current" "(get_current())" appears in the sysfs.
> + *
> + * The source of this definition is the device.h which calls __ATTR
> + * macro in sysfs.h which calls the __stringify macro.
> + *
> + * Only modification that the name is not tried to be resolved
> + * (as a macro let's say).
> + */
> +
> +#define POWER_SUPPLY_ATTR(_name)                                        \
> +{                                                                       \
> +	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE }, \
> +	.show = power_supply_show_property,                             \
> +	.store = NULL,                                                  \
> +}
> +
> +static struct device_attribute power_supply_attrs[];
> +
> +static ssize_t power_supply_show_property(struct device *dev,
> +                                          struct device_attribute *attr,
> +                                          char *buf) {
> +	static char *status_text[] = {
> +		"Unknown", "Charging", "Discharging", "Not charging", "Full"
> +	};
> +	static char *health_text[] = {
> +		"Unknown", "Good", "Overheat", "Dead"
> +	};
> +	static char *technology_text[] = {
> +		"Unknown", "NiMH", "Li-ion", "Li-poly"
> +	};
> +	static char *capacity_level_text[] = {
> +		"Unknown", "Critical", "Low", "Normal", "High", "Full"
> +	};

Shouldn't these strings corrispond with some enumerated type somewhere?
What is keeping them in sequence?

> +	ssize_t ret;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	const off_t off = attr - power_supply_attrs;
> +	union power_supply_propval value;
> +
> +	ret = psy->get_property(psy, off, &value);
> +
> +	if (ret < 0) {
> +		dev_err(dev, "driver failed to report `%s' property\n",
> +		        attr->attr.name);
> +		return ret;
> +	}
> +
> +	if (off == POWER_SUPPLY_PROP_STATUS)
> +		return sprintf(buf, "%s\n", status_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_HEALTH)
> +		return sprintf(buf, "%s\n", health_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
> +		return sprintf(buf, "%s\n", technology_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
> +		return sprintf(buf, "%s\n",
> +		               capacity_level_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_MODEL_NAME)
> +		return sprintf(buf, "%s\n", value.strval);
> +
> +	return sprintf(buf, "%d\n", value.intval);
> +}
> +
> +/* Must be in the same order as POWER_SUPPLY_PROP_* */
> +static struct device_attribute power_supply_attrs[] = {
> +	/* Properties of type `int' */
> +	POWER_SUPPLY_ATTR(status),
> +	POWER_SUPPLY_ATTR(health),
> +	POWER_SUPPLY_ATTR(present),
> +	POWER_SUPPLY_ATTR(online),
> +	POWER_SUPPLY_ATTR(technology),
> +	POWER_SUPPLY_ATTR(voltage_max_design),
> +	POWER_SUPPLY_ATTR(voltage_min_design),
> +	POWER_SUPPLY_ATTR(voltage_now),
> +	POWER_SUPPLY_ATTR(voltage_avg),
> +	POWER_SUPPLY_ATTR(current_now),
> +	POWER_SUPPLY_ATTR(current_avg),
> +	POWER_SUPPLY_ATTR(charge_full_design),
> +	POWER_SUPPLY_ATTR(charge_empty_design),
> +	POWER_SUPPLY_ATTR(charge_full),
> +	POWER_SUPPLY_ATTR(charge_empty),
> +	POWER_SUPPLY_ATTR(charge_now),
> +	POWER_SUPPLY_ATTR(charge_avg),
> +	POWER_SUPPLY_ATTR(energy_full_design),
> +	POWER_SUPPLY_ATTR(energy_empty_design),
> +	POWER_SUPPLY_ATTR(energy_full),
> +	POWER_SUPPLY_ATTR(energy_empty),
> +	POWER_SUPPLY_ATTR(energy_now),
> +	POWER_SUPPLY_ATTR(energy_avg),
> +	POWER_SUPPLY_ATTR(capacity),
> +	POWER_SUPPLY_ATTR(capacity_level),
> +	POWER_SUPPLY_ATTR(temp),
> +	POWER_SUPPLY_ATTR(temp_ambient),
> +	POWER_SUPPLY_ATTR(time_to_empty_now),
> +	POWER_SUPPLY_ATTR(time_to_empty_avg),
> +	POWER_SUPPLY_ATTR(time_to_full_now),
> +	POWER_SUPPLY_ATTR(time_to_full_avg),
> +	/* Properties of type `const char *' */
> +	POWER_SUPPLY_ATTR(model_name),
> +};

Don't you need a NULL attribute at the end here?

> +
> +static ssize_t power_supply_show_static_attrs(struct device *dev,
> +                                              struct device_attribute *attr,
> +                                              char *buf) {
> +	static char *type_text[] = { "Battery", "UPS", "AC", "USB" };
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", type_text[psy->type]);
> +}
> +
> +static struct device_attribute power_supply_static_attrs[] = {
> +	__ATTR(type, 0444, power_supply_show_static_attrs, NULL),
> +};
> +
> +int power_supply_create_attrs(struct power_supply *psy)
> +{
> +	int rc = 0;
> +	int i, j;
> +
> +	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++) {
> +		rc = device_create_file(psy->dev,
> +		            &power_supply_static_attrs[i]);
> +		if (rc)
> +			goto statics_failed;
> +	}
> +
> +	for (j = 0; j < psy->num_properties; j++) {
> +		rc = device_create_file(psy->dev,
> +		            &power_supply_attrs[psy->properties[j]]);
> +		if (rc)
> +			goto dynamics_failed;
> +	}

Why not use the default attribute field?  If you do that, all of the
logic in this function goes away as they are automatically created for
you.

> +
> +	goto succeed;
> +
> +dynamics_failed:
> +	while (j--)
> +		device_remove_file(psy->dev,
> +		           &power_supply_attrs[psy->properties[j]]);
> +statics_failed:
> +	while (i--)
> +		device_remove_file(psy->dev,
> +		           &power_supply_static_attrs[psy->properties[i]]);
> +succeed:
> +	return rc;
> +}
> +
> +void power_supply_remove_attrs(struct power_supply *psy)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
> +		device_remove_file(psy->dev,
> +		            &power_supply_static_attrs[i]);
> +
> +	for (i = 0; i < psy->num_properties; i++)
> +		device_remove_file(psy->dev,
> +		            &power_supply_attrs[psy->properties[i]]);
> +
> +	return;
> +}
> +
> +int power_supply_uevent(struct device *dev, char **envp, int num_envp,
> +                        char *buffer, int buffer_size)
> +{
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	int i = 0, length = 0, ret = 0, j;
> +	char *prop_buf;
> +
> +	dev_dbg(dev, "uevent\n");
> +
> +	if (!psy) {
> +		dev_dbg(dev, "No power supply yet\n");
> +		return ret;
> +	}
> +
> +	dev_dbg(dev, "POWER_SUPPLY_name=%s\n", psy->name);
> +
> +	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
> +	                     &length, "POWER_SUPPLY_name=%s", psy->name);

Why would POWER_SUPPLY_name be different from the kobject's name?

Also, environment variables are usually all in uppercase.

> +	if (ret)
> +		return ret;
> +
> +	prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
> +	if (!prop_buf)
> +		return -ENOMEM;
> +
> +	for (j = 0; j < ARRAY_SIZE(power_supply_static_attrs); j++) {
> +		struct device_attribute *attr;
> +		char *line;
> +
> +		attr = &power_supply_static_attrs[j];
> +
> +		if (power_supply_show_static_attrs(dev, attr, prop_buf) < 0)
> +			goto out;
> +
> +		line = strchr(prop_buf, '\n');
> +		if (line)
> +			*line = 0;
> +
> +		dev_dbg(dev, "Static prop %s=%s\n", attr->attr.name, prop_buf);
> +
> +		ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
> +		                     &length, "POWER_SUPPLY_%s=%s",
> +		                     attr->attr.name, prop_buf);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	dev_dbg(dev, "%d dynamic props\n", psy->num_properties);
> +
> +	for (j = 0; j < psy->num_properties; j++) {
> +		struct device_attribute *attr;
> +		char *line;
> +
> +		attr = &power_supply_attrs[psy->properties[j]];
> +
> +		if (power_supply_show_property(dev, attr, prop_buf) < 0)
> +			goto out;
> +
> +		line = strchr(prop_buf, '\n');
> +		if (line)
> +			*line = 0;
> +
> +		dev_dbg(dev, "prop %s=%s\n", attr->attr.name, prop_buf);
> +
> +		ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
> +		                     &length, "POWER_SUPPLY_%s=%s",
> +		                     attr->attr.name, prop_buf);
> +		if (ret)
> +			goto out;
> +	}

We typically do not export _every_ attribute of a kobject to userspace
through the kevent mechanism.  Why is this needed?

> +
> +out:
> +	free_page((unsigned long)prop_buf);
> +
> +	return ret;
> +}

thanks,

greg k-h
