Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbZBXQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbZBXQwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZBXQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:52:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbZBXQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:52:09 -0500
Date: Tue, 24 Feb 2009 17:51:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Performance regression in write() syscall
Message-ID: <20090224165144.GA25174@elte.hu>
References: <20090224020304.GA4496@google.com> <200902241510.33911.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902232021310.3111@localhost.localdomain> <200902242002.37555.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > No, but I think it should be in arch code, and the 
> > "_nocache" suffix should just be a hint to the architecture 
> > that the destination is not so likely to be used.
> 
> Yes. Especially since arch code is likely to need various 
> arch-specific checks anyway (like the x86 code does about 
> aligning the destination).

I'm inclined to do this in two or three phases: first apply the 
fix from Salman in the form below.

In practice if we get a 4K copy request the likelyhood is large 
that this is for a larger write and for a full pagecache page. 
The target is very unlikely to be misaligned, the source might 
be as it comes from user-space.

This portion of __copy_user_nocache() becomes largely 
unnecessary:

ENTRY(__copy_user_nocache)
        CFI_STARTPROC
        cmpl $8,%edx
        jb 20f          /* less then 8 bytes, go to byte copy loop */
        ALIGN_DESTINATION
        movl %edx,%ecx
        andl $63,%edx
        shrl $6,%ecx
        jz 17f

And the tail portion becomes unnecessary too. Those are over a 
dozen instructions so probably worth optimizing out.

But i'd rather express this in terms of a separate 
__copy_user_page_nocache function and keep the generic 
implementation too.

I.e. like the second patch below. (not tested)

With this __copy_user_nocache() becomes unused - and once we are 
happy with the performance characteristics of 4K non-temporal 
copies, we can remove this more generic implementation.

Does this sound reasonable, or do you think we can be smarter 
than this?

	Ingo

-------------------->
>From 30d697fa3a25fed809a873b17531a00282dc1234 Mon Sep 17 00:00:00 2001
From: Salman Qazi <sqazi@google.com>
Date: Mon, 23 Feb 2009 18:03:04 -0800
Subject: [PATCH] x86: fix performance regression in write() syscall

While the introduction of __copy_from_user_nocache (see commit:
0812a579c92fefa57506821fa08e90f47cb6dbdd) may have been an improvement
for sufficiently large writes, there is evidence to show that it is
deterimental for small writes.  Unixbench's fstime test gives the
following results for 256 byte writes with MAX_BLOCK of 2000:

    2.6.29-rc6 ( 5 samples, each in KB/sec ):
    283750, 295200, 294500, 293000, 293300

    2.6.29-rc6 + this patch (5 samples, each in KB/sec):
    313050, 3106750, 293350, 306300, 307900

    2.6.18
    395700, 342000, 399100, 366050, 359850

    See w_test() in src/fstime.c in unixbench version 4.1.0.  Basically, the above test
    consists of counting how much we can write in this manner:

    alarm(10);
    while (!sigalarm) {
            for (f_blocks = 0; f_blocks < 2000; ++f_blocks) {
                   write(f, buf, 256);
            }
            lseek(f, 0L, 0);
    }

Note, there are other components to the write syscall regression
that are not addressed here.

Signed-off-by: Salman Qazi <sqazi@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess_64.h |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 84210c4..987a2c1 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -192,14 +192,26 @@ static inline int __copy_from_user_nocache(void *dst, const void __user *src,
 					   unsigned size)
 {
 	might_sleep();
-	return __copy_user_nocache(dst, src, size, 1);
+	/*
+	 * In practice this limit means that large file write()s
+	 * which get chunked to 4K copies get handled via
+	 * non-temporal stores here. Smaller writes get handled
+	 * via regular __copy_from_user():
+	 */
+	if (likely(size >= PAGE_SIZE))
+		return __copy_user_nocache(dst, src, size, 1);
+	else
+		return __copy_from_user(dst, src, size);
 }
 
 static inline int __copy_from_user_inatomic_nocache(void *dst,
 						    const void __user *src,
 						    unsigned size)
 {
-	return __copy_user_nocache(dst, src, size, 0);
+	if (likely(size >= PAGE_SIZE))
+		return __copy_user_nocache(dst, src, size, 0);
+	else
+		return __copy_from_user_inatomic(dst, src, size);
 }
 
 unsigned long

>From 577e10ab54dacde4c9fc2d09adfb7e817cadac83 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 24 Feb 2009 17:38:12 +0100
Subject: [PATCH] x86: add __copy_user_page_nocache() optimized memcpy

Add a hardcoded 4K copy __copy_user_page_nocache() implementation,
used for pagecache copies.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess_64.h   |   10 +++--
 arch/x86/lib/copy_user_nocache_64.S |   84 +++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 987a2c1..71cbcda 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -188,6 +188,8 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
 
+extern long __copy_user_page_nocache(void *dst, const void __user *src);
+
 static inline int __copy_from_user_nocache(void *dst, const void __user *src,
 					   unsigned size)
 {
@@ -198,8 +200,8 @@ static inline int __copy_from_user_nocache(void *dst, const void __user *src,
 	 * non-temporal stores here. Smaller writes get handled
 	 * via regular __copy_from_user():
 	 */
-	if (likely(size >= PAGE_SIZE))
-		return __copy_user_nocache(dst, src, size, 1);
+	if (likely(size == PAGE_SIZE))
+		return __copy_user_page_nocache(dst, src);
 	else
 		return __copy_from_user(dst, src, size);
 }
@@ -208,8 +210,8 @@ static inline int __copy_from_user_inatomic_nocache(void *dst,
 						    const void __user *src,
 						    unsigned size)
 {
-	if (likely(size >= PAGE_SIZE))
-		return __copy_user_nocache(dst, src, size, 0);
+	if (likely(size == PAGE_SIZE))
+		return __copy_user_page_nocache(dst, src);
 	else
 		return __copy_from_user_inatomic(dst, src, size);
 }
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index cb0c112..387f08e 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -135,3 +135,87 @@ ENTRY(__copy_user_nocache)
 	.previous
 	CFI_ENDPROC
 ENDPROC(__copy_user_nocache)
+
+/*
+ * copy_user_page_nocache - Uncached memory copy of a single page using
+ * non-temporal stores.
+ *
+ * Used for big 4K sized writes - where the chance of repeat access to
+ * the same data is low.
+ */
+ENTRY(__copy_user_page_nocache)
+	CFI_STARTPROC
+
+	/*
+	 * We'll do 64 iterations of 64 bytes each == 4096 bytes,
+	 * hardcoded:
+	 */
+	movl $64, %ecx
+
+1:	movq	0*8(%rsi),	     %r8
+2:	movq	1*8(%rsi),	     %r9
+3:	movq	2*8(%rsi),	    %r10
+4:	movq	3*8(%rsi),	    %r11
+
+5:	movnti	      %r8	0*8(%rdi)
+6:	movnti	      %r9,	1*8(%rdi)
+7:	movnti	     %r10,	2*8(%rdi)
+8:	movnti	     %r11,	3*8(%rdi)
+
+9:	movq	4*8(%rsi),	     %r8
+10:	movq	5*8(%rsi),	     %r9
+11:	movq	6*8(%rsi),	    %r10
+12:	movq	7*8(%rsi),	    %r11
+
+13:	movnti	      %r8,	4*8(%rdi)
+14:	movnti	      %r9,	5*8(%rdi)
+15:	movnti	     %r10,	6*8(%rdi)
+16:	movnti	     %r11,	7*8(%rdi)
+
+	leaq 64(%rsi),%rsi
+	leaq 64(%rdi),%rdi
+
+	decl %ecx
+	jnz 1b
+
+	sfence
+
+	ret
+
+	.section .fixup,"ax"
+30:	shll $6,%ecx
+	movl %ecx,%edx
+	jmp 60f
+40:	xorl %edx, %edx
+	lea (%rdx,%rcx,8),%rdx
+	jmp 60f
+50:	movl %ecx,%edx
+60:	sfence
+	jmp copy_user_handle_tail
+	.previous
+
+	.section __ex_table,"a"
+	.quad 1b,30b
+	.quad 2b,30b
+	.quad 3b,30b
+	.quad 4b,30b
+	.quad 5b,30b
+	.quad 6b,30b
+	.quad 7b,30b
+	.quad 8b,30b
+	.quad 9b,30b
+	.quad 10b,30b
+	.quad 11b,30b
+	.quad 12b,30b
+	.quad 13b,30b
+	.quad 14b,30b
+	.quad 15b,30b
+	.quad 16b,30b
+	.quad 18b,40b
+	.quad 19b,40b
+	.quad 21b,50b
+	.quad 22b,50b
+	.previous
+
+	CFI_ENDPROC
+ENDPROC(__copy_user_page_nocache)
