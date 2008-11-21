Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYKUI4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYKUI4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYKUIw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51442 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbYKUIwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:55 -0500
Message-ID: <4926762A.7000602@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 1/2] cgroups: enhance task_cgroup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


task_cgroup() calls cgroup_subsys_state().
and we must use rcu_read_lock() to protect cgroup_subsys_state().
so we must use rcu_read_lock() to protect task_cgroup().

but it'll not so friendly to caller: the callers of task_cgroup() have
held cgroup_lock(). it means that struct cgroup will not be freed.

So this patch add rcu_read_lock() in task_cgroup() to enhance task_cgroup().
And we do NOT NEED FIX task_cgroup()'s callers, and cgroup_lock()
can protect task_cgroup().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1164963..22901ff 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -359,6 +360,10 @@
 static inline struct cgroup* task_cgroup(struct task_struct *task,
 					       int subsys_id)
 {
-	return task_subsys_state(task, subsys_id)->cgroup;
+	struct cgroup *ret;
+	rcu_read_lock();
+	ret = task_subsys_state(task, subsys_id)->cgroup;
+	rcu_read_unlock();
+	return ret;
 }
 
 int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss,


