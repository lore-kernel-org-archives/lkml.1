Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYH0WG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYH0WG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYH0WGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:06:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51893 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYH0WGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:06:20 -0400
Date: Thu, 28 Aug 2008 01:05:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [2.6 patch] fix pciehp_free_irq()
Message-ID: <20080827220526.GR11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an obvious bug (loop was never entered) caused by
commit 820943b6fc4781621dee52ba026106758a727dd3
(pciehp: cleanup pcie_poll_cmd).

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0cca78f4b7c7d6c7b64ae5acc08bb641454b4835 
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ab31f5b..9d934dd 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -250,23 +250,23 @@ static inline void pciehp_free_irq(struct controller *ctrl)
 static int pcie_poll_cmd(struct controller *ctrl)
 {
 	u16 slot_status;
 	int timeout = 1000;
 
 	if (!pciehp_readw(ctrl, SLOTSTATUS, &slot_status)) {
 		if (slot_status & CMD_COMPLETED) {
 			pciehp_writew(ctrl, SLOTSTATUS, CMD_COMPLETED);
 			return 1;
 		}
 	}
-	while (timeout > 1000) {
+	while (timeout > 0) {
 		msleep(10);
 		timeout -= 10;
 		if (!pciehp_readw(ctrl, SLOTSTATUS, &slot_status)) {
 			if (slot_status & CMD_COMPLETED) {
 				pciehp_writew(ctrl, SLOTSTATUS, CMD_COMPLETED);
 				return 1;
 			}
 		}
 	}
 	return 0;	/* timeout */
 }
