Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYKDHwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYKDHwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYKDHv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:51:58 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4942 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYKDHv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:51:57 -0500
Message-ID: <490FFF1B.6050300@shikadi.net>
Date: Tue, 04 Nov 2008 17:51:55 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: led and hid class - hid_device vs led_classdev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm writing a driver for a USB HID device (using the new hid class), but 
I'm a bit confused about how the hid_device structure relates to the 
other driver-information structures.

One of the functions the device implements is a LED.  This is pretty 
simple to control (basic on/off), so I'd like to implement a device in 
the "led" class that controls this led.

In my hid driver's probe function I'm given a struct hid_device* which 
is used with functions like hid_hw_start().

I then need to call led_classdev_register() to register my led device. 
At the moment I pass this function hid_device.dev

Then I set my custom driver data with hid_set_drvdata().

Later on, when the user wants to switch the LED on or off, a function in 
my driver gets called, with a struct led_classdev* parameter.

I'm stuck trying to figure out how to convert this led_classdev 
parameter back into a hid_device, so that I can extract the custom data 
I set with hid_set_drvdata().

Some of the led drivers use platform_set_drvdata() in their probe 
functions to get their custom data instead, but I'm afraid if I do this 
I'll overwrite any hid-related data that hid_set_drvdata() might tack on 
to my custom data.

Some pseudocode to help illustrate:

static int my_probe(struct hid_device *hid,
   const struct hid_device_id *id)
{
   hid_parse(hid);
   hid_hw_start(hid, HID_CONNECT_DEFAULT);

   led_classdev_register(&hid->dev, &my_led);

   hid_set_drvdata(hid, my_data);

   /* Don't want to use this, in case it overwrites something that
      hid_set_drvdata() includes. */
   /*platform_set_drvdata(&hid->dev, my_data);*/
}

/* Callback function when user wants to change LED state */
static void my_led_set(struct led_classdev *led_cdev,
   enum led_brightness value)
{
   /* How do I get my_data back? */
}

Hopefully this explains what I'm after - if you need me to clarify 
anything please let me know.

Many thanks,
Adam.
