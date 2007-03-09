Return-Path: <linux-kernel-owner+w=401wt.eu-S1767513AbXCITj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767513AbXCITj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767519AbXCITj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:39:28 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52030 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767513AbXCITj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:39:27 -0500
Date: Fri, 09 Mar 2007 13:39:25 -0600
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070309193925.B60891B8028@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

(this is a second submission -- the first was from a work area back
 porting to an older release)

When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
that have been running on that cpu.

Currently, such a task is migrated:
 1) to any cpu on the same node as the disabled cpu, which is both online
    and among that task's cpus_allowed
 2) to any cpu which is both online and among that task's cpus_allowed

But the task's cpus_allowed may have been a single cpu.

This patch would insert a preference to migrate such a task to a cpu within
its cpuset (and set its cpus_allowed to its cpuset).

With this patch, migrate the task to:
 1) to any cpu on the same node as the disabled cpu, which is both online
    and among that task's cpus_allowed
 2) to any online cpu within the task's cpuset
 3) to any cpu which is both online and among that task's cpus_allowed


Diffed against 2.6.21-rc3 (Andrew's current top of tree)

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 kernel/sched.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: morton.070123/kernel/sched.c
===================================================================
--- morton.070123.orig/kernel/sched.c
+++ morton.070123/kernel/sched.c
@@ -5170,6 +5170,12 @@ restart:
 	if (dest_cpu == NR_CPUS)
 		dest_cpu = any_online_cpu(p->cpus_allowed);
 
+	/* try to stay on the same cpuset */
+	if (dest_cpu == NR_CPUS) {
+		p->cpus_allowed = cpuset_cpus_allowed(p);
+		dest_cpu = any_online_cpu(p->cpus_allowed);
+	}
+
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu == NR_CPUS) {
 		rq = task_rq_lock(p, &flags);
