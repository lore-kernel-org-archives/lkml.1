Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYBHVeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYBHVeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYBHVeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:34:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51210 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYBHVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:34:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 8 Feb 2008 22:33:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 11/9 update] firewire: fw-sbp2: enforce a retry of
 __scsi_add_device if bus generation changed
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <47ACB449.3060200@s5r6.in-berlin.de>
Message-ID: <tkrat.e02d667ba3320993@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
 <47A9FBFD.50100@s5r6.in-berlin.de>
 <tkrat.b66856ee2df66cd4@s5r6.in-berlin.de>
 <200802081354.23299.jwilson@redhat.com> <47ACB449.3060200@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed

fw-sbp2 is unable to reconnect while performing __scsi_add_device
because there is only a single workqueue thread context available for
both at the moment.  This should be fixed eventually.

An actual failure of __scsi_add_device is easy to handle, but an
incomplete execution of __scsi_add_device with an sdev returned would
remain undetected and leave the SBP-2 target unusable.

Therefore we use a workaround:  If there was a bus reset during
__scsi_add_device (i.e. during the SCSI probe), we remove the new sdev
immediately, log out, and attempt login and SCSI probe again.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

The previous patch "firewire: fw-sbp2: retry login if scsi_device was
offlined early" should be folded into this one before upstream
submission.

 drivers/firewire/fw-sbp2.c |   43 ++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -824,36 +824,31 @@ static void sbp2_login(struct work_struc
 
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
-	if (IS_ERR(sdev)) {
-		/*
-		 * The most frequent cause for __scsi_add_device() to fail
-		 * is a bus reset while sending the SCSI INQUIRY.  Try again.
-		 */
+	/*
+	 * FIXME:  We are unable to perform reconnects while in sbp2_login().
+	 * Therefore __scsi_add_device() will get into trouble if a bus reset
+	 * happens in parallel.  It will either fail or leave us with an
+	 * unusable sdev.  As a workaround we check for this and retry the
+	 * whole login and SCSI probing.
+	 */
+
+	if (IS_ERR(sdev))
 		goto out_logout_login;
 
-	} else if (sdev->sdev_state == SDEV_OFFLINE) {
-		/*
-		 * FIXME:  We are unable to perform reconnects while in
-		 * sbp2_login().  Therefore __scsi_add_device() will get
-		 * into trouble if a bus reset happens in parallel.
-		 * It will either fail (that's OK, see above) or take sdev
-		 * offline.  Here is a crude workaround for the latter.
-		 */
-		scsi_device_put(sdev);
+	scsi_device_put(sdev);
+
+	smp_rmb(); /* get current card generation */
+	if (generation != device->card->generation) {
 		scsi_remove_device(sdev);
 		goto out_logout_login;
-
-	} else {
-		/*
-		 * Can you believe it?  Everything went well.
-		 */
-		lu->sdev = sdev;
-		smp_wmb();  /* We need lu->sdev when we want to block lu. */
-		atomic_dec(&lu->tgt->dont_block);
-		scsi_device_put(sdev);
-		goto out;
 	}
 
+	/* Everything went well. */
+	lu->sdev = sdev;
+	smp_wmb();  /* We need lu->sdev when we want to block lu. */
+	atomic_dec(&lu->tgt->dont_block);
+	goto out;
+
  out_logout_login:
 	smp_rmb(); /* generation may have changed */
 	generation = device->generation;

-- 
Stefan Richter
-=====-==--- --=- -=---
http://arcgraph.de/sr/

