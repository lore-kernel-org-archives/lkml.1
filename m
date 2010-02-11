Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab0BKQ3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:29:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46203 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab0BKQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:29:35 -0500
From: Matthew Garrett <mjg@redhat.com>
To: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v2 2/2] e1000e: Don't disable jumbo frames on 82537L due to eeprom contents
Date: Thu, 11 Feb 2010 11:29:27 -0500
Message-Id: <1265905767-3884-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265905767-3884-1-git-send-email-mjg@redhat.com>
References: <1265905767-3884-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the 82537L errata, jumbo frames will work correctly if ASPM
is disabled. Since we disable ASPM on these devices, enable jumbo frames.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---

Fixed so that the flags get applied.

 drivers/net/e1000e/82571.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index 02d67d0..f26edf7 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -330,7 +330,6 @@ static s32 e1000_get_variants_82571(struct e1000_adapter *adapter)
 	struct e1000_hw *hw = &adapter->hw;
 	static int global_quad_port_a; /* global port a indication */
 	struct pci_dev *pdev = adapter->pdev;
-	u16 eeprom_data = 0;
 	int is_port_b = er32(STATUS) & E1000_STATUS_FUNC_1;
 	s32 rc;
 
@@ -381,16 +380,10 @@ static s32 e1000_get_variants_82571(struct e1000_adapter *adapter)
 		if (pdev->device == E1000_DEV_ID_82571EB_SERDES_QUAD)
 			adapter->flags &= ~FLAG_HAS_WOL;
 		break;
-
 	case e1000_82573:
 		if (pdev->device == E1000_DEV_ID_82573L) {
-			if (e1000_read_nvm(&adapter->hw, NVM_INIT_3GIO_3, 1,
-				       &eeprom_data) < 0)
-				break;
-			if (!(eeprom_data & NVM_WORD1A_ASPM_MASK)) {
-				adapter->flags |= FLAG_HAS_JUMBO_FRAMES;
-				adapter->max_hw_frame_size = DEFAULT_JUMBO;
-			}
+			adapter->flags |= FLAG_HAS_JUMBO_FRAMES;
+			adapter->max_hw_frame_size = DEFAULT_JUMBO;
 		}
 		break;
 	default:
-- 
1.6.6.1

