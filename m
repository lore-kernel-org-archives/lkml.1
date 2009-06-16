Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbZFPRxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbZFPRxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZFPRxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:53:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZFPRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:53:22 -0400
Message-Id: <20090616175323.176206738@goodmis.org>
References: <20090616175133.317996432@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 16 Jun 2009 13:51:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] ring-buffer: have benchmark test handle discarded events
Content-Disposition: inline; filename=0001-ring-buffer-have-benchmark-test-handle-discarded-eve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the addition of commit:

  c7b0930857e2278f2e7714db6294e94c57f623b0
  ring-buffer: prevent adding write in discarded area

The ring buffer may now add discarded events when a write passes
the end of a buffer page. Before, a discarded event was only added
when the tracer deliberately created one. The ring buffer benchmark
test does not handle discarded events when it reads the buffer and
fails when it encounters one.

Also fix the increment for large data entries (luckily, the test did
not add any yet).

[ Impact: fix false failure of ring buffer self test ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 8d68e14..cf6b0f5 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -102,8 +102,10 @@ static enum event_status read_page(int cpu)
 			event = (void *)&rpage->data[i];
 			switch (event->type_len) {
 			case RINGBUF_TYPE_PADDING:
-				/* We don't expect any padding */
-				KILL_TEST();
+				/* failed writes may be discarded events */
+				if (!event->time_delta)
+					KILL_TEST();
+				inc = event->array[0] + 4;
 				break;
 			case RINGBUF_TYPE_TIME_EXTEND:
 				inc = 8;
@@ -119,7 +121,7 @@ static enum event_status read_page(int cpu)
 					KILL_TEST();
 					break;
 				}
-				inc = event->array[0];
+				inc = event->array[0] + 4;
 				break;
 			default:
 				entry = ring_buffer_event_data(event);
-- 
1.6.3.1

-- 
