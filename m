Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYCUOcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYCUOcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYCUOcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:32:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYCUOcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:32:45 -0400
Date: Fri, 21 Mar 2008 15:32:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Yakov Lerner <iler.ml@gmail.com>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in
	post_hander()
Message-ID: <20080321143229.GE31719@elte.hu>
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080321110804.GY20420@elte.hu> <20080321113134.GA7620@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321113134.GA7620@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> > thanks, i've added your patch to the .26 bucket of x86.git, but it 
> > would be nice to get an Ack/Nack from a kprobes person as well.
>  
> Ingo,
> 
> I've tested Yakov's more comprehensive patch on powerpc too. This has 
> my ack.
> 
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

thanks, i've queued up the x86-only patch below for .26 merging. (that 
is all that is needed for x86, and no .25 urgency, right?)

	Ingo

------------------>
Subject: x86, kprobes: correct post-eip value in post_hander()
From: "Yakov Lerner" <iler.ml@gmail.com>
Date: Sun, 16 Mar 2008 03:21:21 -0500

I was trying to get the address of instruction to be executed
next after the kprobed instruction.  But regs->eip in post_handler()
contains value which is useless to the user. It's pre-corrected value.
This value is difficult to use without access to resume_execution(), which
is not exported anyway.
I moved the invocation of post_handler() to *after* resume_execution().
Now regs->eip contains meaningful value in post_handler().

I do not think this change breaks any backward-compatibility.
To make meaning of the old value, post_handler() would need access to
resume_execution() which is not exported.  I have difficulty to believe
that previous, uncorrected, regs->eip can be meaningfully used in
post_handler().

Signed-off-by: Yakov Lerner <iler.ml@gmail.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/kernel/kprobes.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/kprobes.c
+++ linux-x86.q/arch/x86/kernel/kprobes.c
@@ -858,15 +858,15 @@ static int __kprobes post_kprobe_handler
 	if (!cur)
 		return 0;
 
+	resume_execution(cur, regs, kcb);
+	regs->flags |= kcb->kprobe_saved_flags;
+	trace_hardirqs_fixup_flags(regs->flags);
+
 	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
 		kcb->kprobe_status = KPROBE_HIT_SSDONE;
 		cur->post_handler(cur, regs, 0);
 	}
 
-	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_flags;
-	trace_hardirqs_fixup_flags(regs->flags);
-
 	/* Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
 		restore_previous_kprobe(kcb);
