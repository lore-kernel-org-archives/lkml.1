Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYAKEfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYAKEfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYAKEfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:35:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43468 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbYAKEfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:35:31 -0500
Date: Thu, 10 Jan 2008 20:35:19 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
 traditional
Message-ID: <20080110203519.573567b7@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
	<alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 08:36:57 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 9 Jan 2008, Arjan van de Ven wrote:
> >
> > +	if (valid_stack_ptr(tinfo, frame, sizeof(*frame)))
> > +		while (valid_stack_ptr(tinfo, frame,
> > sizeof(*frame))) {
> 
> Why?
> 
> Why not just make this something like the appended instead?


ok having poked at this a ton more (and thought about it during a bori^long meeting),
your approach is really hard to make work nicely with things like irq stacks.
HOWEVER, we can do even better! (well in my tired opinion anyway)

What I like most so far is the following idea: We walk the stack using BOTH methods,
and just mark the entries we find as either "reliable as per stack frames" or as "unreliable".
This way we walk the entire stack, get all the data no matter how corrupt EBP or the frames end up,
yet we do get an indication on which parts are probably noise for the case of a reliable stack
frame setup.

I coded it, it's not all that bad, the output looks like:

Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #17
 [<c0405d6c>] show_trace_log_lvl+0x1a/0x2f
 [<c04066d6>] show_trace+0x12/0x14  
 [<c0406f47>] dump_stack+0x6a/0x70
 [<e01f6028>] backtrace_test_timer+0x23/0x25 [backtracetest]
 [<c0426f07>] run_timer_softirq+0x11b/0x17c
 [<e01f6005>] .backtrace_test_timer+0x0/0x25 [backtracetest]
 [<c043b2e0>] .trace_hardirqs_on+0x101/0x13b
 [<e01f6005>] .backtrace_test_timer+0x0/0x25 [backtracetest]
 [<c04243ac>] __do_softirq+0x42/0x94
 [<c04070a0>] do_softirq+0x50/0xb6
 [<c0453f3c>] .handle_edge_irq+0x0/0xfa
 [<c04242a9>] irq_exit+0x37/0x67
 [<c04071a0>] do_IRQ+0x9a/0xaf
 [<c04057da>] common_interrupt+0x2e/0x34
 [<c041007b>] .write_watchdog_counter32+0x5/0x48
 [<c0523371>] .acpi_idle_enter_simple+0x167/0x1da
 [<c05807fe>] cpuidle_idle_call+0x52/0x78
 [<c04034f3>] cpu_idle+0x46/0x60
 [<c05fbbd3>] rest_init+0x43/0x45
 [<c070aa3d>] start_kernel+0x279/0x27f
 [<c070a327>] .unknown_bootoption+0x0/0x1a4
 =======================

where I used a "." to indicate potentially-unreliable (this I'm not very happy with, but I can print anything I want on either side of the function; ideas welcome).

The code is relatively simple as well, it looks more or less like this:

@@ -119,24 +119,31 @@ static inline unsigned long print_contex
 {
 #ifdef CONFIG_FRAME_POINTER
        struct stack_frame *frame = (struct stack_frame *)ebp;
+
+       /*
+        * if EBP is "deeper" into the stack than the actual stack pointer,
+        * we need to rewind the stack pointer a little to start at the
+        * first stack frame, but only if EBP is in this stack frame.  
+        */
+       if (stack > (unsigned long *) ebp)
+                       && valid_stack_ptr(tinfo, frame, sizeof(*frame)) {
+               stack = (unsigned long *) ebp;
+       }
+
+       while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
                unsigned long addr;
 
+               addr = *stack;
+               if (__kernel_text_address(addr)) {
+                       if ((unsigned long) stack == ebp + 4) {
+				/* we have a stack frame based hit */
+                               ops->address(data, addr, 1);   
+                               frame = frame->next_frame;     
+                               ebp = (unsigned long) frame;   
+                       } else {
+				/* 
+				 * it looks like a kernel function, but
+				 * it doesn't match a stack frame,
+				 * print it as unreliable
+				 */
+                               ops->address(data, addr, 0);
+                       }
+               }
+               stack++;
        }


I need to go clean up the patch and split it up into 2 pieces (one for the capability to print unreliable trace entries, and the second the chunk above to actually walk the stack). I'm also going to try to remove some of the casts
in the code.

What do you think of this approach instead of your proposal?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
