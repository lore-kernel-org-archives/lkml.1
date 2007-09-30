Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXI3W6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXI3W6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXI3W5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:57:44 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50378 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbXI3W5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:57:43 -0400
Date: Sun, 30 Sep 2007 16:57:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 6/6] Sysace: Add of_platform_bus binding
In-reply-to: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Message-id: <20070930225738.2476.84540.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

The of_platform bus binding is needed to make the device driver usable
under arch/powerpc.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 296d567..56c4af3 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -91,6 +91,10 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/platform_device.h>
+#if defined(CONFIG_OF)
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#endif
 
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
 MODULE_DESCRIPTION("Xilinx SystemACE device driver");
@@ -1158,6 +1162,85 @@ static struct platform_driver ace_platform_driver = {
 };
 
 /* ---------------------------------------------------------------------
+ * OF_Platform Bus Support
+ */
+
+#if defined(CONFIG_OF)
+static int __devinit
+ace_of_probe(struct of_device *op, const struct of_device_id *match)
+{
+	struct resource res;
+	unsigned long physaddr;
+	const u32 *id;
+	int irq, bus_width, rc;
+
+	dev_dbg(&op->dev, "ace_of_probe(%p, %p)\n", op, match);
+
+	/* device id */
+	id = of_get_property(op->node, "port-number", NULL);
+
+	/* physaddr */
+	rc = of_address_to_resource(op->node, 0, &res);
+	if (rc) {
+		dev_err(&op->dev, "invalid address\n");
+		return rc;
+	}
+	physaddr = res.start;
+
+	/* irq */
+	irq = irq_of_parse_and_map(op->node, 0);
+
+	/* bus width */
+	bus_width = ACE_BUS_WIDTH_16;
+	if (of_find_property(op->node, "8-bit", NULL))
+		bus_width = ACE_BUS_WIDTH_8;
+
+	/* Call the bus-independant setup code */
+	return ace_alloc(&op->dev, id ? *id : 0, physaddr, irq, bus_width);
+}
+
+static int __devexit ace_of_remove(struct of_device *op)
+{
+	ace_free(&op->dev);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id __devinit ace_of_match[] = {
+	{ .compatible = "xilinx,xsysace", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ace_of_match);
+
+static struct of_platform_driver ace_of_driver = {
+	.owner = THIS_MODULE,
+	.name = "xsysace",
+	.match_table = ace_of_match,
+	.probe = ace_of_probe,
+	.remove = __devexit_p(ace_of_remove),
+	.driver = {
+		.name = "xsysace",
+	},
+};
+
+/* Registration helpers to keep the number of #ifdefs to a minimum */
+static inline int __init ace_of_register(void)
+{
+	pr_debug("xsysace: registering OF binding\n");
+	return of_register_platform_driver(&ace_of_driver);
+}
+
+static inline void __exit ace_of_unregister(void)
+{
+	of_unregister_platform_driver(&ace_of_driver);
+}
+#else /* CONFIG_OF */
+/* CONFIG_OF not enabled; do nothing helpers */
+static inline int __init ace_of_register(void) { return 0; }
+static inline void __exit ace_of_unregister(void) { }
+#endif /* CONFIG_OF */
+
+/* ---------------------------------------------------------------------
  * Module init/exit routines
  */
 static int __init ace_init(void)
@@ -1170,6 +1253,9 @@ static int __init ace_init(void)
 		goto err_blk;
 	}
 
+	if ((rc = ace_of_register()) != 0)
+		goto err_of;
+
 	pr_debug("xsysace: registering platform binding\n");
 	if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
 		goto err_plat;
@@ -1178,6 +1264,8 @@ static int __init ace_init(void)
 	return 0;
 
       err_plat:
+	ace_of_unregister();
+      err_of:
 	unregister_blkdev(ace_major, "xsysace");
       err_blk:
 	printk(KERN_ERR "xsysace: registration failed; err=%i\n", rc);
@@ -1188,6 +1276,7 @@ static void __exit ace_exit(void)
 {
 	pr_debug("Unregistering Xilinx SystemACE driver\n");
 	platform_driver_unregister(&ace_platform_driver);
+	ace_of_unregister();
 	unregister_blkdev(ace_major, "xsysace");
 }
 

