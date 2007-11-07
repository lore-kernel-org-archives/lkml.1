Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXKGAMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXKGAMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXKGAMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:12:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53226 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbXKGAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:12:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Nov 2007 01:11:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: fw-sbp2: fix refcounting
To: linux1394-devel@lists.sourceforge.net
cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4730EE5D.6050708@s5r6.in-berlin.de>
Message-ID: <tkrat.e2b0bc32f455c4b6@s5r6.in-berlin.de>
References: <11810860252987-git-send-email-krh@redhat.com> 
 <466AD80C.6060802@s5r6.in-berlin.de>
 <59ad55d30706091352v92b825ch79924ba43a9d6cc8@mail.gmail.com>
 <466B1DE8.3010904@s5r6.in-berlin.de> <466C3BA6.9040602@s5r6.in-berlin.de>
 <46AB2C93.1090804@s5r6.in-berlin.de> <47235AD4.7030705@s5r6.in-berlin.de>
 <472397BC.3030308@s5r6.in-berlin.de>
 <tkrat.3f9b26b28897e271@s5r6.in-berlin.de>
 <4730EE5D.6050708@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since patch "fw-sbp2: use an own workqueue (fix system responsiveness)"
increased parallelism between fw-sbp2 and fw-core, it was possible that
fw-sbp2 didn't release the SCSI device when the FireWire device was
disconnected.

This happened if sbp2_update() ran during sbp2_login(), because a bus
reset occurred during sbp2_login().  The sbp2_login() work would [try
to] reschedule itself because it failed due to the bus reset, and it
would _not_ drop its reference on the target.  However, sbp2_update()
would schedule sbp2_login() too before sbp2_login() rescheduled itself
and hence sbp2_update() would take an additional reference.  And then
we would have one reference too many.

The fix is to _always_ drop the reference when leaving the sbp2_login()
work.  If the sbp2_login() work reschedules itself, it takes a
reference, but only if it wasn't already rescheduled by sbp2_update().

Ditto in the sbp2_reconnect() work.

The resulting code is actually simpler than before:  We _always_ take
a reference when successfully scheduling work.  And we _always_ drop
a reference when leaving a workqueue job.  No exceptions.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -650,13 +650,14 @@ static void sbp2_login(struct work_struc
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
 		if (lu->retries++ < 5) {
-			queue_delayed_work(sbp2_wq, &lu->work,
-					   DIV_ROUND_UP(HZ, 5));
+			if (queue_delayed_work(sbp2_wq, &lu->work,
+					       DIV_ROUND_UP(HZ, 5)))
+				kref_get(&lu->tgt->kref);
 		} else {
 			fw_error("failed to login to %s LUN %04x\n",
 				 unit->device.bus_id, lu->lun);
-			kref_put(&lu->tgt->kref, sbp2_release_target);
 		}
+		kref_put(&lu->tgt->kref, sbp2_release_target);
 		return;
 	}
 
@@ -914,7 +915,9 @@ static void sbp2_reconnect(struct work_s
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
-		queue_delayed_work(sbp2_wq, &lu->work, DIV_ROUND_UP(HZ, 5));
+		if (queue_delayed_work(sbp2_wq, &lu->work, DIV_ROUND_UP(HZ, 5)))
+			kref_get(&lu->tgt->kref);
+		kref_put(&lu->tgt->kref, sbp2_release_target);
 		return;
 	}
 

-- 
Stefan Richter
-=====-=-=== =-== --===
http://arcgraph.de/sr/

