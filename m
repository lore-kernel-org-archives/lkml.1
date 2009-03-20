Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbZCTK3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbZCTK3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762492AbZCTK0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:26:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:35299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762474AbZCTK0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:26:48 -0400
Date: Fri, 20 Mar 2009 10:26:09 GMT
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
In-Reply-To: <49C2F5EA.8060606@cn.fujitsu.com>
References: <49C2F5EA.8060606@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: remove blk_probe_mutex
Message-ID: <tip-a2df44c805026d40fae556b04f9addbce486bbe2@git.kernel.org>
Git-Commit-ID: a2df44c805026d40fae556b04f9addbce486bbe2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:26:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2df44c805026d40fae556b04f9addbce486bbe2
Gitweb:     http://git.kernel.org/tip/a2df44c805026d40fae556b04f9addbce486bbe2
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 09:48:26 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:20:05 +0100

blktrace: remove blk_probe_mutex

blk_register_tracepoints() always returns 0, so make it return void,
thus we don't need to use blk_probe_mutex to protect blk_probes_ref.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C2F5EA.8060606@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   27 +++++----------------------
 1 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 73845b7..223b92e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -47,10 +47,9 @@ static struct tracer_flags blk_tracer_flags = {
 };
 
 /* Global reference count of probes */
-static DEFINE_MUTEX(blk_probe_mutex);
 static atomic_t blk_probes_ref = ATOMIC_INIT(0);
 
-static int blk_register_tracepoints(void);
+static void blk_register_tracepoints(void);
 static void blk_unregister_tracepoints(void);
 
 /*
@@ -256,10 +255,8 @@ static void blk_trace_cleanup(struct blk_trace *bt)
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
-	mutex_lock(&blk_probe_mutex);
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
-	mutex_unlock(&blk_probe_mutex);
 }
 
 int blk_trace_remove(struct request_queue *q)
@@ -471,13 +468,8 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
-	mutex_lock(&blk_probe_mutex);
-	if (atomic_add_return(1, &blk_probes_ref) == 1) {
-		ret = blk_register_tracepoints();
-		if (ret)
-			goto probe_err;
-	}
-	mutex_unlock(&blk_probe_mutex);
+	if (atomic_add_return(1, &blk_probes_ref) == 1)
+		blk_register_tracepoints();
 
 	ret = -EBUSY;
 	old_bt = xchg(&q->blk_trace, bt);
@@ -487,9 +479,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	}
 
 	return 0;
-probe_err:
-	atomic_dec(&blk_probes_ref);
-	mutex_unlock(&blk_probe_mutex);
 err:
 	if (bt) {
 		if (bt->msg_file)
@@ -863,7 +852,7 @@ void blk_add_driver_data(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
-static int blk_register_tracepoints(void)
+static void blk_register_tracepoints(void)
 {
 	int ret;
 
@@ -901,7 +890,6 @@ static int blk_register_tracepoints(void)
 	WARN_ON(ret);
 	ret = register_trace_block_remap(blk_add_trace_remap);
 	WARN_ON(ret);
-	return 0;
 }
 
 static void blk_unregister_tracepoints(void)
@@ -1099,11 +1087,8 @@ static void blk_tracer_print_header(struct seq_file *m)
 
 static void blk_tracer_start(struct trace_array *tr)
 {
-	mutex_lock(&blk_probe_mutex);
 	if (atomic_add_return(1, &blk_probes_ref) == 1)
-		if (blk_register_tracepoints())
-			atomic_dec(&blk_probes_ref);
-	mutex_unlock(&blk_probe_mutex);
+		blk_register_tracepoints();
 	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
@@ -1118,10 +1103,8 @@ static int blk_tracer_init(struct trace_array *tr)
 static void blk_tracer_stop(struct trace_array *tr)
 {
 	trace_flags |= TRACE_ITER_CONTEXT_INFO;
-	mutex_lock(&blk_probe_mutex);
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
-	mutex_unlock(&blk_probe_mutex);
 }
 
 static void blk_tracer_reset(struct trace_array *tr)
