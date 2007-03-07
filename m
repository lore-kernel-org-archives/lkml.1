Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXCGOYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXCGOYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965551AbXCGOYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:24:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37156 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965529AbXCGOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:24:47 -0500
Date: Wed, 07 Mar 2007 08:24:44 -0600
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <45EECB2C.mailxEK515UYJW@eag09.americas.sgi.com>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

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


Diffed against 2.6.16.37

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 kernel/sched.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4602,6 +4602,12 @@ static void move_task_off_dead_cpu(int d
 	if (dest_cpu == NR_CPUS)
 		dest_cpu = any_online_cpu(tsk->cpus_allowed);
 
+	/* try to stay on the same cpuset */
+	if (dest_cpu == NR_CPUS) {
+		tsk->cpus_allowed = cpuset_cpus_allowed(tsk);
+		dest_cpu = any_online_cpu(tsk->cpus_allowed);
+	}
+
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu == NR_CPUS) {
 		cpus_setall(tsk->cpus_allowed);
