Return-Path: <linux-kernel-owner+w=401wt.eu-S1761085AbXGVPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761085AbXGVPsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759360AbXGVPo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:57 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:8114 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159AbXGVPoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=txu+1GdXU1NUDeiEoJC6njqxOZPDZyUlqv8rL9k0s7ft8Cn1TwtqqUGsTMUOF3nT4pS9DeMUZoGqBTTH7yXuW0Fxqaeo4k5a5xXyx7N05VUNwa171Rt5Iqwgak56C5LjOZcSY+5l5TA3Tuw6YxPYKRDDxdfRD4pCHOPBPRdBV6Y=
Message-Id: <20070722153420.859827955@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:21 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ashok Raj <ashok.raj@intel.com>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 9/9] intel_cacheinfo: fix cpu hotplug error handling
Content-Disposition: inline; filename=intel-cacheinfo-cpu-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix resource leakage in error case within detect_cache_attributes()

- Don't register hotcpu notifier when cache_add_dev() returns error

- Introduce cache_dev_map cpumask to track whether cache interface for
  CPU is successfully added by cache_add_dev() or not.

  cache_add_dev() may fail with out of memory error. In order to
  avoid cache_remove_dev() with that uninitialized cache interface when
  CPU_DEAD event is delivered we need to have the cache_dev_map cpumask.

  (We cannot change cache_add_dev() from CPU_ONLINE event handler
  to CPU_UP_PREPARE event handler. Because cache_add_dev() needs
  to do cpuid and store the results with its CPU online.)

Cc: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/cpu/intel_cacheinfo.c |   64 +++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 19 deletions(-)

Index: 2.6-git/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- 2.6-git.orig/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ 2.6-git/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -466,6 +466,11 @@ static void __init cache_remove_shared_c
 
 static void free_cache_attributes(unsigned int cpu)
 {
+	int i;
+
+	for (i = 0; i < num_cache_leaves; i++)
+		cache_remove_shared_cpu_map(cpu, i);
+
 	kfree(cpuid4_info[cpu]);
 	cpuid4_info[cpu] = NULL;
 }
@@ -473,8 +478,8 @@ static void free_cache_attributes(unsign
 static int __cpuinit detect_cache_attributes(unsigned int cpu)
 {
 	struct _cpuid4_info	*this_leaf;
-	unsigned long 		j;
-	int 			retval;
+	unsigned long		j;
+	int			retval;
 	cpumask_t		oldmask;
 
 	if (num_cache_leaves == 0)
@@ -491,19 +496,26 @@ static int __cpuinit detect_cache_attrib
 		goto out;
 
 	/* Do cpuid and store the results */
-	retval = 0;
 	for (j = 0; j < num_cache_leaves; j++) {
 		this_leaf = CPUID4_INFO_IDX(cpu, j);
 		retval = cpuid4_cache_lookup(j, this_leaf);
-		if (unlikely(retval < 0))
+		if (unlikely(retval < 0)) {
+			int i;
+
+			for (i = 0; i < j; i++)
+				cache_remove_shared_cpu_map(cpu, i);
 			break;
+		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
 	set_cpus_allowed(current, oldmask);
 
 out:
-	if (retval)
-		free_cache_attributes(cpu);
+	if (retval) {
+		kfree(cpuid4_info[cpu]);
+		cpuid4_info[cpu] = NULL;
+	}
+
 	return retval;
 }
 
@@ -647,13 +659,14 @@ static void cpuid4_cache_sysfs_exit(unsi
 
 static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
 {
+	int err;
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
 
-	detect_cache_attributes(cpu);
-	if (cpuid4_info[cpu] == NULL)
-		return -ENOENT;
+	err = detect_cache_attributes(cpu);
+	if (err)
+		return err;
 
 	/* Allocate all required memory */
 	cache_kobject[cpu] = kzalloc(sizeof(struct kobject), GFP_KERNEL);
@@ -672,13 +685,15 @@ err_out:
 	return -ENOMEM;
 }
 
+static cpumask_t cache_dev_map = CPU_MASK_NONE;
+
 /* Add/Remove cache interface for CPU device */
 static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
-	int retval = 0;
+	int retval;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
 	if (unlikely(retval < 0))
@@ -688,6 +703,10 @@ static int __cpuinit cache_add_dev(struc
 	kobject_set_name(cache_kobject[cpu], "%s", "cache");
 	cache_kobject[cpu]->ktype = &ktype_percpu_entry;
 	retval = kobject_register(cache_kobject[cpu]);
+	if (retval < 0) {
+		cpuid4_cache_sysfs_exit(cpu);
+		return retval;
+	}
 
 	for (i = 0; i < num_cache_leaves; i++) {
 		this_object = INDEX_KOBJECT_PTR(cpu,i);
@@ -707,6 +726,9 @@ static int __cpuinit cache_add_dev(struc
 			break;
 		}
 	}
+	if (!retval)
+		cpu_set(cpu, cache_dev_map);
+
 	return retval;
 }
 
@@ -715,13 +737,14 @@ static void __cpuexit cache_remove_dev(s
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
 
-	for (i = 0; i < num_cache_leaves; i++) {
-		cache_remove_shared_cpu_map(cpu, i);
+	if (!cpu_isset(cpu, cache_dev_map))
+		return;
+	cpu_clear(cpu, cache_dev_map);
+
+	for (i = 0; i < num_cache_leaves; i++)
 		kobject_unregister(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
-	}
 	kobject_unregister(cache_kobject[cpu]);
 	cpuid4_cache_sysfs_exit(cpu);
-	return;
 }
 
 static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
@@ -746,7 +769,7 @@ static int __cpuinit cacheinfo_cpu_callb
 
 static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
 {
-    .notifier_call = cacheinfo_cpu_callback,
+	.notifier_call = cacheinfo_cpu_callback,
 };
 
 static int __cpuinit cache_sysfs_init(void)
@@ -756,12 +779,15 @@ static int __cpuinit cache_sysfs_init(vo
 	if (num_cache_leaves == 0)
 		return 0;
 
-	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
-
 	for_each_online_cpu(i) {
-		cacheinfo_cpu_callback(&cacheinfo_cpu_notifier, CPU_ONLINE,
-			(void *)(long)i);
+		int err;
+		struct sys_device *sys_dev = get_cpu_sysdev(i);
+
+		err = cache_add_dev(sys_dev);
+		if (err)
+			return err;
 	}
+	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
 
 	return 0;
 }

-- 
