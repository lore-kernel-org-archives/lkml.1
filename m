Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZJAVcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZJAVcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZJAVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:32:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZJAVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:32:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=TN8kl/WewDYRkbMTbQsSyPhoXUsUtpeexFUcgLKi4RXsD+PGvqEb2e1cCffYZbm2V
	QrEl28pkN5sJXo3vCksZw==
Date: Thu, 1 Oct 2009 14:32:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [patch v2] oom: dump stack and VM state when oom killer panics
Message-ID: <alpine.DEB.1.00.0910011432001.6631@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oom killer header, including information such as the allocation order
and gfp mask, current's cpuset and memory controller, call trace, and VM
state information is currently only shown when the oom killer has
selected a task to kill.

This information is omitted, however, when the oom killer panics either
because of panic_on_oom sysctl settings or when no killable task was
found.  It is still relevant to know crucial pieces of information such
as the allocation order and VM state when diagnosing such issues,
especially at boot.

This patch displays the oom killer header whenever it panics so that bug
reports can include pertinent information to debug the issue, if
possible.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -337,6 +337,21 @@ static void dump_tasks(const struct mem_cgroup *mem)
 	} while_each_thread(g, p);
 }
 
+static void dump_header(gfp_t gfp_mask, int order, struct mem_cgroup *mem)
+{
+	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
+		"oom_adj=%d\n",
+		current->comm, gfp_mask, order, current->signal->oom_adj);
+	task_lock(current);
+	cpuset_print_task_mems_allowed(current);
+	task_unlock(current);
+	dump_stack();
+	mem_cgroup_print_oom_info(mem, current);
+	show_mem();
+	if (sysctl_oom_dump_tasks)
+		dump_tasks(mem);
+}
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -395,20 +410,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 {
 	struct task_struct *c;
 
-	if (printk_ratelimit()) {
-		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
-			current->comm, gfp_mask, order,
-			current->signal->oom_adj);
-		task_lock(current);
-		cpuset_print_task_mems_allowed(current);
-		task_unlock(current);
-		dump_stack();
-		mem_cgroup_print_oom_info(mem, current);
-		show_mem();
-		if (sysctl_oom_dump_tasks)
-			dump_tasks(mem);
-	}
+	if (printk_ratelimit())
+		dump_header(gfp_mask, order, mem);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -544,6 +547,7 @@ retry:
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		read_unlock(&tasklist_lock);
+		dump_header(gfp_mask, order, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -609,8 +613,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom == 2)
+	if (sysctl_panic_on_oom == 2) {
+		dump_header(gfp_mask, order, NULL);
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
+	}
 
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
@@ -626,8 +632,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		break;
 
 	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom)
+		if (sysctl_panic_on_oom) {
+			dump_header(gfp_mask, order, NULL);
 			panic("out of memory. panic_on_oom is selected\n");
+		}
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
 		__out_of_memory(gfp_mask, order);
