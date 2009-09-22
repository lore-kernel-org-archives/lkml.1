Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZIVNfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZIVNfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZIVNfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:35:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:33913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZIVNf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:35:28 -0400
Date: Tue, 22 Sep 2009 13:34:43 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ying.huang@intel.com, ak@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: ying.huang@intel.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: mce: Clean up thermal throttling state tracking code
Message-ID: <tip-3967684006f30c253bc6d4a6604d1bad4a7fc672@git.kernel.org>
Git-Commit-ID: 3967684006f30c253bc6d4a6604d1bad4a7fc672
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 13:34:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3967684006f30c253bc6d4a6604d1bad4a7fc672
Gitweb:     http://git.kernel.org/tip/3967684006f30c253bc6d4a6604d1bad4a7fc672
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 22 Sep 2009 15:50:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 17:30:41 +0200

x86: mce: Clean up thermal throttling state tracking code

Instead of a mess of three separate percpu variables, consolidate
the state into a single structure.

Also clean up therm_throt_process(), use cleaner and more
understandable variable names and a clearer logic.

This, without changing the logic, makes the code more
streamlined, more readable and smaller as well:

   text	   data	    bss	    dec	    hex	filename
   1487	    169	      4	   1660	    67c	therm_throt.o.before
   1432	    176	      4	   1612	    64c	therm_throt.o.after

Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   63 ++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 63a56d1..db80b57 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -34,20 +34,30 @@
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
 
-static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
-static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
-static DEFINE_PER_CPU(bool, thermal_throttle_active);
+/*
+ * Current thermal throttling state:
+ */
+struct thermal_state {
+	bool			is_throttled;
+
+	u64			next_check;
+	unsigned long		throttle_count;
+};
+
+static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
-static atomic_t therm_throt_en		= ATOMIC_INIT(0);
+static atomic_t therm_throt_en	= ATOMIC_INIT(0);
 
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
 	static SYSDEV_ATTR(_name, 0444, therm_throt_sysdev_show_##_name, NULL)
 
 #define define_therm_throt_sysdev_show_func(name)			\
-static ssize_t therm_throt_sysdev_show_##name(struct sys_device *dev,	\
-					struct sysdev_attribute *attr,	\
-					      char *buf)		\
+									\
+static ssize_t therm_throt_sysdev_show_##name(				\
+			struct sys_device *dev,				\
+			struct sysdev_attribute *attr,			\
+			char *buf)					\
 {									\
 	unsigned int cpu = dev->id;					\
 	ssize_t ret;							\
@@ -55,7 +65,7 @@ static ssize_t therm_throt_sysdev_show_##name(struct sys_device *dev,	\
 	preempt_disable();	/* CPU hotplug */			\
 	if (cpu_online(cpu))						\
 		ret = sprintf(buf, "%lu\n",				\
-			      per_cpu(thermal_throttle_##name, cpu));	\
+			      per_cpu(thermal_state, cpu).name);	\
 	else								\
 		ret = 0;						\
 	preempt_enable();						\
@@ -63,11 +73,11 @@ static ssize_t therm_throt_sysdev_show_##name(struct sys_device *dev,	\
 	return ret;							\
 }
 
-define_therm_throt_sysdev_show_func(count);
-define_therm_throt_sysdev_one_ro(count);
+define_therm_throt_sysdev_show_func(throttle_count);
+define_therm_throt_sysdev_one_ro(throttle_count);
 
 static struct attribute *thermal_throttle_attrs[] = {
-	&attr_count.attr,
+	&attr_throttle_count.attr,
 	NULL
 };
 
@@ -93,33 +103,38 @@ static struct attribute_group thermal_throttle_attr_group = {
  *          1 : Event should be logged further, and a message has been
  *              printed to the syslog.
  */
-static int therm_throt_process(int curr)
+static int therm_throt_process(bool is_throttled)
 {
-	unsigned int cpu = smp_processor_id();
-	__u64 tmp_jiffs = get_jiffies_64();
-	bool was_throttled = __get_cpu_var(thermal_throttle_active);
-	bool is_throttled = __get_cpu_var(thermal_throttle_active) = curr;
+	struct thermal_state *state;
+	unsigned int this_cpu;
+	bool was_throttled;
+	u64 now;
+
+	this_cpu = smp_processor_id();
+	now = get_jiffies_64();
+	state = &per_cpu(thermal_state, this_cpu);
+
+	was_throttled = state->is_throttled;
+	state->is_throttled = is_throttled;
 
 	if (is_throttled)
-		__get_cpu_var(thermal_throttle_count)++;
+		state->throttle_count++;
 
 	if (!(was_throttled ^ is_throttled) &&
-	    time_before64(tmp_jiffs, __get_cpu_var(next_check)))
+			time_before64(now, state->next_check))
 		return 0;
 
-	__get_cpu_var(next_check) = tmp_jiffs + CHECK_INTERVAL;
+	state->next_check = now + CHECK_INTERVAL;
 
 	/* if we just entered the thermal event */
 	if (is_throttled) {
-		printk(KERN_CRIT "CPU%d: Temperature above threshold, "
-		       "cpu clock throttled (total events = %lu)\n",
-		       cpu, __get_cpu_var(thermal_throttle_count));
+		printk(KERN_CRIT "CPU%d: Temperature above threshold, cpu clock throttled (total events = %lu)\n", this_cpu, state->throttle_count);
 
 		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (was_throttled) {
-		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
+		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", this_cpu);
 		return 1;
 	}
 
@@ -213,7 +228,7 @@ static void intel_thermal_interrupt(void)
 	__u64 msr_val;
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
+	if (therm_throt_process((msr_val & THERM_STATUS_PROCHOT) != 0))
 		mce_log_therm_throt_event(msr_val);
 }
 
