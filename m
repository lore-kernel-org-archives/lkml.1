Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZC1VdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZC1VdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbZC1Vai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:30:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761104AbZC1Vag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:30:36 -0400
Date: Sat, 28 Mar 2009 21:28:14 GMT
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
In-Reply-To: <49CC37E8.6070609@cn.fujitsu.com>
References: <49CC37E8.6070609@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix memory leak when freeing struct blk_io_trace
Message-ID: <tip-3cf224e4aa4a1f24361bce35b3bb54f553bee069@git.kernel.org>
Git-Commit-ID: 3cf224e4aa4a1f24361bce35b3bb54f553bee069
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 28 Mar 2009 21:28:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cf224e4aa4a1f24361bce35b3bb54f553bee069
Gitweb:     http://git.kernel.org/tip/3cf224e4aa4a1f24361bce35b3bb54f553bee069
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 10:20:24 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Mar 2009 12:51:41 +0100

blktrace: fix memory leak when freeing struct blk_io_trace

Impact: fix mixed ioctl and ftrace-plugin blktrace use memory leak

When mixing the use of ioctl-based blktrace and ftrace-based blktrace,
we can leak memory in this way:

  # btrace /dev/sda > /dev/null &
  # echo 0 > /sys/block/sda/sda1/trace/enable

now we leak bt->dropped_file, bt->msg_file, bt->rchan...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49CC37E8.6070609@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8d6bd12..2f21d77 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -247,7 +247,7 @@ record_it:
 static struct dentry *blk_tree_root;
 static DEFINE_MUTEX(blk_tree_mutex);
 
-static void blk_trace_cleanup(struct blk_trace *bt)
+static void blk_trace_free(struct blk_trace *bt)
 {
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
@@ -255,6 +255,11 @@ static void blk_trace_cleanup(struct blk_trace *bt)
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
+}
+
+static void blk_trace_cleanup(struct blk_trace *bt)
+{
+	blk_trace_free(bt);
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
 }
@@ -410,11 +415,11 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		if (buts->name[i] == '/')
 			buts->name[i] = '_';
 
-	ret = -ENOMEM;
 	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
 	if (!bt)
-		goto err;
+		return -ENOMEM;
 
+	ret = -ENOMEM;
 	bt->sequence = alloc_percpu(unsigned long);
 	if (!bt->sequence)
 		goto err;
@@ -483,17 +488,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	return 0;
 err:
-	if (bt) {
-		if (bt->msg_file)
-			debugfs_remove(bt->msg_file);
-		if (bt->dropped_file)
-			debugfs_remove(bt->dropped_file);
-		free_percpu(bt->sequence);
-		free_percpu(bt->msg_data);
-		if (bt->rchan)
-			relay_close(bt->rchan);
-		kfree(bt);
-	}
+	blk_trace_free(bt);
 	return ret;
 }
 
@@ -1091,6 +1086,7 @@ static void blk_tracer_print_header(struct seq_file *m)
 
 static void blk_tracer_start(struct trace_array *tr)
 {
+	blk_tracer_enabled = true;
 	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
@@ -1098,18 +1094,17 @@ static int blk_tracer_init(struct trace_array *tr)
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
 }
 
 static void blk_tracer_reset(struct trace_array *tr)
 {
-	blk_tracer_enabled = false;
 	blk_tracer_stop(tr);
 }
 
@@ -1250,7 +1245,7 @@ static int blk_trace_remove_queue(struct request_queue *q)
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
 
-	kfree(bt);
+	blk_trace_free(bt);
 	return 0;
 }
 
