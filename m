Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYAJGFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYAJGFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYAJGFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:05:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41471 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYAJGFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:05:32 -0500
Date: Wed, 9 Jan 2008 22:05:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Make the 32 bit Frame Pointer backtracer fall back to traditional
Message-ID: <20080109220508.686bbda4@laptopd505.fenrus.org>
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


Subject: Make the 32 bit Frame Pointer backtracer fall back to traditional
From: Arjan van de Ven <arjan@linux.intel.com>

The 32 bit Frame Pointer backtracer code checks if the EBP is valid
to do a backtrace; however currently on a failure it just gives up
and prints nothing. That's not very nice; we can do better and still
print a decent backtrace. 

This patch changes the backtracer to fall back to the non-framepointer
backtracer if the EBP value isn't within the expected range; so on weird
stack corruption cases we get at least something out...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/traps_32.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
@@ -119,26 +119,28 @@ static inline unsigned long print_contex
 {
 #ifdef	CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)ebp;
-	while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
-		struct stack_frame *next;
-		unsigned long addr;
-
-		addr = frame->return_address;
-		if (__kernel_text_address(addr))
-			ops->address(data, addr);
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
+	if (valid_stack_ptr(tinfo, frame, sizeof(*frame)))
+		while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
+			struct stack_frame *next;
+			unsigned long addr;
+
+			addr = frame->return_address;
+			if (__kernel_text_address(addr))
+				ops->address(data, addr);
+			/*
+			 * break out of recursive entries (such as
+			 * end_of_stack_stop_unwind_function). Also,
+			 * we can never allow a frame pointer to
+			 * move downwards!
+			 */
+			next = frame->next_frame;
+			ebp = (unsigned long) next;
+			if (next <= frame)
+				break;
+			frame = next;
+		}
+	else
+#endif
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		unsigned long addr;
 
@@ -146,7 +148,6 @@ static inline unsigned long print_contex
 		if (__kernel_text_address(addr))
 			ops->address(data, addr);
 	}
-#endif
 	return ebp;
 }
 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
