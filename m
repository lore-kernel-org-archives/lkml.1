Return-Path: <linux-kernel-owner+w=401wt.eu-S1767259AbXDETzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767259AbXDETzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767273AbXDETzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:55:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45987 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767259AbXDETzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:55:48 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: linuxppc-dev@ozlabs.org
Subject: Questions about porting perfmon2 to powerpc
Date: Thu, 5 Apr 2007 14:55:33 -0500
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Carl Love <carll@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051455.34600.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Carl Love and I have been working on getting the latest perfmon2 patches 
(http://perfmon2.sourceforge.net/) working on Cell, and on powerpc in 
general. We've come up with some powerpc-specific questions and we're hoping 
to get some opinions from the powerpc kernel developers.

First, the stock 2.6.20 kernel has a prototype in include/linux/smp.h for a 
function called smp_call_function_single(). However, this routine is only 
implemented on i386, x86_64, ia64, and mips. Perfmon2 apparently needs to 
call this to run a function on a specific CPU. Powerpc provides an 
smp_call_function() routine to run a function on all active CPUs, so I used 
that as a basis to add an smp_call_function_single() routine. I've included 
the patch below and was wondering if it looked like a sane approach.

Next, we ran into a problem related to Perfmon2 initialization and sysfs. The 
problem turned out to be that the powerpc version of topology_init() is 
defined as an __initcall() routine, but Perfmon2's initialization is done as 
a subsys_initcall() routine. Thus, Perfmon2 tries to initialize its sysfs 
information before some of the powerpc cpu information has been initialized. 
However, on all other architectures, topology_init() is defined as a 
subsys_initcall() routine, so this problem was not seen on any other 
platforms. Changing the powerpc version of topology_init() to a 
subsys_initcall() seems to have fixed the bug. However, I'm not sure if that 
is going to cause problems elsewhere in the powerpc code. I've included the 
patch below (after the smp-call-function-single patch). Does anyone know if 
this change is safe, or if there was a specific reason that topology_init() 
was left as an __initcall() on powerpc?

Thanks for your help!
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/


===================================================================
Add an smp_call_function_single() to the powerpc architecture. This is mostly
a copy of smp_call_function(), but with minor modifications to call only the
specified CPU.

Index: linux-2.6.20-perfmon/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.20-perfmon.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6.20-perfmon/arch/powerpc/kernel/smp.c
@@ -287,6 +287,92 @@ int smp_call_function (void (*func) (voi
 
 EXPORT_SYMBOL(smp_call_function);
 
+/*
+ * This function sends a 'generic call function' IPI to the specified CPU.
+ *
+ * [SUMMARY] Run a function on the specified CPUs.
+ * <func> The function to run. This must be fast and non-blocking.
+ * <info> An arbitrary pointer to pass to the function.
+ * <nonatomic> currently unused.
+ * <wait> If true, wait (atomically) until function has completed on the
+ * other CPU.
+ * [RETURNS] 0 on success, else a negative status code. Does not return until
+ * remote CPU is nearly ready to execute <<func>> or are or has executed.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function_single(int cpuid, void (*func)(void *info), void *info,
+			     int nonatomic, int wait)
+{
+	struct call_data_struct data;
+	int ret = -1, cpus = 1, me;
+	u64 timeout;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	if (unlikely(smp_ops == NULL))
+		return -1;
+
+	me = get_cpu(); /* prevent preemption and reschedule on another processor */
+	if (cpuid == me) {
+		printk(KERN_INFO "%s: trying to call self\n", __FUNCTION__);
+		put_cpu();
+		return -EBUSY;
+	}
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	spin_lock(&call_lock);
+
+	call_data = &data;
+	smp_wmb();
+	/* Send a message to the specified CPU and wait for it to respond */
+	smp_ops->message_pass(cpuid, PPC_MSG_CALL_FUNCTION);
+
+	timeout = get_tb() + (u64) SMP_CALL_TIMEOUT * tb_ticks_per_sec;
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus) {
+		HMT_low();
+		if (get_tb() >= timeout) {
+			printk("%s on cpu %d: cpu %d not responding\n",
+			       __FUNCTION__, smp_processor_id(), cpuid);
+			debugger(NULL);
+			goto out;
+		}
+	}
+
+	if (wait) {
+		while (atomic_read(&data.finished) != cpus) {
+			HMT_low();
+			if (get_tb() >= timeout) {
+				printk("%s on cpu %d: cpu %d not finishing\n",
+				       __FUNCTION__, smp_processor_id(), cpuid);
+				debugger(NULL);
+				goto out;
+			}
+		}
+	}
+
+	ret = 0;
+
+ out:
+	call_data = NULL;
+	HMT_medium();
+	spin_unlock(&call_lock);
+	put_cpu();
+	return ret;
+}
+
+EXPORT_SYMBOL(smp_call_function_single);
+
 void smp_call_function_interrupt(void)
 {
 	void (*func) (void *info);

===================================================================
Change the powerpc version of topology_init() from an __initcall to
a subsys_initcall to match all other architectures.
 
Index: linux-2.6.20-perfmon/arch/powerpc/kernel/sysfs.c
===================================================================
--- linux-2.6.20-perfmon.orig/arch/powerpc/kernel/sysfs.c
+++ linux-2.6.20-perfmon/arch/powerpc/kernel/sysfs.c
@@ -455,4 +455,4 @@ static int __init topology_init(void)
 
 	return 0;
 }
-__initcall(topology_init);
+subsys_initcall(topology_init);

===================================================================
