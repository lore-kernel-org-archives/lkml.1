Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZC0ING@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZC0ING (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZC0IMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:12:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63011 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZC0IMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:12:45 -0400
Message-ID: <49CC8A9A.6050101@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 16:13:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/7] blktrace: fix memory leak when freeing struct blk_io_trace
References: <49CC6691.7050103@cn.fujitsu.com> <49CC66EA.4000703@cn.fujitsu.com>
In-Reply-To: <49CC66EA.4000703@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static void blk_tracer_start(struct trace_array *tr)
>  {
> +	blk_tracer_enabled = true;
>  	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
>  }
...
>  static void blk_tracer_reset(struct trace_array *tr)
>  {
> -	blk_tracer_enabled = false;
>  	blk_tracer_stop(tr);
>  }

Those changes should have been in [PATCH 3/7]..


==========


[PATCH] blktrace: fix memory leak when freeing struct blk_io_trace

When mixing the use of ioctl-based blktrace and ftrace-based blktrace,
we can leak memory in this way:
  # btrace /dev/sda > /dev/null &
  # echo 0 > /sys/block/sda/sda1/trace/enable
now we leak bt->dropped_file, bt->msg_file, bt->rchan...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index acf8454..2f21d77 100644
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
 
@@ -1250,7 +1245,7 @@ static int blk_trace_remove_queue(struct request_queue *q)
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
 
-	kfree(bt);
+	blk_trace_free(bt);
 	return 0;
 }
 
-- 
1.5.4.rc3


