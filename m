Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYGAJCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYGAJCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYGAJC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:02:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbYGAJC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:02:26 -0400
Date: Tue, 1 Jul 2008 11:02:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
Message-ID: <20080701090204.GA1729@elte.hu>
References: <20080630.134445.193700135.takada@mbf.nifty.com> <20080630210241.93738154077@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630210241.93738154077@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> ptrace has always returned only -EIO for all failures to access 
> registers.  The user_regset calls are allowed to return a more 
> meaningful variety of errors.  The REGSET_XFP calls use -ENODEV for 
> !cpu_has_fxsr hardware.  Make ptrace return the traditional -EIO 
> instead of the error code from the user_regset call.

since the original fix is already upstream, i've applied the delta patch 
below. Should we still do this for v2.6.26 or can we defer it to 
v2.6.27? As ptrace is the only user of this facility for now this would 
be an identity transformation AFAICS and the v2.6.26 release is very 
close.

	Ingo

---------------->
Subject: x86 ptrace: fix PTRACE_GETFPXREGS error
From: Roland McGrath <roland@redhat.com>
Date: Mon, 30 Jun 2008 14:02:41 -0700 (PDT)

ptrace has always returned only -EIO for all failures to access
registers.  The user_regset calls are allowed to return a more
meaningful variety of errors.  The REGSET_XFP calls use -ENODEV
for !cpu_has_fxsr hardware.  Make ptrace return the traditional
-EIO instead of the error code from the user_regset call.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/i387.c   |    4 ++--
 arch/x86/kernel/ptrace.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c
+++ tip/arch/x86/kernel/i387.c
@@ -162,7 +162,7 @@ int xfpregs_get(struct task_struct *targ
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -EIO;
+		return -ENODEV;
 
 	ret = init_fpu(target);
 	if (ret)
@@ -179,7 +179,7 @@ int xfpregs_set(struct task_struct *targ
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -EIO;
+		return -ENODEV;
 
 	ret = init_fpu(target);
 	if (ret)
Index: tip/arch/x86/kernel/ptrace.c
===================================================================
--- tip.orig/arch/x86/kernel/ptrace.c
+++ tip/arch/x86/kernel/ptrace.c
@@ -943,13 +943,13 @@ long arch_ptrace(struct task_struct *chi
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
