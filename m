Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYGXJpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYGXJpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGXJo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:44:57 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:16065 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYGXJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:44:57 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <48884F04.4070403@tremplin-utc.net>
Date: Thu, 24 Jul 2008 11:44:36 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
References: <488763AD.4050400@gmail.com> <20080723174801.GC11009@khazad-dum.debian.net>
In-Reply-To: <20080723174801.GC11009@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh schreef:
> On Wed, 23 Jul 2008, Jonathan Cameron wrote:
>> The subsystem is now in a functional state with a small set of drivers:
>>
>> Max1363 (supports numerous Maxim i2c ADC's) (tested with max1363 and max1238 chips)
>>    - Uses a periodic timer to provide ring buffer mode.
>>    - All reads form these devices are scan modes so direct single element access
>>      is not provided.
>>    - Monitor mode on max1363 is not yet supported (need to do a bit debugging of
>>      the board I have so as to be able to test this).
>>
>> ST LIS3L02DQ - SPI accelerometer.
>>    - Uses a datardy interrupt to driver a software ring buffer.
>>    - Most functionality of this device is supported.
>>
>> VTI SCA3000 (tested with an e05)
>>    - Hardware ring buffer.
> 
> I'd like to see something done to have the common parts of interfaces of the
> same class (e.g. accelerometers) be standard.  Like hwmon does with
> temp#_input, etc.
> 
> Otherwise you made it easier to write drivers, but did nothing to help
> userspace to USE the drivers :-)
Hi,
I completely agree with Henrique. There already exist 3 accelerometer 
drivers in the kernel (and I'm writing a fourth on). What we are 
desperately in need of is a _user_ interface. So that a generic program 
can pop up and say "Oh, there is an accelerometer on this computer, I'll 
use it to detect free falls."

IMHO, I think the ADC should have a much more specific and specialised 
(user and kernel) API corresponding to the accelerometers. Granted, you 
probably had in mind only the accelerometers for industrial usage, but 
it would be much better if the current accelerometer drivers had a 
reason to be ported to this new subsystem.

In particular, what I think would be worthy would be:
* Up to 3 pre-defined axes (X, Y, Z) - that's provided by your current 
version of industrialio
* If the accelerometer is soldered on the computer, define once for all 
to which _physical_ movement corresponds which axis (eg: a laptop on its 
normal position going up has axis Z increasing).
* Free fall event. Either it's hardware detected, or the accelerometer 
infrastructure will detect it in software.
* For each axis, what is the maximum and minimum bound and the unit - 
Probably worthy for the whole ADC infrastructure
* Joystick emulation (calibrated so that when the computer is not 
moving, all the values are at 0). All the current drivers have it.

That's it for my wish-list for accelerometers :-)


Also, a couple of specific comments on the patches:
* At a quick glance, it seems the VTI SCA3000 driver sends events at 50% 
and 75% ring full, while the ST LIS3L02DQ driver sends events at 50% and 
100%. Why this difference?
* The accelerometer infrastructure has axis offset and axis gain 
attributes. However, it seems really specific to the ST accelerometer 
(and still, I doubt it's useful for most users as those values are 
factory-set to good values). Shouldn't they be moved to the ST LIS3L02DQ 
driver instead of being part of the accelerometer infrastructure?
* It would be also very good to provide a small userspace program 
showing how to read an industrialio device (à la evtest).

See you,
Eric



