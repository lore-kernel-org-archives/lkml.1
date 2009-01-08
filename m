Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbZAHWIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbZAHWIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZAHWIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:08:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41046 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZAHWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:08:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Jan 2009 23:07:40 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: add ioctls for iso resource management,
 amendment
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, David Moore <dcm@acm.org>
In-Reply-To: <496648EC.3060806@s5r6.in-berlin.de>
Message-ID: <tkrat.228f8897f8391f98@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de> 
 <tkrat.c425621dbf524825@s5r6.in-berlin.de>
 <1231404355.18613.68.camel@localhost.localdomain>
 <4965D58E.1050606@s5r6.in-berlin.de> <496648EC.3060806@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fixes:
  - Remove stale documentation.
  - Fix a != vs. == thinko that got in the way of channel management.
  - Try bandwidth deallocation even if channel deallocation failed.

A simplification:
  - fw_cdev_allocate_iso_resource.channels is now ordered like
    libdc1394's dc1394_iso_allocate_channel() channels_allowed
    argument.

By the way, I looked closer at cards from NEC, TI, and VIA, and noticed
that they all don't implement IEEE 1394a behaviour which is meant to
deviate from IEEE 1212's notion of lock compare-swap.  This means that
we have to do two lock transactions instead of one in many cases where
one transaction would already succeed on a fully 1394a compliant IRM.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |    2 -
 drivers/firewire/fw-iso.c     |   38 +++++++++++++++++++---------------
 include/linux/firewire-cdev.h |   10 +++-----
 3 files changed, 27 insertions(+), 23 deletions(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -174,8 +174,6 @@ struct fw_cdev_event_iso_interrupt {
  * @handle:	Reference by which an allocated resource can be deallocated
  * @channel:	Isochronous channel which was (de)allocated, if any
  * @bandwidth:	Bandwidth allocation units which were (de)allocated, if any
- * @channels_available:  Last known availability of channels
- * @bandwidth_available: Last known availability of bandwidth
  *
  * An %FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED event is sent after an isochronous
  * resource was allocated at the IRM.  The client has to check @channel and
@@ -580,7 +578,7 @@ struct fw_cdev_get_cycle_timer {
  *
  * The %FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE ioctl works like
  * %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE except that resources are freed
- * instead of allocated.  At most one channel may be specified in this ioctl.
+ * instead of allocated.
  * An %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event concludes this operation.
  *
  * To summarize, %FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE allocates iso resources
@@ -588,9 +586,9 @@ struct fw_cdev_get_cycle_timer {
  * In contrast, %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE allocates iso resources
  * for the duration of a bus generation.
  *
- * @channels is a host-endian bitfield with the most significant bit
- * representing channel 0 and the least significant bit representing channel 63:
- * 1ULL << (63 - c)
+ * @channels is a host-endian bitfield with the least significant bit
+ * representing channel 0 and the most significant bit representing channel 63:
+ * 1ULL << c for each channel c that is a candidate for (de)allocation.
  *
  * @bandwidth is expressed in bandwidth allocation units, i.e. the time to send
  * one quadlet of data (payload or header data) at speed S1600.
Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -204,17 +204,19 @@ static int manage_bandwidth(struct fw_ca
 }
 
 static int manage_channel(struct fw_card *card, int irm_id, int generation,
-			  __be32 channels_mask, u64 offset, bool allocate)
+			  u32 channels_mask, u64 offset, bool allocate)
 {
-	__be32 data[2], c, old = allocate ? cpu_to_be32(~0) : 0;
+	__be32 data[2], c, all, old;
 	int i, retry = 5;
 
+	old = all = allocate ? cpu_to_be32(~0) : 0;
+
 	for (i = 0; i < 32; i++) {
-		c = cpu_to_be32(1 << (31 - i));
-		if (!(channels_mask & c))
+		if (!(channels_mask & 1 << i))
 			continue;
 
-		if (allocate == !(old & c))
+		c = cpu_to_be32(1 << (31 - i));
+		if ((old & c) != (all & c))
 			continue;
 
 		data[0] = old;
@@ -233,7 +235,7 @@ static int manage_channel(struct fw_card
 			old = data[0];
 
 			/* Is the IRM 1394a-2000 compliant? */
-			if ((data[0] & c) != (data[1] & c))
+			if ((data[0] & c) == (data[1] & c))
 				continue;
 
 			/* 1394-1995 IRM, fall through to retry. */
@@ -249,11 +251,10 @@ static int manage_channel(struct fw_card
 static void deallocate_channel(struct fw_card *card, int irm_id,
 			       int generation, int channel)
 {
-	__be32 mask;
+	u32 mask;
 	u64 offset;
 
-	mask = channel < 32 ? cpu_to_be32(1 << (31 - channel)) :
-			      cpu_to_be32(1 << (63 - channel));
+	mask = channel < 32 ? 1 << channel : 1 << (channel - 32);
 	offset = channel < 32 ? CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI :
 				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO;
 
@@ -266,7 +267,12 @@ static void deallocate_channel(struct fw
  * In parameters: card, generation, channels_mask, bandwidth, allocate
  * Out parameters: channel, bandwidth
  * This function blocks (sleeps) during communication with the IRM.
+ *
  * Allocates or deallocates at most one channel out of channels_mask.
+ * channels_mask is a bitfield with MSB for channel 63 and LSB for channel 0.
+ * (Note, the IRM's CHANNELS_AVAILABLE is a big-endian bitfield with MSB for
+ * channel 0 and LSB for channel 63.)
+ * Allocates or deallocates as many bandwidth allocation units as specified.
  *
  * Returns channel < 0 if no channel was allocated or deallocated.
  * Returns bandwidth = 0 if no bandwidth was allocated or deallocated.
@@ -274,17 +280,17 @@ static void deallocate_channel(struct fw
  * If generation is stale, deallocations succeed but allocations fail with
  * channel = -EAGAIN.
  *
- * If channel (de)allocation fails, bandwidth (de)allocation fails too.
+ * If channel allocation fails, no bandwidth will be allocated either.
  * If bandwidth allocation fails, no channel will be allocated either.
- * If bandwidth deallocation fails, channel deallocation may still have been
- * successful.
+ * But deallocations of channel and bandwidth are tried independently
+ * of each other's success.
  */
 void fw_iso_resource_manage(struct fw_card *card, int generation,
 			    u64 channels_mask, int *channel, int *bandwidth,
 			    bool allocate)
 {
-	__be32 channels_hi = cpu_to_be32(channels_mask >> 32);
-	__be32 channels_lo = cpu_to_be32(channels_mask);
+	u32 channels_hi = channels_mask;	/* channels 31...0 */
+	u32 channels_lo = channels_mask >> 32;	/* channels 63...32 */
 	int irm_id, ret, c = -EINVAL;
 
 	spin_lock_irq(&card->lock);
@@ -302,7 +308,7 @@ void fw_iso_resource_manage(struct fw_ca
 	}
 	*channel = c;
 
-	if (channels_mask != 0 && c < 0)
+	if (allocate && channels_mask != 0 && c < 0)
 		*bandwidth = 0;
 
 	if (*bandwidth == 0)
@@ -312,7 +318,7 @@ void fw_iso_resource_manage(struct fw_ca
 	if (ret < 0)
 		*bandwidth = 0;
 
-	if (ret < 0 && c >= 0 && allocate) {
+	if (allocate && ret < 0 && c >= 0) {
 		deallocate_channel(card, irm_id, generation, c);
 		*channel = ret;
 	}
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1082,7 +1082,7 @@ static void iso_resource_work(struct wor
 	spin_unlock_irq(&client->lock);
 
 	if (todo == ISO_RES_ALLOC && channel >= 0)
-		r->channels = 1ULL << (63 - channel);
+		r->channels = 1ULL << channel;
 
 	if (todo == ISO_RES_REALLOC && success)
 		goto out;

-- 
Stefan Richter
-=====-==--= ---= -=---
http://arcgraph.de/sr/

