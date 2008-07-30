Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYG3MN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYG3MN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYG3MNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:13:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:17355 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYG3MNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=BLLs35RzOdzYgxoo/sO53RMIk/dH8NhzNvpQ47VOXeu9FZUPmsjQy3W+toKSBSUfcP
         F3OaMn+zKWXWGWAyM59VykaI3J106CDLzgibmTPpDr3nD0bfV2jA2CDg5IuRUOFJ/V+c
         r9QlcqMNZ1RVDvHYjN6NFhxrabtqmeJcd/3pw=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
Date: Wed, 30 Jul 2008 14:13:22 +0200
In-Reply-To: <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 28 Jul 2008 08:48:41 -0700 (PDT)")
Message-ID: <m3d4kv604d.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 28 Jul 2008, Vitaly Mayatskikh wrote:
>>
>> Reduce protection faults count in copy_user_handle_tail routine by
>> limiting clear length to the end of page as was suggested by Linus.
>
> No, you did it wrong.

Pass direction and clear remainder flags to tail handling routine.
Fixed typos with using register r8d instead of ecx. Testl instruction
used for zero checks instead of andl as it generates more effective
microcode.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index dfdf428..4fbd9d5 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -9,12 +9,14 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 
+/* Align destination */
 #define FIX_ALIGNMENT 1
 
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/cpufeature.h>
+#include <asm/uaccess_64.h>
 
 	.macro ALTERNATIVE_JUMP feature,orig,alt
 0:
@@ -44,15 +46,16 @@
 	subl $8,%ecx
 	negl %ecx
 	subl %ecx,%edx
-100:	movb (%rsi),%al
-101:	movb %al,(%rdi)
+100:	movb (%rsi),%ah			/* al is flags */
+101:	movb %ah,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
 	jnz 100b
 102:
 	.section .fixup,"ax"
-103:	addl %r8d,%edx			/* ecx is zerorest also */
+103:	addl %ecx,%edx
+	movl %eax,%ecx
 	jmp copy_user_handle_tail
 	.previous
 
@@ -61,7 +64,7 @@
 	.quad 100b,103b
 	.quad 101b,103b
 	.previous
-#endif
+#endif /* FIX_ALIGNMENT */
 	.endm
 
 /* Standard copy_to_user with segment limit checking */
@@ -73,6 +76,7 @@ ENTRY(copy_to_user)
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_to_user
+	movl $(DEST_IS_USERSPACE),%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 
@@ -85,18 +89,21 @@ ENTRY(copy_from_user)
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_from_user
+	movl $(SOURCE_IS_USERSPACE | CLEAR_REMAINDER),%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(copy_from_user)
 
 ENTRY(copy_user_generic)
 	CFI_STARTPROC
+	movl $(SOURCE_IS_USERSPACE | DEST_IS_USERSPACE),%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(copy_user_generic)
 
 ENTRY(__copy_from_user_inatomic)
 	CFI_STARTPROC
+	movl $(SOURCE_IS_USERSPACE),%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(__copy_from_user_inatomic)
@@ -125,13 +132,15 @@ ENDPROC(bad_from_user)
  * Input:
  * rdi destination
  * rsi source
- * rdx count
+ * edx count
+ * ecx flags
  *
  * Output:
  * eax uncopied bytes or 0 if successfull.
  */
 ENTRY(copy_user_generic_unrolled)
 	CFI_STARTPROC
+	movl %ecx,%eax	/* save flags in eax */
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -169,11 +178,11 @@ ENTRY(copy_user_generic_unrolled)
 	leaq 8(%rdi),%rdi
 	decl %ecx
 	jnz 18b
-20:	andl %edx,%edx
+20:	testl %edx,%edx
 	jz 23f
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+21:	movb (%rsi),%ah		/* al is flags */
+22:	movb %ah,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
@@ -188,7 +197,8 @@ ENTRY(copy_user_generic_unrolled)
 40:	lea (%rdx,%rcx,8),%rdx
 	jmp 60f
 50:	movl %ecx,%edx
-60:	jmp copy_user_handle_tail /* ecx is zerorest also */
+60:	movl %eax,%ecx	/* get flags back to ecx*/
+	jmp copy_user_handle_tail
 	.previous
 
 	.section __ex_table,"a"
@@ -230,15 +240,15 @@ ENDPROC(copy_user_generic_unrolled)
  * Input:
  * rdi destination
  * rsi source
- * rdx count
+ * edx count
+ * ecx flags
  *
  * Output:
  * eax uncopied bytes or 0 if successful.
  */
 ENTRY(copy_user_generic_string)
 	CFI_STARTPROC
-	andl %edx,%edx
-	jz 4f
+	movl %ecx,%eax	/* save flags */
 	cmpl $8,%edx
 	jb 2f		/* less than 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -250,12 +260,13 @@ ENTRY(copy_user_generic_string)
 2:	movl %edx,%ecx
 3:	rep
 	movsb
-4:	xorl %eax,%eax
+	xorl %eax,%eax
 	ret
 
 	.section .fixup,"ax"
 11:	lea (%rdx,%rcx,8),%rcx
-12:	movl %ecx,%edx		/* ecx is zerorest also */
+12:	movl %ecx,%edx
+	movl %eax,%ecx	/* get flags back to ecx */
 	jmp copy_user_handle_tail
 	.previous
 
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 40e0e30..8703ccd 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -9,11 +9,13 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 
+/* Align destination */
 #define FIX_ALIGNMENT 1
 
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/uaccess_64.h>
 
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
@@ -24,15 +26,16 @@
 	subl $8,%ecx
 	negl %ecx
 	subl %ecx,%edx
-100:	movb (%rsi),%al
-101:	movb %al,(%rdi)
+100:	movb (%rsi),%ah			/* al is flags */
+101:	movb %ah,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
 	jnz 100b
 102:
 	.section .fixup,"ax"
-103:	addl %r8d,%edx			/* ecx is zerorest also */
+103:	addl %ecx,%edx
+	movl %eax,%ecx
 	jmp copy_user_handle_tail
 	.previous
 
@@ -41,7 +44,7 @@
 	.quad 100b,103b
 	.quad 101b,103b
 	.previous
-#endif
+#endif /* FIX_ALIGNMENT */
 	.endm
 
 /*
@@ -50,6 +53,7 @@
  */
 ENTRY(__copy_user_nocache)
 	CFI_STARTPROC
+	movl %ecx,%eax	/* save flags in eax */
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -87,11 +91,11 @@ ENTRY(__copy_user_nocache)
 	leaq 8(%rdi),%rdi
 	decl %ecx
 	jnz 18b
-20:	andl %edx,%edx
+20:	testl %edx,%edx
 	jz 23f
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+21:	movb (%rsi),%ah		/* al is flags */
+22:	movb %ah,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
@@ -108,7 +112,7 @@ ENTRY(__copy_user_nocache)
 	jmp 60f
 50:	movl %ecx,%edx
 60:	sfence
-	movl %r8d,%ecx
+	movl %eax,%ecx	/* get flags back to ecx*/
 	jmp copy_user_handle_tail
 	.previous
 
-- 
wbr, Vitaly
