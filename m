Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbYGaO17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbYGaO17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYGaO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:27:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:36960 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbYGaO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=NH97QeCra08pO4g2Uq11bP4QfxANxt8yg7kJHLaSvzSJqo0nx+xoR3/klS3QJvCyHt
         KoaHffX6jsdwdA2AvT30OtR5RtGN/U88a6VaP8RcwVllsKpZn+ZBggmW96CeFK8H9VwC
         xQ2a7wOXwnC0MSNcsMpW2TwLF66NHSYrldrEw=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	<m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
Date: Thu, 31 Jul 2008 16:27:47 +0200
In-Reply-To: <alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 30 Jul 2008 10:29:32 -0700 (PDT)")
Message-ID: <m3abfyqgbg.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Ok, this is starting to look more reasonable. But you cannot split things 
> up like this per-file, because the end result doesn't _work_ with the 
> changes separated.
>
>> BYTES_LEFT_IN_PAGE macro returns PAGE_SIZE, not zero, when the address
>> is well aligned to page.
>
> Hmm. Why? If the address is aligned, then we shouldn't even tro to copy 
> any more, should we? We know we got a fault - and regardless of whether it 
> was because of some offset off the base pointer or not, if the base 
> pointer was at offset zero, it's going to be in the same page. So why try 
> to do an operation we know will fault again?

Yes, I see. I was messed, sorry. Your BYTES_LEFT_IN_PAGE works very
well, tested.

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
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index f4df6e7..d793900 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -161,23 +161,32 @@ EXPORT_SYMBOL(copy_in_user);
 /*
  * Try to copy last bytes and clear the rest if needed.
  * Since protection fault in copy_from/to_user is not a normal situation,
- * it is not necessary to optimize tail handling.
+ * it is not necessary to do low level optimization of tail handling.
  */
 unsigned long
-copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
+copy_user_handle_tail(char *dst, char *src, unsigned remainder, unsigned flags)
 {
 	char c;
-	unsigned zero_len;
+	unsigned max_copy = remainder;
 
-	for (; len; --len) {
-		if (__get_user_nocheck(c, from++, sizeof(char)))
+	/* Don't even bother trying to cross a page in user space! */
+	if (flags & DEST_IS_USERSPACE)
+		max_copy = min(max_copy, BYTES_LEFT_IN_PAGE(dst));
+	if (flags & SOURCE_IS_USERSPACE)
+		max_copy = min(max_copy, BYTES_LEFT_IN_PAGE(src));
+
+	while (max_copy--) {
+		if (__get_user(c, src))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user(c, dst))
 			break;
+		src++;
+		dst++;
+		remainder--;
 	}
 
-	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
-		if (__put_user_nocheck(c, to++, sizeof(char)))
-			break;
-	return len;
+	if (flags & CLEAR_REMAINDER)
+		memset(dst, 0, remainder);
+
+	return remainder;
 }
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 5cfd295..ea042f8 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -1,6 +1,16 @@
 #ifndef ASM_X86__UACCESS_64_H
 #define ASM_X86__UACCESS_64_H
 
+/* Flags for copy_user_handle_tail */
+#define CLEAR_REMAINDER		1
+#define DEST_IS_USERSPACE	2
+#define SOURCE_IS_USERSPACE	4
+
+#define BYTES_LEFT_IN_PAGE(ptr) \
+	(unsigned int)((PAGE_SIZE-1) & -(long)(ptr))
+
+#ifndef __ASSEMBLY__
+
 /*
  * User space memory access functions
  */
@@ -179,23 +189,26 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
-				unsigned size, int zerorest);
+				unsigned size, unsigned flags);
 
 static inline int __copy_from_user_nocache(void *dst, const void __user *src,
 					   unsigned size)
 {
 	might_sleep();
-	return __copy_user_nocache(dst, src, size, 1);
+	return __copy_user_nocache(dst, src, size, SOURCE_IS_USERSPACE
+						   | CLEAR_REMAINDER);
 }
 
 static inline int __copy_from_user_inatomic_nocache(void *dst,
 						    const void __user *src,
 						    unsigned size)
 {
-	return __copy_user_nocache(dst, src, size, 0);
+	return __copy_user_nocache(dst, src, size, SOURCE_IS_USERSPACE);
 }
 
 unsigned long
-copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest);
+copy_user_handle_tail(char *dst, char *src, unsigned remainder, unsigned flags);
+
+#endif /* __ASSEMBLY__ */
 
 #endif /* ASM_X86__UACCESS_64_H */

-- 
wbr, Vitaly
