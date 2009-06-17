Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbZFQUmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbZFQUmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbZFQUl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:41:57 -0400
Received: from ottawa-hs-64-26-170-27.d-ip.magma.ca ([64.26.170.27]:59297 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755482AbZFQUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:41:57 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 16:41:56 EDT
From: Matthew Wilcox <willy@linux.intel.com>
To: torvalds@linux-foundation.org, jbarnes@virtuousgeek.org
Cc: andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/4] Fix pci_claim_resource
Date: Wed, 17 Jun 2009 16:33:33 -0400
Message-Id: <1245270816-11755-2-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of starting from the iomem or ioport roots, start from the
parent bus' resources.  This fixes a bug where child resources would
appear above their parents resources if they had the same size.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Andrew Patterson <andrew.patterson@hp.com>
---
 drivers/pci/setup-res.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 3039fcb..1240351 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -99,11 +99,11 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
 	struct resource *res = &dev->resource[resource];
-	struct resource *root = NULL;
+	struct resource *root;
 	char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
 	int err;
 
-	root = pcibios_select_root(dev, res);
+	root = pci_find_parent_resource(dev, res);
 
 	err = -EINVAL;
 	if (root != NULL)
-- 
1.6.3.1

