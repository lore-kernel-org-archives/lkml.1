Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0CBX3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:20 -0500
Received: from kroah.org ([198.145.64.141]:38497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0CBX3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/62] sysdev: Convert node driver class attributes to be data driven
Date: Tue,  2 Mar 2010 15:28:05 -0800
Message-Id: <1267572541-410-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Using the new attribute argument convert the node driver class
attributes to carry the node state. Then use a shared function to do
what a lot of individual functions did before.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/node.c |   65 ++++++++++++++------------------------------------
 1 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 85c9d30..aa8bc4b 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -544,59 +544,29 @@ static ssize_t print_nodes_state(enum node_states state, char *buf)
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
-- 
1.7.0.1

