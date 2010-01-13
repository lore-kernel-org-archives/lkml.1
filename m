Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862Ab0AMKlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0AMKlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441Ab0AMKlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:41:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:38627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0AMKkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:40:52 -0500
Date: Wed, 13 Jan 2010 10:37:04 GMT
From: tip-bot for Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       linux@arm.linux.org.uk, peterz@infradead.org, jamie.iles@picochip.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, peterz@infradead.org, jamie.iles@picochip.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262964453-27370-1-git-send-email-jamie.iles@picochip.com>
References: <1262964453-27370-1-git-send-email-jamie.iles@picochip.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] sched/perf: Make sure irqs are disabled for perf_event_task_sched_in()
Message-ID: <tip-8381f65d097dad90416808314737dd7d3ae38ea9@git.kernel.org>
Git-Commit-ID: 8381f65d097dad90416808314737dd7d3ae38ea9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:37:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8381f65d097dad90416808314737dd7d3ae38ea9
Gitweb:     http://git.kernel.org/tip/8381f65d097dad90416808314737dd7d3ae38ea9
Author:     Jamie Iles <jamie.iles@picochip.com>
AuthorDate: Fri, 8 Jan 2010 15:27:33 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:43:08 +0100

sched/perf: Make sure irqs are disabled for perf_event_task_sched_in()

perf_event_task_sched_in() expects interrupts to be disabled,
but on architectures with __ARCH_WANT_INTERRUPTS_ON_CTXSW
defined, this isn't true. If this is defined, disable irqs
around the call in finish_task_switch().

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
LKML-Reference: <1262964453-27370-1-git-send-email-jamie.iles@picochip.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e507af0..c3ad342 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2783,7 +2783,13 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_disable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	perf_event_task_sched_in(current);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 
 	fire_sched_in_preempt_notifiers(current);
