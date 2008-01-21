Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYAUPYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYAUPYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYAUPYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:03 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:62564 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYAUPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:23:59 -0500
Message-Id: <20080121152354.065502922@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 20/23 -v4] Add marker in try_to_wake_up
Content-Disposition: inline; filename=add-markers-to-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked at what Mathieu Desnoyers did in his LTTng patches
to use as a marker for the wakeup latency timings. But unfortunately,
his marker didn't give me enough information. What I need is the
task pointer itself. I also look at its priority but I need to
keep track of the task itself incase it gets pulled to another
CPU. (and no, I'm not going to hook into the migration code)

I took his marker and added a pointer to p and the pointer
to the current running task on p's runqueue (note it may not
be the same runqueue as current is on).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-21 10:03:29.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-21 10:05:41.000000000 -0500
@@ -1633,6 +1633,10 @@ out_set_cpu:
 
 out_activate:
 #endif /* CONFIG_SMP */
+	trace_mark(kernel_sched_wakeup,
+		   "p %p rq->curr %p",
+		   p, rq->curr);
+
 	schedstat_inc(p, se.nr_wakeups);
 	if (sync)
 		schedstat_inc(p, se.nr_wakeups_sync);

-- 
