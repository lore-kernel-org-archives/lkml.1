Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZCWQDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZCWQDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZCWQBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:59391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759410AbZCWQBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:01:08 -0400
Date: Mon, 23 Mar 2009 15:57:45 GMT
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, menage@google.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       menage@google.com, balbir@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090323043253.GA3306@in.ibm.com>
References: <20090323043253.GA3306@in.ibm.com>
Subject: [tip:core/percpu] cpuacct: make cpuacct hierarchy walk in cpuacct_charge() safe when rcupreempt is used -v2
Message-ID: <tip-0d8ba94c48dc07d1c47f18b24826cbafcc4d7282@git.kernel.org>
Git-Commit-ID: 0d8ba94c48dc07d1c47f18b24826cbafcc4d7282
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d8ba94c48dc07d1c47f18b24826cbafcc4d7282
Gitweb:     http://git.kernel.org/tip/0d8ba94c48dc07d1c47f18b24826cbafcc4d7282
Author:     Bharata B Rao <bharata@linux.vnet.ibm.com>
AuthorDate: Mon, 23 Mar 2009 10:02:53 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:55:26 +0100

cpuacct: make cpuacct hierarchy walk in cpuacct_charge() safe when rcupreempt is used -v2

Impact: fix cgroups race under rcu-preempt

cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
This can race with the task's movement between cgroups. This race
can cause an access to freed ca pointer in cpuacct_charge() or access
to invalid cgroups pointer of the task. This will not happen with rcu or
tree rcu as cpuacct_charge() is called with preemption disabled. However if
rcupreempt is used, the race is seen. Thanks to Li Zefan for explaining this.

Fix this race by explicitly protecting ca and the hierarchy walk with
rcu_read_lock().

Changes for v2:

 - Update patch descrition (as per Li Zefan's review comments).

 - Remove comments in cpuacct_charge() which explained why rcu_read_lock()
   was needed (as per Peter Zijlstra's review comments).

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
LKML-Reference: <20090323043253.GA3306@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 61e6356..ebadc7a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9597,6 +9597,8 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 		return;
 
 	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
 	ca = task_ca(tsk);
 
 	do {
@@ -9604,6 +9606,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 		*cpuusage += cputime;
 		ca = ca->parent;
 	} while (ca);
+	rcu_read_unlock();
 }
 
 struct cgroup_subsys cpuacct_subsys = {
