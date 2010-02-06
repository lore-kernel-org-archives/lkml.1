Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0BFRFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:05:25 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:49945 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0BFRFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:05:23 -0500
Date: Sat, 6 Feb 2010 09:05:21 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
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
Message-ID: <20100206170521.GA9163@ovro.caltech.edu>
References: <4B6C619C.3000302@cam.ac.uk>
 <20100205223224.GL5791@ovro.caltech.edu>
 <4B6D75C5.70404@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6D75C5.70404@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Sat, 06 Feb 2010 09:05:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 01:59:33PM +0000, Jonathan Cameron wrote:
> Hi Ira,
> 
> >> There are probably countless error in here. Please point any out you come
> >> across.  This file may well need breaking up into sysfs-class-iio-in, accel
> >> etc so as to keep it manageable.  Note this is not intended to obey the ABI
> >> spec well.  It will be cleaned up before submission and all the other
> >> required information added.
> >>
> > 
> > How about current and power measurement devices?
> We aren't applying any hard limits to what we will cover by IIO.  At the moment
> the limits tend to be more precisely set by what is not adequately covered else
> where than the other way around.  The other category of things we are including
> tend to require facilities that IIO provides (buffering / event infrastructure)
> that are not provided as is by an apparently more appropriate subsystem and
> where the alternate subsystems.
> 
> For reference, Analog Devices have already suggested they will be using IIO
> for a couple of energy meeting ICs which will have some similarities. 
> 
> https://docs.blackfin.uclinux.org/doku.php?id=adi_peripheral_drivers
> 
> For reference, we have a fairly dirty wiki page for IIO keeping track of devices
> people are working on (or at least have and plan to work on for some of the ones
> I'm listing!)
> 
> http://sourceforge.net/apps/mediawiki/iioutils/index.php?title=Device_List
> 
> As I don't have any equivalent devices in my development set, I'm happy to leave
> those who do to hammer out any relevant details of naming etc as long as the
> result fits nicely with the bits that are already being defined.
> > I have an TI INA209
> Interesting bit of kit.  The rest of my comments are based on a quick data sheet
> browse, so please point out anything I have misunderstood or simply missed!
> > chip which I've written a hwmon driver for, but the hwmon guys don't
> > want to accept the driver upstream for the following reasons, and
> > suggest IIO instead.
> > 
> > 1) it is sensitive enough to measure voltage in uV. This makes a huge
> > difference when calculating current measurements, which I currently do
> > in userspace with lm-sensors. The sense resistor is very likely to have
> > a different value depending on the application the chip is used in. On
> > my board, we have 5 of these chip, with 3 different resistor values.
> To clarify things, do these resistors tend to specified accurately enough
> on a per design basis, or are we at the level where we want to individually
> calibrate individual devices?  The question is relevant to whether it makes
> sense to specify these resistors as platform data or where else these values
> need to be.

On my device, they're very accurate. I think putting them in platform
data would be fine. Right now I specify them in conversions performed by
libsensors. Across my 20 (soon to be 150) boards, the measurements all
agree to within a few mV / mA.

> > 
> > 2) it has "output pin enables". You can program an overcurrent limit
> > into the device. When the current being drawn exceeds this limit, it
> > drives an output pin so the power supply can be shut off quickly. In my
> > case, it is wired to an LTC4215 hot swap controller.
> 
> Interesting setup..  If those output pin enables were routed to standard
> interrupts (which clearly defeats the point!) then we could simply handle
> them as event lines in IIO.  Here we have a rather convoluted situation
> where  they act as hardware triggers of another device.   The first question
> is whether it makes sense to make this know to the operating system, or whether
> we effectively just ignore the physical link and configure the two interactive
> devices appropriately (obviously we need to provide the means to do this!).
> 

Ok, I sort-of lied here. They're really routed through an FPGA state
machine so I can capture other information when they trigger. But you're
correct, putting them on a standard interrupt line defeats the point. I
use the INA209's in high-current power supplies to turn off the power
before burning up big (expensive) data processing FPGA's.

Some info about the board, if you want to have a look:
http://www.mmarray.org/~dwh/carma_board/index.html

> For the rest of this discussion, let us ignore the exact case you have here
> and consider it as a more generic interrupt.  Obviously your current driver
> has support for much if not all of what follows!
> 
> So things this device has:
> 
> * Current measurement.  For this we probably want to match naming with hwmon (no
>   reason not to) with raw and conversion info as per in0_raw etc below.  I note
>   we also have a controllable PGA so some of the conversion factors will be rw.

Yep. This chip's current measurement engine requires programming the
chip with a circuit-specific value before it works. This is the
"calibration register" in the datasheet. Instead of inventing a new
hwmon sysfs attribute for this register, I reported the voltage "at the
pins of the chip" and had libsensors do the conversion in userspace.

> * trigger option for conversion. (IIO handles this fine)

I don't use anything fancy here. I just put the ADC in continuous
measurement mode and let it do its thing.

> * Peak-hold registers.  This one is new to us, so we will need to think of a suitable
>   naming convention, but I'd guess reading these via sysfs will be adequate?

I'd match the hwmon naming here too. They've got tempX_{highest,lowest}
as well as powerX_input_{highest,lowest}. I used inX_input_highest in my
hwmon INA209 driver.

> * Critical comparitor control.  Although much faster, these are basically threshold
>   event detectors so we can use equivalents of the events described below.

Yep, these are the things that turn off the power supplies quickly on
overcurrent conditions. Other than voltage and current measurement, this
is the feature I need most.

> * Lots of filtering controls.  Until we get a feel for how generalizable things like
>   this are, we will keep them driver specific and out of the ABI spec.

Sounds good. I just programmed the filters to a reasonable value that
seems to weed out any problems.

> * The smbus alert stuff should work fine as an event source.  I remember seeing
>   some patches for support in i2c from David Brownell. We probably want to chase
>   these up for this device driver.

I actually don't use SMBAlert at all, since AFAIK it isn't supported
through the Linux i2c stack yet. I see that Jean is working on this. I
do have the SMBAlert lines hooked to generic interrupt lines on my
processor.

> * The single control handling data accuracy 8/10/12bit then averaging may take some thought!
> 

I don't change this either. I just leave it set to the power-on default,
and let the chip run.

> So in conclusion, yes, this device falls within the scope of IIO but there are a number
> of ABI elements that will need discussion.  Feel free to get that discussion going
> here, by proposing the ABI you want!
> 

Thanks for taking the time to respond,
Ira
