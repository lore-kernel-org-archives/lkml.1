Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbZJHStn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbZJHStn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbZJHStn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:49:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:63777 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbZJHStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aMsoXnBmARbRk1+n0whwCyUxW5D/yEz2fpfuWtXj1K9uqpUisEENuCiNo+X0ahJZoK
         q0W8y05yaFR1pFQ9JjgLCOQCTIGYaK5vroJ6rOJdDjD3Wm2aNccfF/1sIep6f4cHH7HZ
         3682H0rwSQInpFN6c70ihDIcZCzZk1MVDmlUI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: Fix thread comm resolution in perf sched
Date: Thu,  8 Oct 2009 20:48:32 +0200
Message-Id: <1255027712-10768-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255019582.26976.314.camel@twins>
References: <1255019582.26976.314.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are failing to resolve thread names in perf sched because the table
of threads we are building, on top of comm events, has a per process
granularity. But perf sched, unlike the other perf tools, needs a per
thread granularity as we are profiling every tasks individually.

So fix it by building our threads table using the tid instead of the pid
as the thread identifier.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index e1df705..6b00529 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -638,7 +638,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread;
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	thread = threads__findnew(event->comm.tid, &threads, &last_match);
 
 	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
 		(void *)(offset + head),
-- 
1.6.2.3

