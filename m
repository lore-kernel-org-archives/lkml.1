Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZIXMe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZIXMe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZIXMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:27 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:8484 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752867AbZIXMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6W8-03-AI3-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/10] amd64_edac: fix K8 intlv_sel check
Date: Thu, 24 Sep 2009 14:32:44 +0200
Message-ID: <1253795568-9877-7-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:40.0287 (UTC) FILETIME=[3EECF4F0:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check when DRAM interleaving is enabled should be done against the
pvt->dram_IntlvSel field and not against the ->dram_limit.

Simplify first loop and fixup printk formatting while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3dfb8e6..3f98ae0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -279,14 +279,11 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	intlv_en = pvt->dram_IntlvEn[0];
 
 	if (intlv_en == 0) {
-		for (node_id = 0; ; ) {
+		for (node_id = 0; node_id < DRAM_REG_COUNT; node_id++) {
 			if (amd64_base_limit_match(pvt, sys_addr, node_id))
-				break;
-
-			if (++node_id >= DRAM_REG_COUNT)
-				goto err_no_match;
+				goto found;
 		}
-		goto found;
+		goto err_no_match;
 	}
 
 	if (unlikely((intlv_en != 0x01) &&
@@ -301,7 +298,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	bits = (((u32) sys_addr) >> 12) & intlv_en;
 
 	for (node_id = 0; ; ) {
-		if ((pvt->dram_limit[node_id] & intlv_en) == bits)
+		if ((pvt->dram_IntlvSel[node_id] & intlv_en) == bits)
 			break;	/* intlv_sel field matches */
 
 		if (++node_id >= DRAM_REG_COUNT)
@@ -311,10 +308,10 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	/* sanity test for sys_addr */
 	if (unlikely(!amd64_base_limit_match(pvt, sys_addr, node_id))) {
 		amd64_printk(KERN_WARNING,
-			  "%s(): sys_addr 0x%lx falls outside base/limit "
-			  "address range for node %d with node interleaving "
-			  "enabled.\n", __func__, (unsigned long)sys_addr,
-			  node_id);
+			     "%s(): sys_addr 0x%llx falls outside base/limit "
+			     "address range for node %d with node interleaving "
+			     "enabled.\n",
+			     __func__, sys_addr, node_id);
 		return NULL;
 	}
 
-- 
1.6.3.3


