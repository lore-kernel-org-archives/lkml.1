Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0CCUfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:35:32 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:36783 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0CCUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:35:26 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8EC883.9030804@jic23.retrosnub.co.uk>
Date: Wed, 03 Mar 2010 20:37:23 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk>	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>	 <20100303184132.GA11471@core.coreip.homeip.net>	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>	 <4B8EB685.1060302@jic23.retrosnub.co.uk>	 <1a297b361003031129y6c19ad9cqe8658c2d85d8764@mail.gmail.com>	 <4B8EBC48.8060701@jic23.retrosnub.co.uk> <1a297b361003031208s1a4b6f1dm8aa3ac91f6b7ee73@mail.gmail.com>
In-Reply-To: <1a297b361003031208s1a4b6f1dm8aa3ac91f6b7ee73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>> ...
>>> Maybe it make sense to put all Generic sensors into one whole lot,
>>> where an application can
>>>
>>> - read the value from the driver (eg: 0 - 65535)
>>>
>>> - read from device static information (to identify how the application
>>> should treat the values read back.)
>>>
>>>    - report what type of device it is (Light, Voltage, Acceleration
>>> and what not, simple enumeration will help, mayeb you can even have
>>> bitwise OR the types, so that you can have a driver with multiple
>>> capabilities)
>>>    - the max value it can go
>>>    - the min value it can go
>>>    - the number of steps (gradient) that the driver can do.
>>>
>>>
>>> Maybe such a simplistic interface does help ?
>>>
>>> The application can simply read the static information from the driver
>>> and decide whether it should really handle that driver class.
>>
>> The more generic sensors are covered by IIO (in staging)
>> There is a lot more there as well as an equivalent of what you describe.
>>
>> The simplest equivalent to this is the hwmon subsystem (from which IIO
>> has borrowed a lot of interfaces, as has ALS).
>>
>> You have a sysfs file per channel, so taking als api as an example:
>>
>> illuminance0 - Value of illuminance in lux.
>>
>> If you want your other elements (though no driver provides them at the moment).
>>
>> illuminance0_max
>> illuminance0_min
>> illuminance0_values
> 
> 
> Just as i thought:
> 
> A Class with values to define floor and ceiling and the gradient in
> which the driver can provide such an information in a generic way,
> rather than limiting to Ambient Light Sensor.
> 
> to make it a bit more stylistic, you could provide static information,
> such as driver name also alongwith. But in any case, i guess you
> wouldn't need more than these
> 
> device_name
> max_val
> min_val
> gradient/steps
Except that we actually gain by using specific naming of the type of
input. It's the same approach used very successfully in hwmon which
actually covers quite a few different channel types.  
> 
> 
> as static information and a simple value that could be read back.
> 
> 
> In (some remote thought) addition, some devices could "possibly" have
> levels that you could set the levels at which the device could set of
> a trigger, in which case, you might want to write to the driver to set
> the value at which you want to trigger of some event. (Don't really
> know whether this is applicable, but I have seen it in some
> temperature sensors, such a feature)
A lot of this is covered by the IIO ABI.  If we don't currently have specific
static parameters (and there are lots there!) then it is simply because we haven't
yet encountered a device needing them.
>> For slow devices this is all you need.
>> If you are interested in fast devices, take a look at the recently posted IIO ABI spec.
>> That uses sysfs files to describe the data that can be read from a character device
>> that is fed from a buffer (either hardware or software). It also supports fairly
>> advanced event handling (similar to input, but without cross device aggregation)
>> and triggering of data capture from various 'interrupt' sources.
>>
>> It is still somewhat unclear how exactly to marry the high speed data acquisition
>> requirements with other 'client' subsystems such as input. All suggestions on that
>> are welcome!
> 
> I don't know how fast is "fast".
That one keeps coming up and I keep deliberately being vague on this as
it is very dependent on what your host platform actually is.  If you have
a slow embedded device then we might be talking a few 10's of Hz, but if
you have a high end machine, perhaps many Khz before the overheads matter
enough.  Thus if a developer has a requirement for the more complex
features of IIO in an existing driver, they can be added without breaking
the simpler (higher overhead) interfaces that are already in place.

As an example of how this works, there are quite a few adc drivers and
similar in the blackfin tree.  These are currently mostly of the simplest
variety, just giving direct access (as in ALS) to the individual channels
via sysfs.  Some of these are (I think) capable of relatively high speeds,
and so at somepoint a developer may well add the character device accessed
ring buffer support if there is demand.
> 
> "I think", (based on quick thought) all you might need is a trigger,
> whether the userspace application needs to be triggered to read the
> value from the driver, or do something exotic.
> 
> ie the trigger is a binary only event, as I understand, right ? But in
> any case, you define the trigger mechanism in any way, similar to an
> interrupt
The event can be passed up to userspace.  Typically we are using a buffer
of some type (ideally filled directly by dma from the device). The trigger
usually simply causes this to be started.  For performance reasons it tends
to occur entirely in kernel.  There are then events passed to userspace
to give information on how fall the buffer is etc.  (so in essence as
you describe but with an intermediate buffer). 
> 
> The data to be read back could be just as generic, in any case, rather
> than defining a subsystem per device category..
I agree to a certain extent.  The issue comes in the complexity that the
subsystem gains as one starts to handle faster and more complex devices.
The motivation for ALS was that (so far) all these devices are ludicrously
simple and are very slow so we simply didn't need the weight of IIO or similar.

Whilst we are keeping the minimum driver requirements as slim as possible,
it still isn't as clean and simple as ALS is.

A lot of what you are suggesting is very similar to elements of IIO and
I would certainly appreciate any comments you have on that!

Jonathan


