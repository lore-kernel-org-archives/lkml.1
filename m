Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYDBCTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYDBCTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 22:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbYDBCTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 22:19:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53663 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbYDBCSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 22:18:45 -0400
Message-ID: <47F2EC94.8030707@cn.fujitsu.com>
Date: Wed, 02 Apr 2008 10:16:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH -mm 2/3] cgroup: simplify init_subsys()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are at system boot and there is only 1 cgroup group (i,e,
init_css_set), so we don't need to run through the css_set
linked list. Neither do we need to run through the task list,
since the init process hasn't been created yet.

Also referring to a comment in cgroup.h:

struct css_set
{
	...
	/*
	 * Set of subsystem states, one for each subsystem. This array
	 * is immutable after creation apart from the init_css_set
	 * during subsystem registration (at boot time).
	 */
	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
}

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   30 ++++--------------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 78e5bde..2b72346 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2467,7 +2467,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
-	struct list_head *l;
 
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
@@ -2478,32 +2477,11 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	BUG_ON(IS_ERR(css));
 	init_cgroup_css(css, ss, dummytop);
 
-	/* Update all cgroup groups to contain a subsys
+	/* Update the init_css_set to contain a subsys
 	 * pointer to this state - since the subsystem is
-	 * newly registered, all tasks and hence all cgroup
-	 * groups are in the subsystem's top cgroup. */
-	write_lock(&css_set_lock);
-	l = &init_css_set.list;
-	do {
-		struct css_set *cg =
-			list_entry(l, struct css_set, list);
-		cg->subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
-		l = l->next;
-	} while (l != &init_css_set.list);
-	write_unlock(&css_set_lock);
-
- 	/* If this subsystem requested that it be notified with fork
- 	 * events, we should send it one now for every process in the
- 	 * system */
-	if (ss->fork) {
-		struct task_struct *g, *p;
-
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			ss->fork(ss, p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-	}
+	 * newly registered, all tasks and hence the
+	 * init_css_set is in the subsystem's top cgroup. */
+	init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
-- 
1.5.4.rc3
