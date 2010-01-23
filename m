Return-Path: <linux-kernel-owner+w=401wt.eu-S932168Ab0AWAnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0AWAnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268Ab0AWAns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:43:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:52436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab0AWAnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:43:46 -0500
Date: Sat, 23 Jan 2010 00:43:22 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1264172467-25155-5-git-send-email-bp@amd64.org>
References: <1264172467-25155-5-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Add cache index disable sysfs attrs only to L3 caches
Message-ID: <tip-897de50e08937663912c86fb12ad7f708af2386c@git.kernel.org>
Git-Commit-ID: 897de50e08937663912c86fb12ad7f708af2386c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Jan 2010 00:43:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  897de50e08937663912c86fb12ad7f708af2386c
Gitweb:     http://git.kernel.org/tip/897de50e08937663912c86fb12ad7f708af2386c
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 22 Jan 2010 16:01:06 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 22 Jan 2010 16:06:31 -0800

x86, cacheinfo: Add cache index disable sysfs attrs only to L3 caches

The cache_disable_[01] attribute in

/sys/devices/system/cpu/cpu?/cache/index[0-3]/

is enabled on all cache levels although only L3 supports it. Add it only
to the cache level that actually supports it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-5-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   35 ++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 08c91ab..3976ce9 100644
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
