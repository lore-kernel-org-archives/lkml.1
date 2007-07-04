Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbXGDWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbXGDWLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXGDWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:11:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59512 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755453AbXGDWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:11:38 -0400
Date: Thu, 5 Jul 2007 00:11:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
Subject: Re: blink driver power saving
Message-ID: <20070704221122.GA1719@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz> <200707030142.36252.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030142.36252.dtor@insightbb.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Perhaps one of you geniuses who all hate it can find a better way to
> > > > > solve the "video output dead after kexec; but need visual feedback to the user
> > > > > while crash dumping" problem. I'm waiting for your patches.
> > > > >
> > > > 
> > > > I don't don't like it ;) Unfortunately too many people end up enabling
> > > 
> > > Yes that's pretty weird. I admit I hadn't expected
> > > that problem. blink is equivalent to "annoy me" and it
> > > is a mystery why so many people should willingly ask their computer to 
> > > annoy them.
> > 
> > tristate "Keyboard blink driver"
> > 
> > ...drivers are not expected to act on their own. I was expecting to
> > get nice /sys/class/led* interface to my keyboard leds.
> > 
> > BTW ... I still believe we should have /sys/class/led* interface to
> > those leds. I'd like to make them blink with hdd activity on some
> > machines... of course, that needs non-buggy KBC.
> 
> I'll take patches. Ofcourse we'll have to keep the current EV_LED interface
> for compatibility.

Here's a working version. For some reason, it only works with capslock
led. (But so does your code, is that thinkpad problem?)

Andi, by making default trigger "heartbeat", you can get very nice
visual feedback :-).

Signed-off-by: Pavel Machek <pavel@suse.cz>

/*
 * LED <-> input subsystem glue
 *
 * Copyright 2007 Pavel Machek <pavel@suse.cz>
 * Copyright 2007 Dmitry Torokhov
 * Copyright 2005-2006 Openedhand Ltd.
 *
 * Author: Pavel Machek <pavel@suse.cz>
 * Based on code by: Richard Purdie <rpurdie@openedhand.com>
 * 		     
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/platform_device.h>
#include <linux/leds.h>

#include <linux/module.h>
#include <linux/input.h>
#include <linux/slab.h>
#include <linux/workqueue.h>
#include <linux/init.h>

struct blinker {
	struct delayed_work work;
	struct input_handle handle;
	int state;
};

struct blinker *blinker;

static void inputled_set(struct led_classdev *led_cdev, enum led_brightness value)
{
	blinker->state = value;
	schedule_delayed_work(&blinker->work, 0);
}

static struct led_classdev input_led = {
	.name			= "input",
	.default_trigger	= "none",
	.brightness_set		= inputled_set,
};

static void blink_task_handler(struct work_struct *work)
{
	struct blinker *blinker = container_of(work, struct blinker, work.work);
	input_inject_event(&blinker->handle, EV_LED, LED_CAPSL, !!blinker->state);
}

static void blink_event(struct input_handle *handle, unsigned int type,
		        unsigned int code, int down)
{
	/*
	 * This is a very rare handler that does not process any input
	 * events; just injects them.
	 */
}

static int blink_connect(struct input_handler *handler, struct input_dev *dev,
			  const struct input_device_id *id)
{
	struct input_handle *handle;
	int error;

	blinker = kzalloc(sizeof(struct blinker), GFP_KERNEL);
	if (!blinker)
		return -ENOMEM;

	INIT_DELAYED_WORK(&blinker->work, blink_task_handler);

	handle = &blinker->handle;
	handle->dev = dev;
	handle->handler = handler;
	handle->name = "blink";
	handle->private = blinker;

	error = input_register_handle(handle);
	if (error)
		goto err_free_handle;

	error = input_open_device(handle);
	if (error)
		goto err_unregister_handle;

	error = led_classdev_register(NULL, &input_led);
	if (error < 0)
		goto err_input_close_device;

	return 0;

 err_input_close_device:
	input_close_device(handle);
 err_unregister_handle:
	input_unregister_handle(handle);
 err_free_handle:
	kfree(handle);
	return error;
}

static void blink_disconnect(struct input_handle *handle)
{
	struct blinker *blinker = handle->private;

	led_classdev_unregister(&input_led);
	cancel_rearming_delayed_work(&blinker->work);
	input_close_device(handle);
	input_unregister_handle(handle);
	kfree(blinker);
}

static const struct input_device_id blink_ids[] = {
	{
		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_LEDBIT,
		.evbit = { BIT(EV_LED) },
		.ledbit = { [LONG(LED_CAPSL)] = BIT(LED_CAPSL) },
	},
	{ }
};

static struct input_handler blink_handler = {
	.event		= blink_event,
	.connect	= blink_connect,
	.disconnect	= blink_disconnect,
	.name		= "blink",
	.id_table	= blink_ids,
};

static int __init blink_handler_init(void)
{
	return input_register_handler(&blink_handler);
}

static void __exit blink_handler_exit(void)
{
	input_unregister_handler(&blink_handler);
	flush_scheduled_work();
}

module_init(blink_handler_init);
module_exit(blink_handler_exit);




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
