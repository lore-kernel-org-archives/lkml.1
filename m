Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbYG1OSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbYG1OSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYG1OSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:18:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:7673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbYG1OSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=UDxqVaq1GIQcd8oWS5oQQVZuUkQeJEp5uWZL+yBqIGubSut4jedbwhul3Cp/Pzcapd
         w3ig1F4457D8yHZuQAonrVxe6YgQpUzobKD8vmv3OaiApsCjTzZNFPNIhl/ucJHBriC9
         qfGi0Wg8gdv/7cBSLrt7cugzNorN+h8N0krOk=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Set clear flag in copy_from_user/copy_to_user
Date: Mon, 28 Jul 2008 16:18:21 +0200
Message-ID: <m3ej5edrde.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only copy_to_user should clear the rest of uncopied area. copy_user
routines were modified for passing clear flag to handle tail routine,
clear flag set/reset explicitly in copy_to_user/copy_from_user.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index dfdf428..dd59c48 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -38,21 +38,21 @@
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
 	/* check for bad alignment of destination */
-	movl %edi,%ecx
-	andl $7,%ecx
+	movl %edi,%r8d
+	andl $7,%r8d
 	jz 102f				/* already aligned */
-	subl $8,%ecx
-	negl %ecx
-	subl %ecx,%edx
+	subl $8,%r8d
+	negl %r8d
+	subl %r8d,%edx
 100:	movb (%rsi),%al
 101:	movb %al,(%rdi)
 	incq %rsi
 	incq %rdi
-	decl %ecx
+	decl %r8d
 	jnz 100b
 102:
 	.section .fixup,"ax"
-103:	addl %r8d,%edx			/* ecx is zerorest also */
+103:	addl %r8d,%edx
 	jmp copy_user_handle_tail
 	.previous
 
@@ -73,6 +73,7 @@ ENTRY(copy_to_user)
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_to_user
+	movl $1,%ecx	/* clear tail */
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 
@@ -85,18 +86,21 @@ ENTRY(copy_from_user)
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_from_user
+	xorl %ecx,%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(copy_from_user)
 
 ENTRY(copy_user_generic)
 	CFI_STARTPROC
+	xorl %ecx,%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(copy_user_generic)
 
 ENTRY(__copy_from_user_inatomic)
 	CFI_STARTPROC
+	xorl %ecx,%ecx
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(__copy_from_user_inatomic)
@@ -125,7 +129,8 @@ ENDPROC(bad_from_user)
  * Input:
  * rdi destination
  * rsi source
- * rdx count
+ * edx count
+ * ecx clear flag
  *
  * Output:
  * eax uncopied bytes or 0 if successfull.
@@ -135,6 +140,7 @@ ENTRY(copy_user_generic_unrolled)
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
+	movl %ecx,%eax	/* save clear flag in eax */
 	movl %edx,%ecx
 	andl $63,%edx
 	shrl $6,%ecx
@@ -169,11 +175,11 @@ ENTRY(copy_user_generic_unrolled)
 	leaq 8(%rdi),%rdi
 	decl %ecx
 	jnz 18b
-20:	andl %edx,%edx
+20:	testl %edx,%edx
 	jz 23f
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+21:	movb (%rsi),%dl
+22:	movb %dl,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
@@ -188,7 +194,8 @@ ENTRY(copy_user_generic_unrolled)
 40:	lea (%rdx,%rcx,8),%rdx
 	jmp 60f
 50:	movl %ecx,%edx
-60:	jmp copy_user_handle_tail /* ecx is zerorest also */
+60:	movl %eax,%ecx	/* get clear flag back to ecx*/
+	jmp copy_user_handle_tail
 	.previous
 
 	.section __ex_table,"a"
@@ -230,15 +237,15 @@ ENDPROC(copy_user_generic_unrolled)
  * Input:
  * rdi destination
  * rsi source
- * rdx count
+ * edx count
+ * ecx clear flag
  *
  * Output:
  * eax uncopied bytes or 0 if successful.
  */
 ENTRY(copy_user_generic_string)
 	CFI_STARTPROC
-	andl %edx,%edx
-	jz 4f
+	movl %ecx,%eax	/* save clear_rest flag */
 	cmpl $8,%edx
 	jb 2f		/* less than 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -250,12 +257,13 @@ ENTRY(copy_user_generic_string)
 2:	movl %edx,%ecx
 3:	rep
 	movsb
-4:	xorl %eax,%eax
+	xorl %eax,%eax
 	ret
 
 	.section .fixup,"ax"
 11:	lea (%rdx,%rcx,8),%rcx
-12:	movl %ecx,%edx		/* ecx is zerorest also */
+12:	movl %ecx,%edx
+	movl %eax,%ecx	/* get clear flag back to ecx */
 	jmp copy_user_handle_tail
 	.previous
 
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 40e0e30..d3a5358 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -18,21 +18,21 @@
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
 	/* check for bad alignment of destination */
-	movl %edi,%ecx
-	andl $7,%ecx
+	movl %edi,%r8d
+	andl $7,%r8d
 	jz 102f				/* already aligned */
-	subl $8,%ecx
-	negl %ecx
-	subl %ecx,%edx
+	subl $8,%r8d
+	negl %r8d
+	subl %r8d,%edx
 100:	movb (%rsi),%al
 101:	movb %al,(%rdi)
 	incq %rsi
 	incq %rdi
-	decl %ecx
+	decl %r8d
 	jnz 100b
 102:
 	.section .fixup,"ax"
-103:	addl %r8d,%edx			/* ecx is zerorest also */
+103:	addl %r8d,%edx
 	jmp copy_user_handle_tail
 	.previous
 
@@ -53,6 +53,7 @@ ENTRY(__copy_user_nocache)
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
+	movl %ecx,%eax	/* save clear flag in eax */
 	movl %edx,%ecx
 	andl $63,%edx
 	shrl $6,%ecx
@@ -87,11 +88,11 @@ ENTRY(__copy_user_nocache)
 	leaq 8(%rdi),%rdi
 	decl %ecx
 	jnz 18b
-20:	andl %edx,%edx
+20:	testl %edx,%edx
 	jz 23f
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+21:	movb (%rsi),%dl
+22:	movb %dl,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
@@ -108,7 +109,7 @@ ENTRY(__copy_user_nocache)
 	jmp 60f
 50:	movl %ecx,%edx
 60:	sfence
-	movl %r8d,%ecx
+	movl %eax,%ecx	/* get clear flag back to ecx*/
 	jmp copy_user_handle_tail
 	.previous
 


-- 
wbr, Vitaly
