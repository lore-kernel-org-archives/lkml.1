Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab0BRULJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:11:09 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20501 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0BRULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:11:05 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dNab9bh1b0bMzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KY2022-01-5BG-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 19:42:10 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: [PATCH 2/2] x86, cacheinfo: Enable L3 CID only on AMD
Message-ID: <20100218184210.GF20473@aftab>
References: <1266234236-24749-1-git-send-email-bp@amd64.org>
 <tip-472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7@git.kernel.org>
 <20100216140246.GA31213@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100216140246.GA31213@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 18:42:06.0894 (UTC) FILETIME=[1236BCE0:01CAB0CA]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 03:02:46PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > Commit-ID:  472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
> > Gitweb:     http://git.kernel.org/tip/472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
> > Author:     Borislav Petkov <borislav.petkov@amd.com>
> > AuthorDate: Mon, 15 Feb 2010 12:43:56 +0100
> > Committer:  H. Peter Anvin <hpa@zytor.com>
> > CommitDate: Mon, 15 Feb 2010 12:32:48 -0800
> > 
> > x86, cacheinfo: Remove NUMA dependency, fix for D1 Isntanbul
> 
> FYI, this commit broke the build in -tip testing:
> 
>  arch/x86/built-in.o: In function `store_cache_disable':
>  intel_cacheinfo.c:(.text+0xc509): undefined reference to `amd_get_nb_id'
>  arch/x86/built-in.o: In function `show_cache_disable':
>  intel_cacheinfo.c:(.text+0xc7d3): undefined reference to `amd_get_nb_id'

How's that:

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 18 Feb 2010 19:37:14 +0100
Subject: [PATCH 2/2] x86, cacheinfo: Enable L3 CID only on AMD

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
 
-- 
1.6.4.2


