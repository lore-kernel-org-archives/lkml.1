Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbXJAP7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbXJAP7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXJAP6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:58:30 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39435 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbXJAP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:58:29 -0400
Date: Mon, 01 Oct 2007 09:57:59 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 6/6] Xilinxfb: add of_platform bus binding
In-reply-to: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155759.6114.29143.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Adds the of_platform bus binding to the xilinxfb driver.  Needed to
use framebuffer devices described in the OF device tree (used by
arch/powerpc).

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |  101 ++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index e482bb5..4cf03e1 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -6,9 +6,12 @@
  * Author: MontaVista Software, Inc.
  *         source@mvista.com
  *
- * 2002-2007 (c) MontaVista Software, Inc.  This file is licensed under the
- * terms of the GNU General Public License version 2.  This program is licensed
- * "as is" without any warranty of any kind, whether express or implied.
+ * 2002-2007 (c) MontaVista Software, Inc.
+ * 2007 (c) Secret Lab Technologies, Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
  */
 
 /*
@@ -29,7 +32,10 @@
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
-
+#if defined(CONFIG_OF)
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#endif
 #include <asm/io.h>
 #include <linux/xilinxfb.h>
 
@@ -384,13 +390,91 @@ static struct platform_driver xilinxfb_platform_driver = {
 	},
 };
 
+/* ---------------------------------------------------------------------
+ * OF bus binding
+ */
+
+#if defined(CONFIG_OF)
+static int __devinit
+xilinxfb_of_probe(struct of_device *op, const struct of_device_id *match)
+{
+	struct resource res;
+	const u32 *prop;
+	int width = 0, height = 0, rotate = 0;
+	int size, rc;
+
+	dev_dbg(&op->dev, "xilinxfb_of_probe(%p, %p)\n", op, match);
+
+	rc = of_address_to_resource(op->node, 0, &res);
+	if (rc) {
+		dev_err(&op->dev, "invalid address\n");
+		return rc;
+	}
+
+	prop = of_get_property(op->node, "display-number", &size);
+	if ((prop) && (size >= sizeof(u32)*2)) {
+		width = prop[0];
+		height = prop[1];
+	}
+
+	if (of_find_property(op->node, "rotate-display", NULL))
+		rotate = 1;
+
+	return xilinxfb_assign(&op->dev, res.start, width, height, rotate);
+}
+
+static int __devexit xilinxfb_of_remove(struct of_device *op)
+{
+	return xilinxfb_release(&op->dev);
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id __devinit xilinxfb_of_match[] = {
+	{ .compatible = "xilinx,ml300-fb", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xilinxfb_of_match);
+
+static struct of_platform_driver xilinxfb_of_driver = {
+	.owner = THIS_MODULE,
+	.name = DRIVER_NAME,
+	.match_table = xilinxfb_of_match,
+	.probe = xilinxfb_of_probe,
+	.remove = __devexit_p(xilinxfb_of_remove),
+	.driver = {
+		.name = DRIVER_NAME,
+	},
+};
+
+/* Registration helpers to keep the number of #ifdefs to a minimum */
+static inline int __init xilinxfb_of_register(void)
+{
+	pr_debug("xilinxfb: calling of_register_platform_driver()\n");
+	return of_register_platform_driver(&xilinxfb_of_driver);
+}
+
+static inline void __exit xilinxfb_of_unregister(void)
+{
+	of_unregister_platform_driver(&xilinxfb_of_driver);
+}
+#else /* CONFIG_OF */
+/* CONFIG_OF not enabled; do nothing helpers */
+static inline int __init xilinxfb_of_register(void) { return 0; }
+static inline void __exit xilinxfb_of_unregister(void) { }
+#endif /* CONFIG_OF */
+
+/* ---------------------------------------------------------------------
+ * Module setup and teardown
+ */
+
 static int __init
 xilinxfb_init(void)
 {
-	/*
-	 * No kernel boot options used,
-	 * so we just need to register the driver
-	 */
+	int rc;
+	rc = xilinxfb_of_register();
+	if (rc)
+		return rc;
+
 	return platform_driver_register(&xilinxfb_platform_driver);
 }
 
@@ -398,6 +482,7 @@ static void __exit
 xilinxfb_cleanup(void)
 {
 	platform_driver_unregister(&xilinxfb_platform_driver);
+	xilinxfb_of_unregister();
 }
 
 module_init(xilinxfb_init);

