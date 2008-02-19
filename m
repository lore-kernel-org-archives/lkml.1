Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYBSIGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYBSIGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYBSIF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:05:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39513 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYBSIF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:05:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Feb 2008 09:05:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fw-sbp2: fix NULL pointer deref in
 scsi_remove_device
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <tkrat.bc89a18c9ce7df0b@s5r6.in-berlin.de>
Message-ID: <tkrat.c814d52432988f28@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
 <tkrat.9103805c20697161@s5r6.in-berlin.de>
 <tkrat.bc89a18c9ce7df0b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a kernel bug when unplugging an SBP-2 device after having its
scsi_device already removed via the "delete" sysfs attribute.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  A _put was missing in a failure path.

 drivers/firewire/fw-sbp2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -762,9 +762,10 @@ static void sbp2_release_target(struct k
 	sbp2_unblock(tgt);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
-		if (lu->sdev)
+		if (lu->sdev) {
 			scsi_remove_device(lu->sdev);
-
+			scsi_device_put(lu->sdev);
+		}
 		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
@@ -886,12 +887,11 @@ static void sbp2_login(struct work_struc
 	if (IS_ERR(sdev))
 		goto out_logout_login;
 
-	scsi_device_put(sdev);
-
 	/* Unreported error during __scsi_add_device() */
 	smp_rmb(); /* get current card generation */
 	if (generation != device->card->generation) {
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
 		goto out_logout_login;
 	}
 

-- 
Stefan Richter
-=====-==--- --=- =--==
http://arcgraph.de/sr/

