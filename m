Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0BEPhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:37:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:40600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0BEPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:37:41 -0500
Subject: [RFC][PATCH] perf_events: Fix FORK events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: multipart/mixed; boundary="=-6BKwlM+v1yFPbAzjcztE"
Date: Fri, 05 Feb 2010 16:37:23 +0100
Message-ID: <1265384243.30057.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6BKwlM+v1yFPbAzjcztE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

While looking into a problem reported by Pekka, I noticed that I wasn't
receiving any FORK events for a workload that did fork (see attachment).

After making the below change, stuff started working again, thing is,
I'm not sure why.

The main change is sending the FORK event to the parent instead of the
child thread, however perf_event_fork() is at the end of copy_process(),
which is after perf_event_init_task() which inherits all the counters,
so it should all have worked as it was.

We could of course just slam the commit in and not worry about it, but
that just doesn't feel right.

Alternatively, I'm really really dense and I'm totally missing the
obvious.

Signed-ff-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ab8a312..01655fa 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3399,8 +3399,6 @@ static void perf_event_task_output(struct perf_event *event,
 	task_event->event_id.tid = perf_event_tid(event, task);
 	task_event->event_id.ptid = perf_event_tid(event, current);
 
-	task_event->event_id.time = perf_clock();
-
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
@@ -3440,7 +3438,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_task_ctx(&cpuctx->ctx, task_event);
 	if (!ctx)
-		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
+		ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
 	put_cpu_var(perf_cpu_context);
@@ -3471,6 +3469,7 @@ static void perf_event_task(struct task_struct *task,
 			/* .ppid */
 			/* .tid  */
 			/* .ptid */
+			.time = perf_clock(),
 		},
 	};
 


--=-6BKwlM+v1yFPbAzjcztE
Content-Disposition: attachment; filename="loop_1b_instructions-4x.c"
Content-Type: text/x-csrc; name="loop_1b_instructions-4x.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit


#include <stdlib.h>
#include <stdio.h>
#include <time.h>

main ()
{
	int i;

	fork();
	fork();

	for (i = 0; i < 100000000; i++) {
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
	}
	wait(NULL);
	wait(NULL);
	wait(NULL);
	wait(NULL);
}

--=-6BKwlM+v1yFPbAzjcztE--

