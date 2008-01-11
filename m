Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYAKBAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYAKBAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYAKBAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:00:08 -0500
Received: from jade.aracnet.com ([216.99.193.136]:42012 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYAKBAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:00:06 -0500
Message-ID: <4786BF88.5010802@BitWagon.com>
Date: Thu, 10 Jan 2008 16:59:52 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       Jeff Dike <jdike@addtoit.com>
CC: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops" in git-x86
References: <20080109215725.GA18185@basil.nowhere.org> <20080110074201.GA12585@uranus.ravnborg.org> <478649D8.9080209@BitWagon.com> <20080110180225.GA747@one.firstfloor.org>
In-Reply-To: <20080110180225.GA747@one.firstfloor.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> But actually checking the default implementation in linkage.h already
> implements size: [snip]

> Are you sure it doesn't work?  Your patch should be not needed. If it's
> still wrong then just ENDPROCs() need to be added.

The ENDPROCs() were not used everywhere.  Some code used just END() instead,
while other code used nothing.  um/sys-i386/checksum.S didn't #include
<linux/linkage.h> .  I also got confused because gcc puts the
.type near the ENTRY, while ENDPROC puts it on the opposite end.

Here is a revised patch against  linux-2.6-x86.git , including a comment
in linkage.h which explains one motivation.  PowerPC is different
("_GLOBAL" instead of "ENTRY") and foreign to me, so I left it alone.

Signed off by: John Reiser <jreiser@BitWagon.com>

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index ff203dd..024cfab 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -53,6 +53,10 @@
   .size name, .-name
 #endif

+/* If symbol 'name' is treated as a subroutine (gets called, and returns)
+ * then please use ENDPROC to mark 'name' as STT_FUNC for the benefit of
+ * static analysis tools such as stack depth analyzer.
+ */
 #ifndef ENDPROC
 #define ENDPROC(name) \
   .type name, @function; \
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 444fba4..e2c6e0d 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -49,7 +49,7 @@ ENTRY(__down_failed)
 	ENDFRAME
 	ret
 	CFI_ENDPROC
-	END(__down_failed)
+	ENDPROC(__down_failed)

 ENTRY(__down_failed_interruptible)
 	CFI_STARTPROC
@@ -70,7 +70,7 @@ ENTRY(__down_failed_interruptible)
 	ENDFRAME
 	ret
 	CFI_ENDPROC
-	END(__down_failed_interruptible)
+	ENDPROC(__down_failed_interruptible)

 ENTRY(__down_failed_trylock)
 	CFI_STARTPROC
@@ -91,7 +91,7 @@ ENTRY(__down_failed_trylock)
 	ENDFRAME
 	ret
 	CFI_ENDPROC
-	END(__down_failed_trylock)
+	ENDPROC(__down_failed_trylock)

 ENTRY(__up_wakeup)
 	CFI_STARTPROC
@@ -112,7 +112,7 @@ ENTRY(__up_wakeup)
 	ENDFRAME
 	ret
 	CFI_ENDPROC
-	END(__up_wakeup)
+	ENDPROC(__up_wakeup)

 /*
  * rw spinlock fallbacks
@@ -132,7 +132,7 @@ ENTRY(__write_lock_failed)
 	ENDFRAME
 	ret
 	CFI_ENDPROC
-	END(__write_lock_failed)
+	ENDPROC(__write_lock_failed)

 ENTRY(__read_lock_failed)
 	CFI_STARTPROC
@@ -148,7 +148,7 @@ ENTRY(__read_lock_failed)
 	ENDFRAME
 	ret
 	CFI_ENDPROC
-	END(__read_lock_failed)
+	ENDPROC(__read_lock_failed)

 #endif

@@ -170,7 +170,7 @@ ENTRY(call_rwsem_down_read_failed)
 	CFI_ADJUST_CFA_OFFSET -4
 	ret
 	CFI_ENDPROC
-	END(call_rwsem_down_read_failed)
+	ENDPROC(call_rwsem_down_read_failed)

 ENTRY(call_rwsem_down_write_failed)
 	CFI_STARTPROC
@@ -182,7 +182,7 @@ ENTRY(call_rwsem_down_write_failed)
 	CFI_ADJUST_CFA_OFFSET -4
 	ret
 	CFI_ENDPROC
-	END(call_rwsem_down_write_failed)
+	ENDPROC(call_rwsem_down_write_failed)

 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
@@ -196,7 +196,7 @@ ENTRY(call_rwsem_wake)
 	CFI_ADJUST_CFA_OFFSET -4
 1:	ret
 	CFI_ENDPROC
-	END(call_rwsem_wake)
+	ENDPROC(call_rwsem_wake)

 /* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
@@ -214,6 +214,6 @@ ENTRY(call_rwsem_downgrade_wake)
 	CFI_ADJUST_CFA_OFFSET -4
 	ret
 	CFI_ENDPROC
-	END(call_rwsem_downgrade_wake)
+	ENDPROC(call_rwsem_downgrade_wake)

 #endif
diff --git a/arch/um/sys-i386/checksum.S b/arch/um/sys-i386/checksum.S
index 62c7e56..4f3f62b 100644
--- a/arch/um/sys-i386/checksum.S
+++ b/arch/um/sys-i386/checksum.S
@@ -26,6 +26,7 @@
  */

 #include <asm/errno.h>
+#include <linux/linkage.h>
 				
 /*
  * computes a partial checksum, e.g. for TCP/UDP fragments
@@ -48,7 +49,7 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
 	   * Fortunately, it is easy to convert 2-byte alignment to 4-byte
 	   * alignment for the unrolled loop.
 	   */		
-csum_partial:
+ENTRY(csum_partial)
 	pushl %esi
 	pushl %ebx
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
@@ -113,12 +114,13 @@ csum_partial:
 	popl %ebx
 	popl %esi
 	ret
+	ENDPROC(csum_partial)

 #else

 /* Version for PentiumII/PPro */

-csum_partial:
+ENTRY(csum_partial)
 	pushl %esi
 	pushl %ebx
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
@@ -211,6 +213,7 @@ csum_partial:
 	popl %ebx
 	popl %esi
 	ret
+	ENDPROC(csum_partial)
 				
 #endif

@@ -250,7 +253,7 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 #define ARGBASE 16		
 #define FP		12
 		
-csum_partial_copy_generic_i386:
+ENTRY(csum_partial_copy_generic_i386)
 	subl  $4,%esp	
 	pushl %edi
 	pushl %esi
@@ -368,6 +371,7 @@ DST(	movb %cl, (%edi)	)
 	popl %edi
 	popl %ecx			# equivalent to addl $4,%esp
 	ret	
+	ENDPROC(csum_partial_copy_generic_i386)

 #else

@@ -385,7 +389,7 @@ DST(	movb %cl, (%edi)	)

 #define ARGBASE 12
 		
-csum_partial_copy_generic_i386:
+ENTRY(csum_partial_copy_generic_i386)
 	pushl %ebx
 	pushl %edi
 	pushl %esi
@@ -452,6 +456,7 @@ DST(	movb %dl, (%edi)         )
 	popl %edi
 	popl %ebx
 	ret
+	ENDPROC(csum_partial_copy_generic_i386)
 				
 #undef ROUND
 #undef ROUND1		
diff --git a/arch/m32r/lib/checksum.S b/arch/m32r/lib/checksum.S
index 0af0360..2492222 100644
--- a/arch/m32r/lib/checksum.S
+++ b/arch/m32r/lib/checksum.S
@@ -153,6 +153,7 @@ ENTRY(csum_partial)
 	addx	r0, r2		    ||	ldi	r2, #0
 	addx	r0, r2
 	jmp	r14
+	ENDPROC(csum_partial)

 #else /* not CONFIG_ISA_DUAL_ISSUE */

@@ -288,6 +289,7 @@ ENTRY(csum_partial)
 	ldi	r2, #0
 	addx	r0, r2
 	jmp	r14
+	ENDPROC(csum_partial)

 #endif /* not CONFIG_ISA_DUAL_ISSUE */

@@ -316,5 +318,6 @@ ENTRY(csum_partial_copy_generic)
 	nop
 	nop
 	nop
+	ENDPROC(csum_partial_copy_generic)

 	.end
diff --git a/arch/m68k/lib/semaphore.S b/arch/m68k/lib/semaphore.S
index 0215624..f28889c 100644
--- a/arch/m68k/lib/semaphore.S
+++ b/arch/m68k/lib/semaphore.S
@@ -22,6 +22,7 @@ ENTRY(__down_failed)
 	movel (%sp)+,%a1
 	moveml (%sp)+,%a0/%d0/%d1
 	rts
+	ENDPROC(__down_failed)

 ENTRY(__down_failed_interruptible)
 	movel %a0,-(%sp)
@@ -32,6 +33,7 @@ ENTRY(__down_failed_interruptible)
 	movel (%sp)+,%d1
 	movel (%sp)+,%a0
 	rts
+	ENDPROC(__down_failed_interruptible)

 ENTRY(__down_failed_trylock)
 	movel %a0,-(%sp)
@@ -42,6 +44,7 @@ ENTRY(__down_failed_trylock)
 	movel (%sp)+,%d1
 	movel (%sp)+,%a0
 	rts
+	ENDPROC(__down_failed_trylock)

 ENTRY(__up_wakeup)
 	moveml %a0/%d0/%d1,-(%sp)
@@ -50,4 +53,5 @@ ENTRY(__up_wakeup)
 	movel (%sp)+,%a1
 	moveml (%sp)+,%a0/%d0/%d1
 	rts
+	ENDPROC(__up_wakeup)

diff --git a/arch/m68knommu/lib/semaphore.S b/arch/m68knommu/lib/semaphore.S
index 87c7460..e4bcb07 100644
--- a/arch/m68knommu/lib/semaphore.S
+++ b/arch/m68knommu/lib/semaphore.S
@@ -30,6 +30,7 @@ ENTRY(__down_failed)
 	movel (%sp)+,%d0
 	movel (%sp)+,%d1
 	rts
+	ENDPROC(__down_failed)

 ENTRY(__down_failed_interruptible)
 	movel %a0,-(%sp)
@@ -39,6 +40,7 @@ ENTRY(__down_failed_interruptible)
 	movel (%sp)+,%a1
 	movel (%sp)+,%d1
 	rts
+	ENDPROC(__down_failed_interruptible)

 ENTRY(__up_wakeup)
 #ifdef CONFIG_COLDFIRE
@@ -53,6 +55,7 @@ ENTRY(__up_wakeup)
 	movel (%sp)+,%d0
 	movel (%sp)+,%d1
 	rts
+	ENDPROC(__up_wakeup)

 ENTRY(__down_failed_trylock)
 	movel %a0,-(%sp)
@@ -63,4 +66,5 @@ ENTRY(__down_failed_trylock)
 	movel (%sp)+,%d1
 	movel (%sp)+,%a0
 	rts
+	ENDPROC(__down_failed_trylock)

diff --git a/arch/sh/lib/checksum.S b/arch/sh/lib/checksum.S
index cbdd0d4..c7a41de 100644
--- a/arch/sh/lib/checksum.S
+++ b/arch/sh/lib/checksum.S
@@ -143,6 +143,7 @@ ENTRY(csum_partial)
 9:
 	rts
 	 mov	r6, r0
+	ENDPROC(csum_partial)

 /*
 unsigned int csum_partial_copy_generic (const char *src, char *dst, int len,
@@ -384,3 +385,4 @@ DST(	mov.b	r0,@r5	)
 	add	#8,r15
 	rts
 	 mov	r7,r0
+	ENDPROC(csum_partial_copy_generic)
diff --git a/arch/xtensa/lib/checksum.S b/arch/xtensa/lib/checksum.S
index 9d9cd99..9d12ade 100644
--- a/arch/xtensa/lib/checksum.S
+++ b/arch/xtensa/lib/checksum.S
@@ -169,6 +169,7 @@ ENTRY(csum_partial)
 	addi	a2, a2, 2
 3:
 	j	5b		/* branch to handle the remaining byte */
+	ENDPROC(csum_partial)



@@ -406,4 +407,5 @@ DST(	s8i	a8, a3, 1	)
 	retw

 .previous
+	ENDPROC(csum_partial_copy_generic)


-- 
John Reiser, jreiser@BitWagon.com



