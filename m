Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYJ1Rqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYJ1Rqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYJ1RqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:16 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57671 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753081AbYJ1RqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:15 -0400
Date: Tue, 28 Oct 2008 20:46:13 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 2/6] of/of_i2c: implement of_{,un}register_i2c_device
Message-ID: <20081028174613.GB25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_register_i2c_device is factored out of of_register_i2c_devices.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/of_i2c.c    |   71 +++++++++++++++++++++++++++++------------------
 include/linux/of_i2c.h |    4 +++
 2 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 24bbef7..57de7c5 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -16,41 +16,58 @@
 #include <linux/of_i2c.h>
 #include <linux/module.h>
 
-void of_register_i2c_devices(struct i2c_adapter *adap,
-			     struct device_node *adap_node)
+struct i2c_client *of_register_i2c_device(struct i2c_adapter *adap,
+					  struct i2c_board_info *info,
+					  struct device_node *node)
 {
-	void *result;
-	struct device_node *node;
+	struct i2c_client *client;
+	const u32 *addr;
+	int len;
 
-	for_each_child_of_node(adap_node, node) {
-		struct i2c_board_info info = {};
-		const u32 *addr;
-		int len;
+	if (of_modalias_node(node, info->type, sizeof(info->type)))
+		return NULL;
 
-		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0)
-			continue;
+	addr = of_get_property(node, "reg", &len);
+	if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
+		printk(KERN_ERR
+		       "of-i2c: invalid i2c device entry\n");
+		return NULL;
+	}
+
+	info->irq = irq_of_parse_and_map(node, 0);
+	info->addr = *addr;
 
-		addr = of_get_property(node, "reg", &len);
-		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
-			printk(KERN_ERR
-			       "of-i2c: invalid i2c device entry\n");
-			continue;
-		}
+	request_module("%s", info->type);
+
+	client = i2c_new_device(adap, info);
+	if (!client) {
+		printk(KERN_ERR
+		       "of-i2c: Failed to load driver for %s\n",
+		       info->type);
+		irq_dispose_mapping(info->irq);
+		return NULL;
+	}
+	return client;
+}
+EXPORT_SYMBOL(of_register_i2c_device);
 
-		info.irq = irq_of_parse_and_map(node, 0);
+void of_unregister_i2c_device(struct i2c_client *client)
+{
+	if (client->irq)
+		irq_dispose_mapping(client->irq);
+	i2c_unregister_device(client);
+}
+EXPORT_SYMBOL(of_unregister_i2c_device);
 
-		info.addr = *addr;
+void of_register_i2c_devices(struct i2c_adapter *adap,
+			     struct device_node *adap_node)
+{
+	struct device_node *node;
 
-		request_module("%s", info.type);
+	for_each_child_of_node(adap_node, node) {
+		struct i2c_board_info info = {};
 
-		result = i2c_new_device(adap, &info);
-		if (result == NULL) {
-			printk(KERN_ERR
-			       "of-i2c: Failed to load driver for %s\n",
-			       info.type);
-			irq_dispose_mapping(info.irq);
-			continue;
-		}
+		of_register_i2c_device(adap, &info, node);
 	}
 }
 EXPORT_SYMBOL(of_register_i2c_devices);
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index bd2a870..68851c0 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -14,6 +14,10 @@
 
 #include <linux/i2c.h>
 
+struct i2c_client *of_register_i2c_device(struct i2c_adapter *adap,
+					  struct i2c_board_info *info,
+					  struct device_node *node);
+void of_unregister_i2c_device(struct i2c_client *client);
 void of_register_i2c_devices(struct i2c_adapter *adap,
 			     struct device_node *adap_node);
 
-- 
1.5.6.3

