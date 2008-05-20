Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbYETRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbYETRn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYETRnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:43:16 -0400
Received: from mga10.intel.com ([192.55.52.92]:50152 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756535AbYETRnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,516,1204531200"; 
   d="scan'208";a="566713999"
Date: Tue, 20 May 2008 10:50:41 -0700
From: mark gross <mgross@linux.intel.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080520175041.GA30909@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <4832A211.4040206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832A211.4040206@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 20 May 2008 17:42:59.0088 (UTC) FILETIME=[F1984100:01C8BAA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:04:01AM +0100, Jonathan Cameron wrote:
> This email is basically a request for opinions on how and where such 
> sensors
> should be integrated into the kernel.
>
> To set the scene...
>
> Increasing numbers of embedded devices are being supplied attached MEMS
> devices (www.xbow.com imote2 etc). Along with more traditional sensors such
> as ADC's not being used for hardware monitoring, these do not really seem 
> to
> fit with in an particular subsystem of the kernel.  A previous discussion 
> on
> lkml in 2006 considered the accelerometers to be found within some laptop
> hard drives, but I haven't been able to track down any more general 
> discussions
> of such non hardware monitoring sensors.
>
> The obvious possibilities are:
>
> * To place the various drivers within the spi / i2c etc subsystems as 
> relevant.
>
> * To place within the hwmon subsystem as this is probably closest.
> (there is already at least one straight ADC driver in hwmon)
>
> * To create a new subsystem, or perhaps merely sysfs class to contain these
>  elements.
>
> Typical requirements within an application include simply polling for 
> current
> readings, and using device triggered interrupts to grab data continuously 
> to a
> ring buffer, for collection by suitable userspace code.  Obviously it would 
> be
> desirable to standardize sysfs controls for various calibration parameters 
> as
> much as possible across the various devices.
>
> Any other suggestions welcome!
>
> To illustrate the sort of devices here are a few I have drivers written for 
> or will
> shortly be writing  (some submitted to hwmon and spi mailing lists, some 
> not
> finished as of yet)
>
> ST Micro LIS3L02DQ 3D accelerometer.  SPI device, no buffering, interrupt 
> pin
> raised high on new data being available. Currently the driver assumes, if
> interrupts are enabled, that this is connected to a specified gpio.
> (http://www.st.com/stonline/books/pdf/docs/10175.pdf)

FWIW: I have this device talking to a PIC-18 and pushing the results
over the serial port.

WRT linux support, I can't think of a generalized way to create a driver
that would be able to be used with this device in Linux.  You need to
know witch IRQ line the DR line is connected too, and if you are
bit-banging the SPI data off the thing, then you need to know which
GPIO's of the host CPU you'll be using.  If you have SPI hardware then
you need to know where to pull the data from.  The problem doesn't seem to
generalize well.

Also, If you are playing with accelerometer data, you likely need some
real time support or at lest a reliable time stamping of the data to do
anything interesting.

Another problem area is around SPI itself.  There are variations of
device implementations around chip select polarity, clock biasing
(rising,falling, or midpoint) sampling from one SPI part to the next.

> VTI SCA3000 E05 3D accelerometer equiped with substantial ring buffer. SPI
> device.  Can operate either in buffered or direct mode.  In buffered mode, 
> interrupts
> can be used to indicate when the ring buffer is 3/4 full triggering a 
> download to
> a larger ring buffer in the kernel if necessary.
> (http://www.vti.fi/en/products-solutions/products/accelerometers/sca3000-accelerometers/)
>

ring buffered data can make RT applications harder...

> Analog Devices ADIS16350 combined 3D accelerometer and gyro unit.  SPI 
> device.
> (http://www.analog.com/en/prod/0,,764_801_ADIS16350%2C00.html)
>
> Maxim MAX1363, MAX1238 ADC's.  I2C devices. Some SPI ADC's (www.analog.com 
> for
> examples)
>
> Would be nice if practical to allow the framework to include RS232 devices 
> such
> as those from www.xsens.com, www.isense.com and others.


I'm not sure what you are asking for, you started off with SPI driver
for interfacing a handful of accelerometer devices.  Now your talking
about the serial port.

Besides the consumer of accelerometer data is user space applications
(mine attempt to be somewhat RT applications) 

--mgross

