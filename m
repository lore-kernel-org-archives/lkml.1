Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZJQQFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZJQQFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 12:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZJQQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 12:05:11 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:48266 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZJQQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 12:05:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AD9EB5B.2080303@gmail.com>
Date: Sat, 17 Oct 2009 17:05:47 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Bertrand Roussel <bertrand.roussel@cor-net.org>
CC: linux-kernel@vger.kernel.org, Ben Nizette <bn@niasdigital.com>
Subject: Re: Kernel driver with multiple SPI sources
References: <a5b9b4700910160150o146a8f21n1c76c14755d64da8@mail.gmail.com>
In-Reply-To: <a5b9b4700910160150o146a8f21n1c76c14755d64da8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bertrand,
> Hello,
>
> I am currently writing a kernel driver for an IMU, this is a basic
> driver that is taking infos from
> two SPI devices (an adc and a magnetic sensor), that are running on
> the same bus, but different with different CS.
>
> I'm having troubles to determine if the architecture I am currently
> thinking about is a good way to do things.
> In order to write portable code I was thinking in using general kernel
> APIs, and came out with something like this:
>  _____      ______
> |     | <> |  ADC |
> |     |    |______|
> | IMU |     ______  <> Bus SPI
> |     | <> |  MAG |
> |_____|    |______|
>
> Each block correspond to a driver:
> * IMU is a basic char driver, depending on both ADC and MAG driver,
> and that register new spi_device to the spi_master
> * ADC and MAG are instances of an spi_driver, with a char driver as an interface
>   
As Ben has already said this fits well within IIO. The original
motivation for that
was a very similar situation. (I'm only replying to this email rather
than his because
I want to refer to the other bits of your email.)

I'm a little confused on the arrangement in your diagram? Are we
triggering the
Magnetometer to provide an analog value then read by the ADC after the
magnetomer
is ready or is the ADC doing something else?
> The IMU must take samples from the devices at a fixed rate.
> A problem is that to retrieve infos from the MAG for example, a
> command must be send first, then there is a delay from
> 1 to 4ms before the result are available, which is known when a PIN gets high.
>   
First question here is whether this delay is predictable and are we
dealing with
predictable timing of when it actually takes a reading within this time
period?

Perhaps a ref to what the Magnetometer is might help discusion.
> Since I'm a beginner in kernel writing, I really don't know if the
> approach I took is a good way to do things or not.
>   
Welcome to the fun that is the kernel!
> If that's not the case, can anyone give me some hints about how I
> should consider doing things ?
>
> However, in the case as my approach is right, I am really worried
> about the delay part, since I don't want the kernel
> to block for 5ms doing nothing a hundred times per second just because
> it is reading from the SPI, I was considering
> asynchronous IO implementation on the ADC/MAG side.
> A timer would generate the sample rate in the IMU driver, tell the
> ADC, which would send the command, then return.
>   
Yes, in IIO this is currently a bit of cludge as there is no nice
periodic timer
infrastructure in place (it's on the to do list.) So for now we use the
rtc emails
in conjunction with iio-trig-periodic-rtc driver.  You can set a device
to have triggered
capture on the interrupt from this timer (via userspace sysfs interface). 
Until clear on what your actual setup is difficult to say if a more
complex trigger might
be needed.

If the ADC is reading the magnetometer output...

Then use the periodic rtc trigger to trigger the magnetometer, then
either use
a trigger exported by the magnetometer driver or a generic iio-trig-gpio
(bit low
on configuration options at the mo, but its there in staging) to trigger
the ADC
when the magnetometer says it is supplying the value.  IIO contains support
for small ring buffers (typically 1 page max) which as Ben says often
contain
time stamps though this is up to the adc driver to supply (typically
from any
high resolution timers available).  This timestamping has to be in the
driver as
some devices have a lock and hold, others sample at fixed frequency whereas
others are sample on demand.

i.e

PeriodicTrigger -> Mag (start it going)

MagTrigger (it's indicating it is done) -> ADC read -> Ring buffer in iio

Userspace reads whenever it likes, or waits on events (via chrdev) from ring
(typically 50% full etc) before reading. Which makes sense depends on
application.

Unless that IMU block is doing anything that has to be in kernel space,
I'd move
it out to userspace (computation will be easier with access to floating
put arithmetic
anyway).
> On the gpio interrupt, the driver would read the ADC, and return the
> result to the IMU. Which would then tell the MAG,
> which would send the command, then return. Then gpio interrupt, the
> driver read from the MAG, and return the result to
> the IMU again, which would then store both results in a buffer, until
> an application in user space decide to read it.
>
> I am having trouble writing the Imu <=> Adc and Imu <=> Mag
> communication part, did I got it wrong ?
>
> Best regards,
> Bertrand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

