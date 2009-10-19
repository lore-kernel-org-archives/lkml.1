Return-Path: <linux-kernel-owner+w=401wt.eu-S1750758AbZJSLmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750758AbZJSLmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZJSLmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:42:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:43513 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZJSLmp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Mon, 19 Oct 2009 07:42:45 -0400
Message-Id: <4ADC6D0C020000780001AAA9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 19 Oct 2009 12:43:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix another kernel data leak to 32-bit
	 processes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately I didn't realize that the other instances of branches to
int_ret_from_sys_call also need fixing when preparing the previous
similar patch. The issue fixed here was in fact introduced by an
earlier patch of mine (295286a89107c353b9677bc604361c537fd6a1c0, i.e.
in 2.6.28, but through stable now also present in 2.6.27), making
kernel stack contents potentially visible through R8...R11 when an
this or earlier syscall got interrupted prior to the handler being able
to decrement the stack pointer (such that the space normally used by
those registers within pt_regs would get overwritten by the interrupt
handler stub).

While touching the code, I also swapped the branch pairs so that the
static branch prediction logic would consider the syscall-number-in-
range case the taken path.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: stable@kernel.org 

---
 arch/x86/ia32/ia32entry.S |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.32-rc5/arch/x86/ia32/ia32entry.S	2009-10-19 13:12:43.000000000 +0200
+++ 2.6.32-rc5-x86_64-ia32-syscall-trace-reg-leak/arch/x86/ia32/ia32entry.S	2009-10-19 09:36:39.000000000 +0200
@@ -249,9 +249,9 @@ sysenter_tracesys:
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl	$(IA32_NR_syscalls-1),%eax
-	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
-	jmp	sysenter_do_call
+	cmpl	$IA32_NR_syscalls,%eax
+	jb	sysenter_do_call
+	jmp	ia32_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
 
@@ -368,9 +368,9 @@ cstar_tracesys:
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	cmpl $(IA32_NR_syscalls-1),%eax
-	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
-	jmp cstar_do_call
+	cmpl $IA32_NR_syscalls,%eax
+	jb cstar_do_call
+	jmp ia32_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 END(ia32_cstar_target)
 				
 ia32_badarg:
@@ -445,9 +445,9 @@ ia32_tracesys:			 
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl $(IA32_NR_syscalls-1),%eax
-	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
-	jmp ia32_do_call
+	cmpl $IA32_NR_syscalls,%eax
+	jb ia32_do_call
+	jmp ia32_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 END(ia32_syscall)
 
 ia32_badsys:



