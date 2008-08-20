Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYHTIo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYHTIo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYHTIot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:44:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:55813 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYHTIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TUVLgfR4ov9cEw8iWQhNUnzULsuT4kmWsv1fbS4VreoiPYVFmhHz/PG3oHCgM6agxb
         fLyuHmYhtNJixJ+pG5O8BYX06QIZ2KByBoeoJG14v6FO/PF+unb1h5A6S90R3MuypKWE
         ij3JVkWjvegxsPNxtATAN7YfP8S2dglO0m3Vw=
Message-ID: <5787cf470808200144ta2f28b4nd9b2922cbec73d78@mail.gmail.com>
Date: Wed, 20 Aug 2008 10:44:47 +0200
From: "Uros Bizjak" <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Use X86_CR4_PGE in x86/power/hibernate_asm_32.S
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
diff --git a/arch/x86/power/hibernate_asm_32.S
b/arch/x86/power/hibernate_asm_32.S
index 4fc7e87..6fa219e 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -1,5 +1,3 @@
-.text
-
 /*
  * This may not use any stack, nor any variable that is not "NoSave":
  *
@@ -8,21 +6,21 @@
  * your own stack under you is bad idea.
  */

+	.text
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
-
-	.text
+#include <asm/processor-flags.h>

 ENTRY(swsusp_arch_suspend)
-
 	movl %esp, saved_context_esp
 	movl %ebx, saved_context_ebx
 	movl %ebp, saved_context_ebp
 	movl %esi, saved_context_esi
 	movl %edi, saved_context_edi
-	pushfl ; popl saved_context_eflags
+	pushfl
+	popl saved_context_eflags

 	call swsusp_save
 	ret
@@ -59,7 +57,7 @@ done:
 	movl	mmu_cr4_features, %ecx
 	jecxz	1f	# cr4 Pentium and higher, skip if zero
 	movl	%ecx, %edx
-	andl	$~(1<<7), %edx;  # PGE
+	andl	$~(X86_CR4_PGE), %edx
 	movl	%edx, %cr4;  # turn off PGE
 1:
 	movl	%cr3, %eax;  # flush TLB
@@ -74,7 +72,8 @@ done:
 	movl saved_context_esi, %esi
 	movl saved_context_edi, %edi

-	pushl saved_context_eflags ; popfl
+	pushl saved_context_eflags
+	popfl

 	xorl	%eax, %eax
