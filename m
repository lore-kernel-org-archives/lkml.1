Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793Ab0ATPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0ATPNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534Ab0ATPNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:13:42 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:40300 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0ATPNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:13:41 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B571DA4.6070603@cam.ac.uk>
Date: Wed, 20 Jan 2010 15:13:40 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>, Greg KH <greg@kroah.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: [RFC] Staging:IIO: New ABI
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

An extensive conversation with Manuel Stahl that grew out of his
work on an ADIS16400 driver and the userspace IIO tools at
iioutils.sourceforge.net showed that there were a number of
significant short comings in the current IIO ABI.  Some of these
were simply things that have never been pinned down, others
are down to silly issues with how the code has developed.

Hence Manuel and I have drawn up a new ABI specification.
With hindsight we should probably have held the entire 
conversation publicly but this document will hopefully
act as summary.

Please forgive the flagrant abuse of syntax in large parts
of this file.  This will all be cleaned up before a formal
submission.  At this stage what we are after is comments on
the actual IIO sysfs ABI.  There are doubtlessly unclear sections
and elements we have forgotten completely so if you know of
something that is missing (along with a concrete example
of where it is needed, please do point it out!)

To avoid an insanely long ABI spec, I've suppressed fields
that are not of interest to this discussion and not specified
some items that are similar in purpose to those given for
volt channels.

All comments welcome. One area of extreme complexity currently
is that of event handling and specifically how come up with
a consistent generalizable specification when there are so
many different options. Comments / suggestions on this are
particularly welcome!

As ever, if people could forward / cc anyone how they think
may be interested that would be great.  The current cc list
is based on a fairly rapid dash through previous threads.

What:		/sys/class/iio/device[n]
Description:
		Hardware chip or device accessed by on communication port.
		Corresponds to a grouping of sensor channels.

What:		/sys/class/iio/trigger[n]
Description:
		An event driven driver of data capture to an in kernel buffer.
		May be provided a device driver that also has an IIO device
		based on hardware generated events (e.g. data ready) or
		provided by other hardware (e.g. periodic timer or gpio)
		Contains trigger type specific elements. These do not
		generalize well.


What:        /sys/class/iio/ring_buffer[m]
Description:
	        Link to /sys/class/iio/device[n]/ring_buffer[m]. Ring buffer
		numbering may not match that of device as some devices do not
		have ring buffers.

What:		/sys/class/iio/device[n]/name
Description:
		Description of the physical chip / device. Typically a part
		number.

What:		/sys/class/iio/device[n]/volt_[name][m]_raw
Description:
		Raw (unscaled no bias removal etc) voltage measurement from
		channel m. name is used in special cases where this does
		not correspond to externally available input (e.g. supply
		voltage monitoring).

What:		/sys/class/iio/device[n]/volt_[name][m]_offset
Description:
		If known for a device, offset to be added to volt[m]_raw prior
		to scaling by volt[m]_scale in order to obtain voltage in
		Volts.  Not present if the offset is always 0 or unknown.
		If m is not present, then voltage offset applies to all volt
		channels. May be writable if a variable offset is controlled
		by the device. Note that this is different to calibbias which
		is for devices that apply offsets to compensate for variation
		between different instances of the part.

What:		/sys/class/iio/device[n]/volt_[name][m]_offset_available
Description:
		If a small number of discrete offset values are available, this
		will be a space separated list.  If these are independant (but
		options the same) for individual offsets then m should not be
		present.

What:		/sys/class/iio/device[n]/volt_[name][m]_offset_[min|max]
Description:
		If a more or less continuous range of voltage offsets are supported
		then this specifies the minimum / maximum.  If shared by all
		volt channels then m is not present.

What:		/sys/class/iio/device[n]/volt_[name][m]_calibbias
Description:
		Hardware applied calibration offset. (assumed to fix production
		inaccuracies)

What		/sys/class/iio/device[n]/volt_[name][m]_calibscale
Description:
		Hardware applied calibration scale factor. (assumed to fix production
		inaccuracies)

What:		/sys/class/iio/device[n]/volt_[name][m]_scale
Description:
		If known for a device, scale to be applied to volt[m]_raw post
		addition of volt[m]_offset in order to obtain the measured voltage
		in volts.  If shared across all voltage	channels the m is not present.

What:		/sys/class/iio/device[n]/accel_[x|y|z][m]_raw
Description:
		Acceleration in direction x, y or z (may be arbitrarily assigned
		but should match other such assignments on device)
		channel m (not present if only one accelerometer channel at
		this orientation). Has all of the equivalent parameters as per volt[m].
		Units after application of scale and offset are m/s^2.

What:		/sys/class/iio/device[n]/gyro_[x|y|z][m]_raw
Description:
		Angular velocity about axis x,y or z (may be arbitrarily assigned)
		channel m (not present if only one gyroscope at this orientation).
		Data converted by application of offset then scale to
		radians per second. Has all the equivalent parameters as per volt[m].

What:		/sys/class/iio/device[n]/mag_[x|y|z][m]_raw
Description:
		Magnetic field along axis x, y or z (may be arbitrarily assigned)
		channel m (not present if only one magnetometer at this orientation).
		Data converted by application of offset then scale to Gauss
		Has all the equivalent modifiers as per volt[m].

What:		/sys/class/iio/device[n]/pressure[m]_raw
Description:
		Barometric pressure

//Lots more to add along a similar vain.


What:		/sys/class/iio/device[n]/event_line[m]
Description:
		Configuration of which hardware generated events are passed up to
		userspace. Some of these are a bit complex to generalize so this
		section is a work in progress.

What:		/sys/class/iio/device[n]/event_line[m]/dev
Description:
		major:minor character device numbers.

Again taking accel_x0 as example and serious liberties with ABI spec.

What:		/sys/.../event_line[m]/accel_x0_thresh[_high|_low]
Description:
		Event generated when accel_x0 passes a threshold in correction direction
		(or stays beyond one). If direction isn't specified, either triggers it.
		Note driver will assume last p events requested are enabled where p is
		however many it supports.  So if you want to be sure you have
		set what you think you have, check the contents of these. Drivers
		may have to buffer any parameters so that they are consistent when a
		given event type is enabled a future point (and not those for whatever
		alarm was previously enabled).

What:		/sys/.../event_line[m]/accel_x0_roc[_high|_low]
Description:
		Same as above but based on the first differential of the value.


What:		/sys/.../event_line[m]/accel_x0[_thresh|_roc][_high|_low]_period
Description:
		A period of time (microsecs) for which the condition must be broken
		before an interrupt is triggered. Applies to all alarms if type is not
		specified.

What:		/sys/.../event_line[m]/accel_x0[_thresh|_roc][_high|_low]_value
Description:
		The actual value of the threshold either in raw device units
		obtained by reverse application of scale and offfset to the
		acceleration in m/s^2.

What:		/sys/.../event_line[m]/free_fall
Description:
		Common hardware event in accelerometers. Takes no parameters.

There are many other weird and wonderful event types that we'll deal with as and when.


Taking accel_x0 for example of next section.

What:		/sys/class/iio/device[n]/scan_elements/[m]_accel_x0_en
Description:
		Scan element control for triggered data capture. m implies the
		ordering within the buffer. Next the type is specified with
		modifier and channel number as per the sysfs single channel
		access above.

What:		/sys/class/iio/device[n]/scan_elements/accel[_x0]_precision
Description:
		Scan element precision within the ring buffer. Note that the
		data alignment must restrictions must be read from in
		ring_buffer to work out full data alignment for data read
		via ring_access chrdev. _x0 dropped if shared across all
		acceleration channels.

What:		/sys/class/iio/device[n]/scan_elements/accel[_x0]_shift
Description:
		A bit shift (to right) that must be applied prior to
		extracting the bits specified by accel[_x0]_precision.

What:		/sys/class/iio/device[n]/ring_buffer[m]
Description:
		Ring buffer specific parameters separate. Some are influenced
		by scan_elements.

What:		/sys/.../ring_buffer[m]/ring_event[o]/dev
Description:
		Ring buffer m event character device o major:minor numbers.

What:		/sys/.../ring_buffer[m]/ring_access[o]/dev
Description:
		Ring buffer m access character device o major:minor numbers.

What:		/sys/.../ring_buffer[m]/trigger
Description:
		The name of the trigger source being used, as per string given
		in /sys/class/iio/trigger[n]/name.

What:		/sys/.../ring_buffer[m]/length
Description:
		Number of scans contained by the buffer.

What:		/sys/.../ring_buffer[m]/bps
Description:
		Bytes per scan.  Due to alignment fun, the scan may be larger
		than implied directly by the scan_element parameters.

What:		/sys/.../ring_buffer[m]/enable
Description:
		Actually start the ring buffer capture up.  Will start trigger
		if first device and appropriate.

What:		/sys/.../ring_buffer[m]/alignment
Description:
		Minimum data alignment.  Scan elements larger than this are aligned
		to the nearest power of 2 times this.  (may not be true in weird
		hardware ring buffers that pack data well)



So an example, adis16350

/sys/class/iio contains

device0

  accel_scale (applies to all accel channels)
  accel_x_raw (the raw reading)
  accel_x_calibbias (calibration value - in reg XACCEL_OFF
  		    accel_x_raw_offset assumed to be 0 so not provided).
  accel_y_raw
  accel_y_calibbias

  accel_z_raw
  accel_z_calibbias

  gyro_scale
  gyro_x_raw
  gyro_x_calibbias

  gyro_y_raw
  gyro_x_calibbias

  gyro_z_raw
  gyro_z_calbbias

  volt_0_raw
  volt_0_scale
  volt_supply_raw
  volt_supply_scale

  temp_gyrox_raw (These are somewhat unusual!)
  temp_scale
  temp_offset
  temp_gyroy_raw
  temp_gyroz_raw

  frequency (applies even when trigger not running)

  //some stuff that may not generalise...
  auto_bias_calib
  auto_bias_calib_precision
  restore_factory
  gyro_compensate_accel
  accel_origin_align

  //associated trigger can be navigated to via device directory.  Also the default
  //trigger will be set correctly.  Not in ring_buffer as that directory may become
  //dependent on live configurable ring buffer types. (spurious argument?)
  trigger/
    current_trigger

  ring_buffer0/
    ring_access0
      dev
    ring_event0
      dev
    length
    bps
    ring_enable
    alignment
    scan_elements
      00_volt_supply_en
      01_gyro_x_en
      02_gyro_y_en
      03_gyro_z_en
      04_accel_x_en
      05_accel_y_en
      06_accel_z_en
      07_temp_gyrox_en
      08_temp_gyroy_en
      09_temp_gyroz_en
      10_volt_0_en
      gyro_prescision
      accel_precision
      volt_0_precision
      volt_supply_precision
      temp_precision
   event_line0/
     dev
     accel_x_thresh_high_en
     accel_x_thresh_high_value
     accel_x_thresh_high_period

     accel_x_thresh_low_en
     accel_x_thresh_low_value
     accel_x_thresh_low_period

     accel_x_roc_high_en
     accel_x_roc_high_value
     accel_x_roc_high_period

     accel_x_roc_low_en
     accel_x_roc_low_value
     accel_x_roc_low_period

     //etc.  This may seem overkill but this the only option that I
     //can think of that generalizes well.  Other suggestions welcome!
	
     //device specific (may generalize)
     filtered


trigger0/ (adis16350 is providing a data ready trigger)
  name
//there are no other parameters here as the datardy frequency is dependent
//on how device is configured. (I think it makes more sense in device).
