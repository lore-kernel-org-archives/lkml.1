Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZIWGVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZIWGVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZIWGVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:21:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbZIWGVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:21:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] x86: ptrace: do not sign-extend orig_ax on write
In-Reply-To: Roland McGrath's message of  Tuesday, 22 September 2009 23:18:34 -0700 <20090923061834.BE13A22@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
	<alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
	<20090923024049.AA85913F37@magilla.sf.frob.com>
	<20090923061834.BE13A22@magilla.sf.frob.com>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Message-Id: <20090923062045.4106014093@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 23:20:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The high 32 bits of orig_ax will be ignored when it matters,
so don't fiddle them when setting it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8d7d5c9..52222fa 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -325,16 +325,6 @@ static int putreg(struct task_struct *child,
 		return set_flags(child, value);
 
 #ifdef CONFIG_X86_64
-	/*
-	 * Orig_ax is really just a flag with small positive and
-	 * negative values, so make sure to always sign-extend it
-	 * from 32 bits so that it works correctly regardless of
-	 * whether we come from a 32-bit environment or not.
-	 */
-	case offsetof(struct user_regs_struct, orig_ax):
-		value = (long) (s32) value;
-		break;
-
 	case offsetof(struct user_regs_struct,fs_base):
 		if (value >= TASK_SIZE_OF(child))
 			return -EIO;
@@ -1121,17 +1111,10 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 	R32(esi, si);
 	R32(ebp, bp);
 	R32(eax, ax);
+	R32(orig_eax, orig_ax);
 	R32(eip, ip);
 	R32(esp, sp);
 
-	case offsetof(struct user32, regs.orig_eax):
-		/*
-		 * Sign-extend the value so that orig_eax = -1
-		 * causes (long)orig_ax < 0 tests to fire correctly.
-		 */
-		regs->orig_ax = (long) (s32) value;
-		break;
-
 	case offsetof(struct user32, regs.eflags):
 		return set_flags(child, value);
 
