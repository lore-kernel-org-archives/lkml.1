Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZEHEfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZEHEfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZEHEdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:33:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61340 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbZEHEdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:33:31 -0400
Message-Id: <20090508043331.301908320@goodmis.org>
References: <20090508043250.372421144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 00:32:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] ring-buffer: only periodically call cond_resched to ring-buffer-benchmark
Content-Disposition: inline; filename=0002-ring-buffer-only-periodically-call-cond_resched-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Calling cond_resched at every iteration of the loop adds a bit of
overhead to the benchmark.

This patch does two things.

1) only calls cond-resched when CONFIG_PREEMPT is not enabled
2) only calls cond-resched after so many traces has been performed.

[ Impact: less overhead to the ring-buffer-benchmark ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index f4ceb45..a7c048b 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -218,16 +218,23 @@ static void ring_buffer_producer(void)
 		}
 		do_gettimeofday(&end_tv);
 
-		if (consumer && !(++cnt % wakeup_interval))
+		cnt++;
+		if (consumer && !(cnt % wakeup_interval))
 			wake_up_process(consumer);
 
+#ifndef CONFIG_PREEMPT
 		/*
 		 * If we are a non preempt kernel, the 10 second run will
 		 * stop everything while it runs. Instead, we will call
 		 * cond_resched and also add any time that was lost by a
 		 * rescedule.
+		 *
+		 * Do a cond resched at the same frequency we would wake up
+		 * the reader.
 		 */
-		cond_resched();
+		if (cnt % wakeup_interval)
+			cond_resched();
+#endif
 
 	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
 	pr_info("End ring buffer hammer\n");
-- 
1.6.2.4

-- 
