Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZBZKMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZBZKMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZBZKLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:11:54 -0500
Received: from sineb-mail-1.sun.com ([192.18.19.6]:59570 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZBZKLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:11:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Date: Thu, 26 Feb 2009 18:11:44 +0800
From: Li Wei <W.Li@Sun.COM>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
In-reply-to: <49883CD7.2060602@linux.vnet.ibm.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Message-id: <1235643104.13052.10.camel@localhost>
X-Mailer: Evolution 2.24.3
References: <49883CD7.2060602@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 13:47 +0100, Peter Oberparleiter wrote:
> +/* write() implementation for reset file. Reset all profiling data to zero
> + * and remove ghost nodes. */
> +static ssize_t reset_write(struct file *file, const char __user *addr,
> +			   size_t len, loff_t *pos)
> +{
> +	struct gcov_node *node;
> +	struct gcov_node *r;
> +
> +	mutex_lock(&node_lock);
> +	list_for_each_entry_safe(node, r, &all_head, all) {
> +		if (node->info)
> +			gcov_info_reset(node->info);
> +		else
> +			remove_node(node);
> +	}
> +	mutex_unlock(&node_lock);
> +
> +	return len;
> +}

The remove_node above may have deleted the node that r points at. How
about replacing all_head with a leaves_head that contains all leaf
nodes, and iterate the latter instead?

---
 kernel/gcov/fs.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 6675c82..aab3be7 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -29,7 +29,7 @@
  * struct gcov_node - represents a debugfs entry
  * @list: list head for child node list
  * @children: child nodes
- * @all: list head for list of all nodes
+ * @leaves: list head for list of all leaf nodes
  * @parent: parent node
  * @info: associated profiling data structure if not a directory
  * @ghost: when an object file containing profiling data is unloaded we keep a
@@ -47,7 +47,7 @@
 struct gcov_node {
 	struct list_head list;
 	struct list_head children;
-	struct list_head all;
+	struct list_head leaves;
 	struct gcov_node *parent;
 	struct gcov_info *info;
 	struct gcov_info *ghost;
@@ -60,7 +60,7 @@ static const char objtree[] = OBJTREE;
 static const char srctree[] = SRCTREE;
 static struct gcov_node root_node;
 static struct dentry *reset_dentry;
-static LIST_HEAD(all_head);
+static LIST_HEAD(leaves_head);
 static DEFINE_MUTEX(node_lock);
 
 /* If non-zero, keep copies of profiling data for unloaded modules. */
@@ -206,7 +206,7 @@ static struct gcov_node *get_node_by_name(const char *name)
 	struct gcov_node *node;
 	struct gcov_info *info;
 
-	list_for_each_entry(node, &all_head, all) {
+	list_for_each_entry(node, &leaves_head, leaves) {
 		info = get_node_info(node);
 		if (info && (strcmp(info->filename, name) == 0))
 			return node;
@@ -355,7 +355,7 @@ static void init_node(struct gcov_node *node, struct gcov_info *info,
 {
 	INIT_LIST_HEAD(&node->list);
 	INIT_LIST_HEAD(&node->children);
-	INIT_LIST_HEAD(&node->all);
+	INIT_LIST_HEAD(&node->leaves);
 	node->info = info;
 	if (name)
 		strcpy(node->name, name);
@@ -389,7 +389,8 @@ static struct gcov_node *new_node(struct gcov_node *parent,
 	if (info)
 		add_links(node, parent->dentry);
 	list_add(&node->list, &parent->children);
-	list_add(&node->all, &all_head);
+	list_add(&node->leaves, &leaves_head)From e3ffddfa9af66bf6f9df400b63ae88f2ac90562c Mon Sep 17 00:00:00 2001
From: Li Wei <w.li@sun.com>
Date: Thu, 26 Feb 2009 17:53:37 +0800
Subject: [PATCH] gcov: fix panic in reset_write

remove_node may delete the next node in all_head. Replace the all_head
with a list of all leaf nodes, and process leaves_head in reset_write.
;
+	list_del_init(&parent->leaves);
 
 	return node;
 }
@@ -412,7 +413,7 @@ static void remove_links(struct gcov_node *node)
 static void release_node(struct gcov_node *node)
 {
 	list_del(&node->list);
-	list_del(&node->all);
+	list_del(&node->leaves);
 	debugfs_remove(node->dentry);
 	remove_links(node);
 	if (node->ghost)
@@ -456,7 +457,7 @@ static ssize_t reset_write(struct file *file, const char __user *addr,
 	struct gcov_node *r;
 
 	mutex_lock(&node_lock);
-	list_for_each_entry_safe(node, r, &all_head, all) {
+	list_for_each_entry_safe(node, r, &leaves_head, leaves) {
 		if (node->info)
 			gcov_info_reset(node->info);
 		else
@@ -480,7 +481,7 @@ static const struct file_operations gcov_reset_fops = {
 	.read = reset_read,
 };
 
-/* Create a node for a given profiling data set and add it to all lists and
+/* Create a node for a given profiling data set and add it to leaves lists and
  * debugfs. Needs to be called with node_lock held. */
 static void add_node(struct gcov_info *info)
 {
-- 
1.5.6.3

