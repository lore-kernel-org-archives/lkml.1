Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbYGaDYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbYGaDYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYGaDYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:24:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58229 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbYGaDYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:24:07 -0400
Message-ID: <48912FDD.8060006@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 11:22:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: make ntasks to be a monotonic increasing value
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ntasks is not a monotonic increasing value,
So maybe fudge+1 processes are created when kmalloc and killed
when kfree in every loop. And the loop will not end or
repetition a long time.

This patch prevent this kind of attack.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d5ab79c..65eaa2b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -949,16 +949,20 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	 * few more lines of code, we can retry until we get a big
 	 * enough mmarray[] w/o using GFP_ATOMIC.
 	 */
+	ntasks = cgroup_task_count(cs->css.cgroup);	/* guess */
 	while (1) {
-		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
+		int ntasks_now;
 		ntasks += fudge;
 		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
 		if (!mmarray)
 			goto done;
 		read_lock(&tasklist_lock);		/* block fork */
-		if (cgroup_task_count(cs->css.cgroup) <= ntasks)
+		ntasks_now = cgroup_task_count(cs->css.cgroup);
+		if (ntasks_now <= ntasks)
 			break;				/* got enough */
 		read_unlock(&tasklist_lock);		/* try again */
+		ntasks = ntasks_now;
+		fudge += fudge >> 3;
 		kfree(mmarray);
 	}
 


