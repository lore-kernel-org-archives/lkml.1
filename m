Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0CCRRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:17:43 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37333 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754561Ab0CCRRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:17:40 -0500
Date: Wed, 3 Mar 2010 20:17:39 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] ahci: Factor out PCI specifics from
 ahci_reset_controller()
Message-ID: <20100303171739.GD12362@oksana.dev.rtsoft.ru>
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PCI stuff into ahci_pci_reset_controller().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9d9af3c..830a6fe 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1343,7 +1343,6 @@ static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 
 static int ahci_reset_controller(struct ata_host *host)
 {
-	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
 	u32 tmp;
@@ -1387,7 +1386,17 @@ static int ahci_reset_controller(struct ata_host *host)
 		dev_printk(KERN_INFO, host->dev,
 			   "skipping global host reset\n");
 
+	return 0;
+}
+
+static int ahci_pci_reset_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+
+	ahci_reset_controller(host);
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
+		struct ahci_host_priv *hpriv = host->private_data;
 		u16 tmp16;
 
 		/* configure PCS */
@@ -2670,7 +2679,7 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = ahci_reset_controller(host);
+		rc = ahci_pci_reset_controller(host);
 		if (rc)
 			return rc;
 
@@ -3398,7 +3407,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 
-- 
1.7.0

