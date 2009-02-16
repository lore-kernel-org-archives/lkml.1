Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZBPN3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZBPN3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZBPN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:29:34 -0500
Received: from smtp.nokia.com ([192.100.122.230]:41868 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbZBPN3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:29:33 -0500
Date: Mon, 16 Feb 2009 15:14:26 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <me@felipebalbi.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: triggers: introduce gpio led trigger
Message-ID: <20090216131426.GU21181@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1234786651-4433-1-git-send-email-felipe.balbi@nokia.com> <20090216125746.GR21181@scadufax.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216125746.GR21181@scadufax.research.nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 16 Feb 2009 13:29:10.0068 (UTC) FILETIME=[8CC03740:01C9903A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:57:46PM +0100, Balbi Felipe (Nokia-D/Helsinki) wrote:
> On Mon, Feb 16, 2009 at 01:17:31PM +0100, Balbi Felipe (Nokia-D/Helsinki) wrote:
> > From: Felipe Balbi <me@felipebalbi.com>
> >
> > The gpio led trigger will allow leds to be triggered by
> > gpio events.
> >
> > There's a timer function that keeps checking the gpio
> > value in order to know when we need to turn leds on/off.
> >
> > It's useful for usecases as n810's keypad leds that could
> > be triggered by the gpio event generated when user slides
> > up to show the keypad.
> >
> > We also provide means for userland to tell us what is the
> > desired brightness for that special led when it goes on
> > so userland could use information from ambient light sensors
> > and not set led brightness too high if it's not necessary.
> >
> > This trigger was tested with n810.
> >
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> > ---
> >  drivers/leds/Kconfig        |   13 +++
> >  drivers/leds/Makefile       |    1 +
> >  drivers/leds/ledtrig-gpio.c |  229 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 243 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/leds/ledtrig-gpio.c
> >
> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > index 7427136..2bd77d5 100644
> > --- a/drivers/leds/Kconfig
> > +++ b/drivers/leds/Kconfig
> > @@ -216,6 +216,19 @@ config LEDS_TRIGGER_BACKLIGHT
> >
> >           If unsure, say N.
> >
> > +config LEDS_TRIGGER_GPIO
> > +       tristate "LED GPIO Trigger"
> > +       depends on LEDS_TRIGGERS
> > +       depends on GPIOLIB
> > +       help
> > +         This allows LEDs to be controlled by gpio events. It's good
> > +         when using gpios as switches and triggering the needed LEDs
> > +         from there. One use case is n810's keypad LEDs that could
> > +         be triggered by this trigger when user slides up to show
> > +         keypad.
> > +
> > +         If unsure, say N.
> > +
> >  config LEDS_TRIGGER_DEFAULT_ON
> >         tristate "LED Default ON Trigger"
> >         depends on LEDS_TRIGGERS
> > diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> > index 9d76f0f..c9e5d31 100644
> > --- a/drivers/leds/Makefile
> > +++ b/drivers/leds/Makefile
> > @@ -30,4 +30,5 @@ obj-$(CONFIG_LEDS_TRIGGER_TIMER)      += ledtrig-timer.o
> >  obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)    += ledtrig-ide-disk.o
> >  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)   += ledtrig-heartbeat.o
> >  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)   += ledtrig-backlight.o
> > +obj-$(CONFIG_LEDS_TRIGGER_GPIO)                += ledtrig-gpio.o
> >  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)  += ledtrig-default-on.o
> > diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
> > new file mode 100644
> > index 0000000..af24dcf
> > --- /dev/null
> > +++ b/drivers/leds/ledtrig-gpio.c
> > @@ -0,0 +1,229 @@
> > +/*
> > + * ledtrig-gio.c - LED Trigger Based on GPIO events
> > + *
> > + * Copyright 2009 Felipe Balbi <me@felipebalbi.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/gpio.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/leds.h>
> > +#include "leds.h"
> > +
> > +struct gpio_trig_data {
> > +       struct delayed_work work;
> > +       struct led_classdev *led;
> > +
> > +       unsigned desired_brightness;    /* desired brightness when led is on */
> > +       unsigned inverted;              /* true when gpio is inverted */
> > +       unsigned gpio;                  /* gpio that triggers the leds */
> > +};
> > +
> > +static ssize_t gpio_trig_brightness_show(struct device *dev,
> > +               struct device_attribute *attr, char *buf)
> > +{
> > +       struct led_classdev *led = dev_get_drvdata(dev);
> > +       struct gpio_trig_data *gpio_data = led->trigger_data;
> > +
> > +       return sprintf(buf, "%u\n", gpio_data->desired_brightness);
> > +}
> > +
> > +static ssize_t gpio_trig_brightness_store(struct device *dev,
> > +               struct device_attribute *attr, const char *buf, size_t n)
> > +{
> > +       struct led_classdev *led = dev_get_drvdata(dev);
> > +       struct gpio_trig_data *gpio_data = led->trigger_data;
> > +       unsigned desired_brightness;
> > +       int ret;
> > +
> > +       ret = sscanf(buf, "%u", &desired_brightness);
> > +       if (ret < 1 || desired_brightness > 255) {
> > +               dev_err(dev, "invalid value\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       gpio_data->desired_brightness = desired_brightness;
> > +
> > +       return n;
> > +}
> > +static DEVICE_ATTR(desired_brightness, 0644, gpio_trig_brightness_show,
> > +               gpio_trig_brightness_store);
> > +
> > +static ssize_t gpio_trig_inverted_show(struct device *dev,
> > +               struct device_attribute *attr, char *buf)
> > +{
> > +       struct led_classdev *led = dev_get_drvdata(dev);
> > +       struct gpio_trig_data *gpio_data = led->trigger_data;
> > +
> > +       return sprintf(buf, "%s\n", gpio_data->inverted ? "yes" : "no");
> > +}
> > +
> > +static ssize_t gpio_trig_inverted_store(struct device *dev,
> > +               struct device_attribute *attr, const char *buf, size_t n)
> > +{
> > +       struct led_classdev *led = dev_get_drvdata(dev);
> > +       struct gpio_trig_data *gpio_data = led->trigger_data;
> > +       unsigned inverted;
> > +       int ret;
> > +
> > +       ret = sscanf(buf, "%u", &inverted);
> > +       if (ret < 1) {
> > +               dev_err(dev, "invalid value\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       gpio_data->inverted = !!inverted;
> > +
> > +       return n;
> > +}
> > +static DEVICE_ATTR(inverted, 0644, gpio_trig_inverted_show,
> > +               gpio_trig_inverted_store);
> > +
> > +static ssize_t gpio_trig_gpio_show(struct device *dev,
> > +               struct device_attribute *attr, char *buf)
> > +{
> > +       struct led_classdev *led = dev_get_drvdata(dev);
> > +       struct gpio_trig_data *gpio_data = led->trigger_data;
> > +
> > +       return sprintf(buf, "%u\n", gpio_data->gpio);
> > +}
> > +
> > +static ssize_t gpio_trig_gpio_store(struct device *dev,
> > +               struct device_attribute *attr, const char *buf, size_t n)
> > +{
> > +       struct led_classdev *led = dev_get_drvdata(dev);
> > +       struct gpio_trig_data *gpio_data = led->trigger_data;
> > +       unsigned gpio;
> > +       int ret;
> > +
> > +       ret = sscanf(buf, "%u", &gpio);
> > +       if (ret < 1) {
> > +               dev_err(dev, "couldn't read gpio number\n");
> > +               cancel_delayed_work(&gpio_data->work);
> > +               return -EINVAL;
> > +       }
> > +
> > +       gpio_data->gpio = gpio;
> > +       schedule_delayed_work(&gpio_data->work, msecs_to_jiffies(50));
> > +
> > +       return n;
> > +}
> > +static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
> > +
> > +static void gpio_trig_work(struct work_struct *work)
> > +{
> > +       struct gpio_trig_data *gpio_data = container_of(work,
> > +                       struct gpio_trig_data, work.work);
> > +
> > +       if (!gpio_data->gpio)
> > +               goto out;
> > +
> > +       if (!gpio_data->inverted) {
> > +               if (gpio_get_value(gpio_data->gpio)) {
> > +                       if (gpio_data->desired_brightness)
> > +                               led_set_brightness(gpio_data->led,
> > +                                               gpio_data->desired_brightness);
> > +                       else
> > +                               led_set_brightness(gpio_data->led, LED_FULL);
> > +               } else {
> > +                       led_set_brightness(gpio_data->led, LED_OFF);
> > +               }
> > +       } else {
> > +               if (!gpio_get_value(gpio_data->gpio)) {
> > +                       if (gpio_data->desired_brightness)
> > +                               led_set_brightness(gpio_data->led,
> > +                                               gpio_data->desired_brightness);
> > +                       else
> > +                               led_set_brightness(gpio_data->led, LED_FULL);
> > +               } else {
> > +                       led_set_brightness(gpio_data->led, LED_OFF);
> > +               }
> > +       }

This can be simplified. Hopefully that'll be the last iteration on this
patch. Sorry for that. These ideas came later from colleagues. Here's
the update patch:

diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index af24dcf..775a1a7 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -125,26 +125,14 @@ static void gpio_trig_work(struct work_struct *work)
        if (!gpio_data->gpio)
                goto out;
 
-       if (!gpio_data->inverted) {
-               if (gpio_get_value(gpio_data->gpio)) {
-                       if (gpio_data->desired_brightness)
-                               led_set_brightness(gpio_data->led,
-                                               gpio_data->desired_brightness);
-                       else
-                               led_set_brightness(gpio_data->led, LED_FULL);
-               } else {
-                       led_set_brightness(gpio_data->led, LED_OFF);
-               }
+       if (gpio_get_value(gpio_data->gpio) ^ gpio_data->inverted) {
+               if (gpio_data->desired_brightness)
+                       led_set_brightness(gpio_data->led,
+                                       gpio_data->desired_brightness);
+               else
+                       led_set_brightness(gpio_data->led, LED_FULL);
        } else {
-               if (!gpio_get_value(gpio_data->gpio)) {
-                       if (gpio_data->desired_brightness)
-                               led_set_brightness(gpio_data->led,
-                                               gpio_data->desired_brightness);
-                       else
-                               led_set_brightness(gpio_data->led, LED_FULL);
-               } else {
-                       led_set_brightness(gpio_data->led, LED_OFF);
-               }
+               led_set_brightness(gpio_data->led, LED_OFF);
        }
 
 out:
@@ -202,6 +190,7 @@ static void gpio_trig_deactivate(struct led_classdev *led)
                device_remove_file(led->dev, &dev_attr_inverted);
                device_remove_file(led->dev, &dev_attr_desired_brightness);
                cancel_delayed_work(&gpio_data->work);
+               flush_scheduled_work();
                kfree(gpio_data);
        }
 }


-- 
balbi
