Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYFGBMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYFGBMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbYFGBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:59 -0400
Received: from sous-sol.org ([216.99.217.87]:42352 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbYFGBI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:57 -0400
Message-Id: <20080607010626.125224061@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 36/50] x86, fpu: fix CONFIG_PREEMPT=y corruption of applications FPU stack
Content-Disposition: inline; filename=x86-fpu-fix-config_preempt-y-corruption-of-application-s-fpu-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

upstream commit: 870568b39064cab2dd971fe57969916036982862

Jürgen Mell reported an FPU state corruption bug under CONFIG_PREEMPT,
and bisected it to commit v2.6.19-1363-gacc2076, "i386: add sleazy FPU
optimization".

Add tsk_used_math() checks to prevent calling math_state_restore()
which can sleep in the case of !tsk_used_math(). This prevents
making a blocking call in __switch_to().

Apparently "fpu_counter > 5" check is not enough, as in some signal handling
and fork/exec scenarios, fpu_counter > 5 and !tsk_used_math() is possible.

It's a side effect though. This is the failing scenario:

process 'A' in save_i387_ia32() just after clear_used_math()

Got an interrupt and pre-empted out.

At the next context switch to process 'A' again, kernel tries to restore
the math state proactively and sees a fpu_counter > 0 and !tsk_used_math()

This results in init_fpu() during the __switch_to()'s math_state_restore()

And resulting in fpu corruption which will be saved/restored
(save_i387_fxsave and restore_i387_fxsave) during the remaining
part of the signal handling after the context switch.

Bisected-by: Jürgen Mell <j.mell@t-online.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Jürgen Mell <j.mell@t-online.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/process_32.c |    5 ++++-
 arch/x86/kernel/process_64.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -710,8 +710,11 @@ struct task_struct * __switch_to(struct 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * tsk_used_math() checks prevent calling math_state_restore(),
+	 * which can sleep in the case of !tsk_used_math()
 	 */
-	if (next_p->fpu_counter > 5)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
 
 	/*
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -696,8 +696,11 @@ __switch_to(struct task_struct *prev_p, 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * tsk_used_math() checks prevent calling math_state_restore(),
+	 * which can sleep in the case of !tsk_used_math()
 	 */
-	if (next_p->fpu_counter>5)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
 	return prev_p;
 }

-- 
