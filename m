Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYDNSly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYDNSly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbYDNSlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:41:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51052 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759193AbYDNSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:41:45 -0400
Date: Mon, 14 Apr 2008 21:40:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ambx1@neo.rr.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/pnp/manager.c cleanups
Message-ID: <20080414184038.GB6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups that are now possible:
- remove the following unused functions:
  - pnp_manual_config_dev()
  - pnp_resource_change()
- remove the following unused EXPORT_SYMBOL's:
  - pnp_start_dev
  - pnp_stop_dev
  - pnp_init_resource_table

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 27 Feb 2008
- 13 Feb 2008

 drivers/pnp/manager.c |   72 ------------------------------------------
 include/linux/pnp.h   |    3 -
 2 files changed, 75 deletions(-)

cb84fb3720df015ede1ded3728a721a883ffd6f5 diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
index c28caf2..0ebd36d 100644
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -377,59 +377,6 @@ fail:
 }
 
 /**
- * pnp_manual_config_dev - Disables Auto Config and Manually sets the resource table
- * @dev: pointer to the desired device
- * @res: pointer to the new resource config
- * @mode: 0 or PNP_CONFIG_FORCE
- *
- * This function can be used by drivers that want to manually set thier resources.
- */
-int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
-			  int mode)
-{
-	int i;
-	struct pnp_resource_table *bak;
-
-	if (!pnp_can_configure(dev))
-		return -ENODEV;
-	bak = pnp_alloc(sizeof(struct pnp_resource_table));
-	if (!bak)
-		return -ENOMEM;
-	*bak = dev->res;
-
-	mutex_lock(&pnp_res_mutex);
-	dev->res = *res;
-	if (!(mode & PNP_CONFIG_FORCE)) {
-		for (i = 0; i < PNP_MAX_PORT; i++) {
-			if (!pnp_check_port(dev, i))
-				goto fail;
-		}
-		for (i = 0; i < PNP_MAX_MEM; i++) {
-			if (!pnp_check_mem(dev, i))
-				goto fail;
-		}
-		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			if (!pnp_check_irq(dev, i))
-				goto fail;
-		}
-		for (i = 0; i < PNP_MAX_DMA; i++) {
-			if (!pnp_check_dma(dev, i))
-				goto fail;
-		}
-	}
-	mutex_unlock(&pnp_res_mutex);
-
-	kfree(bak);
-	return 0;
-
-fail:
-	dev->res = *bak;
-	mutex_unlock(&pnp_res_mutex);
-	kfree(bak);
-	return -EINVAL;
-}
-
-/**
  * pnp_auto_config_dev - automatically assigns resources to a device
  * @dev: pointer to the desired device
  */
@@ -555,24 +502,5 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	return 0;
 }
 
-/**
- * pnp_resource_change - change one resource
- * @resource: pointer to resource to be changed
- * @start: start of region
- * @size: size of region
- */
-void pnp_resource_change(struct resource *resource, resource_size_t start,
-			 resource_size_t size)
-{
-	resource->flags &= ~(IORESOURCE_AUTO | IORESOURCE_UNSET);
-	resource->start = start;
-	resource->end = start + size - 1;
-}
-
-EXPORT_SYMBOL(pnp_manual_config_dev);
-EXPORT_SYMBOL(pnp_start_dev);
-EXPORT_SYMBOL(pnp_stop_dev);
 EXPORT_SYMBOL(pnp_activate_dev);
 EXPORT_SYMBOL(pnp_disable_dev);
-EXPORT_SYMBOL(pnp_resource_change);
-EXPORT_SYMBOL(pnp_init_resource_table);
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index cd6332b..3e8760f 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -389,8 +389,6 @@ int pnp_register_port_resource(struct pnp_option *option,
 			       struct pnp_port *data);
 int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data);
 void pnp_init_resource_table(struct pnp_resource_table *table);
-int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
-			  int mode);
 int pnp_auto_config_dev(struct pnp_dev *dev);
 int pnp_validate_config(struct pnp_dev *dev);
 int pnp_start_dev(struct pnp_dev *dev);
@@ -438,7 +436,6 @@ static inline int pnp_register_dma_resource(struct pnp_option *option, struct pn
 static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
 static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
 static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
-static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }

