Return-Path: <linux-kernel-owner+w=401wt.eu-S1764563AbYF0VlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764563AbYF0VlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761306AbYF0Vhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764222AbYF0VhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:17 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 10/39] rename threadinfo to TI
Date: Fri, 27 Jun 2008 18:34:17 -0300
Message-Id: <1214602486-17080-11-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-10-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is for consistency with i386.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/ia32/ia32entry.S        |   25 ++++++++++++++-----------
 arch/x86/kernel/asm-offsets_64.c |    2 +-
 arch/x86/kernel/entry_64.S       |   27 ++++++++++++++-------------
 arch/x86/lib/copy_user_64.S      |    4 ++--
 arch/x86/lib/getuser_64.S        |    8 ++++----
 arch/x86/lib/putuser_64.S        |    8 ++++----
 6 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 3aefbce..9bfea05 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -103,7 +103,7 @@ ENTRY(ia32_sysenter_target)
 	pushfq
 	CFI_ADJUST_CFA_OFFSET 8
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	8*3-THREAD_SIZE+threadinfo_sysenter_return(%rsp), %r10d
+	movl	8*3-THREAD_SIZE+TI_sysenter_return(%rsp), %r10d
 	CFI_REGISTER rip,r10
 	pushq	$__USER32_CS
 	CFI_ADJUST_CFA_OFFSET 8
@@ -123,8 +123,9 @@ ENTRY(ia32_sysenter_target)
  	.quad 1b,ia32_badarg
  	.previous	
 	GET_THREAD_INFO(%r10)
-	orl    $TS_COMPAT,threadinfo_status(%r10)
-	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	orl    $TS_COMPAT,TI_status(%r10)
+	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		 TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 sysenter_do_call:	
@@ -136,9 +137,9 @@ sysenter_do_call:
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
+	testl	$_TIF_ALLWORK_MASK,TI_flags(%r10)
 	jnz	int_ret_from_sys_call
-	andl    $~TS_COMPAT,threadinfo_status(%r10)
+	andl    $~TS_COMPAT,TI_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
@@ -230,8 +231,9 @@ ENTRY(ia32_cstar_target)
 	.quad 1b,ia32_badarg
 	.previous	
 	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,threadinfo_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	orl   $TS_COMPAT,TI_status(%r10)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 cstar_do_call:	
@@ -243,9 +245,9 @@ cstar_do_call:
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
+	testl $_TIF_ALLWORK_MASK,TI_flags(%r10)
 	jnz  int_ret_from_sys_call
-	andl $~TS_COMPAT,threadinfo_status(%r10)
+	andl $~TS_COMPAT,TI_status(%r10)
 	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
@@ -324,8 +326,9 @@ ENTRY(ia32_syscall)
 	   this could be a problem. */
 	SAVE_ARGS 0,0,1
 	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,threadinfo_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	orl   $TS_COMPAT,TI_status(%r10)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		TI_flags(%r10)
 	jnz ia32_tracesys
 ia32_do_syscall:	
 	cmpl $(IA32_NR_syscalls-1),%eax
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index a5bbec3..2fcc6ac 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -34,7 +34,7 @@ int main(void)
 	ENTRY(pid);
 	BLANK();
 #undef ENTRY
-#define ENTRY(entry) DEFINE(threadinfo_ ## entry, offsetof(struct thread_info, entry))
+#define ENTRY(entry) DEFINE(TI_ ## entry, offsetof(struct thread_info, entry))
 	ENTRY(flags);
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c035b20..b79cfc9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -277,13 +277,13 @@ ENTRY(ret_from_fork)
 	CFI_ADJUST_CFA_OFFSET -4
 	call schedule_tail
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	jnz rff_trace
 rff_action:	
 	RESTORE_REST
 	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
 	je   int_ret_from_sys_call
-	testl $_TIF_IA32,threadinfo_flags(%rcx)
+	testl $_TIF_IA32,TI_flags(%rcx)
 	jnz  int_ret_from_sys_call
 	RESTORE_TOP_OF_STACK %rdi,ARGOFFSET
 	jmp ret_from_sys_call
@@ -352,7 +352,8 @@ ENTRY(system_call_after_swapgs)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		TI_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
@@ -371,7 +372,7 @@ sysret_check:
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl threadinfo_flags(%rcx),%edx
+	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz  sysret_careful 
 	CFI_REMEMBER_STATE
@@ -455,10 +456,10 @@ int_ret_from_sys_call:
 int_with_check:
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
-	movl threadinfo_flags(%rcx),%edx
+	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz   int_careful
-	andl    $~TS_COMPAT,threadinfo_status(%rcx)
+	andl    $~TS_COMPAT,TI_status(%rcx)
 	jmp   retint_swapgs
 
 	/* Either reschedule or signal or syscall exit tracking needed. */
@@ -666,7 +667,7 @@ retint_with_reschedule:
 	movl $_TIF_WORK_MASK,%edi
 retint_check:
 	LOCKDEP_SYS_EXIT_IRQ
-	movl threadinfo_flags(%rcx),%edx
+	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	CFI_REMEMBER_STATE
 	jnz  retint_careful
@@ -764,7 +765,7 @@ retint_signal:
 	/* Returning to kernel space from exception. */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retexc_kernel)
-	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	testl $HARDNMI_MASK,TI_preempt_count(%rcx)
 	jz retint_kernel		/* Not nested over NMI ? */
 	testw $X86_EFLAGS_TF,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
 	jnz retint_kernel		/*
@@ -782,9 +783,9 @@ ENTRY(retexc_kernel)
 	/* Returning to kernel space. Check if we need preemption */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
-	cmpl $0,threadinfo_preempt_count(%rcx)
+	cmpl $0,TI_preempt_count(%rcx)
 	jnz  retint_restore_args
-	bt  $TIF_NEED_RESCHED,threadinfo_flags(%rcx)
+	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
 	jnc  retint_restore_args
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
@@ -945,7 +946,7 @@ paranoid_restore_no_nmi\trace:
 	jmp irq_return
 paranoid_restore\trace:
 	GET_THREAD_INFO(%rcx)
-	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	testl $HARDNMI_MASK,TI_preempt_count(%rcx)
 	jz paranoid_restore_no_nmi\trace	/* Nested over NMI ? */
 	testw $X86_EFLAGS_TF,EFLAGS-0(%rsp)	/* trap flag? */
 	jnz paranoid_restore_no_nmi\trace
@@ -953,7 +954,7 @@ paranoid_restore\trace:
 	INTERRUPT_RETURN_NMI_SAFE
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
-	movl threadinfo_flags(%rcx),%ebx
+	movl TI_flags(%rcx),%ebx
 	andl $_TIF_WORK_MASK,%ebx
 	jz paranoid_swapgs\trace
 	movq %rsp,%rdi			/* &pt_regs */
@@ -1051,7 +1052,7 @@ error_exit:
 	testl %eax,%eax
 	jne  retexc_kernel
 	LOCKDEP_SYS_EXIT_IRQ
-	movl  threadinfo_flags(%rcx),%edx
+	movl  TI_flags(%rcx),%edx
 	movl  $_TIF_WORK_MASK,%edi
 	andl  %edi,%edx
 	jnz  retint_careful
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index ee1c3f6..7eaaf01 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -40,7 +40,7 @@ ENTRY(copy_to_user)
 	movq %rdi,%rcx
 	addq %rdx,%rcx
 	jc  bad_to_user
-	cmpq threadinfo_addr_limit(%rax),%rcx
+	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_to_user
 	xorl %eax,%eax	/* clear zero flag */
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
@@ -65,7 +65,7 @@ ENTRY(copy_from_user)
 	movq %rsi,%rcx
 	addq %rdx,%rcx
 	jc  bad_from_user
-	cmpq threadinfo_addr_limit(%rax),%rcx
+	cmpq TI_addr_limit(%rax),%rcx
 	jae  bad_from_user
 	movl $1,%ecx	/* set zero flag */
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
index df37d3a..0ec7890 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser_64.S
@@ -37,7 +37,7 @@
 ENTRY(__get_user_1)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rdx)
-	cmpq threadinfo_addr_limit(%rdx),%rax
+	cmpq TI_addr_limit(%rdx),%rax
 	jae bad_get_user
 1:	movzb (%rax),%edx
 	xorl %eax,%eax
@@ -50,7 +50,7 @@ ENTRY(__get_user_2)
 	addq $1,%rax
 	jc bad_get_user
 	GET_THREAD_INFO(%rdx)
-	cmpq threadinfo_addr_limit(%rdx),%rax
+	cmpq TI_addr_limit(%rdx),%rax
 	jae bad_get_user
 2:	movzwl -1(%rax),%edx
 	xorl %eax,%eax
@@ -63,7 +63,7 @@ ENTRY(__get_user_4)
 	addq $3,%rax
 	jc bad_get_user
 	GET_THREAD_INFO(%rdx)
-	cmpq threadinfo_addr_limit(%rdx),%rax
+	cmpq TI_addr_limit(%rdx),%rax
 	jae bad_get_user
 3:	movl -3(%rax),%edx
 	xorl %eax,%eax
@@ -76,7 +76,7 @@ ENTRY(__get_user_8)
 	addq $7,%rax
 	jc bad_get_user
 	GET_THREAD_INFO(%rdx)
-	cmpq threadinfo_addr_limit(%rdx),%rax
+	cmpq TI_addr_limit(%rdx),%rax
 	jae	bad_get_user
 4:	movq -7(%rax),%rdx
 	xorl %eax,%eax
diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index 4989f5a..940796f 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -35,7 +35,7 @@
 ENTRY(__put_user_1)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%r8)
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%r8),%rcx
 	jae bad_put_user
 1:	movb %dl,(%rcx)
 	xorl %eax,%eax
@@ -48,7 +48,7 @@ ENTRY(__put_user_2)
 	GET_THREAD_INFO(%r8)
 	addq $1,%rcx
 	jc 20f
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%r8),%rcx
 	jae 20f
 	decq %rcx
 2:	movw %dx,(%rcx)
@@ -64,7 +64,7 @@ ENTRY(__put_user_4)
 	GET_THREAD_INFO(%r8)
 	addq $3,%rcx
 	jc 30f
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%r8),%rcx
 	jae 30f
 	subq $3,%rcx
 3:	movl %edx,(%rcx)
@@ -80,7 +80,7 @@ ENTRY(__put_user_8)
 	GET_THREAD_INFO(%r8)
 	addq $7,%rcx
 	jc 40f
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq TI_addr_limit(%r8),%rcx
 	jae 40f
 	subq $7,%rcx
 4:	movq %rdx,(%rcx)
-- 
1.5.5.1

