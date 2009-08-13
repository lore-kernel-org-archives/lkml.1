Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZHMOTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZHMOTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZHMOTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:19:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbZHMOTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:19:37 -0400
Date: Thu, 13 Aug 2009 14:18:56 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, peterz@infradead.org, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, anton@samba.org,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, peterz@infradead.org, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250172882.5241.62.camel@twins>
References: <1250172882.5241.62.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Report the cloning task as parent on perf_counter_fork()
Message-ID: <tip-94d5d1b2d891f1fd5205f978246b7864d998b25c@git.kernel.org>
Git-Commit-ID: 94d5d1b2d891f1fd5205f978246b7864d998b25c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 14:18:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94d5d1b2d891f1fd5205f978246b7864d998b25c
Gitweb:     http://git.kernel.org/tip/94d5d1b2d891f1fd5205f978246b7864d998b25c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Aug 2009 16:14:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 16:17:15 +0200

perf_counter: Report the cloning task as parent on perf_counter_fork()

A bug in (9f498cc: perf_counter: Full task tracing) makes
profiling multi-threaded apps it go belly up.

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

The problem is that perf_counter_fork() reports the actual
parent, instead of the cloning thread.

Fixing that (with the below patch), yields:

 # ./perf report -D | grep FORK
0x4c8 [0x18]: PERF_EVENT_FORK: (1590:1590):(1589:1589)
0xbd8 [0x18]: PERF_EVENT_FORK: (1590:1591):(1590:1590)
0xc80 [0x18]: PERF_EVENT_FORK: (1590:1592):(1590:1590)
0x3338 [0x18]: PERF_EVENT_FORK: (1590:1593):(1590:1590)
0x66b0 [0x18]: PERF_EVENT_FORK: (1590:1594):(1590:1590)

Which both makes more sense and doesn't confuse perf report
anymore.

Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: paulus@samba.org
Cc: Anton Blanchard <anton@samba.org>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <1250172882.5241.62.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 3f841be..534e20d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3028,10 +3028,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
 		return;
 
 	task_event->event.pid = perf_counter_pid(counter, task);
-	task_event->event.ppid = perf_counter_pid(counter, task->real_parent);
+	task_event->event.ppid = perf_counter_pid(counter, current);
 
 	task_event->event.tid = perf_counter_tid(counter, task);
-	task_event->event.ptid = perf_counter_tid(counter, task->real_parent);
+	task_event->event.ptid = perf_counter_tid(counter, current);
 
 	perf_output_put(&handle, task_event->event);
 	perf_output_end(&handle);
