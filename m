Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZIWBcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZIWBcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZIWBcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:32:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834AbZIWBcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:32:51 -0400
Date: Tue, 22 Sep 2009 18:31:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: ptrace: sign-extend eax with orig_eax>=0
In-Reply-To: <20090923004651.2D99513F37@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Sep 2009, Roland McGrath wrote:
>
> The 32-bit ptrace syscall on a 64-bit kernel (32-bit debugger on
> 32-bit task) behaves differently than a native 32-bit kernel.  When
> setting a register state of orig_eax>=0 and eax=-ERESTART* when the
> debugged task is NOT on its way out of a 32-bit syscall, the task will
> fail to do the syscall restart logic that it should do.

Hmm. This really smells extremely hacky to me.

I see what you're doing, and I understand why, but it all makes me 
shudder. I think we already do the wrong thing for 'orig_ax', and that we 
should probably simply test just the low 32 bits of it (looks to be easily 
done by just making the return type of 'syscall_get_nr()' be 'int') rather 
than have that special "let's sign-extend orig_ax" code in ptrace.

I also get the feeling that the TS_COMPAT testing is just hacky to begin 
with. I think it was broken to do things that way, and I have this gut 
feel that we really should have hidden the "am I a 32-bit or 64-bit 
syscall" in that orig_ax field instead (ie make the 64-bit system calls 
set a bit or whatever). That's the field we've always used for system call 
flagging, and TS_COMPAT was broken.

In this example, the problem for ptrace seems to be that TS_COMPAT ends up 
being that "extra" bit of information that isn't visible in the register 
set.

But that's a bigger separate cleanup. In the meantime, I really get the 
feeling that your patch is nasty, and could be replaced with something 
like the following instead.. It just sets the TS_COMPAT bit if we use a 
32-bit interface to set the system call number to positive (ie "inside 
system call").

THE BELOW IS TOTALLY UNTESTED! I haven't really thought it through. I just 
reacted very negatively to your patch, and my gut feel is that the code is 
fundamentally doing something wrong. The below may not work, and may be 
seriously broken and miss the point, but I think it conceptually comes 
closer to how things _should_ work.

		Linus

---
 arch/x86/include/asm/syscall.h |    2 +-
 arch/x86/kernel/ptrace.c       |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d82f39b..f2a0631 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,7 +16,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-static inline long syscall_get_nr(struct task_struct *task,
+static inline int syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
 	/*
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8d7d5c9..90b67db 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1124,13 +1124,19 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 	R32(eip, ip);
 	R32(esp, sp);
 
-	case offsetof(struct user32, regs.orig_eax):
+	case offsetof(struct user32, regs.orig_eax): {
+		struct thread_info *thread = task_thread_info(child);
 		/*
 		 * Sign-extend the value so that orig_eax = -1
 		 * causes (long)orig_ax < 0 tests to fire correctly.
 		 */
 		regs->orig_ax = (long) (s32) value;
+		if ((s32) value >= 0)
+			thread->status |= TS_COMPAT;
+		else
+			thread->status &= ~TS_COMPAT;
 		break;
+	}
 
 	case offsetof(struct user32, regs.eflags):
 		return set_flags(child, value);
