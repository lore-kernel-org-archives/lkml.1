Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359Ab0ASLPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0ASLPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138Ab0ASLO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:14:57 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56501 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab0ASLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:14:56 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2010 06:14:56 EST
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86, cacheinfo: Add cache index disable sysfs attrs only to L3 caches
Date: Tue, 19 Jan 2010 12:07:58 +0100
Message-Id: <1263899279-30739-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263899279-30739-1-git-send-email-bp@amd64.org>
References: <1263899279-30739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache_disable_[01] attribute in

/sys/devices/system/cpu/cpu?/cache/index[0-3]/

is enabled on all cache levels although only L3 supports it. Add it only
to the cache level that actually supports it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   35 ++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 66932f1..53e28e4 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -814,16 +814,24 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
+#define DEFAULT_SYSFS_CACHE_ATTRS	\
+	&type.attr,			\
+	&level.attr,			\
+	&coherency_line_size.attr,	\
+	&physical_line_partition.attr,	\
+	&ways_of_associativity.attr,	\
+	&number_of_sets.attr,		\
+	&size.attr,			\
+	&shared_cpu_map.attr,		\
+	&shared_cpu_list.attr
+
 static struct attribute *default_attrs[] = {
-	&type.attr,
-	&level.attr,
-	&coherency_line_size.attr,
-	&physical_line_partition.attr,
-	&ways_of_associativity.attr,
-	&number_of_sets.attr,
-	&size.attr,
-	&shared_cpu_map.attr,
-	&shared_cpu_list.attr,
+	DEFAULT_SYSFS_CACHE_ATTRS,
+	NULL
+};
+
+static struct attribute *default_l3_attrs[] = {
+	DEFAULT_SYSFS_CACHE_ATTRS,
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
 	NULL
@@ -916,6 +924,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
+	struct _cpuid4_info   *this_leaf;
 	int retval;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
@@ -934,6 +943,14 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 		this_object = INDEX_KOBJECT_PTR(cpu, i);
 		this_object->cpu = cpu;
 		this_object->index = i;
+
+		this_leaf = CPUID4_INFO_IDX(cpu, i);
+
+		if (this_leaf->can_disable)
+			ktype_cache.default_attrs = default_l3_attrs;
+		else
+			ktype_cache.default_attrs = default_attrs;
+
 		retval = kobject_init_and_add(&(this_object->kobj),
 					      &ktype_cache,
 					      per_cpu(ici_cache_kobject, cpu),
-- 
1.6.6

