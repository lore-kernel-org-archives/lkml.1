Return-Path: <linux-kernel-owner+w=401wt.eu-S965176AbXCAPOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbXCAPOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965181AbXCAPOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:14:14 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55673 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965176AbXCAPOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:14:12 -0500
Date: Thu, 1 Mar 2007 16:13:41 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <compudj@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-ID: <20070301161341.1dd3ade7@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070301111447.37ae08f5@dhcp-252-105.norway.atmel.com>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
	<20070301103451.2618cc35@dhcp-252-105.norway.atmel.com>
	<20070301014523.e45c3cc5.akpm@linux-foundation.org>
	<20070301111447.37ae08f5@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 11:14:47 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> On Thu, 1 Mar 2007 01:45:23 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > If there's a lesson here, it is "don't provide #defines in the header for
> > both versions".
> 
> Yes, that's true. It looks like all the other arches do the same thing
> with the _TIF flags, however, so just ripping it out probably won't
> work. Maybe I'll give it a try just to see how much trouble it is.

Actually, it wasn't much trouble at all since the _TIF definitions were
only used by arch code (at least in the configurations I tested, and I
couldn't find any users by grepping.) The below patch rips them out and
fixes up the few users that depend on them.

This is just an RFC, btw. The ptrace fix needs to go in earlier than the
rest, so I have to split this differently.

Is this something other arches should consider doing as well?

> > > I don't think either of those need to be atomic though, since both of
> > > them happen in monitor mode with interrupts disabled.
> > 
> > That's true until you implement SMP ;)
> 
> True. I'm not sure what it can race against though...perhaps something
> in kernel/signal.c?

Nevermind, I didn't pay attention to the rest of the thread.

Haavard

===============[cut here]==============
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [AVR32] Eliminate the _TIF definitions in asm/thread_info.h

Having definitions for both bit offsets and bitmasks that only differ
by a single underscore may introduce nasty bugs that are very hard
to spot. This patch removes the thread flag bitmask definitions from
asm-avr32/thread_info.h and converts the few cases that depends on
them to use an explicit shift instead.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/kernel/entry-avr32b.S |    6 +++---
 arch/avr32/kernel/ptrace.c       |    4 ++--
 arch/avr32/kernel/signal.c       |    2 +-
 include/asm-avr32/thread_info.h  |   10 ----------
 4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index eeb6679..fc1c435 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -250,7 +250,7 @@ syscall_exit_work:
 	ld.w	r1, r0[TI_flags]
 	rjmp	1b
 
-2:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK
+2:	mov	r2, (1 << TIF_SIGPENDING) | (1 << TIF_RESTORE_SIGMASK)
 	tst	r1, r2
 	breq	3f
 	unmask_interrupts
@@ -479,7 +479,7 @@ fault_exit_work:
 	ld.w	r1, r0[TI_flags]
 	rjmp	fault_exit_work
 
-1:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK
+1:	mov	r2, (1 << TIF_SIGPENDING) | (1 << TIF_RESTORE_SIGMASK)
 	tst	r1, r2
 	breq	2f
 	unmask_interrupts
@@ -588,7 +588,7 @@ debug_resume_user:
 	ld.w	r1, r0[TI_flags]
 	rjmp	1b
 
-2:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK
+2:	mov	r2, (1 << TIF_SIGPENDING) | (1 << TIF_RESTORE_SIGMASK)
 	tst	r1, r2
 	breq	3f
 	unmask_interrupts
diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index ce6734d..6f4388f 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -313,7 +313,7 @@ asmlinkage void do_debug_priv(struct pt_regs *regs)
 		__mtdr(DBGREG_DC, dc);
 
 		ti = current_thread_info();
-		ti->flags |= _TIF_BREAKPOINT;
+		set_ti_thread_flag(ti, TIF_BREAKPOINT);
 
 		/* The TLB miss handlers don't check thread flags */
 		if ((regs->pc >= (unsigned long)&itlb_miss)
@@ -328,7 +328,7 @@ asmlinkage void do_debug_priv(struct pt_regs *regs)
 		 * single step.
 		 */
 		if ((regs->sr & MODE_MASK) != MODE_SUPERVISOR)
-			ti->flags |= TIF_SINGLE_STEP;
+			set_ti_thread_flag(ti, TIF_SINGLE_STEP);
 	} else {
 		panic("Unable to handle debug trap at pc = %08lx\n",
 		      regs->pc);
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 0ec1485..cf52d47 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -323,6 +323,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
 	if ((sysreg_read(SR) & MODE_MASK) == MODE_SUPERVISOR)
 		syscall = 1;
 
-	if (ti->flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+	if (ti->flags & ((1 << TIF_SIGPENDING) | (1 << TIF_RESTORE_SIGMASK)))
 		do_signal(regs, &current->blocked, syscall);
 }
diff --git a/include/asm-avr32/thread_info.h b/include/asm-avr32/thread_info.h
index d1f5b35..a037dde 100644
--- a/include/asm-avr32/thread_info.h
+++ b/include/asm-avr32/thread_info.h
@@ -85,16 +85,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
-#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
-#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_BREAKPOINT		(1 << TIF_BREAKPOINT)
-#define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
-#define _TIF_MEMDIE		(1 << TIF_MEMDIE)
-#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-
 /* XXX: These two masks must never span more than 16 bits! */
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		0x0000013e
-- 
1.4.4.4

