Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYLAOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYLAOUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYLAOUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:20:09 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:50130 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYLAOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:20:08 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F291.4020001@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:20:01 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>, Jonathan Cameron <jic23@cam.ac.uk>
CC: LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [0/13] RFC: IIO v3 patchset
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

Sorry this has been so long in coming, it has been a busy couple of
months.

Summary of what IIO is about:

The Industrial I/O (name open to suggestions) subsystem is the result
of discussions on LKML about suitable facilities in the kernel for
the handling of Analog to Digital Converters (ADCs) and the huge classes
of sensor that act in similar fashion (digital accelerometers etc). The
intention is that this may also provide a home for DACs as a lot of chips
have both functions. The sort of devices we are talking typically
communicate over I2C or SPI buses though drivers for rs232 devices etc are
definitely on the cards. Basically we are interested in devices where direct
memory mapped access is not possible.

My particular motivation was to produce an adaptable data capture platform
and, seeing as that's what is paying the bills, it has been the initial focus of
my efforts.  The RFCs below include the question of what other facilities should
be included as options in this system.

For discussion of why these don't fit within existing subsystems see 
http://lkml.org/lkml/2008/5/20/135 and the rest of the associated thread.

The design is intended to allow a disparate set of drivers providing whatever
subset of functionality people have uses for. Hence, the intention is that it
is not necessary or even desirable to support as much as the example drivers
provided here. The system is designed to allow everything from simple drivers
providing sysfs based reading of individual channels to the level of complexity
seen in the sca3000 accelerometer driver found in patch 11.
To this end any final submission will include at least one example of a minimal
driver.

I'm still fairly new to kernel coding so have doubtlessly made many mistakes
and non optimal decisions within this code. So, whilst this is intended
primarily to feed a discussion of the overall framework, I would be grateful
to receive any more specific comments on the code! Particularly welcome are
any suggestions that will result in reductions in code length without loss of
functionality as this is still rather larger than would be ideal!

As ever, thanks to the numerous people who commented on the last version posted
and those who have been testing the various intermediate versions (Marcelo Pias
in particular.)

Contents:

[1/13] The Industrial I/O core:
		The core registration and event handling functionality of IIO.

[2/13] The Industrial I/O core - ring buffer support:
		Adds ring buffer handling to the IIO core.

[3/13] IIO: Software ring buffer implementation.
		An example software ring buffer module.

[4/13] The Industrial I/O core - trigger support
		Adds trigger support to the IIO core.

[5/13] IIO: Periodic real time clock based trigger.
		An example of IIO trigger supplying driver.

[6/13] IIO: Proof of concept GPIO based IIO trigger
		A very simple GPIO based trigger suitable for external
		synchronization.

[7/13] IIO: Maxim MAX1363 driver
		Driver for the the MAX1363 ADC chip (core functionality)

[8/13] IIO: Maxim MAX1363 driver (ring buffer support)
		Add triggered software ring buffer support to the driver

[9/13] IIO: ST LIS3L02DQ 3d accelerometer driver via SPI (core)
		Driver for the ST LIS3L02DQ accelerometer (SPI only)

[10/13] IIO: ST LIS3L02DQ 3d accelerometer driver via SPI (ring)
		Add triggered software ring buffer support and a data
		ready based trigger to the device.

[11/13] IIO: VTI SCA3000 3d accelerometer driver.
		Driver for the VTI SCA3000 range of accelerometers.

[12/13] IIO: Documentation
		Whilst most documentation related to IIO is contained
		as kernel doc comments within the source code, a brief
		overview of what it does and discussions of elements
		of individual drivers are provided in
		Documentation/industrialio.

[13/13] IIO: Example user space ring buffer access.
		Simple example program to illustrate how a user space
		application can interact with the ring buffer
		functionality of IIO (this includes event handling).
		The example used uses the datardy trigger of the
		lis3l02dq to drive the filling of a software ring buffer
		from the lis3l02dq device.

Overview of changes:

* Introduction of trigger drivers to allow more flexible sampling
  strategies and separate out the periodic RTC element (as only
  one example of a trigger driver.) New triggers provided as example
  / proofs of concept are GPIO based for external sync and data ready
  on the lis3l02dq (to act as example of a unified iio:trigger /
  iio:device driver)

* Far more modular design:
  - The core now acts as a registration system providing sysfs class
    handling and registration of chrdevs. The registration is relatively
    heavy weight pulling in other core elements such as ring buffers
    as appropriate.
  - Ring buffers are now an optional element (compile to near zero)
    if not enabled. Intention is that it will be possible to select
    most appropriate implementation at run time though for now this
    is hard coded in the drivers (as there is only one software
    implementation)
  - Separate library module provides a fairly generic ring buffer
    implementation.
  - Drivers are now spit into core component (direct access to channels
    and event chrdevs) and ring buffer related code.
  - The intention is that, if appropriate, other additional optional
    elements will be provided via a similar approach.  This would include
    interfacing to hwmon and input subsystems.
  - Hopefully this will make code review a much simpler exercise than
    the behemoth patches sent last time!

Requests for comment:

Big general question - Is it sensible to try and have unified drivers
providing all functionality users may want from a given sensor chip?
This came up in the previous discussion but I'm still not sure we have
a definitive answer. Basically, is it sensible to have the iio-core
provide hwmon interfaces (for devices that are used as such complete
with caching etc) or input interfaces (for things like accelerometers
that are increasingly used as input devices.)
It would be difficult to say the least to run these at the same time as
for example the ring buffering elements.

Is it worthwhile allowing multiple triggers for single device?  This may
greatly increase the individual driver complexity and not actually be that
useful.

Devices supplied triggers.  These may be used to trigger other devices. Tricky
to set this up unless they are already set to trigger themselves. A clean
means of specifying restrictions on trigger / device associations is needed.

Consider optimal approach to configuring scan modes.
 * Somewhat clunky approach used with max1363 - basically associate formalized
   text label with each scan mode.  Somewhat chip specific approach.

 * Scan element selection as in lis3l02dq and sca3000 drivers.
   Selectable sysfs elements represent each signal that is available.
   Works well in this case where any combination is possible but complex in the
   cases with exclusion problems such as unipolar and bipolar for the max1363.
   Also nasty search functionality and masking of results would be needed to
   apply this to chips like the max1363 where not every combination is
   directly possible.

Whilst it would be nice to clean this up, perhaps enforcing two rigid a set
of rules here will just lead to fiddly unmaintainable code.  Maybe one to
reconsider down the line when many more device drivers are available to
consider.

There are numerous RFCs concerned with more specific questions within the
various patches.

TO DO:

There are still quite a few elements that I know need cleaning up in this
code some of which are listed here.

Protection on many of the control interfaces. In some cases this will require
input via board configs.  For example the maximum sampling rate of a sensor
is often limited by a complex interaction of bus speed and available
processing power. The easiest option would be to allow board configuration
data to specify limits that the developer has tested and verified to give
reasonable performance.

Provision of static sysfs elements to make things like conversion factors
available in as generic a form as possible.

Drivers are all currently missing things like power management support which
will ideally be in place before final submission.

Other drivers in development:

Analog Devices ADIS16350 inertial measurement unit.

Illustration of sysfs Interface:

This is just intended to give an idea of what is available for a typical
driver (lis3l02dq) under /sys/class/industrialio/ (There some RFCs after)

 ls -R industrialio/
industrialio/:
iio:device0   iio:trigger0

industrialio/iio:device0:
accel_x                       event_line0_sources
accel_x_gain                  name
accel_x_offset                power
accel_y                       ring_buf0_acc_minor
accel_y_gain                  ring_buf0_ev_minor
accel_y_offset                ring_buffer
accel_z                       sampling_frequency
accel_z_gain                  scan_elements
accel_z_offset                subsystem
available_sampling_frequency  thresh
device                        trigger
event_line0_minor             uevent

industrialio/iio:device0/event_line0_sources:
accel_x_high  accel_y_high  accel_z_high
accel_x_low   accel_y_low   accel_z_low

industrialio/iio:device0/power:
wakeup

industrialio/iio:device0/ring_buffer:
bps          length       ring_enable

industrialio/iio:device0/scan_elements:
scan_en_accel_x    scan_en_accel_y    scan_en_accel_z    scan_en_timestamp

industrialio/iio:device0/trigger:
current_trigger

industrialio/iio:trigger0:
device     name       power      subsystem  uevent

industrialio/iio:trigger0/power:
wakeup

RFC (on sysfs subsystem):

Add an interface under the trigger to list which devices have it set
as their 'current_trigger'? (useful for debugging if nothing else).
Clearly this particular trigger driver only provides a name element.

Directory structure: Basically any suggestions for a more coherent
and intuitive structure would be welcomed.

All other comments welcomed!

--
Jonathan Cameron
