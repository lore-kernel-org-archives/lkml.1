Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYFXCmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYFXCmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYFXCmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:42:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:29064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbYFXCmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,693,1204531200"; 
   d="scan'208";a="581229630"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806232103.31283.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806230732.44159.Michal.Kudla@gmail.com>
	 <1214200366.14590.150.camel@debian.sh.intel.com>
	 <200806232103.31283.Michal.Kudla@gmail.com>
Content-Type: multipart/mixed; boundary="=-xwfgHcmkLMjmJXxuIx1J"
Organization: Intel Corp.
Date: Tue, 24 Jun 2008 10:41:15 +0800
Message-Id: <1214275275.14590.194.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xwfgHcmkLMjmJXxuIx1J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 2008-06-23 at 21:03 +0200, Michał Kudła wrote:
> 
> I attached files form console log and dmesg
> console-rfkill-0.txt
> dmesg-2.6.26-rc7_2008-06-23-rfkill-0.txt
> console-rfkill-1.txt
> dmesg-2.6.26-rc7_2008-06-23-rfkill-1.txt

Please try attached patch.

Thanks,
-yi

--=-xwfgHcmkLMjmJXxuIx1J
Content-Disposition: attachment; filename=linux-2.6.26-rc7-sw-rfkill.patch
Content-Type: text/x-patch; name=linux-2.6.26-rc7-sw-rfkill.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 883b42f..39cab88 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2444,7 +2444,8 @@ void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
-	clear_bit(STATUS_RF_KILL_SW, &priv->status);
+	if (!priv->is_open)
+		clear_bit(STATUS_RF_KILL_SW, &priv->status);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* wake up ucode */
@@ -2462,7 +2463,6 @@ void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 		return;
 	}
 
-	queue_work(priv->workqueue, &priv->restart);
 	return;
 }
 
@@ -5534,13 +5534,15 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	if (iwl_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-	else {
+	else
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
-		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
-			iwl_rfkill_set_hw_state(priv);
-			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
-			return -ENODEV;
-		}
+
+	if (!test_bit(STATUS_IN_SUSPEND, &priv->status) &&
+	    iwl_is_rfkill(priv)) {
+		iwl_rfkill_set_hw_state(priv);
+		IWL_WARNING("Radio disabled by %s RF Kill switch\n",
+		    test_bit(STATUS_RF_KILL_HW, &priv->status) ? "HW" : "SW");
+		return -ENODEV;
 	}
 
 	iwl_rfkill_set_hw_state(priv);

--=-xwfgHcmkLMjmJXxuIx1J--

