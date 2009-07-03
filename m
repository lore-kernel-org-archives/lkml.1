Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbZGCTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbZGCTWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZGCTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:22:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:42417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbZGCTWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,343,1243839600"; 
   d="scan'208";a="427438756"
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
Date: Fri, 3 Jul 2009 12:24:43 -0700
Subject: RE: [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
Thread-Topic: [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
Thread-Index: Acn79rTVdG0N7p7MQ82/pP32HVPehgAG29wQ
Message-ID: <7E82351C108FA840AB1866AC776AEC4669BFF0F5@orsmsx505.amr.corp.intel.com>
References: <20090703152514.903448283@polymtl.ca>
 <20090703152714.775719309@polymtl.ca>
In-Reply-To: <20090703152714.775719309@polymtl.ca>
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
>Subject: [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
>
>OK, I've tried to clean it up the best I could, but please 
>test this with
>concurrent cpu hotplug and cpufreq add/remove in loops. I'm 
>sure we will make
>other interesting findings.
>

This is a good and needed cleanup of cpufreq_add_dev.


>This is step one of fixing the overall locking dependency mess 
>in cpufreq.
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
> drivers/cpufreq/cpufreq.c |   65 
>++++++++++++++++++++++++++++------------------
> 1 file changed, 40 insertions(+), 25 deletions(-)
>
>Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
>===================================================================
>--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c	
>2009-07-02 23:59:08.000000000 -0400
>+++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c	2009-07-02 
>23:59:09.000000000 -0400
>@@ -763,6 +763,10 @@ static struct kobj_type ktype_cpufreq = 
>  * cpufreq_add_dev - add a CPU device
>  *
>  * Adds the cpufreq interface for a CPU device.
>+ *
>+ * The Oracle says: try running cpufreq 
>registration/unregistration concurrently
>+ * with with cpu hotplugging and all hell will break loose. 
>Tried to clean this
>+ * mess up, but more thorough testing is needed. - Mathieu
>  */
> static int cpufreq_add_dev(struct sys_device *sys_dev)
> {
>@@ -806,15 +810,12 @@ static int cpufreq_add_dev(struct sys_de
> 		goto nomem_out;
> 	}
> 	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL)) {
>-		kfree(policy);
> 		ret = -ENOMEM;
>-		goto nomem_out;
>+		goto err_free_policy;
> 	}
> 	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
>-		free_cpumask_var(policy->cpus);
>-		kfree(policy);
> 		ret = -ENOMEM;
>-		goto nomem_out;
>+		goto err_free_cpumask;
> 	}
> 
> 	policy->cpu = cpu;
>@@ -822,7 +823,8 @@ static int cpufreq_add_dev(struct sys_de
> 
> 	/* Initially set CPU itself as the policy_cpu */
> 	per_cpu(policy_cpu, cpu) = cpu;
>-	lock_policy_rwsem_write(cpu);
>+	ret = (lock_policy_rwsem_write(cpu) < 0);
>+	WARN_ON(ret);
> 
> 	init_completion(&policy->kobj_unregister);
> 	INIT_WORK(&policy->update, handle_update);
>@@ -835,7 +837,7 @@ static int cpufreq_add_dev(struct sys_de
> 	ret = cpufreq_driver->init(policy);
> 	if (ret) {
> 		dprintk("initialization failed\n");
>-		goto err_out;
>+		goto err_unlock_policy;
> 	}
> 	policy->user_policy.min = policy->min;
> 	policy->user_policy.max = policy->max;
>@@ -860,15 +862,21 @@ static int cpufreq_add_dev(struct sys_de
> 		/* Check for existing affected CPUs.
> 		 * They may not be aware of it due to CPU Hotplug.
> 		 */
>-		managed_policy = cpufreq_cpu_get(j);		
>/* FIXME: Where is this released?  What about error paths? */
>+		managed_policy = cpufreq_cpu_get(j);
> 		if (unlikely(managed_policy)) {
> 
> 			/* Set proper policy_cpu */
> 			unlock_policy_rwsem_write(cpu);
> 			per_cpu(policy_cpu, cpu) = managed_policy->cpu;
> 
>-			if (lock_policy_rwsem_write(cpu) < 0)
>-				goto err_out_driver_exit;
>+			if (lock_policy_rwsem_write(cpu) < 0) {
>+				/* Should not go through policy 
>unlock path */
>+				if (cpufreq_driver->exit)
>+					cpufreq_driver->exit(policy);
>+				ret = -EBUSY;
>+				cpufreq_cpu_put(managed_policy);
>+				goto err_free_cpumask;
>+			}
> 
> 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
> 			cpumask_copy(managed_policy->cpus, 
>policy->cpus);
>@@ -879,12 +887,14 @@ static int cpufreq_add_dev(struct sys_de
> 			ret = sysfs_create_link(&sys_dev->kobj,
> 						&managed_policy->kobj,
> 						"cpufreq");
>-			if (ret)
>-				goto err_out_driver_exit;
>-
>-			cpufreq_debug_enable_ratelimit();
>-			ret = 0;
>-			goto err_out_driver_exit; /* call 
>driver->exit() */
>+			if (!ret)
>+				cpufreq_cpu_put(managed_policy);

Looks like cpufreq_cpu_put is needed both with ret and !ret. No?

Thanks,
Venki

>+			/*
>+			 * Success. We only needed to be added 
>to the mask.
>+			 * Call driver->exit() because only the 
>cpu parent of
>+			 * the kobj needed to call init().
>+			 */
>+			goto out_driver_exit; /* call driver->exit() */
> 		}
> 	}
> #endif
>@@ -894,25 +904,25 @@ static int cpufreq_add_dev(struct sys_de
> 	ret = kobject_init_and_add(&policy->kobj, 
>&ktype_cpufreq, &sys_dev->kobj,
> 				   "cpufreq");
> 	if (ret)
>-		goto err_out_driver_exit;
>+		goto out_driver_exit;
> 
> 	/* set up files for this cpu device */
> 	drv_attr = cpufreq_driver->attr;
> 	while ((drv_attr) && (*drv_attr)) {
> 		ret = sysfs_create_file(&policy->kobj, 
>&((*drv_attr)->attr));
> 		if (ret)
>-			goto err_out_driver_exit;
>+			goto err_out_kobj_put;
> 		drv_attr++;
> 	}
> 	if (cpufreq_driver->get) {
> 		ret = sysfs_create_file(&policy->kobj, 
>&cpuinfo_cur_freq.attr);
> 		if (ret)
>-			goto err_out_driver_exit;
>+			goto err_out_kobj_put;
> 	}
> 	if (cpufreq_driver->target) {
> 		ret = sysfs_create_file(&policy->kobj, 
>&scaling_cur_freq.attr);
> 		if (ret)
>-			goto err_out_driver_exit;
>+			goto err_out_kobj_put;
> 	}
> 
> 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
>@@ -930,12 +940,14 @@ static int cpufreq_add_dev(struct sys_de
> 			continue;
> 
> 		dprintk("CPU %u already managed, adding link\n", j);
>-		cpufreq_cpu_get(cpu);
>+		managed_policy = cpufreq_cpu_get(cpu);
> 		cpu_sys_dev = get_cpu_sysdev(j);
> 		ret = sysfs_create_link(&cpu_sys_dev->kobj, 
>&policy->kobj,
> 					"cpufreq");
>-		if (ret)
>+		if (ret) {
>+			cpufreq_cpu_put(managed_policy);
> 			goto err_out_unregister;
>+		}
> 	}
> 
> 	policy->governor = NULL; /* to assure that the starting 
>sequence is
>@@ -967,17 +979,20 @@ err_out_unregister:
> 		per_cpu(cpufreq_cpu_data, j) = NULL;
> 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
>+err_out_kobj_put:
> 	kobject_put(&policy->kobj);
> 	wait_for_completion(&policy->kobj_unregister);
> 
>-err_out_driver_exit:
>+out_driver_exit:
> 	if (cpufreq_driver->exit)
> 		cpufreq_driver->exit(policy);
> 
>-err_out:
>+err_unlock_policy:
> 	unlock_policy_rwsem_write(cpu);
>+err_free_cpumask:
>+	free_cpumask_var(policy->cpus);
>+err_free_policy:
> 	kfree(policy);
>-
> nomem_out:
> 	module_put(cpufreq_driver->owner);
> module_out:
>

