Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYKHLDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYKHLDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKHLDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:03:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38715 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYKHLDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:03:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 8 Nov 2008 12:03:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: detect and log TSB81BA3 erratum
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f09c80ed76dd6c79@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing a larger 1394b bus, I saw the following Texas Instruments
TSB81BA3 hardware bug at work:  On a 1394b-only bus with three or more
PHYs and differing cable lengths or differing hop speeds, the PHYs
repeatedly cause bus resets during traffic on the bus, as documented in
TI's "TSB81BA3 Errata (Rev. C)" SLLZ015C.  These resets cause massive
I/O failures.

Self-ID complete events after such resets consistently show more than
one self-ID zero packet with i bit set ( = initiated reset).  If this
happens, emit a warning in dmesg and suggest hardware workarounds to the
user.  (There is no software workaround.)

The hardware bug is fixed in TSB81BA3 revision D but there are probably
many FireWire 800 products out there which have a buggy version of this
chip.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -179,7 +179,7 @@ static struct fw_node *build_tree(struct
 	struct list_head stack, *h;
 	u32 *next_sid, *end, q;
 	int i, port_count, child_port_count, phy_id, parent_count, stack_depth;
-	int gap_count;
+	int gap_count, reset_initiators;
 	bool beta_repeaters_present;
 
 	local_node = NULL;
@@ -190,6 +190,7 @@ static struct fw_node *build_tree(struct
 	phy_id = 0;
 	irm_node = NULL;
 	gap_count = SELF_ID_GAP_COUNT(*sid);
+	reset_initiators = 0;
 	beta_repeaters_present = false;
 
 	while (sid < end) {
@@ -285,6 +286,8 @@ static struct fw_node *build_tree(struct
 		list_add_tail(&node->link, &stack);
 		stack_depth += 1 - child_port_count;
 
+		reset_initiators += SELF_ID_PHY_INITIATOR(q);
+
 		if (node->phy_speed == SCODE_BETA &&
 		    parent_count + child_port_count > 1)
 			beta_repeaters_present = true;
@@ -307,6 +310,14 @@ static struct fw_node *build_tree(struct
 	card->gap_count = gap_count;
 	card->beta_repeaters_present = beta_repeaters_present;
 
+	if (reset_initiators != 1) {
+		fw_error("%d bus reset initiators, hardware bug?\n",
+			 reset_initiators);
+		if (beta_repeaters_present)
+			fw_error("try cables with matched length "
+				 "or add a 1394a node\n");
+	}
+
 	return local_node;
 }
 

-- 
Stefan Richter
-=====-==--- =-== -=---
http://arcgraph.de/sr/

