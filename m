Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbYF0Vhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbYF0Vhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764166AbYF0Vg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:36:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764096AbYF0Vg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:36:56 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 07/39] don't clobber r8 nor use rcx
Date: Fri, 27 Jun 2008 18:34:14 -0300
Message-Id: <1214602486-17080-8-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-7-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's really no reason to clobber r8 or pass the address in rcx.
We can safely use only two registers (which we already have to touch anyway)
to do the job.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/getuser_64.S    |   42 +++++++++++++++++++++---------------------
 include/asm-x86/uaccess_64.h |    3 +--
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
index 5448876..2b003d3 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser_64.S
@@ -36,10 +36,10 @@
 	.text
 ENTRY(__get_user_1)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	GET_THREAD_INFO(%rdx)
+	cmpq threadinfo_addr_limit(%rdx),%rax
 	jae bad_get_user
-1:	movzb (%rcx),%edx
+1:	movzb (%rax),%edx
 	xorl %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -47,48 +47,48 @@ ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $1,%rcx
+	GET_THREAD_INFO(%rdx)
+	addq $1,%rax
 	jc 20f
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq threadinfo_addr_limit(%rdx),%rax
 	jae 20f
-	decq   %rcx
-2:	movzwl (%rcx),%edx
+	decq   %rax
+2:	movzwl (%rax),%edx
 	xorl %eax,%eax
 	ret
-20:	decq    %rcx
+20:	decq    %rax
 	jmp	bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $3,%rcx
+	GET_THREAD_INFO(%rdx)
+	addq $3,%rax
 	jc 30f
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq threadinfo_addr_limit(%rdx),%rax
 	jae 30f
-	subq $3,%rcx
-3:	movl (%rcx),%edx
+	subq $3,%rax
+3:	movl (%rax),%edx
 	xorl %eax,%eax
 	ret
-30:	subq $3,%rcx
+30:	subq $3,%rax
 	jmp bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_4)
 
 ENTRY(__get_user_8)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $7,%rcx
+	GET_THREAD_INFO(%rdx)
+	addq $7,%rax
 	jc 40f
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	cmpq threadinfo_addr_limit(%rdx),%rax
 	jae	40f
-	subq	$7,%rcx
-4:	movq (%rcx),%rdx
+	subq	$7,%rax
+4:	movq (%rax),%rdx
 	xorl %eax,%eax
 	ret
-40:	subq $7,%rcx
+40:	subq $7,%rax
 	jmp bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_8)
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 83382c1..9049f4e 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -90,8 +90,7 @@ extern int fixup_exception(struct pt_regs *regs);
 #define __get_user_x(size, ret, x, ptr)		      \
 	asm volatile("call __get_user_" #size	      \
 		     : "=a" (ret),"=d" (x)	      \
-		     : "c" (ptr)		      \
-		     : "r8")
+		     : "0" (ptr))		      \
 
 /* Careful: we have to cast the result to the type of the pointer
  * for sign reasons */
-- 
1.5.5.1

