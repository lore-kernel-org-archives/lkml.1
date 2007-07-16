Return-Path: <linux-kernel-owner+w=401wt.eu-S1765279AbXGPOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765279AbXGPOLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbXGPOLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:11:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:51083 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293AbXGPOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RNa2YHt1ZuCKq9A52HZKVdZGVms+Kk7WGR4DCU+9BHYloJ70gEjLWzP1R/4GUpcKln5IWKNRb3bHii1X5lF/Itd8HS+EBlkp8a83X+10GN9uKSL0YExvsftzaA98SY09HILo2zI18rj1nJ26y4xlAdp+qBmMRsLCcegyn/HdjHw=
Date: Mon, 16 Jul 2007 23:01:08 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 10/10] intel_cacheinfo: fix cpu hotplug error handling
Message-ID: <20070716140108.GB2092@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix resource leakage in error case within detect_cache_attributes()

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
 arch/i386/kernel/cpu/intel_cacheinfo.c |   57 +++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 17 deletions(-)

Index: 2.6-mm/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- 2.6-mm.orig/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ 2.6-mm/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -502,6 +502,11 @@ static void __init cache_remove_shared_c
 
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
@@ -509,8 +514,8 @@ static void free_cache_attributes(unsign
 static int __cpuinit detect_cache_attributes(unsigned int cpu)
 {
 	struct _cpuid4_info	*this_leaf;
-	unsigned long 		j;
-	int 			retval;
+	unsigned long		j;
+	int			retval;
 	cpumask_t		oldmask;
 
 	if (num_cache_leaves == 0)
@@ -527,19 +532,26 @@ static int __cpuinit detect_cache_attrib
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
 
@@ -683,13 +695,14 @@ static void cpuid4_cache_sysfs_exit(unsi
 
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
@@ -708,13 +721,15 @@ err_out:
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
@@ -724,6 +739,10 @@ static int __cpuinit cache_add_dev(struc
 	kobject_set_name(cache_kobject[cpu], "%s", "cache");
 	cache_kobject[cpu]->ktype = &ktype_percpu_entry;
 	retval = kobject_register(cache_kobject[cpu]);
+	if (retval < 0) {
+		cpuid4_cache_sysfs_exit(cpu);
+		return retval;
+	}
 
 	for (i = 0; i < num_cache_leaves; i++) {
 		this_object = INDEX_KOBJECT_PTR(cpu,i);
@@ -743,6 +762,9 @@ static int __cpuinit cache_add_dev(struc
 			break;
 		}
 	}
+	if (!retval)
+		cpu_set(cpu, cache_dev_map);
+
 	return retval;
 }
 
@@ -751,13 +773,14 @@ static void __cpuinit cache_remove_dev(s
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
@@ -782,7 +805,7 @@ static int __cpuinit cacheinfo_cpu_callb
 
 static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
 {
-    .notifier_call = cacheinfo_cpu_callback,
+	.notifier_call = cacheinfo_cpu_callback,
 };
 
 static int __cpuinit cache_sysfs_init(void)
@@ -795,8 +818,8 @@ static int __cpuinit cache_sysfs_init(vo
 	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
 
 	for_each_online_cpu(i) {
-		cacheinfo_cpu_callback(&cacheinfo_cpu_notifier, CPU_ONLINE,
-			(void *)(long)i);
+		struct sys_device *sys_dev = get_cpu_sysdev(i);
+		cache_add_dev(sys_dev);
 	}
 
 	return 0;
