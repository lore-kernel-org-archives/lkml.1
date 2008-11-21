Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYKUI4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYKUI4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYKUIwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbYKUIww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:52 -0500
Message-ID: <49267627.80103@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] memcontrol: rcu_read_lock() to protect mm_match_cgroup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm_match_cgroup() calls cgroup_subsys_state().

we must use rcu_read_lock() to protect cgroup_subsys_state().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1fbe14d..ce89ff0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -47,8 +47,15 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-#define mm_match_cgroup(mm, cgroup)	\
-	((cgroup) == mem_cgroup_from_task((mm)->owner))
+static inline
+int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+{
+	struct mem_cgroup *mem;
+	rcu_read_lock();
+	mem = mem_cgroup_from_task((mm)->owner);
+	rcu_read_unlock();
+	return cgroup == mem;
+}
 
 extern int
 mem_cgroup_prepare_migration(struct page *page, struct page *newpage);

