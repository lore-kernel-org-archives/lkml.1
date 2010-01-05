Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057Ab0AELse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0AELse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503Ab0AELsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36331 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0AELsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [7/12] SYSDEV: Use sysdev_class attribute arrays in node driver
Message-Id: <20100105114804.87EAAB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert the node driver to sysdev_class attribute arrays. This
greatly cleans up the code and remove a lot of code.

Saves ~150 bytes of code on x86-64.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/node.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6.33-rc2-ak/drivers/base/node.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/node.c
+++ linux-2.6.33-rc2-ak/drivers/base/node.c
@@ -16,8 +16,11 @@
 #include <linux/device.h>
 #include <linux/swap.h>
 
+static struct sysdev_class_attribute *node_state_attrs[];
+
 static struct sysdev_class node_class = {
 	.name = "node",
+	.attrs = node_state_attrs,
 };
 
 
@@ -569,29 +572,27 @@ static struct node_attr node_state_attr[
 #endif
 };
 
-static int node_states_init(void)
-{
-	int i;
-	int err = 0;
-
-	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
-	for (i = 0;  i < NR_NODE_STATES; i++) {
-		int ret;
-		ret = sysdev_class_create_file(&node_class, &node_state_attr[i].attr);
-		if (!err)
-			err = ret;
-	}
-	return err;
-}
+static struct sysdev_class_attribute *node_state_attrs[] = {
+	&node_state_attr[0].attr,
+	&node_state_attr[1].attr,
+	&node_state_attr[2].attr,
+	&node_state_attr[3].attr,
+#ifdef CONFIG_HIGHMEM
+	&node_state_attr[4].attr,
+#endif
+	NULL
+};
 
 #define NODE_CALLBACK_PRI	2	/* lower than SLAB */
 static int __init register_node_type(void)
 {
 	int ret;
 
+ 	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
+ 	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != NR_NODE_STATES);
+
 	ret = sysdev_class_register(&node_class);
 	if (!ret) {
-		ret = node_states_init();
 		hotplug_memory_notifier(node_memory_callback,
 					NODE_CALLBACK_PRI);
 	}
