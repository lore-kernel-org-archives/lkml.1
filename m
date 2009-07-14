Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZGNPzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZGNPzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZGNPzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:55:46 -0400
Received: from www.tglx.de ([62.245.132.106]:60307 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbZGNPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:55:46 -0400
Date: Tue, 14 Jul 2009 17:55:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86 fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907141754110.2777@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	tglx

------------------>
Dave Jones (1):
      x86: Fix warning in pvclock.c

Rakib Mullick (2):
      x86: Fix false positive section mismatch in es7000_32.c
      x86, apic: Fix false positive section mismatch in numaq_32.c

Roland Dreier (1):
      x86: Remove spurious printk level from segfault message


 arch/x86/kernel/apic/es7000_32.c |    3 ++-
 arch/x86/kernel/apic/numaq_32.c  |    3 ++-
 arch/x86/kernel/pvclock.c        |    2 +-
 arch/x86/mm/fault.c              |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 69328ac..8952a58 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -652,7 +652,8 @@ static int es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem,
 	return ret && es7000_apic_is_cluster();
 }
 
-struct apic apic_es7000_cluster = {
+/* We've been warned by a false positive warning.Use __refdata to keep calm. */
+struct apic __refdata apic_es7000_cluster = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 533e59c..ca96e68 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -493,7 +493,8 @@ static void numaq_setup_portio_remap(void)
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
-struct apic apic_numaq = {
+/* Use __refdata to keep false positive warning calm.	*/
+struct apic __refdata apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 4f9c55f..03801f2 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -60,7 +60,7 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 		"adc  %5,%%edx ; "
 		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
 		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
-#elif __x86_64__
+#elif defined(__x86_64__)
 	__asm__ (
 		"mul %%rdx ; shrd $32,%%rdx,%%rax"
 		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 85307cc..bfae139 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -697,7 +697,7 @@ show_signal_msg(struct pt_regs *regs, unsigned long error_code,
 	if (!printk_ratelimit())
 		return;
 
-	printk(KERN_CONT "%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
+	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
 		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
 		tsk->comm, task_pid_nr(tsk), address,
 		(void *)regs->ip, (void *)regs->sp, error_code);
