Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZCMAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZCMAIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZCMAIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:08:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:46053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZCMAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:08:40 -0400
Date: Fri, 13 Mar 2009 00:06:26 GMT
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090312174501.GA7821@linux.vnet.ibm.com>
References: <20090312174501.GA7821@linux.vnet.ibm.com>
Subject: [tip:sched/urgent] cpuset: Check if the cpus allowed is a subset of the cpuset's cpus for PF_THREAD_BOUND threads
Message-ID: <tip-5a98d36112f4301f068b638d6e0db2357f7deb75@git.kernel.org>
Git-Commit-ID: 5a98d36112f4301f068b638d6e0db2357f7deb75
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 00:06:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a98d36112f4301f068b638d6e0db2357f7deb75
Gitweb:     http://git.kernel.org/tip/5a98d36112f4301f068b638d6e0db2357f7deb75
Author:     Dhaval Giani <dhaval@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Mar 2009 23:15:01 +0530
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 00:21:25 +0100

cpuset: Check if the cpus allowed is a subset of the cpuset's cpus for PF_THREAD_BOUND threads

When a kernel thread which has been bound to a CPU is moved to
a cpuset which is a superset of the CPU it is bound to, the
movement fails.

 [root@llm11 cgroups]# mkdir a
 [root@llm11 cgroups]# echo 3 > a/cpuset.cpus
 [root@llm11 cgroups]# echo 0 > a/cpuset.mems
 [root@llm11 cgroups]# echo 12 > a/tasks
 [root@llm11 cgroups]# echo 12 > tasks
 -bash: echo: write error: Invalid argument
 [root@llm11 cgroups]# cat cpuset.cpus
 0-7
 [root@llm11 cgroups]#

(pid 12 is the migration thread bound to CPU 3)

Change the check to see if the cpus allowed is a subset of the
cpus allowed for that cpuset.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com
LKML-Reference: <20090312174501.GA7821@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f76db9d..34cfd46 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1362,7 +1362,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 
 	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
+		if (!cpumask_subset(&tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
 	}
