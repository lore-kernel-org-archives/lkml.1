Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYAILDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYAILDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYAILDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:03:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:38512 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbYAILDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t9SRwu48MSyPnXLoVLSP4pEgI3kxZ8mSVRok4B3YbqLBupejfGDYLrbFEuCfJaYix42HQmJlVo7alSqH3gWOLOjMDwEREXZlftJVSrHS/9UurpDPmyaX6uqKmTw+qw6Jdi2Ky9vnh8zWsX1KAdekwlA/EWilFObbn650INfU7D0=
From: Joonwoo Park <joonwpark81@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>, netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 4/5] iwlwifi: iwl3945 eliminate sleepable task queue from context
Date: Wed,  9 Jan 2008 20:02:58 +0900
Message-Id: <11998765783953-git-send-email-joonwpark81@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eleminiate task queuing of iwl_pci_probe, register hw to ieee80211 immediately

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   66 +++++++++++++++++---------
 1 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f95f226..7e8d8b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6171,27 +6171,9 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_rfkill(priv))
 		return;
 
-	if (!priv->mac80211_registered) {
-		/* Unlock so any user space entry points can call back into
-		 * the driver without a deadlock... */
-		mutex_unlock(&priv->mutex);
-		iwl_rate_control_register(priv->hw);
-		rc = ieee80211_register_hw(priv->hw);
-		priv->hw->conf.beacon_int = 100;
-		mutex_lock(&priv->mutex);
-
-		if (rc) {
-			iwl_rate_control_unregister(priv->hw);
-			IWL_ERROR("Failed to register network "
-				  "device (error %d)\n", rc);
-			return;
-		}
-
-		priv->mac80211_registered = 1;
+	iwl_reset_channel_flag(priv);
 
-		iwl_reset_channel_flag(priv);
-	} else
-		ieee80211_start_queues(priv->hw);
+	ieee80211_start_queues(priv->hw);
 
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
@@ -6369,7 +6351,8 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	if (priv->mac80211_registered)
+		iwl_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
@@ -6887,10 +6870,21 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 
 static int iwl_mac_start(struct ieee80211_hw *hw)
 {
+	int ret;
 	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+			iwl_is_ready(priv), HOST_COMPLETE_TIMEOUT);
+
+	if (ret == -ERESTARTSYS)
+		return ret;
+	else if (ret == 0 && !iwl_is_ready(priv)) {
+		IWL_ERROR("IWL ready timeout\n");
+		return -ETIMEDOUT;
+	}
+
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
@@ -8299,6 +8293,19 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->beacon_update);
 }
 
+static int iwl_register_hw(struct iwl_priv *priv)
+{
+	int err;
+	IWL_DEBUG_INFO("register_hw\n");
+	iwl_rate_control_register(priv->hw);
+	err = ieee80211_register_hw(priv->hw);
+	if (!err) {
+		priv->hw->conf.beacon_int = 100;
+		priv->mac80211_registered = 1;
+	}
+	return err;
+}
+
 static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_antenna.attr,
 	&dev_attr_channels.attr,
@@ -8546,11 +8553,24 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_pci_alloc;
 	}
 
+	err = __iwl_up(priv);
+	if (err) {
+		IWL_ERROR("Could not make up interface : %d\n", err);
+		mutex_unlock(&priv->mutex);
+		goto out_pci_alloc;
+	}
+
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_INFO("Queing UP work.\n");
+	err = iwl_register_hw(priv);
+	if (err) {
+		iwl_rate_control_unregister(priv->hw);
+		IWL_ERROR("Failed to register network "
+			  "device (error %d)\n", err);
+		goto out_pci_alloc;
+	}
 
-	queue_work(priv->workqueue, &priv->up);
+	iwl_enable_interrupts(priv);
 
 	return 0;
 
-- 
1.5.3.rc5

