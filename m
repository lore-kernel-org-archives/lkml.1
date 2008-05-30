Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbYE3ED4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbYE3ED4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYE3EAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56577 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbYE3EAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:17 -0400
Message-Id: <20080530040013.467433344@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:30 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 10/41] cpu alloc: blktrace conversion
Content-Disposition: inline; filename=cpu_alloc_blktrace_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert blktrace percpu handling to cpu_alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 block/blktrace.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

Index: linux-2.6/block/blktrace.c
===================================================================
--- linux-2.6.orig/block/blktrace.c	2008-05-28 18:45:08.580239875 -0700
+++ linux-2.6/block/blktrace.c	2008-05-29 00:02:19.570236238 -0700
@@ -82,7 +82,7 @@ void __trace_note_message(struct blk_tra
 	char *buf;
 
 	preempt_disable();
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf = THIS_CPU(bt->msg_data);
 	va_start(args, fmt);
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
@@ -138,9 +138,7 @@ void __blk_add_trace(struct blk_trace *b
 	struct task_struct *tsk = current;
 	struct blk_io_trace *t;
 	unsigned long flags;
-	unsigned long *sequence;
 	pid_t pid;
-	int cpu;
 
 	if (unlikely(bt->trace_state != Blktrace_running))
 		return;
@@ -170,18 +168,16 @@ void __blk_add_trace(struct blk_trace *b
 
 	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
 	if (t) {
-		cpu = smp_processor_id();
-		sequence = per_cpu_ptr(bt->sequence, cpu);
-
+		__CPU_INC(bt->sequence);
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
-		t->sequence = ++(*sequence);
+		t->sequence = __CPU_READ(bt->sequence);
 		t->time = ktime_to_ns(ktime_get());
 		t->sector = sector;
 		t->bytes = bytes;
 		t->action = what;
 		t->pid = pid;
 		t->device = bt->dev;
-		t->cpu = cpu;
+		t->cpu = smp_processor_id();
 		t->error = error;
 		t->pdu_len = pdu_len;
 
@@ -248,8 +244,8 @@ static void blk_trace_cleanup(struct blk
 	relay_close(bt->rchan);
 	debugfs_remove(bt->dropped_file);
 	blk_remove_tree(bt->dir);
-	free_percpu(bt->sequence);
-	free_percpu(bt->msg_data);
+	CPU_FREE(bt->sequence);
+	CPU_FREE(bt->msg_data);
 	kfree(bt);
 }
 
@@ -360,11 +356,11 @@ int do_blk_trace_setup(struct request_qu
 	if (!bt)
 		goto err;
 
-	bt->sequence = alloc_percpu(unsigned long);
+	bt->sequence = CPU_ALLOC(unsigned long, GFP_KERNEL | __GFP_ZERO);
 	if (!bt->sequence)
 		goto err;
 
-	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG);
+	bt->msg_data = cpu_alloc(BLK_TN_MAX_MSG, GFP_KERNEL | __GFP_ZERO, 0);
 	if (!bt->msg_data)
 		goto err;
 
@@ -413,8 +409,8 @@ err:
 	if (bt) {
 		if (bt->dropped_file)
 			debugfs_remove(bt->dropped_file);
-		free_percpu(bt->sequence);
-		free_percpu(bt->msg_data);
+		CPU_FREE(bt->sequence);
+		CPU_FREE(bt->msg_data);
 		if (bt->rchan)
 			relay_close(bt->rchan);
 		kfree(bt);

-- 
