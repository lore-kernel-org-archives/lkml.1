Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXHaHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXHaHws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXHaHwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:52:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602AbXHaHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:52:30 -0400
Date: Fri, 31 Aug 2007 00:51:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Fix out-by-one error in traps.c
In-Reply-To: <1188540238.6004.28.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0708310044450.25853@woody.linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> 
 <20070822202551.GB31846@slug>  <20070823145038.9895784f.akpm@linux-foundation.org>
  <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org> 
 <20070824082249.GG31846@slug>  <1188043649.20041.81.camel@localhost.localdomain>
  <20070825122324.GA6138@slug> <20070825211405.GA18217@slug> 
 <1188230999.5531.15.camel@localhost.localdomain>  <20070830163812.GA22190@slug>
  <1188512066.6353.5.camel@localhost.localdomain> 
 <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org>
 <1188540238.6004.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Rusty Russell wrote:

> On Thu, 2007-08-30 at 21:44 -0700, Linus Torvalds wrote:
> > 
> > Hmm.. This *really* cannot happen with a normal kernel - it implies that 
> > the stack has crossed into an invalid page. 
> 
> AFAICT, a corrupt stack could lead us to touch a page which isn't
> mapped.  If we assume the stack isn't corrupt, we don't have to do the
> valid_stack_ptr() check at all...

Fair enough. That said, you seem to see this even without a corrupt stack.

> > Why is that allowed with lguest? What kind of code could validly *ever* 
> > come in here and cause problems?
> 
> head.S pushes a "$0" on the stack to stop the unwinder, lguest doesn't.

The unwinder should stop when it sees an invalid frame pointer, and even 
without the push 0 I'd have expected it to be invalid.

But I suspect lguest triggers another thing: you actually make the stack 
start at the *very*top* of the stack area. Afaik, normal x86 does not. A 
normal x86 kernel will start off with a pt_regs[] setup, I think - ie the 
kernel stack is always set up so that it has the "return to user mode" 
information.

And *that* difference may be what triggers this for lguest, even though it 
can never trigger for a "real" kernel.

But your patch does improve the sanity checking of the frame pointer. That 
said, I think the following patch improves it more: does this also work 
for you? (Totally untested, but it looks like the RightThing(tm) to do)

		Linus

---
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index cfffe3d..b9998f3 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -100,10 +100,10 @@ asmlinkage void machine_check(void);
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
 
-static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
+static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned size)
 {
 	return	p > (void *)tinfo &&
-		p < (void *)tinfo + THREAD_SIZE - 3;
+		p <= (void *)tinfo + THREAD_SIZE - size;
 }
 
 static inline unsigned long print_context_stack(struct thread_info *tinfo,
@@ -113,7 +113,7 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 	unsigned long addr;
 
 #ifdef	CONFIG_FRAME_POINTER
-	while (valid_stack_ptr(tinfo, (void *)ebp)) {
+	while (valid_stack_ptr(tinfo, (void *)ebp, 2*sizeof(unsigned long))) {
 		unsigned long new_ebp;
 		addr = *(unsigned long *)(ebp + 4);
 		ops->address(data, addr);
@@ -129,7 +129,7 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 		ebp = new_ebp;
 	}
 #else
-	while (valid_stack_ptr(tinfo, stack)) {
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		addr = *stack++;
 		if (__kernel_text_address(addr))
 			ops->address(data, addr);
