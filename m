Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYKLAiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYKLAiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYKLA0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:43 -0500
Received: from kroah.org ([198.145.64.141]:42485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753317AbYKLA0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:42 -0500
Date: Tue, 11 Nov 2008 16:23:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tomas Winkler <tomas.winkler@intel.com>,
       Zhu Yi <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 31/49] iwlwifi: dont fail if scan is issued too early
Message-ID: <20081112002358.GF10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-don-t-fail-if-scan-is-issued-too-early.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 8d09a5e1c36d0dec5728e6c8b0bb5412de09b27b upstream

This patch returns success and empty scan on scans requests that were
rejected because issued too early. The cached bss list from previous
scanning will be returned by mac80211.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   12 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    8 +-------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3213,20 +3213,26 @@ static int iwl4965_mac_hw_scan(struct ie
 		goto out_unlock;
 	}
 
-	/* we don't schedule scan within next_scan_jiffies period */
+	/* We don't schedule scan within next_scan_jiffies period.
+	 * Avoid scanning during possible EAPOL exchange, return
+	 * success immediately.
+	 */
 	if (priv->next_scan_jiffies &&
 	    time_after(priv->next_scan_jiffies, jiffies)) {
 		IWL_DEBUG_SCAN("scan rejected: within next scan period\n");
-		rc = -EAGAIN;
+		queue_work(priv->workqueue, &priv->scan_completed);
+		rc = 0;
 		goto out_unlock;
 	}
 	/* if we just finished scan ask for delay */
 	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
 	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
 		IWL_DEBUG_SCAN("scan rejected: within previous scan period\n");
-		rc = -EAGAIN;
+		queue_work(priv->workqueue, &priv->scan_completed);
+		rc = 0;
 		goto out_unlock;
 	}
+
 	if (len) {
 		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
 			       iwl_escape_essid(ssid, len), (int)len);
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -464,11 +464,6 @@ void iwl_init_scan_params(struct iwl_pri
 
 int iwl_scan_initiate(struct iwl_priv *priv)
 {
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("APs don't scan.\n");
-		return 0;
-	}
-
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
 		return -EIO;
@@ -480,8 +475,7 @@ int iwl_scan_initiate(struct iwl_priv *p
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan request while abort pending.  "
-			       "Queuing.\n");
+		IWL_DEBUG_SCAN("Scan request while abort pending\n");
 		return -EAGAIN;
 	}
 

-- 
