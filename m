Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbZJBBek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbZJBBek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZJBBei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:38 -0400
Received: from kroah.org ([198.145.64.141]:33647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbZJBBec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:28 2009
Message-Id: <20091002012428.446815976@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:18:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [136/136] iwlwifi: fix unloading driver while scanning
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-fix-unloading-driver-while-scanning.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This is commit 5bddf54962bf68002816df710348ba197d6391bb in linux-2.6.

If NetworkManager is busy scanning when user
tries to unload the module, the driver can not be unloaded
because HW still scanning.

Make sure driver sends abort scan host command to uCode if it
is in the middle of scanning during driver unload.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2215,7 +2215,7 @@ static void iwl_mac_stop(struct ieee8021
 
 	priv->is_open = 0;
 
-	if (iwl_is_ready_rf(priv)) {
+	if (iwl_is_ready_rf(priv) || test_bit(STATUS_SCAN_HW, &priv->status)) {
 		/* stop mac, cancel any scan request and clear
 		 * RXON_FILTER_ASSOC_MSK BIT
 		 */
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -799,7 +799,8 @@ void iwl_bg_abort_scan(struct work_struc
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
-	if (!iwl_is_ready(priv))
+	if (!test_bit(STATUS_READY, &priv->status) ||
+	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
 		return;
 
 	mutex_lock(&priv->mutex);


