Return-Path: <linux-kernel-owner+w=401wt.eu-S1161520AbXDLC5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161520AbXDLC5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161516AbXDLCvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:51:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48779 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161510AbXDLCvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:51:42 -0400
Date: Wed, 11 Apr 2007 19:53:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-Id: <20070411195359.2983b857.randy.dunlap@oracle.com>
In-Reply-To: <20070411232503.GC20095@zarina>
References: <20070411232503.GC20095@zarina>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 03:25:03 +0400 Anton Vorontsov wrote:

> Here is battery monitor class. According to first copyright string, we're
> maintaining it since 2003. I've took few days and cleaned it up to be
> more suitable for mainline inclusion.
> 
> ---
>  drivers/Kconfig           |    2 +
>  drivers/Makefile          |    1 +
>  drivers/battery/Kconfig   |   11 ++
>  drivers/battery/Makefile  |    1 +
>  drivers/battery/battery.c |  303 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/battery.h   |   98 +++++++++++++++
>  6 files changed, 416 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/battery/Kconfig
>  create mode 100644 drivers/battery/Makefile
>  create mode 100644 drivers/battery/battery.c
>  create mode 100644 include/linux/battery.h
> 
> diff --git a/drivers/battery/battery.c b/drivers/battery/battery.c
> new file mode 100644
> index 0000000..32b8288
> --- /dev/null
> +++ b/drivers/battery/battery.c
> @@ -0,0 +1,303 @@
> +
> +void battery_status_changed(struct battery *bat)
> +{
> +	pr_debug("%s\n", __FUNCTION__);
> +	#ifdef CONFIG_LEDS_TRIGGERS

Please don't indent preprocessor controls (ifdef/endif etc.).

> +	switch(bat->get_status(bat))
> +	{
> +		case BATTERY_STATUS_FULL:
> +			led_trigger_event(bat->charging_trig, LED_OFF);
> +			led_trigger_event(bat->full_trig, LED_FULL);
> +			break;
> +		case BATTERY_STATUS_CHARGING:
> +			led_trigger_event(bat->charging_trig, LED_FULL);
> +			led_trigger_event(bat->full_trig, LED_OFF);
> +			break;
> +		default:
> +			led_trigger_event(bat->charging_trig, LED_OFF);
> +			led_trigger_event(bat->full_trig, LED_OFF);
> +			break;

Place 'switch' and 'case' at the same indent level.  This prevents
the "double-indent" for the code statements.

> +	}
> +	#endif /* CONFIG_LEDS_TRIGGERS */
> +	return;
> +}
> +
> +static char *status_text[] = {
> +	"Unknown", "Charging", "Discharging", "Not charging", "Full"
> +};
> +
> +static ssize_t battery_show_status(struct device *dev,
> +                                   struct device_attribute *attr, char *buf)
> +{
> +	struct battery *bat = dev_get_drvdata(dev);
> +	int status = 0;

We usually try to place a blank line between local data and code.

> +	if (bat->get_status) {
> +		status = bat->get_status(bat);
> +		if (status > 4)
> +			status = 0;
> +		return sprintf(buf, "%s\n", status_text[status]);
> +	}
> +	return 0;
> +}
> +
> +static int battery_create_attrs(struct battery *bat)
> +{
> +	int rc;
> +
> +	#define create_bat_attr_conditional(name)                    \
> +	if(bat->get_##name) {                                        \

	space after "if"

> +		rc = device_create_file(bat->dev, &dev_attr_##name); \
> +		if (rc) goto name##_failed;                          \
> +	}
> +
> +	create_bat_attr_conditional(status);
> +	create_bat_attr_conditional(min_voltage);
> +	create_bat_attr_conditional(min_current);
> +	create_bat_attr_conditional(min_capacity);
> +	create_bat_attr_conditional(max_voltage);
> +	create_bat_attr_conditional(max_current);
> +	create_bat_attr_conditional(max_capacity);
> +	create_bat_attr_conditional(temp);
> +	create_bat_attr_conditional(voltage);
> +	create_bat_attr_conditional(current);
> +	create_bat_attr_conditional(capacity);
> +
> +	#define remove_bat_attr_conditional(name)               \
> +	if(bat->get_##name)                                     \

ditto.

> +		device_remove_file(bat->dev, &dev_attr_##name);
> +
> +	goto success;
> +
> +capacity_failed:     remove_bat_attr_conditional(current);
> +current_failed:      remove_bat_attr_conditional(voltage);
> +voltage_failed:      remove_bat_attr_conditional(temp);
> +temp_failed:         remove_bat_attr_conditional(max_capacity);
> +max_capacity_failed: remove_bat_attr_conditional(max_current);
> +max_current_failed:  remove_bat_attr_conditional(max_voltage);
> +max_voltage_failed:  remove_bat_attr_conditional(min_capacity);
> +min_capacity_failed: remove_bat_attr_conditional(min_current);
> +min_current_failed:  remove_bat_attr_conditional(min_voltage);
> +min_voltage_failed:  remove_bat_attr_conditional(status);

I thought there was a class_remove() or something like that?
but I'm not sure of it.

> +status_failed:
> +success:
> +	return rc;
> +}
> +
> +static void battery_remove_attrs(struct battery *bat)
> +{
> +	remove_bat_attr_conditional(capacity);
> +	remove_bat_attr_conditional(current);
> +	remove_bat_attr_conditional(voltage);
> +	remove_bat_attr_conditional(temp);
> +	remove_bat_attr_conditional(max_capacity);
> +	remove_bat_attr_conditional(max_current);
> +	remove_bat_attr_conditional(max_voltage);
> +	remove_bat_attr_conditional(min_capacity);
> +	remove_bat_attr_conditional(min_current);
> +	remove_bat_attr_conditional(min_voltage);
> +	remove_bat_attr_conditional(status);
> +	return;
> +}
> +
> +int battery_register(struct device *parent, struct battery *bat)
> +{
> +	int rc = 0;
> +
> +	bat->dev = device_create(battery_class, parent, 0, "%s", bat->name);
> +	if(IS_ERR(bat->dev)) {

	space after "if"

> +		rc = PTR_ERR(bat->dev);
> +		goto dev_create_failed;
> +	}
> +
> +	dev_set_drvdata(bat->dev, bat);
> +
> +	rc = battery_create_attrs(bat);
> +	if (rc)
> +		goto create_bat_attrs_failed;
> +
> +	bat->pst.name = bat->name;
> +	bat->pst.power_supply_changed = battery_external_power_changed;
> +	rc = power_supplicant_register(&bat->pst);
> +	if (rc)
> +		goto power_supplicant_failed;
> +
> +	#ifdef CONFIG_LEDS_TRIGGERS

Don't indent the preprocessor lines.  It hides them (too much).

> +	bat->charging_trig_name = kmalloc(strlen(bat->name) +
> +	                                  sizeof("-charging"), GFP_KERNEL);
> +	if (!bat->charging_trig_name) {
> +		rc = -ENOMEM;
> +		goto charging_trig_name_failed;
> +	}
> +
> +	bat->full_trig_name = kmalloc(strlen(bat->name) +
> +	                              sizeof("-full"), GFP_KERNEL);
> +	if (!bat->full_trig_name) {
> +		rc = -ENOMEM;
> +		goto full_trig_name_failed;
> +	}
> +
> +	strcpy(bat->charging_trig_name, bat->name);
> +	strcat(bat->charging_trig_name, "-charging");
> +	strcpy(bat->full_trig_name, bat->name);
> +	strcat(bat->full_trig_name, "-full");
> +
> +	led_trigger_register_charging(bat->charging_trig_name,
> +	                              &bat->charging_trig);
> +	led_trigger_register_simple(bat->full_trig_name,
> +	                            &bat->full_trig);
> +	#endif /* CONFIG_LEDS_TRIGGERS */
> +
> +	goto success;
> +
> +#ifdef CONFIG_LEDS_TRIGGERS
> +full_trig_name_failed:
> +	kfree(bat->charging_trig_name);
> +charging_trig_name_failed:
> +#endif
> +	power_supplicant_unregister(&bat->pst);
> +power_supplicant_failed:
> +	battery_remove_attrs(bat);
> +create_bat_attrs_failed:
> +	device_unregister(bat->dev);
> +dev_create_failed:
> +success:
> +	return rc;
> +}
> +
> +void battery_unregister(struct battery *bat)
> +{
> +	power_supplicant_unregister(&bat->pst);
> +	battery_remove_attrs(bat);
> +	device_unregister(bat->dev);
> +
> +	#ifdef CONFIG_LEDS_TRIGGERS

ifdef/endif not indented, please.

> +	led_trigger_unregister_charging(bat->charging_trig);
> +	led_trigger_unregister_simple(bat->full_trig);
> +	kfree(bat->full_trig_name);
> +	kfree(bat->charging_trig_name);
> +	#endif
> +
> +	return;
> +}
> +
> diff --git a/include/linux/battery.h b/include/linux/battery.h
> new file mode 100644
> index 0000000..a687781
> --- /dev/null
> +++ b/include/linux/battery.h
> @@ -0,0 +1,98 @@
> +
> +/* 
> + * For systems where the charger determines the maximum battery capacity
> + * the min and max fields should be used to present these values to user
> + * space. Unused/uknown fields can be NULL and will not appear in sysfs.

                    unknown

> + */
> +
> +struct battery {
> +	struct device *dev;
> +	char *name;
> +
> +	/* For APM emulation, think legacy userspace. */
> +	int main_battery;
> +
> +	/* executed in userspace, feel free to sleep */
> +	int (*get_min_voltage)(struct battery *bat);
> +	int (*get_min_current)(struct battery *bat);
> +	int (*get_min_capacity)(struct battery *bat);
> +	int (*get_max_voltage)(struct battery *bat);
> +	int (*get_max_current)(struct battery *bat);
> +	int (*get_max_capacity)(struct battery *bat);
> +	int (*get_temp)(struct battery *bat);
> +	int (*get_voltage)(struct battery *bat);
> +	int (*get_current)(struct battery *bat);
> +	int (*get_capacity)(struct battery *bat);
> +	int (*get_status)(struct battery *bat);
> +
> +	/* drivers should not sleep inside it, you'll get there from ISRs */
> +	void (*external_power_changed)(struct battery *bat);
> +
> +	/* private */
> +	struct power_supplicant pst;
> +
> +	#ifdef CONFIG_LEDS_TRIGGERS

ifdef/endif not indented.

> +	struct led_trigger *charging_trig;
> +	char *charging_trig_name;
> +	struct led_trigger *full_trig;
> +	char *full_trig_name;
> +	#endif
> +};
> +
> +/* 

Please check all patches for trailing whitespace and correct that.

> + * This is recommended structure to specify static battery parameters.
> + * Generic one, parametrizable for different batteries. Battery device
> + * itself does bot use it, but that's what implementing most drivers,
> + * should try reuse for consistency.
> + */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
