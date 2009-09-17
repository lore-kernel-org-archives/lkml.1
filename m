Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIQUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIQUz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZIQUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:55:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39819 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZIQUzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:55:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=kzvVf6z9o+3rY+5tR/9zhO656vdsdPlz5N1AEzsBwlVFOkVGbylUSZpnfIcFLis4f
	qv1YJKeBUpbfIhjE1/rDA==
Date: Thu, 17 Sep 2009 13:55:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [patch] oom: dump stack and VM state when oom killer panics
Message-ID: <alpine.DEB.1.00.0909171354570.17483@chino.kir.corp.google.com>
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
 mm/oom_kill.c |   45 +++++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -310,6 +310,23 @@ static void dump_tasks(const struct mem_cgroup *mem)
 	} while_each_thread(g, p);
 }
 
+static void dump_header(gfp_t gfp_mask, int order, struct mem_cgroup *mem)
+{
+	if (printk_ratelimit()) {
+		printk(KERN_WARNING "%s invoked oom-killer: "
+			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
+			current->comm, gfp_mask, order, current->oomkilladj);
+		task_lock(current);
+		cpuset_print_task_mems_allowed(current);
+		task_unlock(current);
+		dump_stack();
+		mem_cgroup_print_oom_info(mem, current);
+		show_mem();
+		if (sysctl_oom_dump_tasks)
+			dump_tasks(mem);
+	}
+}
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -392,20 +409,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 {
 	struct task_struct *c;
 
-	if (printk_ratelimit()) {
-		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
-			current->comm, gfp_mask, order, current->oomkilladj);
-		task_lock(current);
-		cpuset_print_task_mems_allowed(current);
-		task_unlock(current);
-		dump_stack();
-		mem_cgroup_print_oom_info(mem, current);
-		show_mem();
-		if (sysctl_oom_dump_tasks)
-			dump_tasks(mem);
-	}
-
+	dump_header(gfp_mask, order, mem);
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
@@ -540,6 +544,7 @@ retry:
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		read_unlock(&tasklist_lock);
+		dump_header(gfp_mask, order, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -605,8 +610,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom == 2)
-		panic("out of memory. Compulsory panic_on_oom is selected.\n");
+	if (sysctl_panic_on_oom == 2) {
+		dump_header(gfp_mask, order, NULL);
+		panic("Out of memory. Compulsory panic_on_oom is selected.\n");
+	}
 
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
@@ -622,8 +629,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		break;
 
 	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom)
-			panic("out of memory. panic_on_oom is selected\n");
+		if (sysctl_panic_on_oom) {
+			dump_header(gfp_mask, order, NULL);
+			panic("Out of memory. panic_on_oom is selected.\n");
+		}
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
 		__out_of_memory(gfp_mask, order);
