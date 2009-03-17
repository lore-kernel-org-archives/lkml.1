Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZCQGRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZCQGRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZCQGRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:17:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49618 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZCQGRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:17:32 -0400
Date: Tue, 17 Mar 2009 11:47:54 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090317061754.GD3314@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuacct: Make cpuacct hierarchy walk in cpuacct_charge() safe when
	rcupreempt is used.

cpuacct_charge() obtains task's ca and does a hierarchy walk upwards.
This can race with the task's movement between cgroups. This race
can cause an access to freed ca pointer in cpuacct_charge(). This will not
happen with rcu or tree rcu as cpuacct_charge() is called with preemption
disabled. However if rcupreempt is used, the race still exists. Thanks to
Li Zefan for explaining this.

Fix this race by explicitly protecting ca and the hierarchy walk with
rcu_read_lock().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9891,6 +9891,13 @@ static void cpuacct_charge(struct task_s
 		return;
 
 	cpu = task_cpu(tsk);
+
+	/*
+	 * preemption is already disabled here, but to be safe with
+	 * rcupreempt, take rcu_read_lock(). This protects ca and
+	 * hence the hierarchy walk.
+	 */
+	rcu_read_lock();
 	ca = task_ca(tsk);
 
 	do {
@@ -9898,6 +9905,7 @@ static void cpuacct_charge(struct task_s
 		*cpuusage += cputime;
 		ca = ca->parent;
 	} while (ca);
+	rcu_read_unlock();
 }
 
 struct cgroup_subsys cpuacct_subsys = {
