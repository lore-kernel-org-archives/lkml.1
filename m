Return-Path: <linux-kernel-owner+w=401wt.eu-S1762340AbZLKTv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762340AbZLKTv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761766AbZLKTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:51:22 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54083
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761228AbZLKTvV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:51:21 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUI6S5-01-05D-02
X-M-MSG: 
Date: Fri, 11 Dec 2009 20:42:47 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, cache: add cache index disable attributes only on L3
 caches
Message-ID: <20091211194247.GD30407@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Dec 2009 19:42:43.0291 (UTC) FILETIME=[1B2C22B0:01CA7A9A]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 6 Oct 2009 20:11:59 +0200
Subject: [PATCH] x86, cache: add cache index disable attributes only on L3 caches

the cache_disable_[01] attribute in

/sys/devices/system/cpu/cpu?/cache/index[0-3]/

is enabled on all cache levels although only L3 supports it. Fix it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   38 ++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6c40f6b..7accaeb 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -805,16 +805,24 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
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
@@ -854,7 +862,6 @@ static struct sysfs_ops sysfs_ops = {
 
 static struct kobj_type ktype_cache = {
 	.sysfs_ops	= &sysfs_ops,
-	.default_attrs	= default_attrs,
 };
 
 static struct kobj_type ktype_percpu_entry = {
@@ -907,6 +914,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
+	struct _cpuid4_info   *this_leaf;
 	int retval;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
@@ -925,8 +933,14 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 		this_object = INDEX_KOBJECT_PTR(cpu, i);
 		this_object->cpu = cpu;
 		this_object->index = i;
-		retval = kobject_init_and_add(&(this_object->kobj),
-					      &ktype_cache,
+		this_leaf = CPUID4_INFO_IDX(cpu, i);
+
+		if (this_leaf->can_disable)
+			ktype_cache.default_attrs = default_l3_attrs;
+		else
+			ktype_cache.default_attrs = default_attrs;
+
+		retval = kobject_init_and_add(&(this_object->kobj), &ktype_cache,
 					      per_cpu(cache_kobject, cpu),
 					      "index%1lu", i);
 		if (unlikely(retval)) {
-- 
1.6.5.4

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

