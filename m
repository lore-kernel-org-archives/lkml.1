Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0BTLOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:14:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0BTLOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:14:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 20 Feb 2010 12:13:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: cdev: add more flexible cycle timer ioctl
To: linux1394-devel@lists.sourceforge.net, Pieter Palmers <pieterp@joow.be>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.9650095fffa41adc@s5r6.in-berlin.de>
Message-ID: <tkrat.81b07687887c107f@s5r6.in-berlin.de>
References: <tkrat.9650095fffa41adc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system time from CLOCK_REALTIME is not monotonic, hence problematic
for the main user of the FW_CDEV_IOC_GET_CYCLE_TIMER ioctl.  This issue
exists in its successor ABI, i.e. raw1394, too.
http://subversion.ffado.org/ticket/242

We now offer an alternative ioctl which lets the caller choose between
CLOCK_REALTIME, CLOCK_MONOTONIC, and CLOCK_MONOTONIC_RAW as source of
the local time, very similar to the clock_gettime libc function.  The
format of the local time return value matches that of clock_gettime
(seconds and nanoseconds, instead of a single microseconds value from
the existing ioctl).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  Added the core-cdev.c::dispatch_ioctl()::sizeof(union...) hunk.

 drivers/firewire/core-cdev.c  |   38 +++++++++++++++++++++++++++++-----
 include/linux/firewire-cdev.h |   31 ++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 10 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1030,22 +1030,46 @@ static int ioctl_stop_iso(struct client 
 	return fw_iso_context_stop(client->iso_context);
 }
 
-static int ioctl_get_cycle_timer(struct client *client, void *buffer)
+static int ioctl_get_cycle_timer2(struct client *client, void *buffer)
 {
-	struct fw_cdev_get_cycle_timer *request = buffer;
+	struct fw_cdev_get_cycle_timer2 *request = buffer;
 	struct fw_card *card = client->device->card;
-	struct timeval tv;
+	struct timespec ts = {0, 0};
 	u32 cycle_time;
+	int ret = 0;
 
 	local_irq_disable();
 
 	cycle_time = card->driver->get_cycle_time(card);
-	do_gettimeofday(&tv);
+
+	switch (request->clk_id) {
+	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
+	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
+	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
+	default:
+		ret = -EINVAL;
+	}
 
 	local_irq_enable();
 
-	request->local_time = tv.tv_sec * 1000000ULL + tv.tv_usec;
-	request->cycle_timer = cycle_time;
+	request->tv_sec		= ts.tv_sec;
+	request->tv_nsec	= ts.tv_nsec;
+	request->cycle_timer	= cycle_time;
+
+	return ret;
+}
+
+static int ioctl_get_cycle_timer(struct client *client, void *buffer)
+{
+	struct fw_cdev_get_cycle_timer *request = buffer;
+	struct fw_cdev_get_cycle_timer2 ct2;
+
+	ct2.clk_id = CLOCK_REALTIME;
+	ioctl_get_cycle_timer2(client, &ct2);
+
+	request->local_time	= ct2.tv_sec * USEC_PER_SEC +
+				  ct2.tv_nsec / NSEC_PER_USEC;
+	request->cycle_timer	= ct2.cycle_timer;
 
 	return 0;
 }
@@ -1319,6 +1343,7 @@ static int (* const ioctl_handlers[])(st
 	ioctl_get_speed,
 	ioctl_send_broadcast_request,
 	ioctl_send_stream_packet,
+	ioctl_get_cycle_timer2,
 };
 
 static int dispatch_ioctl(struct client *client,
@@ -1340,6 +1365,7 @@ static int dispatch_ioctl(struct client 
 		struct fw_cdev_get_cycle_timer		_0c;
 		struct fw_cdev_allocate_iso_resource	_0d;
 		struct fw_cdev_send_stream_packet	_13;
+		struct fw_cdev_get_cycle_timer2		_14;
 	})];
 	int ret;
 
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -248,6 +248,9 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_SEND_BROADCAST_REQUEST       _IOW('#', 0x12, struct fw_cdev_send_request)
 #define FW_CDEV_IOC_SEND_STREAM_PACKET           _IOW('#', 0x13, struct fw_cdev_send_stream_packet)
 
+/* available since kernel version 2.6.34 */
+#define FW_CDEV_IOC_GET_CYCLE_TIMER2   _IOWR('#', 0x14, struct fw_cdev_get_cycle_timer2)
+
 /*
  * FW_CDEV_VERSION History
  *  1  (2.6.22)  - initial version
@@ -544,14 +547,15 @@ struct fw_cdev_stop_iso {
 /**
  * struct fw_cdev_get_cycle_timer - read cycle timer register
  * @local_time:   system time, in microseconds since the Epoch
- * @cycle_timer:  isochronous cycle timer, as per OHCI 1.1 clause 5.13
+ * @cycle_timer:  Cycle Time register contents
  *
  * The %FW_CDEV_IOC_GET_CYCLE_TIMER ioctl reads the isochronous cycle timer
- * and also the system clock.  This allows to express the receive time of an
- * isochronous packet as a system time with microsecond accuracy.
+ * and also the system clock (%CLOCK_REALTIME).  This allows to express the
+ * receive time of an isochronous packet as a system time.
  *
  * @cycle_timer consists of 7 bits cycleSeconds, 13 bits cycleCount, and
- * 12 bits cycleOffset, in host byte order.
+ * 12 bits cycleOffset, in host byte order.  Cf. the Cycle Time register
+ * per IEEE 1394 or Isochronous Cycle Timer register per OHCI-1394.
  */
 struct fw_cdev_get_cycle_timer {
 	__u64 local_time;
@@ -559,6 +563,25 @@ struct fw_cdev_get_cycle_timer {
 };
 
 /**
+ * struct fw_cdev_get_cycle_timer2 - read cycle timer register
+ * @tv_sec:       system time, seconds
+ * @tv_nsec:      system time, sub-seconds part in nanoseconds
+ * @clk_id:       input parameter, clock from which to get the system time
+ * @cycle_timer:  Cycle Time register contents
+ *
+ * The %FW_CDEV_IOC_GET_CYCLE_TIMER2 works like
+ * %FW_CDEV_IOC_GET_CYCLE_TIMER but lets you choose a clock like with POSIX'
+ * clock_gettime function.  Supported @clk_id values are POSIX' %CLOCK_REALTIME
+ * and %CLOCK_MONOTONIC and Linux' %CLOCK_MONOTONIC_RAW.
+ */
+struct fw_cdev_get_cycle_timer2 {
+	__s64 tv_sec;
+	__s32 tv_nsec;
+	__s32 clk_id;
+	__u32 cycle_timer;
+};
+
+/**
  * struct fw_cdev_allocate_iso_resource - (De)allocate a channel or bandwidth
  * @closure:	Passed back to userspace in correponding iso resource events
  * @channels:	Isochronous channels of which one is to be (de)allocated

-- 
Stefan Richter
-=====-==-=- --=- =-=--
http://arcgraph.de/sr/

