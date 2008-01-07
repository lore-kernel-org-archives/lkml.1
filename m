Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYAGRZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYAGRZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYAGRZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:25:31 -0500
Received: from jade.aracnet.com ([216.99.193.136]:40839 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbYAGRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:25:30 -0500
Message-ID: <47826019.9040607@BitWagon.com>
Date: Mon, 07 Jan 2008 09:23:37 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>, Hirokazu Takata <takata@linux-m32r.org>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Mikael Starvik <starvik@axis.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: STT_FUNC for assembler checksum and semaphore ops
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear $ARCH Maintainers,

This patch adds Elf32_Sym .st_info (STT_FUNC) and .st_size for hand-coded
checksum and semaphore subroutines.  I needed this info when writing a
static analyzer for stack depth [grovel over ./vmlinux] on the um
(UserModeLinux) $ARCH for i386.  The changes work on i386.  Other $ARCH
are analogous but not tested.  Other arch/x86/lib/*.S are not used by um
currently.  [Should analogous changes be made anyway?]

Comments?

--- ./arch/um/sys-i386/checksum.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/um/sys-i386/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -38,6 +38,7 @@
 .text
 .align 4
 .globl csum_partial
+.type csum_partial, @function
 		
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM

@@ -213,6 +214,7 @@
 	ret
 				
 #endif
+.size csum_partial, . - csum_partial

 /*
 unsigned int csum_partial_copy_generic (const char *src, char *dst,
@@ -244,6 +246,7 @@

 .align 4
 .globl csum_partial_copy_generic_i386
+.type csum_partial_copy_generic_i386, @function
 				
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM

@@ -457,3 +460,4 @@
 #undef ROUND1		
 		
 #endif
+.size csum_partial_copy_generic_i386, . - csum_partial_copy_generic_i386
--- ./arch/ppc/lib/checksum.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/ppc/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -23,6 +23,7 @@
  * ip_fast_csum(buf, len) -- Optimized for IP header
  * len is in words and is always >= 5.
  */
+.type ip_fast_csum, @function
 _GLOBAL(ip_fast_csum)
 	lwz	r0,0(r3)
 	lwzu	r5,4(r3)
@@ -39,11 +40,13 @@
 	not	r3,r3
 	srwi	r3,r3,16
 	blr
+.size ip_fast_csum, . - ip_fast_csum

 /*
  * Compute checksum of TCP or UDP pseudo-header:
  *   csum_tcpudp_magic(saddr, daddr, len, proto, sum)
  */	
+.type csum_tcpudp_magic, @function
 _GLOBAL(csum_tcpudp_magic)
 	rlwimi	r5,r6,16,0,15	/* put proto in upper half of len */
 	addc	r0,r3,r4	/* add 4 32-bit words together */
@@ -55,6 +58,7 @@
 	not	r3,r3
 	srwi	r3,r3,16
 	blr
+.size csum_tcpudp_magic, . - csum_tcpudp_magic

 /*
  * computes the checksum of a memory block at buff, length len,
@@ -62,6 +66,7 @@
  *
  * csum_partial(buff, len, sum)
  */
+.type csum_partial, @function
 _GLOBAL(csum_partial)
 	addic	r0,r5,0
 	subi	r3,r3,4
@@ -93,6 +98,7 @@
 	adde	r0,r0,r5
 5:	addze	r3,r0		/* add in final carry */
 	blr
+.size csum_partial, . - csum_partial

 /*
  * Computes the checksum of a memory block at src, length len,
@@ -103,6 +109,7 @@
  *
  * csum_partial_copy_generic(src, dst, len, sum, src_err, dst_err)
  */
+.type csum_partial_copy_generic, @function
 _GLOBAL(csum_partial_copy_generic)
 	addic	r0,r6,0
 	subi	r3,r3,4
@@ -202,6 +209,7 @@
 	stw	r6,0(r8)
 1:	addze	r3,r0
 	blr
+.size csum_partial_copy_generic, . - csum_partial_copy_generic

 .section __ex_table,"a"
 	.long	81b,src_error_1
--- ./arch/m32r/lib/checksum.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/m32r/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -50,6 +50,7 @@
 	 */

 	.text
+	.type csum_partial, @function
 ENTRY(csum_partial)
 	; Function args
 	;  r0: unsigned char *buff
@@ -153,6 +154,7 @@
 	addx	r0, r2		    ||	ldi	r2, #0
 	addx	r0, r2
 	jmp	r14
+	.size csum_partial, . - csum_partial

 #else /* not CONFIG_ISA_DUAL_ISSUE */

@@ -165,6 +167,7 @@
 	 */

 	.text
+	.type csum_partial, @function
 ENTRY(csum_partial)
 	; Function args
 	;  r0: unsigned char *buff
@@ -288,6 +291,7 @@
 	ldi	r2, #0
 	addx	r0, r2
 	jmp	r14
+	.size csum_partial, . - csum_partial

 #endif /* not CONFIG_ISA_DUAL_ISSUE */

@@ -307,6 +311,7 @@
  *	  them all but there's no guarantee.
  */

+	.type csum_partial_copy_generic, @function
 ENTRY(csum_partial_copy_generic)
 	nop
 	nop
@@ -316,5 +321,6 @@
 	nop
 	nop
 	nop
+	.size csum_partial_copy_generic, . - csum_partial_copy_generic

 	.end
--- ./arch/sparc/lib/checksum.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/sparc/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -104,6 +104,7 @@
 	 * buffer of size 0x20.  Follow the code path for that case.
 	 */
 	.globl	csum_partial
+	.type csum_partial, @function
 csum_partial:			/* %o0=buf, %o1=len, %o2=sum */
 	andcc	%o0, 0x7, %g0				! alignment problems?
 	bne	csum_partial_fix_alignment		! yep, handle it
@@ -140,8 +141,10 @@
 	 andcc	%o1, 8, %g0				! check how much
 cpout:	retl						! get outta here
 	 mov	%o2, %o0				! return computed csum
+	.size csum_partial, . - csum_partial

 	.globl __csum_partial_copy_start, __csum_partial_copy_end
+	.type __csum_partial_copy_start, @function
 __csum_partial_copy_start:

 /* Work around cpp -rob */
@@ -322,6 +325,7 @@
 	addx	%g0, %g7, %g7
 	b	3f
 	 andcc	%g1, 0xffffff80, %g0
+	.size __csum_partial_copy_start, . - __csum_partial_copy_start

 	/* Sun, you just can't beat me, you just can't.  Stop trying,
 	 * give up.  I'm serious, I am going to kick the living shit
@@ -329,6 +333,7 @@
 	 */
 	.align	8
 	.globl	__csum_partial_copy_sparc_generic
+	.type __csum_partial_copy_sparc_generic, @function
 __csum_partial_copy_sparc_generic:
 					/* %o0=src, %o1=dest, %g1=len, %g7=sum */
 	xor	%o0, %o1, %o4		! get changing bits
@@ -576,6 +581,7 @@
 	st	%i5, [%o2]
 	ret
 	 restore
+	.size __csum_partial_copy_sparc_generic, . - __csum_partial_copy_sparc_generic

         .section __ex_table,#alloc
         .align 4
--- ./arch/sh/lib/checksum.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/sh/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -41,6 +41,7 @@
  */

 .text
+.type csum_partial, @function
 ENTRY(csum_partial)
 	  /*
 	   * Experiments with Ethernet and SLIP connections show that buff
@@ -143,6 +144,7 @@
 9:
 	rts
 	 mov	r6, r0
+	.size csum_partial, . - csum_partial

 /*
 unsigned int csum_partial_copy_generic (const char *src, char *dst, int len,
@@ -182,6 +184,7 @@
 ! int *SRC_ERR_PTR
 ! int *DST_ERR_PTR
 !
+	.type csum_partial_copy_generic, @function
 ENTRY(csum_partial_copy_generic)
 	mov.l	r5,@-r15
 	mov.l	r6,@-r15
@@ -384,3 +387,4 @@
 	add	#8,r15
 	rts
 	 mov	r7,r0
+	.size csum_partial_copy_generic, . - csum_partial_copy_generic
--- ./arch/m68k/lib/semaphore.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/m68k/lib/semaphore.S	2008-01-07 08:45:39.000000000 -0800
@@ -15,6 +15,7 @@
  * need to convert that sequence back into the C sequence when
  * there is contention on the semaphore.
  */
+	.type __down_failed, @function
 ENTRY(__down_failed)
 	moveml %a0/%d0/%d1,-(%sp)
 	movel %a1,-(%sp)
@@ -22,7 +23,9 @@
 	movel (%sp)+,%a1
 	moveml (%sp)+,%a0/%d0/%d1
 	rts
+	.size __down_failed, . - __down_failed

+	.type __down_failed_interruptible, @function
 ENTRY(__down_failed_interruptible)
 	movel %a0,-(%sp)
 	movel %d1,-(%sp)
@@ -32,7 +35,9 @@
 	movel (%sp)+,%d1
 	movel (%sp)+,%a0
 	rts
+	.size __down_failed_interruptible, . - __down_failed_interruptible

+	.type __down_failed_trylock, @function
 ENTRY(__down_failed_trylock)
 	movel %a0,-(%sp)
 	movel %d1,-(%sp)
@@ -42,7 +47,9 @@
 	movel (%sp)+,%d1
 	movel (%sp)+,%a0
 	rts
+	.size __down_failed_trylock, . - __down_failed_trylock

+	.type __up_wakeup, @function
 ENTRY(__up_wakeup)
 	moveml %a0/%d0/%d1,-(%sp)
 	movel %a1,-(%sp)
@@ -50,4 +57,5 @@
 	movel (%sp)+,%a1
 	moveml (%sp)+,%a0/%d0/%d1
 	rts
+	.size __up_wakeup, . - __up_wakeup

--- ./arch/m68knommu/lib/semaphore.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/m68knommu/lib/semaphore.S	2008-01-07 08:45:39.000000000 -0800
@@ -17,6 +17,7 @@
  * to increment the number of waiters on the semaphore,
  * call "__down()", and then eventually return to try again.
  */
+	.type __down_failed, @function
 ENTRY(__down_failed)
 #ifdef CONFIG_COLDFIRE
 	subl #12,%sp
@@ -39,7 +40,9 @@
 	movel (%sp)+,%a1
 	movel (%sp)+,%d1
 	rts
+	.size __down_failed, . - __down_failed

+	.type __up_wakeup, @function
 ENTRY(__up_wakeup)
 #ifdef CONFIG_COLDFIRE
 	subl #12,%sp
@@ -63,4 +66,5 @@
 	movel (%sp)+,%d1
 	movel (%sp)+,%a0
 	rts
+	.size __up_wakeup, . - __up_wakeup

--- ./arch/xtensa/lib/checksum.S.orig	2007-11-02 07:03:47.000000000 -0700
+++ ./arch/xtensa/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -40,6 +40,7 @@
 99:				;

 .text
+.type csum_partial, @function
 ENTRY(csum_partial)
 	  /*
 	   * Experiments with Ethernet and SLIP connections show that buf
@@ -169,6 +170,7 @@
 	addi	a2, a2, 2
 3:
 	j	5b		/* branch to handle the remaining byte */
+	.size csum_partial, . - csum_partial



@@ -210,6 +212,7 @@
     alignments work, but not nearly as efficiently.
  */

+	.type csum_partial_copy_generic, @function
 ENTRY(csum_partial_copy_generic)
 	entry	sp, 32
 	mov	a12, a3
@@ -406,4 +409,5 @@
 	retw

 .previous
+	.size csum_partial_copy_generic, . - csum_partial_copy_generic

--- ./arch/x86/lib/semaphore_32.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/x86/lib/semaphore_32.S	2008-01-07 08:45:39.000000000 -0800
@@ -30,6 +30,7 @@
  * value or just clobbered..
  */
 	.section .sched.text
+	.type __down_failed, @function
 ENTRY(__down_failed)
 	CFI_STARTPROC
 	FRAME
@@ -50,7 +51,9 @@
 	ret
 	CFI_ENDPROC
 	END(__down_failed)
+	.size __down_failed, . - __down_failed

+	.type __down_failed_interruptible, @function
 ENTRY(__down_failed_interruptible)
 	CFI_STARTPROC
 	FRAME
@@ -71,7 +74,9 @@
 	ret
 	CFI_ENDPROC
 	END(__down_failed_interruptible)
+	.size __down_failed_interruptible, . - __down_failed_interruptible

+	.type __down_failed_trylock, @function
 ENTRY(__down_failed_trylock)
 	CFI_STARTPROC
 	FRAME
@@ -92,7 +97,9 @@
 	ret
 	CFI_ENDPROC
 	END(__down_failed_trylock)
+	.size __down_failed_trylock, . - __down_failed_trylock

+	.type __up_wakeup, @function
 ENTRY(__up_wakeup)
 	CFI_STARTPROC
 	FRAME
@@ -113,11 +120,13 @@
 	ret
 	CFI_ENDPROC
 	END(__up_wakeup)
+	.size __up_wakeup, . - __up_wakeup

 /*
  * rw spinlock fallbacks
  */
 #ifdef CONFIG_SMP
+	.type __write_lock_failed, @function
 ENTRY(__write_lock_failed)
 	CFI_STARTPROC simple
 	FRAME
@@ -133,7 +142,9 @@
 	ret
 	CFI_ENDPROC
 	END(__write_lock_failed)
+	.size __write_lock_failed, . - __write_lock_failed

+	.type __read_lock_failed, @function
 ENTRY(__read_lock_failed)
 	CFI_STARTPROC
 	FRAME
@@ -149,12 +160,14 @@
 	ret
 	CFI_ENDPROC
 	END(__read_lock_failed)
+	.size __read_lock_failed, . - __read_lock_failed

 #endif

 #ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM

 /* Fix up special calling conventions */
+	.type call_rwsem_down_read_failed, @function
 ENTRY(call_rwsem_down_read_failed)
 	CFI_STARTPROC
 	push %ecx
@@ -171,7 +184,9 @@
 	ret
 	CFI_ENDPROC
 	END(call_rwsem_down_read_failed)
+	.size call_rwsem_down_read_failed, . - call_rwsem_down_read_failed

+	.type call_rwsem_down_write_failed, @function
 ENTRY(call_rwsem_down_write_failed)
 	CFI_STARTPROC
 	push %ecx
@@ -183,7 +198,9 @@
 	ret
 	CFI_ENDPROC
 	END(call_rwsem_down_write_failed)
+	.size call_rwsem_down_write_failed, . - call_rwsem_down_write_failed

+	.type call_rwsem_wake, @function
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
 	decw %dx    /* do nothing if still outstanding active readers */
@@ -197,8 +214,10 @@
 1:	ret
 	CFI_ENDPROC
 	END(call_rwsem_wake)
+	.size call_rwsem_wake, . - call_rwsem_wake

 /* Fix up special calling conventions */
+	.type call_rwsem_downgrade_wake, @function
 ENTRY(call_rwsem_downgrade_wake)
 	CFI_STARTPROC
 	push %ecx
@@ -215,5 +234,6 @@
 	ret
 	CFI_ENDPROC
 	END(call_rwsem_downgrade_wake)
+	.size call_rwsem_downgrade_wake, . - call_rwsem_downgrade_wake

 #endif
--- ./arch/x86/lib/checksum_32.S.orig	2007-11-02 07:03:46.000000000 -0700
+++ ./arch/x86/lib/checksum_32.S	2008-01-07 08:45:39.000000000 -0800
@@ -48,6 +48,7 @@
 	   * Fortunately, it is easy to convert 2-byte alignment to 4-byte
 	   * alignment for the unrolled loop.
 	   */		
+	.type csum_partial, @function
 ENTRY(csum_partial)
 	CFI_STARTPROC
 	pushl %esi
@@ -141,11 +142,13 @@
 	ret
 	CFI_ENDPROC
 ENDPROC(csum_partial)
+	.size csum_partial, . - csum_partial

 #else

 /* Version for PentiumII/PPro */

+	.type csum_partial, @function
 ENTRY(csum_partial)
 	CFI_STARTPROC
 	pushl %esi
@@ -269,6 +272,7 @@
 	ret
 	CFI_ENDPROC
 ENDPROC(csum_partial)
+	.size csum_partial, . - csum_partial
 				
 #endif

@@ -305,6 +309,7 @@
 #define ARGBASE 16		
 #define FP		12
 		
+	.type csum_partial_copy_generic, @function
 ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
 	subl  $4,%esp	
@@ -440,6 +445,7 @@
 	ret	
 	CFI_ENDPROC
 ENDPROC(csum_partial_copy_generic)
+	.size csum_partial_copy_generic, . - csum_partial_copy_generic

 #else

@@ -457,6 +463,7 @@

 #define ARGBASE 12
 		
+	.type csum_partial_copy_generic, @function
 ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
 	pushl %ebx
@@ -539,6 +546,7 @@
 	ret
 	CFI_ENDPROC
 ENDPROC(csum_partial_copy_generic)
+	.size csum_partial_copy_generic, . - csum_partial_copy_generic
 				
 #undef ROUND
 #undef ROUND1		
--- ./arch/cris/arch-v10/lib/checksum.S.orig	2007-11-02 07:03:45.000000000 -0700
+++ ./arch/cris/arch-v10/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -6,6 +6,7 @@
  */

 	.globl	csum_partial
+	.type csum_partial, @function
 csum_partial:
 	
 	;; r10 - src
@@ -121,4 +122,4 @@
 	addu.b	[$r10],$r12
 	ret
 	move.d	$r12, $r10
-		
+	.size csum_partial, . - csum_partial
--- ./arch/cris/arch-v32/lib/checksum.S.orig	2007-11-02 07:03:45.000000000 -0700
+++ ./arch/cris/arch-v32/lib/checksum.S	2008-01-07 08:45:39.000000000 -0800
@@ -6,6 +6,7 @@
  */

 	.globl	csum_partial
+	.type csum_partial, @function
 csum_partial:

 	;; r10 - src
@@ -109,3 +110,4 @@
 	addu.b	[$r10],$r12
 	ret
 	move.d	$r12,$r10
+	.size csum_partial, . - csum_partial

-- 
John Reiser, jreiser@BitWagon.com

