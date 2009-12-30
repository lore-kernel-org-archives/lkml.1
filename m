Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZL3MXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZL3MXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZL3MXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:23:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:42556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZL3MXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:23:48 -0500
Date: Wed, 30 Dec 2009 12:22:36 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, npiggin@suse.de, jbeulich@novell.com,
       akpm@linux-foundation.org, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jbeulich@novell.com, torvalds@linux-foundation.org, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B2BB8D30200007800026AF2@vpn.id2.novell.com>
References: <4B2BB8D30200007800026AF2@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Modify memcpy()/memset() alternatives mechanism
Message-ID: <tip-7269e8812a59f74fb1ce134465d0bcf5683b93a1@git.kernel.org>
Git-Commit-ID: 7269e8812a59f74fb1ce134465d0bcf5683b93a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7269e8812a59f74fb1ce134465d0bcf5683b93a1
Gitweb:     http://git.kernel.org/tip/7269e8812a59f74fb1ce134465d0bcf5683b93a1
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 18 Dec 2009 16:16:03 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:57:32 +0100

x86-64: Modify memcpy()/memset() alternatives mechanism

In order to avoid unnecessary chains of branches, rather than
implementing memcpy()/memset()'s access to their alternative
implementations via a jump, patch the (larger) original function
directly.

The memcpy() part of this is slightly subtle: while alternative
instruction patching does itself use memcpy(), with the
replacement block being less than 64-bytes in size the main loop
of the original function doesn't get used for copying memcpy_c()
over memcpy(), and hence we can safely write over its beginning.

Also note that the CFI annotations are fine for both variants of
each of the functions.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4B2BB8D30200007800026AF2@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/memcpy_64.S |   23 ++++++++---------------
 arch/x86/lib/memset_64.S |   18 ++++++------------
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index ad5441e..f82e884 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
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
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 2c59481..e88d3b8 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
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
