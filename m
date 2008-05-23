Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbYEWHtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbYEWHtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYEWHtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:49:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYEWHtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:49:08 -0400
Message-ID: <483676AD.9020303@cn.fujitsu.com>
Date: Fri, 23 May 2008 15:47:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       menage@google.com, pj@sgi.com
Subject: [PATCH] cpusets: fix bug of adding inexistent cpu or mem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding inexistent cpu to a cpuset will be omitted quietly.
It should return -EINVAL.

Example: (real_nr_cpus <= 4 < NR_CPUS or cpu#4 was just offline)

# cat cpus
0-1
# /bin/echo 4 > cpus
# /bin/echo $?
0
# cat cpus

# 

The same as adding inexistent mem.
This patch will fix this bug.
And when *buf == "", the check is unneeded.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 86ea9e3..039baa4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -797,8 +797,10 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 		retval = cpulist_parse(buf, trialcs.cpus_allowed);
 		if (retval < 0)
 			return retval;
+
+		if (!cpus_subset(trialcs.cpus_allowed, cpu_online_map))
+			return -EINVAL;
 	}
-	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
@@ -932,9 +934,11 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
 		if (retval < 0)
 			goto done;
+
+		if (!nodes_subset(trialcs.mems_allowed,
+				node_states[N_HIGH_MEMORY]))
+			return -EINVAL;
 	}
-	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
-						node_states[N_HIGH_MEMORY]);
 	oldmem = cs->mems_allowed;
 	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */


