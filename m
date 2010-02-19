Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0BSGKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:10:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:41454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0BSGKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:10:15 -0500
Date: Fri, 19 Feb 2010 06:09:52 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20100218184210.GF20473@aftab>
References: <20100218184210.GF20473@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Enable L3 CID only on AMD
Message-ID: <tip-cb19060abfdecac0d1eb2d2f0e7d6b7a3f8bc4f4@git.kernel.org>
Git-Commit-ID: cb19060abfdecac0d1eb2d2f0e7d6b7a3f8bc4f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 06:09:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb19060abfdecac0d1eb2d2f0e7d6b7a3f8bc4f4
Gitweb:     http://git.kernel.org/tip/cb19060abfdecac0d1eb2d2f0e7d6b7a3f8bc4f4
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 18 Feb 2010 19:37:14 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 21:59:07 -0800

x86, cacheinfo: Enable L3 CID only on AMD

Final stage linking can fail with

 arch/x86/built-in.o: In function `store_cache_disable':
 intel_cacheinfo.c:(.text+0xc509): undefined reference to `amd_get_nb_id'
 arch/x86/built-in.o: In function `show_cache_disable':
 intel_cacheinfo.c:(.text+0xc7d3): undefined reference to `amd_get_nb_id'

when CONFIG_CPU_SUP_AMD is not enabled because the amd_get_nb_id
helper is defined in AMD-specific code but also used in generic code
(intel_cacheinfo.c). Reorganize the L3 cache index disable code under
CONFIG_CPU_SUP_AMD since it is AMD-only anyway.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100218184210.GF20473@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |  186 +++++++++++++++++----------------
 1 files changed, 98 insertions(+), 88 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index be5f5c2..d440123 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -293,6 +293,13 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
+struct _cache_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct _cpuid4_info *, char *);
+	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
+};
+
+#ifdef CONFIG_CPU_SUP_AMD
 static unsigned int __cpuinit amd_calc_l3_indices(void)
 {
 	/*
@@ -303,7 +310,7 @@ static unsigned int __cpuinit amd_calc_l3_indices(void)
 	int node = cpu_to_node(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned int sc0, sc1, sc2, sc3;
-	u32 val;
+	u32 val = 0;
 
 	pci_read_config_dword(dev, 0x1C4, &val);
 
@@ -335,6 +342,94 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
 
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+				  unsigned int index)
+{
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = amd_get_nb_id(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int reg = 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!dev)
+		return -EINVAL;
+
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "0x%08x\n", reg);
+}
+
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
+}
+SHOW_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
+
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+	const char *buf, size_t count, unsigned int index)
+{
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = amd_get_nb_id(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned long val = 0;
+
+#define SUBCACHE_MASK	(3UL << 20)
+#define SUBCACHE_INDEX	0xfff
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!dev)
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	/* do not allow writes outside of allowed bits */
+	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
+		return -EINVAL;
+
+	val |= BIT(30);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	/*
+	 * We need to WBINVD on a core on the node containing the L3 cache which
+	 * indices we disable therefore a simple wbinvd() is not sufficient.
+	 */
+	wbinvd_on_cpu(cpu);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
+	return count;
+}
+
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
+			    const char *buf, size_t count)		\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
+}
+STORE_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(1)
+
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		show_cache_disable_1, store_cache_disable_1);
+
+#else	/* CONFIG_CPU_SUP_AMD */
+static void __cpuinit
+amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+{
+};
+#endif /* CONFIG_CPU_SUP_AMD */
+
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
 				   struct _cpuid4_info_regs *this_leaf)
@@ -740,88 +835,6 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
-				  unsigned int index)
-{
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned int reg = 0;
-
-	if (!this_leaf->can_disable)
-		return -EINVAL;
-
-	if (!dev)
-		return -EINVAL;
-
-	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
-	return sprintf(buf, "0x%08x\n", reg);
-}
-
-#define SHOW_CACHE_DISABLE(index)					\
-static ssize_t								\
-show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
-{									\
-	return show_cache_disable(this_leaf, buf, index);		\
-}
-SHOW_CACHE_DISABLE(0)
-SHOW_CACHE_DISABLE(1)
-
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-	const char *buf, size_t count, unsigned int index)
-{
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned long val = 0;
-
-#define SUBCACHE_MASK	(3UL << 20)
-#define SUBCACHE_INDEX	0xfff
-
-	if (!this_leaf->can_disable)
-		return -EINVAL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!dev)
-		return -EINVAL;
-
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
-
-	/* do not allow writes outside of allowed bits */
-	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
-		return -EINVAL;
-
-	val |= BIT(30);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-	/*
-	 * We need to WBINVD on a core on the node containing the L3 cache which
-	 * indices we disable therefore a simple wbinvd() is not sufficient.
-	 */
-	wbinvd_on_cpu(cpu);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
-	return count;
-}
-
-#define STORE_CACHE_DISABLE(index)					\
-static ssize_t								\
-store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
-			    const char *buf, size_t count)		\
-{									\
-	return store_cache_disable(this_leaf, buf, count, index);	\
-}
-STORE_CACHE_DISABLE(0)
-STORE_CACHE_DISABLE(1)
-
-struct _cache_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
-};
-
 #define define_one_ro(_name) \
 static struct _cache_attr _name = \
 	__ATTR(_name, 0444, show_##_name, NULL)
@@ -836,11 +849,6 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
-		show_cache_disable_0, store_cache_disable_0);
-static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
-		show_cache_disable_1, store_cache_disable_1);
-
 #define DEFAULT_SYSFS_CACHE_ATTRS	\
 	&type.attr,			\
 	&level.attr,			\
@@ -859,8 +867,10 @@ static struct attribute *default_attrs[] = {
 
 static struct attribute *default_l3_attrs[] = {
 	DEFAULT_SYSFS_CACHE_ATTRS,
+#ifdef CONFIG_CPU_SUP_AMD
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
+#endif
 	NULL
 };
 
