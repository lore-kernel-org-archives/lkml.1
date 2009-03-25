Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZCYCto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZCYCto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZCYCtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:49:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbZCYCtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:49:32 -0400
Message-ID: <49C99BD2.9090503@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 10:49:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [RFC][PATCH] blktrace: fix original blktrace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering what we are going to do with the original blktrace which
is using relay and is used via ioctl.

The problem is currently it's totally broken. You can use ftrace to see
the output of blktrace, but user-space blktrace is unusable.

With this patch, both ioctl and ftrace can be used, but of course you
can't use both of them at the same time.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6fb274f..d8dc48b 100644
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
@@ -1269,7 +1269,6 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 	bt->dev = dev;
 	bt->act_mask = (u16)-1;
 	bt->end_lba = -1ULL;
-	bt->trace_state = Blktrace_running;
 
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt != NULL) {
-- 
1.5.4.rc3

