Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYHVLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYHVLRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYHVLRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:17:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:42780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYHVLRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:17:12 -0400
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
From: Liam Girdwood <lrg@kernel.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
In-Reply-To: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 12:17:02 +0100
Message-Id: <1219403822.10949.29.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 14:25 +0800, Eric Miao wrote:
> Fundamental Design Flaw of the Device Driver Model?
> ===================================================
> 
> Sorry for the misleading subject, its purpose is to draw your attention :-)
> The ideas below are preliminary and I hope I'm not making serious mistakes
> here.
> 
> This question has actually been around in my mind for several months, when
> I started to work on some devices with multiple functions. Specifically, a
> Power Management IC (PMIC in short in the following text) usually includes
> LEDs support (charging, indication...) audio, touch screen, power monitoring,
> LDOs, DC-DC bucks, and possibly some others.
> 
> The initial two ideas came into my mind were:
> 
>    1. separate the functions into multiple devices, write a driver for each
>       of these devices
> 

I've opted for this option with the WM8350 PMIC driver.


>    This, however, creates many questions you have to face with:
> 
>    1. on what bus shall these sub-devices be?
>       ** this is the reason I choose to use "platform_device", at least they
>       can reside on the platform_bus_type, thus platform_driver can be used
>       for this sub-device

My WM8350 clients are all platform_devices too.

> 
>    2. these devices are actually useless except for linking the sub-device
>       to it's sub-device driver and of course, wasting memory. Normally in
>       the driver, another dedicated device will be created. E.g. let's take
>       a typical simple LED driver as an example:
> 

They are not useless as most of my client devices _need_ some sort of
platform data to be passed on for their probe() e.g. my LED driver needs
to know it's brightness values, trigger etc. They also all need a PMIC
reference (passed in the platform_data) which they will need to call any
core PMIC functions e.g. chip read/write


> 
>    3. Who should be the correct parent of these LED devices, the intermediate
>       sub-device we created just now? Or the pmic device on the I2C bus?
>       My answer is the the latter, obviously. However, writing code like:
> 
>       led_classdev_register(pdev->dev.parent, &led_cdev)

Fwiw, I've made the WM8350 I2C driver the parent. The I2C driver also
contains the core PMIC services e.g. IRQs, GPIO's, IO, etc 


> A normal device layout would be:
> 
>                                         device specific
> 					virtual bus type
> 					       |
>          platform_bus_type      i2c_bus_type   |  virtual devices
>                  |                   |         |        |
>      (device)    V                   V         V        V
>    Platform BUS ---> I2C Controller ---> PMIC -+-> LED device (1)
>                                                |
> 					       +-> LED device (2)
> 					       |
> 					       +-> LED device (3)
> 					       |
> 					       +-> DC-DC Buck1
> 					       |
> 					       +-> DC-DC Buck2
> 					       |
> 					       +-> LDO1
> 					       |
> 					       +-> LDO2
> 					       |
> 					       +-> Backlight PWM1
> 					       |
> 					       +-> Backlight PWM2
> 					       |
> 					      ...
> 

Ok, I basically have :-

                                 Platform devices
                                     |        |
                                     V        V
Platform Bus --> I2C controller --> PMIC +-> LED1
                                         +-> LED2
                                         +-> Audio
                                         +-> DCDC1
                                         +-> Backlight

I originally had a PMIC bus (like above) but decided it was easier just
to use the existing kernel infrastructure. My I2C PMIC driver just
registers the client platform_devices when it probes.

Cheers

Liam

