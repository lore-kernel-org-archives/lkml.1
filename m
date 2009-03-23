Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZCWEcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZCWEcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCWEcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:32:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52683 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZCWEcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:32:41 -0400
Date: Mon, 23 Mar 2009 10:02:53 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used -v2
Message-ID: <20090323043253.GA3306@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the v2 of the fix to cpuacct hierarchy walk with the appropriate
tags in the patch. This applies against the latest -tip tree.

Changes for v2:
- Update patch descrition (as per Li Zefan's review comments).
- Remove comments in cpuacct_charge() which explained why rcu_read_lock()
  was needed (as per Peter Zijlstra's review comments).

cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
	rcupreempt is used.

cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
This can race with the task's movement between cgroups. This race
can cause an access to freed ca pointer in cpuacct_charge() or access
to invalid cgroups pointer of the task. This will not happen with rcu or
tree rcu as cpuacct_charge() is called with preemption disabled. However if
rcupreempt is used, the race is seen. Thanks to Li Zefan for explaining this.

Fix this race by explicitly protecting ca and the hierarchy walk with
rcu_read_lock().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Paul Menage <menage@google.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9888,6 +9888,8 @@ static void cpuacct_charge(struct task_s
 		return;
 
 	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
 	ca = task_ca(tsk);
 
 	do {
@@ -9895,6 +9897,7 @@ static void cpuacct_charge(struct task_s
 		*cpuusage += cputime;
 		ca = ca->parent;
 	} while (ca);
+	rcu_read_unlock();
 }
 
 struct cgroup_subsys cpuacct_subsys = {
