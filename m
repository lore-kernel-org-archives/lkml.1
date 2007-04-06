Return-Path: <linux-kernel-owner+w=401wt.eu-S1767511AbXDFCfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767511AbXDFCfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767512AbXDFCfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:35:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46798 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767511AbXDFCfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:35:12 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org
Subject: Re: Questions about porting perfmon2 to powerpc
Date: Thu, 5 Apr 2007 21:35:04 -0500
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Carl Love <carll@us.ibm.com>
References: <200704051455.34600.kevcorry@us.ibm.com> <200704052208.01753.arnd@arndb.de> <200704051532.08775.kevcorry@us.ibm.com>
In-Reply-To: <200704051532.08775.kevcorry@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704052135.05043.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu April 5 2007 3:32 pm, Kevin Corry wrote:
> On Thu April 5 2007 3:08 pm, Arnd Bergmann wrote:
> > On Thursday 05 April 2007, Kevin Corry wrote:
> > > First, the stock 2.6.20 kernel has a prototype in include/linux/smp.h
> > > for a function called smp_call_function_single(). However, this routine
> > > is only implemented on i386, x86_64, ia64, and mips. Perfmon2
> > > apparently needs to call this to run a function on a specific CPU.
> > > Powerpc provides an smp_call_function() routine to run a function on
> > > all active CPUs, so I used that as a basis to add an
> > > smp_call_function_single() routine. I've included the patch below and
> > > was wondering if it looked like a sane approach.
> >
> > The function itself looks good, but since it's very similar to the
> > existing smp_call_function(), you should probably try to share some of
> > the code, e.g. by making a helper function that gets an argument to
> > decide whether to run on a specific CPU or on all CPUs.
>
> Ok. I'll see what I can come up with and post another patch today or
> tomorrow.

Here's a new version that adds smp_call_function_single(), and moves the
code that's shared with smp_call_function() to __smp_call_function().

Thanks,
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/


Add an smp_call_function_single() to the powerpc architecture. Since this
is very similar to the existing smp_call_function() routine, the common
portions have been split out into __smp_call_function(). Since the
spin_lock(&call_lock) was moved to __smp_call_function(),
smp_call_function() now explicitly calls preempt_disable() before getting
the count of online CPUs.

Signed-off-by: Kevin Corry <kevcorry@us.ibm.com>

Index: linux-2.6.20-arnd3-perfmon/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.20-arnd3-perfmon.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6.20-arnd3-perfmon/arch/powerpc/kernel/smp.c
@@ -198,26 +198,11 @@ static struct call_data_struct {
 /* delay of at least 8 seconds */
 #define SMP_CALL_TIMEOUT	8
 
-/*
- * This function sends a 'generic call function' IPI to all other CPUs
- * in the system.
- *
- * [SUMMARY] Run a function on all other CPUs.
- * <func> The function to run. This must be fast and non-blocking.
- * <info> An arbitrary pointer to pass to the function.
- * <nonatomic> currently unused.
- * <wait> If true, wait (atomically) until function has completed on other CPUs.
- * [RETURNS] 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-		       int wait)
-{ 
+static int __smp_call_function(void (*func)(void *info), void *info,
+			       int wait, int target_cpu, int num_cpus)
+{
 	struct call_data_struct data;
-	int ret = -1, cpus;
+	int ret = -1;
 	u64 timeout;
 
 	/* Can deadlock when called with interrupts disabled */
@@ -234,40 +219,33 @@ int smp_call_function (void (*func) (voi
 		atomic_set(&data.finished, 0);
 
 	spin_lock(&call_lock);
-	/* Must grab online cpu count with preempt disabled, otherwise
-	 * it can change. */
-	cpus = num_online_cpus() - 1;
-	if (!cpus) {
-		ret = 0;
-		goto out;
-	}
 
 	call_data = &data;
 	smp_wmb();
 	/* Send a message to all other CPUs and wait for them to respond */
-	smp_ops->message_pass(MSG_ALL_BUT_SELF, PPC_MSG_CALL_FUNCTION);
+	smp_ops->message_pass(target_cpu, PPC_MSG_CALL_FUNCTION);
 
 	timeout = get_tb() + (u64) SMP_CALL_TIMEOUT * tb_ticks_per_sec;
 
 	/* Wait for response */
-	while (atomic_read(&data.started) != cpus) {
+	while (atomic_read(&data.started) != num_cpus) {
 		HMT_low();
 		if (get_tb() >= timeout) {
-			printk("smp_call_function on cpu %d: other cpus not "
-			       "responding (%d)\n", smp_processor_id(),
-			       atomic_read(&data.started));
+			printk("%s on cpu %d: other cpus not "
+			       "responding (%d)\n", __FUNCTION__,
+			       smp_processor_id(), atomic_read(&data.started));
 			debugger(NULL);
 			goto out;
 		}
 	}
 
 	if (wait) {
-		while (atomic_read(&data.finished) != cpus) {
+		while (atomic_read(&data.finished) != num_cpus) {
 			HMT_low();
 			if (get_tb() >= timeout) {
-				printk("smp_call_function on cpu %d: other "
-				       "cpus not finishing (%d/%d)\n",
-				       smp_processor_id(),
+				printk("%s on cpu %d: other cpus "
+				       "not finishing (%d/%d)\n",
+				       __FUNCTION__, smp_processor_id(),
 				       atomic_read(&data.finished),
 				       atomic_read(&data.started));
 				debugger(NULL);
@@ -285,8 +263,74 @@ int smp_call_function (void (*func) (voi
 	return ret;
 }
 
+/*
+ * This function sends a 'generic call function' IPI to all other CPUs
+ * in the system.
+ *
+ * [SUMMARY] Run a function on all other CPUs.
+ * <func> The function to run. This must be fast and non-blocking.
+ * <info> An arbitrary pointer to pass to the function.
+ * <nonatomic> currently unused.
+ * <wait> If true, wait (atomically) until function has completed on other CPUs.
+ * [RETURNS] 0 on success, else a negative status code. Does not return until
+ * remote CPUs are nearly ready to execute <<func>> or are or have executed.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
+		       int wait)
+{
+	int num_cpus, ret = 0;
+
+	/* Must grab online cpu count with preempt disabled, otherwise
+	 * it can change. */
+	preempt_disable();
+	num_cpus = num_online_cpus() - 1;
+	if (num_cpus) {
+		ret = __smp_call_function(func, info, wait,
+					  MSG_ALL_BUT_SELF, num_cpus);
+	}
+	preempt_enable();
+	return ret;
+}
+
 EXPORT_SYMBOL(smp_call_function);
 
+/*
+ * This function sends a 'generic call function' IPI to the specified CPU.
+ *
+ * [SUMMARY] Run a function on the specified CPUs.
+ * <cpuid> The CPU to run the function on.
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
+	int ret;
+
+	/* Prevent preemption and reschedule on another processor */
+	if (get_cpu() == cpuid) {
+		printk(KERN_INFO "%s: trying to call self\n", __FUNCTION__);
+		ret = -EBUSY;
+	} else
+		ret = __smp_call_function(func, info, wait, cpuid, 1);
+
+	put_cpu();
+	return ret;
+}
+
+EXPORT_SYMBOL(smp_call_function_single);
+
 void smp_call_function_interrupt(void)
 {
 	void (*func) (void *info);
