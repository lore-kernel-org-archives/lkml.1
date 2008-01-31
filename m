Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbYAaPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbYAaPnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYAaPnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:43:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYAaPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:43:31 -0500
Subject: [PATCH -v2] hrtimer: fix hrtimer_init_sleeper() users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1201789644.32654.5.camel@lappy>
References: <200801302338.25365.rjw@sisk.pl>
	 <200801310042.07910.rjw@sisk.pl>  <1201789644.32654.5.camel@lappy>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 16:42:50 +0100
Message-Id: <1201794171.32654.19.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this time build tested

---
Subject: hrtimer: fix hrtimer_init_sleeper() users

commit 37bb6cb4097e29ffee970065b74499cbf10603a3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jan 25 21:08:32 2008 +0100

    hrtimer: unlock hrtimer_wakeup

Broke hrtimer_init_sleeper() users. It forgot to fix up the futex
caller of this function to detect the failed queueing and messed up
the do_nanosleep() caller in that it could leak a TASK_INTERRUPTIBLE
state.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/futex.c   |    2 ++
 kernel/hrtimer.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1312,6 +1312,8 @@ static int __sched do_nanosleep(struct h
 
 	} while (t->task && !signal_pending(current));
 
+	__set_current_state(TASK_RUNNING);
+
 	return t->task == NULL;
 }
 
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1252,6 +1252,8 @@ static int futex_wait(u32 __user *uaddr,
 			t.timer.expires = *abs_time;
 
 			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+			if (!hrtimer_active(&t.timer))
+				t.task = NULL;
 
 			/*
 			 * the timer could have already expired, in which


