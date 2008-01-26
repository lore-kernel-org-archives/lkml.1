Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYAZQpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYAZQpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYAZQpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:45:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYAZQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:45:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Jan 2008 17:44:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] firewire: fw-sbp2: retry login if scsi_device was
 offlined early
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
Message-ID: <tkrat.4c73e3fae259fbf4@s5r6.in-berlin.de>
References: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes yet another "can't recognize device" bug.

https://bugzilla.redhat.com/show_bug.cgi?id=428554#c16 :
If a bus reset happens after the login and SCSI INQUIRY succeeded ---
but before scsi_driver.init_command finished ---, SCSI core would take
the brand new scsi_device offline already, leaving the SBP-2 target
inaccessible.

The proper fix would be to allow sbp2_reconnect to happen in parallel to
__scsi_add_device.  This involves intrusive changes to fw-sbp2.  Until
then, we use the following simple workaround:  Check if the new sdev is
offline; if so, remove the device, logout, and let another login attempt
happen.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Depends on patch 2/3.  Has yet to be tested by the Fedora bug reporter.

 drivers/firewire/fw-sbp2.c |   40 +++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -716,21 +716,45 @@ static void sbp2_login(struct work_struc
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
 	if (IS_ERR(sdev)) {
-		smp_rmb(); /* generation may have changed */
-		generation = device->generation;
-		smp_rmb(); /* node_id must not be older than generation */
+		/*
+		 * The most frequent cause for __scsi_add_device() to fail
+		 * is a bus reset while sending the SCSI INQUIRY.  Try again.
+		 */
+		goto out_logout_login;
 
-		sbp2_send_management_orb(lu, device->node_id, generation,
-				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+	} else if (sdev->sdev_state == SDEV_OFFLINE) {
 		/*
-		 * Set this back to sbp2_login so we fall back and
-		 * retry login on bus reset.
+		 * FIXME:  We are unable to perform reconnects while in
+		 * sbp2_login().  Therefore __scsi_add_device() will get
+		 * into trouble if a bus reset happens in parallel.
+		 * It will either fail (that's OK, see above) or take sdev
+		 * offline.  Here is a crude workaround for the latter.
 		 */
-		PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+		scsi_device_put(sdev);
+		scsi_remove_device(sdev);
+		goto out_logout_login;
+
 	} else {
+		/*
+		 * Can you believe it?  Everything went well.
+		 */
 		lu->sdev = sdev;
 		scsi_device_put(sdev);
+		goto out;
 	}
+
+ out_logout_login:
+	smp_rmb(); /* generation may have changed */
+	generation = device->generation;
+	smp_rmb(); /* node_id must not be older than generation */
+
+	sbp2_send_management_orb(lu, device->node_id, generation,
+				 SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+	/*
+	 * If a bus reset happened, sbp2_update will have requeued
+	 * lu->work already.  Reset the work from reconnect to login.
+	 */
+	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
  out:
 	sbp2_target_put(lu->tgt);
 }

-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/

