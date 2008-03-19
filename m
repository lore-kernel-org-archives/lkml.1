Return-Path: <linux-kernel-owner+w=401wt.eu-S965312AbYCSWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbYCSWef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965503AbYCSVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:05:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38347 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965498AbYCSVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:05:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 19 Mar 2008 22:05:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: catch self_id_count == 0
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.8492f68de2af250b@s5r6.in-berlin.de>
Message-ID: <tkrat.8f4d95b45b232823@s5r6.in-berlin.de>
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
 <tkrat.00038248cbf40b77@s5r6.in-berlin.de>
 <tkrat.a46eb70f34367db6@s5r6.in-berlin.de>
 <tkrat.463115f5f3763a98@s5r6.in-berlin.de>
 <tkrat.8492f68de2af250b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_core_handle_bus_reset() incorrectly relied on the assumption that
self_id_count > 0.

We check early in fw-ohci and discard the self ID complete event if
self_id_count == 0 because a valid event always has at least one self ID
packet in it (the one of the local node).  Hence treat self_id_count ==
0 like any other kind of invalid self ID buffer.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Applies after patch "firewire: fw-ohci: add self ID error check".
Supersedes patch "firewire: catch self_id_count == 0".

 drivers/firewire/fw-ohci.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1072,6 +1072,10 @@ static void bus_reset_tasklet(unsigned l
 	 * bit extra to get the actual number of self IDs.
 	 */
 	self_id_count = (reg >> 3) & 0x3ff;
+	if (self_id_count == 0) {
+		fw_notify("inconsistent self IDs\n");
+		return;
+	}
 	generation = (cond_le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
 	rmb();
 

-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/

