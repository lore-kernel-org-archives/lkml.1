Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYIYSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYIYSh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYIYShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:37:14 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:40418 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752934AbYIYShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:37:12 -0400
Date: Thu, 25 Sep 2008 22:37:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linuxppc-dev@ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] OF: new helper: of_parse_phandles_with_args()
Message-ID: <20080925183710.GA25627@oksana.dev.rtsoft.ru>
References: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factored out of of_get_gpio(). Will be used by the QE pin multiplexing
functions (they need to parse the gpios = <> too).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/base.c  |  111 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/gpio.c  |   77 +++++++----------------------------
 include/linux/of.h |    3 +
 3 files changed, 130 insertions(+), 61 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ad8ac1a..51e0fce 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -473,3 +473,114 @@ int of_modalias_node(struct device_node *node, char *modalias, int len)
 }
 EXPORT_SYMBOL_GPL(of_modalias_node);
 
+/**
+ * of_parse_phandles_with_args - Find a node pointed by phandle in a list
+ * @np:		pointer to a device tree node containing a list
+ * @list_name:	property name that contains a list
+ * @cells_name:	property name that specifies phandles' arguments count
+ * @index:	index of a phandle to parse out
+ * @out_node:	pointer to device_node struct pointer (will be filled)
+ * @out_args:	pointer to arguments pointer (will be filled)
+ *
+ * This function is useful to parse lists of phandles and their arguments.
+ * Returns 0 on success and fills out_node and out_args, on error returns
+ * appropriate errno value.
+ *
+ * Example:
+ *
+ * phandle1: node1 {
+ * 	#list-cells = <2>;
+ * }
+ *
+ * phandle2: node2 {
+ * 	#list-cells = <1>;
+ * }
+ *
+ * node3 {
+ * 	list = <&phandle1 1 2 &phandle2 3>;
+ * }
+ *
+ * To get a device_node of the `node2' you may call this:
+ * of_parse_phandles_with_args(node3, "list", "#list-cells", 2, &node2, &args);
+ */
+int of_parse_phandles_with_args(struct device_node *np, const char *list_name,
+				const char *cells_name, int index,
+				struct device_node **out_node,
+				const void **out_args)
+{
+	int ret = -EINVAL;
+	const u32 *list;
+	u32 list_cells;
+	int size;
+	int i;
+	int cur_index = 0;
+	struct device_node *node;
+	const void *args;
+
+	list = of_get_property(np, list_name, &size);
+	if (!list) {
+		ret = -ENOENT;
+		goto err0;
+	}
+	list_cells = size / sizeof(u32);
+
+	for (i = 0; i < list_cells; cur_index++) {
+		const u32 *cells;
+		const phandle *phandle;
+
+		phandle = list + i;
+		args = phandle + 1;
+
+		/* one cell hole in the list = <>; */
+		if (!*phandle) {
+			if (cur_index == index)
+				return -ENOENT;
+			i++;
+			continue;
+		}
+
+		node = of_find_node_by_phandle(*phandle);
+		if (!node) {
+			pr_debug("%s: could not find phandle\n",
+				 np->full_name);
+			goto err0;
+		}
+
+		cells = of_get_property(node, cells_name, &size);
+		if (!cells || size != sizeof(*cells)) {
+			pr_debug("%s: could not get %s for %s\n",
+				 np->full_name, cells_name, node->full_name);
+			goto err1;
+		}
+
+		/* Next phandle is at phandle cells + #cells */
+		i += sizeof(*phandle) / sizeof(u32) + *cells;
+		if (i >= list_cells + 1) {
+			pr_debug("%s: insufficient arguments length\n",
+				 np->full_name);
+			goto err1;
+		}
+
+		if (cur_index == index)
+			break;
+
+		node = NULL;
+		of_node_put(node);
+	}
+
+	if (!node) {
+		ret = -ENOENT;
+		goto err0;
+	}
+
+	*out_node = node;
+	*out_args = args;
+
+	return 0;
+err1:
+	of_node_put(node);
+err0:
+	pr_debug("%s exited with status %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(of_parse_phandles_with_args);
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 1c9cab8..6d6e4c0 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -28,78 +28,33 @@
  */
 int of_get_gpio(struct device_node *np, int index)
 {
-	int ret = -EINVAL;
+	int ret;
 	struct device_node *gc;
 	struct of_gpio_chip *of_gc = NULL;
 	int size;
-	const u32 *gpios;
-	u32 nr_cells;
-	int i;
 	const void *gpio_spec;
 	const u32 *gpio_cells;
-	int gpio_index = 0;
 
-	gpios = of_get_property(np, "gpios", &size);
-	if (!gpios) {
-		ret = -ENOENT;
+	ret = of_parse_phandles_with_args(np, "gpios", "#gpio-cells", index,
+					  &gc, &gpio_spec);
+	if (ret) {
+		pr_debug("%s: can't parse gpios property\n", __func__);
 		goto err0;
 	}
-	nr_cells = size / sizeof(u32);
-
-	for (i = 0; i < nr_cells; gpio_index++) {
-		const phandle *gpio_phandle;
-
-		gpio_phandle = gpios + i;
-		gpio_spec = gpio_phandle + 1;
-
-		/* one cell hole in the gpios = <>; */
-		if (!*gpio_phandle) {
-			if (gpio_index == index)
-				return -ENOENT;
-			i++;
-			continue;
-		}
-
-		gc = of_find_node_by_phandle(*gpio_phandle);
-		if (!gc) {
-			pr_debug("%s: could not find phandle for gpios\n",
-				 np->full_name);
-			goto err0;
-		}
-
-		of_gc = gc->data;
-		if (!of_gc) {
-			pr_debug("%s: gpio controller %s isn't registered\n",
-				 np->full_name, gc->full_name);
-			goto err1;
-		}
-
-		gpio_cells = of_get_property(gc, "#gpio-cells", &size);
-		if (!gpio_cells || size != sizeof(*gpio_cells) ||
-				*gpio_cells != of_gc->gpio_cells) {
-			pr_debug("%s: wrong #gpio-cells for %s\n",
-				 np->full_name, gc->full_name);
-			goto err1;
-		}
-
-		/* Next phandle is at phandle cells + #gpio-cells */
-		i += sizeof(*gpio_phandle) / sizeof(u32) + *gpio_cells;
-		if (i >= nr_cells + 1) {
-			pr_debug("%s: insufficient gpio-spec length\n",
-				 np->full_name);
-			goto err1;
-		}
-
-		if (gpio_index == index)
-			break;
-
-		of_gc = NULL;
-		of_node_put(gc);
-	}
 
+	of_gc = gc->data;
 	if (!of_gc) {
-		ret = -ENOENT;
-		goto err0;
+		pr_debug("%s: gpio controller %s isn't registered\n",
+			 np->full_name, gc->full_name);
+		goto err1;
+	}
+
+	gpio_cells = of_get_property(gc, "#gpio-cells", &size);
+	if (!gpio_cells || size != sizeof(*gpio_cells) ||
+			*gpio_cells != of_gc->gpio_cells) {
+		pr_debug("%s: wrong #gpio-cells for %s\n",
+			 np->full_name, gc->full_name);
+		goto err1;
 	}
 
 	ret = of_gc->xlate(of_gc, np, gpio_spec);
diff --git a/include/linux/of.h b/include/linux/of.h
index 79886ad..e2488f5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -71,5 +71,8 @@ extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
 	const struct of_device_id *matches, const struct device_node *node);
 extern int of_modalias_node(struct device_node *node, char *modalias, int len);
+extern int of_parse_phandles_with_args(struct device_node *np,
+	const char *list_name, const char *cells_name, int index,
+	struct device_node **out_node, const void **out_args);
 
 #endif /* _LINUX_OF_H */
-- 
1.5.6.3

