Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXI2Imc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXI2Imc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXI2ImZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:42:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49963 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXI2ImY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:42:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 29 Sep 2007 10:41:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: adopt read cycle timer ABI from raw1394
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Pieter Palmers <pieterp@joow.be>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This duplicates the read cycle timer feature of raw1394 (added in Linux
2.6.21) in firewire-core's userspace ABI.  The argument to the ioctl is
reordered though to ensure 32/64 bit compatibility.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Only compile-tested.
Counterpart for libraw1394's Juju backend not done yet.


 drivers/firewire/fw-cdev.c    |   26 ++++++++++++++++++++++++++
 include/linux/firewire-cdev.h |   15 +++++++++++++++
 2 files changed, 41 insertions(+)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -178,6 +178,7 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_QUEUE_ISO		_IOWR('#', 0x09, struct fw_cdev_queue_iso)
 #define FW_CDEV_IOC_START_ISO		_IOW('#', 0x0a, struct fw_cdev_start_iso)
 #define FW_CDEV_IOC_STOP_ISO		_IOW('#', 0x0b, struct fw_cdev_stop_iso)
+#define FW_CDEV_IOC_GET_CYCLE_TIMER	_IOR('#', 0x0c, struct fw_cdev_get_cycle_timer)
 
 /* FW_CDEV_VERSION History
  *
@@ -459,4 +460,18 @@ struct fw_cdev_stop_iso {
 	__u32 handle;
 };
 
+/**
+ * struct fw_cdev_get_cycle_timer - read cycle timer register
+ * @local_time:   system time, in microseconds since the Epoch
+ * @cycle_timer:  isochronous cycle timer, as per OHCI 1.1 clause 5.13
+ *
+ * The %FW_CDEV_IOC_GET_CYCLE_TIMER ioctl reads the isochronous cycle timer
+ * and also the system clock.  This allows to express the receive time of an
+ * isochronous packet as a system time with microsecond accuracy.
+ */
+struct fw_cdev_get_cycle_timer {
+	__u64 local_time;
+	__u32 cycle_timer;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -25,11 +25,14 @@
 #include <linux/device.h>
 #include <linux/vmalloc.h>
 #include <linux/poll.h>
+#include <linux/preempt.h>
+#include <linux/time.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/idr.h>
 #include <linux/compat.h>
 #include <linux/firewire-cdev.h>
+#include <asm/system.h>
 #include <asm/uaccess.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -810,6 +813,28 @@ static int ioctl_stop_iso(struct client 
 	return fw_iso_context_stop(client->iso_context);
 }
 
+static int ioctl_get_cycle_timer(struct client *client, void *buffer)
+{
+	struct fw_cdev_get_cycle_timer *request = buffer;
+	struct fw_card *card = client->device->card;
+	unsigned long long bus_time;
+	struct timeval tv;
+	unsigned long flags;
+
+	preempt_disable();
+	local_irq_save(flags);
+
+	bus_time = card->driver->get_bus_time(card);
+	do_gettimeofday(&tv);
+
+	local_irq_restore(flags);
+	preempt_enable();
+
+	request->local_time = tv.tv_sec * 1000000ULL + tv.tv_usec;
+	request->cycle_timer = bus_time & 0xffffffff;
+	return 0;
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -823,6 +848,7 @@ static int (* const ioctl_handlers[])(st
 	ioctl_queue_iso,
 	ioctl_start_iso,
 	ioctl_stop_iso,
+	ioctl_get_cycle_timer,
 };
 
 static int

-- 
Stefan Richter
-=====-=-=== =--= ===-=
http://arcgraph.de/sr/

