Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZBKHbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZBKHbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZBKHbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:31:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:47311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZBKHbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:31:43 -0500
Message-ID: <49927EB4.3050507@kernel.org>
Date: Wed, 11 Feb 2009 16:31:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: [PATCH x86#core/percpu] x86: fix x86_32 stack protector bugs
References: <1234186798-16820-1-git-send-email-tj@kernel.org>	 <1234186798-16820-12-git-send-email-tj@kernel.org> <73c1f2160902100725w2503d693v5a3d1ae93ada75de@mail.gmail.com> <49919FA2.9050309@kernel.org>
In-Reply-To: <49919FA2.9050309@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 07:31:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix x86_32 stack protector

Brian Gerst found out that %gs was being initialized to stack_canary
instead of stack_canary - 20, which basically gave the same canary
value for all threads.  Fixing this also exposed the following bugs.

* cpu_idle() didn't call boot_init_stack_canary()

* stack canary switching in switch_to() was being done too late making
  the initial run of a new thread use the old stack canary value.

Fix all of them and while at it update comment in cpu_idle() about
calling boot_init_stack_canary().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/stackprotector.h |    2 +-
 arch/x86/include/asm/system.h         |    8 +++-----
 arch/x86/kernel/head_32.S             |    1 +
 arch/x86/kernel/process_32.c          |   10 ++++++++++
 arch/x86/kernel/process_64.c          |   11 +++++------
 5 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index fa7e5bd..c2d742c 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -85,7 +85,7 @@ static __always_inline void boot_init_stack_canary(void)
 static inline void setup_stack_canary_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
-	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu);
+	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu) - 20;
 	struct desc_struct *gdt_table = get_cpu_gdt_table(cpu);
 	struct desc_struct desc;
 
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2692ee8..7a80f72 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -25,13 +25,11 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #define __switch_canary							\
-	"movl "__percpu_arg([current_task])",%%ebx\n\t"			\
-	"movl %P[task_canary](%%ebx),%%ebx\n\t"				\
-	"movl %%ebx,"__percpu_arg([stack_canary])"\n\t"
+	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
+	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
 #define __switch_canary_oparam						\
 	, [stack_canary] "=m" (per_cpu_var(stack_canary))
 #define __switch_canary_iparam						\
-	, [current_task] "m" (per_cpu_var(current_task))		\
 	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
 #define __switch_canary
@@ -60,9 +58,9 @@ do {									\
 		     "movl %[next_sp],%%esp\n\t"	/* restore ESP   */ \
 		     "movl $1f,%[prev_ip]\n\t"	/* save    EIP   */	\
 		     "pushl %[next_ip]\n\t"	/* restore EIP   */	\
+		     __switch_canary					\
 		     "jmp __switch_to\n"	/* regparm call  */	\
 		     "1:\t"						\
-		     __switch_canary					\
 		     "popl %%ebp\n\t"		/* restore EBP   */	\
 		     "popfl\n"			/* restore flags */	\
 									\
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 924e316..cf21fd0 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -447,6 +447,7 @@ is386:	movl $2,%ecx		# set MP
 	jne 1f
 	movl $per_cpu__gdt_page,%eax
 	movl $per_cpu__stack_canary,%ecx
+	subl $20, %ecx
 	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
 	shrl $16, %ecx
 	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9a62383..b50604b 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -11,6 +11,7 @@
 
 #include <stdarg.h>
 
+#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -91,6 +92,15 @@ void cpu_idle(void)
 {
 	int cpu = smp_processor_id();
 
+	/*
+	 * If we're the non-boot CPU, nothing set the stack canary up
+	 * for us.  CPU0 already has it initialized but no harm in
+	 * doing it again.  This is a good place for updating it, as
+	 * we wont ever return from this function (so the invalid
+	 * canaries already on the stack wont ever trigger).
+	 */
+	boot_init_stack_canary();
+
 	current_thread_info()->status |= TS_POLLING;
 
 	/* endless idle loop with no priority at all */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 8eb169e..836ef65 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,12 +120,11 @@ void cpu_idle(void)
 	current_thread_info()->status |= TS_POLLING;
 
 	/*
-	 * If we're the non-boot CPU, nothing set the PDA stack
-	 * canary up for us - and if we are the boot CPU we have
-	 * a 0 stack canary. This is a good place for updating
-	 * it, as we wont ever return from this function (so the
-	 * invalid canaries already on the stack wont ever
-	 * trigger):
+	 * If we're the non-boot CPU, nothing set the stack canary up
+	 * for us.  CPU0 already has it initialized but no harm in
+	 * doing it again.  This is a good place for updating it, as
+	 * we wont ever return from this function (so the invalid
+	 * canaries already on the stack wont ever trigger).
 	 */
 	boot_init_stack_canary();
 
-- 
1.6.0.2

