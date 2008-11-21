Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYKUIy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYKUIy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYKUIwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbYKUIwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:42 -0500
Message-ID: <4926761E.8030002@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix incorrect using rcu_dereference() in cgroup_subsys_state()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's task->cgroups protected by RCU. and struct css_set.subsys[subsys_id]
is readonly(after init). so we don't need rcu_dereference() for
struct css_set.subsys[subsys_id].

the ways using cgroup_subsys_state() safely:

#1:
rcu_read_lock() / task_lock();
c = cgroup_subsys_state(tsk, id);
use c;
rcu_read_unlock() / task_unlock();


#2: use cgroup_lock() for _current_ task.
cgroup_lock();
c = cgroup_subsys_state(current, id);
use c;
cgroup_unlock();

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1164963..22901ff 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -359,10 +360,15 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 	return cgrp->subsys[subsys_id];
 }
 
+/* Caller must hold task_lock() or rcu_read_lock() */
 static inline struct cgroup_subsys_state *task_subsys_state(
 	struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference(task->cgroups->subsys[subsys_id]);
+	/*
+	 * ->subsys[subsys_id] are read-only data, so we do not need
+	 * rcu_dereference() for it.
+	 */
+	return rcu_dereference(task->cgroups)->subsys[subsys_id];
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,



