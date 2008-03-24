Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYCXT4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYCXT4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYCXT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:56:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51893 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYCXT42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:56:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:54:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] amendment to "firewire: reread config ROM when device reset
 the bus"
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.404f0a7603ed030f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This applies after and should be rolled into patch "firewire: reread
config ROM when device reset the bus".

Fix:
fw_device_refresh() sometimes forgot to reschedule the bus manager work.
Among else, this kept the bus in danger of PHYs having different gap
counts, which resulted in "giving up on config ROM" or other errors.

Optimization:
We can start re-reading the config ROM of the local node without dealy.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/firewire/fw-device.c	2008-03-24 19:10:42.000000000 +0100
+++ b/drivers/firewire/fw-device.c	2008-03-24 19:09:42.000000000 +0100
@@ -877,8 +877,7 @@ static void fw_device_refresh(struct wor
 
 		fw_device_update(work);
 		device->config_rom_retries = 0;
-
-		return;
+		goto out;
 
 	case REREAD_BIB_CHANGED:
 		break;
@@ -982,7 +981,8 @@ void fw_node_event(struct fw_card *card,
 			    FW_DEVICE_RUNNING,
 			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
-			schedule_delayed_work(&device->work, INITIAL_DELAY);
+			schedule_delayed_work(&device->work,
+				node == card->local_node ? 0 : INITIAL_DELAY);
 		}
 		break;
 

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/

