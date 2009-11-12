Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZKLEtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZKLEtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbZKLEtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:49:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37737 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbZKLEtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:49:32 -0500
Message-Id: <20091112044937.632312570@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 11 Nov 2009 23:41:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 1/2] [PATCH 1/2] ring-buffer: Add multiple iterations between benchmark timestamps
References: <20091112044142.741419929@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Add-multiple-iterations-between-benchmar.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_benchmark does a gettimeofday after every write to the
ring buffer in its measurements. This adds the overhead of the call
to gettimeofday to the measurements and does not give an accurate picture
of the length of time it takes to record a trace.

This was first noticed with perf top:

------------------------------------------------------------------------------
   PerfTop:     679 irqs/sec  kernel:99.9% [1000Hz cpu-clock-msecs],  (all, 4 CPUs)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

             1673.00 - 27.8% : trace_clock_local
              806.00 - 13.4% : do_gettimeofday
              590.00 -  9.8% : rb_reserve_next_event
              554.00 -  9.2% : native_read_tsc
              431.00 -  7.2% : ring_buffer_lock_reserve
              365.00 -  6.1% : __rb_reserve_next
              355.00 -  5.9% : rb_end_commit
              322.00 -  5.4% : getnstimeofday
              268.00 -  4.5% : ring_buffer_unlock_commit
              262.00 -  4.4% : ring_buffer_producer_thread 	[ring_buffer_benchmark]
              113.00 -  1.9% : read_tsc
               91.00 -  1.5% : debug_smp_processor_id
               69.00 -  1.1% : trace_recursive_unlock
               66.00 -  1.1% : ring_buffer_event_data
               25.00 -  0.4% : _spin_unlock_irq

And the length of each write to the ring buffer measured at 310ns.

This patch adds a new module parameter called "write_interval" which is
defaulted to 50. This is the number of writes performed between
timestamps. After this patch perf top shows:

------------------------------------------------------------------------------
   PerfTop:     244 irqs/sec  kernel:100.0% [1000Hz cpu-clock-msecs],  (all, 4 CPUs)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

             2842.00 - 40.4% : trace_clock_local
             1043.00 - 14.8% : rb_reserve_next_event
              784.00 - 11.1% : ring_buffer_lock_reserve
              600.00 -  8.5% : __rb_reserve_next
              579.00 -  8.2% : rb_end_commit
              440.00 -  6.3% : ring_buffer_unlock_commit
              290.00 -  4.1% : ring_buffer_producer_thread 	[ring_buffer_benchmark]
              155.00 -  2.2% : debug_smp_processor_id
              117.00 -  1.7% : trace_recursive_unlock
              103.00 -  1.5% : ring_buffer_event_data
               28.00 -  0.4% : do_gettimeofday
               22.00 -  0.3% : _spin_unlock_irq
               14.00 -  0.2% : native_read_tsc
               11.00 -  0.2% : getnstimeofday

do_gettimeofday dropped from 13% usage to a mere 0.4%! (using the default
50 interval)  The measurement for each timestamp went from 310ns to 210ns.
That's 100ns (1/3rd) overhead that the gettimeofday call was introducing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 573d3cc..70df73e 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -35,6 +35,10 @@ static int disable_reader;
 module_param(disable_reader, uint, 0644);
 MODULE_PARM_DESC(disable_reader, "only run producer");
 
+static int write_iteration = 50;
+module_param(write_iteration, uint, 0644);
+MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
+
 static int read_events;
 
 static int kill_test;
@@ -208,15 +212,18 @@ static void ring_buffer_producer(void)
 	do {
 		struct ring_buffer_event *event;
 		int *entry;
-
-		event = ring_buffer_lock_reserve(buffer, 10);
-		if (!event) {
-			missed++;
-		} else {
-			hit++;
-			entry = ring_buffer_event_data(event);
-			*entry = smp_processor_id();
-			ring_buffer_unlock_commit(buffer, event);
+		int i;
+
+		for (i = 0; i < write_iteration; i++) {
+			event = ring_buffer_lock_reserve(buffer, 10);
+			if (!event) {
+				missed++;
+			} else {
+				hit++;
+				entry = ring_buffer_event_data(event);
+				*entry = smp_processor_id();
+				ring_buffer_unlock_commit(buffer, event);
+			}
 		}
 		do_gettimeofday(&end_tv);
 
-- 
1.6.5


