Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYALFbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYALFbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYALFay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:30:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33893 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYALFay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:30:54 -0500
Date: Fri, 11 Jan 2008 21:30:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@tglx.de, hpa@zytor.com
Subject: [patch 3/8] x86: Improve the 32 bit Frame Pointer backtracer to
 also use the traditional backtrace
Message-ID: <20080111213044.3e1c222f@laptopd505.fenrus.org>
In-Reply-To: <20080111212623.518e1527@laptopd505.fenrus.org>
References: <20080111212623.518e1527@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: Improve the 32 bit Frame Pointer backtracer to also use the traditional backtrace
From: Arjan van de Ven <arjan@linux.intel.com>

The 32 bit Frame Pointer backtracer code checks if the EBP is valid
to do a backtrace; however currently on a failure it just gives up
and prints nothing. That's not very nice; we can do better and still
print a decent backtrace. 

This patch changes the backtracer to use the regular backtracing algorithm
at the same time as the EBP backtracer; the EBP backtracer is basically
used to figure out which part of the backtrace are reliable vs those
which are likely to be noise.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/traps_32.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
@@ -117,36 +117,32 @@ static inline unsigned long print_contex
 				unsigned long *stack, unsigned long ebp,
 				const struct stacktrace_ops *ops, void *data)
 {
-#ifdef	CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)ebp;
-	while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
-		struct stack_frame *next;
-		unsigned long addr;
 
-		addr = frame->return_address;
-		if (__kernel_text_address(addr))
-			ops->address(data, addr, 1);
-		/*
-		 * break out of recursive entries (such as
-		 * end_of_stack_stop_unwind_function). Also,
-		 * we can never allow a frame pointer to
-		 * move downwards!
-		 */
-		next = frame->next_frame;
-		ebp = (unsigned long) next;
-		if (next <= frame)
-			break;
-		frame = next;
-	}
-#else
+	/*
+	 * if EBP is "deeper" into the stack than the actual stack pointer,
+	 * we need to rewind the stack pointer a little to start at the
+	 * first stack frame, but only if EBP is in this stack frame.
+	 */
+	if (stack > (unsigned long *) ebp
+			&& valid_stack_ptr(tinfo, frame, sizeof(*frame)))
+		stack = (unsigned long *) ebp;
+
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		unsigned long addr;
 
-		addr = *stack++;
-		if (__kernel_text_address(addr))
-			ops->address(data, addr, 1);
+		addr = *stack;
+		if (__kernel_text_address(addr)) {
+			if ((unsigned long) stack == ebp + 4) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				ebp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, 0);
+			}
+		}
+		stack++;
 	}
-#endif
 	return ebp;
 }
 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
