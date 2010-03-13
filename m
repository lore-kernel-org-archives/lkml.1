Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811Ab0CMTkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:40:41 -0500
Received: from legolas.restena.lu ([158.64.1.34]:59995 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935670Ab0CMTkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:40:37 -0500
Date: Sat, 13 Mar 2010 20:39:53 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
Message-ID: <20100313203953.0f3436b3@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1002251615570.30967@pobox.suse.cz>
References: <20100221002001.0a7e05a7@neptune.home>
	<20100224170049.0d04af3c@neptune.home>
	<alpine.LNX.2.00.1002251201430.30967@pobox.suse.cz>
	<20100225123214.0523a310@neptune.home>
	<alpine.LNX.2.00.1002251615570.30967@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 February 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 25 Feb 2010, Bruno Prémont wrote:
> 
> > For the two sysfs attributes I currently use, the 'reset' one shall 
> > probably be moved to debugfs (I would like to place it under 
> > /sys/kernel/debug/hid/$device/ next to rdesc and events).
> 
> Yes, that would make sense.

Hm, that works only when driver module gets loaded when USBHID device
is already plugged in.
When driver is registered and has it's probe function called on hotplug
it runs right before hid-core registers the debugfs entries.
As such hid_device's debug_dir is still NULL.

To get around this, in hid_add_device(), hid_debug_register() would
have to be called before device_add() instead of right after.

Is something like below acceptable? (from error handling point of view
it makes no difference...)

Thanks,
Bruno

file: drivers/hid/hid-core.c

 int hid_add_device(struct hid_device *hdev)
 {
         static atomic_t id = ATOMIC_INIT(0);
         int ret;
 
         if (WARN_ON(hdev->status & HID_STAT_ADDED))
                 return -EBUSY;
 
         /* we need to kill them here, otherwise they will stay allocated to
          * wait for coming driver */
         if (hid_ignore(hdev))
                 return -ENODEV;
 
         /* XXX hack, any other cleaner solution after the driver core
          * is converted to allow more than 20 bytes as the device name? */
         dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
                      hdev->vendor, hdev->product, atomic_inc_return(&id));
 
+        hid_debug_register(hdev, dev_name(&hdev->dev));
         ret = device_add(&hdev->dev);
         if (!ret)
                 hdev->status |= HID_STAT_ADDED;
 
-        hid_debug_register(hdev, dev_name(&hdev->dev));
 
         return ret;
 }
 EXPORT_SYMBOL_GPL(hid_add_device);

