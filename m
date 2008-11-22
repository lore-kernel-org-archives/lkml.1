Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYKVEMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYKVEMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 23:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYKVEM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 23:12:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYKVEMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 23:12:25 -0500
Message-ID: <49278602.2000707@cn.fujitsu.com>
Date: Sat, 22 Nov 2008 12:09:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroups: remove rcu_read_lock() in cgroupstats_build()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cgroup_iter_* do not need rcu_read_lock().

In cgroup_enable_task_cg_lists(), do_each_thread() and
while_each_thread() are protected by RCU,
it's OK, for write_lock(&css_set_lock) implies rcu_read_lock() in non-RT kernel.

If we need explicit rcu_read_lock(), we should add rcu_read_lock()
in cgroup_enable_task_cg_lists(), not cgroup_iter_*.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..e6d92a5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2047,7 +2047,6 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 
 	ret = 0;
 	cgrp = dentry->d_fsdata;
-	rcu_read_lock();
 
 	cgroup_iter_start(cgrp, &it);
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
@@ -2072,7 +2071,6 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	cgroup_iter_end(cgrp, &it);
 
-	rcu_read_unlock();
 err:
 	return ret;
 }


