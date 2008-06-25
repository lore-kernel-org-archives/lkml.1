Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYFYMcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYFYMcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYFYMb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:31:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:34834 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYFYMb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=HkwmmEQb47nEPf1ttF+x/w4HLQObynIkoOTF6fkTCzM/wSA33yXGbGdMihGdFGxKvW
         PNY0qBTZ7xqL6niCEgy7CXHrkcn2Y5FWyTBxA7o6tlmFQrwvdE36hLHj9sGYuRWZT+Kp
         NKawW5dn4eHFRUdxlIA6GrnlgpzEJKeGMpwl0=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix copy_user on x86_64
Date: Wed, 25 Jun 2008 14:31:51 +0200
Message-ID: <m3myl9hf0o.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Bug in copy_user can be used from userspace on RHEL-4 and other
distributions with similar kernel base (CVE-2008-0598). Patch with fixed
copy_user attached, it falls into byte copy loop on faults and returns
correct count for uncopied bytes. Patch also fixes incorrect passing of
zero flag in copy_to_user (%eax was used instead of %ecx).

Also there's script for systemtap, it tests corner cases in both
copy_user realizations (unrolled and string).


--=-=-=
Content-Disposition: inline; filename=copy_user.patch
Content-Description: fix copy_user

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

--=-=-=
Content-Disposition: inline; filename=copy.gen
Content-Description: test cases

function test_src:long(type:long, off:long, len:long, zero:long)
%{
        unsigned char *ptr;
        unsigned long addr;
        int ret = 0, cu_ret = 0, i;
        printk("testing src with '%s', off = %lld, len = %lld, zero tail = %lld\n", THIS->type ? "string" : "unrolled", THIS->off, THIS->len, THIS->zero);

        // vmalloc makes a hole after new vma
        ptr = vmalloc(PAGE_SIZE);
        printk("ptr = %p\n", ptr);

        // poison memory
        memset(ptr, 0xaa, PAGE_SIZE >> 1);

        // fill memory with pattern
        for (i = 0; i < PAGE_SIZE >> 1; ++i)
                ptr[i + (PAGE_SIZE >> 1)] = i & 0xff;

        // raise GPF

        addr = THIS->type ? _STRING_ : _UNROLLED_;
        asm ("call %%rax;"
             : "=a"(cu_ret)
             : "S"(ptr + PAGE_SIZE - THIS->off), "D" (ptr), "d"(THIS->len), "c"(THIS->zero),
               "a"(addr)
                );

        if (cu_ret)
                printk("copy_user GPF (%d bytes uncopied)\n", cu_ret);

        // dump
        for (i = 0; i < 256; ++i) {
                if (!(i % 8))
                        printk("\n%04x: ", i);
                printk("%02x ", ptr[i]);
        }

        printk("\n");

        // check for bug in copy_user_generic_unrolled
        for (i = 0; i < (THIS->off > THIS->len ? THIS->len : THIS->off) && !(ret & 1); ++i)
                if  (ptr[i] != ptr[i + PAGE_SIZE - THIS->off])
                        ret |= 1;

        if (cu_ret) {
                if (THIS->len - THIS->off != cu_ret)
                        ret |= 4;

                if (THIS->zero)
                // check for bug in copy_user_generic_c/string
                for (i = 0; i < cu_ret && !(ret & 2); ++i)
                        if (ptr[THIS->off + i])
                                ret |= 2;
        }
        vfree(ptr);
        THIS->__retvalue = ret;
%}

function test_dst:long(type:long, off:long, len:long, zero:long)
%{
        unsigned char *ptr;
        unsigned long addr;
        int ret = 0, cu_ret = 0, i;
        printk("testing dst with '%s', off = %lld, len = %lld, zero tail = %lld\n", THIS->type ? "string" : "unrolled", THIS->off, THIS->len, THIS->zero);

        // vmalloc makes a hole after new vma
        ptr = vmalloc(PAGE_SIZE);
        printk("ptr = %p\n", ptr);

        // poison memory
        memset(ptr + (PAGE_SIZE >> 1), 0xaa, PAGE_SIZE >> 1);

        // fill memory with pattern
        for (i = 0; i < PAGE_SIZE >> 1; ++i)
                ptr[i] = i & 0xff;

        // raise GPF

        addr = THIS->type ? _STRING_ : _UNROLLED_;
        asm ("call %%rax;"
             : "=a"(cu_ret)
             : "S"(ptr), "D" (ptr + PAGE_SIZE - THIS->off), "d"(THIS->len), "c"(THIS->zero),
               "a"(addr)
                );

        if (cu_ret)
                printk("copy_user GPF (%d bytes uncopied)\n", cu_ret);

        // dump
        for (i = PAGE_SIZE - 256; i < PAGE_SIZE; ++i) {
                if (!(i % 8))
                        printk("\n%04x: ", i);
                printk("%02x ", ptr[i]);
        }

        printk("\n");

        for (i = 0; i < (THIS->off > THIS->len ? THIS->len : THIS->off) && !(ret & 1); ++i)
                if (ptr[i] != ptr[PAGE_SIZE - THIS->off + i])
                        ret |= 1;

        vfree(ptr);
        THIS->__retvalue = ret;
%}

function run_test:long(type:long, off:long, len:long, zero:long)
{
        m = test_src(type, off, len, zero);
        printf("testing src '%s', off = %d, len = %d, zero tail = %d, buggy: %s\n", type ? "string" : "unrolled", off, len, zero, m ? "yes" : "no");
        if (m) {
                if (m & 1)
                        printf("copy_user BUG #0: valid data was not stored\n");
                if (m & 2)
                        printf("copy_user BUG #1: tail not zeroed\n");
                if (m & 4)
                        printf("copy_user BUG #2: uncopied bytes miscalculation\n");
        }
        n = test_dst(type, off, len, zero);
        printf("testing dst '%s', off = %d, len = %d, zero tail = %d, buggy: %s\n", type ? "string" : "unrolled", off, len, zero, n ? "yes" : "no");
        if (n) {
                if (n & 1)
                        printf("copy_user BUG #3: copied data unequal\n");
        }
        return m + n;
}

%( kernel_v <= "2.6.18" %?
        function get_feature:long()
        %{
                 THIS->__retvalue = boot_cpu_has(3*32+ 4); // X86_FEATURE_K8_C in RHEL-4 or X86_FEATURE_REP_GOOD in RHEL-5
        %}

        %:

        function get_feature:long()
        %{
                 THIS->__retvalue = boot_cpu_has(3*32+ 16); // X86_FEATURE_REP_GOOD in upstream
        %}
%)

probe begin
{
        printf("begin\n");
        printf("kernel uses '%s' version of copy_user\n", get_feature() ? "string" : "unrolled");
        i = 0;

        i += run_test(0, 56, 3, 1); // zero tail
        i += run_test(1, 56, 3, 1); // zero tail
        i += run_test(0, 56, 3, 0);
        i += run_test(1, 56, 3, 0);

        i += run_test(0, 56, 128, 1); // unrolled loop, zero tail
        i += run_test(1, 56, 128, 1); // movsq, zero tail
        i += run_test(0, 56, 128, 0); // unrolled loop
        i += run_test(1, 56, 128, 0); // movsq

        i += run_test(0, 9, 128, 1);  // unrolled loop, zero tail
        i += run_test(1, 9, 128, 1);  // movsq, zero tail
        i += run_test(0, 9, 128, 0);  // unrolled loop
        i += run_test(1, 9, 128, 0);  // movsq

        i += run_test(0, 9, 9, 1);    // quad word loop + byte loop, zero tail
        i += run_test(1, 9, 9, 1);    // movsq + movsb, zero tail
        i += run_test(0, 9, 9, 0);    // quad word loop + byte loop
        i += run_test(1, 9, 9, 0);    // movsq + movsb

        i += run_test(0, 8, 9, 1);    // quad word loop + byte loop, zero tail
        i += run_test(1, 8, 9, 1);    // movsq + movsb, zero tail
        i += run_test(0, 8, 9, 0);    // quad word loop + byte loop
        i += run_test(1, 8, 9, 0);    // movsq + movsb

        i += run_test(0, 1, 8, 1);    // quad word loop, zero tail
        i += run_test(1, 1, 8, 1);    // movsq, zero tail
        i += run_test(0, 1, 8, 0);    // quad word loop
        i += run_test(1, 1, 8, 0);    // movsq

        i += run_test(0, 0, 1, 1);    // byte loop, zero tail
        i += run_test(1, 0, 1, 1);    // movsb, zero tail
        i += run_test(0, 0, 1, 0);    // byte loop
        i += run_test(1, 0, 1, 0);    // movsb

        i += run_test(0, 1, 1, 1);    // byte loop, zero tail
        i += run_test(1, 1, 1, 1);    // movsb, zero tail
        i += run_test(0, 1, 1, 0);    // byte loop
        i += run_test(1, 1, 1, 0);    // movsb

        i += run_test(0, 1, 0, 1);    // sanity check
        i += run_test(1, 1, 0, 1);    // sanity check
        i += run_test(0, 1, 0, 0);    // sanity check
        i += run_test(1, 1, 0, 0);    // sanity check

        i += run_test(0, 0, 0, 1);    // sanity check
        i += run_test(1, 0, 0, 1);    // sanity check
        i += run_test(0, 0, 0, 0);    // sanity check
        i += run_test(1, 0, 0, 0);    // sanity check

        if (i) {
                printf("copy_user is buggy\n");
        } else {
                printf("copy user is sane\n");
        }
        printf("end\n");
        exit();
}

--=-=-=
Content-Disposition: inline; filename=Makefile

SYMVERS=/boot/System.map-`uname -r`
GENERIC=$(firstword $(shell grep copy_user_generic $(SYMVERS)))
UNROLLED=$(firstword $(shell grep copy_user_generic_unrolled $(SYMVERS)))
STRING=$(firstword $(shell grep copy_user_generic_string $(SYMVERS)))
C=$(firstword $(shell grep copy_user_generic_c $(SYMVERS)))

ifeq ($(UNROLLED),)
	UNROLLED=$(GENERIC)# This is RHEL-4
endif

ifeq ($(STRING),)
	STRING=$(C)# This is RHEL-4
endif

all: prep test

prep:
	cat copy.gen | sed s#_UNROLLED_#0x$(UNROLLED)# | sed s#_STRING_#0x$(STRING)# > copy.stp

test:
	stap -vg copy.stp

--=-=-=


-- 
wbr, Vitaly

--=-=-=--
