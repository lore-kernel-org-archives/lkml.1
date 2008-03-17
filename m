Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYCQE7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYCQE7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 00:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYCQE7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 00:59:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYCQE7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 00:59:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86_64 ptrace vs -ENOSYS
In-Reply-To: Roland McGrath's message of  Sunday, 16 March 2008 21:57:41 -0700 <20080317045741.2F6A526F995@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20080317045741.2F6A526F995@magilla.localdomain>
X-Shopping-List: (1) Cancerous aspersions
   (2) Reverent sumptuous proteins
   (3) Subatomic guilt
   (4) Multitudinous insufficient faceers
Message-Id: <20080317045911.D241E26F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 21:59:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we're stopped at syscall entry tracing, ptrace can change the %rax
value from -ENOSYS to something else.  If no system call is actually made
because the syscall number (now in orig_rax) is bad, then we now always
reset %rax to -ENOSYS again.

This changes it to leave the return value alone after entry tracing.
That way, the %rax value set by ptrace is there to be seen in user mode
(or in syscall exit tracing).  This is consistent with what the 32-bit
kernel does.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c20c9e7..556a8df 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -319,19 +319,17 @@ badsys:
 	/* Do syscall tracing */
 tracesys:			 
 	SAVE_REST
-	movq $-ENOSYS,RAX(%rsp)
+	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
 	call syscall_trace_enter
 	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	cmpq $__NR_syscall_max,%rax
-	movq $-ENOSYS,%rcx
-	cmova %rcx,%rax
-	ja  1f
+	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
-1:	movq %rax,RAX-ARGOFFSET(%rsp)
+	movq %rax,RAX-ARGOFFSET(%rsp)
 	/* Use IRET because user could have changed frame */
 		
 /* 
