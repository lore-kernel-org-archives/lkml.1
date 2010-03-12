Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0CLG7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 01:59:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0CLG7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 01:59:00 -0500
Message-ID: <4B99E634.2070608@cn.fujitsu.com>
Date: Fri, 12 Mar 2010 14:59:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm 2/2] cpuset: alloc nodemask_t at heap not stack - fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix memory leak

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Against the following patch in mmotm-2010-03-11-13-13:
cpuset-alloc-nodemask_t-at-heap-not-stack.patch
---
 kernel/cpuset.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f36e577..8e27d00 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1401,7 +1401,7 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
 
 	if (from == NULL || to == NULL)
-		return;
+		goto alloc_fail;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1432,8 +1432,12 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 		mmput(mm);
 	}
 
-	NODEMASK_FREE(from);
-	NODEMASK_FREE(to);
+alloc_fail:
+	if (from)
+		NODEMASK_FREE(from);
+
+	if (to)
+		NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
-- 
1.6.5.2


