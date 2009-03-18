Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZCREWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZCREWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZCREWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:22:22 -0400
Received: from ozlabs.org ([203.10.76.45]:59273 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZCREWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:22:19 -0400
CC: linux-kernel@vger.kernel.org
To: davej@redhat.com
To: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 18 Mar 2009 10:40:25 +1030
Subject: [PATCH 5/9] cpumask: avoid playing with cpus_allowed in speedstep-ich.c
Cc: Dominik Brodowski <linux@brodo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090318042217.B6F71DDF34@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: don't play with current's cpumask

It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

For speedstep_set_state and speedstep_get_state we use
smp_call_function_single: this had the advantage of being more
efficient, too.

For speedstep_get_freqs() in speedstep_cpu_init(), we use
work_on_cpu: slightly less efficient, but not performance critical.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: davej@redhat.com
To: cpufreq@vger.kernel.org
Cc: Dominik Brodowski <linux@brodo.de>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |   79 +++++++++++++++-------------
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.c |    2 
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -88,7 +88,8 @@ static int speedstep_find_register (void
  * speedstep_set_state - set the SpeedStep state
  * @state: new processor frequency state (SPEEDSTEP_LOW or SPEEDSTEP_HIGH)
  *
- *   Tries to change the SpeedStep state.
+ *   Tries to change the SpeedStep state.  Can be called from
+ *   smp_call_function_single.
  */
 static void speedstep_set_state (unsigned int state)
 {
@@ -142,6 +143,11 @@ static void speedstep_set_state (unsigne
 	return;
 }
 
+/* Wrapper for smp_call_function_single. */
+static void _speedstep_set_state(void *_state)
+{
+	speedstep_set_state(*(unsigned int *)_state);
+}
 
 /**
  * speedstep_activate - activate SpeedStep control in the chipset
@@ -229,22 +235,28 @@ static unsigned int speedstep_detect_chi
 	return 0;
 }
 
-static unsigned int _speedstep_get(const struct cpumask *cpus)
+struct get_freq_data {
+	unsigned int speed;
+	unsigned int processor;
+};
+
+static void get_freq_data(void *_data)
 {
-	unsigned int speed;
-	cpumask_t cpus_allowed;
+	struct get_freq_data *data = _data;
 
-	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpus);
-	speed = speedstep_get_processor_frequency(speedstep_processor);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
-	dprintk("detected %u kHz as current frequency\n", speed);
-	return speed;
+	data->speed = speedstep_get_processor_frequency(data->processor);
 }
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(cpumask_of(cpu));
+	struct get_freq_data data = { .processor = cpu };
+
+	/* You're supposed to ensure CPU is online. */
+	if (smp_call_function_single(cpu, get_freq_data, &data, 1) != 0)
+		BUG();
+
+	dprintk("detected %u kHz as current frequency\n", data.speed);
+	return data.speed;
 }
 
 /**
@@ -259,15 +271,15 @@ static int speedstep_target (struct cpuf
 			     unsigned int target_freq,
 			     unsigned int relation)
 {
-	unsigned int newstate = 0;
+	unsigned int newstate = 0, policy_cpu;
 	struct cpufreq_freqs freqs;
-	cpumask_t cpus_allowed;
 	int i;
 
 	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0], target_freq, relation, &newstate))
 		return -EINVAL;
 
-	freqs.old = _speedstep_get(policy->cpus);
+	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
+	freqs.old = speedstep_get(policy_cpu);
 	freqs.new = speedstep_freqs[newstate].frequency;
 	freqs.cpu = policy->cpu;
 
@@ -277,20 +289,13 @@ static int speedstep_target (struct cpuf
 	if (freqs.old == freqs.new)
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
-
 	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
 
-	/* switch to physical CPU where state is to be changed */
-	set_cpus_allowed_ptr(current, policy->cpus);
-
-	speedstep_set_state(newstate);
-
-	/* allow to be run on all CPUs */
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	smp_call_function_single(policy_cpu, _speedstep_set_state, &newstate,
+				 true);
 
 	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
@@ -313,33 +318,35 @@ static int speedstep_verify (struct cpuf
 	return cpufreq_frequency_table_verify(policy, &speedstep_freqs[0]);
 }
 
+static long get_freqs_on_cpu(void *_policy)
+{
+	struct cpufreq_policy *policy = _policy;
+
+	return speedstep_get_freqs(speedstep_processor,
+				   &speedstep_freqs[SPEEDSTEP_LOW].frequency,
+				   &speedstep_freqs[SPEEDSTEP_HIGH].frequency,
+				   &policy->cpuinfo.transition_latency,
+				   &speedstep_set_state);
+}
 
 static int speedstep_cpu_init(struct cpufreq_policy *policy)
 {
-	int result = 0;
-	unsigned int speed;
-	cpumask_t cpus_allowed;
+	int result;
+	unsigned int policy_cpu, speed;
 
 	/* only run on CPU to be set, or on its sibling */
 #ifdef CONFIG_SMP
 	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
 #endif
-
-	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, policy->cpus);
+	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
 
 	/* detect low and high frequency and transition latency */
-	result = speedstep_get_freqs(speedstep_processor,
-				     &speedstep_freqs[SPEEDSTEP_LOW].frequency,
-				     &speedstep_freqs[SPEEDSTEP_HIGH].frequency,
-				     &policy->cpuinfo.transition_latency,
-				     &speedstep_set_state);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	result = work_on_cpu(policy_cpu, get_freqs_on_cpu, policy);
 	if (result)
 		return result;
 
 	/* get current speed setting */
-	speed = _speedstep_get(policy->cpus);
+	speed = speedstep_get(policy_cpu);
 	if (!speed)
 		return -EIO;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -205,7 +205,7 @@ static unsigned int pentium4_get_frequen
 	return (fsb * mult);
 }
 
-
+/* Warning: may get called from smp_call_function_single. */
 unsigned int speedstep_get_processor_frequency(unsigned int processor)
 {
 	switch (processor) {


