Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915Ab0ATPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0ATPhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682Ab0ATPhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:37:45 -0500
Received: from kroah.org ([198.145.64.141]:39132 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0ATPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:37:44 -0500
Date: Wed, 20 Jan 2010 07:37:48 -0800
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
Message-ID: <20100120153748.GA29401@kroah.com>
References: <4B571DA4.6070603@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B571DA4.6070603@cam.ac.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:13:40PM +0000, Jonathan Cameron wrote:
> What:		/sys/class/iio/device[n]
> Description:
> 		Hardware chip or device accessed by on communication port.
> 		Corresponds to a grouping of sensor channels.
> 
> What:		/sys/class/iio/trigger[n]
> Description:
> 		An event driven driver of data capture to an in kernel buffer.
> 		May be provided a device driver that also has an IIO device
> 		based on hardware generated events (e.g. data ready) or
> 		provided by other hardware (e.g. periodic timer or gpio)
> 		Contains trigger type specific elements. These do not
> 		generalize well.
> 
> 
> What:        /sys/class/iio/ring_buffer[m]
> Description:
> 	        Link to /sys/class/iio/device[n]/ring_buffer[m]. Ring buffer
> 		numbering may not match that of device as some devices do not
> 		have ring buffers.

Why is this link needed?  Why can't you just look in the device
directory for a ring buffer?  And wouldn't the ring buffer be 1..n for
every device?  They shouldn't be "unique" for all iio devices, that
would be wierd.

> What:		/sys/class/iio/device[n]/name
> Description:
> 		Description of the physical chip / device. Typically a part
> 		number.
> 
> What:		/sys/class/iio/device[n]/volt_[name][m]_raw
> Description:
> 		Raw (unscaled no bias removal etc) voltage measurement from
> 		channel m. name is used in special cases where this does
> 		not correspond to externally available input (e.g. supply
> 		voltage monitoring).

So what would 'name' be?

> What:		/sys/class/iio/device[n]/volt_[name][m]_offset
> Description:
> 		If known for a device, offset to be added to volt[m]_raw prior
> 		to scaling by volt[m]_scale in order to obtain voltage in
> 		Volts.  Not present if the offset is always 0 or unknown.
> 		If m is not present, then voltage offset applies to all volt
> 		channels. May be writable if a variable offset is controlled
> 		by the device. Note that this is different to calibbias which
> 		is for devices that apply offsets to compensate for variation
> 		between different instances of the part.
> 
> What:		/sys/class/iio/device[n]/volt_[name][m]_offset_available
> Description:
> 		If a small number of discrete offset values are available, this
> 		will be a space separated list.  If these are independant (but
> 		options the same) for individual offsets then m should not be
> 		present.
> 
> What:		/sys/class/iio/device[n]/volt_[name][m]_offset_[min|max]
> Description:
> 		If a more or less continuous range of voltage offsets are supported
> 		then this specifies the minimum / maximum.  If shared by all
> 		volt channels then m is not present.
> 
> What:		/sys/class/iio/device[n]/volt_[name][m]_calibbias
> Description:
> 		Hardware applied calibration offset. (assumed to fix production
> 		inaccuracies)
> 
> What		/sys/class/iio/device[n]/volt_[name][m]_calibscale
> Description:
> 		Hardware applied calibration scale factor. (assumed to fix production
> 		inaccuracies)
> 
> What:		/sys/class/iio/device[n]/volt_[name][m]_scale
> Description:
> 		If known for a device, scale to be applied to volt[m]_raw post
> 		addition of volt[m]_offset in order to obtain the measured voltage
> 		in volts.  If shared across all voltage	channels the m is not present.

For all of these voltage measurements, why use something different from
what the kernel already supports for the existing hardware monitoring
devices?  There is already a well-defined api for these things.

> What:		/sys/class/iio/device[n]/accel_[x|y|z][m]_raw
> Description:
> 		Acceleration in direction x, y or z (may be arbitrarily assigned
> 		but should match other such assignments on device)
> 		channel m (not present if only one accelerometer channel at
> 		this orientation). Has all of the equivalent parameters as per volt[m].
> 		Units after application of scale and offset are m/s^2.

Shouldn't this just use the existing input accelerometer interface so as
to keep userspace sane?

> What:		/sys/class/iio/device[n]/gyro_[x|y|z][m]_raw
> Description:
> 		Angular velocity about axis x,y or z (may be arbitrarily assigned)
> 		channel m (not present if only one gyroscope at this orientation).
> 		Data converted by application of offset then scale to
> 		radians per second. Has all the equivalent parameters as per volt[m].

Same as above, I think we already have an api for this.

> What:		/sys/class/iio/device[n]/mag_[x|y|z][m]_raw
> Description:
> 		Magnetic field along axis x, y or z (may be arbitrarily assigned)
> 		channel m (not present if only one magnetometer at this orientation).
> 		Data converted by application of offset then scale to Gauss
> 		Has all the equivalent modifiers as per volt[m].
> 
> What:		/sys/class/iio/device[n]/pressure[m]_raw
> Description:
> 		Barometric pressure
> 
> //Lots more to add along a similar vain.

Again, look at the existing apis, if we don't have the exiting units and
types, we can always add them, instead of making up new ones burried in
the iio class stuff.

> What:		/sys/class/iio/device[n]/event_line[m]
> Description:
> 		Configuration of which hardware generated events are passed up to
> 		userspace. Some of these are a bit complex to generalize so this
> 		section is a work in progress.
> 
> What:		/sys/class/iio/device[n]/event_line[m]/dev
> Description:
> 		major:minor character device numbers.

No, don't bury devices down a level in sysfs, that's not ok.  Actually,
I think it would take you a lot of work to get this to properly work on
the implementation side :)

If event_lines need device nodes, then they should be real devices.

Actually, all of this looks like it needs to be a bus, not a class, if
you are having this many different types of things hanging off of them.
Have you thought about that instead?  It would make your code a lot
easier in the end.

> Again taking accel_x0 as example and serious liberties with ABI spec.
> 
> What:		/sys/.../event_line[m]/accel_x0_thresh[_high|_low]
> Description:
> 		Event generated when accel_x0 passes a threshold in correction direction
> 		(or stays beyond one). If direction isn't specified, either triggers it.
> 		Note driver will assume last p events requested are enabled where p is
> 		however many it supports.  So if you want to be sure you have
> 		set what you think you have, check the contents of these. Drivers
> 		may have to buffer any parameters so that they are consistent when a
> 		given event type is enabled a future point (and not those for whatever
> 		alarm was previously enabled).
> 
> What:		/sys/.../event_line[m]/accel_x0_roc[_high|_low]
> Description:
> 		Same as above but based on the first differential of the value.
> 
> 
> What:		/sys/.../event_line[m]/accel_x0[_thresh|_roc][_high|_low]_period
> Description:
> 		A period of time (microsecs) for which the condition must be broken
> 		before an interrupt is triggered. Applies to all alarms if type is not
> 		specified.
> 
> What:		/sys/.../event_line[m]/accel_x0[_thresh|_roc][_high|_low]_value
> Description:
> 		The actual value of the threshold either in raw device units
> 		obtained by reverse application of scale and offfset to the
> 		acceleration in m/s^2.

Again, look at our existing apis, I think we already cover these types
of things, don't create new ones please.

> What:		/sys/.../event_line[m]/free_fall
> Description:
> 		Common hardware event in accelerometers. Takes no parameters.

I know we have this one already, please use it.

> There are many other weird and wonderful event types that we'll deal with as and when.
> 
> 
> Taking accel_x0 for example of next section.
> 
> What:		/sys/class/iio/device[n]/scan_elements/[m]_accel_x0_en
> Description:
> 		Scan element control for triggered data capture. m implies the
> 		ordering within the buffer. Next the type is specified with
> 		modifier and channel number as per the sysfs single channel
> 		access above.
> 
> What:		/sys/class/iio/device[n]/scan_elements/accel[_x0]_precision
> Description:
> 		Scan element precision within the ring buffer. Note that the
> 		data alignment must restrictions must be read from in
> 		ring_buffer to work out full data alignment for data read
> 		via ring_access chrdev. _x0 dropped if shared across all
> 		acceleration channels.
> 
> What:		/sys/class/iio/device[n]/scan_elements/accel[_x0]_shift
> Description:
> 		A bit shift (to right) that must be applied prior to
> 		extracting the bits specified by accel[_x0]_precision.
> 
> What:		/sys/class/iio/device[n]/ring_buffer[m]
> Description:
> 		Ring buffer specific parameters separate. Some are influenced
> 		by scan_elements.
> 
> What:		/sys/.../ring_buffer[m]/ring_event[o]/dev
> Description:
> 		Ring buffer m event character device o major:minor numbers.

Again, don't bury devices.  Or if you are, use a bus, not a class,
that's the wrong classification.

thanks,

greg k-h
