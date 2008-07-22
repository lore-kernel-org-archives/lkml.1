Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYGVSC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYGVSC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYGVSCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:02:18 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:3807 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYGVSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:02:17 -0400
X-BigFish: VPS-60(z21eW37d4jz1432R9370T98dR1805M936fTzz10d3izzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K4F63C-01-4HD-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 01/01] x86: L3 cache index disable for 2.6.26
Date: Tue, 22 Jul 2008 13:06:02 -0500
User-Agent: KMail/1.9.9
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
References: <200807181603.52332.mark.langsdorf@amd.com> <20080721113706.GC23095@elte.hu> <20080721124812.GA25371@elte.hu>
In-Reply-To: <20080721124812.GA25371@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200807221306.03123.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 18:02:08.0663 (UTC) FILETIME=[0ED1BA70:01C8EC25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008, Ingo Molnar wrote:
> > applied to tip/x86/cpu, thanks Mark.
> > 
> > I've done some coding style fixes for the new functions you've 
> > introduced, see that commit below.
> 
> -tip testing found the following build failure:
> 
>  arch/x86/kernel/built-in.o: In function `show_cache_disable':
>  intel_cacheinfo.c:(.text+0xbbf2): undefined reference to `k8_northbridges'
>  arch/x86/kernel/built-in.o: In function `store_cache_disable':
>  intel_cacheinfo.c:(.text+0xbd91): undefined reference to `k8_northbridges'
> 
> please send a delta fix patch against the tip/x86/cpu branch:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> which has your patch plus the cleanup applied.

delta fix patch follows.  It removes the dependency on k8_northbridges.

-Mark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 491892c..08ee65a 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -13,10 +13,10 @@
 #include <linux/compiler.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/pci.h>
 
 #include <asm/processor.h>
 #include <asm/smp.h>
-#include <asm/k8.h>
 
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
@@ -135,6 +135,12 @@ struct _cpuid4_info {
 	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
 };
 
+static struct pci_device_id k8_nb_id[] = {
+        { PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
+        { PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+        {}
+};
+
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -655,16 +661,39 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf) {
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
+static struct pci_dev *get_k8_northbridge(int node)
+{
+	struct pci_dev *dev = NULL;
+	int i;
+
+	for (i = 0; i <= node; i++) {
+		do {
+			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
+			if (!dev)
+				break;
+		} while (!pci_match_id(&k8_nb_id[0], dev));
+		if (!dev)
+			break;
+	}
+	return dev;	
+}
+
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
 {
 	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
-	struct pci_dev *dev = k8_northbridges[node];
+	struct pci_dev *dev = NULL;
 	ssize_t ret = 0;
 	int i;
 
 	if (!this_leaf->can_disable)
 		return sprintf(buf, "Feature not enabled\n");
 
+	dev = get_k8_northbridge(node);
+	if (!dev) {
+		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+		return -EINVAL;
+	}
+
 	for (i = 0; i < 2; i++) {
 		unsigned int reg;
 
@@ -686,14 +715,12 @@ store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		    size_t count)
 {
 	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
-	struct pci_dev *dev = k8_northbridges[node];
+	struct pci_dev *dev = NULL;
 	unsigned int ret, index, val;
 
 	if (!this_leaf->can_disable)
 		return 0;
 
-	/* write the MSR value */
-
 	if (strlen(buf) > 15)
 		return -EINVAL;
 
@@ -704,6 +731,12 @@ store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		return -EINVAL;
 
 	val |= 0xc0000000;
+	dev = get_k8_northbridge(node);
+	if (!dev) {
+		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+		return -EINVAL;
+	}
+	
 	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
 	wbinvd();
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);

