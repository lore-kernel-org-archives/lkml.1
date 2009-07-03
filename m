Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZGCTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZGCTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZGCTJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:09:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:56804 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbZGCTJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:09:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,343,1243839600"; 
   d="scan'208";a="427437577"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "rjw@sisk.pl" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "sven.wegener@stealer.net" <sven.wegener@stealer.net>
Date: Fri, 3 Jul 2009 12:11:52 -0700
Subject: RE: [patch 2.6.30 3/4] cpufreq add gov mutex
Thread-Topic: [patch 2.6.30 3/4] cpufreq add gov mutex
Thread-Index: Acn79rU0fowvvIuMQJqrnWYdL4/c5wAGavcQ
Message-ID: <7E82351C108FA840AB1866AC776AEC4669BFF0DE@orsmsx505.amr.corp.intel.com>
References: <20090703152514.903448283@polymtl.ca>
 <20090703152714.953585501@polymtl.ca>
In-Reply-To: <20090703152714.953585501@polymtl.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Mathieu Desnoyers [mailto:mathieu.desnoyers@polymtl.ca] 
>Sent: Friday, July 03, 2009 8:25 AM
>To: linux-kernel@vger.kernel.org; Pallipadi, Venkatesh; Dave 
>Jones; Thomas Renninger; cpufreq@vger.kernel.org; 
>kernel-testers@vger.kernel.org; Ingo Molnar; rjw@sisk.pl; Dave 
>Young; Pekka Enberg
>Cc: Mathieu Desnoyers; Li, Shaohua; Rusty Russell; 
>sven.wegener@stealer.net
>Subject: [patch 2.6.30 3/4] cpufreq add gov mutex
>
>Using the cpufreq_gov_mutex to protect internal governor data 
>structures. The
>policy rwsem write lock nests inside this mutex. 

This makes the whole locking in cpufreq upside down. Takes away
most of the reason for existence of rwsem lock. Taking a smaller
Percpu rwsem lock inside a bigger global mutex doesn't seem right.

>The policy 
>rwsem is taken in
>the timer handler, and therefore cannot be held while doing a 
>sync teardown of
>the timer.  This cpufreq_gov_mutex lock protects init/teardown 
>of governor
>timers.

Why is the protection required for init/teardown of percpu
timer with a global mutex? cpufreq rwsem (when held correctly)
ensures that there can be only one store_scaling_governor for
a cpu at any point in time. I don't see any reason why we need
a global mutex to protect timer init teardown.


> This is why this lock, although it protects a data 
>structure located
>within the governors, is located in cpufreq.c.

I think this is taking a step back in terms of locking. A system
wide Cpufreq_gov_mutex is being held more frequently now and seems
to be providing all the serialization needed. The locks crossing
layers of cpufreq core and governor is just going to make
situation worse IMO.

If we really want to pursue this option, we should get rid
of rwsem altogether. It is not adding much value
and just providing lot more confusion with things like rwsem
should be held everywhere else other than CPUFREQ_GOV_STOP.


Thanks,
Venki

>
>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>CC: rjw@sisk.pl
>CC: mingo@elte.hu
>CC: Shaohua Li <shaohua.li@intel.com>
>CC: Pekka Enberg <penberg@cs.helsinki.fi>
>CC: Dave Young <hidave.darkstar@gmail.com>
>CC: "Rafael J. Wysocki" <rjw@sisk.pl>
>CC: Rusty Russell <rusty@rustcorp.com.au>
>CC: sven.wegener@stealer.net
>CC: cpufreq@vger.kernel.org
>CC: Thomas Renninger <trenn@suse.de>
>---
> drivers/cpufreq/cpufreq.c |   38 
>+++++++++++++++++++++++++++++++++++---
> 1 file changed, 35 insertions(+), 3 deletions(-)
>
>Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
>===================================================================
>--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c	
>2009-07-03 09:48:35.000000000 -0400
>+++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c	2009-07-03 
>10:12:44.000000000 -0400
>@@ -133,6 +133,17 @@ pure_initcall(init_cpufreq_transition_no
> static LIST_HEAD(cpufreq_governor_list);
> static DEFINE_MUTEX(cpufreq_governor_mutex);
> 
>+/*
>+ * Using the cpufreq_gov_mutex to protect internal governor
>+ * data structures. The policy rwsem write lock nests inside 
>this mutex.
>+ * The policy rwsem is taken in the timer handler, and 
>therefore cannot be
>+ * held while doing a sync teardown of the timer.
>+ * This cpufreq_gov_mutex lock protects init/teardown of 
>governor timers.
>+ * This is why this lock, although it protects a data 
>structure located within
>+ * the governors, is here.
>+ */
>+static DEFINE_MUTEX(cpufreq_gov_mutex);
>+
> struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
> {
> 	struct cpufreq_policy *data;
>@@ -725,6 +736,7 @@ static ssize_t store(struct kobject *kob
> 	if (!policy)
> 		goto no_policy;
> 
>+	mutex_lock(&cpufreq_gov_mutex);
> 	if (lock_policy_rwsem_write(policy->cpu) < 0)
> 		goto fail;
> 
>@@ -735,6 +747,7 @@ static ssize_t store(struct kobject *kob
> 
> 	unlock_policy_rwsem_write(policy->cpu);
> fail:
>+	mutex_unlock(&cpufreq_gov_mutex);
> 	cpufreq_cpu_put(policy);
> no_policy:
> 	return ret;
>@@ -823,6 +836,7 @@ static int cpufreq_add_dev(struct sys_de
> 
> 	/* Initially set CPU itself as the policy_cpu */
> 	per_cpu(policy_cpu, cpu) = cpu;
>+	mutex_lock(&cpufreq_gov_mutex);
> 	ret = (lock_policy_rwsem_write(cpu) < 0);
> 	WARN_ON(ret);
> 
>@@ -875,7 +889,7 @@ static int cpufreq_add_dev(struct sys_de
> 					cpufreq_driver->exit(policy);
> 				ret = -EBUSY;
> 				cpufreq_cpu_put(managed_policy);
>-				goto err_free_cpumask;
>+				goto err_unlock_gov_mutex;
> 			}
> 
> 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
>@@ -964,6 +978,7 @@ static int cpufreq_add_dev(struct sys_de
> 	}
> 
> 	unlock_policy_rwsem_write(cpu);
>+	mutex_unlock(&cpufreq_gov_mutex);
> 
> 	kobject_uevent(&policy->kobj, KOBJ_ADD);
> 	module_put(cpufreq_driver->owner);
>@@ -989,6 +1004,8 @@ out_driver_exit:
> 
> err_unlock_policy:
> 	unlock_policy_rwsem_write(cpu);
>+err_unlock_gov_mutex:
>+	mutex_unlock(&cpufreq_gov_mutex);
> err_free_cpumask:
> 	free_cpumask_var(policy->cpus);
> err_free_policy:
>@@ -1028,6 +1045,7 @@ static int __cpufreq_remove_dev(struct s
> 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 		cpufreq_debug_enable_ratelimit();
> 		unlock_policy_rwsem_write(cpu);
>+		mutex_unlock(&cpufreq_gov_mutex);
> 		return -EINVAL;
> 	}
> 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
>@@ -1045,6 +1063,7 @@ static int __cpufreq_remove_dev(struct s
> 		cpufreq_cpu_put(data);
> 		cpufreq_debug_enable_ratelimit();
> 		unlock_policy_rwsem_write(cpu);
>+		mutex_unlock(&cpufreq_gov_mutex);
> 		return 0;
> 	}
> #endif
>@@ -1088,9 +1107,13 @@ static int __cpufreq_remove_dev(struct s
> #endif
> 
> 	unlock_policy_rwsem_write(cpu);
>-
>+	/*
>+	 * Calling only with the cpufreq_gov_mutex held because
>+	 * sync timer teardown has locking dependency with policy rwsem.
>+	 */
> 	if (cpufreq_driver->target)
> 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
>+	mutex_unlock(&cpufreq_gov_mutex);
> 
> 	kobject_put(&data->kobj);
> 
>@@ -1123,6 +1146,7 @@ static int cpufreq_remove_dev(struct sys
> 	if (cpu_is_offline(cpu))
> 		return 0;
> 
>+	mutex_lock(&cpufreq_gov_mutex);
> 	if (unlikely(lock_policy_rwsem_write(cpu)))
> 		BUG();
> 
>@@ -1506,12 +1530,16 @@ int cpufreq_driver_target(struct cpufreq
> 	if (!policy)
> 		goto no_policy;
> 
>-	if (unlikely(lock_policy_rwsem_write(policy->cpu)))
>+	mutex_lock(&cpufreq_gov_mutex);
>+	if (unlikely(lock_policy_rwsem_write(policy->cpu))) {
>+		mutex_unlock(&cpufreq_gov_mutex);
> 		goto fail;
>+	}
> 
> 	ret = __cpufreq_driver_target(policy, target_freq, relation);
> 
> 	unlock_policy_rwsem_write(policy->cpu);
>+	mutex_unlock(&cpufreq_gov_mutex);
> 
> fail:
> 	cpufreq_cpu_put(policy);
>@@ -1769,7 +1797,9 @@ int cpufreq_update_policy(unsigned int c
> 		goto no_policy;
> 	}
> 
>+	mutex_lock(&cpufreq_gov_mutex);
> 	if (unlikely(lock_policy_rwsem_write(cpu))) {
>+		mutex_unlock(&cpufreq_gov_mutex);
> 		ret = -EINVAL;
> 		goto fail;
> 	}
>@@ -1798,6 +1828,7 @@ int cpufreq_update_policy(unsigned int c
> 	ret = __cpufreq_set_policy(data, &policy);
> 
> 	unlock_policy_rwsem_write(cpu);
>+	mutex_unlock(&cpufreq_gov_mutex);
> 
> fail:
> 	cpufreq_cpu_put(data);
>@@ -1821,6 +1852,7 @@ static int __cpuinit cpufreq_cpu_callbac
> 			break;
> 		case CPU_DOWN_PREPARE:
> 		case CPU_DOWN_PREPARE_FROZEN:
>+			mutex_lock(&cpufreq_gov_mutex);
> 			if (unlikely(lock_policy_rwsem_write(cpu)))
> 				BUG();
> 
>
>-- 
>Mathieu Desnoyers
>OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 
>A8FE 3BAE 9A68
>