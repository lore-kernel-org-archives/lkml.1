Return-Path: <linux-kernel-owner+w=401wt.eu-S1764500AbYF0Vl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764500AbYF0Vl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764247AbYF0Vhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761831AbYF0VhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:24 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 14/39] merge getuser asm functions
Date: Fri, 27 Jun 2008 18:34:21 -0300
Message-Id: <1214602486-17080-15-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-14-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getuser_32.S and getuser_64.S are merged into getuser.S

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/Makefile     |    2 +-
 arch/x86/lib/getuser.S    |  104 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/getuser_32.S |   79 ----------------------------------
 arch/x86/lib/getuser_64.S |  100 -------------------------------------------
 include/asm-x86/asm.h     |    4 +-
 5 files changed, 108 insertions(+), 181 deletions(-)
 create mode 100644 arch/x86/lib/getuser.S
 delete mode 100644 arch/x86/lib/getuser_32.S
 delete mode 100644 arch/x86/lib/getuser_64.S

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 700c2c3..bf990ca 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_SMP) := msr-on-cpu.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser_$(BITS).o putuser_$(BITS).o
+lib-y += usercopy_$(BITS).o getuser.o putuser_$(BITS).o
 lib-y += memcpy_$(BITS).o
 
 ifeq ($(CONFIG_X86_32),y)
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
new file mode 100644
index 0000000..ad37400
--- /dev/null
+++ b/arch/x86/lib/getuser.S
@@ -0,0 +1,104 @@
+/*
+ * __get_user functions.
+ *
+ * (C) Copyright 1998 Linus Torvalds
+ * (C) Copyright 2005 Andi Kleen
+ * (C) Copyright 2008 Glauber Costa
+ *
+ * These functions have a non-standard call interface
+ * to make them more efficient, especially as they
+ * return an error value in addition to the "real"
+ * return value.
+ */
+
+/*
+ * __get_user_X
+ *
+ * Inputs:	%[r|e]ax contains the address.
+ *		The register is modified, but all changes are undone
+ *		before returning because the C code doesn't know about it.
+ *
+ * Outputs:	%[r|e]ax is error code (0 or -EFAULT)
+ *		%[r|e]dx contains zero-extended value
+ *
+ *
+ * These functions should not modify any other registers,
+ * as they get called from within inline assembly.
+ */
+
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/page.h>
+#include <asm/errno.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/asm.h>
+
+	.text
+ENTRY(__get_user_1)
+	CFI_STARTPROC
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae bad_get_user
+1:	movzb (%_ASM_AX),%edx
+	xor %eax,%eax
+	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_1)
+
+ENTRY(__get_user_2)
+	CFI_STARTPROC
+	add $1,%_ASM_AX
+	jc bad_get_user
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae bad_get_user
+2:	movzwl -1(%_ASM_AX),%edx
+	xor %eax,%eax
+	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_2)
+
+ENTRY(__get_user_4)
+	CFI_STARTPROC
+	add $3,%_ASM_AX
+	jc bad_get_user
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae bad_get_user
+3:	mov -3(%_ASM_AX),%edx
+	xor %eax,%eax
+	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_4)
+
+#ifdef CONFIG_X86_64
+ENTRY(__get_user_8)
+	CFI_STARTPROC
+	add $7,%_ASM_AX
+	jc bad_get_user
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae	bad_get_user
+4:	movq -7(%_ASM_AX),%_ASM_DX
+	xor %eax,%eax
+	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_8)
+#endif
+
+bad_get_user:
+	CFI_STARTPROC
+	xor %edx,%edx
+	mov $(-EFAULT),%_ASM_AX
+	ret
+	CFI_ENDPROC
+END(bad_get_user)
+
+.section __ex_table,"a"
+	_ASM_PTR 1b,bad_get_user
+	_ASM_PTR 2b,bad_get_user
+	_ASM_PTR 3b,bad_get_user
+#ifdef CONFIG_X86_64
+	_ASM_PTR 4b,bad_get_user
+#endif
diff --git a/arch/x86/lib/getuser_32.S b/arch/x86/lib/getuser_32.S
deleted file mode 100644
index 2bb0a18..0000000
--- a/arch/x86/lib/getuser_32.S
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- * __get_user functions.
- *
- * (C) Copyright 1998 Linus Torvalds
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
- * __get_user_X
- *
- * Inputs:	%eax contains the address
- *
- * Outputs:	%eax is error code (0 or -EFAULT)
- *		%edx contains zero-extended value
- *
- * These functions should not modify any other registers,
- * as they get called from within inline assembly.
- */
-
-.text
-ENTRY(__get_user_1)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae bad_get_user
-1:	movzb (%_ASM_AX),%edx
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_1)
-
-ENTRY(__get_user_2)
-	CFI_STARTPROC
-	add $1,%_ASM_AX
-	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae bad_get_user
-2:	movzwl -1(%_ASM_AX),%edx
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_2)
-
-ENTRY(__get_user_4)
-	CFI_STARTPROC
-	add $3,%_ASM_AX
-	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae bad_get_user
-3:	mov -3(%_ASM_AX),%edx
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_4)
-
-bad_get_user:
-	CFI_STARTPROC
-	xor %edx,%edx
-	mov $-14,%_ASM_AX
-	ret
-	CFI_ENDPROC
-END(bad_get_user)
-
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_get_user
-	_ASM_PTR 2b,bad_get_user
-	_ASM_PTR 3b,bad_get_user
-.previous
diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
deleted file mode 100644
index e333884..0000000
--- a/arch/x86/lib/getuser_64.S
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * __get_user functions.
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
- * __get_user_X
- *
- * Inputs:	%rax contains the address.
- *		The register is modified, but all changes are undone
- *		before returning because the C code doesn't know about it.
- *
- * Outputs:	%rax is error code (0 or -EFAULT)
- *		%rdx contains zero-extended value
- * 
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
-	.text
-ENTRY(__get_user_1)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae bad_get_user
-1:	movzb (%_ASM_AX),%edx
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_1)
-
-ENTRY(__get_user_2)
-	CFI_STARTPROC
-	add $1,%_ASM_AX
-	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae bad_get_user
-2:	movzwl -1(%_ASM_AX),%edx
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_2)
-
-ENTRY(__get_user_4)
-	CFI_STARTPROC
-	add $3,%_ASM_AX
-	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae bad_get_user
-3:	mov -3(%_ASM_AX),%edx
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_4)
-
-ENTRY(__get_user_8)
-	CFI_STARTPROC
-	add $7,%_ASM_AX
-	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
-	jae	bad_get_user
-4:	movq -7(%_ASM_AX),%_ASM_DX
-	xor %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_8)
-
-bad_get_user:
-	CFI_STARTPROC
-	xor %edx,%edx
-	mov $(-EFAULT),%_ASM_AX
-	ret
-	CFI_ENDPROC
-END(bad_get_user)
-
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_get_user
-	_ASM_PTR 2b,bad_get_user
-	_ASM_PTR 3b,bad_get_user
-	_ASM_PTR 4b,bad_get_user
-.previous
diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
index 435402e..57750a9 100644
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -3,8 +3,10 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_EX_SEC	.section __ex_table
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
 #ifdef CONFIG_X86_32
@@ -30,7 +32,7 @@
 
 /* Exception table entry */
 # define _ASM_EXTABLE(from,to) \
-	" .section __ex_table,\"a\"\n" \
+	__ASM_EX_SEC	\
 	_ASM_ALIGN "\n" \
 	_ASM_PTR #from "," #to "\n" \
 	" .previous\n"
-- 
1.5.5.1

