Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXKGBV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXKGBV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbXKGBUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:20:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54647 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbXKGBUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:20:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Nov 2007 02:20:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire update
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.9427ebfc20439622@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following fix for a regression since 2.6.24-rc1.
(Or apply from this e-mail.)

 drivers/firewire/fw-sbp2.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

Stefan Richter (1):
      firewire: fw-sbp2: fix refcounting


Full log and diff:

commit 7c45d1913f0a1d597eb4bc3b2c962bc2967da9ea
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Nov 7 01:11:56 2007 +0100

    firewire: fw-sbp2: fix refcounting
    
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

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 5596df6..624ff3e 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -650,13 +650,14 @@ static void sbp2_login(struct work_struct *work)
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
 
@@ -914,7 +915,9 @@ static void sbp2_reconnect(struct work_struct *work)
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

