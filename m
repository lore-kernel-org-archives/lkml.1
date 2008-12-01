Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYLAOiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYLAOiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYLAOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:38:13 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:42882 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYLAOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:38:12 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F6D0.3080900@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:38:08 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [12/13] RFC: IIO Documentation
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

The Industrial I/O Documentation.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--

This patch provides some documentation for the industrial I/O (IIO)
subsystem. Much of the documentation is as kernel-doc comments
within the code, but an overview is provided here along with
some specific details of ring buffering and the max1363 driver.

 Documentation/industrialio/iio_ring.txt |   90 +++++++++++++++++++++++++++++++
 Documentation/industrialio/max1363.txt  |   37 +++++++++++++
 Documentation/industrialio/overview.txt |   76 ++++++++++++++++++++++++++
 3 files changed, 203 insertions(+), 0 deletions(-)

diff --git a/Documentation/industrialio/iio_ring.txt b/Documentation/industrialio/iio_ring.txt
new file mode 100644
index 0000000..410a552
--- /dev/null
+++ b/Documentation/industrialio/iio_ring.txt
@@ -0,0 +1,90 @@
+Industrialio subsystem ring buffers
+
+The industrial io subsystem supports both hardware (eg. sca3000) and software
+(eg. max1363 and lis3l02dq) ring buffers.
+
+For both types a chrdev is used to provide events to userspace. These merely
+contain an id and a timestamp.
+
+This is used to provide notifications of the ring having reached a certain level
+(50%, 75%, 100%).
+
+Direct access to the contents of the ring buffer is available via a second
+chrdev.  The data output is pretty much raw device readings, so a userspace
+function is needed to convert these into appropriate SI units.  This function
+should be provided in a device specific header if appropriate.
+
+The hardware ring buffer simply implements the above functionality by pulling
+data directly from the device on demand (sca3000).
+
+The software ring buffer is somewhat more complex.
+
+The design considerations for this are:
+
+1) Writing should be as latency free as possible (preferably lock free)
+2) As few samples as possible should be missed (ideally none - but as
+   we aren't dealing with a realtime OS some will occasionally be lost).
+3) Reading does not lock the buffer but instead takes a copy then validate
+   what data is definitely good approach.
+4) The filling of the buffer should be either driver by the device (datardy)
+   or if that is not possible via a periodic time source.
+5) All latencies should be as small as possible (wishful thinking ;)
+
+The code in industrialio-ring.c meets most of these requirements and hopefuly
+does not have any critical failure cases.
+
+A number of pointers into a static array are maintained.
+
+write_p - the next location to write to.
+read_p - the oldest location from which we may read (start point for copying)
+last_written_p - the newest location from which we may read (used to provide
+	       direct access whilst the ring buffer is in use, without adding
+	       to the communications with the sensor.
+
+half_p - Kept half the length of the buffer behind the write pointer and used
+       in conjunction with read_p to trigger an event when the buffer is half
+       full.
+
+The events are designed to escalate until we reach the point of buffer 100%
+full. Thus a single event has it's code changed when it becomes outdated.
+
+The other interesting bit is reading data from the ring. Currently this is via
+normal file reads rather than mmaping the ring buffer.
+
+1) A copy of the ring buffer between read_p and write_p is made.  This is done
+without locking the buffer in anyway so the data is not guaranteed to have not
+been changed by subsequent writes.
+
+2) The value of read_p after the copy is used to provide a worst case location
+for where we have clean data from.  There is an obvious nasty case of the read
+pointer having wrapped all the way round the buffer. For now we assume the
+capture rate is slow enough that this will not have happened.
+
+Only the valid data is then sent to userspace.
+
+What the iio_dev ring parameters are
+
+@ring_bytes_per_datum Number of bytes per 'reading', this includes timestamp
+
+@ring_length Number of readings in the ring
+
+The four functions are concerned with behaviour around the point where the
+device mode actually switches.
+@ring_preenable - usually things like disabling unwanted (sensor side)
+		interrupts.
+
+@ring_postenable - usually actually enabling the data ready generation if
+		 appropriate.
+
+@ring_predisable - usually disabling data ready generation
+@ring_postdisable - restoring anything disable before the the ring came into
+		  use.
+
+@ring_poll_func - For perioidic timer based rings, this function is called on
+		each timer interrupt. Reads from the device and pushes the
+		data into the ring. Also tends to grab a timestamp at the
+		point likely to be as close as possible to when the data
+		was acquired. Sensor specific offsets can compensate for
+		some fixed lags (particularly at low bus speeds).
+
+More information is available in <linux/industrialio/ring_generic.h>
diff --git a/Documentation/industrialio/max1363.txt b/Documentation/industrialio/max1363.txt
new file mode 100644
index 0000000..ad388d9
--- /dev/null
+++ b/Documentation/industrialio/max1363.txt
@@ -0,0 +1,37 @@
+
+Documentation for the max1363 industrialio driver via i2c interface.
+
+This driver has been tested with max1363 and max1238 chips.
+
+Please report any problems / success in using with other chips.
+
+Supported chips
+
+With monitor and smbus alert.
+
+max1361, max1362 - 10 bit versions
+max1363, max1364 - 12 bit versions
+
+Simple
+max1136, max1137 - 4 channel 10 bit versions
+max1138, max1139 - 12 channel 10 bit versions
+
+max1236, max1237 - 4 channel 12 bit versions
+max1238, max1239 - 12 channel 12 bit versions.
+
+
+May add support for the following in the future:
+
+* max103{6-9} - 8 bit versions. Obviously the read code will be somewhat
+simpler for these.
+
+* max1069, max1169 - 14, 16 bit single channel i2c adapters.
+
+Please point out any other similar devices - or even better submit a patch
+adding support.
+
+Probably not similar enough to support via the same driver:
+
+* max127, max128 - multirange 8 channel adc's.
+
+* max1153,max1154,max1253 and max1254 - more complex devices.
diff --git a/Documentation/industrialio/overview.txt b/Documentation/industrialio/overview.txt
new file mode 100644
index 0000000..6dae28d
--- /dev/null
+++ b/Documentation/industrialio/overview.txt
@@ -0,0 +1,76 @@
+Overview of the industrialio subsystem.
+
+Main Components
+
+Currently the industrial I/O subsystem has a core component which is used by
+all drivers and 2 optional components.
+
+The first of these provides the infrastructure used by ring buffer drivers.
+These ring buffers can either exit in software (handled by the kernel) or
+as elements of the hardware to which IIO is interfacing.
+
+The second main component is concerned with IIO triggers. These triggers
+are effectively an interrupt handling interface that allows run time
+configuration of what occurs on a particular interrupt.
+
+Core
+
+industrialio-core.c contains the main registration code for devices using the
+subsytem. The key function is
+
+int iio_device_register(struct iio_dev *dev_info);
+
+This takes a structure containing a number of user specified variables which
+control how the device driver interacts with the subsystem components.
+
+For documentation of this see <linux/industrialio/iio.h> in which all
+relevant parameters are described.
+
+What happens when a iio_dev is registered.
+
+1) Unique id obtained.
+2) Sysfs direct read and configuration elements registered.
+3) Device event (sensor interrupts) registered.
+4) If software ring to be used, setup the ring but don't actually allocate.
+   This occurs on first enabled / when reenabled after parameter change.
+4) If triggered ring then register the fact this is a trigger consumer.
+   Some but not all device drivers will which to specify a default trigger
+   (typcially the devices own data ready signal).
+
+
+Ring Buffer
+
+industrialio-ring.c provides the registration and access architecture
+common to all IIO ring buffer implementations. What actually happens on
+calls to ring buffer functionality is handled via a number of functions
+supplied by individual drivers (see <linux/industrialio/ring_generic.h>
+ring_sw is an example of a software ring buffer using this architecture
+and the sca3000 driver contrains an example of interfacing with a hardware
+ring buffer using much the same framework (an awful lot of which is
+optional)  More detail in iio_ring.txt.
+
+Triggers
+
+industrialio-trigger.c provides the registration and access architecture
+common to IIO triggers.  These triggers act as a means to drive one or more
+device functions (on any number of devices.) Currently they are restricted
+in the drivers to causing data to be sampled (or in case of data ready
+signals aquire that data that we are being notified about) and then pushed
+to a ring buffer. 
+
+Examples of triggers include 
+
+2 non device specific cases:
+
+iio-trig-gpio which allows the use of an external sync signal via the
+generic GPIO infrastructure
+
+iio-trig-prtc which uses available real time clocks that are capable of
+periodic interrupts to provide regular sampling of data.
+
+Many hardware devices that operate on internal clocks produce data ready
+signals and the lis3l02dq driver provides an example of using this signal
+as an IIO trigger.  Note the complexities this causes if other devices
+want to use it by the lis3l02dq itself does not (clearing data ready does
+not occur).
+
