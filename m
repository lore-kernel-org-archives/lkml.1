Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbYJYWYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbYJYWYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJYWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:24:13 -0400
Received: from ozlabs.org ([203.10.76.45]:39136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbYJYWYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:24:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL] module, param and stop_machine patches
Date: Sun, 26 Oct 2008 09:24:08 +1100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
References: <200810221005.59874.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810260924.09479.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 October 2008 08:17:38 Linus Torvalds wrote:
> On Wed, 22 Oct 2008, Rusty Russell wrote:
> > Heiko Carstens (4):
> >       Call init_workqueues before pre smp initcalls.
>
> This one actually causes a regression for me on one of my machines.

Thanks, Heiko tracked this down; he's probably sleeping now but Hugh and Walt
reported this fixes it for them and it makes sense.

---
Subject: commit a802dd0e breaks console keyboard input
Date: Sat, 25 Oct 2008 16:16:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>

The patch below moves the init call to its old place but makes the
stop_machine initialization happen later. I added a BUG_ON to catch possible
early calls, but there shouldn't be any. I think the patch should solve
the regression you are seeing. Could you give it a try please?
The patch applies on top of latest Linus' git tree.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/stop_machine.h |    6 ++++++
 init/main.c                  |    5 +++--
 kernel/stop_machine.c        |    9 ++++++---
 3 files changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/stop_machine.h
===================================================================
--- linux-2.6.orig/include/linux/stop_machine.h
+++ linux-2.6/include/linux/stop_machine.h
@@ -35,6 +35,9 @@ int stop_machine(int (*fn)(void *), void
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+
+void stop_machine_init(void);
+
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -46,5 +49,8 @@ static inline int stop_machine(int (*fn)
 	local_irq_enable();
 	return ret;
 }
+
+static inline void stop_machine_init(void) { }
+
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -38,6 +38,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
 #include <linux/writeback.h>
+#include <linux/stop_machine.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/cgroup.h>
@@ -768,6 +769,8 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
+	init_workqueues();
+	stop_machine_init();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -851,8 +854,6 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
-	init_workqueues();
-
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -43,6 +43,7 @@ static struct workqueue_struct *stop_mac
 static struct stop_machine_data active, idle;
 static const cpumask_t *active_cpus;
 static void *stop_machine_work;
+static int stop_machine_initialized;
 
 static void set_state(enum stopmachine_state newstate)
 {
@@ -114,6 +115,7 @@ int __stop_machine(int (*fn)(void *), vo
 	struct work_struct *sm_work;
 	int i;
 
+	BUG_ON(!stop_machine_initialized);
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	num_threads = num_online_cpus();
@@ -154,10 +156,11 @@ int stop_machine(int (*fn)(void *), void
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
-static int __init stop_machine_init(void)
+void __init stop_machine_init(void)
 {
 	stop_machine_wq = create_rt_workqueue("kstop");
+	BUG_ON(!stop_machine_wq);
 	stop_machine_work = alloc_percpu(struct work_struct);
-	return 0;
+	BUG_ON(!stop_machine_work);
+	stop_machine_initialized = 1;
 }
-early_initcall(stop_machine_init);




