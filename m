Return-Path: <linux-kernel-owner+w=401wt.eu-S1163434AbXD1SNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163434AbXD1SNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163431AbXD1SNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:13:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163301AbXD1Rwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:47 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [19/35] i386: Add dwarf2 annotations to *_user and checksum functions
Message-Id: <20070428175244.2B569151F2@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jan Beulich <jbeulich@novell.com>


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/lib/checksum.S |   69 ++++++++++++++++++++++++++++++++++++++++-------
 arch/i386/lib/getuser.S  |   26 +++++++++++------
 arch/i386/lib/putuser.S  |   39 +++++++++++++++++---------
 3 files changed, 102 insertions(+), 32 deletions(-)

Index: linux/arch/i386/lib/checksum.S
===================================================================
--- linux.orig/arch/i386/lib/checksum.S
+++ linux/arch/i386/lib/checksum.S
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
Index: linux/arch/i386/lib/getuser.S
===================================================================
--- linux.orig/arch/i386/lib/getuser.S
+++ linux/arch/i386/lib/getuser.S
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
Index: linux/arch/i386/lib/putuser.S
===================================================================
--- linux.orig/arch/i386/lib/putuser.S
+++ linux/arch/i386/lib/putuser.S
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
