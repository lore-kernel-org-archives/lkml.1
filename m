Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbXLFJjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbXLFJjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXLFJje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:39:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:50977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXLFJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:39:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=n3ajYQ6IHKyXt/X5KsKdhSeSEI1slgKdPrLINrx4mFHsJqN85e+2iYJMjxTI9wJ5Dl5lbFiowGOoBL8a9WM6PZlbbBKbtW1aT9kR9SSNYxic/j9y1uuWNYWgFdWXxmOD1jm1EBitgJy4WFpjU7oQf9gDdWgfwCTAzF9kjSAwcNk=
Date: Thu, 6 Dec 2007 12:39:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Tuttle <linux-kernel@ttuttle.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Wu <flamingice@sourmilk.net>,
       LWML <linux-wireless@vger.kernel.org>
Subject: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
Message-ID: <20071206093922.GA7356@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

could you test this one please.

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak

This patch does fix rate control algo reference leak in case
if network device has been failed to register. In this case
special flag priv->mac80211_registered is not set and the
rate algo reference is not freeing on module unload. That leads
to OOPs in further ieee80211 rate register/unregister procedure
(by any callee).

It should fix the bug #9470

	http://bugzilla.kernel.org/show_bug.cgi?id=9470

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 465da4f..c222bec 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6167,6 +6167,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9918780..9295755 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6523,6 +6523,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
-- 
1.5.3.5

