Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbYDJW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbYDJW44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYDJW4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:56:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55113 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYDJW4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:56:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 11 Apr 2008 00:51:15 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: fw-ohci: extend logging of bus generations and
 node ID
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f3c267b896f5d604@s5r6.in-berlin.de>
Message-ID: <tkrat.af66976aaf531c2f@s5r6.in-berlin.de>
References: <tkrat.f3c267b896f5d604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the logging of "AR evt_bus_reset, link internal" to "AR
evt_bus_reset, generation ${selfIDGeneration}".  That way we can check
whether this generation matches the one seen in self ID complete event
logging.  See OHCI 1.1 clause 8.4.2.3.

Also extend logging of "firewire_ohci: * selfIDs, generation *" by
"local node ID ffc*" in self ID logging to make the local node in AT/AR
event logs more obvious.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -302,13 +302,13 @@ static char _p(u32 *s, int shift)
 	return port[*s >> shift & 3];
 }
 
-static void log_selfids(int generation, int self_id_count, u32 *s)
+static void log_selfids(int node_id, int generation, int self_id_count, u32 *s)
 {
 	if (likely(!(param_debug & OHCI_PARAM_DEBUG_SELFIDS)))
 		return;
 
-	printk(KERN_DEBUG KBUILD_MODNAME ": %d selfIDs, generation %d\n",
-	       self_id_count, generation);
+	printk(KERN_DEBUG KBUILD_MODNAME ": %d selfIDs, generation %d, "
+	       "local node ID %04x\n", self_id_count, generation, node_id);
 
 	for (; self_id_count--; ++s)
 		if ((*s & 1 << 23) == 0)
@@ -371,6 +371,12 @@ static void log_ar_at_event(char dir, in
 	if (unlikely(evt >= ARRAY_SIZE(evts)))
 			evt = 0x1f;
 
+	if (evt == OHCI1394_evt_bus_reset) {
+		printk(KERN_DEBUG "A%c evt_bus_reset, generation %d\n",
+		       dir, (header[2] >> 16) & 0xff);
+		return;
+	}
+
 	if (header[1] == ~header[2]) {
 		printk(KERN_DEBUG "A%c %s, %s, %08x\n",
 		       dir, evts[evt], phys[header[1] >> 30 & 0x3],
@@ -417,7 +423,7 @@ static void log_ar_at_event(char dir, in
 #else
 
 #define log_irqs(evt)
-#define log_selfids(generation, self_id_count, sid)
+#define log_selfids(node_id, generation, self_id_count, sid)
 #define log_ar_at_event(dir, speed, header, evt)
 
 #endif /* CONFIG_FIREWIRE_OHCI_DEBUG */
@@ -1320,7 +1326,8 @@ static void bus_reset_tasklet(unsigned l
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  free_rom, free_rom_bus);
 
-	log_selfids(generation, self_id_count, ohci->self_id_buffer);
+	log_selfids(ohci->node_id, generation,
+		    self_id_count, ohci->self_id_buffer);
 
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer);

-- 
Stefan Richter
-=====-==--- -=-- -=-==
http://arcgraph.de/sr/

