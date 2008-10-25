Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYJYAPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYJYAPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJYAPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:15:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYJYAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:15:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=a+LIjhGU2oY3XSEpAIihaA/JOS3CJc6noNwHT4KHM2eojDujnTLnyr9uNCtPx7LmT
	3VZrdrwgUSW16OTHWzOuA==
Date: Fri, 24 Oct 2008 17:15:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: [patch] oom: print triggering task's cpuset and mems allowed
In-Reply-To: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpusets are enabled, it's necessary to print the triggering task's
set of allowable nodes so the subsequently printed meminfo can be
interpreted correctly.

We also print the task's cpuset name for informational purposes.

Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Updated version of the same patch for -mm inclusion.

 include/linux/cpuset.h |    7 +++++++
 kernel/cpuset.c        |   15 +++++++++++++++
 mm/oom_kill.c          |   22 ++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -79,6 +79,7 @@ extern void cpuset_track_online_nodes(void);
 extern int current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
+extern int cpuset_get_name(struct task_struct *p, size_t len, char *buffer);
 
 #else /* !CONFIG_CPUSETS */
 
@@ -163,6 +164,12 @@ static inline void rebuild_sched_domains(void)
 	partition_sched_domains(1, NULL, NULL);
 }
 
+static inline int cpuset_get_name(struct task_struct *p, size_t len,
+				  char *buffer)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2339,6 +2339,21 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
+/**
+ * cpuset_get_name - grabs the name of @task's cpuset
+ * @task: pointer to task_struct of some task.
+ *
+ * Description: Place @task's cpuset name in @buffer and return the
+ * number of characters copied.  Must hold task_lock(task).
+ */
+int cpuset_get_name(struct task_struct *task, size_t len, char *buffer)
+{
+        struct dentry *dentry;
+        dentry = task_cs(task)->css.cgroup->dentry;
+        return snprintf(buffer, len,
+                        dentry ? (const char *)dentry->d_name.name : "/");
+}
+
 /*
  * Collection of memory_pressure is suppressed unless
  * this flag is enabled by writing "1" to the special
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -305,6 +305,27 @@ static void dump_tasks(const struct mem_cgroup *mem)
 	} while_each_thread(g, p);
 }
 
+#ifdef CONFIG_CPUSETS
+#define BUFFER_LEN	(256)
+
+static void print_task_cpuset(struct task_struct *p)
+{
+	char buffer[BUFFER_LEN];
+
+	if (cpuset_get_name(p, BUFFER_LEN, buffer) > 0) {
+		char nodelist[BUFFER_LEN];
+
+		nodelist_scnprintf(nodelist, BUFFER_LEN, p->mems_allowed);
+		printk(KERN_ERR "%s cpuset=%s mems_allowed=%s\n",
+		       p->comm, buffer, nodelist);
+	}
+}
+#else
+static inline void print_task_cpuset(struct task_struct *p)
+{
+}
+#endif
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -391,6 +412,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		printk(KERN_WARNING "%s invoked oom-killer: "
 			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
 			current->comm, gfp_mask, order, current->oomkilladj);
+		print_task_cpuset(current);
 		dump_stack();
 		show_mem();
 		if (sysctl_oom_dump_tasks)
