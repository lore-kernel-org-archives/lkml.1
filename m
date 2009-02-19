Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZBSVrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZBSVrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZBSVq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:46:59 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42770 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbZBSVq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:46:58 -0500
X-BigFish: VPS-22(zz13e6S936eQ936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KFC1TL-01-S8Z-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: [PATCH][retry 1] Conform L3 Cache Index Disable to Linux standards
Date: Thu, 19 Feb 2009 15:46:22 -0600
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200902191546.22214.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 19 Feb 2009 21:46:43.0670 (UTC) FILETIME=[8E1F9F60:01C992DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ABI Documentation entry and fix some /sys directory formating
issues with the L3 Cache Index Disable feature for future AMD
processors.  Add a check to disable it for family 0x10 models
that do not support it yet.

diffed against 2.6.29-rc5-git3

-Mark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff -r 3c05ca868c9d Documentation/ABI/testing/sysfs-devices-cache_disable
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/Documentation/ABI/testing/sysfs-devices-cache_disable	Thu Feb 19 13:36:25 2009 -0600
@@ -0,0 +1,18 @@
+What:	    /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
+Date:	    August 2008
+KernelVersion:  2.6.27
+Contact:	 mark.langsd...@amd.com
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
+		 http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_do...
+		 for formatting information and other details on the
+		 cache index disable.
+Users:	   joachim.degu...@amd.com
diff -r 3c05ca868c9d arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c	Thu Feb 19 13:36:10 2009 -0600
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c	Thu Feb 19 13:48:49 2009 -0600
@@ -17,6 +17,9 @@
 
 #include <asm/processor.h>
 #include <asm/smp.h>
+
+#include <linux/pci.h>
+#include <asm/k8.h>
 
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
@@ -150,14 +153,6 @@ struct _cpuid4_info {
 	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
 };
 
-#ifdef CONFIG_PCI
-static struct pci_device_id k8_nb_id[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
-	{}
-};
-#endif
-
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -282,6 +277,12 @@ amd_check_l3_disable(int index, struct _
 {
 	if (index < 3)
 		return;
+	if (boot_cpu_data.x86 == 0x11)
+		return;
+
+	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x15))
+		return;
+
 	this_leaf->can_disable = 1;
 }
 
@@ -617,6 +618,64 @@ static ssize_t show_##file_name						\
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
@@ -673,96 +732,6 @@ static ssize_t show_type(struct _cpuid4_
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
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
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
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
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
@@ -783,7 +752,11 @@ define_one_ro(shared_cpu_map);
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
@@ -795,7 +768,8 @@ static struct attribute * default_attrs[
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
-	&cache_disable.attr,
+	&cache_disable_0.attr,
+	&cache_disable_1.attr,
 	NULL
 };
 

