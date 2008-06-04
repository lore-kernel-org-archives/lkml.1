Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYFDIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYFDIgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYFDIgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:36:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48148 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYFDIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:36:06 -0400
Date: Wed, 04 Jun 2008 17:36:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: menage@google.com, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] cgroup: list_for_each cleanup
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080604172812.941C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------------------
while() {
	list_entry();
	...
}
--------------------------

is equivalent to following code.

--------------------------
list_for_each_entry(){
	...
}
--------------------------

later can review easily more.

this patch is just clean up.
it doesn't have any behavor change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 kernel/cgroup.c |   55 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

Index: b/kernel/cgroup.c
===================================================================
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -241,17 +241,20 @@ static int use_task_css_set_links;
  */
 static void unlink_css_set(struct css_set *cg)
 {
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
+
 	write_lock(&css_set_lock);
 	hlist_del(&cg->hlist);
 	css_set_count--;
-	while (!list_empty(&cg->cg_links)) {
-		struct cg_cgroup_link *link;
-		link = list_entry(cg->cg_links.next,
-				  struct cg_cgroup_link, cg_link_list);
+
+	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
+				 cg_link_list) {
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
+
 	write_unlock(&css_set_lock);
 }
 
@@ -363,15 +366,14 @@ static struct css_set *find_existing_css
 static int allocate_cg_links(int count, struct list_head *tmp)
 {
 	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
 	int i;
 	INIT_LIST_HEAD(tmp);
 	for (i = 0; i < count; i++) {
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link) {
-			while (!list_empty(tmp)) {
-				link = list_entry(tmp->next,
-						  struct cg_cgroup_link,
-						  cgrp_link_list);
+			list_for_each_entry_safe(link, saved_link, tmp,
+						 cgrp_link_list) {
 				list_del(&link->cgrp_link_list);
 				kfree(link);
 			}
@@ -384,11 +386,10 @@ static int allocate_cg_links(int count, 
 
 static void free_cg_links(struct list_head *tmp)
 {
-	while (!list_empty(tmp)) {
-		struct cg_cgroup_link *link;
-		link = list_entry(tmp->next,
-				  struct cg_cgroup_link,
-				  cgrp_link_list);
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
+
+	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
@@ -1093,6 +1094,8 @@ static void cgroup_kill_sb(struct super_
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	int ret;
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
 
 	BUG_ON(!root);
 
@@ -1112,10 +1115,9 @@ static void cgroup_kill_sb(struct super_
 	 * root cgroup
 	 */
 	write_lock(&css_set_lock);
-	while (!list_empty(&cgrp->css_sets)) {
-		struct cg_cgroup_link *link;
-		link = list_entry(cgrp->css_sets.next,
-				  struct cg_cgroup_link, cgrp_link_list);
+
+	list_for_each_entry_safe(link, saved_link, &cgrp->css_sets,
+				 cgrp_link_list) {
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
 		kfree(link);
@@ -1756,15 +1758,11 @@ int cgroup_add_files(struct cgroup *cgrp
 int cgroup_task_count(const struct cgroup *cgrp)
 {
 	int count = 0;
-	struct list_head *l;
+	struct cg_cgroup_link *link;
 
 	read_lock(&css_set_lock);
-	l = cgrp->css_sets.next;
-	while (l != &cgrp->css_sets) {
-		struct cg_cgroup_link *link =
-			list_entry(l, struct cg_cgroup_link, cgrp_link_list);
+	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
 		count += atomic_read(&link->cg->ref.refcount);
-		l = l->next;
 	}
 	read_unlock(&css_set_lock);
 	return count;
@@ -3072,16 +3070,19 @@ void __css_put(struct cgroup_subsys_stat
  */
 static void cgroup_release_agent(struct work_struct *work)
 {
+	struct cgroup *cgrp;
+	struct cgroup *saved_cgrp;
+
 	BUG_ON(work != &release_agent_work);
 	mutex_lock(&cgroup_mutex);
 	spin_lock(&release_list_lock);
-	while (!list_empty(&release_list)) {
+
+	list_for_each_entry_safe(cgrp, saved_cgrp, &release_list,
+				 release_list) {
 		char *argv[3], *envp[3];
 		int i;
 		char *pathbuf;
-		struct cgroup *cgrp = list_entry(release_list.next,
-						    struct cgroup,
-						    release_list);
+
 		list_del_init(&cgrp->release_list);
 		spin_unlock(&release_list_lock);
 		pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);


