Return-Path: <linux-kernel-owner+w=401wt.eu-S969222AbXGaEhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969222AbXGaEhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968260AbXGaEcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34616 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967722AbXGaEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:12 -0400
Date: Mon, 30 Jul 2007 21:33:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 18/26] POWERPC: Fix subtle FP state corruption bug in
	signal return on SMP
Message-ID: <20070731043316.GS3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fix-subtle-fp-state-corruption-bug-in-signal-return-on-smp.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

This fixes a bug which can cause corruption of the floating-point state
on return from a signal handler.  If we have a signal handler that has
used the floating-point registers, and it happens to context-switch to
another task while copying the interrupted floating-point state from the
user stack into the thread struct (e.g. because of a page fault, or
because it gets preempted), the context switch code will think that the
FP registers contain valid FP state that needs to be copied into the
thread_struct, and will thus overwrite the values that the signal return
code has put into the thread_struct.

This can occur because we clear the MSR bits that indicate the presence
of valid FP state after copying the state into the thread_struct.  To fix
this we just move the clearing of the MSR bits to before the copy.  A
similar potential problem also occurs with the Altivec state, and this
fixes that in the same way.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/signal_64.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- linux-2.6.21.6.orig/arch/powerpc/kernel/signal_64.c
+++ linux-2.6.21.6/arch/powerpc/kernel/signal_64.c
@@ -177,6 +177,13 @@ static long restore_sigcontext(struct pt
 	 */
 	discard_lazy_cpu_state();
 
+	/*
+	 * Force reload of FP/VEC.
+	 * This has to be done before copying stuff into current->thread.fpr/vr
+	 * for the reasons explained in the previous comment.
+	 */
+	regs->msr &= ~(MSR_FP | MSR_FE0 | MSR_FE1 | MSR_VEC);
+
 	err |= __copy_from_user(&current->thread.fpr, &sc->fp_regs, FP_REGS_SIZE);
 
 #ifdef CONFIG_ALTIVEC
@@ -198,9 +205,6 @@ static long restore_sigcontext(struct pt
 		current->thread.vrsave = 0;
 #endif /* CONFIG_ALTIVEC */
 
-	/* Force reload of FP/VEC */
-	regs->msr &= ~(MSR_FP | MSR_FE0 | MSR_FE1 | MSR_VEC);
-
 	return err;
 }
 

-- 
