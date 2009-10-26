Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZJZPUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZJZPUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZJZPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:20:29 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52940 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZJZPU3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Mon, 26 Oct 2009 11:20:29 -0400
Message-Id: <4AE5CC4D020000780001BD13@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 26 Oct 2009 15:20:29 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@kernel.org>, "Roland McGrath" <roland@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86-64: fix register leak in 32-bit syscall
	 audting
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restoring %ebp after the call to audit_syscall_exit() is not only
unnecessary (because the register didn't get clobbered), but in the
sysenter case wasn't even doing the right thing: It loaded %ebp from a
location below the top of stack (RBP < ARGOFFSET), i.e. arbitrary
kernel data got passed back to user mode in the register.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <stable@kernel.org>

---
 arch/x86/ia32/ia32entry.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.32-rc5/arch/x86/ia32/ia32entry.S	2009-10-19 13:12:43.000000000 +0200
+++ 2.6.32-rc5-x86_64-ia32-syscall-audit-ebp/arch/x86/ia32/ia32entry.S	2009-10-19 09:36:39.000000000 +0200
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



