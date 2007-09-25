Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXIYMLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXIYMLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXIYMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:11:31 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:6159 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXIYMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:11:30 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] PowerPC: Move of_device allocation into of_device.[ch]
Date: Tue, 25 Sep 2007 14:11:27 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mackerras <pmac@au1.ibm.com>
References: <200709251410.29780.fenkes@de.ibm.com>
In-Reply-To: <200709251410.29780.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251411.27755.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extract generic of_device allocation code from of_platform_device_create()
and move it into of_device.[ch], called of_device_alloc(). Also, there's now
of_device_free() which puts the device node.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 include/asm-powerpc/of_device.h   |    4 ++
 include/linux/of_device.h         |    5 ++
 arch/powerpc/kernel/of_device.c   |   80 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/of_platform.c |   70 +-------------------------------
 4 files changed, 91 insertions(+), 68 deletions(-)

diff --git a/include/asm-powerpc/of_device.h b/include/asm-powerpc/of_device.h
index ec2a8a2..9ab469d 100644
--- a/include/asm-powerpc/of_device.h
+++ b/include/asm-powerpc/of_device.h
@@ -17,6 +17,10 @@ struct of_device
 	struct device		dev;		/* Generic device interface */
 };
 
+extern struct of_device *of_device_alloc(struct device_node *np,
+					 const char *bus_id,
+					 struct device *parent);
+
 extern ssize_t of_device_get_modalias(struct of_device *ofdev,
 					char *str, ssize_t len);
 extern int of_device_uevent(struct device *dev,
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 91bf84b..212bffb 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -22,5 +22,10 @@ extern int of_device_register(struct of_device *ofdev);
 extern void of_device_unregister(struct of_device *ofdev);
 extern void of_release_dev(struct device *dev);
 
+static inline void of_device_free(struct of_device *dev)
+{
+	of_release_dev(&dev->dev);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_OF_DEVICE_H */
diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
index 89b911e..ecb8b0e 100644
--- a/arch/powerpc/kernel/of_device.c
+++ b/arch/powerpc/kernel/of_device.c
@@ -7,8 +7,88 @@
 #include <linux/slab.h>
 
 #include <asm/errno.h>
+#include <asm/dcr.h>
 #include <asm/of_device.h>
 
+static void of_device_make_bus_id(struct of_device *dev)
+{
+	static atomic_t bus_no_reg_magic;
+	struct device_node *node = dev->node;
+	char *name = dev->dev.bus_id;
+	const u32 *reg;
+	u64 addr;
+	int magic;
+
+	/*
+	 * If it's a DCR based device, use 'd' for native DCRs
+	 * and 'D' for MMIO DCRs.
+	 */
+#ifdef CONFIG_PPC_DCR
+	reg = of_get_property(node, "dcr-reg", NULL);
+	if (reg) {
+#ifdef CONFIG_PPC_DCR_NATIVE
+		snprintf(name, BUS_ID_SIZE, "d%x.%s",
+			 *reg, node->name);
+#else /* CONFIG_PPC_DCR_NATIVE */
+		addr = of_translate_dcr_address(node, *reg, NULL);
+		if (addr != OF_BAD_ADDR) {
+			snprintf(name, BUS_ID_SIZE,
+				 "D%llx.%s", (unsigned long long)addr,
+				 node->name);
+			return;
+		}
+#endif /* !CONFIG_PPC_DCR_NATIVE */
+	}
+#endif /* CONFIG_PPC_DCR */
+
+	/*
+	 * For MMIO, get the physical address
+	 */
+	reg = of_get_property(node, "reg", NULL);
+	if (reg) {
+		addr = of_translate_address(node, reg);
+		if (addr != OF_BAD_ADDR) {
+			snprintf(name, BUS_ID_SIZE,
+				 "%llx.%s", (unsigned long long)addr,
+				 node->name);
+			return;
+		}
+	}
+
+	/*
+	 * No BusID, use the node name and add a globally incremented
+	 * counter (and pray...)
+	 */
+	magic = atomic_add_return(1, &bus_no_reg_magic);
+	snprintf(name, BUS_ID_SIZE, "%s.%d", node->name, magic - 1);
+}
+
+struct of_device *of_device_alloc(struct device_node *np,
+				  const char *bus_id,
+				  struct device *parent)
+{
+	struct of_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->node = of_node_get(np);
+	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.parent = parent;
+	dev->dev.release = of_release_dev;
+	dev->dev.archdata.of_node = np;
+	dev->dev.archdata.numa_node = of_node_to_nid(np);
+
+	if (bus_id)
+		strlcpy(dev->dev.bus_id, bus_id, BUS_ID_SIZE);
+	else
+		of_device_make_bus_id(dev);
+
+	return dev;
+}
+EXPORT_SYMBOL(of_device_alloc);
+
 ssize_t of_device_get_modalias(struct of_device *ofdev,
 				char *str, ssize_t len)
 {
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index f70e787..1d96b82 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -21,7 +21,6 @@
 #include <linux/pci.h>
 
 #include <asm/errno.h>
-#include <asm/dcr.h>
 #include <asm/of_device.h>
 #include <asm/of_platform.h>
 #include <asm/topology.h>
@@ -53,8 +52,6 @@ static struct of_device_id of_default_bus_ids[] = {
 	{},
 };
 
-static atomic_t bus_no_reg_magic;
-
 struct bus_type of_platform_bus_type = {
        .uevent	= of_device_uevent,
 };
@@ -84,89 +81,26 @@ void of_unregister_platform_driver(struct of_platform_driver *drv)
 }
 EXPORT_SYMBOL(of_unregister_platform_driver);
 
-static void of_platform_make_bus_id(struct of_device *dev)
-{
-	struct device_node *node = dev->node;
-	char *name = dev->dev.bus_id;
-	const u32 *reg;
-	u64 addr;
-	int magic;
-
-	/*
-	 * If it's a DCR based device, use 'd' for native DCRs
-	 * and 'D' for MMIO DCRs.
-	 */
-#ifdef CONFIG_PPC_DCR
-	reg = of_get_property(node, "dcr-reg", NULL);
-	if (reg) {
-#ifdef CONFIG_PPC_DCR_NATIVE
-		snprintf(name, BUS_ID_SIZE, "d%x.%s",
-			 *reg, node->name);
-#else /* CONFIG_PPC_DCR_NATIVE */
-		addr = of_translate_dcr_address(node, *reg, NULL);
-		if (addr != OF_BAD_ADDR) {
-			snprintf(name, BUS_ID_SIZE,
-				 "D%llx.%s", (unsigned long long)addr,
-				 node->name);
-			return;
-		}
-#endif /* !CONFIG_PPC_DCR_NATIVE */
-	}
-#endif /* CONFIG_PPC_DCR */
-
-	/*
-	 * For MMIO, get the physical address
-	 */
-	reg = of_get_property(node, "reg", NULL);
-	if (reg) {
-		addr = of_translate_address(node, reg);
-		if (addr != OF_BAD_ADDR) {
-			snprintf(name, BUS_ID_SIZE,
-				 "%llx.%s", (unsigned long long)addr,
-				 node->name);
-			return;
-		}
-	}
-
-	/*
-	 * No BusID, use the node name and add a globally incremented
-	 * counter (and pray...)
-	 */
-	magic = atomic_add_return(1, &bus_no_reg_magic);
-	snprintf(name, BUS_ID_SIZE, "%s.%d", node->name, magic - 1);
-}
-
 struct of_device* of_platform_device_create(struct device_node *np,
 					    const char *bus_id,
 					    struct device *parent)
 {
 	struct of_device *dev;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = of_device_alloc(np, bus_id, parent);
 	if (!dev)
 		return NULL;
 
-	dev->node = of_node_get(np);
 	dev->dma_mask = 0xffffffffUL;
-	dev->dev.dma_mask = &dev->dma_mask;
-	dev->dev.parent = parent;
 	dev->dev.bus = &of_platform_bus_type;
-	dev->dev.release = of_release_dev;
-	dev->dev.archdata.of_node = np;
-	dev->dev.archdata.numa_node = of_node_to_nid(np);
 
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
 	 */
 
-	if (bus_id)
-		strlcpy(dev->dev.bus_id, bus_id, BUS_ID_SIZE);
-	else
-		of_platform_make_bus_id(dev);
-
 	if (of_device_register(dev) != 0) {
-		kfree(dev);
+		of_device_free(dev);
 		return NULL;
 	}
 
-- 
1.5.2


