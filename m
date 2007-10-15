Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXJOFmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXJOFmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXJOFlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:41:51 -0400
Received: from ozlabs.org ([203.10.76.45]:53558 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbXJOFlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:41:49 -0400
Date: Mon, 15 Oct 2007 00:38:01 -0500
From: Anton Blanchard <anton@samba.org>
To: yi.zhu@intel.com, jketreno@linux.intel.com
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [PATCH] jiffies_round -> jiffies_round_relative conversion -
	ipw2100/ipw2200
Message-ID: <20071015053801.GB3257@kryten>
References: <20071015053428.GA3257@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015053428.GA3257@kryten>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When rounding a relative timeout we need to use round_jiffies_relative(). 

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 2d46a16..739d060 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -1769,7 +1769,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 		if (priv->stop_rf_kill) {
 			priv->stop_rf_kill = 0;
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(HZ));
+					   round_jiffies_relative(HZ));
 		}
 
 		deferred = 1;
@@ -2102,7 +2102,8 @@ static void isr_indicate_rf_kill(struct ipw2100_priv *priv, u32 status)
 	/* Make sure the RF Kill check timer is running */
 	priv->stop_rf_kill = 0;
 	cancel_delayed_work(&priv->rf_kill);
-	queue_delayed_work(priv->workqueue, &priv->rf_kill, round_jiffies(HZ));
+	queue_delayed_work(priv->workqueue, &priv->rf_kill,
+			   round_jiffies_relative(HZ));
 }
 
 static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
@@ -4237,7 +4238,7 @@ static int ipw_radio_kill_sw(struct ipw2100_priv *priv, int disable_radio)
 			priv->stop_rf_kill = 0;
 			cancel_delayed_work(&priv->rf_kill);
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(HZ));
+					   round_jiffies_relative(HZ));
 		} else
 			schedule_reset(priv);
 	}
@@ -5975,7 +5976,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 		IPW_DEBUG_RF_KILL("RF Kill active, rescheduling GPIO check\n");
 		if (!priv->stop_rf_kill)
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(HZ));
+					   round_jiffies_relative(HZ));
 		goto exit_unlock;
 	}
 
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index feb8fcb..88b0f81 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1753,7 +1753,7 @@ static int ipw_radio_kill_sw(struct ipw_priv *priv, int disable_radio)
 			/* Make sure the RF_KILL check timer is running */
 			cancel_delayed_work(&priv->rf_kill);
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   round_jiffies(2 * HZ));
+					   round_jiffies_relative(2 * HZ));
 		} else
 			queue_work(priv->workqueue, &priv->up);
 	}
@@ -4364,7 +4364,7 @@ static void handle_scan_event(struct ipw_priv *priv)
 	if (!priv->user_requested_scan) {
 		if (!delayed_work_pending(&priv->scan_event))
 			queue_delayed_work(priv->workqueue, &priv->scan_event,
-					 round_jiffies(msecs_to_jiffies(4000)));
+					 round_jiffies_relative(msecs_to_jiffies(4000)));
 	} else {
 		union iwreq_data wrqu;
 
@@ -4728,7 +4728,7 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 				 && priv->status & STATUS_ASSOCIATED)
 				queue_delayed_work(priv->workqueue,
 						   &priv->request_scan,
-						   round_jiffies(HZ));
+						   round_jiffies_relative(HZ));
 
 			/* Send an empty event to user space.
 			 * We don't send the received data on the event because
