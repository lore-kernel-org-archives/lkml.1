Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbYF0Vzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbYF0Vzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765599AbYF0Vwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:52:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23786 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763968AbYF0Vws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=h+q1drUrHOLQIQso3WWZBfVIgVRwjqOUcMAKmaaHeimZOIyRMl/uf1OsNvEEWM8ZJw
         Pe/6LIkbDaV8HyVRnEnc0WocbxLR4OP7QBpgFpMUXbzlEQ5vjkd+Seb42TiBKzqT5wmI
         mivJNB67B3XcJ1ngWrcvq9zP4KtDCvwtTqMYs=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] Fix copy_user on x86_64
Date: Fri, 27 Jun 2008 23:52:43 +0200
Message-ID: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Added copy_user_64.c instead of copy_user_64.S and
copy_user_nocache_64.S


--=-=-=
Content-Disposition: inline; filename=add-copy_user_64_c.patch
Content-Description: add copy_user_64.c

diff --git a/arch/x86/lib/copy_user_64.c b/arch/x86/lib/copy_user_64.c
new file mode 100644
index 0000000..7317bf5
--- /dev/null
+++ b/arch/x86/lib/copy_user_64.c
@@ -0,0 +1,295 @@
+/*
+ * Copyright 2008 Vitaly Mayatskikh <vmayatsk@redhat.com>
+ * Copyright 2002 Andi Kleen, SuSE Labs.
+ * Subject to the GNU Public License v2.
+ *
+ * Functions to copy from and to user space.
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+/*
+ * Try to copy last bytes and clear rest if needed.
+ * Since protection fault in copy_from/to_user is not a normal situation,
+ * it is not necessary to optimize tail handling .
+ */
+unsigned long
+copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
+{
+	char c;
+	unsigned zero_len;
+
+	for (; len; --len) {
+		if (__get_user_nocheck(c, from++, sizeof(char)))
+			break;
+		if (__put_user_nocheck(c, to++, sizeof(char)))
+			break;
+	}
+
+	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
+		if (__put_user_nocheck(c, to++, sizeof(char)))
+			break;
+	return len;
+}
+
+/* Some CPUs run faster using the string copy instructions.
+ * This is also a lot simpler. Use them when possible.
+ *
+ * Only 4GB of copy is supported. This shouldn't be a problem
+ * because the kernel normally only writes from/to page sized chunks
+ * even if user space passed a longer buffer.
+ * And more would be dangerous because both Intel and AMD have
+ * errata with rep movsq > 4GB. If someone feels the need to fix
+ * this please consider this.
+ */
+inline unsigned long
+copy_user_generic_string(void *to, const void *from, unsigned len)
+{
+	unsigned long ret;
+	asm volatile (
+		"	movl %%ecx,%%edx\n"
+		"	shrl $3,%%ecx\n"
+		"	andl $7,%%edx\n"
+		"1:	rep; movsq\n"
+		"	movl %%edx,%%ecx\n"
+		"2:	rep; movsb\n"
+		"3:\n"
+		".section .fixup,\"ax\"\n"
+		"12:	xorl %%ecx,%%ecx\n"
+		"11:	leal (%%edx,%%ecx,8),%%ecx\n"
+		"	movl %%ecx,%%edx\n"	/* ecx is zerorest also */
+		"	call copy_user_handle_tail\n"
+		"	movl %%eax,%%ecx\n"
+		"	jmp 3b\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.quad 1b,11b\n"
+		"	.quad 2b,12b\n"
+		".previous"
+		: "=c"(ret)
+		: "D"(to), "S"(from), "c"(len)
+		: "eax", "edx", "memory"
+		);
+	return ret;
+}
+
+/*
+ * copy_user_generic_unrolled - memory copy with exception handling.
+ * This version is for CPUs like P4 that don't have efficient micro
+ * code for rep movsq
+ */
+inline unsigned long
+copy_user_generic_unrolled(void *to, const void *from, unsigned len)
+{
+	unsigned long ret;
+	asm volatile (
+		"	movl %%ecx,%%edx\n"
+		"	andl $63,%%edx\n"
+		"	shrl $6,%%ecx\n"
+		"	jz 17f\n"
+		"1:	movq (%%rsi),%%r8\n"
+		"2:	movq 1*8(%%rsi),%%r9\n"
+		"3:	movq 2*8(%%rsi),%%r10\n"
+		"4:	movq 3*8(%%rsi),%%r11\n"
+		"5:	movq %%r8,(%%rdi)\n"
+		"6:	movq %%r9,1*8(%%rdi)\n"
+		"7:	movq %%r10,2*8(%%rdi)\n"
+		"8:	movq %%r11,3*8(%%rdi)\n"
+		"9:	movq 4*8(%%rsi),%%r8\n"
+		"10:	movq 5*8(%%rsi),%%r9\n"
+		"11:	movq 6*8(%%rsi),%%r10\n"
+		"12:	movq 7*8(%%rsi),%%r11\n"
+		"13:	movq %%r8,4*8(%%rdi)\n"
+		"14:	movq %%r9,5*8(%%rdi)\n"
+		"15:	movq %%r10,6*8(%%rdi)\n"
+		"16:	movq %%r11,7*8(%%rdi)\n"
+		"	leaq 64(%%rsi),%%rsi\n"
+		"	leaq 64(%%rdi),%%rdi\n"
+		"	decl %%ecx\n"
+		"	jnz 1b\n"
+		"17:	movl %%edx,%%ecx\n"
+		"	andl $7,%%edx\n"
+		"	shrl $3,%%ecx\n"
+		"	jz 20f\n"
+		"18:	movq (%%rsi),%%r8\n"
+		"19:	movq %%r8,(%%rdi)\n"
+		"	leaq 8(%%rsi),%%rsi\n"
+		"	leaq 8(%%rdi),%%rdi\n"
+		"	decl %%ecx\n"
+		"	jnz 18b\n"
+		"20:	andl %%edx,%%edx\n"
+		"	jz 23f\n"
+		"	movl %%edx,%%ecx\n"
+		"21:	movb (%%rsi),%%al\n"
+		"22:	movb %%al,(%%rdi)\n"
+		"	incq %%rsi\n"
+		"	incq %%rdi\n"
+		"	decl %%ecx\n"
+		"	jnz 21b\n"
+		"23:\n"
+		".section .fixup,\"ax\"\n"
+		"30:	shll $6,%%ecx\n"
+		"	addl %%ecx,%%edx\n"
+		"	jmp 60f\n"
+		"40:	leal (%%edx,%%ecx,8),%%edx\n"
+		"	jmp 60f\n"
+		"50:	movl %%ecx,%%edx\n"
+		"60:\n"				/* ecx is zerorest also */
+		"	call copy_user_handle_tail\n"
+		"	movl %%eax,%%ecx\n"
+		"	jmp  23b\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.quad 1b,30b\n"
+		"	.quad 2b,30b\n"
+		"	.quad 3b,30b\n"
+		"	.quad 4b,30b\n"
+		"	.quad 5b,30b\n"
+		"	.quad 6b,30b\n"
+		"	.quad 7b,30b\n"
+		"	.quad 8b,30b\n"
+		"	.quad 9b,30b\n"
+		"	.quad 10b,30b\n"
+		"	.quad 11b,30b\n"
+		"	.quad 12b,30b\n"
+		"	.quad 13b,30b\n"
+		"	.quad 14b,30b\n"
+		"	.quad 15b,30b\n"
+		"	.quad 16b,30b\n"
+		"	.quad 18b,40b\n"
+		"	.quad 19b,40b\n"
+		"	.quad 21b,50b\n"
+		"	.quad 22b,50b\n"
+		".previous"
+		: "=c"(ret)
+		: "D"(to), "S"(from), "c"(len)
+		: "eax", "edx", "r8", "r9", "r10", "r11", "memory"
+		);
+	return ret;
+}
+
+/*
+ * copy_user_nocache - Uncached memory copy with exception handling
+ * This will force destination/source out of cache for more performance.
+ */
+long __copy_user_nocache(void *to, const void *from, unsigned len, int zerorest)
+{
+	unsigned long ret;
+	asm volatile (
+		"	movl %%ecx,%%edx\n"
+		"	andl $63,%%edx\n"
+		"	shrl $6,%%ecx\n"
+		"	jz 17f\n"
+		"1:	movq (%%rsi),%%r8\n"
+		"2:	movq 1*8(%%rsi),%%r9\n"
+		"3:	movq 2*8(%%rsi),%%r10\n"
+		"4:	movq 3*8(%%rsi),%%r11\n"
+		"5:	movnti %%r8,(%%rdi)\n"
+		"6:	movnti %%r9,1*8(%%rdi)\n"
+		"7:	movnti %%r10,2*8(%%rdi)\n"
+		"8:	movnti %%r11,3*8(%%rdi)\n"
+		"9:	movq 4*8(%%rsi),%%r8\n"
+		"10:	movq 5*8(%%rsi),%%r9\n"
+		"11:	movq 6*8(%%rsi),%%r10\n"
+		"12:	movq 7*8(%%rsi),%%r11\n"
+		"13:	movnti %%r8,4*8(%%rdi)\n"
+		"14:	movnti %%r9,5*8(%%rdi)\n"
+		"15:	movnti %%r10,6*8(%%rdi)\n"
+		"16:	movnti %%r11,7*8(%%rdi)\n"
+		"	leaq 64(%%rsi),%%rsi\n"
+		"	leaq 64(%%rdi),%%rdi\n"
+		"	decl %%ecx\n"
+		"	jnz 1b\n"
+		"17:	movl %%edx,%%ecx\n"
+		"	andl $7,%%edx\n"
+		"	shrl $3,%%ecx\n"
+		"	jz 20f\n"
+		"18:	movq (%%rsi),%%r8\n"
+		"19:	movnti %%r8,(%%rdi)\n"
+		"	leaq 8(%%rsi),%%rsi\n"
+		"	leaq 8(%%rdi),%%rdi\n"
+		"	decl %%ecx\n"
+		"	jnz 18b\n"
+		"20:	andl %%edx,%%edx\n"
+		"	jz 23f\n"
+		"	movl %%edx,%%ecx\n"
+		"21:	movb (%%rsi),%%al\n"
+		"22:	movb %%al,(%%rdi)\n"
+		"	incq %%rsi\n"
+		"	incq %%rdi\n"
+		"	decl %%ecx\n"
+		"	jnz 21b\n"
+		"23:	sfence\n"
+		".section .fixup,\"ax\"\n"
+		"30:	shll $6,%%ecx\n"
+		"	addl %%ecx,%%edx\n"
+		"	jmp 60f\n"
+		"40:	leal (%%edx,%%ecx,8),%%edx\n"
+		"	jmp 60f\n"
+		"50:	movl %%ecx,%%edx\n"
+		"60:	sfence\n"
+		"	movl %%ebx,%%ecx\n"
+		"	call copy_user_handle_tail\n"
+		"	movl %%eax,%%ecx\n"
+		"	jmp  23b\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.quad 1b,30b\n"
+		"	.quad 2b,30b\n"
+		"	.quad 3b,30b\n"
+		"	.quad 4b,30b\n"
+		"	.quad 5b,30b\n"
+		"	.quad 6b,30b\n"
+		"	.quad 7b,30b\n"
+		"	.quad 8b,30b\n"
+		"	.quad 9b,30b\n"
+		"	.quad 10b,30b\n"
+		"	.quad 11b,30b\n"
+		"	.quad 12b,30b\n"
+		"	.quad 13b,30b\n"
+		"	.quad 14b,30b\n"
+		"	.quad 15b,30b\n"
+		"	.quad 16b,30b\n"
+		"	.quad 18b,40b\n"
+		"	.quad 19b,40b\n"
+		"	.quad 21b,50b\n"
+		"	.quad 22b,50b\n"
+		".previous"
+		: "=c"(ret)
+		: "D"(to), "S"(from), "c"(len), "b"(zerorest)
+		: "eax", "edx", "r8", "r9", "r10", "r11", "memory"
+		);
+	return ret;
+}
+
+unsigned long copy_user_generic(void *to, const void *from, unsigned len)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_REP_GOOD))
+		return copy_user_generic_string(to, from, len);
+	else
+		return copy_user_generic_unrolled(to, from, len);
+}
+
+/* Standard copy_to_user with segment limit checking */
+unsigned long copy_to_user(void __user *to, const void *from, unsigned len)
+{
+	if (access_ok(VERIFY_WRITE, to, len))
+		return copy_user_generic(to, from, len);
+	return len;
+}
+
+/* Standard copy_from_user with segment limit checking */
+unsigned long copy_from_user(void *to, const void __user *from, unsigned len)
+{
+	if (access_ok(VERIFY_READ, from, len))
+		return copy_user_generic(to, from, len);
+	else
+		memset(to, 0, len);
+	return len;
+}
+
+long __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
+{
+	return copy_user_generic(dst, src, size);
+}

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

--=-=-=


-- 
wbr, Vitaly

--=-=-=--
