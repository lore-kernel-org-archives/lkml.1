Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYAILCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYAILCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYAILCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:02:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:38505 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYAILCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ORHAhv2Qqc4OzxNr3CZrUD0Jzaiuup2g91zEsOVvl0CLsQ9lmTHkQ12BrL1V5FYvPfvWlQHN/GapF5a5CX0mL+Ijsc+fgGL9beQw57n6X7lum74FX5rtXW74SYWzjZx/I92ExQc+admlFBt8zUN3H5ycVIYZeIlHf2v19tSPaHY=
From: Joonwoo Park <joonwpark81@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>, netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 1/5] iwlwifi: iwl3945 flush interrupt mask
Date: Wed,  9 Jan 2008 20:02:14 +0900
Message-Id: <11998765342443-git-send-email-joonwpark81@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling/disabling interrupts flushing is required

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 8a8b96f..f2bc30e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -87,6 +87,8 @@ static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
 #define iwl_read32(p, o) _iwl_read32(p, o)
 #endif
 
+#define iwl_flush32(iwl, ofs) iwl_read32(iwl, ofs)
+
 static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 				u32 bits, u32 mask, int timeout)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8ed898d..85f1112 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4410,6 +4410,7 @@ static void iwl_enable_interrupts(struct iwl_priv *priv)
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
 	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
+	iwl_flush32(priv, CSR_INT_MASK);
 }
 
 static inline void iwl_disable_interrupts(struct iwl_priv *priv)
@@ -4418,11 +4419,15 @@ static inline void iwl_disable_interrupts(struct iwl_priv *priv)
 
 	/* disable interrupts from uCode/NIC to host */
 	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+	iwl_flush32(priv, CSR_INT_MASK);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
 	iwl_write32(priv, CSR_INT, 0xffffffff);
+	iwl_flush32(priv, CSR_INT);
 	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
+	iwl_flush32(priv, CSR_FH_INT_STATUS);
+
 	IWL_DEBUG_ISR("Disabled interrupts\n");
 }
 
@@ -4840,6 +4845,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	 * If we *don't* have something, we'll re-enable before leaving here. */
 	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
 	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+	iwl_flush32(priv, CSR_INT_MASK);
 
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(priv, CSR_INT);
-- 
1.5.3.rc5

