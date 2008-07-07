Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYGGG4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYGGG4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYGGG4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:56:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYGGG4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:56:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/4] x86_64: remove bogus optimization in sysret_signal
X-Zippy-Says: What I want to find out is -- do parrots know much about Astro-Turf?
Message-Id: <20080707065615.77BD9154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 23:56:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short-circuit path in sysret_signal looks wrong to me.
AFAICT, in practice the branch is never taken--and if it were,
it would go wrong.  To wit, try loading a module whose init
function does set_thread_flag(TIF_IRET), and see insmod crash
(presumably with a wrong user stack pointer).

This is because the FIXUP_TOP_OF_STACK work hasn't been done yet
when we jump around the call to ptregscall_common and get to
int_with_check--where it expects the user RSP,SS,CS and EFLAGS to
have been stored by FIXUP_TOP_OF_STACK.

I don't think it's normally possible to get to sysret_signal with no
_TIF_DO_NOTIFY_MASK bits set anyway, so these two instructions are
already superfluous.  If it ever did happen, it is harmless to call
do_notify_resume with nothing for it to do.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 556a8df..f9c859d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -296,16 +296,12 @@ sysret_careful:
 sysret_signal:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	testl $_TIF_DO_NOTIFY_MASK,%edx
-	jz    1f
-
-	/* Really a signal */
 	/* edx:	work flags (arg3) */
 	leaq do_notify_resume(%rip),%rax
 	leaq -ARGOFFSET(%rsp),%rdi # &pt_regs -> arg1
 	xorl %esi,%esi # oldset -> arg2
 	call ptregscall_common
-1:	movl $_TIF_NEED_RESCHED,%edi
+	movl $_TIF_NEED_RESCHED,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
 	DISABLE_INTERRUPTS(CLBR_NONE)
