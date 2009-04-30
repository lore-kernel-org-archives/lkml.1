Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbZD3Oyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbZD3Oyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZD3Oya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:54:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32809 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZD3Oy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dNGt/dlKGJYba/0OoklBqN6Hbcd/Xbcq8KAJhKdhQdSrmg1tesY+dw910xO3qMJWuU
         a2SeHG9Rk/aHhW90K6612rEa/LOtvGftk3oikSdwiY0LTugJSitUUKEXQ7z9oO+HEOgV
         vHfkvR99dwOLNPpJNPbHcam+pZeYhB/6/7It8=
Date: Thu, 30 Apr 2009 16:54:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [GIT PULL] tracing/workqueue: fix 32 bits unfriendly 64
	bits division
Message-ID: <20090430145425.GA5974@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is a fix for the build error you reported.
This branch can be pulled independantly or on top of tracing/workqueue
from the previous pull-request.

Thanks.


The following changes since commit 10c494ea1b75f96d5fca78178732d79e68129cc0:
  Frederic Weisbecker (1):
        tracing/workqueue: fix 32 bits unfriendly 64 bits division

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue-2

---

>From 10c494ea1b75f96d5fca78178732d79e68129cc0 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 30 Apr 2009 16:07:59 +0200
Subject: [PATCH] tracing/workqueue: fix 32 bits unfriendly 64 bits division

To get the average of time consumed by each worklets, we do
a direct 64 bits division on wfstat->total_time. This is fine
on a 64 bits arch but not on a 32 one on which we can get the
following warning:

kernel/built-in.o: In function `workqueue_stat_show':
trace_workqueue.c:(.text+0x74f57): undefined reference to `__udivdi3'

We must use do_div() here to ensure the division is supported on
every archs.

[ Impact: fix a build error on 32 bits archs ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_workqueue.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index eafb4a5..c67be60 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -399,13 +399,22 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	} else {
 		/* It is effect node, need to print workfunc info */
 		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
+		unsigned long long avg_time;
+
+		if (wfstat->executed) {
+			avg_time = wfstat->total_time;
+			do_div(avg_time, wfstat->executed);
+			avg_time = ns2usecs(avg_time);
+		} else {
+			avg_time = 0;
+		}
+
 		seq_printf(s, "  %3d   %6d   %6u   %6llu   %6llu   %c-%pF\n",
 			cws->cpu,
 			wfstat->inserted,
 			wfstat->executed,
 			ns2usecs(wfstat->max_executed_time),
-			!wfstat->executed ? 0 :
-				ns2usecs(wfstat->total_time / wfstat->executed),
+			avg_time,
 			lastwf ? '`' : '|',
 			wfstat->func);
 	}
-- 
1.6.2.3


