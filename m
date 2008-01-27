Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYA0SP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYA0SP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbYA0SPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:15:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53917 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbYA0SPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:15:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 Jan 2008 19:14:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: don't retry login or reconnect after
 unplug
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Message-ID: <tkrat.98202457f6ba93dd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a device is being unplugged while fw-sbp2 had a login or reconnect on
schedule, it would take about half a minute to shut the fw_unit down:

Jan 27 18:34:54 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0 retries)
<unplug>
Jan 27 18:34:59 stein firewire_sbp2: sbp2_scsi_abort
Jan 27 18:34:59 stein scsi 25:0:0:0: Device offlined - not ready after error recovery
Jan 27 18:35:01 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:06 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:12 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:17 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:22 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:27 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:32 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 27 18:35:32 stein firewire_sbp2: failed to login to fw2.0 LUN 0000
Jan 27 18:35:32 stein firewire_sbp2: released fw2.0

After this patch, typically only a few seconds spent in __scsi_add_device
remain:

Jan 27 19:05:50 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0 retries)
<unplug>
Jan 27 19:05:56 stein firewire_sbp2: sbp2_scsi_abort
Jan 27 19:05:56 stein scsi 33:0:0:0: Device offlined - not ready after error recovery
Jan 27 19:05:56 stein firewire_sbp2: released fw2.0

The benefit of this is negligible on simple setups.  But on buses with
several devices, we should avoid any unnecessary blockade of fw-sbp2's
workqueue thread.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -499,6 +499,9 @@ sbp2_send_management_orb(struct sbp2_log
 	unsigned int timeout;
 	int retval = -ENOMEM;
 
+	if (function == SBP2_LOGOUT_REQUEST && fw_device_is_shutdown(device))
+		return 0;
+
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL)
 		return -ENOMEM;
@@ -619,16 +622,13 @@ static void sbp2_release_target(struct k
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
-	struct fw_device *device = fw_device(tgt->unit->device.parent);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
 		if (lu->sdev)
 			scsi_remove_device(lu->sdev);
 
-		if (!fw_device_is_shutdown(device))
-			sbp2_send_management_orb(lu, tgt->node_id,
-					lu->generation, SBP2_LOGOUT_REQUEST,
-					lu->login_id, NULL);
+		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
 		fw_core_remove_address_handler(&lu->address_handler);
 		list_del(&lu->link);
@@ -673,6 +673,9 @@ static void sbp2_login(struct work_struc
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
+	if (fw_device_is_shutdown(device))
+		goto out;
+
 	generation    = device->generation;
 	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
@@ -968,6 +971,9 @@ static void sbp2_reconnect(struct work_s
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
+	if (fw_device_is_shutdown(device))
+		goto out;
+
 	generation    = device->generation;
 	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;

-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/

