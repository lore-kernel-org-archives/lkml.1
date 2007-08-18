Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbXHRNte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbXHRNte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 09:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbXHRNtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 09:49:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58333 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXHRNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 09:49:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Aug 2007 15:48:44 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [rfc patch] firewire: fw-ohci: enforce read order for selfID
 generation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.fcb43d301f23f4f1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems unlikely, but access to self_id_cpu[0] could at least in theory
be deferred until after the loop over self_id_cpu[1..n] or even after
the subsequent reg_read.  Enforce the desired order by a read barrier.

Also prevent the reg_read from being reordered relative to the for loop.
This isn't necessary if the loop's conditional printk counts as an
implicit barrier, but better make it explicit.

(self_id_cpu[] is a coherent DMA buffer.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -30,6 +30,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
+#include <asm/system.h>
 
 #include "fw-transaction.h"
 #include "fw-ohci.h"
@@ -926,6 +927,7 @@ static void bus_reset_tasklet(unsigned l
 
 	self_id_count = (reg_read(ohci, OHCI1394_SelfIDCount) >> 3) & 0x3ff;
 	generation = (le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
+	rmb();
 
 	for (i = 1, j = 0; j < self_id_count; i += 2, j++) {
 		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1])
@@ -946,7 +948,7 @@ static void bus_reset_tasklet(unsigned l
 	 * the two generations match we know we have a consistent set
 	 * of self IDs.
 	 */
-
+	barrier();
 	new_generation = (reg_read(ohci, OHCI1394_SelfIDCount) >> 16) & 0xff;
 	if (new_generation != generation) {
 		fw_notify("recursive bus reset detected, "

-- 
Stefan Richter
-=====-=-=== =--- =--=-
http://arcgraph.de/sr/

