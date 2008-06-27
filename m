Return-Path: <linux-kernel-owner+w=401wt.eu-S1764748AbYF0VqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764748AbYF0VqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764096AbYF0ViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760756AbYF0ViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:00 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 23/39] merge putuser asm functions
Date: Fri, 27 Jun 2008 18:34:30 -0300
Message-Id: <1214602486-17080-24-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-23-git-send-email-gcosta@redhat.com>
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
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
 <1214602486-17080-22-git-send-email-gcosta@redhat.com>
 <1214602486-17080-23-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

putuser_32.S and putuser_64.S are merged into putuser.S

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/Makefile     |    2 +-
 arch/x86/lib/putuser.S    |   97 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/putuser_32.S |   90 -----------------------------------------
 arch/x86/lib/putuser_64.S |   94 -------------------------------------------
 4 files changed, 98 insertions(+), 185 deletions(-)
 create mode 100644 arch/x86/lib/putuser.S
 delete mode 100644 arch/x86/lib/putuser_32.S
 delete mode 100644 arch/x86/lib/putuser_64.S

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index bf990ca..aa3fa41 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_SMP) := msr-on-cpu.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser.o putuser_$(BITS).o
+lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 
 ifeq ($(CONFIG_X86_32),y)
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
new file mode 100644
index 0000000..36b0d15
--- /dev/null
+++ b/arch/x86/lib/putuser.S
@@ -0,0 +1,97 @@
+/*
+ * __put_user functions.
+ *
+ * (C) Copyright 2005 Linus Torvalds
+ * (C) Copyright 2005 Andi Kleen
+ * (C) Copyright 2008 Glauber Costa
+ *
+ * These functions have a non-standard call interface
+ * to make them more efficient, especially as they
+ * return an error value in addition to the "real"
+ * return value.
+ */
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/asm.h>
+
+
+/*
+ * __put_user_X
+ *
+ * Inputs:	%eax[:%edx] contains the data
+ *		%ecx contains the address
+ *
+ * Outputs:	%eax is error code (0 or -EFAULT)
+ *
+ * These functions should not modify any other registers,
+ * as they get called from within inline assembly.
+ */
+
+#define ENTER	CFI_STARTPROC ; \
+		GET_THREAD_INFO(%_ASM_BX)
+#define EXIT	ret ; \
+		CFI_ENDPROC
+
+.text
+ENTRY(__put_user_1)
+	ENTER
+	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
+	jae bad_put_user
+1:	movb %al,(%_ASM_CX)
+	xor %eax,%eax
+	EXIT
+ENDPROC(__put_user_1)
+
+ENTRY(__put_user_2)
+	ENTER
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $1,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
+	jae bad_put_user
+2:	movw %ax,(%_ASM_CX)
+	xor %eax,%eax
+	EXIT
+ENDPROC(__put_user_2)
+
+ENTRY(__put_user_4)
+	ENTER
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $3,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
+	jae bad_put_user
+3:	movl %eax,(%_ASM_CX)
+	xor %eax,%eax
+	EXIT
+ENDPROC(__put_user_4)
+
+ENTRY(__put_user_8)
+	ENTER
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $7,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
+	jae bad_put_user
+4:	mov %_ASM_AX,(%_ASM_CX)
+#ifdef CONFIG_X86_32
+5:	movl %edx,4(%_ASM_CX)
+#endif
+	xor %eax,%eax
+	EXIT
+ENDPROC(__put_user_8)
+
+bad_put_user:
+	CFI_STARTPROC
+	movl $-EFAULT,%eax
+	EXIT
+END(bad_put_user)
+
+.section __ex_table,"a"
+	_ASM_PTR 1b,bad_put_user
+	_ASM_PTR 2b,bad_put_user
+	_ASM_PTR 3b,bad_put_user
+	_ASM_PTR 4b,bad_put_user
+#ifdef CONFIG_X86_32
+	_ASM_PTR 5b,bad_put_user
+#endif
+.previous
diff --git a/arch/x86/lib/putuser_32.S b/arch/x86/lib/putuser_32.S
deleted file mode 100644
index e7eda34..0000000
--- a/arch/x86/lib/putuser_32.S
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * __put_user functions.
- *
- * (C) Copyright 2005 Linus Torvalds
- *
- * These functions have a non-standard call interface
- * to make them more efficient, especially as they
- * return an error value in addition to the "real"
- * return value.
- */
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/thread_info.h>
-#include <asm/asm.h>
-
-
-/*
- * __put_user_X
- *
- * Inputs:	%eax[:%edx] contains the data
- *		%ecx contains the address
- *
- * Outputs:	%eax is error code (0 or -EFAULT)
- *
- * These functions should not modify any other registers,
- * as they get called from within inline assembly.
- */
-
-#define ENTER	CFI_STARTPROC ; \
-		GET_THREAD_INFO(%_ASM_BX)
-#define EXIT	ret ; \
-		CFI_ENDPROC
-
-.text
-ENTRY(__put_user_1)
-	ENTER
-	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
-	jae bad_put_user
-1:	movb %al,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_1)
-
-ENTRY(__put_user_2)
-	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub $1,%_ASM_BX
-	cmp %_ASM_BX,%_ASM_CX
-	jae bad_put_user
-2:	movw %ax,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_2)
-
-ENTRY(__put_user_4)
-	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub $3,%_ASM_BX
-	cmp %_ASM_BX,%_ASM_CX
-	jae bad_put_user
-3:	movl %eax,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_4)
-
-ENTRY(__put_user_8)
-	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub $7,%_ASM_BX
-	cmp %_ASM_BX,%_ASM_CX
-	jae bad_put_user
-4:	movl %_ASM_AX,(%_ASM_CX)
-5:	movl %edx,4(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_8)
-
-bad_put_user:
-	CFI_STARTPROC
-	movl $-14,%eax
-	EXIT
-END(bad_put_user)
-
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_put_user
-	_ASM_PTR 2b,bad_put_user
-	_ASM_PTR 3b,bad_put_user
-	_ASM_PTR 4b,bad_put_user
-	_ASM_PTR 5b,bad_put_user
-.previous
diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
deleted file mode 100644
index d496cc8..0000000
--- a/arch/x86/lib/putuser_64.S
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * __put_user functions.
- *
- * (C) Copyright 1998 Linus Torvalds
- * (C) Copyright 2005 Andi Kleen
- *
- * These functions have a non-standard call interface
- * to make them more efficient, especially as they
- * return an error value in addition to the "real"
- * return value.
- */
-
-/*
- * __put_user_X
- *
- * Inputs:	%rcx contains the address
- *		%rdx contains new value
- *
- * Outputs:	%rax is error code (0 or -EFAULT)
- *
- * %rbx is destroyed.
- *
- * These functions should not modify any other registers,
- * as they get called from within inline assembly.
- */
-
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/page.h>
-#include <asm/errno.h>
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-#include <asm/asm.h>
-
-#define ENTER   CFI_STARTPROC ; \
-                GET_THREAD_INFO(%_ASM_BX)
-#define EXIT    ret ; \
-                CFI_ENDPROC
-
-	.text
-ENTRY(__put_user_1)
-	ENTER
-	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
-	jae bad_put_user
-1:	movb %al,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_1)
-
-ENTRY(__put_user_2)
-	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub  $1, %_ASM_BX
-	cmp %_ASM_BX ,%_ASM_CX
-	jae  bad_put_user
-2:	movw %ax,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_2)
-
-ENTRY(__put_user_4)
-	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub  $3, %_ASM_BX
-	cmp  %_ASM_BX, %_ASM_CX
-	jae bad_put_user
-3:	movl %eax,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_4)
-
-ENTRY(__put_user_8)
-	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub  $7, %_ASM_BX
-	cmp  %_ASM_BX, %_ASM_CX
-	jae bad_put_user
-4:	movq %_ASM_AX,(%_ASM_CX)
-	xor %eax,%eax
-	EXIT
-ENDPROC(__put_user_8)
-
-bad_put_user:
-	CFI_STARTPROC
-	mov $(-EFAULT),%eax
-	EXIT
-END(bad_put_user)
-
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_put_user
-	_ASM_PTR 2b,bad_put_user
-	_ASM_PTR 3b,bad_put_user
-	_ASM_PTR 4b,bad_put_user
-.previous
-- 
1.5.5.1

