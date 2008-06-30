Return-Path: <linux-kernel-owner+w=401wt.eu-S1763146AbYF3VDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763146AbYF3VDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762298AbYF3VD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:03:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828AbYF3VD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:03:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
In-Reply-To: TAKADA Yoshihito's message of  Monday, 30 June 2008 13:44:45 +0900 <20080630.134445.193700135.takada@mbf.nifty.com>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080630210241.93738154077@magilla.localdomain>
Date: Mon, 30 Jun 2008 14:02:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace has always returned only -EIO for all failures to access
registers.  The user_regset calls are allowed to return a more
meaningful variety of errors.  The REGSET_XFP calls use -ENODEV
for !cpu_has_fxsr hardware.  Make ptrace return the traditional
-EIO instead of the error code from the user_regset call.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index a7835f2..77040b6 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -943,13 +943,13 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		return copy_regset_to_user(child, &user_x86_32_view,
 					   REGSET_XFP,
 					   0, sizeof(struct user_fxsr_struct),
-					   datap);
+					   datap) ? -EIO : 0;
 
 	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
 		return copy_regset_from_user(child, &user_x86_32_view,
 					     REGSET_XFP,
 					     0, sizeof(struct user_fxsr_struct),
-					     datap);
+					     datap) ? -EIO : 0;
 #endif
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
