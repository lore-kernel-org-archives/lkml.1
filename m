Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbZJSFFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbZJSFFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZJSFFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:05:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:21846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZJSFFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:05:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,583,1249282800"; 
   d="scan'208";a="560930406"
From: linguranus@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Ling <linguranus@gmail.com>
Subject: [PATCH RFC] [X86] performance improvement for memcpy_64.S by avoid memory miss predication.
Date: Mon, 19 Oct 2009 13:08:44 +0800
Message-Id: <1255928924-19140-1-git-send-email-linguranus@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ling <linguranus@gmail.com>

Hi All

CPU will use memory disambiguration predication to speculatively read memory
without waiting for previous write instructions and correctly avoid conflict between
them (RAW). However it seem only to care about last 12 bits of address, not 
care about real address. For example if rsi is 0xf004, rdi is 0xe008, when we
do following operation there will generate big performance latency.
1. movq (%rsi),	%rax
2. movq %rax,	(%rdi)
3. movq 8(%rsi), %rax
4. movq %rax,	8(%rdi)

If %rsi and rdi were in really the same meory page, there will be read-after-write
conflict, which cause partial memory access latency. But we can see rsi(f004) is 
in different page with rdi(e008), cpu incorrectly disambiguration predicate,
so instruction 3 have to wait instruction 2 to write data into cache from write buffer,
then issue.
We may avoid it by tunning operation sequence as follow

1. movq 8(%rsi), %rax
2. movq %rax,	8(%rdi)
3. movq (%rsi),	%rax
4. movq %rax,	(%rdi)

At last we gain 1.83x speedup compared with original instruction sequence.

In this patch we use forward and backward copy to avoid this predication
miss for larger size(more 64 bytes), tested on Core2 and NHM, it got good
result when rdi offset is bigger than rsi, and smaller than rdi, specially 
when last 12bits of rdi sustracted by that of rsi is less 64, i.e.
0x008(rsi)and 0x010(rdi), rdi - rsi = 0x8(which is less 64).

In next step, we will try to improve less 64bytes performance.

Two comparison result set(on core2):

Dst addr   Src addr    Len     Speedup   
0x77008    0x88000      64,    2.01x     
0x77008    0x88000     128,    3.16x     
0x77008    0x88000     192,    3.67x     
0x77008    0x88000     256,    3.75x     
0x77008    0x88000     320,    4.10x     
0x77008    0x88000     384,    4.37x     
0x77008    0x88000     448,    4.58x     
0x77008    0x88000     512,    4.81x     
0x77008    0x88000    1024,    5.50x     
0x77008    0x88000    2048,    5.96x     
0x77008    0x88000    4096,    6.18x     
0x77008    0x88000    8192,    5.26x     
0x77008    0x88000    256k,    2.79x     
0x77008    0x88000    2048k    2.26x     
                                         
Dst addr   Src addr    Len     Speedup   
0xc3010    0xd4008      64,    2.0x      
0xc3010    0xd4008     128,    3.1x      
0xc3010    0xd4008     192,    3.6x      
0xc3010    0xd4008     256,    3.7x      
0xc3010    0xd4008     320,    4.1x      
0xc3010    0xd4008     384,    4.4x      
0xc3010    0xd4008     448,    4.7x      
0xc3010    0xd4008     512,    4.8x      
0xc3010    0xd4008    1024,    5.5x      
0xc3010    0xd4008    2048,    5.9x      
0xc3010    0xd4008    4096,    6.2x      
0xc3010    0xd4008    8192,    5.7x      
0xc3010    0xd4008    256k,    2.7x      
0xc3010    0xd4008    2048k    2.7x      

Appreciate your comments.

Thanks
Ling

---
 arch/x86/lib/memcpy_64.S |   98 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 82 insertions(+), 16 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index ad5441e..83e22de 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -49,10 +49,20 @@ ENTRY(memcpy)
 	movq %rdi, %rax
 	movl %edx, %ecx
 	shrl   $6, %ecx
-	jz .Lhandle_tail
+	jz .Lhandle_tail)
+
+	/*
+	 * Chose forward or back copy based on page offset.
+	 */
+	mov %esi, %r8d
+	mov %edi, %r9d
+	and $0xfff, %r8d
+	and $0xfff, %r9d
+	cmp %r8d, %r9d
+	jg .Lloop_64_bwd_start
 
 	.p2align 4
-.Lloop_64:
+.Lloop_64_fwd:
 	/*
 	 * We decrement the loop index here - and the zero-flag is
 	 * checked at the end of the loop (instructions inbetween do
@@ -61,33 +71,89 @@ ENTRY(memcpy)
 	decl %ecx
 
 	/*
-	 * Move in blocks of 4x16 bytes:
+	 * Forward move in blocks of 4x16 bytes:
 	 */
-	movq 0*8(%rsi),		%r11
+	movq 0*8(%rsi),		%r8
+	movq %r8,		0*8(%rdi)
 	movq 1*8(%rsi),		%r8
-	movq %r11,		0*8(%rdi)
 	movq %r8,		1*8(%rdi)
 
-	movq 2*8(%rsi),		%r9
-	movq 3*8(%rsi),		%r10
-	movq %r9,		2*8(%rdi)
-	movq %r10,		3*8(%rdi)
+	movq 2*8(%rsi),		%r8
+	movq %r8,		2*8(%rdi)
+	movq 3*8(%rsi),		%r8
+	movq %r8,		3*8(%rdi)
 
-	movq 4*8(%rsi),		%r11
+	movq 4*8(%rsi),		%r8
+	movq %r8,		4*8(%rdi)
 	movq 5*8(%rsi),		%r8
-	movq %r11,		4*8(%rdi)
 	movq %r8,		5*8(%rdi)
 
-	movq 6*8(%rsi),		%r9
-	movq 7*8(%rsi),		%r10
-	movq %r9,		6*8(%rdi)
-	movq %r10,		7*8(%rdi)
+	movq 6*8(%rsi),		%r8
+	movq %r8,		6*8(%rdi)
+	movq 7*8(%rsi),		%r8
+	movq %r8,		7*8(%rdi)
 
 	leaq 64(%rsi), %rsi
 	leaq 64(%rdi), %rdi
 
-	jnz  .Lloop_64
+	jnz  .Lloop_64_fwd
+
+	jmp  .handle_tail
+	.p2align 4
+.Lloop_64_bwd_start:
+	
+	/*
+	 * Get long backward copy size.
+	 */
+	movq %rdx, %r9
+	and $-64, %r9
+	/*
+	 * Calculate begining src and dst address for long backward copy.
+	 */
+	lea -64(%rsi, %r9), %rsi
+	lea -64(%rdi, %r9), %rdi
+	.p2align 4
+.Lloop_64_bwd:
+	/*
+	 * We decrement the loop index here - and the zero-flag is
+	 * checked at the end of the loop (instructions inbetween do
+	 * not change the zero flag:
+	 */
+	decl %ecx
 
+	/*
+	 * Backward move in blocks of 4x16 bytes 
+	 */
+	movq 7*8(%rsi),		%r8
+	movq %r8,		7*8(%rdi)
+	movq 6*8(%rsi),		%r8
+	movq %r8,		6*8(%rdi)
+
+	movq 5*8(%rsi),		%r8
+	movq %r8,		5*8(%rdi)
+	movq 4*8(%rsi),		%r8
+	movq %r8,		4*8(%rdi)
+
+	movq 3*8(%rsi),		%r8
+	movq %r8,		3*8(%rdi)
+	movq 2*8(%rsi),		%r8
+	movq %r8,		2*8(%rdi)
+
+	movq 1*8(%rsi),		%r8
+	movq %r8,		1*8(%rdi)
+	movq 0*8(%rsi),		%r8
+	movq %r8,		0*8(%rdi)
+
+	leaq -64(%rsi), %rsi
+	leaq -64(%rdi), %rdi
+
+	jnz  .Lloop_64_bwd
+
+	/*
+	 * Calculate new address after long size backward copy.
+	 */
+	lea 64(%rsi, %r9), %rsi
+	lea 64(%rdi, %r9), %rdi
 .Lhandle_tail:
 	movl %edx, %ecx
 	andl  $63, %ecx
-- 
1.6.2.5

