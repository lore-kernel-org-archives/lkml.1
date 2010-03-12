Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0CLHPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:15:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48801 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0CLHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:15:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Sharyathi Nagesh <sharyath@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: sched_getaffinity() allow less than NR_CPUS length
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100312161316.9520.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 12 Mar 2010 16:15:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, some distro decided to use NR_CPUS=4096 for mysterious reason.
Unfortunately, glibc sched interface have following definition.

	# define __CPU_SETSIZE  1024
	# define __NCPUBITS     (8 * sizeof (__cpu_mask))
	typedef unsigned long int __cpu_mask;
	typedef struct
	{
	  __cpu_mask __bits[__CPU_SETSIZE / __NCPUBITS];
	} cpu_set_t;

It mean, if NR_CPUS is bigger than 1024, cpu_set_t can makes ABI issue.

More recently, Sharyathi Nagesh reported following test program makes
misterious syscall failure.

-----------------------------------------------------------------------
 #define _GNU_SOURCE
 #include<stdio.h>
 #include<errno.h>
 #include<sched.h>

int main()
{
     cpu_set_t set;
     if (sched_getaffinity(0, sizeof(cpu_set_t), &set) < 0)
         printf("\n Call is failing with:%d", errno);
}
-----------------------------------------------------------------------

Because the kernel assue len argument of sched_getaffinity() is bigger
than NR_CPUS. but now it is not correct.

Now we faced annoying dilemma.
(1) if we change glibc's __CPU_SETSIZE definition, we lost
    binary compatibility of _all_ application.
(2) if we don't change it, we also lost binary compatibility of
     Sharyathi's use case.

Then, I would propse to change the rule of the len argument of
sched_getaffinity().

Old:
	len should be bigger than NR_CPUS
New:
	len should be bigger than maximum possible cpu id

It makes following behavior
(A) In the real 4096 cpus machine, the above test program still return -EINVAL.
(B) NR_CPUS=4096 but the machine have less than 1024 cpus (almost
    machines in the world), the above can run successfully.

Fortunatelly, BIG SGI machine is mainly used for HPC use case. It mean
they can rewrite their program by themself. IOW we can think
they don't annoy this issue.

Reported-by: Sharyathi Nagesh <sharyath@in.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 150b698..34217f1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4902,7 +4902,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	int ret;
 	cpumask_var_t mask;
 
-	if (len < cpumask_size())
+	if (len < nr_cpu_ids)
+		return -EINVAL;
+	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
@@ -4910,10 +4912,12 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
+		int retlen = min(len, cpumask_size());
+
+		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;
 		else
-			ret = cpumask_size();
+			ret = retlen;
 	}
 	free_cpumask_var(mask);
 
-- 
1.6.5.2



