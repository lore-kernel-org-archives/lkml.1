Return-Path: <linux-kernel-owner+w=401wt.eu-S1763057AbYF3Pdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763057AbYF3Pdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762883AbYF3PbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:31:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762867AbYF3PbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:31:03 -0400
Date: Mon, 30 Jun 2008 17:30:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [git pull] x86 fixes
Message-ID: <20080630153038.GA19653@elte.hu>
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

Please pull the latest x86 fix git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Daniel J Blueman (1):
      x86: section/warning fixes

Max Asbock (1):
      x86: shift bits the right way in native_read_tscp

TAKADA Yoshihito (1):
      ptrace GET/SET FPXREGS broken

Zhang, Yanmin (1):
      x86: fix cpu hotplug crash

 arch/x86/kernel/i387.c    |    4 ++--
 arch/x86/kernel/smpboot.c |    1 -
 arch/x86/mm/init_64.c     |    8 ++++----
 include/asm-x86/msr.h     |    2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index eb9ddd8..95e80e5 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -162,7 +162,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -ENODEV;
+		return -EIO;
 
 	ret = init_fpu(target);
 	if (ret)
@@ -179,7 +179,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -ENODEV;
+		return -EIO;
 
 	ret = init_fpu(target);
 	if (ret)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 56078d6..3e1cece 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -996,7 +996,6 @@ do_rest:
 #endif
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
-		cpu_clear(cpu, cpu_possible_map);
 		cpu_clear(cpu, cpu_present_map);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 156e6d7..f6d20be 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -135,7 +135,7 @@ static __init void *spp_getpage(void)
 	return ptr;
 }
 
-static void
+static __init void
 set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 {
 	pgd_t *pgd;
@@ -214,7 +214,7 @@ void __init cleanup_highmap(void)
 }
 
 /* NOTE: this is meant to be run only at boot */
-void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
+void __init __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
 {
 	unsigned long address = __fix_to_virt(idx);
 
@@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	u64 t_start, t_size;
+	unsigned long t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
@@ -525,7 +525,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
+			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
 				t_start, t_start + t_size, pattern);
 
 			memtest(t_start, t_size, pattern);
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 3707650..2b5f2c9 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -18,7 +18,7 @@ static inline unsigned long long native_read_tscp(unsigned int *aux)
 	unsigned long low, high;
 	asm volatile(".byte 0x0f,0x01,0xf9"
 		     : "=a" (low), "=d" (high), "=c" (*aux));
-	return low | ((u64)high >> 32);
+	return low | ((u64)high << 32);
 }
 
 /*
