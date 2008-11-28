Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYK1H1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYK1H1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYK1H0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:26:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYK1H0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:26:48 -0500
Message-ID: <492F9D50.9050603@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 15:27:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: add link_css_set() to remove duplicate code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a common function link_css_set() to link a css_set to a
cgroup.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   51 ++++++++++++++++++++++-----------------------------
 1 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 46d9981..42d0597 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -384,6 +384,19 @@ static int allocate_cg_links(int count, struct list_head *tmp)
 	return 0;
 }
 
+static void link_css_set(struct list_head *tmp_cg_links,
+			 struct css_set *cg, struct cgroup *cgrp)
+{
+	struct cg_cgroup_link *link;
+
+	BUG_ON(list_empty(tmp_cg_links));
+	link = list_first_entry(tmp_cg_links, struct cg_cgroup_link,
+				cgrp_link_list);
+	link->cg = cg;
+	list_move(&link->cgrp_link_list, &cgrp->css_sets);
+	list_add(&link->cg_link_list, &cg->cg_links);
+}
+
 /*
  * find_css_set() takes an existing cgroup group and a
  * cgroup object, and returns a css_set object that's
@@ -399,7 +412,6 @@ static struct css_set *find_css_set(
 	int i;
 
 	struct list_head tmp_cg_links;
-	struct cg_cgroup_link *link;
 
 	struct hlist_head *hhead;
 
@@ -444,16 +456,8 @@ static struct css_set *find_css_set(
 		 * only do it for the first subsystem in each
 		 * hierarchy
 		 */
-		if (ss->root->subsys_list.next == &ss->sibling) {
-			BUG_ON(list_empty(&tmp_cg_links));
-			link = list_entry(tmp_cg_links.next,
-					  struct cg_cgroup_link,
-					  cgrp_link_list);
-			list_del(&link->cgrp_link_list);
-			list_add(&link->cgrp_link_list, &cgrp->css_sets);
-			link->cg = res;
-			list_add(&link->cg_link_list, &res->cg_links);
-		}
+		if (ss->root->subsys_list.next == &ss->sibling)
+			link_css_set(&tmp_cg_links, res, cgrp);
 	}
 
 	BUG_ON(!list_empty(&tmp_cg_links));
@@ -982,7 +986,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		root = NULL;
 	} else {
 		/* New superblock */
-		struct cgroup *cgrp = &root->top_cgroup;
+		struct cgroup *root_cgrp = &root->top_cgroup;
 		struct inode *inode;
 		int i;
 
@@ -1023,7 +1027,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		list_add(&root->root_list, &roots);
 		root_count++;
 
-		sb->s_root->d_fsdata = &root->top_cgroup;
+		sb->s_root->d_fsdata = root_cgrp;
 		root->top_cgroup.dentry = sb->s_root;
 
 		/* Link the top cgroup in this hierarchy into all
@@ -1034,29 +1038,18 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 			struct hlist_node *node;
 			struct css_set *cg;
 
-			hlist_for_each_entry(cg, node, hhead, hlist) {
-				struct cg_cgroup_link *link;
-
-				BUG_ON(list_empty(&tmp_cg_links));
-				link = list_entry(tmp_cg_links.next,
-						  struct cg_cgroup_link,
-						  cgrp_link_list);
-				list_del(&link->cgrp_link_list);
-				link->cg = cg;
-				list_add(&link->cgrp_link_list,
-					 &root->top_cgroup.css_sets);
-				list_add(&link->cg_link_list, &cg->cg_links);
-			}
+			hlist_for_each_entry(cg, node, hhead, hlist)
+				link_css_set(&tmp_cg_links, cg, root_cgrp);
 		}
 		write_unlock(&css_set_lock);
 
 		free_cg_links(&tmp_cg_links);
 
-		BUG_ON(!list_empty(&cgrp->sibling));
-		BUG_ON(!list_empty(&cgrp->children));
+		BUG_ON(!list_empty(&root_cgrp->sibling));
+		BUG_ON(!list_empty(&root_cgrp->children));
 		BUG_ON(root->number_of_cgroups != 1);
 
-		cgroup_populate_dir(cgrp);
+		cgroup_populate_dir(root_cgrp);
 		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
 	}
-- 
1.5.4.rc3
