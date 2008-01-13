Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYAMSfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYAMSfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYAMSe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:34:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52816 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288AbYAMSe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:34:56 -0500
Message-Id: <20080113183454.551029000@sgi.com>
References: <20080113183453.973425000@sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 13 Jan 2008 10:34:57 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] x86: Change NR_CPUS arrays in intel_cacheinfo
Content-Disposition: inline; filename=NR_CPUS-arrays-in-intel_cacheinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the following static arrays sized by NR_CPUS to
per_cpu data variables:

	_cpuid4_info *cpuid4_info[NR_CPUS];
	_index_kobject *index_kobject[NR_CPUS];
	kobject * cache_kobject[NR_CPUS];

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   55 +++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -451,8 +451,8 @@ unsigned int __cpuinit init_intel_cachei
 }
 
 /* pointer to _cpuid4_info array (for each cache leaf) */
-static struct _cpuid4_info *cpuid4_info[NR_CPUS];
-#define CPUID4_INFO_IDX(x,y)    (&((cpuid4_info[x])[y]))
+static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
+#define CPUID4_INFO_IDX(x,y)    (&((per_cpu(cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
@@ -474,7 +474,7 @@ static void __cpuinit cache_shared_cpu_m
 			if (cpu_data(i).apicid >> index_msb ==
 			    c->apicid >> index_msb) {
 				cpu_set(i, this_leaf->shared_cpu_map);
-				if (i != cpu && cpuid4_info[i])  {
+				if (i != cpu && per_cpu(cpuid4_info, i))  {
 					sibling_leaf = CPUID4_INFO_IDX(i, index);
 					cpu_set(cpu, sibling_leaf->shared_cpu_map);
 				}
@@ -505,8 +505,8 @@ static void __cpuinit free_cache_attribu
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
-	kfree(cpuid4_info[cpu]);
-	cpuid4_info[cpu] = NULL;
+	kfree(per_cpu(cpuid4_info, cpu));
+	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
 static int __cpuinit detect_cache_attributes(unsigned int cpu)
@@ -519,9 +519,9 @@ static int __cpuinit detect_cache_attrib
 	if (num_cache_leaves == 0)
 		return -ENOENT;
 
-	cpuid4_info[cpu] = kzalloc(
+	per_cpu(cpuid4_info, cpu) = kzalloc(
 	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (cpuid4_info[cpu] == NULL)
+	if (per_cpu(cpuid4_info, cpu) == NULL)
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
@@ -546,8 +546,8 @@ static int __cpuinit detect_cache_attrib
 
 out:
 	if (retval) {
-		kfree(cpuid4_info[cpu]);
-		cpuid4_info[cpu] = NULL;
+		kfree(per_cpu(cpuid4_info, cpu));
+		per_cpu(cpuid4_info, cpu) = NULL;
 	}
 
 	return retval;
@@ -561,7 +561,7 @@ out:
 extern struct sysdev_class cpu_sysdev_class; /* from drivers/base/cpu.c */
 
 /* pointer to kobject for cpuX/cache */
-static struct kobject * cache_kobject[NR_CPUS];
+static DEFINE_PER_CPU(struct kobject *, cache_kobject);
 
 struct _index_kobject {
 	struct kobject kobj;
@@ -570,8 +570,8 @@ struct _index_kobject {
 };
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
-static struct _index_kobject *index_kobject[NR_CPUS];
-#define INDEX_KOBJECT_PTR(x,y)    (&((index_kobject[x])[y]))
+static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
+#define INDEX_KOBJECT_PTR(x,y)    (&((per_cpu(index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
 static ssize_t show_##file_name						\
@@ -684,10 +684,10 @@ static struct kobj_type ktype_percpu_ent
 
 static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
-	kfree(cache_kobject[cpu]);
-	kfree(index_kobject[cpu]);
-	cache_kobject[cpu] = NULL;
-	index_kobject[cpu] = NULL;
+	kfree(per_cpu(cache_kobject, cpu));
+	kfree(per_cpu(index_kobject, cpu));
+	per_cpu(cache_kobject, cpu) = NULL;
+	per_cpu(index_kobject, cpu) = NULL;
 	free_cache_attributes(cpu);
 }
 
@@ -703,13 +703,14 @@ static int __cpuinit cpuid4_cache_sysfs_
 		return err;
 
 	/* Allocate all required memory */
-	cache_kobject[cpu] = kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (unlikely(cache_kobject[cpu] == NULL))
+	per_cpu(cache_kobject, cpu) =
+		kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (unlikely(per_cpu(cache_kobject, cpu) == NULL))
 		goto err_out;
 
-	index_kobject[cpu] = kzalloc(
+	per_cpu(index_kobject, cpu) = kzalloc(
 	    sizeof(struct _index_kobject ) * num_cache_leaves, GFP_KERNEL);
-	if (unlikely(index_kobject[cpu] == NULL))
+	if (unlikely(per_cpu(index_kobject, cpu) == NULL))
 		goto err_out;
 
 	return 0;
@@ -733,7 +734,8 @@ static int __cpuinit cache_add_dev(struc
 	if (unlikely(retval < 0))
 		return retval;
 
-	retval = kobject_init_and_add(cache_kobject[cpu], &ktype_percpu_entry,
+	retval = kobject_init_and_add(per_cpu(cache_kobject, cpu),
+				      &ktype_percpu_entry,
 				      &sys_dev->kobj, "%s", "cache");
 	if (retval < 0) {
 		cpuid4_cache_sysfs_exit(cpu);
@@ -745,13 +747,14 @@ static int __cpuinit cache_add_dev(struc
 		this_object->cpu = cpu;
 		this_object->index = i;
 		retval = kobject_init_and_add(&(this_object->kobj),
-					      &ktype_cache, cache_kobject[cpu],
+					      &ktype_cache,
+					      per_cpu(cache_kobject, cpu),
 					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++) {
 				kobject_put(&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
 			}
-			kobject_put(cache_kobject[cpu]);
+			kobject_put(per_cpu(cache_kobject, cpu));
 			cpuid4_cache_sysfs_exit(cpu);
 			break;
 		}
@@ -760,7 +763,7 @@ static int __cpuinit cache_add_dev(struc
 	if (!retval)
 		cpu_set(cpu, cache_dev_map);
 
-	kobject_uevent(cache_kobject[cpu], KOBJ_ADD);
+	kobject_uevent(per_cpu(cache_kobject, cpu), KOBJ_ADD);
 	return retval;
 }
 
@@ -769,7 +772,7 @@ static void __cpuinit cache_remove_dev(s
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
 
-	if (cpuid4_info[cpu] == NULL)
+	if (per_cpu(cpuid4_info, cpu) == NULL)
 		return;
 	if (!cpu_isset(cpu, cache_dev_map))
 		return;
@@ -777,7 +780,7 @@ static void __cpuinit cache_remove_dev(s
 
 	for (i = 0; i < num_cache_leaves; i++)
 		kobject_put(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
-	kobject_put(cache_kobject[cpu]);
+	kobject_put(per_cpu(cache_kobject, cpu));
 	cpuid4_cache_sysfs_exit(cpu);
 }
 

-- 
