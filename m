Return-Path: <linux-kernel-owner+w=401wt.eu-S965525AbYCSVGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525AbYCSVGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYCST5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:57:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36813 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761272AbYCST5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:57:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 19 Mar 2008 20:56:26 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: insist on successive self ID complete events
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
Message-ID: <tkrat.00038248cbf40b77@s5r6.in-berlin.de>
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole topology code only works if the old and new topologies which
are compared come from immediately successive self ID complete events.

If there happened bus resets without self ID complete events in the
meantime, or self ID complete events with invalid selfIDs, the topology
comparison could identify nodes wrongly, or more likely just corrupt
kernel memory or panic right away.

We new discard all nodes of the old topology and treat all current nodes
as new ones if the current self ID generation is not the previous one
plus 1.  This should fix another aspect of
http://bugzilla.kernel.org/show_bug.cgi?id=10128

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -518,6 +518,17 @@ fw_core_handle_bus_reset(struct fw_card 
 		return;
 	}
 
+	/*
+	 * If the selfID buffer is not the immediate successor of the
+	 * previously processed one, we cannot reliably compare the
+	 * old and new topologies.
+	 */
+	if ((generation & 0xff) != ((card->generation + 1) & 0xff)) {
+		fw_notify("skipped bus generations, destroying all nodes\n");
+		fw_destroy_nodes(card);
+		card->bm_retries = 0;
+	}
+
 	spin_lock_irqsave(&card->lock, flags);
 
 	/*

-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/

