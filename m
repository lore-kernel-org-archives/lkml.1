Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYDWXW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYDWXW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYDWXWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:22:17 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:17032 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYDWXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:22:16 -0400
From: Roland Dreier <rdreier@cisco.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: Don't unlock priv->mutex if it isn't locked
References: <c4e36d110804231600l4b540a3ka637dedca0d7687b@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Apr 2008 16:22:13 -0700
In-Reply-To: <c4e36d110804231600l4b540a3ka637dedca0d7687b@mail.gmail.com>
	(Zdenek Kabelac's message of "Thu, 24 Apr 2008 01:00:34 +0200")
Message-ID: <adazlrk88d6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 23:22:13.0410 (UTC) FILETIME=[DC901020:01C8A598]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b716bb91 ("iwlwifi: Cancel scanning upon association") moved the
test of priv->vif in iwl{3945,4964}_mac_config_interface() outside of
where priv->mutex is held, but still tries to do mutex_unlock() on
return.  This is clearly wrong and triggers a nasty lockdep warning when
this codepath is triggered.  Fix this by removing the mutex_unlock().

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Assuming the original b716bb91 commit is correct, this is probably the
right fix.  But I'm not sure if it's correct to look at priv->vif
without holding priv->mutex, so maybe the fix is more complicated.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a5678f..a1a0b3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6907,7 +6907,6 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 
 	if (priv->vif != vif) {
 		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
-		mutex_unlock(&priv->mutex);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d7e2358..d0bbcaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6473,7 +6473,6 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 
 	if (priv->vif != vif) {
 		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
-		mutex_unlock(&priv->mutex);
 		return 0;
 	}
 
