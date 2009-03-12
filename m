Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZCLRqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZCLRqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZCLRps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:45:48 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:38827 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbZCLRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:45:47 -0400
Date: Thu, 12 Mar 2009 23:15:01 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com
Cc: Balbir Singh <balbir@in.ibm.com>
Subject: cpuset: Check if the cpus allowed is a subset of the cpuset's cpus
	for PF_THREAD_BOUND threads
Message-ID: <20090312174501.GA7821@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1362,7 +1362,7 @@ static int cpuset_can_attach(struct cgro
 
 	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
+		if (!cpumask_subset(&tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
 	}
-- 
regards,
Dhaval
