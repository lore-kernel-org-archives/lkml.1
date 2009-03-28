Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbZC1V3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbZC1V3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZC1V2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:28:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:53442 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZC1V2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:28:49 -0400
Date: Sat, 28 Mar 2009 21:28:04 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49CC37D9.6030201@cn.fujitsu.com>
References: <49CC37D9.6030201@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix blk_probes_ref chaos
Message-ID: <tip-2311b67256cb376cdbb541c781b95397f6896911@git.kernel.org>
Git-Commit-ID: 2311b67256cb376cdbb541c781b95397f6896911
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 28 Mar 2009 21:28:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2311b67256cb376cdbb541c781b95397f6896911
Gitweb:     http://git.kernel.org/tip/2311b67256cb376cdbb541c781b95397f6896911
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 10:20:09 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Mar 2009 12:51:41 +0100

blktrace: fix blk_probes_ref chaos

Impact: fix mixed ioctl and ftrace-plugin blktrace use refcount bugs

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
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49CC37D9.6030201@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 5b28f0f..8d6bd12 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -478,7 +478,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		goto err;
 	}
 
-	if (atomic_add_return(1, &blk_probes_ref) == 1)
+	if (atomic_inc_return(&blk_probes_ref) == 1)
 		blk_register_tracepoints();
 
 	return 0;
@@ -1091,8 +1091,6 @@ static void blk_tracer_print_header(struct seq_file *m)
 
 static void blk_tracer_start(struct trace_array *tr)
 {
-	if (atomic_add_return(1, &blk_probes_ref) == 1)
-		blk_register_tracepoints();
 	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
@@ -1107,15 +1105,10 @@ static int blk_tracer_init(struct trace_array *tr)
 static void blk_tracer_stop(struct trace_array *tr)
 {
 	trace_flags |= TRACE_ITER_CONTEXT_INFO;
-	if (atomic_dec_and_test(&blk_probes_ref))
-		blk_unregister_tracepoints();
 }
 
 static void blk_tracer_reset(struct trace_array *tr)
 {
-	if (!atomic_read(&blk_probes_ref))
-		return;
-
 	blk_tracer_enabled = false;
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
 
