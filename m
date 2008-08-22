Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYHVGZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYHVGZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYHVGZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:25:08 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37444 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYHVGZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FDHkD2Xbv02p1g/6kYabmCY9geqKWKpj6hFATyVr9xVZkE5ucD7eJ4BzkJBnCXnmts
         2Uyw4ihc9WeFHR8MK0PHTLJguo899n+P8Pte3Sm7OXF1Mc8rzzQJBgHb+nmln+2Xu0sr
         V50/zYRlHN1DakH3M69Wdy9/v5teeA0PENZE0=
Message-ID: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
Date: Fri, 22 Aug 2008 14:25:01 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fundamental Design Flaw of the Device Driver Model?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fundamental Design Flaw of the Device Driver Model?
===================================================

Sorry for the misleading subject, its purpose is to draw your attention :-)
The ideas below are preliminary and I hope I'm not making serious mistakes
here.

This question has actually been around in my mind for several months, when
I started to work on some devices with multiple functions. Specifically, a
Power Management IC (PMIC in short in the following text) usually includes
LEDs support (charging, indication...) audio, touch screen, power monitoring,
LDOs, DC-DC bucks, and possibly some others.

The initial two ideas came into my mind were:

   1. separate the functions into multiple devices, write a driver for each
      of these devices

   2. a big all-in-one driver

Pros and Cons

   Solution (1) is obviously more attractive: better modularization and
   structure, work can be incrementally done, individual patches can go
   through each subsystem's git tree, reviewed by dedicated people, and
   so on.

   One thing I'm not so happy with solution (1) is: you have to create
   intermediate devices in order that the dedicated sub-device drivers
   to match up. E.g.

   ==== pmic.c =============================================================

   ...

   pmic_add_subdevs(void)
   {
   	for all sub-devices on this pmic:
		pdev = platform_device_alloc(sub-device-name, sub-device-id)
		platform_device_add(pdev);
		...
   }

   pmic_probe(struct i2c_client *client)
   {
   	...

	pmic_add_subdevs();

	...
   }

   struct i2c_driver pmic_driver = {
	.probe	= pmic_probe,

	...
   }

   ==== pmic.c =============================================================

   ==== pmic-subdev.c ======================================================

   static int sub_device_driver_probe(struct platform_device *sub_device)
   {
   	... ...
   }

   static struct platform_driver pmic_subdev_driver = {
   	.name	= sub-device-name,
	.probe	= sub_device_driver_probe,
	... ...
   }
   ==== pmic-subdev.c ======================================================
   This, however, creates many questions you have to face with:

   1. on what bus shall these sub-devices be?
      ** this is the reason I choose to use "platform_device", at least they
      can reside on the platform_bus_type, thus platform_driver can be used
      for this sub-device

   2. these devices are actually useless except for linking the sub-device
      to it's sub-device driver and of course, wasting memory. Normally in
      the driver, another dedicated device will be created. E.g. let's take
      a typical simple LED driver as an example:

static int __devinit xxxx_led_probe(struct BUS_device *dev)
{
	struct led_classdev led;

	/* initialize led */
	...

	led_classdev_register(dev, &led);

	...
}

static struct BUS_driver xxxx_led_driver = {
	.probe	= xxxx_led_probe,
	...
};

While led_classdev_register() is implemented something like:

int led_classdev_register(struct device *parent, struct led_classdev *led)
{
	1. allocate led device
	2. initialize led device
	3. assign "struct class leds_class"
	4. add device specific attributes
	5. add device to a global list (LED subsystem specific)

	return OK or ERR
}

      As you notice, a new LED device is created. If there are multiple
      LEDs on the chip, (yes, we have a PMIC with 5 LEDs on-chip, each
      differs only at the offset of its controlling register), then you
      probably will have to create 5 LED devices here, and manage them
      in a whole. In recent terminology of the device-model, such device
      is called a virtual device, it has no bus, no driver ..., it's used
      so that class, attributes can attach.

      Hence, here comes the 3rd and 4th questions:

   3. Who should be the correct parent of these LED devices, the intermediate
      sub-device we created just now? Or the pmic device on the I2C bus?
      My answer is the the latter, obviously. However, writing code like:

      led_classdev_register(pdev->dev.parent, &led_cdev)

      is apparantly funny and misleading.

   4. An intermediate device with no bus, no driver, no many other things
      is really not something deserving a "struct device", that's a waste
      of memory.

I'd really like to blame the device model that prevent me from writing a
perfect driver for such multi-function devices, otherwise I'd like to
blame the semiconductor manufacturers to come up with such devices making
us write ugly drivers. But I couldn't:

   1. the PMIC design is nature, if I were the PMIC designer, with so many
      analog circuitry already built-in, I would also add ADC, Touch, Audio
      PWM, and many others to make them squeeze into the tiny chip. (No,
      not including using I2C bus, which I'd prefer to avoid)

   2. There's no fundamental flaw in the device model (sorry for the title),
      of course, after weeks of reviewing the underlying code.

So probably, we are writing drivers in an incorrect way, that we have
ignored for the following reasons:

   1. Most Linux developers are working on the PC world, which usually don't
      have to care about the multi-function devices, one PCI card, one PCI
      device, and one PCI device one function, we have a PCI driver to handle
      that, in that PCI driver, implement the function we need, that's all.

   2. Even if there are multiple sub-devices, they are probably of the same
      functionality, and creating an array is easy, managing them in a whole
      in the driver is really not a big deal.

   3. We don't strictly distinguish between a physical device and a virtual
      device, a physical device driver and a virtual device driver. E.g. a
      virtual device could be a "net_device", "mtd_device", "led_classdev",
      and many others

A normal device layout would be:

                                        device specific
					virtual bus type
					       |
         platform_bus_type      i2c_bus_type   |  virtual devices
                 |                   |         |        |
     (device)    V                   V         V        V
   Platform BUS ---> I2C Controller ---> PMIC -+-> LED device (1)
                                               |
					       +-> LED device (2)
					       |
					       +-> LED device (3)
					       |
					       +-> DC-DC Buck1
					       |
					       +-> DC-DC Buck2
					       |
					       +-> LDO1
					       |
					       +-> LDO2
					       |
					       +-> Backlight PWM1
					       |
					       +-> Backlight PWM2
					       |
					      ...

the startup sequence would be:

   1. bus controller being initialized

   2. each bus_device on this bus controller is identified

   3. registration of these bus_device[] triggers the match of the
      bus_driver[] on this bus type

   4. the bus_driver for this device creates all the virtual devices
      found, (device can be registered to a virtual bus type)

   5. virtual device driver matches the virtual device and implement
      the function of this virtual device

Now it can be seen that:

   1. virtual devices are no different than physical devices, instead
      of being registered on a physical bus, they can be registered
      on a device specific virtual bus, or a function specific bus.
      (Let's say a net-bus, led-bus, mtd-bus, probably within
       /sys/devices/virtual/net/, /sys/devices/virtual/mtd, and so on)

      Or even on a global somewhat virtual_bus, which will probably
      increase the iteration match time.

   2. no intermediate device required for the device/driver match-up,
      the parent of the virtual device is the physical device, and
      this sounds reasonable

   3. one virtual driver for many virtual devices of the same type,
      driver doesn't have to managing them by array or link-list.

   4. everything else still works

The only inconvenience would be for those physical device with only
_one_ virtual device, that by using a virtual device the driver, it
(we really want just a single driver for the physical device and the
virtual device) will possibly look like:

   static int virtual_driver_probe ( struct device *virtual_device )
   {
   	...
   }

   static virtual_device_driver {
   	.probe = virtual_driver_probe,
	...
   }

   static int physical_driver_probe ( struct device *physical_device )
   {
   	...

	add_one_virtual_device(physical_device_as_parent);

	...
	return 0;
   }

   static physical_device_driver {
   	.probe = physical_driver_probe,
	...
   }

   module_init:
       physical_driver_register (&physical_device_driver);
       virtual_driver_register  (&virtual_device_driver);

This doesn't look nice, a generic virtual device driver is needed here.
If we define the network device as something like:

    struct net_device {
	struct device dev;

	struct net_device_ops *ops;
	...
    }

    static int generic_net_probe(struct device *dev)
    {
    	struct net_device *net_dev = to_net_device(dev);

	net_dev->ops->init();

	add_to_net_device_list(net_dev);
	
	register_to_network_layer(net_dev);

	...
    }

    struct device_driver generic_net_device_driver = {
        .name	= "generic_virtual_net_device_driver",
	.probe	= generic_net_probe,
	....
    }

Then probably, each physical network device driver will be written like:

   static int physical_driver_probe ( struct device *physical_device )
   {
	/* net_dev as the virtual device of this physical one */
   	struct net_device *net_dev;	
   	...

	net_dev->ops = xxxx;
	add_one_virtual_device(physical_device_as_parent);

	...
	return 0;
   }

   static physical_device_driver {
   	.probe = physical_driver_probe,
	...
   }

   module_init:
       physical_driver_register (&physical_device_driver);
       virtual_driver_register  (&virtual_device_driver);

This is same as what we are doing now, the difference is that: instead of
calling register_netdev() by the physical driver itself, it's now creating
a virtual device and using the device-driver bus model for the generic
virtual network driver to match. As said, on such 1 physical device + 1
virtual device case, the benefit isn't significant. (that's why our driver
is written like it is today)

Finally comes an example of how LED device driver shall be implemented with
the above concept change, this is illustration _only_, no guarantee to work.

==== board.c ==============================================================

... ...

static struct gpio_led_platform_data board_leds[] = {
        [0] = {
                .name                   = "gpio-led",
		.gpio			= 10,
		.active_low		= 1,
        },
        [1] = {
                .name                   = "gpio-led",
		.gpio			= 11,
		.active_low		= 1,
        },
};

static void __init board_init_leds(void)
{
        gpio_led_add(gpio_dev, 0, &board_debug_leds[0]);
        gpio_led_add(gpio_dev, 1, &board_debug_leds[1]);
}

... ...

==== board.c ==============================================================

==== include/linux/leds/led.h =============================================

#ifndef __LED_H
#define __LED_H

#include <linux/device.h>

enum {
	LED_OFF		= 0,
	LED_HALF	= 127,
	LED_FULL	= 255,
};

struct led_device;

struct led_device_ops {
	void	(*set_brightness)(struct led_device *, int brightness);
	int	(*get_brightness)(struct led_device *);
};

struct led_device {
	struct device		dev;

	const char		*name;
	int 			id;
	int			brightness;
	struct led_device_ops	*ops;
};

#define to_led_device(dev)	container_of((dev), struct led_device, dev)

extern struct bus_type led_bus_type;
extern struct class led_class;

extern struct led_device *led_device_alloc(const char *name, int id);
extern int led_device_add(struct led_device *ldev);
extern int led_device_register(struct led_device *ldev);
extern void led_device_unregister(struct led_device *ldev);
#endif /* __LED_H */

==== include/linux/leds/led.h =============================================

==== drivers/leds/core.c ==================================================

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/leds/led.h>

static struct device led_bus_device = {
	.bus_id		= "leds",
};

static void led_device_release(struct device *dev)
{
	kfree(to_led_device(dev));
}

struct led_device *led_device_alloc(const char *name, int id)
{
	struct led_device *ldev;

	ldev = kzalloc(sizeof(struct led_device), GFP_KERNEL);
	if (ldev == NULL)
		return NULL;

	ldev->name = name;
	ldev->id = id;
	ldev->brightness = 0;
	device_initialize(&ldev->dev);
	ldev->dev.release = led_device_release;
	return ldev;
}
EXPORT_SYMBOL_GPL(led_device_alloc);

int led_device_add(struct led_device *ldev)
{
	if (!ldev)
		return -EINVAL;

	if (!ldev->dev.parent)
		ldev->dev.parent = &led_bus_device;

	ldev->dev.bus = &led_bus_type;
	ldev->dev.class = &led_class;

	if (ldev->id != -1)
		snprintf(ldev->dev.bus_id, BUS_ID_SIZE, "%s.%d",
				ldev->name, ldev->id);
	else
		strlcpy(ldev->dev.bus_id, ldev->name, BUS_ID_SIZE);

	pr_debug("Registering led device '%s'. Parent at %s\n",
			ldev->dev.bus_id, ldev->dev.parent->bus_id);

	return device_add(&ldev->dev);
}
EXPORT_SYMBOL_GPL(led_device_add);

int led_device_register(struct led_device *ldev)
{
	device_initialize(&ldev->dev);
	return led_device_add(ldev);
}
EXPORT_SYMBOL_GPL(led_device_register);

void led_device_unregister(struct led_device *ldev)
{
	if (ldev) {
		device_del(&ldev->dev);
		put_device(&ldev->dev);
	}
}
EXPORT_SYMBOL_GPL(led_device_unregister);

static void led_set_brightness(struct led_device *ldev, int brightness)
{
	if (ldev->ops && ldev->ops->set_brightness)
		ldev->ops->set_brightness(ldev, brightness);

	ldev->brightness = brightness;
}

static int led_get_brightness(struct led_device *ldev)
{
	if (ldev->ops && ldev->ops->get_brightness)
		return ldev->ops->get_brightness(ldev);

	return ldev->brightness;
}

static ssize_t led_brightness_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", led_get_brightness(to_led_device(dev)));
}

static ssize_t led_brightness_store(struct device *dev,
		struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_device *ldev = to_led_device(dev);
	int brightness = (int) simple_strtol(buf, NULL, 0);

	led_set_brightness(ldev, brightness);
	return count;
}

static struct device_attribute led_device_attrs[] = {
	__ATTR(brightness, 0644, led_brightness_show, led_brightness_store),
	__ATTR_NULL,
};

#ifdef CONFIG_PM
static int led_class_suspend(struct device *dev, pm_message_t state)
{
	struct led_device *ldev = to_led_device(dev);

	if (ldev->ops && ldev->ops->set_brightness)
		ldev->ops->set_brightness(ldev, 0);

	return 0;
}

static int led_class_resume(struct device *dev)
{
	struct led_device *ldev = to_led_device(dev);

	if (ldev->ops && ldev->ops->set_brightness)
		ldev->ops->set_brightness(ldev, ldev->brightness);

	return 0;
}
#else
#define led_class_suspend	NULL
#define led_class_resume	NULL
#endif /* CONFIG_PM */

struct class led_class = {
	.name		= "led-class",
	.owner		= THIS_MODULE,
	.dev_attrs	= led_device_attrs,
	.suspend	= led_class_suspend,
	.resume		= led_class_resume,
};
EXPORT_SYMBOL_GPL(led_class);

static int led_bus_match(struct device *dev, struct device_driver *drv)
{
	struct led_device *ldev = to_led_device(dev);

	return (strncmp(ldev->name, drv->name, BUS_ID_SIZE) == 0);
}

static int led_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
{
	struct led_device *ldev = to_led_device(dev);

	add_uevent_var(env, "MODALIAS=led:%s", ldev->name);
	return 0;
}

struct bus_type led_bus_type = {
	.name		= "led-bus",
	.match		= led_bus_match,
	.uevent		= led_bus_uevent,
};
EXPORT_SYMBOL_GPL(led_bus_type);

static int __init led_core_init(void)
{
	int err;

	err = device_register(&led_bus_device);
	if (err)
		return err;

	err = bus_register(&led_bus_type);
	if (err)
		return err;

	err = class_register(&led_class);
	if (err)
		return err;

	return 0;
}
subsys_initcall(led_core_init);

static void __exit led_core_exit(void)
{
	class_unregister(&led_class);
	bus_unregister(&led_bus_type);
	device_unregister(&led_bus_device);
}
module_exit(led_core_exit);

==== drivers/leds/core.c ==================================================

==== include/linux/leds/led-gpio.h ========================================

#ifndef __LED_GPIO_H
#define __LED_GPIO_H

#include <linux/leds/led.h>

struct gpio_led_platform_data {
	unsigned 	gpio;
	unsigned	active_low : 1;
};

extern struct led_device *gpio_led_add(struct device *parent, int id,
				struct gpio_led_platform_data *pdata);

extern void gpio_led_del(struct led_device *ldev);
#endif /* __LED_GPIO_H */

==== include/linux/leds/led-gpio.h ========================================

==== drivers/leds/led-gpio.c ==============================================

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/gpio.h>
#include <linux/leds/led.h>
#include <linux/leds/led-gpio.h>

struct led_device *gpio_led_add(struct device *parent, int id,
				struct gpio_led_platform_data *pdata)
{
	struct led_device *ldev;
	struct gpio_led_platform_data *p;
	int err;

	ldev = led_device_alloc("led-gpio", id);
	if (ldev == NULL)
		return NULL;

	p = kmalloc(sizeof(struct gpio_led_platform_data), GFP_KERNEL);
	if (p == NULL) {
		kfree(ldev);	
		return NULL;
	}
	memcpy(p, pdata, sizeof(*pdata));

	ldev->dev.platform_data = p;

	err = led_device_add(ldev);
	if (err) {
		kfree(p);
		put_device(&ldev->dev);
		return NULL;
	}
	return ldev;
}
EXPORT_SYMBOL_GPL(gpio_led_add);

void gpio_led_del(struct led_device *ldev)
{
	led_device_unregister(ldev);
}
EXPORT_SYMBOL_GPL(gpio_led_del);

struct gpio_led_data {
	unsigned	gpio;
	unsigned	active_low	: 1;
	unsigned	can_sleep	: 1;
	int		new_level;
	struct work_struct work;
};

static void gpio_led_work(struct work_struct *work)
{
	struct gpio_led_data *data;
	
	data = container_of(work, struct gpio_led_data, work);
	gpio_set_value_cansleep(data->gpio, data->new_level);
}

static void gpio_led_set_brightness(struct led_device *ldev, int brightness)
{
	struct gpio_led_data *data = dev_get_drvdata(&ldev->dev);
	int level;

	level = (brightness == LED_OFF) ? 0 : 1;
	
	if (data->active_low)
		level = !level;

	if (data->can_sleep) {
		data->new_level = level;
		schedule_work(&data->work);
	} else
		gpio_set_value(data->gpio, level);
}

static struct led_device_ops gpio_led_ops = {
	.set_brightness	= gpio_led_set_brightness,
};

static int __devinit gpio_led_probe(struct device *dev)
{
	struct gpio_led_platform_data *pdata = dev->platform_data;
	struct led_device *ldev = to_led_device(dev);
	struct gpio_led_data *data;
	int err;

	ldev->ops = &gpio_led_ops;

	err = gpio_request(pdata->gpio, dev->bus_id);
	if (err) {
		dev_err(dev, "failed to request GPIO%d\n", pdata->gpio);
		return -EBUSY;
	}

	data = kzalloc(sizeof(struct gpio_led_data), GFP_KERNEL);
	if (data == NULL) {
		dev_err(dev, "failed to allocate memory\n");
		return -ENOMEM;
	}

	data->gpio = pdata->gpio;
	data->active_low = pdata->active_low;
	data->can_sleep = gpio_cansleep(data->gpio);
	data->new_level = 0;
	INIT_WORK(&data->work, gpio_led_work);

	dev_set_drvdata(dev, data);
	return 0;
}

static int __devexit gpio_led_remove(struct device *dev)
{
	struct gpio_led_data *data = dev_get_drvdata(dev);

	kfree(data);
	return 0;
}

static struct device_driver gpio_led_driver = {
	.name		= "led",
	.bus		= &led_bus_type,
	.owner		= THIS_MODULE,
	.probe		= gpio_led_probe,
	.remove		= __devexit_p(gpio_led_remove),
};

static int __init gpio_led_init(void)
{
	return driver_register(&gpio_led_driver);
}
module_init(gpio_led_init);

static void __exit gpio_led_exit(void)
{
	driver_unregister(&gpio_led_driver);
}
module_exit(gpio_led_exit);

==== drivers/leds/led-gpio.c ==============================================

Cheers
- eric
