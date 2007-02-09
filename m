Return-Path: <linux-kernel-owner+w=401wt.eu-S1945995AbXBIBiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945995AbXBIBiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945999AbXBIBiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:38:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:44124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945995AbXBIBiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:38:19 -0500
From: Neil Brown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 9 Feb 2007 12:37:34 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17867.53342.333989.501336@notabene.brown>
Cc: Andi Kleen <ak@muc.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Use correct macros in raid code, not raw asm
In-Reply-To: message from H. Peter Anvin on Thursday February 8
References: <1167348861.30506.46.camel@localhost.localdomain>
	<20061228155659.462eaa9c.akpm@osdl.org>
	<1167350803.30506.49.camel@localhost.localdomain>
	<20061229111355.GA82929@muc.de>
	<45CBCC72.6080409@zytor.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday February 8, hpa@zytor.com wrote:
> Andi Kleen wrote:
> > 
> > It should use kernel_fpu_begin() imho. If someone wants to test
> > it in user space again they can add dummy definitions of that
> > to their user space  header.
> 
> I hadn't seen this thread until now, when Neil pointed me to the thread.
> 
> Using kernel_fpu_begin() ... kernel_fpu_end() is probably indeed the 
> best option.
> 

So does this look right (no, I haven't compiled it yet)

NeilBrown


### Diffstat output
 ./drivers/md/raid6x86.h |   56 ++++++++++--------------------------------------
 1 file changed, 12 insertions(+), 44 deletions(-)

diff .prev/drivers/md/raid6x86.h ./drivers/md/raid6x86.h
--- .prev/drivers/md/raid6x86.h	2007-02-09 12:30:32.000000000 +1100
+++ ./drivers/md/raid6x86.h	2007-02-09 12:36:01.000000000 +1100
@@ -25,20 +25,17 @@
 
 typedef struct {
 	unsigned int fsave[27];
-	unsigned long cr0;
 } raid6_mmx_save_t __attribute__((aligned(16)));
 
 /* N.B.: For SSE we only save %xmm0-%xmm7 even for x86-64, since
    the code doesn't know about the additional x86-64 registers */
 typedef struct {
 	unsigned int sarea[8*4+2];
-	unsigned long cr0;
 } raid6_sse_save_t __attribute__((aligned(16)));
 
 /* This is for x86-64-specific code which uses all 16 XMM registers */
 typedef struct {
 	unsigned int sarea[16*4+2];
-	unsigned long cr0;
 } raid6_sse16_save_t __attribute__((aligned(16)));
 
 /* On x86-64 the stack *SHOULD* be 16-byte aligned, but currently this
@@ -50,7 +47,6 @@ typedef struct {
 
 typedef struct {
 	unsigned int fsave[27];
-	unsigned long cr0;
 } raid6_mmx_save_t;
 
 /* On i386, the stack is only 8-byte aligned, but SSE requires 16-byte
@@ -58,7 +54,6 @@ typedef struct {
    a properly-sized area correctly.  */
 typedef struct {
 	unsigned int sarea[8*4+3];
-	unsigned long cr0;
 } raid6_sse_save_t;
 
 /* Find the 16-byte aligned save area */
@@ -66,56 +61,29 @@ typedef struct {
 
 #endif
 
-#ifdef __KERNEL__ /* Real code */
-
-/* Note: %cr0 is 32 bits on i386 and 64 bits on x86-64 */
-
-static inline unsigned long raid6_get_fpu(void)
-{
-	unsigned long cr0;
-
-	preempt_disable();
-	asm volatile("mov %%cr0,%0 ; clts" : "=r" (cr0));
-	return cr0;
-}
-
-static inline void raid6_put_fpu(unsigned long cr0)
-{
-	asm volatile("mov %0,%%cr0" : : "r" (cr0));
-	preempt_enable();
-}
-
-#else /* Dummy code for user space testing */
-
-static inline unsigned long raid6_get_fpu(void)
-{
-	return 0xf00ba6;
-}
-
-static inline void raid6_put_fpu(unsigned long cr0)
-{
-	(void)cr0;
-}
-
+#ifndef __KERNEL__
+/* for user-space testing */
+#define kernel_fpu_begin()
+#define kernel_fpu_end();
 #endif
 
 static inline void raid6_before_mmx(raid6_mmx_save_t *s)
 {
-	s->cr0 = raid6_get_fpu();
+	kernel_fpu_begin();
 	asm volatile("fsave %0 ; fwait" : "=m" (s->fsave[0]));
 }
 
 static inline void raid6_after_mmx(raid6_mmx_save_t *s)
 {
 	asm volatile("frstor %0" : : "m" (s->fsave[0]));
-	raid6_put_fpu(s->cr0);
+	kernel_fpu_end();
 }
 
 static inline void raid6_before_sse(raid6_sse_save_t *s)
 {
 	unsigned int *rsa = SAREA(s);
 
-	s->cr0 = raid6_get_fpu();
+	kernel_fpu_begin();
 
 	asm volatile("movaps %%xmm0,%0" : "=m" (rsa[0]));
 	asm volatile("movaps %%xmm1,%0" : "=m" (rsa[4]));
@@ -140,14 +108,14 @@ static inline void raid6_after_sse(raid6
 	asm volatile("movaps %0,%%xmm6" : : "m" (rsa[24]));
 	asm volatile("movaps %0,%%xmm7" : : "m" (rsa[28]));
 
-	raid6_put_fpu(s->cr0);
+	kernel_fpu_end();
 }
 
 static inline void raid6_before_sse2(raid6_sse_save_t *s)
 {
 	unsigned int *rsa = SAREA(s);
 
-	s->cr0 = raid6_get_fpu();
+	kernel_fpu_begin();
 
 	asm volatile("movdqa %%xmm0,%0" : "=m" (rsa[0]));
 	asm volatile("movdqa %%xmm1,%0" : "=m" (rsa[4]));
@@ -172,7 +140,7 @@ static inline void raid6_after_sse2(raid
 	asm volatile("movdqa %0,%%xmm6" : : "m" (rsa[24]));
 	asm volatile("movdqa %0,%%xmm7" : : "m" (rsa[28]));
 
-	raid6_put_fpu(s->cr0);
+	kernel_fpu_end();
 }
 
 #ifdef __x86_64__
@@ -181,7 +149,7 @@ static inline void raid6_before_sse16(ra
 {
 	unsigned int *rsa = SAREA(s);
 
-	s->cr0 = raid6_get_fpu();
+	kernel_fpu_begin();
 
 	asm volatile("movdqa %%xmm0,%0" : "=m" (rsa[0]));
 	asm volatile("movdqa %%xmm1,%0" : "=m" (rsa[4]));
@@ -222,7 +190,7 @@ static inline void raid6_after_sse16(rai
 	asm volatile("movdqa %0,%%xmm14" : : "m" (rsa[56]));
 	asm volatile("movdqa %0,%%xmm15" : : "m" (rsa[60]));
 
-	raid6_put_fpu(s->cr0);
+	kernel_fpu_end();
 }
 
 #endif /* __x86_64__ */
