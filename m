Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab0CBX6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:58:54 -0500
Received: from kroah.org ([198.145.64.141]:38514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab0CBX3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/62] sysdev: Use sysdev_class attribute arrays in node driver
Date: Tue,  2 Mar 2010 15:28:10 -0800
Message-Id: <1267572541-410-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Convert the node driver to sysdev_class attribute arrays. This
greatly cleans up the code and remove a lot of code.

Saves ~150 bytes of code on x86-64.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/node.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index aa8bc4b..ad43185 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -16,8 +16,11 @@
 #include <linux/device.h>
 #include <linux/swap.h>
 
+static struct sysdev_class_attribute *node_state_attrs[];
+
 static struct sysdev_class node_class = {
 	.name = "node",
+	.attrs = node_state_attrs,
 };
 
 
@@ -569,29 +572,27 @@ static struct node_attr node_state_attr[] = {
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
-- 
1.7.0.1

