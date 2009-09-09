Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZIIL2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZIIL2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZIIL2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:28:00 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:49822 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZIIL17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:27:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AA79144.8060104@cam.ac.uk>
Date: Wed, 09 Sep 2009 12:28:04 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: RFC: Light sensors, unifying current options?
References: <4A9FC9D7.20000@cam.ac.uk> <1252308744.3483.414.camel@rzhang-dt>	 <4AA4F194.1070507@cam.ac.uk> <1252467684.3483.446.camel@rzhang-dt>
In-Reply-To: <1252467684.3483.446.camel@rzhang-dt>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui wrote:
> On Mon, 2009-09-07 at 19:42 +0800, Jonathan Cameron wrote:
>> Zhang Rui wrote:
>>> Hi, Jonathan,
>>>
>>> On Thu, 2009-09-03 at 21:51 +0800, Jonathan Cameron wrote:
>>>> Dear All,
>>>>
>>>> This thread is a follow up to (amongst others)
>>>>
>>>> [lm-sensors] Ambient Light sensor for Intersil-ISL29020 device
>>>>
>>>> Currently there are a number of light sensor drivers either in the
>>>> mainline kernel, posted to various mailing lists or sitting in various
>>>> testing trees.
>>>>
>>>> For example.
>>>>
>>>> Intersil ISL29020
>>>> http://www.intersil.com/products/deviceinfo.asp?pn=ISL29020 driver
>>>> posted by Kalan Trisal to lm-sensors (as hwmon device rejected for
>>>> being out of subsystem scope)
>>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2009-September/026575.html
>>>>
>>>> ALS_sysfs class and als_acpi driver (V6 posted to lkml earlier this week).
>>>> http://lkml.org/lkml/2009/9/1/38
>>>>
>>>> TSL2561 under the industrial I/O Framework. (in Greg KH's tree, will
>>>> being in staging after merge window - there due to lack of review
>>>> more than any known problems.)
>>>> http://www.farnell.com/datasheets/49661.pdf
>>>> http://lkml.org/lkml/2009/7/2/189
>>>>
>>>> TSL2550 under i2c/chips/ which as a location is going away.
>>>> http://www.farnell.com/datasheets/48715.pdf
>>>>
>>>> (any others people know of?)
>>>>
>>>> Two big questions:
>>>>
>>>> * Are there sufficient shared characteristics between these devices to
>>>> all for a unified framework? (would certainly be nice!)
>>>>
>>>> * What applications are they used for? This will drive the question
>>>> of what functionality is desirable. (particularly do we need an event
>>>> infrastructure or not).
>>>>
>>>> To sumarize the functionality currently provided by the above drivers
>>>> (or that should probably be added)
>>>>
>>>> ISL29020:
>>>> * sensing_range
>>>> * lux_level
>>>> * power state (should probably move over to the new power management
>>>>   framework)
>>>>
>>>> ALS:
>>>> * illuminance (equivalent of lux_level)
>>>> * adjustment (I don't follow the purpose of this, but then I don't know
>>>> anything about how this is being used!)
>>>>
>>> adjustment is a percentage value used by userspace to adjust the display
>>> backlight.
>>>
>>> According to the ACPI spec, ACPI ALS device has "ambient light
>>> illuminance to display luminance" mappings that can be used by an OS to
>>> calibrate its ambient light policy for a given sensor configuration. The
>>> OS can use this information to extrapolate an ALS response curve. i.e.
>>> ACPI ALS knows what to do when ambient light illuminance changes, but it
>>> won't change the backlight. Instead, it exports this info to user space
>>> via the "adjustment" attribute.
>>> user space applications can get this value and change the display
>>> brightness via the backlight sysfs I/F.
>> Is this conversion entirely independent of the physical configuration of
>> the sensor?
> 
> yes.
> 
>>   I can sort of imagine cases where some direct pickup from
>> the backlight occurs alongside the ambient and some where none does.
>> Fair enough if not.
>>
> do you mean that on some platforms, als may change the backlight
> directly when ambient light changes?
Not really, more a question of where the sensor is.  In some cases
it might be near enough the screen as to pick up direct lighting from
it and others it might be no where near and hence that doesn't occur.
I guess that may be something for a future occasion if it actually occurs!
No point in implementing code for something hypothetical. 
> 
>>> IMO, the ALS device should do the following work:
>>> 1. catch the ambient light illuminance change.
>> Sometimes this is more complex with the ability to separately read light
>> levels in different frequency ranges (e.g. infrared and visible)  Still
>> this value can usually be derived.
> 
> so, "illuminance" should be a required attribute, right?
Yes,
> 
>>> 2. tell the userspace what to do with this change.
>>> isn't this true for the other ALS devices in this thread?
>> None of the others (other than the additional asus one mentioned
>> later in this thread - which I haven't looked at) have any concept of what userspace
>> should do with the value. They simply measure it (and supply appropriate
>> threshold interrupts etc)
> 
> then what does OS do upon these interrupts? nothing?
Depends on the application.  Worth remembering not all such sensors are
used purely for back light control.  Down the line we might want a means
of passing these up to userspace for any apps that are interested.
I'd be inclined to leave them out for now though. I don't think any of
the current drivers implement them.

> who is responsible for changing the backlight, BIOS?
Back to the point that not all these sensors have anything to do with
back lights.  They are ultimately things sensing light levels. Whilst
using that to control back lights is one major application it isn't
the only one.
 
>>>> TSL2561
>>>> * infrared (raw value)
>>>> * broad spectrum (raw value)
>>>> (I'm of the view any derived values should probably be done in userspace)
>>>> This one is under IIO at the moment for two reasons.
>>>> 1) I hit the same issue of no suitable subsystem, but for a much larger
>>>> class of sensor devices. Light sensors are just one example (that's not
>>>> to say I mind hiving this lot off to a system of their own).
>>>> 2) To provide an event interface (which I haven't yet done)
>>>> Driver should also include:
>>>> * integration time
>>>> * gain control 
>>>>
>>>> TSL2550
>>>> * power state
>>>> * operating mode
>>>> * lux (actually calculated from two separate readings as
>>>> per the tsl2561 but the are not available to userspace)
>>>>
>>>> Applications:
>>>>
>>>> 1) Backlight intensity type apps (guessing that covers most people)
>>>> 2) Environmental monitoring apps (the crossbow imb400 imote2 daughter
>>>> board I'm using doesn't have any screen or other direct interface, its
>>>> simply a lightweight sensor platform).
>>>> 3) High speed apps (all current sensors are pretty slow so this isn't
>>>> yet relevant).
>>>>
>>>> My personal feelings is that the IIO is overkill for these types
>>>> of sensors (slow update rate, tsl2550 takes 400ms, tsl2561 12-400ms)
>>>> unless we want the event handling infrastructure. I'm inclined to
>>>> say it is unecessary given the same result could be obtained by
>>>> polling only a few times a second.
>>>>
>>> agree.
>>> this is not a problem to ACPI ALS device.
>>> ACPI sends a notification to the ACPI ALS device when illuminance is
>>> changed.
>>>
>>>> My comments on ALS may be wrong or misleading as they are based on a
>>>> brief read of the code (please correct me!)  A lot of the
>>>> infrastructure is only necessary if we have in kernel users
>>>>  (and at
>>>> the moment the functionality doesn't appear to be there for any such
>>>> users to acquire access to these sensors in the first place.  For
>>>> example, the approach used by hwmon of letting drivers define their
>>>> own attributes seems to me to be more easily extendable than ALS' use
>>>> of an ops structure.
>>> ﻿I agree that the ops structure is unnecessary.
>>> To make the als_sys class more generic, we just need to
>>> 1. defines the generic attributes that the native ALS driver must
>>> follow.
>>> 2. registers an als device in the als_sys class.
>>> and the native driver should be responsible for the sysfs attributes.
>> Yup. 
>>> Because my approach is made by reading the ACPI spec, I'm not sure what
>>> should be done in the native driver and what should be done in the
>>> generic driver at the beginning.
>> For now I'd be tempted to keep as little as possible in the generic
>> driver and start moving stuff in only once a particular element
>> is verified to be relevant to almost every device.
>>> thanks for pointing this out.
>>>
>>>>  For example, I'm not convinced it makes sense for
>>>> drivers to have to have a get_adjustment attribute or indeed even
>>>> necessarily have a direct illuminance attribute (deriving the relevant
>>>> value may be a case of userspace combining several associated
>>>> readings).
>>> what these associated readings are?
>>> I think we can define some optional attributes besides the required
>>> attributes.
>> Agreed.
>>> but we should make clear what is necessary for an ALS device, and what
>>> optional features it may support.
>> Yes,
>>
>> For now I'd be inclined to stick to the ability to read illuminance 
>> in some specified unit.  Perhaps some other flag to specify something
>> about the frequency range of the sensor?
>>
> ACPI ALS doesn't support this.
> what's this frequency range used for?
Typically a device has 2 sensors, one in infrared one covering infrared and visible.
You can use them to produce a single reading of visible light level (probably
corresponds to your ALS illuminance) but if the functionality is there to read
them independently I'd like to support it.
> is there some reason that userspace should know this?
Depends on application.  If you are looking at an environmental monitoring case
then sometimes yes.
> 
>> Maybe similar to hwmon approach allowing for multiple readings of a given
>> type?
>>
>> illumiance[n]
>> illuminmance_type[n]
> 
> what's the value in illuminance_type, infrared/visible/ultraviolet?
Probably a mask allowing for a given sensor to cover several of these. 
Hence if you have an infrared and an visible + infrared, userspace can
pull the visible out.  Or we could do that separation in kernel, so
in this case export

visible, visible+infrared and infrared.

Perhaps we might do it via sysfs naming instead.

illuminance[n] - defined to be visible (which is what term means anyway)

infrared[n] - hmm.. will be in different units to illuminance - perhaps we leave
these raw with suitable documentation?

illuminance_and_infrared[n]

On the tsl2561, if we were to implement threshold interrupts the interestingly
don't apply on illuminance but rather on the illuminance + infrared sensor,
which will make setting it from userspace 'interesting'.
> 
>> Everything else optional.  Actually I'm personally of the view everything
>> should be optional as long as any close matches in functionality are given
>> the same names.  It's up to userspace to figure out of the device supports
>> what it wants to use.  Things that I can envisioned not meeting the above
>> but still being appropriately placed within als:
>>
>> * Device that simply tells you whether ambient is greater or less than
>> backlight value + some offset (perhaps with controllable offset).
>>
> sorry, I don't understand this.
> IMO, ambient and backlight are two different concepts.
> that's why ACPI spec defines "﻿ambient light illuminance to display
> luminance" mappings.
Agreed, though that doesn't mean every chip will allow you to read illuminance.
You may well get things that effectively provide you with a value part way through
the calculations you are doing in userspace to then adjust the display brightness.

The only point of these examples, is we don't want to enforce any attribute in the
code, rather we want to imply which are required in documentation.  Thus if something
comes along we haven't considered, it is possible to support it and merely change
documentation to reflect this rather than needing a change to the core.
> 
>> * Weird and wonderful sensor types we can't even envision at this point in
>> time!
>>
>> Perhaps the trick is to document the 'required' parameters as being those
>> required without consulting the maintainer / mailing list then they can be
>> adjusted over time as more device drivers are written.
>>
>> This is definitely the sort of driver
>> where the fine grained power management stuff should be encouraged.  After
>> all not a lot of point in having them powered up if the screen is off!
>> As ever whether people put this stuff in is up to them.  Others can always
>> submit patches adding it drivers at a later date.
>>
> agree.
>
So in summary, I think we are agreed that what we need is similar to hwmon,
with all drivers exporting illuminance.  If they are capable of
exporting other things all well and good.  The naming can be decided as and
when people post drivers with new functionality.

The other obvious question is whether it makes sense to cache values from sensors?
(as per many hwmon drivers)  These things are pretty slow, so there is no point in
taking a new reading unless there has been sufficient time for it to update.
Still this is again a documentation issue rather than core code, as it would be
down to the individual drivers.

Jonathan
