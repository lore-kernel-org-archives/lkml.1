Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYCNNob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYCNNob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCNNoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:44:24 -0400
Received: from sacred.ru ([62.205.161.221]:54468 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYCNNoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:44:23 -0400
Message-ID: <47DA811A.8040704@openvz.org>
Date: Fri, 14 Mar 2008 16:43:54 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix check for thread being a group leader in memcgroup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 16:43:58 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check t->pid == t->pid is not the blessed way to check
whether a task is a group leader.

This is not about the code beautifulness only, but about 
pid namespaces fixes - both the tgid and the pid fields on 
the task_struct are (slowly :( ) becoming deprecated.

Besides, the thread_group_leader() macro makes only one
dereference :)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eb681a6..bc4cac6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1065,7 +1065,7 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 	 * Only thread group leaders are allowed to migrate, the mm_struct is
 	 * in effect owned by the leader
 	 */
-	if (p->tgid != p->pid)
+	if (!thread_group_leader(p))
 		goto out;
 
 	css_get(&mem->css);

