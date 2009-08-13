Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZHMOPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZHMOPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZHMOPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:15:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:53508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZHMOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:15:17 -0400
Subject: [PATCH] perf_counter: Report the cloning task as parent on
 perf_counter_fork()
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, Arnaldo Carvalho de Melo <acme@redhat.com>,
       paulus@samba.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1250155708.6052.2.camel@penberg-laptop>
References: <1250155708.6052.2.camel@penberg-laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 16:14:42 +0200
Message-Id: <1250172882.5241.62.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bug in (9f498cc: perf_counter: Full task tracing) makes profiling
multi-threaded apps it go belly up.

[ output as: (PID:TID):(PPID:PTID) ]

# ./perf report -D | grep FORK
0x4b0 [0x18]: PERF_EVENT_FORK: (3237:3237):(3236:3236)
0xa10 [0x18]: PERF_EVENT_FORK: (3237:3238):(3236:3236)
0xa70 [0x18]: PERF_EVENT_FORK: (3237:3239):(3236:3236)
0xad0 [0x18]: PERF_EVENT_FORK: (3237:3240):(3236:3236)
0xb18 [0x18]: PERF_EVENT_FORK: (3237:3241):(3236:3236)

Shows us that the test (27d028d perf report: Update for the new
FORK/EXIT events) in builtin-report.c:

        /*
         * A thread clone will have the same PID for both
         * parent and child.
         */
        if (thread == parent)
                return 0;

Will clearly fail.

The problem is that perf_counter_fork() reports the actual parent,
instead of the cloning thread.

Fixing that (with the below patch), yields:

# ./perf report -D | grep FORK
0x4c8 [0x18]: PERF_EVENT_FORK: (1590:1590):(1589:1589)
0xbd8 [0x18]: PERF_EVENT_FORK: (1590:1591):(1590:1590)
0xc80 [0x18]: PERF_EVENT_FORK: (1590:1592):(1590:1590)
0x3338 [0x18]: PERF_EVENT_FORK: (1590:1593):(1590:1590)
0x66b0 [0x18]: PERF_EVENT_FORK: (1590:1594):(1590:1590)

Which both makes more sense and doesn't confuse perf report anymore.

Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 perf_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3024,10 +3024,10 @@ static void perf_counter_task_output(str
 		return;
 
 	task_event->event.pid = perf_counter_pid(counter, task);
-	task_event->event.ppid = perf_counter_pid(counter, task->real_parent);
+	task_event->event.ppid = perf_counter_pid(counter, current);
 
 	task_event->event.tid = perf_counter_tid(counter, task);
-	task_event->event.ptid = perf_counter_tid(counter, task->real_parent);
+	task_event->event.ptid = perf_counter_tid(counter, current);
 
 	perf_output_put(&handle, task_event->event);
 	perf_output_end(&handle);

