Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbYF0U4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbYF0U4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYF0U4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:56:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYF0U4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:56:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: stable@kernel.org
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Thorsten Knabe <linux@thorsten-knabe.de>, Jeff Dike <jdike@addtoit.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: [PATCH stable-2.6.25] x86_64 ptrace: fix sys32_ptrace task_struct leak
In-Reply-To: WANG Cong's message of  Sunday, 8 June 2008 22:34:34 +0800 <20080608143434.GF2487@hacking>
References: <483EC624.90503@thorsten-knabe.de>
	<20080601213134.GJ4018@sequoia.sous-sol.org>
	<20080602010546.GA8578@c2.user-mode-linux.org>
	<484719C7.2020502@thorsten-knabe.de>
	<20080605004925.GA15461@c2.user-mode-linux.org>
	<484BC4DF.5000605@thorsten-knabe.de>
	<20080608143434.GF2487@hacking>
X-Shopping-List: (1) Latent expectorants
   (2) Insufficient deodorant documents
   (3) Sexy deep-fried apparition rice
Message-Id: <20080627204953.EB060154039@magilla.localdomain>
Date: Thu, 12 Jun 2008 12:01:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5a4646a4efed8c835f76c3b88f3155f6ab5b8d9b introduced a leak of
task_struct refs into sys32_ptrace.  This bug has already gone away in
for 2.6.26 in commit 562b80bafffaf42a6d916b0a2ee3d684220a1c10.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   45 ++++++++++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 9003e0b..a10ba65 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1309,42 +1309,49 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 		break;
 
 	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_GENERAL,
-					   0, sizeof(struct user_regs_struct32),
-					   datap);
+		ret = copy_regset_to_user(child, &user_x86_32_view,
+					  REGSET_GENERAL,
+					  0, sizeof(struct user_regs_struct32),
+					  datap);
+		break;
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
-		return copy_regset_from_user(child, &user_x86_32_view,
-					     REGSET_GENERAL, 0,
-					     sizeof(struct user_regs_struct32),
-					     datap);
+		ret = copy_regset_from_user(child, &user_x86_32_view,
+					    REGSET_GENERAL, 0,
+					    sizeof(struct user_regs_struct32),
+					    datap);
+		break;
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_FP, 0,
-					   sizeof(struct user_i387_ia32_struct),
-					   datap);
+		ret = copy_regset_to_user(child, &user_x86_32_view,
+					  REGSET_FP, 0,
+					  sizeof(struct user_i387_ia32_struct),
+					  datap);
+		break;
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
-		return copy_regset_from_user(
+		ret = copy_regset_from_user(
 			child, &user_x86_32_view, REGSET_FP,
 			0, sizeof(struct user_i387_ia32_struct), datap);
+		break;
 
 	case PTRACE_GETFPXREGS:	/* Get the child extended FPU state. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_XFP, 0,
-					   sizeof(struct user32_fxsr_struct),
-					   datap);
+		ret = copy_regset_to_user(child, &user_x86_32_view,
+					  REGSET_XFP, 0,
+					  sizeof(struct user32_fxsr_struct),
+					  datap);
+		break;
 
 	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
-		return copy_regset_from_user(child, &user_x86_32_view,
+		ret = copy_regset_from_user(child, &user_x86_32_view,
 					     REGSET_XFP, 0,
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
+		break;
 
 	default:
-		return compat_ptrace_request(child, request, addr, data);
+		ret = compat_ptrace_request(child, request, addr, data);
+		break;
 	}
 
  out:
