Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZLRQPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZLRQPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbZLRQPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:15:12 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40453 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbZLRQPK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 18 Dec 2009 11:15:10 -0500
Message-Id: <4B2BB8D30200007800026AF2@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Dec 2009 16:16:03 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: modify memcpy()/memset() alternatives
	 mechanism
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid unnecessary chains of branches, rather than
implementing memcpy()/memset()'s access to their alternative
implementations via a jump, patch the (larger) original function
directly.

The memcpy() part of this is slightly subtle: While alternative
instruction patching does itself use memcpy(), with the replacement
block being less than 64-bytes in size the main loop of the original
function doesn't get used for copying memcpy_c() over memcpy(), and
hence we can safely write over its beginning.

Also note that the CFI annotations are fine for both variants of each
of the functions.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 arch/x86/lib/memcpy_64.S |   23 ++++++++---------------
 arch/x86/lib/memset_64.S |   18 ++++++------------
 2 files changed, 14 insertions(+), 27 deletions(-)

--- linux-2.6.33-rc1/arch/x86/lib/memcpy_64.S	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.33-rc1-x86_64-memcpy-memset-alternative/arch/x86/lib/memcpy_64.S	2009-11-16 16:10:22.000000000 +0100
@@ -20,12 +20,11 @@
 /*
  * memcpy_c() - fast string ops (REP MOVSQ) based variant.
  *
- * Calls to this get patched into the kernel image via the
+ * This gets patched over the unrolled variant (below) via the
  * alternative instructions framework:
  */
-	ALIGN
-memcpy_c:
-	CFI_STARTPROC
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemcpy_c:
 	movq %rdi, %rax
 
 	movl %edx, %ecx
@@ -35,8 +34,8 @@ memcpy_c:
 	movl %edx, %ecx
 	rep movsb
 	ret
-	CFI_ENDPROC
-ENDPROC(memcpy_c)
+.Lmemcpy_e:
+	.previous
 
 ENTRY(__memcpy)
 ENTRY(memcpy)
@@ -128,16 +127,10 @@ ENDPROC(__memcpy)
 	 * It is also a lot simpler. Use this when possible:
 	 */
 
-	.section .altinstr_replacement, "ax"
-1:	.byte 0xeb				/* jmp <disp8> */
-	.byte (memcpy_c - memcpy) - (2f - 1b)	/* offset */
-2:
-	.previous
-
 	.section .altinstructions, "a"
 	.align 8
 	.quad memcpy
-	.quad 1b
+	.quad .Lmemcpy_c
 	.byte X86_FEATURE_REP_GOOD
 
 	/*
@@ -145,6 +138,6 @@ ENDPROC(__memcpy)
 	 * so it is silly to overwrite itself with nops - reboot is the
 	 * only outcome...
 	 */
-	.byte 2b - 1b
-	.byte 2b - 1b
+	.byte .Lmemcpy_e - .Lmemcpy_c
+	.byte .Lmemcpy_e - .Lmemcpy_c
 	.previous
--- linux-2.6.33-rc1/arch/x86/lib/memset_64.S	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.33-rc1-x86_64-memcpy-memset-alternative/arch/x86/lib/memset_64.S	2009-11-16 16:03:03.000000000 +0100
@@ -12,9 +12,8 @@
  * 
  * rax   original destination
  */	
-	ALIGN
-memset_c:
-	CFI_STARTPROC
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemset_c:
 	movq %rdi,%r9
 	movl %edx,%r8d
 	andl $7,%r8d
@@ -29,8 +28,8 @@ memset_c:
 	rep stosb
 	movq %r9,%rax
 	ret
-	CFI_ENDPROC
-ENDPROC(memset_c)
+.Lmemset_e:
+	.previous
 
 ENTRY(memset)
 ENTRY(__memset)
@@ -118,16 +117,11 @@ ENDPROC(__memset)
 
 #include <asm/cpufeature.h>
 
-	.section .altinstr_replacement,"ax"
-1:	.byte 0xeb				/* jmp <disp8> */
-	.byte (memset_c - memset) - (2f - 1b)	/* offset */
-2:
-	.previous
 	.section .altinstructions,"a"
 	.align 8
 	.quad memset
-	.quad 1b
+	.quad .Lmemset_c
 	.byte X86_FEATURE_REP_GOOD
 	.byte .Lfinal - memset
-	.byte 2b - 1b
+	.byte .Lmemset_e - .Lmemset_c
 	.previous



