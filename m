Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864Ab0CKSHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:07:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756Ab0CKSHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:07:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 37/37] arch/sparc: Remove .archdata.of_node and use .of_node
	in struct device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:07:12 -0700
Message-ID: <20100311180711.4824.57524.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.archdata.of_node is being removed from Microblaze, SPARC and PowerPC
because it duplicates the struct device .of_node pointer.  This patch
also removes .node from struct of_device for the same reason.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/sparc/include/asm/device.h    |    9 ---------
 arch/sparc/include/asm/of_device.h |    1 -
 arch/sparc/kernel/of_device_32.c   |    3 ---
 arch/sparc/kernel/of_device_64.c   |    2 --
 arch/sparc/kernel/pci.c            |    1 -
 5 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/include/asm/device.h b/arch/sparc/include/asm/device.h
index 55dadca..d4c4521 100644
--- a/arch/sparc/include/asm/device.h
+++ b/arch/sparc/include/asm/device.h
@@ -13,19 +13,10 @@ struct dev_archdata {
 	void			*iommu;
 	void			*stc;
 	void			*host_controller;
-
-	struct device_node	*prom_node;
 	struct of_device	*op;
-
 	int			numa_node;
 };
 
-static inline void dev_archdata_set_node(struct dev_archdata *ad,
-					 struct device_node *np)
-{
-	ad->prom_node = np;
-}
-
 struct pdev_archdata {
 };
 
diff --git a/arch/sparc/include/asm/of_device.h b/arch/sparc/include/asm/of_device.h
index a5d9811..f320246 100644
--- a/arch/sparc/include/asm/of_device.h
+++ b/arch/sparc/include/asm/of_device.h
@@ -14,7 +14,6 @@
  */
 struct of_device
 {
-	struct device_node		*node;
 	struct device			dev;
 	struct resource			resource[PROMREG_MAX];
 	unsigned int			irqs[PROMINTR_MAX];
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index 909bee0..37ab163 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -345,12 +345,9 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 		return NULL;
 
 	sd = &op->dev.archdata;
-	sd->prom_node = dp; /* temporary */
 	sd->op = op;
 	op->dev.of_node = dp;
 
-	op->node = dp;
-
 	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
 					       (25*1000*1000));
 	op->portid = of_getintprop_default(dp, "upa-portid", -1);
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index e436381..1dae807 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -640,11 +640,9 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 		return NULL;
 
 	sd = &op->dev.archdata;
-	sd->prom_node = dp; /* temporary */
 	sd->op = op;
 
 	op->dev.of_node = dp;
-	op->node = dp;
 
 	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
 					       (25*1000*1000));
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 89c17d0..8a8363a 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -261,7 +261,6 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	sd->iommu = pbm->iommu;
 	sd->stc = &pbm->stc;
 	sd->host_controller = pbm;
-	sd->prom_node = node; /* temporary */
 	sd->op = op = of_find_device_by_node(node);
 	sd->numa_node = pbm->numa_node;
 

