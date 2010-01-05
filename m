Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252Ab0AELsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0AELsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271Ab0AELsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36321 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0AELsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:01 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [2/12] SYSFS: Convert node driver class attributes to be data driven
Message-Id: <20100105114759.7A2EEB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:47:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using the new attribute argument convert the node driver class attributes
to carry the node state. Then use a shared function to do what 
a lot of individual functions did before.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/node.c |   65 ++++++++++++++--------------------------------------
 1 file changed, 18 insertions(+), 47 deletions(-)

Index: linux-2.6.33-rc2-ak/drivers/base/node.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/node.c
+++ linux-2.6.33-rc2-ak/drivers/base/node.c
@@ -544,59 +544,29 @@ static ssize_t print_nodes_state(enum no
 	return n;
 }
 
-static ssize_t print_nodes_possible(struct sysdev_class *class,
-				    struct sysdev_class_attribute *attr, char *buf)
-{
-	return print_nodes_state(N_POSSIBLE, buf);
-}
-
-static ssize_t print_nodes_online(struct sysdev_class *class,
-				  struct sysdev_class_attribute *attr,
-				  char *buf)
-{
-	return print_nodes_state(N_ONLINE, buf);
-}
-
-static ssize_t print_nodes_has_normal_memory(struct sysdev_class *class,
-					     struct sysdev_class_attribute *attr,
-					     char *buf)
-{
-	return print_nodes_state(N_NORMAL_MEMORY, buf);
-}
-
-static ssize_t print_nodes_has_cpu(struct sysdev_class *class,
-				   struct sysdev_class_attribute *attr,
-				   char *buf)
-{
-	return print_nodes_state(N_CPU, buf);
-}
-
-static SYSDEV_CLASS_ATTR(possible, 0444, print_nodes_possible, NULL);
-static SYSDEV_CLASS_ATTR(online, 0444, print_nodes_online, NULL);
-static SYSDEV_CLASS_ATTR(has_normal_memory, 0444, print_nodes_has_normal_memory,
-									NULL);
-static SYSDEV_CLASS_ATTR(has_cpu, 0444, print_nodes_has_cpu, NULL);
+struct node_attr {
+	struct sysdev_class_attribute attr;
+	enum node_states state;
+};
 
-#ifdef CONFIG_HIGHMEM
-static ssize_t print_nodes_has_high_memory(struct sysdev_class *class,
-					   struct sysdev_class_attribute *attr,
-					   char *buf)
+static ssize_t show_node_state(struct sysdev_class *class,
+			       struct sysdev_class_attribute *attr, char *buf)
 {
-	return print_nodes_state(N_HIGH_MEMORY, buf);
+	struct node_attr *na = container_of(attr, struct node_attr, attr);
+	return print_nodes_state(na->state, buf);
 }
 
-static SYSDEV_CLASS_ATTR(has_high_memory, 0444, print_nodes_has_high_memory,
-									 NULL);
-#endif
+#define _NODE_ATTR(name, state) \
+	{ _SYSDEV_CLASS_ATTR(name, 0444, show_node_state, NULL), state }
 
-struct sysdev_class_attribute *node_state_attr[] = {
-	&attr_possible,
-	&attr_online,
-	&attr_has_normal_memory,
+static struct node_attr node_state_attr[] = {
+	_NODE_ATTR(possible, N_POSSIBLE),
+	_NODE_ATTR(online, N_ONLINE),
+	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
+	_NODE_ATTR(has_cpu, N_CPU),
 #ifdef CONFIG_HIGHMEM
-	&attr_has_high_memory,
+	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
-	&attr_has_cpu,
 };
 
 static int node_states_init(void)
@@ -604,9 +574,10 @@ static int node_states_init(void)
 	int i;
 	int err = 0;
 
+	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
 	for (i = 0;  i < NR_NODE_STATES; i++) {
 		int ret;
-		ret = sysdev_class_create_file(&node_class, node_state_attr[i]);
+		ret = sysdev_class_create_file(&node_class, &node_state_attr[i].attr);
 		if (!err)
 			err = ret;
 	}
