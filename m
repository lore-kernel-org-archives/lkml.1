Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYJ1QKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYJ1QKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYJ1QIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:08:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61004 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYJ1QIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:08:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=PFjodiC/oQI8Q/1xoWTtTVZ4BrewDWx9CGUVXQf0PxaYW+MHDNRNp9SkujjxBW0rB
	HW95KRvRgWXMRTiB7RJ/A==
Date: Tue, 28 Oct 2008 09:08:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: print triggering task's cpuset and mems allowed
In-Reply-To: <20081027174136.c97687c7.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810280222090.31219@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com> <alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com> <20081027174136.c97687c7.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Andrew Morton wrote:

> We can call the oom-killer at very very deep nesting levels, and adding
> another 512 bytes of stack consuption to that call path is really
> risky.  Perhaps use statically allocated buffers protected by a local
> spinlock?
> 

That sounds appropriate.  I've also moved all the cpuset-specific code 
over to kernel/cpuset.c where it belongs.

> Also, 256 bytes might be overkill for storing the cpuset's name?
> 
> Also, it's Just Wrong that this code has to hardwire private knowledge
> of the max possible length of a cpuset name and of the
> nodelist_scnprintf() return string.  These things should be controlled
> by a single #define in a shared header file.
> 

The max length of a cpuset name is dependant on the dentry, but it's of no 
concern here: we're more interested in only printing a single line with 
the pertinent information and truncate it as necessary.

The same is true of the nodelist, since it's possible for this string to 
be 2000 characters in length on architectures such as ia64 where 
CONFIG_NODES_SHIFT is >= 10.  

We must truncate at some point, so 256 bytes was an arbitrary length.

How about this updated version?



oom: print triggering task's cpuset and mems allowed

When cpusets are enabled, it's necessary to print the triggering task's
set of allowable nodes so the subsequently printed meminfo can be
interpreted correctly.

We also print the task's cpuset name for informational purposes.

Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/cpuset.h |    6 ++++++
 kernel/cpuset.c        |   34 ++++++++++++++++++++++++++++++++++
 mm/oom_kill.c          |    1 +
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -80,6 +80,8 @@ extern int current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
 
+extern void cpuset_print_task_mems_allowed(struct task_struct *p);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
@@ -163,6 +165,10 @@ static inline void rebuild_sched_domains(void)
 	partition_sched_domains(1, NULL, NULL);
 }
 
+static inline void cpuset_print_task_mems_allowed(struct task_struct *p)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -239,6 +239,17 @@ static struct cpuset top_cpuset = {
 static DEFINE_MUTEX(callback_mutex);
 
 /*
+ * cpuset_buffer_lock protects both the cpuset_name and cpuset_nodelist
+ * buffers.  They are statically allocated to prevent using excess stack
+ * when calling cpuset_print_task_mems_allowed().
+ */
+#define CPUSET_NAME_LEN		(128)
+#define	CPUSET_NODELIST_LEN	(256)
+static char cpuset_name[CPUSET_NAME_LEN];
+static char cpuset_nodelist[CPUSET_NODELIST_LEN];
+static DEFINE_SPINLOCK(cpuset_buffer_lock);
+
+/*
  * This is ugly, but preserves the userspace API for existing cpuset
  * users. If someone tries to mount the "cpuset" filesystem, we
  * silently switch it to mount "cgroup" instead
@@ -2339,6 +2350,29 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
+/**
+ * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
+ * @task: pointer to task_struct of some task.
+ *
+ * Description: Prints @task's name, cpuset name, and cached copy of its
+ * mems_allowed to the kernel log.  Must hold task_lock(task) to allow
+ * dereferencing task_cs(task).
+ */
+void cpuset_print_task_mems_allowed(struct task_struct *tsk)
+{
+	struct dentry *dentry;
+
+	dentry = task_cs(tsk)->css.cgroup->dentry;
+	spin_lock(&cpuset_buffer_lock);
+	snprintf(cpuset_name, CPUSET_NAME_LEN,
+		 dentry ? (const char *)dentry->d_name.name : "/");
+	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
+			   tsk->mems_allowed);
+	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
+	       tsk->comm, cpuset_name, cpuset_nodelist);
+	spin_unlock(&cpuset_buffer_lock);
+}
+
 /*
  * Collection of memory_pressure is suppressed unless
  * this flag is enabled by writing "1" to the special
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -391,6 +391,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		printk(KERN_WARNING "%s invoked oom-killer: "
 			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
 			current->comm, gfp_mask, order, current->oomkilladj);
+		cpuset_print_task_mems_allowed(current);
 		dump_stack();
 		show_mem();
 		if (sysctl_oom_dump_tasks)
