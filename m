Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbXKGANQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbXKGANQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXKGANA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:13:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53243 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXKGAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:12:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Nov 2007 01:12:51 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: fw-sbp2: refactor workq and kref handling
To: linux1394-devel@lists.sourceforge.net
cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.e2b0bc32f455c4b6@s5r6.in-berlin.de>
Message-ID: <tkrat.18e59e3853b8aa98@s5r6.in-berlin.de>
References: <11810860252987-git-send-email-krh@redhat.com> 
 <466AD80C.6060802@s5r6.in-berlin.de>
 <59ad55d30706091352v92b825ch79924ba43a9d6cc8@mail.gmail.com>
 <466B1DE8.3010904@s5r6.in-berlin.de> <466C3BA6.9040602@s5r6.in-berlin.de>
 <46AB2C93.1090804@s5r6.in-berlin.de> <47235AD4.7030705@s5r6.in-berlin.de>
 <472397BC.3030308@s5r6.in-berlin.de>
 <tkrat.3f9b26b28897e271@s5r6.in-berlin.de>
 <4730EE5D.6050708@s5r6.in-berlin.de>
 <tkrat.e2b0bc32f455c4b6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This somewhat reduces the size of firewire-sbp2.ko.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   56 +++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -628,6 +628,21 @@ static void sbp2_release_target(struct k
 
 static struct workqueue_struct *sbp2_wq;
 
+/*
+ * Always get the target's kref when scheduling work on one its units.
+ * Each workqueue job is responsible to call sbp2_target_put() upon return.
+ */
+static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
+{
+	if (queue_delayed_work(sbp2_wq, &lu->work, delay))
+		kref_get(&lu->tgt->kref);
+}
+
+static void sbp2_target_put(struct sbp2_target *tgt)
+{
+	kref_put(&tgt->kref, sbp2_release_target);
+}
+
 static void sbp2_reconnect(struct work_struct *work);
 
 static void sbp2_login(struct work_struct *work)
@@ -649,16 +664,12 @@ static void sbp2_login(struct work_struc
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
-		if (lu->retries++ < 5) {
-			if (queue_delayed_work(sbp2_wq, &lu->work,
-					       DIV_ROUND_UP(HZ, 5)))
-				kref_get(&lu->tgt->kref);
-		} else {
+		if (lu->retries++ < 5)
+			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
+		else
 			fw_error("failed to login to %s LUN %04x\n",
 				 unit->device.bus_id, lu->lun);
-		}
-		kref_put(&lu->tgt->kref, sbp2_release_target);
-		return;
+		goto out;
 	}
 
 	lu->generation        = generation;
@@ -700,7 +711,8 @@ static void sbp2_login(struct work_struc
 		lu->sdev = sdev;
 		scsi_device_put(sdev);
 	}
-	kref_put(&lu->tgt->kref, sbp2_release_target);
+ out:
+	sbp2_target_put(lu->tgt);
 }
 
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
@@ -865,18 +877,13 @@ static int sbp2_probe(struct device *dev
 
 	get_device(&unit->device);
 
-	/*
-	 * We schedule work to do the login so we can easily
-	 * reschedule retries. Always get the ref before scheduling
-	 * work.
-	 */
+	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		if (queue_delayed_work(sbp2_wq, &lu->work, 0))
-			kref_get(&tgt->kref);
+		sbp2_queue_work(lu, 0);
 	return 0;
 
  fail_tgt_put:
-	kref_put(&tgt->kref, sbp2_release_target);
+	sbp2_target_put(tgt);
 	return -ENOMEM;
 
  fail_shost_put:
@@ -889,7 +896,7 @@ static int sbp2_remove(struct device *de
 	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = unit->device.driver_data;
 
-	kref_put(&tgt->kref, sbp2_release_target);
+	sbp2_target_put(tgt);
 	return 0;
 }
 
@@ -915,10 +922,8 @@ static void sbp2_reconnect(struct work_s
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
-		if (queue_delayed_work(sbp2_wq, &lu->work, DIV_ROUND_UP(HZ, 5)))
-			kref_get(&lu->tgt->kref);
-		kref_put(&lu->tgt->kref, sbp2_release_target);
-		return;
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
+		goto out;
 	}
 
 	lu->generation        = generation;
@@ -930,8 +935,8 @@ static void sbp2_reconnect(struct work_s
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
-
-	kref_put(&lu->tgt->kref, sbp2_release_target);
+ out:
+	sbp2_target_put(lu->tgt);
 }
 
 static void sbp2_update(struct fw_unit *unit)
@@ -947,8 +952,7 @@ static void sbp2_update(struct fw_unit *
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link) {
 		lu->retries = 0;
-		if (queue_delayed_work(sbp2_wq, &lu->work, 0))
-			kref_get(&tgt->kref);
+		sbp2_queue_work(lu, 0);
 	}
 }
 

-- 
Stefan Richter
-=====-=-=== =-== --===
http://arcgraph.de/sr/

