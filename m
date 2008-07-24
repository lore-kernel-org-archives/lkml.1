Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYGXR5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYGXR5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYGXR5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:57:20 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:56076 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYGXR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:57:18 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4888C284.50006@gmail.com>
Date: Thu, 24 Jul 2008 18:57:24 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>
CC: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [Patch 5/4] IndustrialIO subsystem very early cut of documentation
 + userspace demo
References: <488763AD.4050400@gmail.com>
In-Reply-To: <488763AD.4050400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

A very early cut of some documentation for the industrialio subsystem. Also
includes a small demo app for listening to a ring buffer event chrdev and
reading from the access chrdev as appropriate.
--- a/Documentation/industrialio/overview.txt	1970-01-01 01:00:00.000000000 +0100
+++ b/Documentation/industrialio/overview.txt	2008-07-24 18:37:56.000000000 +0100
@@ -0,0 +1,117 @@
+Overview of the industrialio subsystem.
+
+Main Components
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
+This is a cut down version containing only those elements intended for direct
+access by drivers.
+
+struct iio_dev {
+/* device specific data */
+	void *dev_data;
+
+/* Modes the drivers supports */
+	int modes;
+
+/* Current mode */
+	int currentmode;
+
+/* The device for with which we are dealing */
+	struct device *dev;
+
+/* General attributes */
+	const struct attribute_group *attrs;
+
+/* Used to specify ownership of interrupt etc that may be created by iio */
+	struct module *driver_module;
+/* How many hardware interrupt lines are there */
+	int num_interrupt_lines;
+
+/* Event control attributes */
+	struct attribute_group *event_attrs;
+
+
+/* Software Ring Buffer (discussed in iio_ring.txt
+   - for now assuming only makes sense to have a single ring */
+	int ring_dimension;
+	int ring_bytes_per_datum;
+	int ring_length;
+
+/* enabling / disabling related functions.
+ * post / pre refer to relative to the change of current_mode. */
+	int (*ring_preenable)(struct iio_dev *);
+	int (*ring_postenable)(struct iio_dev *);
+	int (*ring_predisable)(struct iio_dev *);
+	int (*ring_postdisable)(struct iio_dev *);
+
+	void (*ring_poll_func)(void *private_data);
+
+	/* Device state lock.
+	 * Used to prevent simultaneous changes to device state.
+	 * In here rather than modules as some ring buffer changes must occur
+	 * with this locked.*/
+	struct mutex			mlock;
+
+};
+
+@dev_data - driver specific data.
+
+@modes - currently limited to combinations of INDIO_DIRECT_MODE,
+INDIO_RING_POLLED, INDIO_RING_DATA_RDY and INDIO_RING_HARDWARE_BUFFER
+
+All devices should probably support INDIO_DIRECT_MODE which means
+that sensor values may be read directly from files in sysfs.
+Typically this may be via single element files (x, y, z for accelerometers)
+or scan files (max1363 for example).
+
+INDIO_RING_POLLED currently uses periodic real time clocks to generate
+interrupts which are then used to poll the device. See iio_ring for more details
+
+INDIO_RING_DATA_RDY is for devices that supply a data ready interrupt when new
+data becomes available (eg lis3l02dq)
+
+INDIO_RING_HARDWARE_BUFFER is for devices with hardware ring buffers
+(eg. sca3000)
+
+@attrs general attribute group for both direct access attributes for reading
+from sensors and for sensor specific parameters of use to userspace (conversion
+factors etc).
+
+@driver_module - corresponds to OWNER within the driver.  This is to ensure
+any interrupts etc requested are registered to the relevant module rather than
+iio.
+
+@num_interrupt_lines - does what it says on the tin.  Most devices only have one
+but I have seen ones with separate lines for data ready signals from motion
+detection etc.
+
+@event_attrs - sysfs attributes which control whether particular events (read
+interrupts from the point of view of the sensor) are enabled or not.  If they
+are up to 10 events will be queued on the related chrdev for reading by
+userspace code.
+
+Ring parameters and functions are covered in iio_ring.txt.
+
+@mlock - device configuration lock. Note it is the responsibility of drivers
+to get this lock if they wish to change parameters which may effect ring buffer
+capture (changing scan modes for example.)
+
+
+What happens when a iio_dev is registered.
+
+1) Unique id obtained.
+2) Sysfs direct read and configuration elements registered
+3) Device event (sensor interrupts) registered.
+4) If software ring to be used, setup the ring but don't actually allocate.
+   This occurs on first enabled / when reenabled after parameter change.
+4) If polled ring get a periodic timer.
+

--- a/Documentation/industrialio/iio_ring.txt	1970-01-01 01:00:00.000000000 +0100
+++ b/Documentation/industrialio/iio_ring.txt	2008-07-24 18:45:04.000000000 +0100
@@ -0,0 +1,91 @@
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
+dev. The data output is pretty much raw device readings, so a userspace function
+is needed to convert these into appropriate SI units.  This function should be
+provided in a device specific header if appropriate.
+
+The hardware ring buffer simply implements the above functionality by pull data
+directly from the device on demand (sca3000).
+
+
+The software ring buffer is somewhat more complex.
+
+The design considerations for this are:
+
+1) Writing should be as latency free as possible (preferably lock free)
+2) As few readings as possible should be missed (ideally none - but as
+   we aren't dealing with a realtime OS some will occasionally be lost).
+3) Reading does not lock the buffer but instead takes a copy then validate
+   what data is 'clean' approach.
+4) The filling of the buffer should be either driver by the device (datardy)
+   or if that is not possible via a periodic time source.
+5) All latencies should be as small as possible(wishful thinking ;)
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
--- a/Documentation/industrialio/TestRingMax1363.c	1970-01-01 01:00:00.000000000 +0100
+++ b/Documentation/industrialio/TestRingMax1363.c	2008-07-24 18:48:56.000000000 +0100
@@ -0,0 +1,106 @@
+/* Industrialio test ring buffer with a max1238
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ * Little tool to poke character devices associated with ring buffer and see
+ * what events are coming out.
+ *
+ * Todo: Make this more adapatable - e.g. allow specification of which
+ *       ring to poke.
+ *
+ * Clearly this needs a lot of work if it going to be a coherent / general
+ * piece of example code.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <stdint.h>
+#include <linux/types.h>
+
+
+struct iio_event_data {
+	int id;
+	__s64 timestamp;
+};
+int main(int argc, char **argv)
+{
+	FILE  *sysfsfp, *fp_ev;
+	int fp;
+	char data[20000];
+	size_t read_size;
+	int i, j, k;
+	int minor, minor_ev;
+	char name[100];
+	char name2[100];
+	char command[100];
+	char temp[100];
+	int pos;
+	struct iio_event_data dat;
+	int device_no;
+
+	if (argc == 1)
+		return -1;
+	device_no = atoi(argv[1]);
+	pos = sprintf(temp, "/sys/class/industrialio/industrialio%d/device/",
+		      device_no);
+	sprintf(temp + pos, "ring_buffer0_access_minor");
+	sysfsfp = fopen(temp, "r");
+	if (sysfsfp == NULL) {
+		printf("failed to open minor stuff \n");
+		return -1;
+	}
+
+	fscanf(sysfsfp, "%d\n", &minor);
+	sprintf(name, "/dev/indring%d", minor);
+
+	fclose(sysfsfp);
+	sprintf(temp + pos, "ring_buffer0_ev_minor");
+	sysfsfp = fopen(temp, "r");
+	if (sysfsfp == NULL) {
+		printf("failed to open minor stuff \n");
+		return -1;
+	}
+
+	fscanf(sysfsfp, "%d\n", &minor_ev);
+	fclose(sysfsfp);
+	sprintf(name2, "/dev/indringev%d", minor_ev);
+
+	fp = open(name, O_RDONLY | O_NONBLOCK);
+	if (fp == -1) {
+		sprintf(command, "mknod %s c 244 %d; mknod %s c 244 %d ",
+			name, minor, name2, minor_ev);
+		system(command);
+		fp = open(name, O_RDONLY | O_NONBLOCK);
+		if (fp == -1) {
+			printf("Unable to open %s\n", name);
+			return -1;
+		}
+	}
+	fp_ev = fopen(name2, "rb");
+	if (fp_ev == NULL)
+		printf("bug opening %s\n", name2);
+	/* Wait for events 10 times */
+	for (j = 0; j < 10; j++) {
+		read_size = fread(&dat, 1, sizeof(struct iio_event_data),
+				  fp_ev);
+		printf("event code received: %d\n", dat.id);
+		read_size = read(fp, (char *)(data), 100*(12+8));
+		if (read_size == -EAGAIN)
+			printf("nothing available \n");
+
+		/* print a small amount of data */
+		for (i = 0; i < 10; i++) {
+			for (k = 0; k < 12; k++)
+				printf("%d ",
+				       ((int)((data[i*32 + (k)*2 + 0]
+					       & 0x0F) << 8)
+					+ ((int)((data[i*32 + (k)*2 + 1])))));
+			printf(" %lld\n", *(__s64 *)(&data[i*32 + 12*2]));
+		}
+	}
+	return 0;
+}
