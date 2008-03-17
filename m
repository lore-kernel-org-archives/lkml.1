Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYCQE6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYCQE6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 00:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYCQE6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 00:58:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYCQE6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 00:58:18 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86_64 ia32 ptrace vs -ENOSYS
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Superstitious liver inquisitions
   (2) Ubiquitous intrinsic bogs
   (3) Methodical experimental whips
   (4) Perspicacious gumption condiments
Message-Id: <20080317045741.2F6A526F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 21:57:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we're stopped at syscall entry tracing, ptrace can change the %eax
value from -ENOSYS to something else.  If no system call is actually made
because the syscall number (now in orig_eax) is bad, then the %eax value
set by ptrace should be returned to the user.  But, instead it gets reset
to -ENOSYS again.  This is a regression from the native 32-bit kernel.

This change fixes it by leaving the return value alone after entry tracing.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b42d009..eafb0b9 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -325,7 +325,7 @@ ENTRY(ia32_syscall)
 	jnz ia32_tracesys
 ia32_do_syscall:	
 	cmpl $(IA32_NR_syscalls-1),%eax
-	ja  ia32_badsys
+	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 	IA32_ARG_FIXUP
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
@@ -335,7 +335,7 @@ ia32_sysret:
 ia32_tracesys:			 
 	SAVE_REST
 	CLEAR_RREGS
-	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
+	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
