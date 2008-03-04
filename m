Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbYCDQ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbYCDQ7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYCDQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:59:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYCDQ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:59:45 -0500
Date: Tue, 4 Mar 2008 17:59:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080304165928.GA17474@elte.hu>
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


Linus, please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks,

	Ingo

------------------>
Ian Campbell (1):
      x86/xen: fix DomU boot problem

Suresh Siddha (1):
      x86, i387: fix ptrace leakage using init_fpu()

Yinghai Lu (1):
      x86: not set node to cpu_to_node if the node is not online

 arch/x86/kernel/i387.c |    8 ++++----
 arch/x86/mm/numa_64.c  |    8 ++++++--
 arch/x86/xen/setup.c   |    3 ++-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 763dfc4..60fe801 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -132,7 +132,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	unlazy_fpu(target);
+	init_fpu(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.i387.fxsave, 0, -1);
@@ -147,7 +147,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	unlazy_fpu(target);
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
@@ -307,7 +307,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!HAVE_HWFP)
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
-	unlazy_fpu(target);
+	init_fpu(target);
 
 	if (!cpu_has_fxsr)
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
@@ -332,7 +332,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
-	unlazy_fpu(target);
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	if (!cpu_has_fxsr)
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 59898fb..8ccfee1 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -622,13 +622,17 @@ void __init init_cpu_to_node(void)
 	int i;
 
 	for (i = 0; i < NR_CPUS; i++) {
+		int node;
 		u16 apicid = x86_cpu_to_apicid_init[i];
 
 		if (apicid == BAD_APICID)
 			continue;
-		if (apicid_to_node[apicid] == NUMA_NO_NODE)
+		node = apicid_to_node[apicid];
+		if (node == NUMA_NO_NODE)
 			continue;
-		numa_set_node(i, apicid_to_node[apicid]);
+		if (!node_online(node))
+			continue;
+		numa_set_node(i, node);
 	}
 }
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 3bad477..2341492 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -38,7 +38,8 @@ char * __init xen_memory_setup(void)
 	unsigned long max_pfn = xen_start_info->nr_pages;
 
 	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
+	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
+	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
 
 	return "Xen";
 }
