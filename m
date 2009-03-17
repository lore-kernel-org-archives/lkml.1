Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZCQTz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZCQTz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZCQTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:55:11 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58234 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752746AbZCQTzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:55:09 -0400
X-BigFish: VPS-34(zz13e6S936eQ936fKzz1202hzz5eeeTz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KGO1X8-02-32F-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       eric@lammerts.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
Subject: [PATCH][retry 5] Conform L3 Cache Index Disable to Linux Standards
Date: Tue, 17 Mar 2009 14:57:25 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <200903171457.25582.mark.langsdorf@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2009 19:53:46.0192 (UTC) FILETIME=[152C0D00:01C9A73A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ABI Documentation entry and fix some /sys directory formating
issues with the L3 Cache Index Disable feature for future AMD
processors.  Add a check to disable it for family 0x10 models
that do not support it properly.  Correct the disable algorithm
to reflect erratum 388.
    
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-cache_disable
new file mode 100644
index 0000000..c7d9174
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-cache_disable
@@ -0,0 +1,18 @@
+What:	    /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
+Date:	    August 2008
+KernelVersion:  2.6.27
+Contact:	 mark.langsdorf@amd.com
+Description:    These files exist in every cpu's cache index directories.
+		 There are currently 2 cache_disable_# files in each
+		 directory.  Reading from these files on a supported
+		 processor will return that cache disable index value
+		 for that processor and node.  Writing to one of these
+		 files will cause the specificed cache index to be disabled.
+
+		 Currently, only AMD Family 10h Processors support cache index
+		 disable, and only for their L3 caches.  See the BIOS and
+		 Kernel Developer's Guide at
+		 http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
+		 for formatting information and other details on the
+		 cache index disable.
+Users:	   joachim.deguara@amd.com
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index 54c8cc5..0d619c3 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -6,7 +6,11 @@
 extern struct pci_device_id k8_nb_ids[];
 
 extern int early_is_k8_nb(u32 value);
+#ifdef CONFIG_K8_NB
 extern struct pci_dev **k8_northbridges;
+#else
+struct pci_dev **k8_northbridges;
+#endif
 extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 483eda9..9f41501 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -18,6 +18,9 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 
+#include <linux/pci.h>
+#include <asm/k8.h>
+
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
 #define LVL_2		3
@@ -159,14 +162,6 @@ struct _cpuid4_info_regs {
 	unsigned long can_disable;
 };
 
-#if defined(CONFIG_PCI) && defined(CONFIG_SYSFS)
-static struct pci_device_id k8_nb_id[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
-	{}
-};
-#endif
-
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -291,6 +286,12 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
 	if (index < 3)
 		return;
+	if (boot_cpu_data.x86 == 0x11)
+		return;
+
+	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
+		return;
+
 	this_leaf->can_disable = 1;
 }
 
@@ -639,6 +640,68 @@ static ssize_t show_##file_name						\
 	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
 
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+		 unsigned int index)
+{
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	struct pci_dev *dev = k8_northbridges[node];
+	unsigned int reg = 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "%x\n", reg);
+}
+
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
+}
+
+static ssize_t
+store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
+		 size_t count, unsigned int index)
+{
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	struct pci_dev *dev = k8_northbridges[node];
+	unsigned long val = 0;
+	unsigned int scrubber = 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	val |= 0xc0000000;
+	pci_read_config_dword(dev, 0x58, &scrubber);
+	scrubber &= ~0x0f800000;
+	pci_write_config_dword(dev, 0x58, scrubber);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
+	wbinvd();
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	return count;
+}
+
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
+		 const char *buf, size_t count)			     	\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
+}
+
+SHOW_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
+STORE_CACHE_DISABLE(1)
+
 show_one_plus(level, eax.split.level, 0);
 show_one_plus(coherency_line_size, ebx.split.coherency_line_size, 1);
 show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
@@ -696,98 +759,6 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-#ifdef CONFIG_PCI
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	struct pci_dev *dev = NULL;
-	int i;
-
-	for (i = 0; i <= node; i++) {
-		do {
-			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-			if (!dev)
-				break;
-		} while (!pci_match_id(&k8_nb_id[0], dev));
-		if (!dev)
-			break;
-	}
-	return dev;
-}
-#else
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	return NULL;
-}
-#endif
-
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
-{
-	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
-	int node = cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev = NULL;
-	ssize_t ret = 0;
-	int i;
-
-	if (!this_leaf->can_disable)
-		return sprintf(buf, "Feature not enabled\n");
-
-	dev = get_k8_northbridge(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
-		return -EINVAL;
-	}
-
-	for (i = 0; i < 2; i++) {
-		unsigned int reg;
-
-		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
-
-		ret += sprintf(buf, "%sEntry: %d\n", buf, i);
-		ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",  
-			buf,
-			reg & 0x80000000 ? "Disabled" : "Allowed",
-			reg & 0x40000000 ? "Disabled" : "Allowed");
-		ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
-			buf, (reg & 0x30000) >> 16, reg & 0xfff);
-	}
-	return ret;
-}
-
-static ssize_t
-store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
-		    size_t count)
-{
-	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
-	int node = cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev = NULL;
-	unsigned int ret, index, val;
-
-	if (!this_leaf->can_disable)
-		return 0;
-
-	if (strlen(buf) > 15)
-		return -EINVAL;
-
-	ret = sscanf(buf, "%x %x", &index, &val);
-	if (ret != 2)
-		return -EINVAL;
-	if (index > 1)
-		return -EINVAL;
-
-	val |= 0xc0000000;
-	dev = get_k8_northbridge(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
-		return -EINVAL;
-	}
-
-	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
-	wbinvd();
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-
-	return 1;
-}
-
 struct _cache_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct _cpuid4_info *, char *);
@@ -808,7 +779,11 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-static struct _cache_attr cache_disable = __ATTR(cache_disable, 0644, show_cache_disable, store_cache_disable);
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		 show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		 show_cache_disable_1, store_cache_disable_1);
+
 
 static struct attribute * default_attrs[] = {
 	&type.attr,
@@ -820,7 +795,8 @@ static struct attribute * default_attrs[] = {
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
-	&cache_disable.attr,
+	&cache_disable_0.attr,
+	&cache_disable_1.attr,
 	NULL
 };
 

