Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZATIiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZATIiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZATIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:37:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZATIh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:37:58 -0500
Date: Tue, 20 Jan 2009 09:37:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Justin Madru <jdm64@gawab.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
Message-ID: <20090120083700.GA5277@elte.hu>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.C4F.Q9QdJB@chimera> <49756F3E.6050304@gawab.com> <20090120074312.GD16426@elte.hu> <20090120081650.GA29725@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120081650.GA29725@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > (added Cc:s)
> 
> > Justin, does it work if you apply the patch below instead of the revert?
> 
> hm, that patch wont build because the protect_asmlinkage macro is rather 
> limited - it cannot deal with structure parameters.
> 
> We might be better off with a revert here, and a comment added that points 
> out the problem.

Below is the revert+document commit that i have queued up.

Justin, could you try the tip/master tree (which has this fix included):

  http://people.redhat.com/mingo/tip.git/README

does Firefox still work fine?

	Ingo

------------->
>From 779c9b9f8cb87cdfbd299ee7beb62e50ce139a92 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Jan 2009 09:31:49 +0100
Subject: [PATCH] Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"

This reverts commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191.

Justin Madru bisected this commit, it was causing weird Firefox
crashes.

The reason is that GCC mis-optimizes (re-uses) the on-stack parameters of
the calling frame, which corrupts the syscall return pt_regs state and
thus corrupts user-space register state.

So we go back to the slightly less clean but more optimization-safe
method of getting to pt_regs. Also add a comment to explain this.

Resolves: http://bugzilla.kernel.org/show_bug.cgi?id=12505

Reported-and-bisected-by: Justin Madru <jdm64@gawab.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/syscalls.h |    2 +-
 arch/x86/kernel/signal.c        |   11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 9c6797c..c0b0bda 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -40,7 +40,7 @@ asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 asmlinkage int sys_sigaltstack(unsigned long);
 asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(struct pt_regs);
+asmlinkage int sys_rt_sigreturn(unsigned long);
 
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned long);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 89bb766..df0587f 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -632,9 +632,16 @@ badframe:
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
+/*
+ * Note: do not pass in pt_regs directly as with tail-call optimization
+ * GCC will incorrectly stomp on the caller's frame and corrupt user-space
+ * register state:
+ */
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 {
-	return do_rt_sigreturn(&regs);
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
 }
 #else /* !CONFIG_X86_32 */
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
