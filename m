Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYJZIQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYJZIQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 04:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYJZIQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 04:16:24 -0400
Received: from ozlabs.org ([203.10.76.45]:42840 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYJZIQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 04:16:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL] module, param and stop_machine patches
Date: Sun, 26 Oct 2008 19:16:16 +1100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
References: <200810221005.59874.rusty@rustcorp.com.au> <200810260924.09479.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261916.17311.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 October 2008 09:33:43 Linus Torvalds wrote:
> On Sun, 26 Oct 2008, Rusty Russell wrote:
> > Thanks, Heiko tracked this down; he's probably sleeping now but Hugh and
> > Walt reported this fixes it for them and it makes sense.
>
> I'm not seeing any "tracked it down".

He tracked it down to moving init_workqueues() too early, so he moved that
back.

> And it then mixes things up with 'stop_machine_init()' mess. Why does that
> need to run so early?

The S/390 guys want to run it stop_machine v. early, so when Heiko introduced
stop_machine_init() he made it an early_initcall().

> IOW, I don't think that patch is anything but a "hey, test if it works
> with this". None of the changes or the problems are explained.

Indeed.

Turns out it's the cpu_online_map difference.  If init_workqueues() is called
too early, only the boot cpu is set.  We then only create_workqueue_thread()
for the boot cpu.

If CONFIG_HOTPLUG_CPU=y, it's fine since the hotplug callback will create the
workqueue threads for the other cpus as they come up.  Without it, the kevent
workqueues on non-boot cpus don't get processed.

Still boots for me, but was a bit sick (varying, but no keyboard was one
symptom).

> Nor do I see a sign-off from Heiko on it.

I thought mine would be sufficient since we both work for IBM?

> I also don't want to see more BUG_ON()'s there. Make them warnings or
> something.

OK, I just killed them.  It'll crash anyway.

Rusty.

Subject: Fix boot problems caused by moving init_workqueues()
Date: Sat, 25 Oct 2008 16:16:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>

The patch below moves the init_workqueues() call to its old place but
makes the stop_machine initialization happen later (but still before
core_initcalls).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/stop_machine.h |    6 ++++++
 init/main.c                  |    5 +++--
 kernel/stop_machine.c        |    9 ++++++---
 3 files changed, 15 insertions(+), 5 deletions(-)

diff -r 2b5f764088ee include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Sun Oct 26 18:50:23 2008 +1100
+++ b/include/linux/stop_machine.h	Sun Oct 26 19:13:04 2008 +1100
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
diff -r 2b5f764088ee init/main.c
--- a/init/main.c	Sun Oct 26 18:50:23 2008 +1100
+++ b/init/main.c	Sun Oct 26 19:13:04 2008 +1100
@@ -38,6 +38,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
 #include <linux/writeback.h>
+#include <linux/stop_machine.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/cgroup.h>
@@ -767,6 +768,8 @@ static void __init do_basic_setup(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
+	init_workqueues();
+	stop_machine_init();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -850,8 +853,6 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
-	init_workqueues();
-
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
diff -r 2b5f764088ee kernel/stop_machine.c
--- a/kernel/stop_machine.c	Sun Oct 26 18:50:23 2008 +1100
+++ b/kernel/stop_machine.c	Sun Oct 26 19:13:04 2008 +1100
@@ -154,10 +154,8 @@ int stop_machine(int (*fn)(void *), void
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
-static int __init stop_machine_init(void)
+void __init stop_machine_init(void)
 {
 	stop_machine_wq = create_rt_workqueue("kstop");
 	stop_machine_work = alloc_percpu(struct work_struct);
-	return 0;
 }
-early_initcall(stop_machine_init);
