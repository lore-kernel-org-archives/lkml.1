Return-Path: <linux-kernel-owner+w=401wt.eu-S933723AbYF3Vo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbYF3Vo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbYF3VlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933445AbYF3Vk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:40:59 -0400
Message-ID: <486952BA.4090208@redhat.com>
Date: Mon, 30 Jun 2008 18:40:10 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 17/39] clobber rbx in putuser_64.S
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>	<1214602486-17080-3-git-send-email-gcosta@redhat.com>	<1214602486-17080-4-git-send-email-gcosta@redhat.com>	<1214602486-17080-5-git-send-email-gcosta@redhat.com>	<1214602486-17080-6-git-send-email-gcosta@redhat.com>	<1214602486-17080-7-git-send-email-gcosta@redhat.com>	<1214602486-17080-8-git-send-email-gcosta@redhat.com>	<1214602486-17080-9-git-send-email-gcosta@redhat.com>	<1214602486-17080-10-git-send-email-gcosta@redhat.com>	<1214602486-17080-11-git-send-email-gcosta@redhat.com>	<1214602486-17080-12-git-send-email-gcosta@redhat.com>	<1214602486-17080-13-git-send-email-gcosta@redhat.com>	<1214602486-17080-14-git-send-email-gcosta@redhat.com>	<1214602486-17080-15-git-send-email-gcosta@redhat.com>	<1214602486-17080-16-git-send-email-gcosta@redhat.com>	<1214602486-17080-17-git-send-email-gcosta@redhat.com>	<1214602486-17080-18-git-send-email-gcosta@redhat.com> <87abh5pxl6.fsf@basil.nowhere.org>
In-Reply-To: <87abh5pxl6.fsf@basil.nowhere.org>
Content-Type: multipart/mixed;
 boundary="------------050506070307050002070902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050506070307050002070902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
> Glauber Costa <gcosta@redhat.com> writes:
> 
>> Instead of clobbering r8, clobber rbx, which is the i386 way.
> 
> Note rbx is callee saved on 64bit, so using that one means
> the surrounding function always has to save explicitely.
> Not the case with r8.
> 
> There's a reason it is the way it is.
> 
> -Andi

Andi, how about this one ?

--------------050506070307050002070902
Content-Type: text/plain;
 name="0001-Use-r8-as-clobber-for-putuser-at-x86_64.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Use-r8-as-clobber-for-putuser-at-x86_64.patch"

>From d7162c0499da551b71c2894fa8357c148cc3b974 Mon Sep 17 00:00:00 2001
From: Glauber Costa <gcosta@redhat.com>
Date: Mon, 30 Jun 2008 18:30:32 -0300
Subject: [PATCH] Use r8 as clobber for putuser at x86_64.

As pointed out by Andi Kleen, we can do a little bit
better with putuser, regarding code generation. (As
a matter of fact, we used to.)

So use either r8 or ebx in the clobber list, depending
on which platform we are. This patch also provides comments
on the reasoning behind it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/lib/putuser.S    |   39 ++++++++++++++++++++++++++++-----------
 include/asm-x86/uaccess.h |   16 +++++++++-------
 2 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 36b0d15..896667d 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -30,14 +30,31 @@
  */
 
 #define ENTER	CFI_STARTPROC ; \
-		GET_THREAD_INFO(%_ASM_BX)
+		GET_THREAD_INFO(%SCRATCH_REG)
 #define EXIT	ret ; \
 		CFI_ENDPROC
 
+/*
+ * i386 calling convention determines that eax, ecx and edx belongs
+ * to the called function (caller-saved). This means that if we used any
+ * of those registers, the compiler would not need to save and restore it.
+ * However, all those registers are used for parameter passing in i386,
+ * and we have to trash one of them anyway. We randomly choose ebx.
+ *
+ * x86_64 has many more caller-saved registers, and we can pick one of them
+ * to use here. Again at random, we pick r8. This should lead to better code
+ * generation in the later platform.
+ */
+#ifdef CONFIG_X86_64
+#define SCRATCH_REG r8
+#else
+#define SCRATCH_REG ebx
+#endif
+
 .text
 ENTRY(__put_user_1)
 	ENTER
-	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
+	cmp TI_addr_limit(%SCRATCH_REG),%_ASM_CX
 	jae bad_put_user
 1:	movb %al,(%_ASM_CX)
 	xor %eax,%eax
@@ -46,9 +63,9 @@ ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub $1,%_ASM_BX
-	cmp %_ASM_BX,%_ASM_CX
+	mov TI_addr_limit(%SCRATCH_REG),%SCRATCH_REG
+	sub $1,%SCRATCH_REG
+	cmp %SCRATCH_REG,%_ASM_CX
 	jae bad_put_user
 2:	movw %ax,(%_ASM_CX)
 	xor %eax,%eax
@@ -57,9 +74,9 @@ ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub $3,%_ASM_BX
-	cmp %_ASM_BX,%_ASM_CX
+	mov TI_addr_limit(%SCRATCH_REG),%SCRATCH_REG
+	sub $3,%SCRATCH_REG
+	cmp %SCRATCH_REG,%_ASM_CX
 	jae bad_put_user
 3:	movl %eax,(%_ASM_CX)
 	xor %eax,%eax
@@ -68,9 +85,9 @@ ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
-	sub $7,%_ASM_BX
-	cmp %_ASM_BX,%_ASM_CX
+	mov TI_addr_limit(%SCRATCH_REG),%SCRATCH_REG
+	sub $7,%SCRATCH_REG
+	cmp %SCRATCH_REG,%_ASM_CX
 	jae bad_put_user
 4:	mov %_ASM_AX,(%_ASM_CX)
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index f6fa4d8..c00fbc3 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -178,12 +178,6 @@ extern int __get_user_bad(void);
 	__ret_gu;							\
 })
 
-#define __put_user_x(size, x, ptr, __ret_pu)			\
-	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
-		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
-
-
-
 #ifdef CONFIG_X86_32
 #define __put_user_u64(x, addr, err)					\
 	asm volatile("1:	movl %%eax,0(%2)\n"			\
@@ -201,17 +195,25 @@ extern int __get_user_bad(void);
 #define __put_user_x8(x, ptr, __ret_pu)				\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+#define PUT_USER_REG_CLOBBER	"ebx"
 #else
 #define __put_user_u64(x, ptr, retval) \
 	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
+#define PUT_USER_REG_CLOBBER	"r8"
 #endif
 
+#define __put_user_x(size, x, ptr, __ret_pu)			\
+	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
+		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr)	\
+		     : PUT_USER_REG_CLOBER )
+
 extern void __put_user_bad(void);
 
 /*
  * Strange magic calling convention: pointer in %ecx,
- * value in %eax(:%edx), return value in %eax. clobbers %rbx
+ * value in %eax(:%edx), return value in %eax.
+ * For clobbers, refer to the explanation at putuser.S
  */
 extern void __put_user_1(void);
 extern void __put_user_2(void);
-- 
1.5.5.1


--------------050506070307050002070902--
