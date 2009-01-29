Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZA2JpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZA2JpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZA2Joz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:44:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbZA2Joy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:44:54 -0500
Date: Thu, 29 Jan 2009 01:44:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       Miao Xie <miaox@cn.fujitsu.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH -mmotm] fix more cpuset breakage
Message-Id: <20090129014435.b50390a3.akpm@linux-foundation.org>
In-Reply-To: <49812168.7070708@oracle.com>
References: <200901290142.n0T1gq02009439@imap1.linux-foundation.org>
	<49812168.7070708@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 19:24:24 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Not everyone uses cpusets, so fix the b0rked build (part 2):
> 
> kernel/kthread.c:243: error: 'struct task_struct' has no member named 'mems_allowed'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  kernel/kthread.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- mmotm-2009-0128-1742.orig/kernel/kthread.c
> +++ mmotm-2009-0128-1742/kernel/kthread.c
> @@ -240,7 +240,9 @@ int kthreadd(void *unused)
>  	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
>  	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
>  
> +#ifdef CONFIG_CPUSETS
>  	current->mems_allowed = node_possible_map;
> +#endif
>  	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
>  
>  	for (;;) {

OK, enough ifdefs.  I did this:

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
--- a/init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/init/main.c
@@ -873,7 +873,7 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	current->mems_allowed = node_possible_map;
+	set_mems_allowed(node_possible_map);
 
 	cad_pid = task_pid(current);
 
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


Also, I think we're still waiting for someone to tell us why
kernel_init() (at least) needed that chantge?

And why did kthreadd need changing, come to that?

