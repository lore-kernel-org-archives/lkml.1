Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbZCRObI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbZCRObI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZCROay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:30:54 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:51448 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZCROax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:30:53 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peter.oruba@amd.com, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       dmitry.adamushko@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       tigran@aivazian.fsnet.co.uk
Subject: Re: [tip:cpus4096] x86: microcode: cleanup
Date: Wed, 18 Mar 2009 10:30:28 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc8; KDE/4.2.0; i686; ; )
Cc: linux-tip-commits@vger.kernel.org
References: <200903111632.37279.rusty@rustcorp.com.au>
 <tip-4bae1967357bfc78a2fad1be5e81a4b868980ae6@git.kernel.org>
In-reply-to: <tip-4bae1967357bfc78a2fad1be5e81a4b868980ae6@git.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903181030.28859.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Ingo Molnar wrote:
>Commit-ID:  4bae1967357bfc78a2fad1be5e81a4b868980ae6
>Gitweb:    
> http://git.kernel.org/tip/4bae1967357bfc78a2fad1be5e81a4b868980ae6 Author: 
>    Ingo Molnar <mingo@elte.hu>
>AuthorDate: Wed, 11 Mar 2009 11:19:46 +0100
>Commit:     Ingo Molnar <mingo@elte.hu>
>CommitDate: Wed, 18 Mar 2009 13:51:17 +0100
>
>x86: microcode: cleanup
>
>Impact: cleanup
>
>Cc: Rusty Russell <rusty@rustcorp.com.au>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>Cc: Peter Oruba <peter.oruba@amd.com>
>LKML-Reference: <200903111632.37279.rusty@rustcorp.com.au>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
>---
> arch/x86/kernel/microcode_amd.c   |   43 +++++++++----------
> arch/x86/kernel/microcode_core.c  |   58 +++++++++++++-------------
> arch/x86/kernel/microcode_intel.c |   83
> +++++++++++++++++++++--------------- 3 files changed, 97 insertions(+), 87
> deletions(-)
>
>diff --git a/arch/x86/kernel/microcode_amd.c
> b/arch/x86/kernel/microcode_amd.c index c25fdb3..453b579 100644
>--- a/arch/x86/kernel/microcode_amd.c
>+++ b/arch/x86/kernel/microcode_amd.c
>@@ -12,31 +12,30 @@
>  *
>  *  Licensed under the terms of the GNU General Public
>  *  License version 2. See file COPYING for details.
>-*/
>-
>+ */
>+#include <linux/platform_device.h>
> #include <linux/capability.h>
>-#include <linux/kernel.h>
>-#include <linux/init.h>
>-#include <linux/sched.h>
>-#include <linux/cpumask.h>
>-#include <linux/module.h>
>-#include <linux/slab.h>
>-#include <linux/vmalloc.h>
> #include <linux/miscdevice.h>
>+#include <linux/firmware.h>
> #include <linux/spinlock.h>
>-#include <linux/mm.h>
>-#include <linux/fs.h>
>+#include <linux/cpumask.h>
>+#include <linux/pci_ids.h>
>+#include <linux/uaccess.h>
>+#include <linux/vmalloc.h>
>+#include <linux/kernel.h>
>+#include <linux/module.h>
> #include <linux/mutex.h>
>+#include <linux/sched.h>
>+#include <linux/init.h>
>+#include <linux/slab.h>
> #include <linux/cpu.h>
>-#include <linux/firmware.h>
>-#include <linux/platform_device.h>
> #include <linux/pci.h>
>-#include <linux/pci_ids.h>
>-#include <linux/uaccess.h>
>+#include <linux/fs.h>
>+#include <linux/mm.h>
>
>-#include <asm/msr.h>
>-#include <asm/processor.h>
> #include <asm/microcode.h>
>+#include <asm/processor.h>
>+#include <asm/msr.h>
>
> MODULE_DESCRIPTION("AMD Microcode Update Driver");
> MODULE_AUTHOR("Peter Oruba");
>@@ -72,8 +71,8 @@ struct microcode_header_amd {
> } __attribute__((packed));
>
> struct microcode_amd {
>-	struct microcode_header_amd hdr;
>-	unsigned int mpb[0];
>+	struct microcode_header_amd	hdr;
>+	unsigned int			mpb[0];
> };
>
> #define UCODE_MAX_SIZE			2048
>@@ -184,8 +183,8 @@ static int get_ucode_data(void *to, const u8 *from,
> size_t n) return 0;
> }
>
>-static void *get_next_ucode(const u8 *buf, unsigned int size,
>-			    unsigned int *mc_size)
>+static void *
>+get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
> {
> 	unsigned int total_size;
> 	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
>@@ -223,7 +222,6 @@ static void *get_next_ucode(const u8 *buf, unsigned int
> size, return mc;
> }
>
>-
> static int install_equiv_cpu_table(const u8 *buf)
> {
> 	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
>@@ -372,4 +370,3 @@ struct microcode_ops * __init init_amd_microcode(void)
> {
> 	return &microcode_amd_ops;
> }
>-
>diff --git a/arch/x86/kernel/microcode_core.c
> b/arch/x86/kernel/microcode_core.c index 9a8dbc0..a0f3851 100644
>--- a/arch/x86/kernel/microcode_core.c
>+++ b/arch/x86/kernel/microcode_core.c
>@@ -70,47 +70,47 @@
>  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
>  *		Thanks to Stuart Swales for pointing out this bug.
>  */
>+#include <linux/platform_device.h>
> #include <linux/capability.h>
>-#include <linux/kernel.h>
>-#include <linux/init.h>
>-#include <linux/sched.h>
>+#include <linux/miscdevice.h>
>+#include <linux/firmware.h>
> #include <linux/smp_lock.h>
>+#include <linux/spinlock.h>
> #include <linux/cpumask.h>
>-#include <linux/module.h>
>-#include <linux/slab.h>
>+#include <linux/uaccess.h>
> #include <linux/vmalloc.h>
>-#include <linux/miscdevice.h>
>-#include <linux/spinlock.h>
>-#include <linux/mm.h>
>-#include <linux/fs.h>
>+#include <linux/kernel.h>
>+#include <linux/module.h>
> #include <linux/mutex.h>
>+#include <linux/sched.h>
>+#include <linux/init.h>
>+#include <linux/slab.h>
> #include <linux/cpu.h>
>-#include <linux/firmware.h>
>-#include <linux/platform_device.h>
>+#include <linux/fs.h>
>+#include <linux/mm.h>
>
>-#include <asm/msr.h>
>-#include <asm/uaccess.h>
>-#include <asm/processor.h>
> #include <asm/microcode.h>
>+#include <asm/processor.h>
>+#include <asm/msr.h>
>
> MODULE_DESCRIPTION("Microcode Update Driver");
> MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
> MODULE_LICENSE("GPL");
>
>-#define MICROCODE_VERSION 	"2.00"
>+#define MICROCODE_VERSION	"2.00"
>
>-static struct microcode_ops *microcode_ops;
>+static struct microcode_ops	*microcode_ops;
>
> /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
> static DEFINE_MUTEX(microcode_mutex);
>
>-struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
>+struct ucode_cpu_info		ucode_cpu_info[NR_CPUS];
> EXPORT_SYMBOL_GPL(ucode_cpu_info);
>
> #ifdef CONFIG_MICROCODE_OLD_INTERFACE
> struct update_for_cpu {
>-	const void __user *buf;
>-	size_t size;
>+	const void __user	*buf;
>+	size_t			size;
> };
>
> static long update_for_cpu(void *_ufc)
>@@ -209,12 +209,12 @@ static void microcode_dev_exit(void)
>
> MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
> #else
>-#define microcode_dev_init() 0
>-#define microcode_dev_exit() do { } while (0)
>+#define microcode_dev_init()	0
>+#define microcode_dev_exit()	do { } while (0)
> #endif
>
> /* fake device for request_firmware */
>-static struct platform_device *microcode_pdev;
>+static struct platform_device	*microcode_pdev;
>
> static long reload_for_cpu(void *unused)
> {
>@@ -282,8 +282,8 @@ static struct attribute *mc_default_attrs[] = {
> };
>
> static struct attribute_group mc_attr_group = {
>-	.attrs = mc_default_attrs,
>-	.name = "microcode",
>+	.attrs		= mc_default_attrs,
>+	.name		= "microcode",
> };
>
> static void __microcode_fini_cpu(int cpu)
>@@ -353,7 +353,7 @@ static long microcode_update_cpu(void *unused)
> 	 */
> 	if (uci->valid) {
> 		err = microcode_resume_cpu(smp_processor_id());
>-	} else {
>+	} else {
> 		collect_cpu_info(smp_processor_id());
> 		if (uci->valid && system_state == SYSTEM_RUNNING)
> 			err = microcode_ops->request_microcode_fw(
>@@ -423,9 +423,9 @@ static int mc_sysdev_resume(struct sys_device *dev)
> }
>
> static struct sysdev_driver mc_sysdev_driver = {
>-	.add = mc_sysdev_add,
>-	.remove = mc_sysdev_remove,
>-	.resume = mc_sysdev_resume,
>+	.add		= mc_sysdev_add,
>+	.remove		= mc_sysdev_remove,
>+	.resume		= mc_sysdev_resume,
> };
>
> static __cpuinit int
>@@ -464,7 +464,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long
> action, void *hcpu) }
>
> static struct notifier_block __refdata mc_cpu_notifier = {
>-	.notifier_call = mc_cpu_callback,
>+	.notifier_call	= mc_cpu_callback,
> };
>
> static int __init microcode_init(void)
>diff --git a/arch/x86/kernel/microcode_intel.c
> b/arch/x86/kernel/microcode_intel.c index 5e9f4fc..149b9ec 100644
>--- a/arch/x86/kernel/microcode_intel.c
>+++ b/arch/x86/kernel/microcode_intel.c
>@@ -70,28 +70,28 @@
>  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
>  *		Thanks to Stuart Swales for pointing out this bug.
>  */
>+#include <linux/platform_device.h>
> #include <linux/capability.h>
>-#include <linux/kernel.h>
>-#include <linux/init.h>
>-#include <linux/sched.h>
>+#include <linux/miscdevice.h>
>+#include <linux/firmware.h>
> #include <linux/smp_lock.h>
>+#include <linux/spinlock.h>
> #include <linux/cpumask.h>
>-#include <linux/module.h>
>-#include <linux/slab.h>
>+#include <linux/uaccess.h>
> #include <linux/vmalloc.h>
>-#include <linux/miscdevice.h>
>-#include <linux/spinlock.h>
>-#include <linux/mm.h>
>-#include <linux/fs.h>
>+#include <linux/kernel.h>
>+#include <linux/module.h>
> #include <linux/mutex.h>
>+#include <linux/sched.h>
>+#include <linux/init.h>
>+#include <linux/slab.h>
> #include <linux/cpu.h>
>-#include <linux/firmware.h>
>-#include <linux/platform_device.h>
>-#include <linux/uaccess.h>
>+#include <linux/fs.h>
>+#include <linux/mm.h>
>
>-#include <asm/msr.h>
>-#include <asm/processor.h>
> #include <asm/microcode.h>
>+#include <asm/processor.h>
>+#include <asm/msr.h>
>
> MODULE_DESCRIPTION("Microcode Update Driver");
> MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
>@@ -129,12 +129,13 @@ struct extended_sigtable {
> 	struct extended_signature sigs[0];
> };
>
>-#define DEFAULT_UCODE_DATASIZE 	(2000)
>+#define DEFAULT_UCODE_DATASIZE	(2000)
> #define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
> #define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
> #define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
> #define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
> #define DWSIZE			(sizeof(u32))
>+
> #define get_totalsize(mc) \
> 	(((struct microcode_intel *)mc)->hdr.totalsize ? \
> 	 ((struct microcode_intel *)mc)->hdr.totalsize : \
>@@ -197,30 +198,31 @@ static inline int update_match_cpu(struct
> cpu_signature *csig, int sig, int pf) }
>
> static inline int
>-update_match_revision(struct microcode_header_intel *mc_header,	int rev)
>+update_match_revision(struct microcode_header_intel *mc_header, int rev)
> {
> 	return (mc_header->rev <= rev) ? 0 : 1;
> }
>
> static int microcode_sanity_check(void *mc)
> {
>+	unsigned long total_size, data_size, ext_table_size;
> 	struct microcode_header_intel *mc_header = mc;
> 	struct extended_sigtable *ext_header = NULL;
>-	struct extended_signature *ext_sig;
>-	unsigned long total_size, data_size, ext_table_size;
> 	int sum, orig_sum, ext_sigcount = 0, i;
>+	struct extended_signature *ext_sig;
>
> 	total_size = get_totalsize(mc_header);
> 	data_size = get_datasize(mc_header);
>+
> 	if (data_size + MC_HEADER_SIZE > total_size) {
> 		printk(KERN_ERR "microcode: error! "
>-			"Bad data size in microcode data file\n");
>+				"Bad data size in microcode data file\n");
> 		return -EINVAL;
> 	}
>
> 	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> 		printk(KERN_ERR "microcode: error! "
>-			"Unknown microcode update format\n");
>+				"Unknown microcode update format\n");
> 		return -EINVAL;
> 	}
> 	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
>@@ -318,11 +320,15 @@ get_matching_microcode(struct cpu_signature *cpu_sig,
> void *mc, int rev)
>
> static void apply_microcode(int cpu)
> {
>+	struct microcode_intel *mc_intel;
>+	struct ucode_cpu_info *uci;
> 	unsigned long flags;
> 	unsigned int val[2];
>-	int cpu_num = raw_smp_processor_id();
>-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>-	struct microcode_intel *mc_intel = uci->mc;
>+	int cpu_num;
>+
>+	cpu_num = raw_smp_processor_id();
>+	uci = ucode_cpu_info + cpu;
>+	mc_intel = uci->mc;
>
> 	/* We should bind the task to the CPU */
> 	BUG_ON(cpu_num != cpu);
>@@ -348,15 +354,17 @@ static void apply_microcode(int cpu)
> 	spin_unlock_irqrestore(&microcode_update_lock, flags);
> 	if (val[1] != mc_intel->hdr.rev) {
> 		printk(KERN_ERR "microcode: CPU%d update from revision "
>-			"0x%x to 0x%x failed\n", cpu_num, uci->cpu_sig.rev, val[1]);
>+				"0x%x to 0x%x failed\n",
>+			cpu_num, uci->cpu_sig.rev, val[1]);
> 		return;
> 	}
> 	printk(KERN_INFO "microcode: CPU%d updated from revision "
>-	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
>+			 "0x%x to 0x%x, date = %04x-%02x-%02x \n",
> 		cpu_num, uci->cpu_sig.rev, val[1],
> 		mc_intel->hdr.date & 0xffff,
> 		mc_intel->hdr.date >> 24,
> 		(mc_intel->hdr.date >> 16) & 0xff);
>+
> 	uci->cpu_sig.rev = val[1];
> }
>
>@@ -404,18 +412,23 @@ static int generic_load_microcode(int cpu, void *data,
> size_t size, leftover  -= mc_size;
> 	}
>
>-	if (new_mc) {
>-		if (!leftover) {
>-			if (uci->mc)
>-				vfree(uci->mc);
>-			uci->mc = (struct microcode_intel *)new_mc;
>-			pr_debug("microcode: CPU%d found a matching microcode update with"
>-				 " version 0x%x (current=0x%x)\n",
>-				cpu, new_rev, uci->cpu_sig.rev);
>-		} else
>-			vfree(new_mc);
>+	if (!new_mc)
>+		goto out;
>+
>+	if (leftover) {
>+		vfree(new_mc);
>+		goto out;
> 	}
>
>+	if (uci->mc)
>+		vfree(uci->mc);
>+	uci->mc = (struct microcode_intel *)new_mc;
>+
>+	pr_debug("microcode: CPU%d found a matching microcode update with"
>+		 " version 0x%x (current=0x%x)\n",
>+			cpu, new_rev, uci->cpu_sig.rev);
>+
>+ out:
> 	return (int)leftover;
> }
============================
I'll get some bounces as I'm not subbed to linux-tip-commit, but do I need to 
apply this patch to a plain .29-rc8?

All I am seeing now in dmesg is:
============================
[    0.655686] microcode: CPU0: patch_level=0x1000065
[    0.655702] microcode: CPU1: patch_level=0x1000065
[    0.655721] microcode: CPU2: patch_level=0x1000065
[    0.655742] microcode: CPU3: patch_level=0x1000065
[    0.655744] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, 
Peter Oruba
=============================================
And when this microcode first came out for AMD, I saw it update to 0x1000083 
for all 4 cores, and despite some powerdowns thanks to the MCP55 PHY killers 
in .29, I have not seen any indication of the code being applied since.

Thanks guys.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You will be misunderstood by everyone.

