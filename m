Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZGJUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZGJUhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZGJUhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:37:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZGJUhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:37:07 -0400
Date: Fri, 10 Jul 2009 22:36:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [GIT PULL, v2] core kernel fixes
Message-ID: <20090710203650.GA5950@elte.hu>
References: <20090710162848.GA26862@elte.hu> <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain> <20090710193110.GA28281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710193110.GA28281@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the v2 core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus-2

This has the overlap() bug(s) fixed. [ You might want to hold off on 
pulling this for a few hours, just in case the fresh dma-debug.c fix 
has any unexpected (and unprecedented) breakages. ]

 Thanks,

	Ingo

------------------>
Arnd Bergmann (1):
      signals: declare sys_rt_tgsigqueueinfo in syscalls.h

Ingo Molnar (2):
      dma-debug: Put all hash-chain locks into the same lock class
      dma-debug: Fix the overlap() function to be correct and readable

Joerg Roedel (1):
      dma-debug: fix off-by-one error in overlap function

Maynard Johnson (1):
      oprofile: reset bt_lost_no_mapping with other stats

Paul E. McKenney (1):
      rcu: Mark Hierarchical RCU no longer experimental

Robert Richter (1):
      x86/oprofile: rename kernel parameter for architectural perfmon to arch_perfmon


 Documentation/kernel-parameters.txt |    4 ++--
 arch/x86/oprofile/nmi_int.c         |    2 +-
 drivers/oprofile/oprofile_stats.c   |    1 +
 include/linux/syscalls.h            |    2 ++
 kernel/rcutree.c                    |    3 +--
 lib/dma-debug.c                     |   26 +++++++++++++-------------
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 92e1ab8..c59e965 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1728,8 +1728,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	oprofile.cpu_type=	Force an oprofile cpu type
 			This might be useful if you have an older oprofile
 			userland or if you want common events.
-			Format: { archperfmon }
-			archperfmon: [X86] Force use of architectural
+			Format: { arch_perfmon }
+			arch_perfmon: [X86] Force use of architectural
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b07dd8d..89b9a5c 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -390,7 +390,7 @@ static int __init p4_init(char **cpu_type)
 static int force_arch_perfmon;
 static int force_cpu_type(const char *str, struct kernel_param *kp)
 {
-	if (!strcmp(str, "archperfmon")) {
+	if (!strcmp(str, "arch_perfmon")) {
 		force_arch_perfmon = 1;
 		printk(KERN_INFO "oprofile: forcing architectural perfmon\n");
 	}
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index e1f6ce0..3c2270a 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -33,6 +33,7 @@ void oprofile_reset_stats(void)
 	atomic_set(&oprofile_stats.sample_lost_no_mm, 0);
 	atomic_set(&oprofile_stats.sample_lost_no_mapping, 0);
 	atomic_set(&oprofile_stats.event_lost_overflow, 0);
+	atomic_set(&oprofile_stats.bt_lost_no_mapping, 0);
 }
 
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fa4242c..80de700 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -321,6 +321,8 @@ asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct timespec __user *uts,
 				size_t sigsetsize);
+asmlinkage long sys_rt_tgsigqueueinfo(pid_t tgid, pid_t  pid, int sig,
+		siginfo_t __user *uinfo);
 asmlinkage long sys_kill(int pid, int sig);
 asmlinkage long sys_tgkill(int tgid, int pid, int sig);
 asmlinkage long sys_tkill(int pid, int sig);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0dccfbb..7717b95 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1533,7 +1533,7 @@ void __init __rcu_init(void)
 	int j;
 	struct rcu_node *rnp;
 
-	printk(KERN_WARNING "Experimental hierarchical RCU implementation.\n");
+	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
@@ -1546,7 +1546,6 @@ void __init __rcu_init(void)
 		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
 	/* Register notifier for non-boot CPUs */
 	register_cpu_notifier(&rcu_nb);
-	printk(KERN_WARNING "Experimental hierarchical RCU init done.\n");
 }
 
 module_param(blimit, int, 0);
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 3b93129..65b0d99 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -716,7 +716,7 @@ void dma_debug_init(u32 num_entries)
 
 	for (i = 0; i < HASH_SIZE; ++i) {
 		INIT_LIST_HEAD(&dma_entry_hash[i].list);
-		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
+		spin_lock_init(&dma_entry_hash[i].lock);
 	}
 
 	if (dma_debug_fs_init() != 0) {
@@ -856,22 +856,21 @@ static void check_for_stack(struct device *dev, void *addr)
 				"stack [addr=%p]\n", addr);
 }
 
-static inline bool overlap(void *addr, u64 size, void *start, void *end)
+static inline bool overlap(void *addr, unsigned long len, void *start, void *end)
 {
-	void *addr2 = (char *)addr + size;
+	unsigned long a1 = (unsigned long)addr;
+	unsigned long b1 = a1 + len;
+	unsigned long a2 = (unsigned long)start;
+	unsigned long b2 = (unsigned long)end;
 
-	return ((addr >= start && addr < end) ||
-		(addr2 >= start && addr2 < end) ||
-		((addr < start) && (addr2 >= end)));
+	return !(b1 <= a2 || a1 >= b2);
 }
 
-static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
+static void check_for_illegal_area(struct device *dev, void *addr, unsigned long len)
 {
-	if (overlap(addr, size, _text, _etext) ||
-	    overlap(addr, size, __start_rodata, __end_rodata))
-		err_printk(dev, NULL, "DMA-API: device driver maps "
-				"memory from kernel text or rodata "
-				"[addr=%p] [size=%llu]\n", addr, size);
+	if (overlap(addr, len, _text, _etext) ||
+	    overlap(addr, len, __start_rodata, __end_rodata))
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);
 }
 
 static void check_sync(struct device *dev,
@@ -969,7 +968,8 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 		entry->type = dma_debug_single;
 
 	if (!PageHighMem(page)) {
-		void *addr = ((char *)page_address(page)) + offset;
+		void *addr = page_address(page) + offset;
+
 		check_for_stack(dev, addr);
 		check_for_illegal_area(dev, addr, size);
 	}
