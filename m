Return-Path: <linux-kernel-owner+w=401wt.eu-S1767479AbXECX6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767479AbXECX6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767486AbXECX6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:58:16 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2624 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767479AbXECX6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:58:14 -0400
Date: Fri, 4 May 2007 03:54:37 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/8] Universal power supply class (was: battery class)
Message-ID: <20070503235437.GA20869@zarina>
Reply-To: cbou@mail.ru
References: <20070503213139.GC20067@zarina> <20070503225346.GA12892@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070503225346.GA12892@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:53:46PM -0700, Greg KH wrote:
> On Fri, May 04, 2007 at 01:31:39AM +0400, Anton Vorontsov wrote:
> > This class is result of "external power" and "battery" classes merge,
> > as suggested by David Woodhouse. He also implemented uevent support.
> > 
> > Here how userspace seeing it now:
> > 
> >     	# ls /sys/class/power\ supply/
> >     	ac  main-battery  usb
> 
> Please don't put a space in a class name.  Yes, we can do it, but some
> scripts will bomb.  If you look all of the other classes use a '_'
> instead.

Ack. power_supply would be okay? Or power-supply better?

> >     	# cat /sys/class/power\ supply/
> >     	ac/           main-battery/ usb/
> 
> Um, shouldn't that be an error?  Isn't /sys/class/power\ supply/ a
> directory?

Actually that class does not work, I just faking output and lying it
works. ;-)

Just kidding.. It's just shell completion.

> >     	# cat /sys/class/power\ supply/ac/type
> >     	AC
> > 
> >     	# cat /sys/class/power\ supply/usb/type
> >     	USB
> > 
> >     	# cat /sys/class/power\ supply/main-battery/type
> >     	Battery
> > 
> >     	# cat /sys/class/power\ supply/ac/online
> >     	1
> > 
> >     	# cat /sys/class/power\ supply/usb/online
> >     	0
> 
> I don't really understand, is the 'usb' and 'ac' directories really a
> 'struct device' here?  Shouldn't there be some symlinks around here?
> 
> Can you do a 'tree /sys/class/power\ supply/' and show me the output?

# tree
-bash: tree: command not found

# ls -al /sys/class/power\ supply/
total 0
drwxr-xr-x  2 root root 0 Jan  1 00:01 .
drwxr-xr-x 20 root root 0 Jan  1 00:01 ..
lrwxrwxrwx  1 root root 0 Jan  1 00:01 ac -> ../../devices/platform/pda-power/ac
lrwxrwxrwx  1 root root 0 Jan  1 00:01 usb -> ../../devices/platform/pda-power/usb

# ls -al /sys/class/power\ supply/ac/
total 0
drwxr-xr-x 3 root root    0 Jan  1 00:01 .
drwxr-xr-x 5 root root    0 Jan  1 00:01 ..
-r--r--r-- 1 root root 4096 Jan  1 00:01 online
drwxr-xr-x 2 root root    0 Jan  1 00:01 power
lrwxrwxrwx 1 root root    0 Jan  1 00:01 subsystem -> ../../../../class/power supply
-r--r--r-- 1 root root 4096 Jan  1 00:01 type
--w------- 1 root root 4096 Jan  1 00:01 uevent

> > 
> >     	# cat /sys/class/power\ supply/main-battery/status
> >     	Charging
> > 
> >     	# cat /sys/class/leds/h5400\:red-left/trigger
> >     	none h5400-radio timer hwtimer ac-online usb-online
> >     	main-battery-charging-or-full [main-battery-charging]
> >     	main-battery-full
> 
> Huh?  What does the led have to do with the battery?

Have you read Documentation/power_supply_class.txt? Quoting:

"It also integrates with LED framework, for the purpose of providing
typically expected feedback of battery charging/fully charged status and
AC/USB power supply online status. (Note that specific details of the
indication (including whether to use it at all) are fully controllable by
user and/or specific machine defaults, per design principles of LED
framework)."

So, PDA/phones using LEDs to provide feedback of battery charging
status. You put PDA into cradle, and LED1 starts to flash... when battery
fully charged, LED1 offs, and another LED2 (with different color) starts
flashing.

> > diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> > new file mode 100644
> > index 0000000..95085ba
> > --- /dev/null
> > +++ b/drivers/power/Makefile
> > @@ -0,0 +1,15 @@
> > +power_supply-objs := power_supply_core.o
> > +
> > +ifeq ($(CONFIG_SYSFS),y)
> > +power_supply-objs += power_supply_sysfs.o
> > +endif
> 
> Why would this work at all without sysfs?

I don't know, because it can? I didn't tested w/o sysfs, though.

But sysfs is just one of interfaces power supply class using to
"export" power supply information to the user-space. apm_power
is another. And who knows what new intefaces we'll see later.

> > +
> > +static int __init power_supply_class_init(void)
> > +{
> > +	power_supply_class = class_create(THIS_MODULE, "power supply");
> 
> Please use "power_supply" instead as mentioned above.

Ack again.

> > --- /dev/null
> > +++ b/drivers/power/power_supply_sysfs.c
> > @@ -0,0 +1,254 @@
> > +/*
> > + *  Sysfs interface for the universal power supply monitor class
> > + *
> > + *  Copyright ??  2007  David Woodhouse <dwmw2@infradead.org>
> 
> What's with the ??

:-) It's because my locale is utf8 unaware, and mutt destroyed (c)
symbol.

> > + *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
> > + *  Copyright (c) 2004  Szabolcs Gyurko
> > + *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
> > + *
> > + *  Modified: 2004, Oct     Szabolcs Gyurko
> > + *
> > + *  You may use this code as per GPL version 2
> > + */
> > +
> > +#include <linux/power_supply.h>
> > +
> > +/*
> > + * This is because the name "current" breaks the device attr macro.
> > + * The "current" word resolvs to "(get_current())" so instead of
> > + * "current" "(get_current())" appears in the sysfs.
> > + *
> > + * The source of this definition is the device.h which calls __ATTR
> > + * macro in sysfs.h which calls the __stringify macro.
> > + *
> > + * Only modification that the name is not tried to be resolved
> > + * (as a macro let's say).
> > + */
> > +
> > +#define POWER_SUPPLY_ATTR(_name)                                        \
> > +{                                                                       \
> > +	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE }, \
> > +	.show = power_supply_show_property,                             \
> > +	.store = NULL,                                                  \
> > +}
> > +
> > +static struct device_attribute power_supply_attrs[];
> > +
> > +static ssize_t power_supply_show_property(struct device *dev,
> > +                                          struct device_attribute *attr,
> > +                                          char *buf) {
> > +	static char *status_text[] = {
> > +		"Unknown", "Charging", "Discharging", "Not charging", "Full"
> > +	};
> > +	static char *health_text[] = {
> > +		"Unknown", "Good", "Overheat", "Dead"
> > +	};
> > +	static char *technology_text[] = {
> > +		"Unknown", "NiMH", "Li-ion", "Li-poly"
> > +	};
> > +	static char *capacity_level_text[] = {
> > +		"Unknown", "Critical", "Low", "Normal", "High", "Full"
> > +	};
> 
> Shouldn't these strings corrispond with some enumerated type somewhere?
> What is keeping them in sequence?

include/linux/power_supply.h keeping them in sequence.

#define POWER_SUPPLY_HEALTH_UNKNOWN  0
#define POWER_SUPPLY_HEALTH_GOOD     1
#define POWER_SUPPLY_HEALTH_OVERHEAT 2
#define POWER_SUPPLY_HEALTH_DEAD     3

> > +	ssize_t ret;
> > +	struct power_supply *psy = dev_get_drvdata(dev);
> > +	const off_t off = attr - power_supply_attrs;
> > +	union power_supply_propval value;
> > +
> > +	ret = psy->get_property(psy, off, &value);
> > +
> > +	if (ret < 0) {
> > +		dev_err(dev, "driver failed to report `%s' property\n",
> > +		        attr->attr.name);
> > +		return ret;
> > +	}
> > +
> > +	if (off == POWER_SUPPLY_PROP_STATUS)
> > +		return sprintf(buf, "%s\n", status_text[value.intval]);
> > +	else if (off == POWER_SUPPLY_PROP_HEALTH)
> > +		return sprintf(buf, "%s\n", health_text[value.intval]);
> > +	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
> > +		return sprintf(buf, "%s\n", technology_text[value.intval]);
> > +	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
> > +		return sprintf(buf, "%s\n",
> > +		               capacity_level_text[value.intval]);
> > +	else if (off == POWER_SUPPLY_PROP_MODEL_NAME)
> > +		return sprintf(buf, "%s\n", value.strval);
> > +
> > +	return sprintf(buf, "%d\n", value.intval);
> > +}
> > +
> > +/* Must be in the same order as POWER_SUPPLY_PROP_* */
> > +static struct device_attribute power_supply_attrs[] = {
> > +	/* Properties of type `int' */
> > +	POWER_SUPPLY_ATTR(status),
> > +	POWER_SUPPLY_ATTR(health),
> > +	POWER_SUPPLY_ATTR(present),
> > +	POWER_SUPPLY_ATTR(online),
> > +	POWER_SUPPLY_ATTR(technology),
> > +	POWER_SUPPLY_ATTR(voltage_max_design),
> > +	POWER_SUPPLY_ATTR(voltage_min_design),
> > +	POWER_SUPPLY_ATTR(voltage_now),
> > +	POWER_SUPPLY_ATTR(voltage_avg),
> > +	POWER_SUPPLY_ATTR(current_now),
> > +	POWER_SUPPLY_ATTR(current_avg),
> > +	POWER_SUPPLY_ATTR(charge_full_design),
> > +	POWER_SUPPLY_ATTR(charge_empty_design),
> > +	POWER_SUPPLY_ATTR(charge_full),
> > +	POWER_SUPPLY_ATTR(charge_empty),
> > +	POWER_SUPPLY_ATTR(charge_now),
> > +	POWER_SUPPLY_ATTR(charge_avg),
> > +	POWER_SUPPLY_ATTR(energy_full_design),
> > +	POWER_SUPPLY_ATTR(energy_empty_design),
> > +	POWER_SUPPLY_ATTR(energy_full),
> > +	POWER_SUPPLY_ATTR(energy_empty),
> > +	POWER_SUPPLY_ATTR(energy_now),
> > +	POWER_SUPPLY_ATTR(energy_avg),
> > +	POWER_SUPPLY_ATTR(capacity),
> > +	POWER_SUPPLY_ATTR(capacity_level),
> > +	POWER_SUPPLY_ATTR(temp),
> > +	POWER_SUPPLY_ATTR(temp_ambient),
> > +	POWER_SUPPLY_ATTR(time_to_empty_now),
> > +	POWER_SUPPLY_ATTR(time_to_empty_avg),
> > +	POWER_SUPPLY_ATTR(time_to_full_now),
> > +	POWER_SUPPLY_ATTR(time_to_full_avg),
> > +	/* Properties of type `const char *' */
> > +	POWER_SUPPLY_ATTR(model_name),
> > +};
> 
> Don't you need a NULL attribute at the end here?

No.

> > +
> > +static ssize_t power_supply_show_static_attrs(struct device *dev,
> > +                                              struct device_attribute *attr,
> > +                                              char *buf) {
> > +	static char *type_text[] = { "Battery", "UPS", "AC", "USB" };
> > +	struct power_supply *psy = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%s\n", type_text[psy->type]);
> > +}
> > +
> > +static struct device_attribute power_supply_static_attrs[] = {
> > +	__ATTR(type, 0444, power_supply_show_static_attrs, NULL),
> > +};
> > +
> > +int power_supply_create_attrs(struct power_supply *psy)
> > +{
> > +	int rc = 0;
> > +	int i, j;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++) {
> > +		rc = device_create_file(psy->dev,
> > +		            &power_supply_static_attrs[i]);
> > +		if (rc)
> > +			goto statics_failed;
> > +	}
> > +
> > +	for (j = 0; j < psy->num_properties; j++) {
> > +		rc = device_create_file(psy->dev,
> > +		            &power_supply_attrs[psy->properties[j]]);
> > +		if (rc)
> > +			goto dynamics_failed;
> > +	}
> 
> Why not use the default attribute field?  If you do that, all of the
> logic in this function goes away as they are automatically created for
> you.

Please, take a look at any driver which using that class, and you'll
see why it's done that way.

static int ds2760_battery_get_property(struct power_supply *psy,
                                       enum power_supply_property psp,
                                       union power_supply_propval *val)
{
        struct ds2760_device_info *di = to_ds2760_device_info(psy);

        switch (psp) {
        case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
                val->intval = di->bi->voltage_max_design;
                return 0;
	...
}

static enum power_supply_property ds2760_battery_props[] = {
        POWER_SUPPLY_PROP_STATUS,
        POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
        POWER_SUPPLY_PROP_VOLTAGE_NOW,
	...
}

static int ds2760_battery_probe(struct platform_device *pdev)
{
        ...
        di->bat.properties     = ds2760_battery_props;
        di->bat.num_properties = ARRAY_SIZE(ds2760_battery_props);
        di->bat.get_property   = ds2760_battery_get_property;
	...
}

If you have better idea how to declare conditional/optional attributes,
which not appears in sysfs when unused, then please tell.

Declaring attributes inside driver itself is no go, because that way
class don't know about them, can't read them, and can't do it's own
logic (LEDs, apm_power).

> > +
> > +	goto succeed;
> > +
> > +dynamics_failed:
> > +	while (j--)
> > +		device_remove_file(psy->dev,
> > +		           &power_supply_attrs[psy->properties[j]]);
> > +statics_failed:
> > +	while (i--)
> > +		device_remove_file(psy->dev,
> > +		           &power_supply_static_attrs[psy->properties[i]]);
> > +succeed:
> > +	return rc;
> > +}
> > +
> > +void power_supply_remove_attrs(struct power_supply *psy)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
> > +		device_remove_file(psy->dev,
> > +		            &power_supply_static_attrs[i]);
> > +
> > +	for (i = 0; i < psy->num_properties; i++)
> > +		device_remove_file(psy->dev,
> > +		            &power_supply_attrs[psy->properties[i]]);
> > +
> > +	return;
> > +}
> > +
> > +int power_supply_uevent(struct device *dev, char **envp, int num_envp,
> > +                        char *buffer, int buffer_size)
> > +{
> > +	struct power_supply *psy = dev_get_drvdata(dev);
> > +	int i = 0, length = 0, ret = 0, j;
> > +	char *prop_buf;
> > +
> > +	dev_dbg(dev, "uevent\n");
> > +
> > +	if (!psy) {
> > +		dev_dbg(dev, "No power supply yet\n");
> > +		return ret;
> > +	}
> > +
> > +	dev_dbg(dev, "POWER_SUPPLY_name=%s\n", psy->name);
> > +
> > +	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
> > +	                     &length, "POWER_SUPPLY_name=%s", psy->name);
> 
> Why would POWER_SUPPLY_name be different from the kobject's name?
> 
> Also, environment variables are usually all in uppercase.

I'll take a look how to fix caps. _name given in lowercase
because attr->attr.name is in lowercase too:

ret = add_uevent_var(..., "POWER_SUPPLY_%s=%s", attr->attr.name, ...);

> > +	if (ret)
> > +		return ret;
> > +
> > +	prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
> > +	if (!prop_buf)
> > +		return -ENOMEM;
> > +
> > +	for (j = 0; j < ARRAY_SIZE(power_supply_static_attrs); j++) {
> > +		struct device_attribute *attr;
> > +		char *line;
> > +
> > +		attr = &power_supply_static_attrs[j];
> > +
> > +		if (power_supply_show_static_attrs(dev, attr, prop_buf) < 0)
> > +			goto out;
> > +
> > +		line = strchr(prop_buf, '\n');
> > +		if (line)
> > +			*line = 0;
> > +
> > +		dev_dbg(dev, "Static prop %s=%s\n", attr->attr.name, prop_buf);
> > +
> > +		ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
> > +		                     &length, "POWER_SUPPLY_%s=%s",
> > +		                     attr->attr.name, prop_buf);
> > +		if (ret)
> > +			goto out;
> > +	}
> > +
> > +	dev_dbg(dev, "%d dynamic props\n", psy->num_properties);
> > +
> > +	for (j = 0; j < psy->num_properties; j++) {
> > +		struct device_attribute *attr;
> > +		char *line;
> > +
> > +		attr = &power_supply_attrs[psy->properties[j]];
> > +
> > +		if (power_supply_show_property(dev, attr, prop_buf) < 0)
> > +			goto out;
> > +
> > +		line = strchr(prop_buf, '\n');
> > +		if (line)
> > +			*line = 0;
> > +
> > +		dev_dbg(dev, "prop %s=%s\n", attr->attr.name, prop_buf);
> > +
> > +		ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
> > +		                     &length, "POWER_SUPPLY_%s=%s",
> > +		                     attr->attr.name, prop_buf);
> > +		if (ret)
> > +			goto out;
> > +	}
> 
> We typically do not export _every_ attribute of a kobject to userspace
> through the kevent mechanism.  Why is this needed?

Neither David nor me had anything against exporting all attributes, so
it's done that way. If it's forbiden, then we need discussion what
attributes to export (only changed ones, or some strict subset, or ...).

> > +
> > +out:
> > +	free_page((unsigned long)prop_buf);
> > +
> > +	return ret;
> > +}
> 
> thanks,
> 
> greg k-h

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
