Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYCSVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYCSVkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764239AbYCSUJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:09:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764144AbYCSUJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:09:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 ia32 ptrace vs -ENOSYS sysenter/syscall
In-Reply-To: Roland McGrath's message of  Sunday, 16 March 2008 21:57:41 -0700 <20080317045741.2F6A526F995@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20080317045741.2F6A526F995@magilla.localdomain>
Emacs: Lovecraft was an optimist.
Message-Id: <20080319012350.C00F826F995@magilla.localdomain>
Date: Tue, 18 Mar 2008 18:23:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous "x86_64 ia32 ptrace vs -ENOSYS" fix only covered
the int $0x80 system call entries.  This does the same fix
for the sysenter and syscall instruction paths.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index eafb0b9..b5e329d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -162,12 +162,14 @@ sysenter_tracesys:
 	SAVE_REST
 	CLEAR_RREGS
 	movq	%r9,R9(%rsp)
-	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
+	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl	%ebp,%r9d
+	cmpl	$(IA32_NR_syscalls-1),%eax
+	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -261,13 +263,15 @@ cstar_tracesys:
 	SAVE_REST
 	CLEAR_RREGS
 	movq %r9,R9(%rsp)
-	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
+	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
 	movl RSP-ARGOFFSET(%rsp), %r8d
+	cmpl $(IA32_NR_syscalls-1),%eax
+	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				
