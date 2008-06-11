Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYFKHNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYFKHNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYFKHNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:13:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63400 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYFKHNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:13:43 -0400
Message-ID: <484F7AC5.8040206@cn.fujitsu.com>
Date: Wed, 11 Jun 2008 15:12:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: mingo@elte.hu
CC: peterz@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fair group: fix divide by zero
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a bug which can be reproduced by this way:(linux-2.6.26-rc5, x86-64)
(use 2^32, 2^33, ...., 2^63 as shares value)

# mkdir /dev/cpuctl
# mount -t cgroup -o cpu cpuctl /dev/cpuctl
# cd /dev/cpuctl
# mkdir sub
# echo 0x8000000000000000 > sub/cpu.shares
# echo $$ > sub/tasks
oops here! divide by zero.

This is because do_div() expects the 2th parameter to be 32 bits,
but unsigned long is 64 bits in x86_64.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..d3005b4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -368,7 +368,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		cfs_rq = cfs_rq_of(se);
 
 		slice *= se->load.weight;
-		do_div(slice, cfs_rq->load.weight);
+		slice = div64_u64(slice, cfs_rq->load.weight);
 	}
 
 
@@ -399,7 +399,7 @@ static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 			weight += se->load.weight;
 
 		vslice *= NICE_0_LOAD;
-		do_div(vslice, weight);
+		vslice = div64_u64(vslice, weight);
 	}
 
 	return vslice;


