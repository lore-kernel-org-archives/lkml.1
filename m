Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZA3XAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZA3XAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZA3XAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:00:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZA3XAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:00:37 -0500
Date: Sat, 31 Jan 2009 00:00:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090130230026.GA24150@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andreas Schwab (1):
      x86 setup: fix asm constraints in vesa_store_edid

H. Peter Anvin (1):
      x86: correct the CPUID pattern for MSR_IA32_MISC_ENABLE availability

Ingo Molnar (1):
      x86: tone down mtrr_trim_uncached_memory() warning

Jeremy Fitzhardinge (1):
      xen: make sysfs files behave as their names suggest


 arch/x86/boot/video-vesa.c      |   11 +++++------
 arch/x86/kernel/cpu/intel.c     |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c |    3 +--
 drivers/xen/balloon.c           |   33 ++++++++++++++++++++++++++++++++-
 4 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 7511584..4a58c8c 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -269,9 +269,8 @@ void vesa_store_edid(void)
 	   we genuinely have to assume all registers are destroyed here. */
 
 	asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
-	    : "+a" (ax), "+b" (bx)
-	    :  "c" (cx), "D" (di)
-	    : "esi");
+	    : "+a" (ax), "+b" (bx), "+c" (cx), "+D" (di)
+	    : : "esi", "edx");
 
 	if (ax != 0x004f)
 		return;		/* No EDID */
@@ -285,9 +284,9 @@ void vesa_store_edid(void)
 	dx = 0;			/* EDID block number */
 	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
 	asm(INT10
-	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info)
-	    : "c" (cx), "D" (di)
-	    : "esi");
+	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info),
+	      "+c" (cx), "+D" (di)
+	    : : "esi");
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 549f2ad..430e5c3 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -30,7 +30,7 @@
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	/* Unmask CPUID levels if masked: */
-	if (c->x86 == 6 && c->x86_model >= 15) {
+	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
 		u64 misc_enable;
 
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index d259e5d..236a401 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1594,8 +1594,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		WARN(!kvm_para_available(), KERN_WARNING
-				"WARNING: strange, CPU MTRRs all blank?\n");
+		printk(KERN_INFO "CPU MTRRs all blank - virtualized system.\n");
 		return 0;
 	}
 
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 2ba8f95..efa4b36 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -498,7 +498,7 @@ static ssize_t store_target_kb(struct sys_device *dev,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	target_bytes = memparse(buf, &endchar);
+	target_bytes = simple_strtoull(buf, &endchar, 0) * 1024;
 
 	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
 
@@ -508,8 +508,39 @@ static ssize_t store_target_kb(struct sys_device *dev,
 static SYSDEV_ATTR(target_kb, S_IRUGO | S_IWUSR,
 		   show_target_kb, store_target_kb);
 
+
+static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%llu\n",
+		       (u64)balloon_stats.target_pages << PAGE_SHIFT);
+}
+
+static ssize_t store_target(struct sys_device *dev,
+			    struct sysdev_attribute *attr,
+			    const char *buf,
+			    size_t count)
+{
+	char *endchar;
+	unsigned long long target_bytes;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	target_bytes = memparse(buf, &endchar);
+
+	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
+
+	return count;
+}
+
+static SYSDEV_ATTR(target, S_IRUGO | S_IWUSR,
+		   show_target, store_target);
+
+
 static struct sysdev_attribute *balloon_attrs[] = {
 	&attr_target_kb,
+	&attr_target,
 };
 
 static struct attribute *balloon_info_attrs[] = {
