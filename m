Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYJXLHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYJXLHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYJXLHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:07:47 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50416 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYJXLHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:07:46 -0400
Date: Fri, 24 Oct 2008 13:07:42 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: walt <w41ter@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: commit a802dd0e breaks console keyboard input
Message-ID: <20081024110742.GD4620@osiris.boeblingen.de.ibm.com>
References: <49011234.7090902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49011234.7090902@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 05:09:24PM -0700, walt wrote:
> Hi team,
>
> commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Mon Oct 13 23:50:08 2008 +0200
>
>     Call init_workqueues before pre smp initcalls.
>
> This commit causes the console login prompt to ignore my keystrokes
> so I'm unable to log in (though ssh works fine).  Oddly, if I hit
> ctrl-alt-delete the machine does reboot, but no other keystrokes
> appear on the screen or have any effect that I can detect.
>
> No surprise that this problem appears only on my dual-core amd64
> machine, while the k7 single processor machine works normally.
>
> I've not seen anyone else complaining on the linux list, so maybe
> this is a BIOS bug on the affected machine?  It's an ECS mobo with
> a GeForce6100PM-M2 chipset, and I use a ps/2 keyboard.

Could you try the patch below and see if it makes any difference?
Thanks!

---
 include/linux/stop_machine.h |   16 +++++++++++-----
 init/main.c                  |    3 +--
 kernel/stop_machine.c        |    8 ++++++++
 3 files changed, 20 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/stop_machine.h
===================================================================
--- linux-2.6.orig/include/linux/stop_machine.h
+++ linux-2.6/include/linux/stop_machine.h
@@ -8,6 +8,16 @@
 #include <linux/cpumask.h>
 #include <asm/system.h>
 
+static inline int stop_machine_simple(int (*fn)(void *), void *data,
+				      const cpumask_t *cpus)
+{
+	int ret;
+	local_irq_disable();
+	ret = fn(data);
+	local_irq_enable();
+	return ret;
+}
+
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
 /**
@@ -40,11 +50,7 @@ int __stop_machine(int (*fn)(void *), vo
 static inline int stop_machine(int (*fn)(void *), void *data,
 			       const cpumask_t *cpus)
 {
-	int ret;
-	local_irq_disable();
-	ret = fn(data);
-	local_irq_enable();
-	return ret;
+	return stop_machine_simple(fn, data, cpus);
 }
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -43,6 +43,7 @@ static struct workqueue_struct *stop_mac
 static struct stop_machine_data active, idle;
 static const cpumask_t *active_cpus;
 static void *stop_machine_work;
+static int sm_initialized;
 
 static void set_state(enum stopmachine_state newstate)
 {
@@ -114,6 +115,10 @@ int __stop_machine(int (*fn)(void *), vo
 	struct work_struct *sm_work;
 	int i;
 
+	WARN_ON_ONCE(!sm_initialized);
+	if (num_online_cpus() == 1)
+		return stop_machine_simple(fn, data, cpus);
+
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	num_threads = num_online_cpus();
@@ -157,7 +162,10 @@ EXPORT_SYMBOL_GPL(stop_machine);
 static int __init stop_machine_init(void)
 {
 	stop_machine_wq = create_rt_workqueue("kstop");
+	BUG_ON(!stop_machine_wq);
 	stop_machine_work = alloc_percpu(struct work_struct);
+	BUG_ON(!stop_machine_work);
+	sm_initialized = 1;
 	return 0;
 }
 early_initcall(stop_machine_init);
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -851,10 +851,9 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
-	init_workqueues();
-
 	smp_prepare_cpus(setup_max_cpus);
 
+	init_workqueues();
 	do_pre_smp_initcalls();
 	start_boot_trace();
 
