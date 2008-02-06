Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbYBFVKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbYBFVKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYBFVK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:10:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55066 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbYBFVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:10:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 6 Feb 2008 22:09:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 11/9] firewire: fw-sbp2: enforce a retry of __scsi_add_device
 if bus generation changed
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47A9FBFD.50100@s5r6.in-berlin.de>
Message-ID: <tkrat.b66856ee2df66cd4@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
 <200802060017.06958.jwilson@redhat.com> <47A9FBFD.50100@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw-sbp2 is unable to reconnect while performing __scsi_add_device
because there is only a single workqueue thread context available for
both at the moment.  This should be fixed eventually.

Until then, take care that __scsi_add_device does not return success
even though the SCSI high-level driver probing failed (sd READ_CAPACITY
and friends) due to bus reset.  The trick to do so is to use a different
error indicator in the command completion as long as __scsi_add_device
did not return.

An actual failure of __scsi_add_device is easy to handle, but an
incomplete execution of __scsi_add_device with an sdev returned would
remain undetected and leave the SBP-2 target unusable.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Jarod, does this work like I assume and fixes your setup of two OXFW911
based disks?

 drivers/firewire/fw-sbp2.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -825,28 +825,17 @@ static void sbp2_login(struct work_struc
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
 	if (IS_ERR(sdev)) {
-		/*
-		 * The most frequent cause for __scsi_add_device() to fail
-		 * is a bus reset while sending the SCSI INQUIRY.  Try again.
-		 */
+		/* Probably a bus reset happened.  Try again. */
 		goto out_logout_login;
 
 	} else if (sdev->sdev_state == SDEV_OFFLINE) {
-		/*
-		 * FIXME:  We are unable to perform reconnects while in
-		 * sbp2_login().  Therefore __scsi_add_device() will get
-		 * into trouble if a bus reset happens in parallel.
-		 * It will either fail (that's OK, see above) or take sdev
-		 * offline.  Here is a crude workaround for the latter.
-		 */
+		/* Something else happened which left the device unusable. */
 		scsi_device_put(sdev);
 		scsi_remove_device(sdev);
 		goto out_logout_login;
 
 	} else {
-		/*
-		 * Can you believe it?  Everything went well.
-		 */
+		/* Can you believe it?  Everything went well. */
 		lu->sdev = sdev;
 		smp_wmb();  /* We need lu->sdev when we want to block lu. */
 		atomic_dec(&lu->tgt->dont_block);
@@ -1237,8 +1226,18 @@ complete_command_orb(struct sbp2_orb *ba
 		 * If the orb completes with status == NULL, something
 		 * went wrong, typically a bus reset happened mid-orb
 		 * or when sending the write (less likely).
+		 *
+		 * Normally, tell the SCSI core we are busy so that the
+		 * command is retried.  But if the sdev is still being
+		 * set up, pretend that the device went away so that
+		 * __scsi_add_device will fail. sbp2_login will retry it.
+		 *
+		 * FIXME:  There is potentially a small window after
+		 * __scsi_add_device returned but before lu->sdev is
+		 * set during which we rather want to say DID_BUS_BUSY.
 		 */
-		result = DID_BUS_BUSY << 16;
+		result = orb->lu->sdev != NULL ? DID_BUS_BUSY << 16 :
+						 DID_NO_CONNECT << 16;
 		sbp2_conditionally_block(orb->lu);
 	}
 

-- 
Stefan Richter
-=====-==--- --=- --==-
http://arcgraph.de/sr/

