Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZIWGWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZIWGWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZIWGWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZIWGWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:22:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] x86: ptrace: set TS_COMPAT when 32-bit ptrace sets orig_eax>=0
In-Reply-To: Roland McGrath's message of  Tuesday, 22 September 2009 23:18:34 -0700 <20090923061834.BE13A22@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
	<alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
	<20090923024049.AA85913F37@magilla.sf.frob.com>
	<20090923061834.BE13A22@magilla.sf.frob.com>
X-Shopping-List: (1) Perfidious tape
   (2) Spastic proteins
   (3) Nylon odorous balls
   (4) Hot squirrels
Message-Id: <20090923062115.D2F3114093@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 23:21:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit ptrace syscall on a 64-bit kernel (32-bit debugger on
32-bit task) behaves differently than a native 32-bit kernel.  When
setting a register state of orig_eax>=0 and eax=-ERESTART* when the
debugged task is NOT on its way out of a 32-bit syscall, the task will
fail to do the syscall restart logic that it should do.

Test case available at http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/erestartsys-trap.c?cvsroot=systemtap

This happens because the 32-bit ptrace syscall sets eax=0xffffffff
when it sets orig_eax>=0.  The resuming task will not sign-extend this
for the -ERESTART* check because TS_COMPAT is not set.  (So the task
thinks it is restarting after a 64-bit syscall, not a 32-bit one.)

The fix is to have 32-bit ptrace calls set TS_COMPAT when setting
orig_eax>=0.  This ensures that the 32-bit syscall restart logic
will apply when the child resumes.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 52222fa..7b058a2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1111,10 +1111,22 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 	R32(esi, si);
 	R32(ebp, bp);
 	R32(eax, ax);
-	R32(orig_eax, orig_ax);
 	R32(eip, ip);
 	R32(esp, sp);
 
+	case offsetof(struct user32, regs.orig_eax):
+		/*
+		 * A 32-bit debugger setting orig_eax means to restore
+		 * the state of the task restarting a 32-bit syscall.
+		 * Make sure we interpret the -ERESTART* codes correctly
+		 * in case the task is not actually still sitting at the
+		 * exit from a 32-bit syscall with TS_COMPAT still set.
+		 */
+		regs->orig_ax = value;
+		if (syscall_get_nr(child, regs) >= 0)
+			task_thread_info(child)->status |= TS_COMPAT;
+		break;
+
 	case offsetof(struct user32, regs.eflags):
 		return set_flags(child, value);
 
