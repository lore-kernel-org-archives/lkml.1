Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYGXKM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYGXKM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYGXKMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:12:17 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:52712 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYGXKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:12:16 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48885584.9070709@cam.ac.uk>
Date: Thu, 24 Jul 2008 11:12:20 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 1/4] Industrialio Core
References: <488763AD.4050400@gmail.com> <488765A5.3040703@gmail.com> <20080723183113.GA22142@polina.dev.rtsoft.ru>
In-Reply-To: <20080723183113.GA22142@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
Hi Anton,
> 
> Sorry, I didn't comment on the first version. So my comments for
> this version is below. Note, I only briefly looked in the code,
> thus the comments are really superficial.
> 
> So... this subsystem is _huge_. And so it needs documentation. Yes,
> the code is well commented, much thanks for this. But the
> documentation is needed, for example, to answer these simple
> questions:
> 
> - What userspace interface the subsystem provides (i.e. for use with
>   userspace tools).
> - What kernel interface the subsystem provides (i.e. for use with
>   in-kernel drivers, for example touchscreens).
> - What is iio_ring (as I see it, is one of basic concepts of this
>   subsystem), I'd like to see description of its basic usage.
> - What is struct iio_event_data, what is event's "id"? How it is used
>   across subsystem?
> 
> There is a lot of questions more. Of course, half the questions I'll
> answer myself through reading the code... But you really need to
> describe basic ideas of 2431-LOC-subsystem.
> 
> Something like Documentation/gpio.txt would work.

Agreed, sorry about that - docs are about half written and should probably have
finished them off before I posted the patch.  I'll try and get a first version
cleaned up and posted today. Main issue at the moment is getting example code
into a state where it isn't too dependent on the exact board setup I'm testing
on.

> On the subsystem itself. I would recommend you to split the 
> industrialio_{core,rtc,ring,ptimer_board_info} into separate modules
> (if possible) and into separate patches (for better reviewing).
> 
> Few more comments below.
> 
> [...]
>> +
>> +#define INIT_IIO_RING_BUFFER(ring_buf, _bytes_per_datum, _length) {	\
>> +		(ring_buf)->size = _bytes_per_datum;			\
>> +		(ring_buf)->length = _length;				\
>> +		(ring_buf)->loopcount = 0;				\
>> +		(ring_buf)->shared_ev_pointer.ev_p = 0;			\
>> +		(ring_buf)->shared_ev_pointer.lock =			\
>> +			__SPIN_LOCK_UNLOCKED((ring_buf)			\
>> +					     ->shared_ev_pointer->loc);	\
>> +	}
> 
> Is it possible to convert this into function?
Good point. No idea why I did it like that!

> [...]

>> +	/* Event control attributes */
>> +	struct attribute_group *event_attrs;
>> +	/* The character device related elements */
>> +	struct iio_event_interface *event_interfaces;
>> +
>> +/* Software Ring Buffer
>> +   - for now assuming only makes sense to have a single ring */
> 
> These comments are really hard to parse. Try to turn off syntax
> highlighting (if you use), and see the result. It is really
> unreadable.
> 
> So, I'd suggest to use kernel doc syntax to describe the fields.
> 
> For example, I very like how include/linux/mtd/nand.h is commented.
> It is in kernel doc, plus explains what fields are
> internal/driver-specific/e.t.c.
Thanks for the pointer, I'll do that.
> [...]
>> +	IIO_DEVICE_ATTR(z_gain, _mode, _show, _store, _addr)
>> +
> 
> Why such a generic subsystem should be aware of X/Y/Z? ADC can measure
> strength of wind, for example. But in fact it measures voltage and/or
> current. Yes, it is convenient to tell user what exactly chip is
> supposed to measure, but it is chip (and thus driver) specific,
> subsystem should only provides means to expose that information, but
> it should not be aware of what exactly we're measuring. At least that is
> how I imagine the ADC subsystem.
I'd argue this is actually connected to improving the usability of the system.

I would envision that the set of definitions (probably broken out into specific
headers for different classes of device) and will grow considerably. If a
particular parameter is available in say 2 drivers, or looks like it will be,
then it will get moved to the main headers rather than being driver specific.

The basic advantages of doing it this way are concerned with user readability.
If we know the device is an accelerometer rather than a general ADC is would be
silly to have the user guessing which of the inputs are accelerations rather
than say temperature readings. Clearly there are issues with definitions of axes
on these devices but that will be something to clear up by clear documentation
(pick a standard and stick to it!).

Clearly there are cases, for example where an accelerometer is attached via a
generic ADC in which we don't have the inherent ability to identify the inputs
from the generic adc driver.  Given this is a common setup, there may well be
some scope for custom drivers for any common sensor circuits or indeed providing
a way specifying this in a board config.

It will be interesting to see how this pans out.

What I also forgot to mention alongside the patches is that each driver should
be accompanied by a userspace header file providing conversion function
to real world units as appropriate. This is clearly required to interpret the
data coming out of the ring buffers (which will always be as raw as possible).

There is also the question of whether the outputs in sysfs of say acceleration
should be converted to SI units or left as raw readings. For now I'm inclined
to leave them raw as the calibration of such sensors within systems is fairly
complex and often done as an offline process.  However I'm definitely open
to other opinions on this.


Thanks for taking a look and providing feedback.
--
Jonathan Cameron
