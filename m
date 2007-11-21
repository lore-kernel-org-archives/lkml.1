Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbXKUKWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbXKUKWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXKUKWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:22:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXKUKWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:22:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
In-Reply-To: Roland McGrath's message of  Wednesday, 21 November 2007 02:19:28 -0800 <20071121101928.A08CF26F8BE@magilla.localdomain>
Subject: [PATCH 3/5] x86: ptrace fs/gs_base
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
X-Shopping-List: (1) Coughing rotators
   (2) Pungent reluctant ashes
   (3) Welding turkey climates
Message-Id: <20071121102159.1D82C26F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 02:21:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The fs_base and gs_base fields are available in user_regs_struct.
But reading these via ptrace (PTRACE_GETREGS or PTRACE_PEEKUSR) does
not give a reliably useful value.  The thread_struct fields are 0
when do_arch_prctl decided to use a GDT slot instead of MSR_FS_BASE,
which it does for a value under 1<<32.

This changes ptrace access to fs_base and gs_base to work like
PTRACE_ARCH_PRCTL does.  That is, it reads the base address that
user-mode memory access using the fs/gs instruction prefixes will
use, regardless of how it's being implemented in the kernel.  The
MSR vs GDT is an implementation detail that is pretty much hidden
from userland in the actual using, and there is no reason that
ptrace should give the internal implementation picture rather than
the user-mode semantic picture.  In the case of setting the value,
this can implicitly change the fsindex/gsindex value (also
separately in user_regs_struct), which is what happens when the
thread calls arch_prctl itself.  In a PTRACE_SETREGS, the fs_base
change will come after the fsindex change due to the order of the
struct, and so a change the debugger made to fs_base will have the
effect intended, another part of the user_regs_struct will now
differ when read back from what the debugger wrote.

This makes PTRACE_ARCH_PRCTL obsolete.  We could consider declaring
it deprecated and removing it one day, though there is no hurry.
For the foreseeable future, debuggers have to assume an old kernel
that does not report reliable fs_base/gs_base values in user_regs_struct
and stick to PTRACE_ARCH_PRCTL anyway.

Signed-off-by: Roland McGrath <roland@redhat.com>

diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 607085f..3ff7ddc 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -22,6 +22,7 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/processor.h>
+#include <asm/prctl.h>
 #include <asm/i387.h>
 #include <asm/debugreg.h>
 #include <asm/ldt.h>
@@ -260,12 +261,22 @@ static int putreg(struct task_struct *child,
 		case offsetof(struct user_regs_struct,fs_base):
 			if (value >= TASK_SIZE_OF(child))
 				return -EIO;
-			child->thread.fs = value;
+			/*
+			 * When changing the segment base, use do_arch_prctl
+			 * to set either thread.fs or thread.fsindex and the
+			 * corresponding GDT slot.
+			 */
+			if (child->thread.fs != value)
+				return do_arch_prctl(child, ARCH_SET_FS, value);
 			return 0;
 		case offsetof(struct user_regs_struct,gs_base):
+			/*
+			 * Exactly the same here as the %fs handling above.
+			 */
 			if (value >= TASK_SIZE_OF(child))
 				return -EIO;
-			child->thread.gs = value;
+			if (child->thread.gs != value)
+				return do_arch_prctl(child, ARCH_SET_GS, value);
 			return 0;
 		case offsetof(struct user_regs_struct, eflags):
 			value &= FLAG_MASK;
@@ -296,9 +307,25 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 		case offsetof(struct user_regs_struct, es):
 			return child->thread.es; 
 		case offsetof(struct user_regs_struct, fs_base):
-			return child->thread.fs;
+			/*
+			 * do_arch_prctl may have used a GDT slot instead of
+			 * the MSR.  To userland, it appears the same either
+			 * way, except the %fs segment selector might not be 0.
+			 */
+			if (child->thread.fs != 0)
+				return child->thread.fs;
+			if (child->thread.fsindex != FS_TLS_SEL)
+				return 0;
+			return get_desc_base(&child->thread.tls_array[FS_TLS]);
 		case offsetof(struct user_regs_struct, gs_base):
-			return child->thread.gs;
+			/*
+			 * Exactly the same here as the %fs handling above.
+			 */
+			if (child->thread.gs != 0)
+				return child->thread.gs;
+			if (child->thread.gsindex != GS_TLS_SEL)
+				return 0;
+			return get_desc_base(&child->thread.tls_array[GS_TLS]);
 		default:
 			regno = regno - sizeof(struct pt_regs);
 			val = get_stack_long(child, regno);
