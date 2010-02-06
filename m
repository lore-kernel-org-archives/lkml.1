Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0BFN6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 08:58:05 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:48981 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0BFN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:58:00 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B6D75C5.70404@cam.ac.uk>
Date: Sat, 06 Feb 2010 13:59:33 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: Re: [RFC] Staging: IIO: New ABI V2
References: <4B6C619C.3000302@cam.ac.uk> <20100205223224.GL5791@ovro.caltech.edu>
In-Reply-To: <20100205223224.GL5791@ovro.caltech.edu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ira,

>> There are probably countless error in here. Please point any out you come
>> across.  This file may well need breaking up into sysfs-class-iio-in, accel
>> etc so as to keep it manageable.  Note this is not intended to obey the ABI
>> spec well.  It will be cleaned up before submission and all the other
>> required information added.
>>
> 
> How about current and power measurement devices?
We aren't applying any hard limits to what we will cover by IIO.  At the moment
the limits tend to be more precisely set by what is not adequately covered else
where than the other way around.  The other category of things we are including
tend to require facilities that IIO provides (buffering / event infrastructure)
that are not provided as is by an apparently more appropriate subsystem and
where the alternate subsystems.

For reference, Analog Devices have already suggested they will be using IIO
for a couple of energy meeting ICs which will have some similarities. 

https://docs.blackfin.uclinux.org/doku.php?id=adi_peripheral_drivers

For reference, we have a fairly dirty wiki page for IIO keeping track of devices
people are working on (or at least have and plan to work on for some of the ones
I'm listing!)

http://sourceforge.net/apps/mediawiki/iioutils/index.php?title=Device_List

As I don't have any equivalent devices in my development set, I'm happy to leave
those who do to hammer out any relevant details of naming etc as long as the
result fits nicely with the bits that are already being defined.
> I have an TI INA209
Interesting bit of kit.  The rest of my comments are based on a quick data sheet
browse, so please point out anything I have misunderstood or simply missed!
> chip which I've written a hwmon driver for, but the hwmon guys don't
> want to accept the driver upstream for the following reasons, and
> suggest IIO instead.
> 
> 1) it is sensitive enough to measure voltage in uV. This makes a huge
> difference when calculating current measurements, which I currently do
> in userspace with lm-sensors. The sense resistor is very likely to have
> a different value depending on the application the chip is used in. On
> my board, we have 5 of these chip, with 3 different resistor values.
To clarify things, do these resistors tend to specified accurately enough
on a per design basis, or are we at the level where we want to individually
calibrate individual devices?  The question is relevant to whether it makes
sense to specify these resistors as platform data or where else these values
need to be.
> 
> 2) it has "output pin enables". You can program an overcurrent limit
> into the device. When the current being drawn exceeds this limit, it
> drives an output pin so the power supply can be shut off quickly. In my
> case, it is wired to an LTC4215 hot swap controller.

Interesting setup..  If those output pin enables were routed to standard
interrupts (which clearly defeats the point!) then we could simply handle
them as event lines in IIO.  Here we have a rather convoluted situation
where  they act as hardware triggers of another device.   The first question
is whether it makes sense to make this know to the operating system, or whether
we effectively just ignore the physical link and configure the two interactive
devices appropriately (obviously we need to provide the means to do this!).

For the rest of this discussion, let us ignore the exact case you have here
and consider it as a more generic interrupt.  Obviously your current driver
has support for much if not all of what follows!

So things this device has:

* Current measurement.  For this we probably want to match naming with hwmon (no
  reason not to) with raw and conversion info as per in0_raw etc below.  I note
  we also have a controllable PGA so some of the conversion factors will be rw.
* trigger option for conversion. (IIO handles this fine)
* Peak-hold registers.  This one is new to us, so we will need to think of a suitable
  naming convention, but I'd guess reading these via sysfs will be adequate?
* Critical comparitor control.  Although much faster, these are basically threshold
  event detectors so we can use equivalents of the events described below.
* Lots of filtering controls.  Until we get a feel for how generalizable things like
  this are, we will keep them driver specific and out of the ABI spec.
* The smbus alert stuff should work fine as an event source.  I remember seeing
  some patches for support in i2c from David Brownell. We probably want to chase
  these up for this device driver.
* The single control handling data accuracy 8/10/12bit then averaging may take some thought!

So in conclusion, yes, this device falls within the scope of IIO but there are a number
of ABI elements that will need discussion.  Feel free to get that discussion going
here, by proposing the ABI you want!

Jonathan




