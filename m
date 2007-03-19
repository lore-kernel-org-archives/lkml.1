Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXCSG44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXCSG44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965738AbXCSG44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:56:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45195 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965736AbXCSG4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:56:55 -0400
Date: Sun, 18 Mar 2007 22:54:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rlove@rlove.org,
       linux-kernel@hansmi.ch
Subject: Re: [PATCH] Apple SMC driver (hardware monitoring and control)
Message-Id: <20070318225430.3d704289.akpm@linux-foundation.org>
In-Reply-To: <45FE1D44.8000805@boichat.ch>
References: <45F7C083.7090504@boichat.ch>
	<45FE1D44.8000805@boichat.ch>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 13:19:00 +0800 Nicolas Boichat <nicolas@boichat.ch> wrote:

> 
> This driver provides support for the Apple System Management Controller, which
> provides an accelerometer (Apple Sudden Motion Sensor), light sensors,
> temperature sensors, keyboard backlight control and fan control. Only
> Intel-based Apple's computers are supported (MacBook Pro, MacBook, MacMini).
> 

It's trivia time:

> +#define MOTION_SENSOR_X_KEY	"MO_X" //r-o length 2
> +#define MOTION_SENSOR_Y_KEY	"MO_Y" //r-o length 2
> +#define MOTION_SENSOR_Z_KEY	"MO_Z" //r-o length 2
> +#define MOTION_SENSOR_KEY	"MOCN" //r/w length 2
> +
> +#define FANS_COUNT		"FNum" //r-o length 1
> +#define FANS_MANUAL		"FS! " //r-w length 2
> +#define FAN_ACTUAL_SPEED	"F0Ac" //r-o length 2
> +#define FAN_MIN_SPEED		"F0Mn" //r-o length 2
> +#define FAN_MAX_SPEED		"F0Mx" //r-o length 2
> +#define FAN_SAFE_SPEED		"F0Sf" //r-o length 2
> +#define FAN_TARGET_SPEED	"F0Tg" //r-w length 2

Please avoid C++-style comments.

> +/* Temperature sensors keys. First set for Macbook(Pro), second for Macmini */
> +static const char* temperature_sensors_sets[][8] = {
> +	{ "TB0T", "TC0D", "TC0P", "Th0H", "Ts0P", "Th1H", "Ts1P", NULL },
> +	{ "TC0D", "TC0P", NULL }
> +};

The NULLs here are harmless, but unneeded.

> +/* Structure to be passed to DMI_MATCH function */
> +struct dmi_match_data {
> +/* Indicates whether this computer has an accelerometer. */
> +	int accelerometer;
> +/* Indicates whether this computer has light sensors and keyboard backlight. */
> +	int light;
> +/* Indicates which temperature sensors set to use. */
> +	int temperature_set;
> +};
> +
> +static int debug = 0;
> +static struct platform_device *pdev;
> +static s16 rest_x;
> +static s16 rest_y;
> +static struct timer_list applesmc_timer;
> +static struct input_dev *applesmc_idev;
> +
> +/* Indicates whether this computer has an accelerometer. */
> +static unsigned int applesmc_accelerometer = 0;
> +
> +/* Indicates whether this computer has light sensors and keyboard backlight. */
> +static unsigned int applesmc_light = 0;
> +
> +/* Indicates which temperature sensors set to use. */
> +static unsigned int applesmc_temperature_set = 0;

All the "= 0"s above are unneeded and will increase the module or vmlinux
size - they should be removed.

> +static DECLARE_MUTEX(applesmc_sem);

Semaphores should be used only when their counting feature is required.  I
think thsi can be switched to `struct mutex'.

> +/*
> + * applesmc_read_key - reads len bytes from a given key, and put them in buffer.
> + * Returns zero on success or a negative error on failure. Callers must
> + * hold applesmc_sem.
> + */
> +static int applesmc_read_key(const char* key, u8* buffer, u8 len)
> +{
> +	int ret = -EIO;
> +	int i;
> +
> +	outb(APPLESMC_READ_CMD, APPLESMC_CMD_PORT);
> +	if (__wait_status(0x0c))
> +		goto out;
> +	
> +	for (i = 0; i < 4; i++) {
> +		outb(key[i], APPLESMC_DATA_PORT);
> +		if (__wait_status(0x04))
> +			goto out;
> +	}
> +	if (debug) printk(KERN_DEBUG "<%s", key);
> +
> +	outb(len, APPLESMC_DATA_PORT);
> +	if (debug) printk(KERN_DEBUG ">%x", len);

Please convert to standard kernel style:

	if (debug)
		printk(KERN_DEBUG ">%x", len);

There are many instances of this.

> +
> +	for (i = 0; i < len; i++) {
> +		if (__wait_status(0x05))
> +			goto out;
> +		buffer[i] = inb(APPLESMC_DATA_PORT);
> +		if (debug) printk(KERN_DEBUG "<%x", buffer[i]);
> +	}
> +	if (debug) printk(KERN_DEBUG "\n");
> +	ret = 0;
> +
> +out:
> +	return ret;
> +}
> +
>
> ...
>
> +/*
> + * applesmc_device_init - initialize the accelerometer.  Returns zero on success
> + * and negative error code on failure.  Can sleep.
> + */
> +static int applesmc_device_init(void)
> +{
> +	int total, ret = -ENXIO;
> +	u8 buffer[2];
> +
> +	if (!applesmc_accelerometer) return 0;
> +
> +	down(&applesmc_sem);
> +
> +	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
> +		if (debug) printk(KERN_DEBUG "applesmc try %d\n", total);
> +		if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
> +				(buffer[0] != 0x00 || buffer[1] != 0x00)) {
> +			if (total == INIT_TIMEOUT_MSECS) {
> +				printk(KERN_DEBUG "applesmc: device has" 
> +						" already been initialized"
> +						" (0x%02x, 0x%02x).\n",
> +						buffer[0], buffer[1]);
> +			}
> +			else {

Please use

			} else {

here and wherever else the above appears.

> +				printk(KERN_DEBUG "applesmc: device" 
> +						" successfully initialized"
> +						" (0x%02x, 0x%02x).\n",
> +						buffer[0], buffer[1]);
> +			}
> +			ret = 0;
> +			goto out;
> +		}
> +		buffer[0] = 0xe0;
> +		buffer[1] = 0x00;
> +		applesmc_write_key(MOTION_SENSOR_KEY, buffer, 2);
> +		msleep(INIT_WAIT_MSECS);
> +	}
> +
> +	printk(KERN_WARNING "applesmc: failed to init the device\n");
> +
> +out:
> +	up(&applesmc_sem);
> +	return ret;
> +}
> +
>
> ...
>
> +/*
> + * Macro defining helper functions and DEVICE_ATTR for a fan sysfs entries.
> + *  - show actual speed
> + *  - show/store minimum speed
> + *  - show maximum speed
> + *  - show safe speed
> + *  - show/store target speed
> + *  - show/store manual mode
> + */
> +#define sysfs_fan_speeds_offset(offset) \
> +static ssize_t show_fan_actual_speed_##offset (struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +{ \
> +	return applesmc_show_fan_speed(dev, buf, FAN_ACTUAL_SPEED, offset); \
> +} \
> +static DEVICE_ATTR(fan##offset##_actual_speed, S_IRUGO, \
> +					show_fan_actual_speed_##offset, NULL); \
> +\
> +static ssize_t show_fan_minimum_speed_##offset (struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +{ \
> +	return applesmc_show_fan_speed(dev, buf, FAN_MIN_SPEED, offset); \
> +} \
> +static ssize_t store_fan_minimum_speed_##offset (struct device *dev, \
> +		struct device_attribute *attr, const char *buf, size_t count) \
> +{ \
> +	return applesmc_store_fan_speed(dev, buf, count, FAN_MIN_SPEED, offset); \
> +} \
> +static DEVICE_ATTR(fan##offset##_minimum_speed, S_IRUGO | S_IWUSR, \
> +	show_fan_minimum_speed_##offset, store_fan_minimum_speed_##offset); \
> +\
> +static ssize_t show_fan_maximum_speed_##offset (struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +{ \
> +	return applesmc_show_fan_speed(dev, buf, FAN_MAX_SPEED, offset); \
> +} \
> +static DEVICE_ATTR(fan##offset##_maximum_speed, S_IRUGO, \
> +				show_fan_maximum_speed_##offset, NULL); \
> +\
> +static ssize_t show_fan_safe_speed_##offset (struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +{ \
> +	return applesmc_show_fan_speed(dev, buf, FAN_SAFE_SPEED, offset); \
> +} \
> +static DEVICE_ATTR(fan##offset##_safe_speed, S_IRUGO, \
> +					show_fan_safe_speed_##offset, NULL); \
> +\
> +static ssize_t show_fan_target_speed_##offset (struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +{ \
> +	return applesmc_show_fan_speed(dev, buf, FAN_TARGET_SPEED, offset); \
> +} \
> +static ssize_t store_fan_target_speed_##offset (struct device *dev, \
> +		struct device_attribute *attr, const char *buf, size_t count) \
> +{ \
> +	return applesmc_store_fan_speed(dev, buf, count, FAN_TARGET_SPEED, offset); \
> +} \
> +static DEVICE_ATTR(fan##offset##_target_speed, S_IRUGO | S_IWUSR, \
> +	show_fan_target_speed_##offset, store_fan_target_speed_##offset); \
> +static ssize_t show_fan_manual_##offset (struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +{ \
> +	return applesmc_show_fan_manual(dev, buf, offset); \
> +} \
> +static ssize_t store_fan_manual_##offset (struct device *dev, \
> +		struct device_attribute *attr, const char *buf, size_t count) \
> +{ \
> +	return applesmc_store_fan_manual(dev, buf, count, offset); \
> +} \
> +static DEVICE_ATTR(fan##offset##_manual, S_IRUGO | S_IWUSR, \
> +		   show_fan_manual_##offset, store_fan_manual_##offset);

erk.  Can we use attribute groups here?

> +/*
> + * Create the needed functions for each fan using the macro defined above 
> + * (2 fans are supported)
> + */
> +sysfs_fan_speeds_offset(0);
> +sysfs_fan_speeds_offset(1);
> +
> +/* Macro creating the sysfs entries for a fan */
> +#define device_create_file_fan(ret, client, offset) \
> +do { \
> +ret = sysfs_create_file(client, &dev_attr_fan##offset##_actual_speed.attr); \
> +if (ret) break; \
> +ret = sysfs_create_file(client, &dev_attr_fan##offset##_minimum_speed.attr); \
> +if (ret) break; \
> +ret = sysfs_create_file(client, &dev_attr_fan##offset##_maximum_speed.attr); \
> +if (ret) break; \
> +ret = sysfs_create_file(client, &dev_attr_fan##offset##_safe_speed.attr); \
> +if (ret) break; \
> +ret = sysfs_create_file(client, &dev_attr_fan##offset##_target_speed.attr); \
> +if (ret) break; \
> +ret = sysfs_create_file(client, &dev_attr_fan##offset##_manual.attr); \
> +} while (0)

And here?

>
> ...
>
> +/* 
> + * applesmc_dmi_match - found a match.  return one, short-circuiting the hunt.
> + */
> +static int applesmc_dmi_match(struct dmi_system_id *id)
> +{
> +	int i = 0;
> +	struct dmi_match_data* dmi_data =
> +					(struct dmi_match_data*)id->driver_data;

Unneeded and undesirable cast of void*.

> +	printk(KERN_INFO "applesmc: %s detected:\n", id->ident);
> +	applesmc_accelerometer = dmi_data->accelerometer;
> +	printk(KERN_INFO "applesmc:  - Model %s accelerometer\n",
> +				applesmc_accelerometer ? "with" : "without");
> +	applesmc_light = dmi_data->light;
> +	printk(KERN_INFO "applesmc:  - Model %s light sensors and backlight\n",
> +					applesmc_light ? "with" : "without");
> +
> +	applesmc_temperature_set =  dmi_data->temperature_set;
> +	while (temperature_sensors_sets[applesmc_temperature_set][i] != NULL)
> +		i++;
> +	printk(KERN_INFO "applesmc:  - Model with %d temperature sensors\n", i);
> +	return 1;
> +}
> +
> +/* Create accelerometer ressources */
> +static int applesmc_create_accelerometer(void) {

Opening brace goes in column 1

> +	int ret;
> +
> +	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_position.attr);
> +	if (ret)
> +		goto out;
> +
> +	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_calibrate.attr);
> +	if (ret)
> +		goto out;
> +
> +	applesmc_idev = input_allocate_device();
> +	if (!applesmc_idev) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* initial calibrate for the input device */
> +	applesmc_calibrate();
> +
> +	/* initialize the input class */
> +	applesmc_idev->name = "applesmc";
> +	applesmc_idev->cdev.dev = &pdev->dev;
> +	applesmc_idev->evbit[0] = BIT(EV_ABS);
> +	input_set_abs_params(applesmc_idev, ABS_X,
> +			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
> +	input_set_abs_params(applesmc_idev, ABS_Y,
> +			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
> +
> +	input_register_device(applesmc_idev);
> +
> +	/* start up our timer for the input device */
> +	init_timer(&applesmc_timer);
> +	applesmc_timer.function = applesmc_mousedev_poll;
> +	applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
> +	add_timer(&applesmc_timer);
> +
> +	return 0;
> +
> +out:
> +	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
> +	return ret;
> +}
> +
> +/* Release all ressources used by the accelerometer */
> +static void applesmc_release_accelerometer(void) {
> +	del_timer_sync(&applesmc_timer);
> +	input_unregister_device(applesmc_idev);
> +}

Opening brace in column 1

> +static int __init applesmc_init(void)
> +{
> +	int ret;
> +	int count;
> +
> +	struct dmi_match_data applesmc_dmi_data[] = {
> +	/* MacBook Pro: accelerometer, backlight and temperature set 0 */
> +	  { .accelerometer = 1, .light = 1, .temperature_set = 0 },
> +	/* MacBook: accelerometer and temperature set 0 */
> +	  { .accelerometer = 1, .light = 0, .temperature_set = 0 },
> +	/* MacBook: temperature set 1 */
> +	  { .accelerometer = 0, .light = 0, .temperature_set = 1 }
> +	};
> +
> +	/* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
> +	 * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
> +	struct dmi_system_id applesmc_whitelist[] = {
> +		{ applesmc_dmi_match, "Apple MacBook Pro", {
> +		  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> +		  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
> +			(void*)&applesmc_dmi_data[0]},
> +		{ applesmc_dmi_match, "Apple MacBook", {
> +		  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> +		  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
> +			(void*)&applesmc_dmi_data[1]},
> +		{ applesmc_dmi_match, "Apple Macmini", {
> +		  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> +		  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
> +			(void*)&applesmc_dmi_data[2]},
> +		{ .ident = NULL }
> +	};

The compiler will need to build the above arrays on the stack at runtime. 
Is it possible to make these static so they are build at compile-time?  And
to then make them __initdata so they get discarded?

> +	if (!dmi_check_system(applesmc_whitelist)) {
> +		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	if (!request_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS,
> +								"applesmc")) {
> +		ret = -ENXIO;
> +		goto out;
> +	}
> +
> +	ret = platform_driver_register(&applesmc_driver);
> +	if (ret)
> +		goto out_region;
> +
> +	pdev = platform_device_register_simple("applesmc", -1, NULL, 0);
> +	if (IS_ERR(pdev)) {
> +		ret = PTR_ERR(pdev);
> +		goto out_driver;
> +	}
> +

