Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbYHGMgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbYHGMgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbYHGMgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:36:31 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:52689 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbYHGMg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:36:29 -0400
Date: Thu, 7 Aug 2008 18:05:58 +0530
From: Chirag Jog <chirag@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: "Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: [PATCH][PPC64][RT] Fix a previously reverted fix again
Message-ID: <20080807123558.GA10684@linux.vnet.ibm.com>
Reply-To: Chirag Jog <chirag@linux.vnet.ibm.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-rt-users <linux-rt-users@vger.kernel.org>,
	"Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>,
	Josh Triplett <josht@linux.vnet.ibm.com>,
	Sebastien Dugue <sebastien.dugue@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Organization: IBM LTC
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Steven,
   Ironically in the 2.6.26-rt1,the patch fix-a-previously-reverted-fix.patch
   again got reverted ;).
   
   Here the patch that should replace the above patch.

This patch reintroduces a "fix" that got reverted.
Here was the original patch http://lkml.org/lkml/2007/5/22/133

Here is the new patch
This patch also fixes OOPS reported here: http://lkml.org/lkml/2008/6/19/146

>From tsutomu.owa@toshiba.co.jp
Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>



---
 arch/powerpc/kernel/entry_64.S |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6.26-rt1/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-2.6.26-rt1.orig/arch/powerpc/kernel/entry_64.S	2008-08-07 10:35:18.000000000 +0000
+++ linux-2.6.26-rt1/arch/powerpc/kernel/entry_64.S	2008-08-07 11:33:55.000000000 +0000
@@ -595,30 +595,31 @@
 	bne	restore
 	/* here we are preempting the current task */
 1:
+	/*
+	 * preempt_schedule_irq() expects interrupts disabled and returns
+	 * with interrupts disabled. No need to check preemption again,
+	 * preempt_schedule_irq just did that for us.
+	 */
+	bl	.preempt_schedule_irq
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	.trace_hardirqs_on
+#endif /* CONFIG_TRACE_IRQFLAGS */
+
 	/* Note: we just clobbered r10 which used to contain the previous
 	 * MSR before the hard-disabling done by the caller of do_work.
 	 * We don't have that value anymore, but it doesn't matter as
 	 * we will hard-enable unconditionally, we can just reload the
 	 * current MSR into r10
 	 */
-	mfmsr	r10
-#endif /* CONFIG_TRACE_IRQFLAGS */
-	li	r0,1
-	stb	r0,PACASOFTIRQEN(r13)
-	stb	r0,PACAHARDIRQEN(r13)
-	ori	r10,r10,MSR_EE
-	mtmsrd	r10,1		/* reenable interrupts */
-	bl	.preempt_schedule
-	mfmsr	r10
-	clrrdi	r9,r1,THREAD_SHIFT
-	rldicl	r10,r10,48,1	/* disable interrupts again */
-	rotldi	r10,r10,16
-	mtmsrd	r10,1
-	ld	r4,TI_FLAGS(r9)
-	andi.	r0,r4,_TIF_NEED_RESCHED
-	bne	1b
+	bl	.preempt_schedule_irq
+	mfmsr   r10
+	clrrdi  r9,r1,THREAD_SHIFT
+	rldicl  r10,r10,48,1    /* disable interrupts again */
+	rotldi  r10,r10,16
+	mtmsrd  r10,1
+	ld      r4,TI_FLAGS(r9)
+	andi.   r0,r4,(_TIF_NEED_RESCHED)
+	bne     1b
 	b	restore
 
 user_work:


