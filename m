Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYAILDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYAILDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYAILCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:02:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:38512 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYAILCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:02:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Zx7ztxvZ2epIORGykKsre+kiZ33wmvQuRgF0BQO8gqKGO4G/JOTlYU6vA4x9LBmCz6Av2QSZ4NMmyWBwgN4NJpQY6zOq2r6J9JpGTT7ud0jLpl4o5cZKzLVIV4qVpr5PVJFb5PKNC8tjPugqlDrWuKJm23wWUpXd2uA9h706lAg=
From: Joonwoo Park <joonwpark81@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>, netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 2/5] iwlwifi: iwl3945 synchronize interrupt and tasklet for down iwlwifi
Date: Wed,  9 Jan 2008 20:02:28 +0900
Message-Id: <11998765481610-git-send-email-joonwpark81@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After disabling interrupts, it's possible irq & tasklet is pending or running
This patch eleminates races for down iwlwifi

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c97448d..3986aaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6262,6 +6262,10 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(priv);
 
+	/* synchronize irq and tasklet */
+	synchronize_irq(priv->pci_dev->irq);
+	tasklet_kill(&priv->irq_tasklet);
+
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-- 
1.5.3.rc5

