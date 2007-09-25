Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbXIYMMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbXIYMMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXIYMMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:12:31 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:21343 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbXIYMMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:12:30 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] ibmebus: Add device creation and bus probing based on of_device
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
Content-Disposition: inline
X-Length: 8152
Date: Tue, 25 Sep 2007 14:12:27 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709251412.27896.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The devtree root is now searched for devices matching a built-in whitelist
during boot, so these devices appear on the bus from the beginning. It is
still possible to manually add/remove devices to/from the bus by using the
probe/remove sysfs interface. Also, when a device driver registers itself,
the devtree is matched against its matchlist.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 arch/powerpc/kernel/ibmebus.c |   97 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index cc80f84..c506e0d 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -51,6 +51,15 @@ static struct device ibmebus_bus_device = { /* fake "parent" device */
 
 struct bus_type ibmebus_bus_type;
 
+/* These devices will automatically be added to the bus during init */
+static struct of_device_id builtin_matches[] = {
+	{ .name = "lhca" },
+	{ .compatible = "IBM,lhca" },
+	{ .name = "lhea" },
+	{ .compatible = "IBM,lhea" },
+	{},
+};
+
 static void *ibmebus_alloc_coherent(struct device *dev,
 				    size_t size,
 				    dma_addr_t *dma_handle,
@@ -124,6 +133,67 @@ static struct dma_mapping_ops ibmebus_dma_ops = {
 	.dma_supported  = ibmebus_dma_supported,
 };
 
+static int ibmebus_match_path(struct device *dev, void *data)
+{
+	struct device_node *dn = to_of_device(dev)->node;
+	return (dn->full_name &&
+		(strcasecmp((char *)data, dn->full_name) == 0));
+}
+
+static int ibmebus_match_node(struct device *dev, void *data)
+{
+	return to_of_device(dev)->node == data;
+}
+
+static int ibmebus_create_device(struct device_node *dn)
+{
+	struct of_device *dev;
+	int ret;
+
+	dev = of_device_alloc(dn, NULL, &ibmebus_bus_device);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->dev.bus = &ibmebus_bus_type;
+	dev->dev.archdata.dma_ops = &ibmebus_dma_ops;
+
+	ret = of_device_register(dev);
+	if (ret) {
+		of_device_free(dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ibmebus_create_devices(const struct of_device_id *matches)
+{
+	struct device_node *root, *child;
+	int ret = 0;
+
+	root = of_find_node_by_path("/");
+
+	for (child = NULL; (child = of_get_next_child(root, child)); ) {
+		if (!of_match_node(matches, child))
+			continue;
+
+		if (bus_find_device(&ibmebus_bus_type, NULL, child,
+				    ibmebus_match_node))
+			continue;
+
+		ret = ibmebus_create_device(child);
+		if (ret) {
+			printk(KERN_ERR "%s: failed to create device (%i)",
+			       __FUNCTION__, ret);
+			of_node_put(child);
+			break;
+		}
+	}
+
+	of_node_put(root);
+	return ret;
+}
+
 int ibmebus_register_driver(struct ibmebus_driver *drv)
 {
 	return 0;
@@ -172,18 +242,6 @@ static struct device_attribute ibmebus_dev_attrs[] = {
 	__ATTR_NULL
 };
 
-static int ibmebus_match_path(struct device *dev, void *data)
-{
-	int rc;
-	struct device_node *dn =
-		of_node_get(to_ibmebus_dev(dev)->ofdev.node);
-
-	rc = (dn->full_name && (strcasecmp((char*)data, dn->full_name) == 0));
-
-	of_node_put(dn);
-	return rc;
-}
-
 static char *ibmebus_chomp(const char *in, size_t count)
 {
 	char *out = (char*)kmalloc(count + 1, GFP_KERNEL);
@@ -202,7 +260,6 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 				   const char *buf, size_t count)
 {
 	struct device_node *dn = NULL;
-	struct ibmebus_dev *dev;
 	char *path;
 	ssize_t rc;
 
@@ -219,9 +276,9 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 	}
 
 	if ((dn = of_find_node_by_path(path))) {
-/*		dev = ibmebus_register_device_node(dn); */
+		rc = ibmebus_create_device(dn);
 		of_node_put(dn);
-		rc = IS_ERR(dev) ? PTR_ERR(dev) : count;
+		rc = rc ? rc : count;
 	} else {
 		printk(KERN_WARNING "%s: no such device node: %s\n",
 		       __FUNCTION__, path);
@@ -245,7 +302,7 @@ static ssize_t ibmebus_store_remove(struct bus_type *bus,
 
 	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, path,
 				   ibmebus_match_path))) {
-/*		ibmebus_unregister_device(dev); */
+		of_device_unregister(to_of_device(dev));
 
 		kfree(path);
 		return count;
@@ -265,6 +322,7 @@ static struct bus_attribute ibmebus_bus_attrs[] = {
 };
 
 struct bus_type ibmebus_bus_type = {
+	.uevent    = of_device_uevent,
 	.dev_attrs = ibmebus_dev_attrs,
 	.bus_attrs = ibmebus_bus_attrs
 };
@@ -292,6 +350,13 @@ static int __init ibmebus_bus_init(void)
 		return err;
 	}
 
+	err = ibmebus_create_devices(builtin_matches);
+	if (err) {
+		device_unregister(&ibmebus_bus_device);
+		bus_unregister(&ibmebus_bus_type);
+		return err;
+	}
+
 	return 0;
 }
 postcore_initcall(ibmebus_bus_init);
-- 
1.5.2


