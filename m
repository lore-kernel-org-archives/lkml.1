Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYHABhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYHABhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHABhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:37:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64784 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYHABhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:37:24 -0400
Message-ID: <4892685E.2000000@cn.fujitsu.com>
Date: Fri, 01 Aug 2008 09:35:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
References: <48912FDD.8060006@cn.fujitsu.com>	<20080731072355.b582b2d6.pj@sgi.com>	<4891B9E0.2090900@cn.fujitsu.com> <20080731083706.e6bd4acc.pj@sgi.com>
In-Reply-To: <20080731083706.e6bd4acc.pj@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Bottom line - my priorities for non-critical code paths, most important first:
>  1) It must work.
>  2) Keep it easy for humans to understand.
>  3) Reduce kernel text size.
>  4) Reduce CPU cycles.
> 

I agree, Thank you!

How about this one?

The loop after this patch applied is:

	ntasks_now = cgroup_task_count(cs->css.cgroup);
	while (1) {
		ntasks = ntasks_now;			/* guess */
		ntasks += fudge;
		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
		if (!mmarray)
			goto done;
		read_lock(&tasklist_lock);		/* block fork */
		ntasks_now = cgroup_task_count(cs->css.cgroup);
		if (ntasks_now <= ntasks)
			break;				/* got enough */
		read_unlock(&tasklist_lock);		/* try again */
		kfree(mmarray);
	}

I think the readability of this code is as good as original's.
And it's better in semantic meaning.

The old non monotonic increasing value is caused by the redundant
cgroup_task_count(). Removing it is good for keeping ntasks
increasing(not need additional arithmetic compare or max statement).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d5ab79c..56a057f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -930,7 +930,7 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 {
 	struct task_struct *p;
 	struct mm_struct **mmarray;
-	int i, n, ntasks;
+	int i, n, ntasks, ntasks_now;
 	int migrate;
 	int fudge;
 	struct cgroup_iter it;
@@ -949,14 +949,16 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	 * few more lines of code, we can retry until we get a big
 	 * enough mmarray[] w/o using GFP_ATOMIC.
 	 */
+	ntasks_now = cgroup_task_count(cs->css.cgroup);
 	while (1) {
-		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
+		ntasks = ntasks_now;			/* guess */
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
 		kfree(mmarray);

