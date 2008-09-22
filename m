Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYIVEEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYIVEEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYIVEEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:04:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44691 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYIVEEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:04:34 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: krkumar2@in.ibm.com, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 22 Sep 2008 09:34:31 +0530
Message-Id: <20080922040431.10477.8751.sendpatchset@localhost.localdomain>
In-Reply-To: <20080922040404.10477.24678.sendpatchset@localhost.localdomain>
References: <20080922040404.10477.24678.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/2]: workqueue: Modify some users to use the new API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Modify some users to use the new API.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 drivers/net/wireless/ipw2100.c       |   12 ++++++------
 drivers/net/wireless/libertas/scan.c |    5 ++---
 drivers/net/wireless/libertas/wext.c |    7 +++----
 fs/afs/vlocation.c                   |   11 +++--------
 fs/ocfs2/cluster/heartbeat.c         |    5 ++---
 5 files changed, 16 insertions(+), 24 deletions(-)

diff -ruNp 2.6.27-rc7-org/drivers/net/wireless/ipw2100.c 2.6.27-rc7-new/drivers/net/wireless/ipw2100.c
--- 2.6.27-rc7-org/drivers/net/wireless/ipw2100.c	2008-09-17 13:15:53.000000000 +0530
+++ 2.6.27-rc7-new/drivers/net/wireless/ipw2100.c	2008-09-17 13:26:08.000000000 +0530
@@ -2085,9 +2085,8 @@ static void isr_indicate_rf_kill(struct 
 
 	/* Make sure the RF Kill check timer is running */
 	priv->stop_rf_kill = 0;
-	cancel_delayed_work(&priv->rf_kill);
-	queue_delayed_work(priv->workqueue, &priv->rf_kill,
-			   round_jiffies_relative(HZ));
+	queue_update_delayed_work(priv->workqueue, &priv->rf_kill,
+				  round_jiffies_relative(HZ));
 }
 
 static void send_scan_event(void *data)
@@ -4241,9 +4240,10 @@ static int ipw_radio_kill_sw(struct ipw2
 					  "disabled by HW switch\n");
 			/* Make sure the RF_KILL check timer is running */
 			priv->stop_rf_kill = 0;
-			cancel_delayed_work(&priv->rf_kill);
-			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies_relative(HZ));
+
+			queue_update_delayed_work(priv->workqueue,
+						  &priv->rf_kill,
+						  round_jiffies_relative(HZ));
 		} else
 			schedule_reset(priv);
 	}
diff -ruNp 2.6.27-rc7-org/drivers/net/wireless/libertas/scan.c 2.6.27-rc7-new/drivers/net/wireless/libertas/scan.c
--- 2.6.27-rc7-org/drivers/net/wireless/libertas/scan.c	2008-09-17 13:15:53.000000000 +0530
+++ 2.6.27-rc7-new/drivers/net/wireless/libertas/scan.c	2008-09-17 13:27:46.000000000 +0530
@@ -435,9 +435,8 @@ int lbs_scan_networks(struct lbs_private
 				priv->scan_channel = to_scan;
 			else
 				priv->scan_channel += to_scan;
-			cancel_delayed_work(&priv->scan_work);
-			queue_delayed_work(priv->work_thread, &priv->scan_work,
-					   msecs_to_jiffies(300));
+			queue_update_delayed_work(priv->work_thread,
+				&priv->scan_work, msecs_to_jiffies(300));
 			/* skip over GIWSCAN event */
 			goto out;
 		}
diff -ruNp 2.6.27-rc7-org/drivers/net/wireless/libertas/wext.c 2.6.27-rc7-new/drivers/net/wireless/libertas/wext.c
--- 2.6.27-rc7-org/drivers/net/wireless/libertas/wext.c	2008-09-17 13:15:53.000000000 +0530
+++ 2.6.27-rc7-new/drivers/net/wireless/libertas/wext.c	2008-09-17 13:26:08.000000000 +0530
@@ -24,10 +24,9 @@
 
 static inline void lbs_postpone_association_work(struct lbs_private *priv)
 {
-	if (priv->surpriseremoved)
-		return;
-	cancel_delayed_work(&priv->assoc_work);
-	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
+	if (!priv->surpriseremoved)
+		queue_update_delayed_work(priv->work_thread, &priv->assoc_work,
+					  HZ / 2);
 }
 
 static inline void lbs_cancel_association_work(struct lbs_private *priv)
diff -ruNp 2.6.27-rc7-org/fs/afs/vlocation.c 2.6.27-rc7-new/fs/afs/vlocation.c
--- 2.6.27-rc7-org/fs/afs/vlocation.c	2008-09-17 13:15:53.000000000 +0530
+++ 2.6.27-rc7-new/fs/afs/vlocation.c	2008-09-17 13:26:08.000000000 +0530
@@ -557,12 +557,8 @@ static void afs_vlocation_reaper(struct 
 		if (expiry > now) {
 			delay = (expiry - now) * HZ;
 			_debug("delay %lu", delay);
-			if (!schedule_delayed_work(&afs_vlocation_reap,
-						   delay)) {
-				cancel_delayed_work(&afs_vlocation_reap);
-				schedule_delayed_work(&afs_vlocation_reap,
-						      delay);
-			}
+			schedule_update_delayed_work(&afs_vlocation_reap,
+						     delay);
 			break;
 		}
 
@@ -615,8 +611,7 @@ void afs_vlocation_purge(void)
 			   &afs_vlocation_update, 0);
 	destroy_workqueue(afs_vlocation_update_worker);
 
-	cancel_delayed_work(&afs_vlocation_reap);
-	schedule_delayed_work(&afs_vlocation_reap, 0);
+	schedule_update_delayed_work(&afs_vlocation_reap, 0);
 }
 
 /*
diff -ruNp 2.6.27-rc7-org/fs/ocfs2/cluster/heartbeat.c 2.6.27-rc7-new/fs/ocfs2/cluster/heartbeat.c
--- 2.6.27-rc7-org/fs/ocfs2/cluster/heartbeat.c	2008-09-17 13:15:53.000000000 +0530
+++ 2.6.27-rc7-new/fs/ocfs2/cluster/heartbeat.c	2008-09-17 13:26:08.000000000 +0530
@@ -172,10 +172,9 @@ static void o2hb_arm_write_timeout(struc
 {
 	mlog(0, "Queue write timeout for %u ms\n", O2HB_MAX_WRITE_TIMEOUT_MS);
 
-	cancel_delayed_work(&reg->hr_write_timeout_work);
 	reg->hr_last_timeout_start = jiffies;
-	schedule_delayed_work(&reg->hr_write_timeout_work,
-			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
+	schedule_update_delayed_work(&reg->hr_write_timeout_work,
+			msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
 }
 
 static void o2hb_disarm_write_timeout(struct o2hb_region *reg)
