Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXLDQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXLDQmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXLDQmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:42:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXLDQmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:42:03 -0500
Date: Tue, 4 Dec 2007 17:41:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [git pull] x86 fixes
Message-ID: <20071204164143.GA2798@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

4 commits: a Kconfig fix for CONFIG_M8K, a warning-message printout 
tweak/fix, and two section fixes. This empties the x86 queue of pending 
2.6.24 fixes for now. Thanks,

	Ingo

------------------>
Adrian Bunk (2):
      x86: revert CONFIG_X86_HT semantics change
      x86: free_cache_attributes() section fix

Andrew Morton (1):
      x86: arch_register_cpu() section fix

Don Zickus (1):
      x86: add the word 'WARNING' in check_nmi_watchdog() output

 Kconfig                      |    3 ++-
 kernel/cpu/intel_cacheinfo.c |    2 +-
 kernel/nmi_32.c              |    3 ++-
 kernel/nmi_64.c              |    3 ++-
 kernel/topology.c            |    5 +++--
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 368864d..391cb18 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -148,7 +148,8 @@ config X86_SMP
 
 config X86_HT
 	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER || MK8)
+	depends on SMP
+	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || (X86_64 && !MK8)
 	default y
 
 config X86_BIOS_REBOOT
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 9921b01..606fe4d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -497,7 +497,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
 static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
-static void free_cache_attributes(unsigned int cpu)
+static void __cpuinit free_cache_attributes(unsigned int cpu)
 {
 	int i;
 
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index f5cc47c..80ca72e 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -106,7 +106,8 @@ static int __init check_nmi_watchdog(void)
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
-			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
+				"appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
 				nmi_count(cpu));
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index a576fd7..4253c4e 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -109,7 +109,8 @@ int __init check_nmi_watchdog (void)
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (cpu_pda(cpu)->__nmi_count - counts[cpu] <= 5) {
-			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
+			       "appears to be stuck (%d->%d)!\n",
 			       cpu,
 			       counts[cpu],
 			       cpu_pda(cpu)->__nmi_count);
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 8caa0b7..7e16d67 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -33,7 +33,7 @@
 
 static struct i386_cpu cpu_devices[NR_CPUS];
 
-int arch_register_cpu(int num)
+int __cpuinit arch_register_cpu(int num)
 {
 	/*
 	 * CPU0 cannot be offlined due to several
@@ -53,7 +53,8 @@ int arch_register_cpu(int num)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-void arch_unregister_cpu(int num) {
+void arch_unregister_cpu(int num)
+{
 	return unregister_cpu(&cpu_devices[num].cpu);
 }
 EXPORT_SYMBOL(arch_register_cpu);
