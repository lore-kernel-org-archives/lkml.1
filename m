Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab0COHn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:43:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:51256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624Ab0COHnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:43:55 -0400
Date: Mon, 15 Mar 2010 07:43:02 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, torvalds@linux-foundation.org, peterz@infradead.org,
       rja@sgi.com, sharyath@in.ibm.com, drepper@redhat.com, steiner@sgi.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, travis@sgi.com, peterz@infradead.org,
       drepper@redhat.com, rja@sgi.com, sharyath@in.ibm.com,
       akpm@linux-foundation.org, steiner@sgi.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20100312161316.9520.A69D9226@jp.fujitsu.com>
References: <20100312161316.9520.A69D9226@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: sched_getaffinity(): Allow less than NR_CPUS length
Message-ID: <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org>
Git-Commit-ID: cd3d8031eb4311e516329aee03c79a08333141f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 15 Mar 2010 07:43:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd3d8031eb4311e516329aee03c79a08333141f1
Gitweb:     http://git.kernel.org/tip/cd3d8031eb4311e516329aee03c79a08333141f1
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Fri, 12 Mar 2010 16:15:36 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Mar 2010 08:28:44 +0100

sched: sched_getaffinity(): Allow less than NR_CPUS length

[ Note, this commit changes the syscall ABI for > 1024 CPUs systems. ]

Recently, some distro decided to use NR_CPUS=4096 for mysterious reasons.
Unfortunately, glibc sched interface has the following definition:

	# define __CPU_SETSIZE  1024
	# define __NCPUBITS     (8 * sizeof (__cpu_mask))
	typedef unsigned long int __cpu_mask;
	typedef struct
	{
	  __cpu_mask __bits[__CPU_SETSIZE / __NCPUBITS];
	} cpu_set_t;

It mean, if NR_CPUS is bigger than 1024, cpu_set_t makes an
ABI issue ...

More recently, Sharyathi Nagesh reported following test program makes
misterious syscall failure:

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

Because the kernel assumes len argument of sched_getaffinity() is bigger
than NR_CPUS. But now it is not correct.

Now we are faced with the following annoying dilemma, due to
the limitations of the glibc interface built in years ago:

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

This creates the following behavior:

 (A) In the real 4096 cpus machine, the above test program still
     return -EINVAL.

 (B) NR_CPUS=4096 but the machine have less than 1024 cpus (almost
     all machines in the world), the above can run successfully.

Fortunatelly, BIG SGI machine is mainly used for HPC use case. It means
they can rebuild their programs.

IOW we hope they are not annoyed by this issue ...

Reported-by: Sharyathi Nagesh <sharyath@in.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <20100312161316.9520.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..6eaef3d 100644
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
 
