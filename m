Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZCYJVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZCYJVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZCYJU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:20:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZCYJU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:20:59 -0400
Message-ID: <49C9F796.9040503@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 17:21:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] blktrace: fix the original blktrace
References: <49C9F700.9070609@cn.fujitsu.com>
In-Reply-To: <49C9F700.9070609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the original blktrace, which is using relay and is used via
ioctl, is broken. You can use ftrace to see the output of blktrace,
but user-space blktrace is unusable.

It's broken by "blktrace: add ftrace plugin"
(c71a896154119f4ca9e89d6078f5f63ad60ef199)

========
@@ -131,13 +162,14 @@ static void __blk_add_trace()
- 	if (unlikely(bt->trace_state != Blktrace_running))
+ 	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
 		return;
=========

With this patch, both ioctl and ftrace can be used, but of course you
can't use both of them at the same time.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 95f89fa..a7f7ff5 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -110,7 +110,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 	unsigned long flags;
 	char *buf;
 
-	if (blk_tr) {
+	if (blk_tracer_enabled) {
 		va_start(args, fmt);
 		ftrace_vprintk(fmt, args);
 		va_end(args);
@@ -169,7 +169,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	pid_t pid;
 	int cpu, pc = 0;
 
-	if (unlikely(bt->trace_state != Blktrace_running ||
+	if (unlikely(bt->trace_state != Blktrace_running &&
 		     !blk_tracer_enabled))
 		return;
 
@@ -185,7 +185,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		return;
 	cpu = raw_smp_processor_id();
 
-	if (blk_tr) {
+	if (blk_tracer_enabled) {
 		tracing_record_cmdline(current);
 
 		pc = preempt_count();
@@ -235,7 +235,7 @@ record_it:
 		if (pdu_len)
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
 
-		if (blk_tr) {
+		if (blk_tracer_enabled) {
 			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
 			return;
 		}
@@ -267,8 +267,7 @@ int blk_trace_remove(struct request_queue *q)
 	if (!bt)
 		return -EINVAL;
 
-	if (bt->trace_state == Blktrace_setup ||
-	    bt->trace_state == Blktrace_stopped)
+	if (bt->trace_state != Blktrace_running)
 		blk_trace_cleanup(bt);
 
 	return 0;
@@ -1273,7 +1272,6 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 	bt->dev = dev;
 	bt->act_mask = (u16)-1;
 	bt->end_lba = -1ULL;
-	bt->trace_state = Blktrace_running;
 
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt != NULL) {
-- 
1.5.4.rc3


