Return-Path: <linux-kernel-owner+w=401wt.eu-S937863AbZDJMkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937863AbZDJMkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938232AbZDJMjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:39:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:45873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938201AbZDJMi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:38:58 -0400
Date: Fri, 10 Apr 2009 12:37:08 GMT
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, andreas.herrmann3@amd.com,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409131849.GJ31527@alberich.amd.com>
References: <20090409131849.GJ31527@alberich.amd.com>
Subject: [tip:x86/cpu] x86: cacheinfo: replace sysfs interface for cache_disable feature
Message-ID: <tip-f8b201fc7110c3673437254e8ba02451461ece0b@git.kernel.org>
Git-Commit-ID: f8b201fc7110c3673437254e8ba02451461ece0b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:37:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8b201fc7110c3673437254e8ba02451461ece0b
Gitweb:     http://git.kernel.org/tip/f8b201fc7110c3673437254e8ba02451461ece0b
Author:     Mark Langsdorf <mark.langsdorf@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:18:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 14:21:53 +0200

x86: cacheinfo: replace sysfs interface for cache_disable feature

Impact: replace sysfs attribute

Current interface violates against "one-value-per-sysfs-attribute
rule". This patch replaces current attribute with two attributes --
one for each L3 Cache Index Disable register.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090409131849.GJ31527@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   90 ++++++++++++++++----------------
 1 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 0cde071..fc28291 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -697,73 +697,69 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+				  unsigned int index)
 {
-	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
-	int node = cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev = NULL;
-	ssize_t ret = 0;
-	int i;
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int reg = 0;
 
 	if (!this_leaf->can_disable)
-		return sprintf(buf, "Feature not enabled\n");
-
-	dev = node_to_k8_nb_misc(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
 		return -EINVAL;
-	}
 
-	for (i = 0; i < 2; i++) {
-		unsigned int reg;
+	if (!dev)
+		return -EINVAL;
 
-		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "%x\n", reg);
+}
 
-		ret += sprintf(buf, "%sEntry: %d\n", buf, i);
-		ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",  
-			buf,
-			reg & 0x80000000 ? "Disabled" : "Allowed",
-			reg & 0x40000000 ? "Disabled" : "Allowed");
-		ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
-			buf, (reg & 0x30000) >> 16, reg & 0xfff);
-	}
-	return ret;
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
 }
+SHOW_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
 
-static ssize_t
-store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
-		    size_t count)
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+	const char *buf, size_t count, unsigned int index)
 {
-	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
-	int node = cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev = NULL;
-	unsigned int ret, index, val;
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned long val = 0;
 
 	if (!this_leaf->can_disable)
 		return -EINVAL;
 
-	if (strlen(buf) > 15)
-		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
-	ret = sscanf(buf, "%x %x", &index, &val);
-	if (ret != 2)
-		return -EINVAL;
-	if (index > 1)
+	if (!dev)
 		return -EINVAL;
 
-	val |= 0xc0000000;
-	dev = node_to_k8_nb_misc(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
-	}
 
+	val |= 0xc0000000;
 	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
 	wbinvd();
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	return count;
+}
 
-	return 1;
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
+			    const char *buf, size_t count)		\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
 }
+STORE_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(1)
 
 struct _cache_attr {
 	struct attribute attr;
@@ -785,7 +781,10 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-static struct _cache_attr cache_disable = __ATTR(cache_disable, 0644, show_cache_disable, store_cache_disable);
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		show_cache_disable_1, store_cache_disable_1);
 
 static struct attribute * default_attrs[] = {
 	&type.attr,
@@ -797,7 +796,8 @@ static struct attribute * default_attrs[] = {
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
-	&cache_disable.attr,
+	&cache_disable_0.attr,
+	&cache_disable_1.attr,
 	NULL
 };
 
