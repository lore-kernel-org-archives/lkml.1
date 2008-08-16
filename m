Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYHPLjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYHPLjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 07:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYHPLjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 07:39:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45819 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYHPLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 07:39:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 13:39:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 3/3] ieee1394: sbp2: let nodemgr retry node updates during bus
 reset series
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, damien_benoist@yahoo.com
In-Reply-To: <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
Message-ID: <tkrat.5bc1689ebb141ddb@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
 <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
 <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbp2 was too quick to run away screaming "Failed to reconnect to sbp2
device!" when additional nodes on the same bus came online.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -733,15 +733,26 @@ static int sbp2_update(struct unit_direc
 {
 	struct sbp2_lu *lu = ud->device.driver_data;
 
-	if (sbp2_reconnect_device(lu)) {
-		/* Reconnect has failed. Perhaps we didn't reconnect fast
-		 * enough. Try a regular login, but first log out just in
-		 * case of any weirdness. */
+	if (sbp2_reconnect_device(lu) != 0) {
+		/*
+		 * Reconnect failed.  If another bus reset happened,
+		 * let nodemgr proceed and call sbp2_update again later
+		 * (or sbp2_remove if this node went away).
+		 */
+		if (!hpsb_node_entry_valid(lu->ne))
+			return 0;
+		/*
+		 * Or the target rejected the reconnect because we weren't
+		 * fast enough.  Try a regular login, but first log out
+		 * just in case of any weirdness.
+		 */
 		sbp2_logout_device(lu);
 
-		if (sbp2_login_device(lu)) {
-			/* Login failed too, just fail, and the backend
-			 * will call our sbp2_remove for us */
+		if (sbp2_login_device(lu) != 0) {
+			if (!hpsb_node_entry_valid(lu->ne))
+				return 0;
+
+			/* Maybe another initiator won the login. */
 			SBP2_ERR("Failed to reconnect to sbp2 device!");
 			return -EBUSY;
 		}

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

