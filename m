Return-Path: <linux-kernel-owner+w=401wt.eu-S965958AbXCFQ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958AbXCFQ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965956AbXCFQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:57:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:31784 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965949AbXCFQ5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:57:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,254,1170662400"; 
   d="scan'208"; a="207490630:sNHT6222607510"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH 2/3] e1000: FIX: firmware handover bits
Date: Tue, 06 Mar 2007 08:57:24 -0800
To: jgarzik@pobox.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, john.ronciak@intel.com,
       jesse.brandeburg@intel.com
Message-Id: <20070306165723.27434.79292.stgit@localhost.localdomain>
In-Reply-To: <20070306165721.27434.23796.stgit@localhost.localdomain>
References: <20070306165721.27434.23796.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
X-OriginalArrivalTime: 06 Mar 2007 16:57:24.0117 (UTC) FILETIME=[83410C50:01C76010]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Upon code inspection it was spotted that the firmware handover bit get/set
mismatched, which may have resulted in management issues on PCI-E
adapters. Setting them correctly may fix some management issues such
as arp routing etc.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/net/e1000/e1000_main.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index fff3bc0..3492f0b 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -409,25 +409,21 @@ e1000_release_hw_control(struct e1000_adapter *adapter)
 {
 	uint32_t ctrl_ext;
 	uint32_t swsm;
-	uint32_t extcnf;
 
 	/* Let firmware taken over control of h/w */
 	switch (adapter->hw.mac_type) {
-	case e1000_82571:
-	case e1000_82572:
-	case e1000_80003es2lan:
-		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
-		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
-				ctrl_ext & ~E1000_CTRL_EXT_DRV_LOAD);
-		break;
 	case e1000_82573:
 		swsm = E1000_READ_REG(&adapter->hw, SWSM);
 		E1000_WRITE_REG(&adapter->hw, SWSM,
 				swsm & ~E1000_SWSM_DRV_LOAD);
+		break;
+	case e1000_82571:
+	case e1000_82572:
+	case e1000_80003es2lan:
 	case e1000_ich8lan:
-		extcnf = E1000_READ_REG(&adapter->hw, CTRL_EXT);
+		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
 		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
-				extcnf & ~E1000_CTRL_EXT_DRV_LOAD);
+				ctrl_ext & ~E1000_CTRL_EXT_DRV_LOAD);
 		break;
 	default:
 		break;
@@ -450,26 +446,21 @@ e1000_get_hw_control(struct e1000_adapter *adapter)
 {
 	uint32_t ctrl_ext;
 	uint32_t swsm;
-	uint32_t extcnf;
 
 	/* Let firmware know the driver has taken over */
 	switch (adapter->hw.mac_type) {
-	case e1000_82571:
-	case e1000_82572:
-	case e1000_80003es2lan:
-		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
-		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
-				ctrl_ext | E1000_CTRL_EXT_DRV_LOAD);
-		break;
 	case e1000_82573:
 		swsm = E1000_READ_REG(&adapter->hw, SWSM);
 		E1000_WRITE_REG(&adapter->hw, SWSM,
 				swsm | E1000_SWSM_DRV_LOAD);
 		break;
+	case e1000_82571:
+	case e1000_82572:
+	case e1000_80003es2lan:
 	case e1000_ich8lan:
-		extcnf = E1000_READ_REG(&adapter->hw, EXTCNF_CTRL);
-		E1000_WRITE_REG(&adapter->hw, EXTCNF_CTRL,
-				extcnf | E1000_EXTCNF_CTRL_SWFLAG);
+		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
+		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
+				ctrl_ext | E1000_CTRL_EXT_DRV_LOAD);
 		break;
 	default:
 		break;
