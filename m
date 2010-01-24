Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621Ab0AXLZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0AXLZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 06:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522Ab0AXLZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 06:25:48 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:56797 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0AXLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 06:25:46 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B5C2E8C.2060606@jic23.retrosnub.co.uk>
Date: Sun, 24 Jan 2010 11:27:08 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com> <4B573501.9090001@jic23.retrosnub.co.uk> <20100122204718.GA15759@kroah.com>
In-Reply-To: <20100122204718.GA15759@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
>>> On Wed, Jan 20, 2010 at 03:13:40PM +0000, Jonathan Cameron wrote:
>>>> What:		/sys/class/iio/device[n]
>>>> Description:
>>>> 		Hardware chip or device accessed by on communication port.
>>>> 		Corresponds to a grouping of sensor channels.
>>>>
>>>> What:		/sys/class/iio/trigger[n]
>>>> Description:
>>>> 		An event driven driver of data capture to an in kernel buffer.
>>>> 		May be provided a device driver that also has an IIO device
>>>> 		based on hardware generated events (e.g. data ready) or
>>>> 		provided by other hardware (e.g. periodic timer or gpio)
>>>> 		Contains trigger type specific elements. These do not
>>>> 		generalize well.
>>>>
>>>>
>>>> What:        /sys/class/iio/ring_buffer[m]
>>>> Description:
>>>> 	        Link to /sys/class/iio/device[n]/ring_buffer[m]. Ring buffer
>>>> 		numbering may not match that of device as some devices do not
>>>> 		have ring buffers.
>>>
>>> Why is this link needed?  Why can't you just look in the device
>>> directory for a ring buffer?  And wouldn't the ring buffer be 1..n for
>>> every device?  They shouldn't be "unique" for all iio devices, that
>>> would be wierd.
>> I'm a little unclear what you mean here (so my apologies if I'm misinterpreting!)
>> A given IIO device will indeed have a either none or typically 1 ring buffers.
>> They are not currently shared across devices. Aggregation if desired is done
>> in userspace.
> 
> Ok, that's fine, but the name of those buffers do not have to be unique
> to all ring buffers in the system.
> 
> Hm, oh yeah, they do, ok, nevermind, stupid me :)
> 
>>>> What:		/sys/class/iio/device[n]/name
>>>> Description:
>>>> 		Description of the physical chip / device. Typically a part
>>>> 		number.
>>>>
>>>> What:		/sys/class/iio/device[n]/volt_[name][m]_raw
>>>> Description:
>>>> 		Raw (unscaled no bias removal etc) voltage measurement from
>>>> 		channel m. name is used in special cases where this does
>>>> 		not correspond to externally available input (e.g. supply
>>>> 		voltage monitoring).
>>>
>>> So what would 'name' be?
>> This is for a few device corner cases such as volt_supply_raw for the the
>> adis16350 below.  It can't really be used as a general purpose ADC
>> so the idea was to separate it out.  The vast majority of voltage channels
>> would simply be numbered.  There is an argument that, it might make sense
>> to support this single parameter via hwmon, but then there are high end
>> gyros where we would be grabbing the voltage, temperature and actual reading
>> on each trigger so as to be able to compensate for the huge difference
>> these can make to the resulting data.
> 
> But again, what would 'name' be?
Probably an option from a small list. (supply being the only element right now!)
Actually, whilst the list is small we might as well put it straight in the abi
description line. 

> 
>>>> What:		/sys/class/iio/device[n]/volt_[name][m]_scale
>>>> Description:
>>>> 		If known for a device, scale to be applied to volt[m]_raw post
>>>> 		addition of volt[m]_offset in order to obtain the measured voltage
>>>> 		in volts.  If shared across all voltage	channels the m is not present.
>>>
>>> For all of these voltage measurements, why use something different from
>>> what the kernel already supports for the existing hardware monitoring
>>> devices?  There is already a well-defined api for these things.
>> Agreed.  We did consider using in0 etc as per hwmon but decided that we were
>> breaking sufficiently from the approach there (where the readings are always
>> provided in microvolts iirc) that we could change the name to something that
>> was a little more specific.  I'm not overly tied to volt but the semantics
>> are different enough here  (with offsets and gain passed to userspace) that
>> we may actually create confusion by mirroring that api.
> 
> I really think you should merge with that api somehow.
> 
> I understand that you don't want to do conversions in the kernel, so
> perhaps there could be some way to show this like you have described,
> that the hwmon interface could also use.
> 
> That way userspace tools will work for all types of devices, and you
> don't have a custom interface just for these device.  Unification is a
> good thing :)
A good point.  I'll have a think about how to do this then post an update
including the hwmon list to see if we can work out what needs adding to their
current interface.
> 
>>>> What:		/sys/class/iio/device[n]/accel_[x|y|z][m]_raw
>>>> Description:
>>>> 		Acceleration in direction x, y or z (may be arbitrarily assigned
>>>> 		but should match other such assignments on device)
>>>> 		channel m (not present if only one accelerometer channel at
>>>> 		this orientation). Has all of the equivalent parameters as per volt[m].
>>>> 		Units after application of scale and offset are m/s^2.
>>>
>>> Shouldn't this just use the existing input accelerometer interface so as
>>> to keep userspace sane?
>> Again, it comes down to whether we process the data or not.  IIO is all about
>> the ability to handle things fast.  These sysfs interfaces are actually meant
>> to mirror the chrdev ring buffer accesses which are the primary access point
>> for higher end devices.  A lot of the use cases are either interested in logging
>> for later use, or algorithms that will run in the device units (sometime in integer
>> arithmetic).  Hence all conversion to sane units is left to userspace. The
>> drivers merely provide sufficient information to do this conversion if it
>> is desired.
> 
> See above.  I suggest working with the hwmon developers to add the "raw"
> type interface to their api making these able to be used there as well.
> 
>>>> What:		/sys/class/iio/device[n]/event_line[m]
>>>> Description:
>>>> 		Configuration of which hardware generated events are passed up to
>>>> 		userspace. Some of these are a bit complex to generalize so this
>>>> 		section is a work in progress.
>>>>
>>>> What:		/sys/class/iio/device[n]/event_line[m]/dev
>>>> Description:
>>>> 		major:minor character device numbers.
>>>
>>> No, don't bury devices down a level in sysfs, that's not ok.  Actually,
>>> I think it would take you a lot of work to get this to properly work on
>>> the implementation side :)
>> This bit of the documentation is indeed wrong (oops). These are members of the IIO
>> class and so this is just a link (much like the event elements in input) created
>> by making them in class iio with the device as a a parent. Again, application
>> wise we aren't normally interested in aggregation so there is one (or more) of these
>> per device.
> 
> Ok.
> 
>>>
>>> If event_lines need device nodes, then they should be real devices.
>> (oops) The are ;)
> 
> Heh, that will not work, as Kay described :)
> 
>>> Actually, all of this looks like it needs to be a bus, not a class, if
>>> you are having this many different types of things hanging off of them.
>>> Have you thought about that instead?  It would make your code a lot
>>> easier in the end.
>> That is definitely an option. The reason we didn't is more to do with following
>> the most similar current case (input) than any particular preference.
> 
> As Kay said, this should be a bus, and you should have devices attach to
> them, be it virtual or not.  Or, you just tie into the hwmon interface
> which makes it much easier for you overall.
We'll definitely move over to a bus.  I'd fallen for the naming and never
really considered it as an option! As for tying into hwmon, I'll take another
look as I can see it may be simpler with the bus structure separating the different
'devices'.
> 
>>>> Again taking accel_x0 as example and serious liberties with ABI spec.
>>>>
>>>> What:		/sys/.../event_line[m]/accel_x0_thresh[_high|_low]
>>>> Description:
>>>> 		Event generated when accel_x0 passes a threshold in correction direction
>>>> 		(or stays beyond one). If direction isn't specified, either triggers it.
>>>> 		Note driver will assume last p events requested are enabled where p is
>>>> 		however many it supports.  So if you want to be sure you have
>>>> 		set what you think you have, check the contents of these. Drivers
>>>> 		may have to buffer any parameters so that they are consistent when a
>>>> 		given event type is enabled a future point (and not those for whatever
>>>> 		alarm was previously enabled).
>>>>
>>>> What:		/sys/.../event_line[m]/accel_x0_roc[_high|_low]
>>>> Description:
>>>> 		Same as above but based on the first differential of the value.
>>>>
>>>>
>>>> What:		/sys/.../event_line[m]/accel_x0[_thresh|_roc][_high|_low]_period
>>>> Description:
>>>> 		A period of time (microsecs) for which the condition must be broken
>>>> 		before an interrupt is triggered. Applies to all alarms if type is not
>>>> 		specified.
>>>>
>>>> What:		/sys/.../event_line[m]/accel_x0[_thresh|_roc][_high|_low]_value
>>>> Description:
>>>> 		The actual value of the threshold either in raw device units
>>>> 		obtained by reverse application of scale and offfset to the
>>>> 		acceleration in m/s^2.
>>>
>>> Again, look at our existing apis, I think we already cover these types
>>> of things, don't create new ones please.
>> I am not aware of these. Could you direct me to the current api? Also note that these
>> aren't the actual alarms, merely a means of enabling the relevant event on the related
>> event character device. 
> 
> Hm, I thought we had an accelerator interface somewhere...
(cleared up by Dmitry further down the thread)
> 
>>>> What:		/sys/.../event_line[m]/free_fall
>>>> Description:
>>>> 		Common hardware event in accelerometers. Takes no parameters.
>>>
>>> I know we have this one already, please use it.
>>
>> Again, does it make sense to match api when the result is very different? The event
>> infrastructure in IIO is much slimmer than that in input (this was one of the original
>> reasons for not simply adding these things to input in the first place).  This particular
>> example is a bit unusual in that the current api (hwmon/lis3lv02d.c for example) handles
>> this via a dedicated freefall character device.  This doesn't really generalize to the more
>> complex events handled here. To be honest this one doesn't really make sense in IIO's
>> intended applications so it might be best to drop it entirely! 
> 
> Yeah, a dedicated char device doesn't seem to make much sense either,
> but any unification you could find here would be nice.  Even if it means
> the existing driver converts over to your new api :)
Fair point.

> 
>>> Again, don't bury devices.  Or if you are, use a bus, not a class,
>>> that's the wrong classification.
>> Cool, I'll look into making the change.  What we really have here
>> is a single conceptual device using a pair or character interfaces.  Is a bus
>> the right way to handle that?
>>
>> How about the following under a bus (this is for a single physical chip).
>>
>> device0
>> event0 (for physical events)
>> ringaccess0 (actual device from which data is read)
>> ringevent0 (associated event interface for the ring  - ideally not aggregated with the event0)
>>
>> and sometimes:
>> trigger0
>>
>> Is that best way to go.  Currently ringacces0 and ring event0 are
>> grouped under ring_buffer0 but that was simply for the reason they are
>> always matched.  
> 
> Yes, that would work, and make sense.
Excellent,

Thanks for taking a look at this!

Jonathan
