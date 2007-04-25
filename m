Return-Path: <linux-kernel-owner+w=401wt.eu-S1423357AbXDYR6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423357AbXDYR6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423356AbXDYR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:58:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423354AbXDYR6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:58:09 -0400
Date: Wed, 25 Apr 2007 19:57:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425175758.GA28201@elte.hu>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425040605.6d6b4a82.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


just found and fixed the bug below in SysRq-T - should be included in 
v2.6.21 i think.

-------------------------->
Subject: [patch] make SysRq-T show all tasks again
From: Ingo Molnar <mingo@elte.hu>

show_state() (SysRq-T) developed the buggy habbit of not showing 
TASK_RUNNING tasks. This was due to the mistaken belief that 
state_filter == -1 would be a pass-through filter - while in reality it 
did not let TASK_RUNNING == 0 p->state values through.

(fix this be restoring the original '!state_filter means all tasks' 
special-case i had in the original version. Test-built and test-booted 
on i686, SysRq-T now works as intended.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    4 ++--
 kernel/sched.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -196,13 +196,13 @@ extern void init_idle(struct task_struct
 extern cpumask_t nohz_cpu_mask;
 
 /*
- * Only dump TASK_* tasks. (-1 for all tasks)
+ * Only dump TASK_* tasks. (0 for all tasks)
  */
 extern void show_state_filter(unsigned long state_filter);
 
 static inline void show_state(void)
 {
-	show_state_filter(-1);
+	show_state_filter(0);
 }
 
 extern void show_regs(struct pt_regs *);
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4746,7 +4746,7 @@ void show_state_filter(unsigned long sta
 		 * console might take alot of time:
 		 */
 		touch_nmi_watchdog();
-		if (p->state & state_filter)
+		if (!state_filter || (p->state & state_filter))
 			show_task(p);
 	} while_each_thread(g, p);
 
