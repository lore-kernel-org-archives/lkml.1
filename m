Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYG1CWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYG1CWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYG1CWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:22:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1CWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:22:32 -0400
Message-ID: <488D2D0A.7050006@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:20:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: remove duplicate code in allocate_cg_link()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- just call free_cg_links() in allocate_cg_links()
- the list will get initialized in allocate_cg_links(), so don't init
  it twice

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 28debe4..249a517 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -355,6 +355,17 @@ static struct css_set *find_existing_css_set(
 	return NULL;
 }
 
+static void free_cg_links(struct list_head *tmp)
+{
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
+
+	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
+		list_del(&link->cgrp_link_list);
+		kfree(link);
+	}
+}
+
 /*
  * allocate_cg_links() allocates "count" cg_cgroup_link structures
  * and chains them on tmp through their cgrp_link_list fields. Returns 0 on
@@ -363,17 +374,12 @@ static struct css_set *find_existing_css_set(
 static int allocate_cg_links(int count, struct list_head *tmp)
 {
 	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
 	int i;
 	INIT_LIST_HEAD(tmp);
 	for (i = 0; i < count; i++) {
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link) {
-			list_for_each_entry_safe(link, saved_link, tmp,
-						 cgrp_link_list) {
-				list_del(&link->cgrp_link_list);
-				kfree(link);
-			}
+			free_cg_links(tmp);
 			return -ENOMEM;
 		}
 		list_add(&link->cgrp_link_list, tmp);
@@ -381,17 +387,6 @@ static int allocate_cg_links(int count, struct list_head *tmp)
 	return 0;
 }
 
-static void free_cg_links(struct list_head *tmp)
-{
-	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
-
-	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
-		list_del(&link->cgrp_link_list);
-		kfree(link);
-	}
-}
-
 /*
  * find_css_set() takes an existing cgroup group and a
  * cgroup object, and returns a css_set object that's
@@ -956,7 +951,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	struct super_block *sb;
 	struct cgroupfs_root *root;
 	struct list_head tmp_cg_links;
-	INIT_LIST_HEAD(&tmp_cg_links);
 
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
-- 
1.5.4.rc3

