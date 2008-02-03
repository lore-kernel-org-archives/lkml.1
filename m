Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYBCWL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYBCWL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYBCWLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:11:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47879 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYBCWLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:11:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:11:39 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 7/9] firewire: fw-sbp2: logout and login after failed
 reconnect
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.4988439f2c8906f5@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fw-sbp2 was too late with requesting the reconnect, the target would
reject this.  In this case, log out before attempting the reconnect.
Else several firmwares will deny the re-login because they somehow
didn't invalidate the old login.

Also, don't retry reconnects in this situation.  The retries won't
succeed either.

These changes improve chances for successful re-login and shorten the
period during which the logical unit is inaccessible.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -710,6 +710,11 @@ static void sbp2_login(struct work_struc
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
+	/* If this is a re-login attempt, log out, or we might be rejected. */
+	if (lu->sdev)
+		sbp2_send_management_orb(lu, device->node_id, generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
 		if (lu->retries++ < 5)
@@ -1021,9 +1026,17 @@ static void sbp2_reconnect(struct work_s
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,
 				     lu->login_id, NULL) < 0) {
-		if (lu->retries++ >= 5) {
+		/*
+		 * If reconnect was impossible even though we are in the
+		 * current generation, fall back and try to log in again.
+		 *
+		 * We could check for "Function rejected" status, but
+		 * looking at the bus generation as simpler and more general.
+		 */
+		smp_rmb(); /* get current card generation */
+		if (generation == device->card->generation ||
+		    lu->retries++ >= 5) {
 			fw_error("%s: failed to reconnect\n", tgt->bus_id);
-			/* Fall back and try to log in again. */
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

