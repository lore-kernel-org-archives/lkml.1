Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbYAJQiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbYAJQiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYAJQhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:37:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378AbYAJQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:37:54 -0500
Date: Thu, 10 Jan 2008 08:36:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
 traditional
In-Reply-To: <20080109220508.686bbda4@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jan 2008, Arjan van de Ven wrote:
>
> +	if (valid_stack_ptr(tinfo, frame, sizeof(*frame)))
> +		while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {

Why?

Why not just make this something like the appended instead?

This is *totally* untested, but the basic notion is very simple: start off 
using the frame pointer until it is no longer valid (for any reason - 
whether the return address is corrupt, or the next frame info is bad), and 
update the stack pointer a you go.

When we've run out of frame pointers, we then scan any remaining stack the 
oldfashioned way, regardless of what happened. No unnecessary conditionals 
that will just mean that we don't show enough of the stack if *part* of it 
is corrupt.

The code is simpler and more robust (assuming it works - as mentioned, I 
didn't actually test it, so there may be some stupid thinko there).

		Linus

---
 arch/x86/kernel/traps_32.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index c88bbff..36714d7 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -107,6 +107,11 @@ static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned s
 		p <= (void *)tinfo + THREAD_SIZE - size;
 }
 
+static inline int valid_frame_ptr(struct thread_info *tinfo, void *stack, void *p, unsigned size)
+{
+	return p >= stack && valid_stack_ptr(tinfo, p, size);
+}
+
 /* The form of the top of the frame on the stack */
 struct stack_frame {
 	struct stack_frame *next_frame;
@@ -119,24 +124,23 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 {
 #ifdef	CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)ebp;
-	while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
-		struct stack_frame *next;
+	while (valid_frame_ptr(tinfo, stack, frame, sizeof(*frame))) {
 		unsigned long addr;
 
 		addr = frame->return_address;
+		if (!__kernel_text_address(addr))
+			break;
 		ops->address(data, addr);
+
 		/*
-		 * break out of recursive entries (such as
-		 * end_of_stack_stop_unwind_function). Also,
-		 * we can never allow a frame pointer to
-		 * move downwards!
+		 * Update the stack pointer to past the return
+		 * address we just printed out, and try the next
+		 * frame..
 		 */
-		next = frame->next_frame;
-		if (next <= frame)
-			break;
-		frame = next;
+		stack = 1+&frame->return_address;
+		frame = frame->next_frame;
 	}
-#else
+#endif
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		unsigned long addr;
 
@@ -144,7 +148,6 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 		if (__kernel_text_address(addr))
 			ops->address(data, addr);
 	}
-#endif
 	return ebp;
 }
 
