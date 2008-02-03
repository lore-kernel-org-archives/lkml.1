Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYBCWJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYBCWJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYBCWJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:09:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47823 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbYBCWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:09:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:08:58 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/9] firewire: fw-sbp2: wait for completion of fetch agent
 reset
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.f428e74c4b757abb@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the old sbp2 driver, wait for the write transaction to the
AGENT_RESET to complete before proceeding (after login, after reconnect,
or in SCSI error handling).

There is one occasion where AGENT_RESET is written to from atomic
context when getting DEAD status for a command ORB.  There we still
continue without waiting for the transaction to complete because this
is more difficult to fix...

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   39 ++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -603,29 +603,46 @@ sbp2_send_management_orb(struct sbp2_log
 
 static void
 complete_agent_reset_write(struct fw_card *card, int rcode,
-			   void *payload, size_t length, void *data)
+			   void *payload, size_t length, void *done)
 {
-	struct fw_transaction *t = data;
+	complete(done);
+}
+
+static void sbp2_agent_reset(struct sbp2_logical_unit *lu)
+{
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct fw_transaction t;
+	static u32 z;
 
-	kfree(t);
+	fw_send_request(device->card, &t, TCODE_WRITE_QUADLET_REQUEST,
+			lu->tgt->node_id, lu->generation, device->max_speed,
+			lu->command_block_agent_address + SBP2_AGENT_RESET,
+			&z, sizeof(z), complete_agent_reset_write, &done);
+	wait_for_completion(&done);
 }
 
-static int sbp2_agent_reset(struct sbp2_logical_unit *lu)
+static void
+complete_agent_reset_write_no_wait(struct fw_card *card, int rcode,
+				   void *payload, size_t length, void *data)
+{
+	kfree(data);
+}
+
+static void sbp2_agent_reset_no_wait(struct sbp2_logical_unit *lu)
 {
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct fw_transaction *t;
-	static u32 zero;
+	static u32 z;
 
-	t = kzalloc(sizeof(*t), GFP_ATOMIC);
+	t = kmalloc(sizeof(*t), GFP_ATOMIC);
 	if (t == NULL)
-		return -ENOMEM;
+		return;
 
 	fw_send_request(device->card, t, TCODE_WRITE_QUADLET_REQUEST,
 			lu->tgt->node_id, lu->generation, device->max_speed,
 			lu->command_block_agent_address + SBP2_AGENT_RESET,
-			&zero, sizeof(zero), complete_agent_reset_write, t);
-
-	return 0;
+			&z, sizeof(z), complete_agent_reset_write_no_wait, t);
 }
 
 static void sbp2_release_target(struct kref *kref)
@@ -1110,7 +1127,7 @@ complete_command_orb(struct sbp2_orb *ba
 
 	if (status != NULL) {
 		if (STATUS_GET_DEAD(*status))
-			sbp2_agent_reset(orb->lu);
+			sbp2_agent_reset_no_wait(orb->lu);
 
 		switch (STATUS_GET_RESPONSE(*status)) {
 		case SBP2_STATUS_REQUEST_COMPLETE:

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

