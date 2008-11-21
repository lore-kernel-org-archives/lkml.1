Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYKUIzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYKUIzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYKUIwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbYKUIws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:48 -0500
Message-ID: <49267624.70305@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cpuset: rcu_read_lock() to protect task_cs() even we don't
 dereference to task_cs()'s return value
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


task_cs() calls cgroup_subsys_state().

we must use rcu_read_lock() to protect cgroup_subsys_state().

in current_cpuset_is_being_rebound(), we don't dereference to task_cs()'s
return value, but task_cs() accesses css_set, this css_set maybe freed
when task_cs() called.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e00526..e0e087e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1141,7 +1136,11 @@ done:
 
 int current_cpuset_is_being_rebound(void)
 {
-	return task_cs(current) == cpuset_being_rebound;
+	struct cpuset *cs;
+	rcu_read_lock();
+	cs = task_cs(current);
+	rcu_read_unlock();
+	return cs == cpuset_being_rebound;
 }
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)

