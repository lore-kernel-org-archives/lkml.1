Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbZKYNnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbZKYNnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964835AbZKYNnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:43:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:40167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471AbZKYNns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:43:48 -0500
Date: Wed, 25 Nov 2009 13:42:34 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       akpm@linux-foundation.org, tj@kernel.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu, cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, fweisbec@gmail.com,
       akpm@linux-foundation.org, tj@kernel.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, cl@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20091125115856.GA17856@elte.hu>
References: <20091125115856.GA17856@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Rename global percpu symbol dr7 to cpu_dr7
Message-ID: <tip-28b4e0d86acf59ae3bc422921138a4958458326e@git.kernel.org>
Git-Commit-ID: 28b4e0d86acf59ae3bc422921138a4958458326e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28b4e0d86acf59ae3bc422921138a4958458326e
Gitweb:     http://git.kernel.org/tip/28b4e0d86acf59ae3bc422921138a4958458326e
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 25 Nov 2009 22:24:44 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Nov 2009 14:30:04 +0100

x86: Rename global percpu symbol dr7 to cpu_dr7

Percpu symbols now occupy the same namespace as other global
symbols and as such short global symbols without subsystem
prefix tend to collide with local variables.  dr7 percpu
variable used by x86 was hit by this. Rename it to cpu_dr7.

The rename also makes it more consistent with its fellow
cpu_debugreg percpu variable.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20091125115856.GA17856@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/debugreg.h |    4 ++--
 arch/x86/kernel/hw_breakpoint.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index fdabd84..8240f76 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -75,7 +75,7 @@
  */
 #ifdef __KERNEL__
 
-DECLARE_PER_CPU(unsigned long, dr7);
+DECLARE_PER_CPU(unsigned long, cpu_dr7);
 
 static inline void hw_breakpoint_disable(void)
 {
@@ -91,7 +91,7 @@ static inline void hw_breakpoint_disable(void)
 
 static inline int hw_breakpoint_active(void)
 {
-	return __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK;
+	return __get_cpu_var(cpu_dr7) & DR_GLOBAL_ENABLE_MASK;
 }
 
 extern void aout_dump_debugregs(struct user *dump);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 4d267fb..92ea5aa 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -46,8 +46,8 @@
 #include <asm/debugreg.h>
 
 /* Per cpu debug control register value */
-DEFINE_PER_CPU(unsigned long, dr7);
-EXPORT_PER_CPU_SYMBOL(dr7);
+DEFINE_PER_CPU(unsigned long, cpu_dr7);
+EXPORT_PER_CPU_SYMBOL(cpu_dr7);
 
 /* Per cpu debug address registers values */
 static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
@@ -118,7 +118,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	set_debugreg(info->address, i);
 	__get_cpu_var(cpu_debugreg[i]) = info->address;
 
-	dr7 = &__get_cpu_var(dr7);
+	dr7 = &__get_cpu_var(cpu_dr7);
 	*dr7 |= encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
@@ -153,7 +153,7 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
 		return;
 
-	dr7 = &__get_cpu_var(dr7);
+	dr7 = &__get_cpu_var(cpu_dr7);
 	*dr7 &= ~encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
@@ -437,7 +437,7 @@ void hw_breakpoint_restore(void)
 	set_debugreg(__get_cpu_var(cpu_debugreg[2]), 2);
 	set_debugreg(__get_cpu_var(cpu_debugreg[3]), 3);
 	set_debugreg(current->thread.debugreg6, 6);
-	set_debugreg(__get_cpu_var(dr7), 7);
+	set_debugreg(__get_cpu_var(cpu_dr7), 7);
 }
 EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
 
