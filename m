Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0BJQc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:32:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab0BJQcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:32:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Tb7K8x4gIbqDbt1WPNa0+8PhDqLrGQnTRsnuDniGbcLq7sI+tRSB3u6o9PLbVqs8v
	Yo8xMWNwKafQmhA9FL15w==
Date: Wed, 10 Feb 2010 08:32:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 5/7 -mm] oom: replace sysctls with quick mode
In-Reply-To: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1002100229250.8001@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two VM sysctls, oom dump_tasks and oom_kill_allocating_task, were
implemented for very large systems to avoid excessively long tasklist
scans.  The former suppresses helpful diagnostic messages that are
emitted for each thread group leader that are candidates for oom kill
including their pid, uid, vm size, rss, oom_adj value, and name; this
information is very helpful to users in understanding why a particular
task was chosen for kill over others.  The latter simply kills current,
the task triggering the oom condition, instead of iterating through the
tasklist looking for the worst offender.

Both of these sysctls are combined into one for use on the aforementioned
large systems: oom_kill_quick.  This disables the now-default
oom_dump_tasks and kills current whenever the oom killer is called.

The oom killer rewrite is the perfect opportunity to combine both sysctls
into one instead of carrying around the others for years to come for
nothing else than legacy purposes.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/sysctl/vm.txt |   44 +++++-------------------------------------
 include/linux/oom.h         |    3 +-
 kernel/sysctl.c             |   13 ++---------
 mm/oom_kill.c               |    9 +++----
 4 files changed, 14 insertions(+), 55 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -43,9 +43,8 @@ Currently, these files are in /proc/sys/vm:
 - nr_pdflush_threads
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
-- oom_dump_tasks
 - oom_forkbomb_thres
-- oom_kill_allocating_task
+- oom_kill_quick
 - overcommit_memory
 - overcommit_ratio
 - page-cluster
@@ -470,27 +469,6 @@ this is causing problems for your system/application.
 
 ==============================================================
 
-oom_dump_tasks
-
-Enables a system-wide task dump (excluding kernel threads) to be
-produced when the kernel performs an OOM-killing and includes such
-information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
-name.  This is helpful to determine why the OOM killer was invoked
-and to identify the rogue task that caused it.
-
-If this is set to zero, this information is suppressed.  On very
-large systems with thousands of tasks it may not be feasible to dump
-the memory state information for each one.  Such systems should not
-be forced to incur a performance penalty in OOM conditions when the
-information may not be desired.
-
-If this is set to non-zero, this information is shown whenever the
-OOM killer actually kills a memory-hogging task.
-
-The default value is 0.
-
-==============================================================
-
 oom_forkbomb_thres
 
 This value defines how many children with a seperate address space a specific
@@ -511,22 +489,12 @@ The default value is 1000.
 
 ==============================================================
 
-oom_kill_allocating_task
-
-This enables or disables killing the OOM-triggering task in
-out-of-memory situations.
-
-If this is set to zero, the OOM killer will scan through the entire
-tasklist and select a task based on heuristics to kill.  This normally
-selects a rogue memory-hogging task that frees up a large amount of
-memory when killed.
-
-If this is set to non-zero, the OOM killer simply kills the task that
-triggered the out-of-memory condition.  This avoids the expensive
-tasklist scan.
+oom_kill_quick
 
-If panic_on_oom is selected, it takes precedence over whatever value
-is used in oom_kill_allocating_task.
+When enabled, this will always kill the task that triggered the oom killer, i.e.
+the task that attempted to allocate memory that could not be found.  It also
+suppresses the tasklist dump to the kernel log whenever the oom killer is
+called.  Typically set on systems with an extremely large number of tasks.
 
 The default value is 0.
 
diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -51,8 +51,7 @@ static inline void oom_killer_enable(void)
 }
 /* for sysctl */
 extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
+extern int sysctl_oom_kill_quick;
 extern int sysctl_oom_forkbomb_thres;
 
 #endif /* __KERNEL__*/
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -949,16 +949,9 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "oom_kill_allocating_task",
-		.data		= &sysctl_oom_kill_allocating_task,
-		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "oom_dump_tasks",
-		.data		= &sysctl_oom_dump_tasks,
-		.maxlen		= sizeof(sysctl_oom_dump_tasks),
+		.procname	= "oom_kill_quick",
+		.data		= &sysctl_oom_kill_quick,
+		.maxlen		= sizeof(sysctl_oom_kill_quick),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -32,9 +32,8 @@
 #include <linux/security.h>
 
 int sysctl_panic_on_oom;
-int sysctl_oom_kill_allocating_task;
-int sysctl_oom_dump_tasks;
 int sysctl_oom_forkbomb_thres = DEFAULT_OOM_FORKBOMB_THRES;
+int sysctl_oom_kill_quick;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
 /*
@@ -397,7 +396,7 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
-	if (sysctl_oom_dump_tasks)
+	if (!sysctl_oom_kill_quick)
 		dump_tasks(mem);
 }
 
@@ -604,9 +603,9 @@ static void __out_of_memory(gfp_t gfp_mask, int order, unsigned long totalpages,
 	struct task_struct *p;
 	unsigned int points;
 
-	if (sysctl_oom_kill_allocating_task)
+	if (sysctl_oom_kill_quick)
 		if (!oom_kill_process(current, gfp_mask, order, 0, totalpages,
-			NULL, "Out of memory (oom_kill_allocating_task)"))
+			NULL, "Out of memory (quick mode)"))
 			return;
 retry:
 	/*
