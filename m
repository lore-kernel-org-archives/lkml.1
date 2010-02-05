Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab0BEWc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:32:27 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:39066 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab0BEWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:32:26 -0500
Date: Fri, 5 Feb 2010 14:32:24 -0800
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
Message-ID: <20100205223224.GL5791@ovro.caltech.edu>
References: <4B6C619C.3000302@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6C619C.3000302@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 05 Feb 2010 14:32:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 06:21:16PM +0000, Jonathan Cameron wrote:
> Dear All,
> 
> Here is another iteration of the ABI spec for IIO with changes made in response
> to http://lkml.org/lkml/2010/1/20/195 and
> http://marc.info/?l=lm-sensors&m=126496271320649&w=2 along with a few other
> general tidy ups.
> 
> If there are no major issues raised, we may begin working on the move to this
> ABI shortly on the basis any minor changes can always get cleaned up before
> those patches merge.  I'll also be doing a formal version of this file for
> in kernel documentation once things are fairly stable with all of the information
> not relevant to this discussion.
> 
> Changes since v1:
> 
> * iio is now a bus with directory changes resulting in this document.
> * moved to in0_raw etc for voltage sensors to avoid confusion with a completely
>   different ABI from hwmon.  Jean made the point that we shouldn't take this to
>   far, but as things currently stand there is no disadvantage in this name change.
> * dropped freefall event for now. More discussions need to be had on this and in
>   a straight IIO world we normally won't care about this one anyway.
> * 'device' naming changed for the various subsidiary devices so as make the
>   interconnections more obvious.  I haven't tried implementing this yet, but I
>   think the small amount of pain involved is worth it for increased clarity.
>   The only exception is triggers where the connections are not specified as a
>   given trigger may not have and IIO device associated with it.  Anyone suggest
>   a scheme for this? (see about 10 lines below to clarify what I mean here!)
> * As conversion of the max1363 driver over to a consistent scan_element interface
>   will mean that these will only apply to the ring buffer (rather than direct
>   capture), scan_elements is moved into the ring buffer device directory.
> * Switch ring for simply buffer as it might be a fifo or other buffer form instead.
> 
> At times I may have suppressed links that would be created by the tree of 
> devices. In the flat base directory a given driver can now create the following:
> 
> device[n]
> device[n]:ring
> device[n]:ring:access
> device[n]:ring:event
> device[n]:event[m]
> trigger[o]
> 
> Which correspond to
> 
> device[n]
>   device[n]:ring
>      device[n]:ring:access
>      device[n]:ring:event
>   device[n]:event[m]
> 
> trigger[o]
> 
> Hence we still meet the unique naming requirements but have a much clearer
> direct means fo understanding the resulting tree.
> 
> ---
> I have take liberties with not specifying obvious equivalents of scale etc
> for all the channel types.
> 
> 
> There are probably countless error in here. Please point any out you come
> across.  This file may well need breaking up into sysfs-class-iio-in, accel
> etc so as to keep it manageable.  Note this is not intended to obey the ABI
> spec well.  It will be cleaned up before submission and all the other
> required information added.
> 

How about current and power measurement devices? I have an TI INA209
chip which I've written a hwmon driver for, but the hwmon guys don't
want to accept the driver upstream for the following reasons, and
suggest IIO instead.

1) it is sensitive enough to measure voltage in uV. This makes a huge
difference when calculating current measurements, which I currently do
in userspace with lm-sensors. The sense resistor is very likely to have
a different value depending on the application the chip is used in. On
my board, we have 5 of these chip, with 3 different resistor values.

2) it has "output pin enables". You can program an overcurrent limit
into the device. When the current being drawn exceeds this limit, it
drives an output pin so the power supply can be shut off quickly. In my
case, it is wired to an LTC4215 hot swap controller.

Ira

> What:		/sys/bus/iio/devices/device[n]
> Description:
> 		Hardware chip or device accessed by on communication port.
> 		Corresponds to a grouping of sensor channels.
> 
> What:		/sys/bus/iio/devices/trigger[n]
> Description:
> 		An event driven driver of data capture to an in kernel buffer.
> 		May be provided by a device driver that also has an IIO device
> 		based on hardware generated events (e.g. data ready) or
> 		provided by a separate driver for other hardware (e.g.
> 		periodic timer, gpio or high resolution timer).
> 		Contains trigger type specific elements. These do not
> 		generalize well and hence are not documented in this file.
> 
> What:		/sys/bus/iio/devices/device[n]:buffer
> Description:
> 	        Link to /sys/class/iio/device[n]/device[n]:buffer. n indicates the
> 		device with which this buffer buffer is associated.
> 
> What:		/sys/.../device[n]/name
> Description:
> 		Description of the physical chip / device. Typically a part
> 		number.
> 
> What:		/sys/.../device[n]/in[_name][m]_raw
> Description:
> 		Raw (unscaled no bias removal etc) voltage measurement from
> 		channel m. name is used in special cases where this does
> 		not correspond to externally available input (e.g. supply
> 		voltage monitoring in which case the file is in_supply_raw).
> 
> What:		/sys/.../device[n]/in[_name][m]_offset
> Description:
> 		If known for a device, offset to be added to in[m]_raw prior
> 		to scaling by volt[m]_scale in order to obtain voltage in
> 		millivolts.  Not present if the offset is always 0 or unknown.
> 		If m is not present, then voltage offset applies to all in
> 		channels. May be writable if a variable offset is controlled
> 		by the device. Note that this is different to calibbias which
> 		is for devices that apply offsets to compensate for variation
> 		between different instances of the part, typically adjusted by
> 		using some hardware supported calibration procedure.
> 
> What:		/sys/.../device[n]/in[_name][m]_offset_available
> Description:
> 		If a small number of discrete offset values are available, this
> 		will be a space separated list.  If these are independant (but
> 		options the same) for individual offsets then m should not be
> 		present.
> 
> What:		/sys/.../device[n]/in[_name][m]_offset_[min|max]
> Description:
> 		If a more or less continuous range of voltage offsets are supported
> 		then these specify the minimum and maximum.  If shared by all
> 		in channels then m is not present.
> 
> What:		/sys/.../device[n]/in[_name][m]_calibbias
> Description:
> 		Hardware applied calibration offset. (assumed to fix production
> 		inaccuracies)
> 
> What		/sys/.../device[n]/in[_name][m]_calibscale
> Description:
> 		Hardware applied calibration scale factor. (assumed to fix production
> 		inaccuracies)
> 
> What:		/sys/.../device[n]/in[_name][m]_scale
> Description:
> 		If known for a device, scale to be applied to volt[m]_raw post
> 		addition of volt[m]_offset in order to obtain the measured voltage
> 		in millivolts.  If shared across all in channels then m is not present.
> 
> What:		/sys/.../device[n]/in[m]-in[o]_raw
> Description:
> 		Raw (unscaled) differential voltage measurement equivalent to
> 		channel m - channel o where these channel numbers apply to the physically
> 		equivalent inputs when non differential readings are separately available.
> 		In differential only parts, then all that is required is a consistent
> 		labelling.
> 
> What:		/sys/.../device[n]/accel[_x|_y|_z][m]_raw
> Description:
> 		Acceleration in direction x, y or z (may be arbitrarily assigned
> 		but should match other such assignments on device)
> 		channel m (not present if only one accelerometer channel at
> 		this orientation). Has all of the equivalent parameters as per in[m].
> 		Units after application of scale and offset are m/s^2.
> 
> What:		/sys/.../device[n]/gyro[_x|_y|_z][m]_raw
> Description:
> 		Angular velocity about axis x, y or z (may be arbitrarily assigned)
> 		channel m (not present if only one gyroscope at this orientation).
> 		Data converted by application of offset then scale to
> 		radians per second. Has all the equivalent parameters as per in[m].
> 
> What:		/sys/.../device[n]/mag[_x|_y|_z][m]_raw
> Description:
> 		Magnetic field along axis x, y or z (may be arbitrarily assigned)
> 		channel m (not present if only one magnetometer at this orientation).
> 		Data converted by application of offset then scale to Gauss
> 		Has all the equivalent modifiers as per in[m].
> 
> What:		/sys/.../device[n]/device[n]:event[m]
> Description:
> 		Configuration of which hardware generated events are passed up to
> 		userspace. Some of these are a bit complex to generalize so this
> 		section is a work in progress.
> 
> What:		/sys/.../device[n]:event[m]/dev
> Description:
> 		major:minor character device numbers for the event line.
> 
> Taking accel_x0 as an example
> 
> What:		/sys/.../device[n]:event[m]/accel_x0_thresh[_high|_low]
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
> What:		/sys/.../device[n]:event[m]/accel_x0_roc[_high|_low]
> Description:
> 		Same as above but based on the first differential of the value.
> 
> 
> What:		/sys/.../device[n]:event[m]/accel_x0[_thresh|_roc][_high|_low]_period
> Description:
> 		A period of time (microsecs) for which the condition must be broken
> 		before an interrupt is triggered. Applies to all alarms if type is not
> 		specified.
> 
> What:		/sys/.../device[n]:event[m]/accel_x0[_thresh|_roc][_high|_low]_value
> Description:
> 		The actual value of the threshold in raw device units obtained by
> 		 reverse application of scale and offset to the acceleration in m/s^2.
> 
> What:		/sys/.../device[n]:buffer/scan_elements
> Description:
> 		Directory containing interfaces for elements that will be captured
> 		for a single triggered sample set in the buffer.
> 
> What:		/sys/.../device[n]:buffer/scan_elements/[m]_accel_x0_en
> Description:
> 		Scan element control for triggered data capture. m implies the
> 		ordering within the buffer. Next the type is specified with
> 		modifier and channel number as per the sysfs single channel
> 		access above.
> 
> What:		/sys/.../device[n]:buffer/scan_elements/accel[_x0]_precision
> Description:
> 		Scan element precision within the buffer. Note that the
> 		data alignment must restrictions must be read from within
> 		buffer to work out full data alignment for data read
> 		via buffer_access chrdev. _x0 dropped if shared across all
> 		acceleration channels.
> 
> What:		/sys/.../device[n]:buffer/scan_elements/accel[_x0]_shift
> Description:
> 		A bit shift (to right) that must be applied prior to
> 		extracting the bits specified by accel[_x0]_precision.
> 
> What:		/sys/.../device[n]:buffer/device[n]:buffer:event/dev
> Description:
> 		Buffer for device n event character device major:minor numbers.
> 
> What:		/sys/.../device[n]:buffer/device[n]:buffer:access/dev
> Description:
> 		Buffer for device n access character device o major:minor numbers.
> 
> What:		/sys/.../device[n]:buffer/trigger
> Description:
> 		The name of the trigger source being used, as per string given
> 		in /sys/class/iio/trigger[n]/name.
> 
> What:		/sys/.../device[n]:buffer/length
> Description:
> 		Number of scans contained by the buffer.
> 
> What:		/sys/.../device[n]:buffer/bps
> Description:
> 		Bytes per scan.  Due to alignment fun, the scan may be larger
> 		than implied directly by the scan_element parameters.
> 
> What:		/sys/.../device[n]:buffer/enable
> Description:
> 		Actually start the buffer capture up.  Will start trigger
> 		if first device and appropriate.
> 
> What:		/sys/.../device[n]:buffer/alignment
> Description:
> 		Minimum data alignment.  Scan elements larger than this are aligned
> 		to the nearest power of 2 times this.  (may not be true in weird
> 		hardware buffers that pack data well)
> 
> 
> 
> So an example, adis16350
> 
> /sys/bus/iio/devices contains
> 
> device0
> 
>   accel_scale (applies to all accel channels)
>   accel_x_raw (the raw reading)
>   accel_x_calibbias (calibration value - in reg XACCEL_OFF
>   		    accel_x_raw_offset assumed to be 0 so not provided).
>   accel_y_raw
>   accel_y_calibbias
> 
>   accel_z_raw
>   accel_z_calibbias
> 
>   gyro_scale
>   gyro_x_raw
>   gyro_x_calibbias
> 
>   gyro_y_raw
>   gyro_y_calibbias
> 
>   gyro_z_raw
>   gyro_z_calbbias
> 
>   in0_raw
>   in0_scale
>   in_supply_raw
>   in_supply_scale
> 
>   temp_gyrox_raw (These are somewhat unusual!)
>   temp_scale
>   temp_offset
>   temp_gyroy_raw
>   temp_gyroz_raw
> 
>   frequency (applies even when trigger not running, so a device parameter
>   	    rather than one for the data ready trigger)
> 
>   //some stuff that may not generalise...
>   auto_bias_calib
>   auto_bias_calib_precision
>   restore_factory
>   gyro_compensate_accel
>   accel_origin_align
> 
>   device0:buffer/
>     current_trigger
>     device0:buffer:access
>       dev
>     device0:buffer:event
>       dev
>     length
>     bps
>     buffer_enable
>     alignment
>     scan_elements
>       00_in_supply_en
>       01_gyro_x_en
>       02_gyro_y_en
>       03_gyro_z_en
>       04_accel_x_en
>       05_accel_y_en
>       06_accel_z_en
>       07_temp_gyrox_en
>       08_temp_gyroy_en
>       09_temp_gyroz_en
>       10_in0_en
>       gyro_prescision
>       accel_precision
>       in0_precision
>       in_supply_precision
>       temp_precision
>    device0:event0/
>      dev
>      accel_x_thresh_high_en
>      accel_x_thresh_high_value
>      accel_x_thresh_high_period
> 
>      accel_x_thresh_low_en
>      accel_x_thresh_low_value
>      accel_x_thresh_low_period
> 
>      accel_x_roc_high_en
>      accel_x_roc_high_value
>      accel_x_roc_high_period
> 
>      accel_x_roc_low_en
>      accel_x_roc_low_value
>      accel_x_roc_low_period
> 
>      //etc.  This may seem overkill but this the only option that I
>      //can think of that generalizes well.  Other suggestions welcome!
> 
>      //device specific (may generalize)
>      filtered
> 
> 
> trigger0/ (adis16350 is providing a data ready trigger)
>   name
> //there are no other parameters here as the datardy frequency is dependent
> //on how device is configured.
> 
