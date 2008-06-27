Return-Path: <linux-kernel-owner+w=401wt.eu-S1764617AbYF0Vlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764617AbYF0Vlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764244AbYF0Vhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764223AbYF0VhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:17 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 12/39] introduce __ASM_REG macro
Date: Fri, 27 Jun 2008 18:34:19 -0300
Message-Id: <1214602486-17080-13-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-12-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations in which the architecture wants to use the
register that represents its word-size, whatever it is. For those,
introduce __ASM_REG in asm.h, along with the first users _ASM_AX
and _ASM_DX. They have users waiting for it, namely the getuser
functions.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/getuser_32.S |   25 +++++++++++++------------
 arch/x86/lib/getuser_64.S |   36 ++++++++++++++++++------------------
 include/asm-x86/asm.h     |    3 +++
 3 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/lib/getuser_32.S b/arch/x86/lib/getuser_32.S
index 8200fde..2cc3cee 100644
--- a/arch/x86/lib/getuser_32.S
+++ b/arch/x86/lib/getuser_32.S
@@ -11,6 +11,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 
 /*
@@ -28,10 +29,10 @@
 .text
 ENTRY(__get_user_1)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%edx)
-	cmp TI_addr_limit(%edx),%eax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-1:	movzb (%eax),%edx
+1:	movzb (%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -39,12 +40,12 @@ ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	add $1,%eax
+	add $1,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%edx)
-	cmp TI_addr_limit(%edx),%eax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-2:	movzwl -1(%eax),%edx
+2:	movzwl -1(%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -52,12 +53,12 @@ ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	add $3,%eax
+	add $3,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%edx)
-	cmp TI_addr_limit(%edx),%eax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-3:	mov -3(%eax),%edx
+3:	mov -3(%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -66,7 +67,7 @@ ENDPROC(__get_user_4)
 bad_get_user:
 	CFI_STARTPROC
 	xor %edx,%edx
-	mov $-14,%eax
+	mov $-14,%_ASM_AX
 	ret
 	CFI_ENDPROC
 END(bad_get_user)
diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
index 6134752..63b0e5c 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser_64.S
@@ -13,14 +13,13 @@
 /*
  * __get_user_X
  *
- * Inputs:	%rcx contains the address.
+ * Inputs:	%rax contains the address.
  *		The register is modified, but all changes are undone
  *		before returning because the C code doesn't know about it.
  *
  * Outputs:	%rax is error code (0 or -EFAULT)
  *		%rdx contains zero-extended value
  * 
- * %r8 is destroyed.
  *
  * These functions should not modify any other registers,
  * as they get called from within inline assembly.
@@ -32,14 +31,15 @@
 #include <asm/errno.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 	.text
 ENTRY(__get_user_1)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%rdx)
-	cmp TI_addr_limit(%rdx),%rax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-1:	movzb (%rax),%edx
+1:	movzb (%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -47,12 +47,12 @@ ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	add $1,%rax
+	add $1,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%rdx)
-	cmp TI_addr_limit(%rdx),%rax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-2:	movzwl -1(%rax),%edx
+2:	movzwl -1(%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -60,12 +60,12 @@ ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	add $3,%rax
+	add $3,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%rdx)
-	cmp TI_addr_limit(%rdx),%rax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-3:	mov -3(%rax),%edx
+3:	mov -3(%_ASM_AX),%edx
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -73,12 +73,12 @@ ENDPROC(__get_user_4)
 
 ENTRY(__get_user_8)
 	CFI_STARTPROC
-	add $7,%rax
+	add $7,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%rdx)
-	cmp TI_addr_limit(%rdx),%rax
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae	bad_get_user
-4:	movq -7(%rax),%rdx
+4:	movq -7(%_ASM_AX),%_ASM_DX
 	xor %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -87,7 +87,7 @@ ENDPROC(__get_user_8)
 bad_get_user:
 	CFI_STARTPROC
 	xor %edx,%edx
-	mov $(-EFAULT),%rax
+	mov $(-EFAULT),%_ASM_AX
 	ret
 	CFI_ENDPROC
 END(bad_get_user)
diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
index 7093982..435402e 100644
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -14,6 +14,7 @@
 #endif
 
 #define __ASM_SIZE(inst)	__ASM_SEL(inst##l, inst##q)
+#define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
@@ -24,6 +25,8 @@
 #define _ASM_ADD	__ASM_SIZE(add)
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
+#define _ASM_AX		__ASM_REG(ax)
+#define _ASM_DX		__ASM_REG(dx)
 
 /* Exception table entry */
 # define _ASM_EXTABLE(from,to) \
-- 
1.5.5.1

