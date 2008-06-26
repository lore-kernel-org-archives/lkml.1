Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbYFZJNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbYFZJNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:12:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYFZJM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:12:57 -0400
Message-ID: <48635DA0.80102@redhat.com>
Date: Thu, 26 Jun 2008 11:13:04 +0200
From: Anton Arapov <aarapov@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix copy_user on x86_64
References: <m3myl9hf0o.fsf@gravicappa.englab.brq.redhat.com>
In-Reply-To: <m3myl9hf0o.fsf@gravicappa.englab.brq.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080002070303060308080100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002070303060308080100
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Just in order to bring your attention!

This is the patch patch for copy_user routine, you've discussed recently.

I'm attached updated patch, in order to pass 'checkpatch.pl' tool process smoothly.
Couple of extra whitespace has been removed and signed-off and acked-by lines 
added.

Patch cleanly applies to current git tree.

-Anton

Vitaly Mayatskikh wrote:
> Bug in copy_user can be used from userspace on RHEL-4 and other
> distributions with similar kernel base (CVE-2008-0598). Patch with fixed
> copy_user attached, it falls into byte copy loop on faults and returns
> correct count for uncopied bytes. Patch also fixes incorrect passing of
> zero flag in copy_to_user (%eax was used instead of %ecx).
> 
> Also there's script for systemtap, it tests corner cases in both
> copy_user realizations (unrolled and string).
> 
> 
> 
> ------------------------------------------------------------------------
> 
> 

--------------080002070303060308080100
Content-Type: text/x-patch;
 name="copy_user.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="copy_user.patch"


Bug in copy_user can be used from userspace on RHEL-4 and other
distributions with similar kernel base (CVE-2008-0598). Patch with fixed
copy_user attached, it falls into byte copy loop on faults and returns
correct count for uncopied bytes. Patch also fixes incorrect passing of
zero flag in copy_to_user (%eax was used instead of %ecx).

Also there's script for systemtap, it tests corner cases in both
copy_user realizations (unrolled and string).


Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Acked-by: Anton Arapov <aarapov@redhat.com>

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index ee1c3f6..6402891 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -42,7 +42,7 @@ ENTRY(copy_to_user)
 	jc  bad_to_user
 	cmpq threadinfo_addr_limit(%rax),%rcx
 	jae bad_to_user
-	xorl %eax,%eax	/* clear zero flag */
+	xorl %ecx,%ecx	/* clear zero flag */
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 
@@ -170,8 +170,8 @@ ENTRY(copy_user_generic_unrolled)
 	jnz .Lloop_8
 
 .Lhandle_7:
+	andl $7,%edx
 	movl %edx,%ecx
-	andl $7,%ecx
 	jz   .Lende
 	.p2align 4
 .Lloop_1:
@@ -218,41 +218,74 @@ ENTRY(copy_user_generic_unrolled)
 	.section __ex_table,"a"
 	.align 8
 	.quad .Ls1,.Ls1e	/* Ls1-Ls4 have copied zero bytes */
-	.quad .Ls2,.Ls1e
-	.quad .Ls3,.Ls1e
-	.quad .Ls4,.Ls1e
-	.quad .Ld1,.Ls1e	/* Ld1-Ld4 have copied 0-24 bytes */
-	.quad .Ld2,.Ls2e
-	.quad .Ld3,.Ls3e
-	.quad .Ld4,.Ls4e
+	.quad .Ls2,.Ls2e
+	.quad .Ls3,.Ls3e
+	.quad .Ls4,.Ls4e
+	.quad .Ld1,.Ld1e	/* Ld1-Ld4 have copied 0-24 bytes */
+	.quad .Ld2,.Ld2e
+	.quad .Ld3,.Ld3e
+	.quad .Ld4,.Ld4e
 	.quad .Ls5,.Ls5e	/* Ls5-Ls8 have copied 32 bytes */
-	.quad .Ls6,.Ls5e
-	.quad .Ls7,.Ls5e
-	.quad .Ls8,.Ls5e
-	.quad .Ld5,.Ls5e	/* Ld5-Ld8 have copied 32-56 bytes */
-	.quad .Ld6,.Ls6e
-	.quad .Ld7,.Ls7e
-	.quad .Ld8,.Ls8e
-	.quad .Ls9,.Le_quad
-	.quad .Ld9,.Le_quad
+	.quad .Ls6,.Ls6e
+	.quad .Ls7,.Ls7e
+	.quad .Ls8,.Ls8e
+	.quad .Ld5,.Ld5e	/* Ld5-Ld8 have copied 32-56 bytes */
+	.quad .Ld6,.Ld6e
+	.quad .Ld7,.Ld7e
+	.quad .Ld8,.Ld8e
+	.quad .Ls9,.Ls9e
+	.quad .Ld9,.Ld9e
 	.quad .Ls10,.Le_byte
 	.quad .Ld10,.Le_byte
 #ifdef FIX_ALIGNMENT
 	.quad .Ls11,.Lzero_rest
 	.quad .Ld11,.Lzero_rest
 #endif
+	.quad .Lt1,.Lt1e
 	.quad .Le5,.Le_zero
 	.previous
 
+	/* Exception on read in unrolled loop
+	   Don't forget to store registers, which were loaded before fault.
+	   Otherwise we will have up to 24 bytes of garbage and possible
+	   security leak */
+.Ls8e:	addl $8,%eax
+	movq %r9,6*8(%rdi)
+.Ls7e:	addl $8,%eax
+	movq %r8,5*8(%rdi)
+.Ls6e:	addl $8,%eax
+	movq %r11,4*8(%rdi)
+.Ls5e:	addl $32,%eax
+	jmp .Ls1e
+
+.Ls4e:	addl $8,%eax
+	movq %r9,2*8(%rdi)
+.Ls3e:	addl $8,%eax
+	movq %r8,1*8(%rdi)
+.Ls2e:	addl $8,%eax
+	movq %r11,(%rdi)
+.Ls1e:	addq %rax,%rdi
+	addq %rax,%rsi
+	shlq $6,%rdx
+	addq %rbx,%rdx
+	subq %rax,%rdx
+	andl $63,%ecx
+	addq %rdx,%rcx
+.Lt1:	rep		/* copy last bytes */
+	movsb
+.Lt1e:	movq %rcx,%rdx
+	jmp .Lzero_rest
+
+	/* Exception on write in unrolled loop */
 	/* eax: zero, ebx: 64 */
-.Ls1e: 	addl $8,%eax		/* eax is bytes left uncopied within the loop (Ls1e: 64 .. Ls8e: 8) */
-.Ls2e: 	addl $8,%eax
-.Ls3e: 	addl $8,%eax
-.Ls4e: 	addl $8,%eax
-.Ls5e: 	addl $8,%eax
-.Ls6e: 	addl $8,%eax
-.Ls7e: 	addl $8,%eax
-.Ls8e: 	addl $8,%eax
+.Ld1e: 	addl $8,%eax		/* eax is bytes left uncopied within the loop (Ls1e: 64 .. Ls8e: 8) */
+.Ld2e: 	addl $8,%eax
+.Ld3e: 	addl $8,%eax
+.Ld4e: 	addl $8,%eax
+.Ld5e: 	addl $8,%eax
+.Ld6e: 	addl $8,%eax
+.Ld7e: 	addl $8,%eax
+.Ld8e: 	addl $8,%eax
 	addq %rbx,%rdi	/* +64 */
 	subq %rax,%rdi  /* correct destination with computed offset */
 
@@ -260,19 +293,27 @@ ENTRY(copy_user_generic_unrolled)
 	addq %rax,%rdx	/* add offset to loopcnt */
 	andl $63,%ecx	/* remaining bytes */
 	addq %rcx,%rdx	/* add them */
-	jmp .Lzero_rest
+	jmp .Le_zero	/* fault in dst, just return */
 
-	/* exception on quad word loop in tail handling */
+	/* Exception on read in quad word loop in tail handling */
 	/* ecx:	loopcnt/8, %edx: length, rdi: correct */
-.Le_quad:
-	shll $3,%ecx
+.Ls9e:	shll $3,%ecx	/* fault in src of quad loop */
+	andl $7,%edx
+	addl %edx,%ecx
+	jmp .Lt1	/* try to copy last bytes */
+
+	/* Exception on write in quad word loop in tail handling */
+.Ld9e:	shll $3,%ecx	/* fault in dst of quad loop */
 	andl $7,%edx
 	addl %ecx,%edx
+	jmp .Le_zero	/* fault in dst, just return */
+
 	/* edx: bytes to zero, rdi: dest, eax:zero */
 .Lzero_rest:
 	cmpl $0,(%rsp)
 	jz   .Le_zero
 	movq %rdx,%rcx
+	/* Exception on read or write in byte loop in tail handling */
 .Le_byte:
 	xorl %eax,%eax
 .Le5:	rep
@@ -308,44 +349,39 @@ ENDPROC(copy_user_generic)
 ENTRY(copy_user_generic_string)
 	CFI_STARTPROC
 	movl %ecx,%r8d		/* save zero flag */
+	xorq %rax,%rax
 	movl %edx,%ecx
 	shrl $3,%ecx
-	andl $7,%edx	
-	jz   10f
-1:	rep 
-	movsq 
+	andl $7,%edx
+	andl %r8d,%r8d		/* store zero flag in eflags */
+.Lc1:	rep
+	movsq
 	movl %edx,%ecx
-2:	rep
+.Lc2:	rep
 	movsb
-9:	movl %ecx,%eax
 	ret
 
-	/* multiple of 8 byte */
-10:	rep
-	movsq
-	xor %eax,%eax
+.Lc1e:	leaq (%rdx,%rcx,8),%r8
+	movl %r8d,%ecx
+.Lc3:	rep			/* try to use byte copy */
+	movsb
+.Lc3e:	movl %ecx,%r8d
+	jz .Lc4e		/* rep movs* does not affect eflags */
+.Lc4:	rep
+	stosb
+.Lc4e:	movl %r8d,%eax
 	ret
 
-	/* exception handling */
-3:      lea (%rdx,%rcx,8),%rax	/* exception on quad loop */
-	jmp 6f
-5:	movl %ecx,%eax		/* exception on byte loop */
-	/* eax: left over bytes */
-6:	testl %r8d,%r8d		/* zero flag set? */
-	jz 7f
-	movl %eax,%ecx		/* initialize x86 loop counter */
-	push %rax
-	xorl %eax,%eax
-8:	rep
-	stosb 			/* zero the rest */
-11:	pop %rax
-7:	ret
+.Lc2e:	movl %ecx,%r8d
+	jz .Lc4e
+	jmp .Lc4
 	CFI_ENDPROC
-END(copy_user_generic_c)
+ENDPROC(copy_user_generic_string)
 
 	.section __ex_table,"a"
-	.quad 1b,3b
-	.quad 2b,5b
-	.quad 8b,11b
-	.quad 10b,3b
+	.align 8
+	.quad .Lc1,.Lc1e
+	.quad .Lc2,.Lc2e
+	.quad .Lc3,.Lc3e
+	.quad .Lc4,.Lc4e
 	.previous
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 9d3d1ab..b34b6bd 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -146,41 +146,74 @@ ENTRY(__copy_user_nocache)
 	.section __ex_table,"a"
 	.align 8
 	.quad .Ls1,.Ls1e	/* .Ls[1-4] - 0 bytes copied */
-	.quad .Ls2,.Ls1e
-	.quad .Ls3,.Ls1e
-	.quad .Ls4,.Ls1e
-	.quad .Ld1,.Ls1e	/* .Ld[1-4] - 0..24 bytes coped */
-	.quad .Ld2,.Ls2e
-	.quad .Ld3,.Ls3e
-	.quad .Ld4,.Ls4e
+	.quad .Ls2,.Ls2e
+	.quad .Ls3,.Ls3e
+	.quad .Ls4,.Ls4e
+	.quad .Ld1,.Ld1e	/* .Ld[1-4] - 0..24 bytes coped */
+	.quad .Ld2,.Ld2e
+	.quad .Ld3,.Ld3e
+	.quad .Ld4,.Ld4e
 	.quad .Ls5,.Ls5e	/* .Ls[5-8] - 32 bytes copied */
-	.quad .Ls6,.Ls5e
-	.quad .Ls7,.Ls5e
-	.quad .Ls8,.Ls5e
-	.quad .Ld5,.Ls5e	/* .Ld[5-8] - 32..56 bytes copied */
-	.quad .Ld6,.Ls6e
-	.quad .Ld7,.Ls7e
-	.quad .Ld8,.Ls8e
-	.quad .Ls9,.Le_quad
-	.quad .Ld9,.Le_quad
+	.quad .Ls6,.Ls6e
+	.quad .Ls7,.Ls7e
+	.quad .Ls8,.Ls8e
+	.quad .Ld5,.Ld5e	/* .Ld[5-8] - 32..56 bytes copied */
+	.quad .Ld6,.Ld6e
+	.quad .Ld7,.Ld7e
+	.quad .Ld8,.Ld8e
+	.quad .Ls9,.Ls9e
+	.quad .Ld9,.Ld9e
 	.quad .Ls10,.Le_byte
 	.quad .Ld10,.Le_byte
 #ifdef FIX_ALIGNMENT
 	.quad .Ls11,.Lzero_rest
 	.quad .Ld11,.Lzero_rest
 #endif
+	.quad .Lt1,.Lt1e
 	.quad .Le5,.Le_zero
 	.previous
 
+	/* Exception on read in unrolled loop
+	   Don't forget to store registers, which were loaded before fault.
+	   Otherwise we will have up to 24 bytes of garbage and possible
+	   security leak */
+.Ls8e:	addl $8,%eax
+	movq %r9,6*8(%rdi)
+.Ls7e:	addl $8,%eax
+	movq %r8,5*8(%rdi)
+.Ls6e:	addl $8,%eax
+	movq %r11,4*8(%rdi)
+.Ls5e:	addl $32,%eax
+	jmp .Ls1e
+
+.Ls4e:	addl $8,%eax
+	movq %r9,2*8(%rdi)
+.Ls3e:	addl $8,%eax
+	movq %r8,1*8(%rdi)
+.Ls2e:	addl $8,%eax
+	movq %r11,(%rdi)
+.Ls1e:	addq %rax,%rdi
+	addq %rax,%rsi
+	shlq $6,%rdx
+	addq %rbx,%rdx
+	subq %rax,%rdx
+	andl $63,%ecx
+	addq %rdx,%rcx
+.Lt1:	rep		/* copy last bytes */
+	movsb
+.Lt1e:	movq %rcx,%rdx
+	jmp .Lzero_rest
+
+	/* Exception on write in unrolled loop */
 	/* eax: zero, ebx: 64 */
-.Ls1e: 	addl $8,%eax	/* eax: bytes left uncopied: Ls1e: 64 .. Ls8e: 8 */
-.Ls2e: 	addl $8,%eax
-.Ls3e: 	addl $8,%eax
-.Ls4e: 	addl $8,%eax
-.Ls5e: 	addl $8,%eax
-.Ls6e: 	addl $8,%eax
-.Ls7e: 	addl $8,%eax
-.Ls8e: 	addl $8,%eax
+.Ld1e: 	addl $8,%eax		/* eax is bytes left uncopied within the loop (Ls1e: 64 .. Ls8e: 8) */
+.Ld2e: 	addl $8,%eax
+.Ld3e: 	addl $8,%eax
+.Ld4e: 	addl $8,%eax
+.Ld5e: 	addl $8,%eax
+.Ld6e: 	addl $8,%eax
+.Ld7e: 	addl $8,%eax
+.Ld8e: 	addl $8,%eax
 	addq %rbx,%rdi	/* +64 */
 	subq %rax,%rdi  /* correct destination with computed offset */
 
@@ -188,19 +221,27 @@ ENTRY(__copy_user_nocache)
 	addq %rax,%rdx	/* add offset to loopcnt */
 	andl $63,%ecx	/* remaining bytes */
 	addq %rcx,%rdx	/* add them */
-	jmp .Lzero_rest
+	jmp .Le_zero	/* fault in dst, just return */
 
-	/* exception on quad word loop in tail handling */
+	/* Exception on read in quad word loop in tail handling */
 	/* ecx:	loopcnt/8, %edx: length, rdi: correct */
-.Le_quad:
-	shll $3,%ecx
+.Ls9e:	shll $3,%ecx	/* fault in src of quad loop */
+	andl $7,%edx
+	addl %edx,%ecx
+	jmp .Lt1	/* try to copy last bytes */
+
+	/* Exception on write in quad word loop in tail handling */
+.Ld9e:	shll $3,%ecx	/* fault in dst of quad loop */
 	andl $7,%edx
 	addl %ecx,%edx
+	jmp .Le_zero	/* fault in dst, just return */
+
 	/* edx: bytes to zero, rdi: dest, eax:zero */
 .Lzero_rest:
 	cmpl $0,(%rsp)	/* zero flag set? */
 	jz   .Le_zero
 	movq %rdx,%rcx
+	/* Exception on read or write in byte loop in tail handling */
 .Le_byte:
 	xorl %eax,%eax
 .Le5:	rep

--------------080002070303060308080100--
