Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbYE0PgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbYE0PgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbYE0Pfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:35:41 -0400
Received: from mga07.intel.com ([143.182.124.22]:14193 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758444AbYE0Pfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="252833289"
Date: Tue, 27 May 2008 08:43:31 -0700
From: mark gross <mgross@linux.intel.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [spi-devel-general] Accelerometer, Gyros and ADC's etc within
	the kernel.
Message-ID: <20080527154331.GA29868@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <4832A211.4040206@gmail.com> <20080520175041.GA30909@linux.intel.com> <4833EE22.80502@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4833EE22.80502@cam.ac.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 27 May 2008 15:35:35.0411 (UTC) FILETIME=[4E7FF430:01C8C00F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:40:50AM +0100, Jonathan Cameron wrote:

First I'm sorry for not checking my email for a week and the late reply.

> Hi Mark,
>
>>> ST Micro LIS3L02DQ 3D accelerometer.  SPI device, no buffering, interrupt 
>>> pin
>>> raised high on new data being available. Currently the driver assumes, if
>>> interrupts are enabled, that this is connected to a specified gpio.
>>> (http://www.st.com/stonline/books/pdf/docs/10175.pdf)
>> FWIW: I have this device talking to a PIC-18 and pushing the results
>> over the serial port.
>
> That's certainly interesting and I guess one of the easiest ways of getting 
> data from spi to a desktop machine. I'll admit my interest is more with 
> embedded machines.
>
>> WRT linux support, I can't think of a generalized way to create a driver
>> that would be able to be used with this device in Linux.  You need to
>> know witch IRQ line the DR line is connected too, and if you are
>> bit-banging the SPI data off the thing, then you need to know which
>> GPIO's of the host CPU you'll be using. 
> Yes, and that means we would use the delights of platform data and the 
> generic gpio subsystem.  Although I believe generic gpio isn't available on 
> every platform as yet, it is getting there and is certainly in place for 
> ARM (and cleans up an awful lot of hardware interfaces!)
>> If you have SPI hardware then
>> you need to know where to pull the data from.  The problem doesn't seem to
>> generalize well.
> Yes, the intention would not be to generalize the hardware comms, but 
> rather the
> interface on the user side.  This is similar to a number of other 
> subsystems such as hwmon, where you share functionality as much as 
> possible, but allow very different approaches to things like actual 
> hardware register reads as and when they are necessary.

Ok, say the HW SPI is pushed down to some lower level driver.  These
things send streaming data, and sometimes signals (free-fall detect) out
of band WRT the SPI comms.

I would like to see how a higher level API could encapsulate the
generalization of a class of such devices.

Also, I'm not sure how one could generalize SPI communications at a high
level given its bi-directional nature.

I guess I need to see some header files showing what you are thinking
about.

Keep in mind that one abstraction of these devices is they are simply
streaming A2D 16 bit data values over SPI (or I2C).  The size of the
data set is a function of the sensor axes.


>
>> Also, If you are playing with accelerometer data, you likely need some
>> real time support or at lest a reliable time stamping of the data to do
>> anything interesting.
> Definitely. Obviously the accuracy of this time stamp is going to be 
> limited by
> the variable nature of when an interrupt handler picks it up, but knowledge 
> of the device specs can allow filtering of this timing data.  This is 
> certainly something we would want to consider at a later date although it 
> may well be more sensible to leave this to userspace applications.
>
>> Another problem area is around SPI itself.  There are variations of
>> device implementations around chip select polarity, clock biasing
>> (rising,falling, or midpoint) sampling from one SPI part to the next.
> Indeed.  This is well handled by the SPI subsystem. I've spent far too much 
> time with a scope recently fiddling with these parameters for badly 
> documented chips!
>
>>> VTI SCA3000 E05 3D accelerometer equiped with substantial ring buffer. 
>>> SPI
>>> device.  Can operate either in buffered or direct mode.  In buffered 
>>> mode, interrupts
>>> can be used to indicate when the ring buffer is 3/4 full triggering a 
>>> download to
>>> a larger ring buffer in the kernel if necessary.
>>> (http://www.vti.fi/en/products-solutions/products/accelerometers/sca3000-accelerometers/)
>>>
>> ring buffered data can make RT applications harder...
> Agreed.  With this sort of device two modes would be needed (and are 
> supported by the hardware).  The first gives direct data access and the 
> second uses the ring buffer.  Which you use would obviously be dependent on 
> the application. Some applications want the most recent data on all 
> occasions, whilst some will be more interested in ensuring that all data is 
> captured.
>
>>>
>>> Would be nice if practical to allow the framework to include RS232 
>>> devices such
>>> as those from www.xsens.com, www.isense.com and others.
>> I'm not sure what you are asking for, you started off with SPI driver
>> for interfacing a handful of accelerometer devices.  Now your talking
>> about the serial port.
>
> The question here is concerned with standardising mainly the userspace 
> interfaces (and hardware interfaces only when appropriate). Some of these 
> devices (the ST accel above for example) support multiple hardware 
> interfaces specs (I2C and SPI for that one).  So in a similar way to it 
> making sense to group all TV adapters irrespective of how they are 
> interfaced to the computer, in order to ensure a consistent interface to 
> user space, it makes sense to share these interfaces amongst drivers 
> talking to these devices irrespective of what their hardware interface is.

I guess I need to see some header files to see where you are going with
this idea.  To be useful you'll also need to handle rotation sensors and
communicate the temperature bias's up the stack too.


good luck keep me posted on where your going with this, it is
interesting to me.

--mgross

>> Besides the consumer of accelerometer data is user space applications
>> (mine attempt to be somewhat RT applications) 
>
> Thanks,
>
> --
> Jonathan Cameron
