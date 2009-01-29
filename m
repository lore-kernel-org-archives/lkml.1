Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZA2RqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZA2RqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbZA2RpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:45:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639AbZA2RpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:45:21 -0500
Date: Thu, 29 Jan 2009 09:44:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Miao Xie <miaox@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-01-28-02-17 uploaded
Message-Id: <20090129094445.67fab3e4.akpm@linux-foundation.org>
In-Reply-To: <10146.1233200604@turing-police.cc.vt.edu>
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
	<10146.1233200604@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 22:43:24 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 28 Jan 2009 02:19:09 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
> 
> breaks compiles with CONFIG_CPUSETS=n
> 
>   CC      init/main.o
> init/main.c: In function 'kernel_init':
> init/main.c:876: error: 'struct task_struct' has no member named 'mems_allowed'
> make[1]: *** [init/main.o] Error 1
> 
> Looks like it adds a reference to task->mems_allowed to kernel/main.c
> and kernel/kthreads.c and neither one is wrapped with #ifdef CONFIG_CPUSETS
> or anything.
> 

yup.  mmotm-2009-01-29-02-29 has

diff -puN include/linux/cpuset.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2 include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/include/linux/cpuset.h
@@ -79,6 +79,11 @@ extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
+static inline void set_mems_allowed(nodemask_t nodemask)
+{
+	current->mems_allowed = nodemask;
+}
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init(void) { return 0; }
@@ -163,6 +168,10 @@ static inline void cpuset_print_task_mem
 {
 }
 
+static inline void set_mems_allowed(nodemask_t nodemask)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff -puN init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2 init/main.c
--- a/init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/init/main.c
@@ -873,7 +873,7 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	current->mems_allowed = node_possible_map;
+	set_mems_allowed(node_possible_map);
 
 	cad_pid = task_pid(current);
 
diff -puN kernel/kthread.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2 kernel/kthread.c
--- a/kernel/kthread.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/kernel/kthread.c
@@ -13,6 +13,8 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/cpuset.h>
+
 #include <trace/sched.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
@@ -242,7 +244,7 @@ int kthreadd(void *unused)
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
-	current->mems_allowed = node_possible_map;
+	set_mems_allowed(node_possible_map);
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
 	for (;;) {
_

