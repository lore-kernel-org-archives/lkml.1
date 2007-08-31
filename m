Return-Path: <linux-kernel-owner+w=401wt.eu-S966076AbXHaS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966076AbXHaS1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXHaS1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:27:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932908AbXHaS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:27:41 -0400
Date: Fri, 31 Aug 2007 11:24:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Fix out-by-one error in traps.c
In-Reply-To: <1188581852.10802.13.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0708311120030.25853@woody.linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> 
 <20070822202551.GB31846@slug>  <20070823145038.9895784f.akpm@linux-foundation.org>
  <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org> 
 <20070824082249.GG31846@slug>  <1188043649.20041.81.camel@localhost.localdomain>
  <20070825122324.GA6138@slug> <20070825211405.GA18217@slug> 
 <1188230999.5531.15.camel@localhost.localdomain>  <20070830163812.GA22190@slug>
  <1188512066.6353.5.camel@localhost.localdomain> 
 <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org> 
 <1188540238.6004.28.camel@localhost.localdomain> 
 <alpine.LFD.0.999.0708310044450.25853@woody.linux-foundation.org>
 <1188581852.10802.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Sep 2007, Rusty Russell wrote:
> 
> This is only for the initial booting stack (init_thread_union); see
> arch/i386/kernel/head.S:
> 	/* Set up the stack pointer */
> 	lss stack_start,%esp
> 	...
> 	pushl $0		# fake return address for unwinder

Ok, we should fix that. We should just make it look like all other stack 
frames.

There is other code in the kernel that "knows" that all kernel stacks have 
the fields for the user stack return on it, namely the ptrace code etc. 
Now, the initial stack is hopefully never *accessed* by that kind of code, 
but this kind of special-case code is just wrong.

> > But your patch does improve the sanity checking of the frame pointer. That 
> > said, I think the following patch improves it more: does this also work 
> > for you? (Totally untested, but it looks like the RightThing(tm) to do)
> 
> Yes, looks good.  Perhaps one additional magic num removal:

Well, we might as well then just make the code readable instead. IOW, how 
about this one, which just declares a structure that describes the stack 
frame thing? That just makes everything clearer, since we can then use 
"sizeof(that structure)" instead of using the magic "2*sizeof(unsigned 
long)".

		Linus

---
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index cfffe3d..47b0bef 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -100,36 +100,45 @@ asmlinkage void machine_check(void);
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
 
-static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
+static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned size)
 {
 	return	p > (void *)tinfo &&
-		p < (void *)tinfo + THREAD_SIZE - 3;
+		p <= (void *)tinfo + THREAD_SIZE - size;
 }
 
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
 static inline unsigned long print_context_stack(struct thread_info *tinfo,
 				unsigned long *stack, unsigned long ebp,
 				struct stacktrace_ops *ops, void *data)
 {
-	unsigned long addr;
-
 #ifdef	CONFIG_FRAME_POINTER
-	while (valid_stack_ptr(tinfo, (void *)ebp)) {
-		unsigned long new_ebp;
-		addr = *(unsigned long *)(ebp + 4);
+	struct stack_frame *frame = (struct stack_frame *)ebp;
+	while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
+		struct stack_frame *next;
+		unsigned long addr;
+
+		addr = frame->return_address;
 		ops->address(data, addr);
 		/*
 		 * break out of recursive entries (such as
 		 * end_of_stack_stop_unwind_function). Also,
 		 * we can never allow a frame pointer to
 		 * move downwards!
-	 	 */
-	 	new_ebp = *(unsigned long *)ebp;
-		if (new_ebp <= ebp)
+		 */
+		next = frame->next_frame;
+		if (next <= frame)
 			break;
-		ebp = new_ebp;
+		frame = next;
 	}
 #else
-	while (valid_stack_ptr(tinfo, stack)) {
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
+		unsigned long addr;
+
 		addr = *stack++;
 		if (__kernel_text_address(addr))
 			ops->address(data, addr);
