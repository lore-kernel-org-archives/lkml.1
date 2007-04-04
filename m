Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXDEAVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXDEAVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXDEARt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:49 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36889 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932238AbXDEARC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:17:02 -0400
Message-Id: <20070404191205.778755309@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:12:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: [patch 11/20] Fix patch site clobbers to include return register
Content-Disposition: inline; filename=paravirt-fix-clobbers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few clobbers to include the return register.  The clobbers set
is the set of all registers modified (or may be modified) by the code
snippet, regardless of whether it was deliberate or accidental.

Also, make sure that callsites which are used in contexts which don't
allow clobbers actually save and restore all clobberable registers.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/entry.S    |    2 +-
 include/asm-i386/paravirt.h |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -342,7 +342,7 @@ 1:	movl (%ebp),%ebp
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
-	DISABLE_INTERRUPTS(CLBR_ECX|CLBR_EDX)
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -532,7 +532,7 @@ static inline unsigned long __raw_local_
 				  "popl %%edx; popl %%ecx")
 		     : "=a"(f)
 		     : paravirt_type(save_fl),
-		       paravirt_clobber(CLBR_NONE)
+		       paravirt_clobber(CLBR_EAX)
 		     : "memory", "cc");
 	return f;
 }
@@ -617,27 +617,29 @@ 772:;						\
 	.popsection
 
 #define INTERRUPT_RETURN					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_ANY,		\
+	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_NONE,		\
 		  jmp *%cs:paravirt_ops+PARAVIRT_iret)
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(PARAVIRT_irq_disable), clobbers,		\
-		  pushl %ecx; pushl %edx;				\
+		  pushl %eax; pushl %ecx; pushl %edx;			\
 		  call *%cs:paravirt_ops+PARAVIRT_irq_disable;		\
-		  popl %edx; popl %ecx)					\
+		  popl %edx; popl %ecx; popl %eax)			\
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable), clobbers,		\
-		  pushl %ecx; pushl %edx;				\
+		  pushl %eax; pushl %ecx; pushl %edx;			\
 		  call *%cs:paravirt_ops+PARAVIRT_irq_enable;		\
-		  popl %edx; popl %ecx)
+		  popl %edx; popl %ecx; popl %eax)
 
 #define ENABLE_INTERRUPTS_SYSEXIT					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_ANY,	\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_NONE,	\
 		  jmp *%cs:paravirt_ops+PARAVIRT_irq_enable_sysexit)
 
 #define GET_CR0_INTO_EAX			\
-	call *paravirt_ops+PARAVIRT_read_cr0
+	push %ecx; push %edx;			\
+	call *paravirt_ops+PARAVIRT_read_cr0;	\
+	pop %edx; pop %ecx
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */

-- 

