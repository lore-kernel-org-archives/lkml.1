Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYGCSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYGCSbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYGCSb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:31:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48817 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYGCSb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:31:28 -0400
Date: Thu, 3 Jul 2008 14:31:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH] hrtimer: prevent migration for raising softirq
Message-ID: <Pine.LNX.4.58.0807031428440.7798@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Due to a possible deadlock, the waking of the softirq was pushed outside
of the hrtimer base locks. See commit 0c96c5979a522c3323c30a078a70120e29b5bdbc

Unfortunately this allows the task to migrate after setting up the softirq
and raising it. Since softirqs run a queue that is per-cpu we may raise the
softirq on the wrong CPU and this will keep the queued softirq task from
running.

To solve this issue, this patch disables preemption around the releasing
of the hrtimer lock and raising of the softirq.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linus.git/kernel/hrtimer.c
===================================================================
--- linus.git.orig/kernel/hrtimer.c	2008-05-09 15:11:45.000000000 -0400
+++ linus.git/kernel/hrtimer.c	2008-07-03 14:07:30.000000000 -0400
@@ -1003,10 +1003,18 @@ hrtimer_start(struct hrtimer *timer, kti
 	 */
 	raise = timer->state == HRTIMER_STATE_PENDING;

+	/*
+	 * We use preempt_disable to prevent this task from migrating after
+	 * setting up the softirq and raising it. Otherwise, if me migrate
+	 * we will raise the softirq on the wrong CPU.
+	 */
+	preempt_disable();
+
 	unlock_hrtimer_base(timer, &flags);

 	if (raise)
 		hrtimer_raise_softirq();
+	preempt_enable();

 	return ret;
 }

