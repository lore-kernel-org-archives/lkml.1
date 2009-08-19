Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZHSHsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZHSHsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZHSHsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:48:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15783 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZHSHsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:48:52 -0400
Message-Id: <4A8BCA850200007800010836@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 19 Aug 2009 08:48:53 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make use of inc/dec conditional
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to gcc's instruction selection, inc/dec can be used without
penalty on most CPU models, but should be avoided on others. Hence we
should have a config option controlling the use of inc/dec, and
respective abstraction macros to avoid making the resulting code too
ugly. There are a few instances of inc/dec that must be retained in
assembly code, due to that code's dependency on the instruction not
changing the carry flag.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig.cpu                |    4 ++++
 arch/x86/include/asm/asm.h          |   27 +++++++++++++++++++++++++++
 arch/x86/include/asm/atomic_32.h    |    8 ++++----
 arch/x86/include/asm/atomic_64.h    |   16 ++++++++--------
 arch/x86/include/asm/checksum_32.h  |    2 +-
 arch/x86/include/asm/spinlock.h     |    6 +++---
 arch/x86/lib/checksum_32.S          |   11 ++++++-----
 arch/x86/lib/clear_page_64.S        |    3 ++-
 arch/x86/lib/copy_page_64.S         |    5 +++--
 arch/x86/lib/copy_user_64.S         |   17 +++++++++--------
 arch/x86/lib/copy_user_nocache_64.S |   17 +++++++++--------
 arch/x86/lib/memcpy_64.S            |   11 ++++++-----
 arch/x86/lib/memset_64.S            |    7 ++++---
 arch/x86/lib/rwlock_64.S            |    5 +++--
 arch/x86/lib/semaphore_32.S         |    7 ++++---
 arch/x86/lib/string_32.c            |   23 ++++++++++++-----------
 arch/x86/lib/strstr_32.c            |    5 +++--
 17 files changed, 108 insertions(+), 66 deletions(-)

--- linux-2.6.31-rc6/arch/x86/Kconfig.cpu	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/Kconfig.cpu	2009-08-10 14:43:44.000000000 +0200
@@ -399,6 +399,10 @@ config X86_CMOV
 	def_bool y
 	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
 
+config X86_INCDEC
+	def_bool y
+	depends on CC_OPTIMIZE_FOR_SIZE || !(X86_GENERIC || GENERIC_CPU || MPENTIUM4 || MPSC)
+
 config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
--- linux-2.6.31-rc6/arch/x86/include/asm/asm.h	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/include/asm/asm.h	2009-08-10 15:10:21.000000000 +0200
@@ -3,9 +3,11 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_FORM_(x)	x,
 # define __ASM_EX_SEC	.section __ex_table
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_FORM_(x)	" " #x ","
 # define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
@@ -22,8 +24,13 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#ifdef CONFIG_X86_INCDEC
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
+#else
+#define _ASM_INC	__ASM_SIZE(add) __ASM_FORM_($1)
+#define _ASM_DEC	__ASM_SIZE(sub) __ASM_FORM_($1)
+#endif
 #define _ASM_ADD	__ASM_SIZE(add)
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
@@ -44,4 +51,24 @@
 	_ASM_PTR #from "," #to "\n" \
 	" .previous\n"
 
+#ifdef CONFIG_X86_INCDEC
+#define _ASM_INCB	__ASM_FORM(incb)
+#define _ASM_INCW	__ASM_FORM(incw)
+#define _ASM_INCL	__ASM_FORM(incl)
+#define _ASM_INCQ	__ASM_FORM(incq)
+#define _ASM_DECB	__ASM_FORM(decb)
+#define _ASM_DECW	__ASM_FORM(decw)
+#define _ASM_DECL	__ASM_FORM(decl)
+#define _ASM_DECQ	__ASM_FORM(decq)
+#else
+#define _ASM_INCB	__ASM_FORM(addb) __ASM_FORM_($1)
+#define _ASM_INCW	__ASM_FORM(addw) __ASM_FORM_($1)
+#define _ASM_INCL	__ASM_FORM(addl) __ASM_FORM_($1)
+#define _ASM_INCQ	__ASM_FORM(addq) __ASM_FORM_($1)
+#define _ASM_DECB	__ASM_FORM(subb) __ASM_FORM_($1)
+#define _ASM_DECW	__ASM_FORM(subw) __ASM_FORM_($1)
+#define _ASM_DECL	__ASM_FORM(subl) __ASM_FORM_($1)
+#define _ASM_DECQ	__ASM_FORM(subq) __ASM_FORM_($1)
+#endif
+
 #endif /* _ASM_X86_ASM_H */
--- linux-2.6.31-rc6/arch/x86/include/asm/atomic_32.h	2009-08-18 15:31:15.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/include/asm/atomic_32.h	2009-08-10 14:26:03.000000000 +0200
@@ -91,7 +91,7 @@ static inline int atomic_sub_and_test(in
  */
 static inline void atomic_inc(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "incl %0"
+	asm volatile(LOCK_PREFIX _ASM_INCL "%0"
 		     : "+m" (v->counter));
 }
 
@@ -103,7 +103,7 @@ static inline void atomic_inc(atomic_t *
  */
 static inline void atomic_dec(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "decl %0"
+	asm volatile(LOCK_PREFIX _ASM_DECL "%0"
 		     : "+m" (v->counter));
 }
 
@@ -119,7 +119,7 @@ static inline int atomic_dec_and_test(at
 {
 	unsigned char c;
 
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+	asm volatile(LOCK_PREFIX _ASM_DECL "%0; sete %1"
 		     : "+m" (v->counter), "=qm" (c)
 		     : : "memory");
 	return c != 0;
@@ -137,7 +137,7 @@ static inline int atomic_inc_and_test(at
 {
 	unsigned char c;
 
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
+	asm volatile(LOCK_PREFIX _ASM_INCL "%0; sete %1"
 		     : "+m" (v->counter), "=qm" (c)
 		     : : "memory");
 	return c != 0;
--- linux-2.6.31-rc6/arch/x86/include/asm/atomic_64.h	2009-08-18 15:31:15.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/include/asm/atomic_64.h	2009-08-10 14:27:30.000000000 +0200
@@ -90,7 +90,7 @@ static inline int atomic_sub_and_test(in
  */
 static inline void atomic_inc(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "incl %0"
+	asm volatile(LOCK_PREFIX _ASM_INCL "%0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
@@ -103,7 +103,7 @@ static inline void atomic_inc(atomic_t *
  */
 static inline void atomic_dec(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "decl %0"
+	asm volatile(LOCK_PREFIX _ASM_DECL "%0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
@@ -120,7 +120,7 @@ static inline int atomic_dec_and_test(at
 {
 	unsigned char c;
 
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+	asm volatile(LOCK_PREFIX _ASM_DECL "%0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
 		     : "m" (v->counter) : "memory");
 	return c != 0;
@@ -138,7 +138,7 @@ static inline int atomic_inc_and_test(at
 {
 	unsigned char c;
 
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
+	asm volatile(LOCK_PREFIX _ASM_INCL "%0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
 		     : "m" (v->counter) : "memory");
 	return c != 0;
@@ -270,7 +270,7 @@ static inline int atomic64_sub_and_test(
  */
 static inline void atomic64_inc(atomic64_t *v)
 {
-	asm volatile(LOCK_PREFIX "incq %0"
+	asm volatile(LOCK_PREFIX _ASM_INCQ "%0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
@@ -283,7 +283,7 @@ static inline void atomic64_inc(atomic64
  */
 static inline void atomic64_dec(atomic64_t *v)
 {
-	asm volatile(LOCK_PREFIX "decq %0"
+	asm volatile(LOCK_PREFIX _ASM_DECQ "%0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
@@ -300,7 +300,7 @@ static inline int atomic64_dec_and_test(
 {
 	unsigned char c;
 
-	asm volatile(LOCK_PREFIX "decq %0; sete %1"
+	asm volatile(LOCK_PREFIX _ASM_DECQ "%0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
 		     : "m" (v->counter) : "memory");
 	return c != 0;
@@ -318,7 +318,7 @@ static inline int atomic64_inc_and_test(
 {
 	unsigned char c;
 
-	asm volatile(LOCK_PREFIX "incq %0; sete %1"
+	asm volatile(LOCK_PREFIX _ASM_INCQ "%0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
 		     : "m" (v->counter) : "memory");
 	return c != 0;
--- linux-2.6.31-rc6/arch/x86/include/asm/checksum_32.h	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/include/asm/checksum_32.h	2009-08-10 14:29:39.000000000 +0200
@@ -73,7 +73,7 @@ static inline __sum16 ip_fast_csum(const
 		     "adcl 12(%1), %0;\n"
 		     "1:	adcl 16(%1), %0	;\n"
 		     "lea 4(%1), %1	;\n"
-		     "decl %2	;\n"
+		     _ASM_DECL "%2	;\n"
 		     "jne 1b		;\n"
 		     "adcl $0, %0	;\n"
 		     "movl %0, %2	;\n"
--- linux-2.6.31-rc6/arch/x86/include/asm/spinlock.h	2009-08-18 15:31:15.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/include/asm/spinlock.h	2009-08-10 14:28:38.000000000 +0200
@@ -98,7 +98,7 @@ static __always_inline int __ticket_spin
 
 static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
+	asm volatile(UNLOCK_LOCK_PREFIX _ASM_INCB "%0"
 		     : "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
@@ -151,7 +151,7 @@ static __always_inline int __ticket_spin
 
 static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
+	asm volatile(UNLOCK_LOCK_PREFIX _ASM_INCW "%0"
 		     : "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
@@ -286,7 +286,7 @@ static inline int __raw_write_trylock(ra
 
 static inline void __raw_read_unlock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX _ASM_INCL "%0" :"+m" (rw->lock) : : "memory");
 }
 
 static inline void __raw_write_unlock(raw_rwlock_t *rw)
--- linux-2.6.31-rc6/arch/x86/lib/checksum_32.S	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/checksum_32.S	2009-08-10 14:59:24.000000000 +0200
@@ -26,6 +26,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 #include <asm/errno.h>
 				
@@ -70,7 +71,7 @@ ENTRY(csum_partial)
 	movzbl (%esi), %ebx
 	adcl %ebx, %eax
 	roll $8, %eax
-	inc %esi
+	_ASM_INCL %esi
 	testl $2, %esi
 	jz 2f
 10:
@@ -181,13 +182,13 @@ ENTRY(csum_partial)
 	testl $1, %esi         
 	jz 30f                 
 	# buf is odd
-	dec %ecx
+	_ASM_DECL %ecx
 	jl 90f
 	movzbl (%esi), %ebx
 	addl %ebx, %eax
 	adcl $0, %eax
 	roll $8, %eax
-	inc %esi
+	_ASM_INCL %esi
 	testl $2, %esi
 	jz 10b
 
@@ -241,7 +242,7 @@ ENTRY(csum_partial)
 45:
 	lea 128(%esi), %esi
 	adcl $0, %eax
-	dec %ecx
+	_ASM_DECL %ecx
 	jge 40b
 	movl %edx, %ecx
 50:	andl $3, %ecx
@@ -494,7 +495,7 @@ ENTRY(csum_partial_copy_generic)
 	ROUND (-16) ROUND(-12) ROUND(-8)  ROUND(-4)	
 3:	adcl $0,%eax
 	addl $64, %edx
-	dec %ecx
+	_ASM_DECL %ecx
 	jge 1b
 4:	movl ARGBASE+12(%esp),%edx	#len
 	andl $3, %edx
--- linux-2.6.31-rc6/arch/x86/lib/clear_page_64.S	2009-08-18 15:31:16.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/clear_page_64.S	2009-08-10 15:18:01.000000000 +0200
@@ -1,4 +1,5 @@
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 /*
@@ -20,7 +21,7 @@ ENTRY(clear_page)
 	movl   $4096/64,%ecx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	_ASM_DECL %ecx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
--- linux-2.6.31-rc6/arch/x86/lib/copy_page_64.S	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/copy_page_64.S	2009-08-10 15:18:05.000000000 +0200
@@ -1,6 +1,7 @@
 /* Written 2003 by Andi Kleen, based on a kernel by Evandro Menezes */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 	ALIGN
@@ -31,7 +32,7 @@ ENTRY(copy_page)
 	movl	$(4096/64)-5,%ecx
 	.p2align 4
 .Loop64:
-  	dec     %rcx
+  	_ASM_DECL %ecx
 
 	movq        (%rsi), %rax
 	movq      8 (%rsi), %rbx
@@ -61,7 +62,7 @@ ENTRY(copy_page)
 	movl	$5,%ecx
 	.p2align 4
 .Loop2:
-	decl   %ecx
+	_ASM_DECL %ecx
 
 	movq        (%rsi), %rax
 	movq      8 (%rsi), %rbx
--- linux-2.6.31-rc6/arch/x86/lib/copy_user_64.S	2009-08-18 15:31:16.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/copy_user_64.S	2009-08-10 15:18:11.000000000 +0200
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 #define FIX_ALIGNMENT 1
@@ -46,9 +47,9 @@
 	subl %ecx,%edx
 100:	movb (%rsi),%al
 101:	movb %al,(%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
+	_ASM_INCQ %rsi
+	_ASM_INCQ %rdi
+	_ASM_DECL %ecx
 	jnz 100b
 102:
 	.section .fixup,"ax"
@@ -158,7 +159,7 @@ ENTRY(copy_user_generic_unrolled)
 16:	movq %r11,7*8(%rdi)
 	leaq 64(%rsi),%rsi
 	leaq 64(%rdi),%rdi
-	decl %ecx
+	_ASM_DECL %ecx
 	jnz 1b
 17:	movl %edx,%ecx
 	andl $7,%edx
@@ -168,16 +169,16 @@ ENTRY(copy_user_generic_unrolled)
 19:	movq %r8,(%rdi)
 	leaq 8(%rsi),%rsi
 	leaq 8(%rdi),%rdi
-	decl %ecx
+	_ASM_DECL %ecx
 	jnz 18b
 20:	andl %edx,%edx
 	jz 23f
 	movl %edx,%ecx
 21:	movb (%rsi),%al
 22:	movb %al,(%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
+	_ASM_INCQ %rsi
+	_ASM_INCQ %rdi
+	_ASM_DECL %ecx
 	jnz 21b
 23:	xor %eax,%eax
 	ret
--- linux-2.6.31-rc6/arch/x86/lib/copy_user_nocache_64.S	2008-10-10 00:13:53.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/copy_user_nocache_64.S	2009-08-10 15:18:15.000000000 +0200
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 #define FIX_ALIGNMENT 1
@@ -26,9 +27,9 @@
 	subl %ecx,%edx
 100:	movb (%rsi),%al
 101:	movb %al,(%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
+	_ASM_INCQ %rsi
+	_ASM_INCQ %rdi
+	_ASM_DECL %ecx
 	jnz 100b
 102:
 	.section .fixup,"ax"
@@ -75,7 +76,7 @@ ENTRY(__copy_user_nocache)
 16:	movnti %r11,7*8(%rdi)
 	leaq 64(%rsi),%rsi
 	leaq 64(%rdi),%rdi
-	decl %ecx
+	_ASM_DECL %ecx
 	jnz 1b
 17:	movl %edx,%ecx
 	andl $7,%edx
@@ -85,16 +86,16 @@ ENTRY(__copy_user_nocache)
 19:	movnti %r8,(%rdi)
 	leaq 8(%rsi),%rsi
 	leaq 8(%rdi),%rdi
-	decl %ecx
+	_ASM_DECL %ecx
 	jnz 18b
 20:	andl %edx,%edx
 	jz 23f
 	movl %edx,%ecx
 21:	movb (%rsi),%al
 22:	movb %al,(%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
+	_ASM_INCQ %rsi
+	_ASM_INCQ %rdi
+	_ASM_DECL %ecx
 	jnz 21b
 23:	xorl %eax,%eax
 	sfence
--- linux-2.6.31-rc6/arch/x86/lib/memcpy_64.S	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/memcpy_64.S	2009-08-10 15:18:30.000000000 +0200
@@ -2,6 +2,7 @@
 
 #include <linux/linkage.h>
 
+#include <asm/asm.h>
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
 
@@ -58,7 +59,7 @@ ENTRY(memcpy)
 	 * checked at the end of the loop (instructions inbetween do
 	 * not change the zero flag):
 	 */
-	decl %ecx
+	_ASM_DECL %ecx
 
 	/*
 	 * Move in blocks of 4x16 bytes:
@@ -96,7 +97,7 @@ ENTRY(memcpy)
 
 	.p2align 4
 .Lloop_8:
-	decl %ecx
+	_ASM_DECL %ecx
 	movq (%rsi),		%r8
 	movq %r8,		(%rdi)
 	leaq 8(%rdi),		%rdi
@@ -112,9 +113,9 @@ ENTRY(memcpy)
 .Lloop_1:
 	movb (%rsi), %r8b
 	movb %r8b, (%rdi)
-	incq %rdi
-	incq %rsi
-	decl %ecx
+	_ASM_INCQ %rdi
+	_ASM_INCQ %rsi
+	_ASM_DECL %ecx
 	jnz .Lloop_1
 
 .Lend:
--- linux-2.6.31-rc6/arch/x86/lib/memset_64.S	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/memset_64.S	2009-08-10 15:18:37.000000000 +0200
@@ -1,6 +1,7 @@
 /* Copyright 2002 Andi Kleen, SuSE Labs */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 /*
@@ -56,7 +57,7 @@ ENTRY(__memset)
 
 	.p2align 4
 .Lloop_64:
-	decl   %ecx
+	_ASM_DECL %ecx
 	movq  %rax,(%rdi)
 	movq  %rax,8(%rdi)
 	movq  %rax,16(%rdi)
@@ -78,7 +79,7 @@ ENTRY(__memset)
 	shrl	$3,%ecx
 	.p2align 4
 .Lloop_8:
-	decl   %ecx
+	_ASM_DECL %ecx
 	movq  %rax,(%rdi)
 	leaq  8(%rdi),%rdi
 	jnz    .Lloop_8
@@ -89,7 +90,7 @@ ENTRY(__memset)
 	jz      .Lende
 	.p2align 4
 .Lloop_1:
-	decl    %ecx
+	_ASM_DECL %ecx
 	movb 	%al,(%rdi)
 	leaq	1(%rdi),%rdi
 	jnz     .Lloop_1
--- linux-2.6.31-rc6/arch/x86/lib/rwlock_64.S	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/rwlock_64.S	2009-08-10 15:18:44.000000000 +0200
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <asm/rwlock.h>
 #include <asm/alternative-asm.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 /* rdi:	pointer to rwlock_t */
@@ -25,13 +26,13 @@ END(__write_lock_failed)
 ENTRY(__read_lock_failed)
 	CFI_STARTPROC
 	LOCK_PREFIX
-	incl (%rdi)
+	_ASM_INCL (%rdi)
 1:	rep
 	nop
 	cmpl $1,(%rdi)
 	js 1b
 	LOCK_PREFIX
-	decl (%rdi)
+	_ASM_DECL (%rdi)
 	js __read_lock_failed
 	ret
 	CFI_ENDPROC
--- linux-2.6.31-rc6/arch/x86/lib/semaphore_32.S	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/semaphore_32.S	2009-08-10 15:18:52.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/linkage.h>
 #include <asm/rwlock.h>
 #include <asm/alternative-asm.h>
+#include <asm/asm.h>
 #include <asm/frame.h>
 #include <asm/dwarf2.h>
 
@@ -55,12 +56,12 @@ ENTRY(__read_lock_failed)
 	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
-	incl	(%eax)
+	_ASM_INCL (%eax)
 1:	rep; nop
 	cmpl	$1,(%eax)
 	js	1b
 	LOCK_PREFIX
-	decl	(%eax)
+	_ASM_DECL (%eax)
 	js	2b
 	ENDFRAME
 	ret
@@ -103,7 +104,7 @@ ENTRY(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
+	_ASM_DECW %dx    /* do nothing if still outstanding active readers */
 	jnz 1f
 	push %ecx
 	CFI_ADJUST_CFA_OFFSET 4
--- linux-2.6.31-rc6/arch/x86/lib/string_32.c	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/string_32.c	2009-08-10 14:48:22.000000000 +0200
@@ -12,6 +12,7 @@
 
 #include <linux/string.h>
 #include <linux/module.h>
+#include <asm/asm.h>
 
 #ifdef __HAVE_ARCH_STRCPY
 char *strcpy(char *dest, const char *src)
@@ -32,7 +33,7 @@ EXPORT_SYMBOL(strcpy);
 char *strncpy(char *dest, const char *src, size_t count)
 {
 	int d0, d1, d2, d3;
-	asm volatile("1:\tdecl %2\n\t"
+	asm volatile("1:\t" _ASM_DECL "%2\n\t"
 		"js 2f\n\t"
 		"lodsb\n\t"
 		"stosb\n\t"
@@ -54,7 +55,7 @@ char *strcat(char *dest, const char *src
 	int d0, d1, d2, d3;
 	asm volatile("repne\n\t"
 		"scasb\n\t"
-		"decl %1\n"
+		_ASM_DECL "%1\n"
 		"1:\tlodsb\n\t"
 		"stosb\n\t"
 		"testb %%al,%%al\n\t"
@@ -72,9 +73,9 @@ char *strncat(char *dest, const char *sr
 	int d0, d1, d2, d3;
 	asm volatile("repne\n\t"
 		"scasb\n\t"
-		"decl %1\n\t"
+		_ASM_DECL "%1\n\t"
 		"movl %8,%3\n"
-		"1:\tdecl %3\n\t"
+		"1:\t" _ASM_DECL "%3\n\t"
 		"js 2f\n\t"
 		"lodsb\n\t"
 		"stosb\n\t"
@@ -118,7 +119,7 @@ int strncmp(const char *cs, const char *
 {
 	int res;
 	int d0, d1, d2;
-	asm volatile("1:\tdecl %3\n\t"
+	asm volatile("1:\t" _ASM_DECL "%3\n\t"
 		"js 2f\n\t"
 		"lodsb\n\t"
 		"scasb\n\t"
@@ -151,7 +152,7 @@ char *strchr(const char *s, int c)
 		"jne 1b\n\t"
 		"movl $1,%1\n"
 		"2:\tmovl %1,%0\n\t"
-		"decl %0"
+		_ASM_DECL "%0"
 		: "=a" (res), "=&S" (d0)
 		: "1" (s), "0" (c)
 		: "memory");
@@ -168,7 +169,7 @@ size_t strlen(const char *s)
 	asm volatile("repne\n\t"
 		"scasb\n\t"
 		"notl %0\n\t"
-		"decl %0"
+		_ASM_DECL "%0"
 		: "=c" (res), "=&D" (d0)
 		: "1" (s), "a" (0), "0" (0xffffffffu)
 		: "memory");
@@ -188,7 +189,7 @@ void *memchr(const void *cs, int c, size
 		"scasb\n\t"
 		"je 1f\n\t"
 		"movl $1,%0\n"
-		"1:\tdecl %0"
+		"1:\t" _ASM_DECL "%0"
 		: "=D" (res), "=&c" (d0)
 		: "a" (c), "0" (cs), "1" (count)
 		: "memory");
@@ -204,7 +205,7 @@ void *memscan(void *addr, int c, size_t 
 		return addr;
 	asm volatile("repnz; scasb\n\t"
 	    "jnz 1f\n\t"
-	    "dec %%edi\n"
+	    _ASM_DECL "%%edi\n"
 	    "1:"
 	    : "=D" (addr), "=c" (size)
 	    : "0" (addr), "1" (size), "a" (c)
@@ -223,8 +224,8 @@ size_t strnlen(const char *s, size_t cou
 		"jmp 2f\n"
 		"1:\tcmpb $0,(%0)\n\t"
 		"je 3f\n\t"
-		"incl %0\n"
-		"2:\tdecl %1\n\t"
+		_ASM_INCL "%0\n"
+		"2:\t" _ASM_DECL "%1\n\t"
 		"cmpl $-1,%1\n\t"
 		"jne 1b\n"
 		"3:\tsubl %2,%0"
--- linux-2.6.31-rc6/arch/x86/lib/strstr_32.c	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.31-rc6-x86-incdec/arch/x86/lib/strstr_32.c	2009-08-10 14:48:16.000000000 +0200
@@ -1,4 +1,5 @@
 #include <linux/string.h>
+#include <asm/asm.h>
 
 char *strstr(const char *cs, const char *ct)
 {
@@ -9,7 +10,7 @@ __asm__ __volatile__(
 	"repne\n\t"
 	"scasb\n\t"
 	"notl %%ecx\n\t"
-	"decl %%ecx\n\t"	/* NOTE! This also sets Z if searchstring='' */
+	_ASM_DECL "%%ecx\n\t"	/* NOTE! This also sets Z if searchstring='' */
 	"movl %%ecx,%%edx\n"
 	"1:\tmovl %6,%%edi\n\t"
 	"movl %%esi,%%eax\n\t"
@@ -18,7 +19,7 @@ __asm__ __volatile__(
 	"cmpsb\n\t"
 	"je 2f\n\t"		/* also works for empty string, see above */
 	"xchgl %%eax,%%esi\n\t"
-	"incl %%esi\n\t"
+	_ASM_INCL "%%esi\n\t"
 	"cmpb $0,-1(%%eax)\n\t"
 	"jne 1b\n\t"
 	"xorl %%eax,%%eax\n\t"


