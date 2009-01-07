Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZAGTPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZAGTPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZAGTPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:15:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33070 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZAGTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:15:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jan 2009 20:14:53 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: increment fw_cdev_version, update
 documentation
To: David Moore <dcm@MIT.EDU>, linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <4964FCA5.1040808@s5r6.in-berlin.de>
Message-ID: <tkrat.d261fdcc22c8bd25@s5r6.in-berlin.de>
References: <1216794220.18969.14.camel@pisces.mit.edu>
 <4964FCA5.1040808@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Necessary due to
    Date: Tue, 22 Jul 2008 23:23:40 -0700
    From: David Moore <dcm@acm.org>
    Subject: firewire: Include iso timestamp in headers when header_size > 4

Side note:  The lack of upwards compatibility sounds worse than it is.
All existing client implementations, libraw1394 and libdc1394, set
header_size = 4.  And since the ABI v1 behaviour does not offer any
advantages over the new behaviour, we deliberately do not provide the
old behaviour anymore.

Also add documentation about the format of fw_cdev_get_cycle_timer which
may be used in conjunction with the timestamp of iso packets but has a
different format.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |   35 +++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -138,7 +138,24 @@ struct fw_cdev_event_request {
  * This event is sent when the controller has completed an &fw_cdev_iso_packet
  * with the %FW_CDEV_ISO_INTERRUPT bit set.  In the receive case, the headers
  * stripped of all packets up until and including the interrupt packet are
- * returned in the @header field.
+ * returned in the @header field.  The amount of header data per packet is as
+ * specified at iso context creation by &fw_cdev_create_iso_context.header_size.
+ *
+ * In version 1 of this ABI, header data consisted of the 1394 isochronous
+ * packet header, followed by quadlets from the packet payload if
+ * &fw_cdev_create_iso_context.header_size > 4.
+ *
+ * In version 2 of this ABI, header data consist of the 1394 isochronous
+ * packet header, followed by a timestamp quadlet if
+ * &fw_cdev_create_iso_context.header_size > 4, followed by quadlets from the
+ * packet payload if &fw_cdev_create_iso_context.header_size > 8.
+ *
+ * Behaviour of ver. 1 of this ABI is no longer available since ABI ver. 2.
+ *
+ * Format of 1394 iso packet header: 16 bits len, 2 bits tag, 6 bits channel,
+ * 4 bits tcode, 4 bits sy, in big endian byte order.  Format of timestamp:
+ * 16 bits invalid, 3 bits cycleSeconds, 13 bits cycleCount, in big endian byte
+ * order.
  */
 struct fw_cdev_event_iso_interrupt {
 	__u64 closure;
@@ -232,11 +249,13 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_GET_SPEED                    _IOR('#', 0x11, struct fw_cdev_get_speed)
 #define FW_CDEV_IOC_SEND_BROADCAST_REQUEST       _IOW('#', 0x12, struct fw_cdev_send_request)
 
-/* FW_CDEV_VERSION History
- *
- * 1	Feb 18, 2007:  Initial version.
+/*
+ * FW_CDEV_VERSION History
+ *  1  (2.6.22)  - initial version
+ *  2  (2.6.30)  - changed &fw_cdev_event_iso_interrupt.header if
+ *                 &fw_cdev_create_iso_context.header_size is 8 or more
  */
-#define FW_CDEV_VERSION		1
+#define FW_CDEV_VERSION 2
 
 /**
  * struct fw_cdev_get_info - General purpose information ioctl
@@ -417,6 +436,9 @@ struct fw_cdev_remove_descriptor {
  *
  * If a context was successfully created, the kernel writes back a handle to the
  * context, which must be passed in for subsequent operations on that context.
+ *
+ * Note that the effect of a @header_size > 4 depends on
+ * &fw_cdev_get_info.version, as documented at &fw_cdev_event_iso_interrupt.
  */
 struct fw_cdev_create_iso_context {
 	__u32 type;
@@ -520,6 +542,9 @@ struct fw_cdev_stop_iso {
  * The %FW_CDEV_IOC_GET_CYCLE_TIMER ioctl reads the isochronous cycle timer
  * and also the system clock.  This allows to express the receive time of an
  * isochronous packet as a system time with microsecond accuracy.
+ *
+ * @cycle_timer consists of 7 bits cycleSeconds, 13 bits cycleCount, and
+ * 12 bits cycleOffset, in host byte order.
  */
 struct fw_cdev_get_cycle_timer {
 	__u64 local_time;

-- 
Stefan Richter
-=====-==--= ---= --===
http://arcgraph.de/sr/

