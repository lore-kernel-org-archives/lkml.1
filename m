Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0CBSbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:31:12 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38739 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754277Ab0CBS3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:42 -0500
Date: Tue, 2 Mar 2010 21:29:39 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] ahci: Introduce ahci_set_em_messages()
Message-ID: <20100302182939.GI3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some ahci_em_messages handling code from ahci_init_one().
We would like to reuse it for non-PCI devices.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 18443e9..6694b17 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -3040,6 +3040,29 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
+static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
+				 struct ata_port_info *pi)
+{
+	u8 messages;
+	void __iomem *mmio = hpriv->mmio;
+	u32 em_loc = readl(mmio + HOST_EM_LOC);
+	u32 em_ctl = readl(mmio + HOST_EM_CTL);
+
+	if (!ahci_em_messages || !(hpriv->cap & HOST_CAP_EMS))
+		return;
+
+	messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
+
+	/* we only support LED message type right now */
+	if ((messages & 0x01) && (ahci_em_messages == 1)) {
+		/* store em_loc */
+		hpriv->em_loc = ((em_loc >> 16) * 4);
+		pi->flags |= ATA_FLAG_EM;
+		if (!(em_ctl & EM_CTL_ALHD))
+			pi->flags |= ATA_FLAG_SW_ACTIVITY;
+	}
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -3143,23 +3166,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
-	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
-		u8 messages;
-		void __iomem *mmio = hpriv->mmio;
-		u32 em_loc = readl(mmio + HOST_EM_LOC);
-		u32 em_ctl = readl(mmio + HOST_EM_CTL);
-
-		messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
-
-		/* we only support LED message type right now */
-		if ((messages & 0x01) && (ahci_em_messages == 1)) {
-			/* store em_loc */
-			hpriv->em_loc = ((em_loc >> 16) * 4);
-			pi.flags |= ATA_FLAG_EM;
-			if (!(em_ctl & EM_CTL_ALHD))
-				pi.flags |= ATA_FLAG_SW_ACTIVITY;
-		}
-	}
+	ahci_set_em_messages(hpriv, &pi);
 
 	if (ahci_broken_system_poweroff(pdev)) {
 		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
-- 
1.7.0

