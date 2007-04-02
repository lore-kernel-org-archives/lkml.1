Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXDBHbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXDBHbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXDBHbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:31:23 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:42407
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbXDBHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:31:22 -0400
Message-Id: <4610CD8D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 02 Apr 2007 08:31:57 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Fw: Re: 2.6.21-rc5-mm3
References: <20070330103958.16b738aa.akpm@linux-foundation.org>
 <200703302131.23469.ak@suse.de>
In-Reply-To: <200703302131.23469.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  [<c020c23e>] __put_user_4+0x12/0x18
>> DWARF2 unwinder stuck at __put_user_4+0x12/0x18
>> Leftover inexact backtrace:
>>  [<c01040d6>] ret_from_fork+0x6/0x1c
>
>Hmpf. I saw it once in child_rip here too. Then I wanted to reproduce it to report
>properly and couldn't again. I had a few other backtraces that were all non stuck
>with child_rip then on essentially the same kernel. Something weird is going on.
>
>>  [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
>>  [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
>>  [<c0104bef>] apic_timer_interrupt+0x33/0x38
>>  [<c020c184>] __get_user_4+0x14/0x17
>> DWARF2 unwinder stuck at __get_user_4+0x14/0x17
>> Leftover inexact backtrace:
>
>Now that is weird. Never seen before. Jan, any ideas?

Not weird at all - these functions simply aren't annotated (i.e. I assume you
forgot to apply the respective patch when you re-added the unwinder). As
I don't have this as a standalone patch anymore, I'll include the full diff for
arch/i386/lib/ below - this is likely to apply.

Jan

Index: head-2007-03-19/arch/i386/lib/checksum.S
===================================================================
--- head-2007-03-19.orig/arch/i386/lib/checksum.S	2007-02-04 19:44:54.000000000 +0100
+++ head-2007-03-19/arch/i386/lib/checksum.S	2007-03-21 12:29:15.000000000 +0100
@@ -25,6 +25,8 @@
  *		2 of the License, or (at your option) any later version.
  */
 
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
 #include <asm/errno.h>
 				
 /*
@@ -36,8 +38,6 @@ unsigned int csum_partial(const unsigned
  */
 		
 .text
-.align 4
-.globl csum_partial								
 		
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
 
@@ -48,9 +48,14 @@ unsigned int csum_partial(const unsigned
 	   * Fortunately, it is easy to convert 2-byte alignment to 4-byte
 	   * alignment for the unrolled loop.
 	   */		
-csum_partial:	
+ENTRY(csum_partial)
+	CFI_STARTPROC
 	pushl %esi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET esi, 0
 	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebx, 0
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
 	movl 16(%esp),%ecx	# Function arg: int len
 	movl 12(%esp),%esi	# Function arg: unsigned char *buff
@@ -128,16 +133,27 @@ csum_partial:	
 	roll $8, %eax
 8:
 	popl %ebx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebx
 	popl %esi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE esi
 	ret
+	CFI_ENDPROC
+ENDPROC(csum_partial)
 
 #else
 
 /* Version for PentiumII/PPro */
 
-csum_partial:
+ENTRY(csum_partial)
+	CFI_STARTPROC
 	pushl %esi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET esi, 0
 	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebx, 0
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
 	movl 16(%esp),%ecx	# Function arg: int len
 	movl 12(%esp),%esi	# Function arg:	const unsigned char *buf
@@ -245,8 +261,14 @@ csum_partial:
 	roll $8, %eax
 90: 
 	popl %ebx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebx
 	popl %esi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE esi
 	ret
+	CFI_ENDPROC
+ENDPROC(csum_partial)
 				
 #endif
 
@@ -278,19 +300,24 @@ unsigned int csum_partial_copy_generic (
 	.long 9999b, 6002f	;	\
 	.previous
 
-.align 4
-.globl csum_partial_copy_generic
-				
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
 
 #define ARGBASE 16		
 #define FP		12
 		
-csum_partial_copy_generic:
+ENTRY(csum_partial_copy_generic)
+	CFI_STARTPROC
 	subl  $4,%esp	
+	CFI_ADJUST_CFA_OFFSET 4
 	pushl %edi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edi, 0
 	pushl %esi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET esi, 0
 	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebx, 0
 	movl ARGBASE+16(%esp),%eax	# sum
 	movl ARGBASE+12(%esp),%ecx	# len
 	movl ARGBASE+4(%esp),%esi	# src
@@ -400,10 +427,19 @@ DST(	movb %cl, (%edi)	)
 .previous
 
 	popl %ebx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebx
 	popl %esi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE esi
 	popl %edi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE edi
 	popl %ecx			# equivalent to addl $4,%esp
+	CFI_ADJUST_CFA_OFFSET -4
 	ret	
+	CFI_ENDPROC
+ENDPROC(csum_partial_copy_generic)
 
 #else
 
@@ -421,10 +457,17 @@ DST(	movb %cl, (%edi)	)
 
 #define ARGBASE 12
 		
-csum_partial_copy_generic:
+ENTRY(csum_partial_copy_generic)
+	CFI_STARTPROC
 	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebx, 0
 	pushl %edi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edi, 0
 	pushl %esi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET esi, 0
 	movl ARGBASE+4(%esp),%esi	#src
 	movl ARGBASE+8(%esp),%edi	#dst	
 	movl ARGBASE+12(%esp),%ecx	#len
@@ -485,9 +528,17 @@ DST(	movb %dl, (%edi)         )
 .previous				
 
 	popl %esi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE esi
 	popl %edi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE edi
 	popl %ebx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebx
 	ret
+	CFI_ENDPROC
+ENDPROC(csum_partial_copy_generic)
 				
 #undef ROUND
 #undef ROUND1		
Index: head-2007-03-19/arch/i386/lib/getuser.S
===================================================================
--- head-2007-03-19.orig/arch/i386/lib/getuser.S	2007-02-04 19:44:54.000000000 +0100
+++ head-2007-03-19/arch/i386/lib/getuser.S	2007-03-21 12:29:15.000000000 +0100
@@ -8,6 +8,8 @@
  * return an error value in addition to the "real"
  * return value.
  */
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
 #include <asm/thread_info.h>
 
 
@@ -24,19 +26,19 @@
  */
 
 .text
-.align 4
-.globl __get_user_1
-__get_user_1:
+ENTRY(__get_user_1)
+	CFI_STARTPROC
 	GET_THREAD_INFO(%edx)
 	cmpl TI_addr_limit(%edx),%eax
 	jae bad_get_user
 1:	movzbl (%eax),%edx
 	xorl %eax,%eax
 	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_1)
 
-.align 4
-.globl __get_user_2
-__get_user_2:
+ENTRY(__get_user_2)
+	CFI_STARTPROC
 	addl $1,%eax
 	jc bad_get_user
 	GET_THREAD_INFO(%edx)
@@ -45,10 +47,11 @@ __get_user_2:
 2:	movzwl -1(%eax),%edx
 	xorl %eax,%eax
 	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_2)
 
-.align 4
-.globl __get_user_4
-__get_user_4:
+ENTRY(__get_user_4)
+	CFI_STARTPROC
 	addl $3,%eax
 	jc bad_get_user
 	GET_THREAD_INFO(%edx)
@@ -57,11 +60,16 @@ __get_user_4:
 3:	movl -3(%eax),%edx
 	xorl %eax,%eax
 	ret
+	CFI_ENDPROC
+ENDPROC(__get_user_4)
 
 bad_get_user:
+	CFI_STARTPROC
 	xorl %edx,%edx
 	movl $-14,%eax
 	ret
+	CFI_ENDPROC
+END(bad_get_user)
 
 .section __ex_table,"a"
 	.long 1b,bad_get_user
Index: head-2007-03-19/arch/i386/lib/putuser.S
===================================================================
--- head-2007-03-19.orig/arch/i386/lib/putuser.S	2007-02-04 19:44:54.000000000 +0100
+++ head-2007-03-19/arch/i386/lib/putuser.S	2007-03-21 12:29:15.000000000 +0100
@@ -8,6 +8,8 @@
  * return an error value in addition to the "real"
  * return value.
  */
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
 #include <asm/thread_info.h>
 
 
@@ -23,23 +25,28 @@
  * as they get called from within inline assembly.
  */
 
-#define ENTER	pushl %ebx ; GET_THREAD_INFO(%ebx)
-#define EXIT	popl %ebx ; ret
+#define ENTER	CFI_STARTPROC ; \
+		pushl %ebx ; \
+		CFI_ADJUST_CFA_OFFSET 4 ; \
+		CFI_REL_OFFSET ebx, 0 ; \
+		GET_THREAD_INFO(%ebx)
+#define EXIT	popl %ebx ; \
+		CFI_ADJUST_CFA_OFFSET -4 ; \
+		CFI_RESTORE ebx ; \
+		ret ; \
+		CFI_ENDPROC
 
 .text
-.align 4
-.globl __put_user_1
-__put_user_1:
+ENTRY(__put_user_1)
 	ENTER
 	cmpl TI_addr_limit(%ebx),%ecx
 	jae bad_put_user
 1:	movb %al,(%ecx)
 	xorl %eax,%eax
 	EXIT
+ENDPROC(__put_user_1)
 
-.align 4
-.globl __put_user_2
-__put_user_2:
+ENTRY(__put_user_2)
 	ENTER
 	movl TI_addr_limit(%ebx),%ebx
 	subl $1,%ebx
@@ -48,10 +55,9 @@ __put_user_2:
 2:	movw %ax,(%ecx)
 	xorl %eax,%eax
 	EXIT
+ENDPROC(__put_user_2)
 
-.align 4
-.globl __put_user_4
-__put_user_4:
+ENTRY(__put_user_4)
 	ENTER
 	movl TI_addr_limit(%ebx),%ebx
 	subl $3,%ebx
@@ -60,10 +66,9 @@ __put_user_4:
 3:	movl %eax,(%ecx)
 	xorl %eax,%eax
 	EXIT
+ENDPROC(__put_user_4)
 
-.align 4
-.globl __put_user_8
-__put_user_8:
+ENTRY(__put_user_8)
 	ENTER
 	movl TI_addr_limit(%ebx),%ebx
 	subl $7,%ebx
@@ -73,10 +78,16 @@ __put_user_8:
 5:	movl %edx,4(%ecx)
 	xorl %eax,%eax
 	EXIT
+ENDPROC(__put_user_8)
 
 bad_put_user:
+	CFI_STARTPROC simple
+	CFI_DEF_CFA esp, 2*4
+	CFI_OFFSET eip, -1*4
+	CFI_OFFSET ebx, -2*4
 	movl $-14,%eax
 	EXIT
+END(bad_put_user)
 
 .section __ex_table,"a"
 	.long 1b,bad_put_user

