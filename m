Return-Path: <linux-kernel-owner+w=401wt.eu-S934364AbYCSWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbYCSWP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbYCSUpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:45:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37909 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761484AbYCSUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:45:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 19 Mar 2008 21:40:32 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fw-ohci: add self ID error check
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.463115f5f3763a98@s5r6.in-berlin.de>
Message-ID: <tkrat.8492f68de2af250b@s5r6.in-berlin.de>
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
 <tkrat.00038248cbf40b77@s5r6.in-berlin.de>
 <tkrat.a46eb70f34367db6@s5r6.in-berlin.de>
 <tkrat.463115f5f3763a98@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Mar, Stefan Richter wrote:
> On 19 Mar, Stefan Richter wrote:
[slippery mouse button... actual reply follows now]


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: fw-ohci: add self ID error check

Discard self ID buffer contents if
  - the selfIDError flag is set,
  - any of the self ID packets has bit errors.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  Demote log level from KERN_ERR to KERN_NOTICE.

 drivers/firewire/fw-ohci.c |   14 ++++++++++----
 drivers/firewire/fw-ohci.h |    1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1060,20 +1060,26 @@ static void bus_reset_tasklet(unsigned l
 	ohci->node_id = reg & (OHCI1394_NodeID_busNumber |
 			       OHCI1394_NodeID_nodeNumber);
 
+	reg = reg_read(ohci, OHCI1394_SelfIDCount);
+	if (reg & OHCI1394_SelfIDCount_selfIDError) {
+		fw_notify("inconsistent self IDs\n");
+		return;
+	}
 	/*
 	 * The count in the SelfIDCount register is the number of
 	 * bytes in the self ID receive buffer.  Since we also receive
 	 * the inverted quadlets and a header quadlet, we shift one
 	 * bit extra to get the actual number of self IDs.
 	 */
-
-	self_id_count = (reg_read(ohci, OHCI1394_SelfIDCount) >> 3) & 0x3ff;
+	self_id_count = (reg >> 3) & 0x3ff;
 	generation = (cond_le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
 	rmb();
 
 	for (i = 1, j = 0; j < self_id_count; i += 2, j++) {
-		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1])
-			fw_error("inconsistent self IDs\n");
+		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1]) {
+			fw_notify("inconsistent self IDs\n");
+			return;
+		}
 		ohci->self_id_buffer[j] =
 				cond_le32_to_cpu(ohci->self_id_cpu[i]);
 	}
Index: linux/drivers/firewire/fw-ohci.h
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.h
+++ linux/drivers/firewire/fw-ohci.h
@@ -30,6 +30,7 @@
 #define  OHCI1394_HCControl_softReset		0x00010000
 #define OHCI1394_SelfIDBuffer                 0x064
 #define OHCI1394_SelfIDCount                  0x068
+#define  OHCI1394_SelfIDCount_selfIDError	0x80000000
 #define OHCI1394_IRMultiChanMaskHiSet         0x070
 #define OHCI1394_IRMultiChanMaskHiClear       0x074
 #define OHCI1394_IRMultiChanMaskLoSet         0x078


-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/

