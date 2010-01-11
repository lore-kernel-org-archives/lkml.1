Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745Ab0AKGiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0AKGiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424Ab0AKGiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:38:23 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:53399 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0AKGiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wnZ9vWOtXkUwEsm7eMtiHaL2JAuvf2sfpJ2eZCcP+6A9DlbrneS+0ySCGCvqspzbd0
         Cz7w+lmDTfJ+QpXwypMl/9+HpOnUpA+/D0F/ixF4o/G/A3N8oEo8R3Kvu7ZJgG4405y0
         HHReIjuI40j+5Z+F2wMmoLi0k+vNuGuYngXIk=
MIME-Version: 1.0
Date: Mon, 11 Jan 2010 14:38:21 +0800
Message-ID: <2674af741001102238w7b0ddcadref00d345e2181d11@mail.gmail.com>
Subject: [PATCH] sched: reassign prev and switch_count when 
	reacquire_kernel_lock() fail
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4c04fbbd43f3fef7a3b9471a0000c399c2e045ed Mon Sep 17 00:00:00 2001
From: Yong Zhang <yong.zhang0@gmail.com>
Date: Mon, 11 Jan 2010 14:21:25 +0800
Subject: [PATCH] sched: reassign prev and switch_count when
reacquire_kernel_lock() fail

Assume A->B schedule is processing, if B have acquired BKL before and
it need reschedule this time. Then on B's context, it will go to
need_resched_nonpreemptible for reschedule. But at this time, prev
and switch_count are related to A. It's wrong and will lead to
incorrect scheduler statistics.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..4508fe7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5530,8 +5530,11 @@ need_resched_nonpreemptible:

 	post_schedule(rq);

-	if (unlikely(reacquire_kernel_lock(current) < 0))
+	if (unlikely(reacquire_kernel_lock(current) < 0)) {
+		prev = rq->curr;
+		switch_count = &prev->nivcsw;
 		goto need_resched_nonpreemptible;
+	}

 	preempt_enable_no_resched();
 	if (need_resched())
-- 
1.6.3.3
