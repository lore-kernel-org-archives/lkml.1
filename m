Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbYJDKOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbYJDKOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYJDKOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:14:34 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:3014 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYJDKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:14:33 -0400
Date: Sat, 4 Oct 2008 12:06:08 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH FIX] traps: x86: correct copy/paste bug: a trap is a GATE_TRAP
Message-ID: <20081004100608.GA7659@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223114224.25951.1277482279@webmail.messagingengine.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sat, 04 Oct 2008 12:08:02 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix copy/paste/forgot-to-edit bug in desc.h.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

> * Ingo Molnar <mingo@elte.hu> wrote:
> > * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > > Hi Ingo,
> > > 
> > > This series unifies traps_32.c and traps_64.c.
> > 
> > wow, very nice! I've applied them to tip/x86/traps:
> > 
> > f58f3d5: traps: x86: finalize unification of traps.c
> > bf395d6: traps: x86: make traps_32.c and traps_64.c equal
> > f156f35: traps: x86: various noop-changes preparing for unification of traps_xx.c
> > 70cfe30: traps: x86_64: use task_pid_nr(tsk) instead of tsk->pid in do_general_protection
> > dc89ce0: traps: i386: expand clear_mem_error and remove from mach_traps.h
> > 6f8063f: traps: x86_64: make io_check_error equal to the one on i386
> > d025445: traps: i386: use preempt_conditional_sti/cli in do_int3
> > 2180afa: traps: x86_64: make math_state_restore more like i386
> > 686cc4a: traps: x86: converge trap_init functions
> 
> -tip testing found a spontaneus reboot bug on two 32-bit systems (one 
> Intel and one AMD testbox), and i've bisected it down to:
> 
> | 686cc4a0c1ca92bffbc22a897c3b433dadbbf444 is first bad commit
> | commit 686cc4a0c1ca92bffbc22a897c3b433dadbbf444
> | Author: Alexander van Heukelum <heukelum@fastmail.fm>
> | Date:   Fri Oct 3 22:00:32 2008 +0200
> |
> |     traps: x86: converge trap_init functions
> 
> config attached. The bisection log:
> 
>  # bad:  [a229a9da] Merge branch 'timers/urgent'
>  # good: [27de5e39] Merge branch 'out-of-tree'
>  # good: [8e9cb9db] Merge branch 'tracing/ring-buffer'
>  # bad:  [70cfe30f] traps: x86_64: use task_pid_nr(tsk) instead of tsk
>  # bad:  [d0254456] traps: i386: use preempt_conditional_sti/cli in do
>  # bad:  [2180afaf] traps: x86_64: make math_state_restore more like i
>  # bad:  [686cc4a0] traps: x86: converge trap_init functions
> 
> so i've excluded these commits from tip/master for now.
> 
> there's no serial log entry visible - the spontaneous reboot happens at 
> around when we hit user-space.
> 
> I suspect syscall entry setup might be borked - the stack frames of call 
> gates versus interrupt gates are different and it's easy to make a small 
> mistake there with such effects.
> 
> 	Ingo

*blush*

You were so right. I have no idea how this has slipped
through testing. Could you see if this on top of the
traps branch makes things go again? I'll get you some
replacement patches to make the whole thing bisectable
again.

Alexander

---

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 168c5cc..f06adac 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -354,7 +354,7 @@ static inline void set_system_intr_gate(unsigned int n, void *addr)
 static inline void set_system_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
 }
 
 static inline void set_trap_gate(unsigned int n, void *addr)
