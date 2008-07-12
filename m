Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYGLMZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYGLMZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYGLMZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:25:27 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:62119 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYGLMZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:25:26 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
From: Andi Kleen <andi@firstfloor.org>
References: <20080710215039.2A143154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org>
	<20080710224256.AD038154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
	<20080711005243.ADE90154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101824150.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807101855020.2936@woody.linux-foundation.org>
Date: Sat, 12 Jul 2008 14:24:59 +0200
In-Reply-To: <alpine.LFD.1.10.0807101855020.2936@woody.linux-foundation.org> (Linus Torvalds's message of "Thu, 10 Jul 2008 19:02:25 -0700 (PDT)")
Message-ID: <87r69z2stg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jul 2008 12:17:33.0705 (UTC) FILETIME=[4373FF90:01C8E419]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> That said, seeing the full history of this same thing on the x86-32 side 
> actually makes me _much_ happier about the patch. Because now I can tell 
> when we did it, and what problems it seems to have caused (answer: 
> "apparently none that are possibly relevant on x86-64").

FWIW I agree with Roland that the 64bit behaviour has a race window
that can lead to delayed signals. I had actually fixed this some
months ago myself in my tree because this was noticed by David (who
was comparing to sparc I thin) during code review, but never pushed it
out because it didn't get enough testing (it only ran on my
workstation for some time)

I think his patch is actually doing way too much work though, especially
it is not needed to repeat all checks for the full work mask. I'm
appending the patch I was using, which only rechecks signals.

Obviously it's still not something that should be used without a lot 
of testing.

But in theory it's ok.

> So now I'm considering just putting it in before the 2.6.26 release after 
> all ;)

That would seem rather hazardous.

-Andi

---

Fix lost signal race on x86-64

Originally noticed by Dave Miller during code review

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/entry_64.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S
+++ linux/arch/x86/kernel/entry_64.S
@@ -305,7 +305,7 @@ sysret_signal:
 	leaq -ARGOFFSET(%rsp),%rdi # &pt_regs -> arg1
 	xorl %esi,%esi # oldset -> arg2
 	call ptregscall_common
-1:	movl $_TIF_NEED_RESCHED,%edi
+1:	movl $_TIF_NEED_RESCHED|_TIF_SIGPENDING,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -393,7 +393,7 @@ int_signal:
 	movq %rsp,%rdi		# &ptregs -> arg1
 	xorl %esi,%esi		# oldset -> arg2
 	call do_notify_resume
-1:	movl $_TIF_NEED_RESCHED,%edi	
+1:	movl $_TIF_NEED_RESCHED|_TIF_SIGPENDING,%edi
 int_restore_rest:
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -647,7 +647,7 @@ retint_signal:
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl $_TIF_NEED_RESCHED,%edi
+	movl $_TIF_NEED_RESCHED|_TIF_SIGPENDING,%edi
 	GET_THREAD_INFO(%rcx)
 	jmp retint_check
 
