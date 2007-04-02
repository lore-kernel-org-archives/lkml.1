Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXDBGAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXDBGAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXDBF7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:59:15 -0400
Received: from gw.goop.org ([64.81.55.164]:38284 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933611AbXDBF7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:59:08 -0400
Message-Id: <20070402055704.967165514@goop.org>
References: <20070402055652.610711908@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 22:57:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: [patch 11/17] Fix patch site clobbers to include return register
Content-Disposition: inline; filename=paravirt-fix-clobbers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few clobbers to include the return register.  The clobbers set
is the set of all registers modified (or may be modified) by the code
snippet, regardless of whether it was deliberate or accidental.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/entry.S    |    2 +-
 include/asm-i386/paravirt.h |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

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
@@ -622,15 +622,15 @@ 772:;						\
 
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
 	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_ANY,	\

-- 

