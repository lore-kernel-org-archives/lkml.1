Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbZFPGFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbZFPGFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935968AbZFPFvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:45 -0400
Received: from kroah.org ([198.145.64.141]:48470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935916AbZFPFvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-parisc@vger.kernel.org,
       Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH 56/64] parisc: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:45 -0700
Message-Id: <1245131213-24168-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-parisc@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parisc/eisa.c      |    2 +-
 drivers/parisc/sba_iommu.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/parisc/eisa.c b/drivers/parisc/eisa.c
index f415fdd..5b89f40 100644
--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -373,7 +373,7 @@ static int __init eisa_probe(struct parisc_device *dev)
 	if (result >= 0) {
 		/* FIXME : Don't enumerate the bus twice. */
 		eisa_dev.root.dev = &dev->dev;
-		dev->dev.driver_data = &eisa_dev.root;
+		dev_set_drvdata(&dev->dev, &eisa_dev.root);
 		eisa_dev.root.bus_base_addr = 0;
 		eisa_dev.root.res = &eisa_dev.hba.io_space;
 		eisa_dev.root.slots = result;
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e5999c4..d46dd57 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -2010,7 +2010,7 @@ void __init sba_init(void)
 void * sba_get_iommu(struct parisc_device *pci_hba)
 {
 	struct parisc_device *sba_dev = parisc_parent(pci_hba);
-	struct sba_device *sba = sba_dev->dev.driver_data;
+	struct sba_device *sba = dev_get_drvdata(&sba_dev->dev);
 	char t = sba_dev->id.hw_type;
 	int iocnum = (pci_hba->hw_path >> 3);	/* rope # */
 
@@ -2031,7 +2031,7 @@ void * sba_get_iommu(struct parisc_device *pci_hba)
 void sba_directed_lmmio(struct parisc_device *pci_hba, struct resource *r)
 {
 	struct parisc_device *sba_dev = parisc_parent(pci_hba);
-	struct sba_device *sba = sba_dev->dev.driver_data;
+	struct sba_device *sba = dev_get_drvdata(&sba_dev->dev);
 	char t = sba_dev->id.hw_type;
 	int i;
 	int rope = (pci_hba->hw_path & (ROPES_PER_IOC-1));  /* rope # */
@@ -2073,7 +2073,7 @@ void sba_directed_lmmio(struct parisc_device *pci_hba, struct resource *r)
 void sba_distributed_lmmio(struct parisc_device *pci_hba, struct resource *r )
 {
 	struct parisc_device *sba_dev = parisc_parent(pci_hba);
-	struct sba_device *sba = sba_dev->dev.driver_data;
+	struct sba_device *sba = dev_get_drvdata(&sba_dev->dev);
 	char t = sba_dev->id.hw_type;
 	int base, size;
 	int rope = (pci_hba->hw_path & (ROPES_PER_IOC-1));  /* rope # */
-- 
1.6.3.2

