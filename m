Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0CLABY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:01:24 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:37433 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0CLABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:01:20 -0500
Subject: [PATCH v1 3/3] PCI: for address space collisions,
	show conflicting resource
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 11 Mar 2010 17:01:19 -0700
Message-ID: <20100312000119.4355.21178.stgit@bob.kio>
In-Reply-To: <20100311235954.4355.23100.stgit@bob.kio>
References: <20100311235954.4355.23100.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With request_resource_conflict(), we can learn what the actual conflict is,
so print that info for debugging purposes.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/setup-res.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 7d678bb..17bed18 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -93,8 +93,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
 	struct resource *res = &dev->resource[resource];
-	struct resource *root;
-	int err;
+	struct resource *root, *conflict;
 
 	root = pci_find_parent_resource(dev, res);
 	if (!root) {
@@ -103,12 +102,15 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 		return -EINVAL;
 	}
 
-	err = request_resource(root, res);
-	if (err)
+	conflict = request_resource_conflict(root, res);
+	if (conflict) {
 		dev_err(&dev->dev,
-			"address space collision: %pR already in use\n", res);
+			"address space collision: %pR conflicts with %s %pR\n",
+			res, conflict->name, conflict);
+		return -EBUSY;
+	}
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(pci_claim_resource);
 

