Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZC0INg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZC0INg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZC0IMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:12:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZC0IMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:12:45 -0400
Message-ID: <49CC8A92.3030307@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 16:13:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/7] blktrace: fix blk_probes_ref chaos
References: <49CC6691.7050103@cn.fujitsu.com> <49CC66DD.3060902@cn.fujitsu.com>
In-Reply-To: <49CC66DD.3060902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some changes that should have been in this patch, went into [PATCH 4/7]..

Something went wrong when I made those patches.. :(


========


ioctl-based blktrace allocates bt and registers tracepoints when
ioctl(BLKTRACESETUP), and do all cleanups when ioctl(BLKTRACETEARDOWN).

while ftrace-based blktrace allocates/frees bt when:
  # echo 1/0 > /sys/block/sda/sda1/trace/enable

and registers/unregisters tracepoints when:
  # echo blk/nop > /debugfs/tracing/current_tracer
or
  # echo 1/0 > /debugfs/tracing/tracing_enable

The separatation of allocation and registeration causes 2 problems:
  1. current user-space blktrace still calls ioctl(TEARDOWN) when
     ioctl(SETUP) failed:
       # echo 1 > /sys/block/sda/sda1/trace/enable
       # blktrace /dev/sda
         BLKTRACESETUP: Device or resource busy
         ^C
     and now blk_probes_ref == -1

  2. Another way to make blk_probes_ref == -1:
     # plugin sdb && mount sdb1
     # echo 1 > /sys/block/sdb/sdb1/trace/enable
     # remove sdb

This patch does the allocation and registeration when writing
sdaX/trace/enable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 5b28f0f..acf8454 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -478,7 +478,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		goto err;
 	}
 
-	if (atomic_add_return(1, &blk_probes_ref) == 1)
+	if (atomic_inc_return(&blk_probes_ref) == 1)
 		blk_register_tracepoints();
 
 	return 0;
@@ -1091,8 +1091,7 @@ static void blk_tracer_print_header(struct seq_file *m)
 
 static void blk_tracer_start(struct trace_array *tr)
 {
-	if (atomic_add_return(1, &blk_probes_ref) == 1)
-		blk_register_tracepoints();
+	blk_tracer_enabled = true;
 	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
@@ -1100,23 +1099,17 @@ static int blk_tracer_init(struct trace_array *tr)
 {
 	blk_tr = tr;
 	blk_tracer_start(tr);
-	blk_tracer_enabled = true;
 	return 0;
 }
 
 static void blk_tracer_stop(struct trace_array *tr)
 {
+	blk_tracer_enabled = false;
 	trace_flags |= TRACE_ITER_CONTEXT_INFO;
-	if (atomic_dec_and_test(&blk_probes_ref))
-		blk_unregister_tracepoints();
 }
 
 static void blk_tracer_reset(struct trace_array *tr)
 {
-	if (!atomic_read(&blk_probes_ref))
-		return;
-
-	blk_tracer_enabled = false;
 	blk_tracer_stop(tr);
 }
 
@@ -1254,6 +1247,9 @@ static int blk_trace_remove_queue(struct request_queue *q)
 	if (bt == NULL)
 		return -EINVAL;
 
+	if (atomic_dec_and_test(&blk_probes_ref))
+		blk_unregister_tracepoints();
+
 	kfree(bt);
 	return 0;
 }
@@ -1280,6 +1276,9 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 		return -EBUSY;
 	}
 
+	if (atomic_inc_return(&blk_probes_ref) == 1)
+		blk_register_tracepoints();
+
 	return 0;
 }
 
-- 
1.5.4.rc3


