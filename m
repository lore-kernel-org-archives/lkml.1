Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZKYN1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZKYN1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZKYN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:27:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:48894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZKYN1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:27:33 -0500
Message-ID: <4B0D301C.30709@kernel.org>
Date: Wed, 25 Nov 2009 22:24:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: rename global percpu symbol dr7 to cpu_dr7
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <20091125105004.GA18163@elte.hu>
In-Reply-To: <20091125105004.GA18163@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu symbols now occupy the same namespace as other global symbols
and as such short global symbols without subsystem prefix tend to
collide with local variables.  dr7 percpu variable used by x86 was hit
by this.  Rename it to cpu_dr7.  The rename also makes it more
consistent with its fellow cpu_debugreg percpu variable.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
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
 
