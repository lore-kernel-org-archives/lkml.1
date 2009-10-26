Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZJZP0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZJZP0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZJZP0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:26:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:32778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZJZP0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:26:31 -0400
Date: Mon, 26 Oct 2009 15:24:51 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, jbeulich@novell.com, stable@kernel.org,
       JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, jbeulich@novell.com, stable@kernel.org,
       JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AE5CC4D020000780001BD13@vpn.id2.novell.com>
References: <4AE5CC4D020000780001BD13@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Fix register leak in 32-bit syscall audting
Message-ID: <tip-81766741fe1eee3884219e8daaf03f466f2ed52f@git.kernel.org>
Git-Commit-ID: 81766741fe1eee3884219e8daaf03f466f2ed52f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81766741fe1eee3884219e8daaf03f466f2ed52f
Gitweb:     http://git.kernel.org/tip/81766741fe1eee3884219e8daaf03f466f2ed52f
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 26 Oct 2009 15:20:29 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 16:23:26 +0100

x86-64: Fix register leak in 32-bit syscall audting

Restoring %ebp after the call to audit_syscall_exit() is not
only unnecessary (because the register didn't get clobbered),
but in the sysenter case wasn't even doing the right thing: It
loaded %ebp from a location below the top of stack (RBP <
ARGOFFSET), i.e. arbitrary kernel data got passed back to user
mode in the register.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <4AE5CC4D020000780001BD13@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/ia32/ia32entry.S |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 1733f9f..581b056 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -204,7 +204,7 @@ sysexit_from_sys_call:
 	movl RDI-ARGOFFSET(%rsp),%r8d	/* reload 5th syscall arg */
 	.endm
 
-	.macro auditsys_exit exit,ebpsave=RBP
+	.macro auditsys_exit exit
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
@@ -217,7 +217,6 @@ sysexit_from_sys_call:
 	call audit_syscall_exit
 	GET_THREAD_INFO(%r10)
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
-	movl \ebpsave-ARGOFFSET(%rsp),%ebp /* reload user register value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	cli
 	TRACE_IRQS_OFF
@@ -351,7 +350,7 @@ cstar_auditsys:
 	jmp cstar_dispatch
 
 sysretl_audit:
-	auditsys_exit sysretl_from_sys_call, RCX /* user %ebp in RCX slot */
+	auditsys_exit sysretl_from_sys_call
 #endif
 
 cstar_tracesys:
