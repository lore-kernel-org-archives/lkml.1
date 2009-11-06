Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZKFWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZKFWJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbZKFWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:53 -0500
Received: from kroah.org ([198.145.64.141]:39764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929AbZKFWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:52 2009
Message-Id: <20091106215951.964924845@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [15/30] x86-64: Fix register leak in 32-bit syscall audting
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=x86-64-fix-register-leak-in-32-bit-syscall-audting.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Beulich <JBeulich@novell.com>

commit 81766741fe1eee3884219e8daaf03f466f2ed52f upstream.

Restoring %ebp after the call to audit_syscall_exit() is not
only unnecessary (because the register didn't get clobbered),
but in the sysenter case wasn't even doing the right thing: It
loaded %ebp from a location below the top of stack (RBP <
ARGOFFSET), i.e. arbitrary kernel data got passed back to user
mode in the register.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Roland McGrath <roland@redhat.com>
LKML-Reference: <4AE5CC4D020000780001BD13@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/ia32/ia32entry.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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


