Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbYEVEZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbYEVEZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYEVEXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:23:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYEVEXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:23:05 -0400
Message-Id: <20080522042302.242307072@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:22:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: remove printks from irqsoff trace
Content-Disposition: inline; filename=ftrace-dont-printk-on-max.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing out new max latencies was fine for the old RT tracer. But for
mainline it is a bit messy. We also need to test if the run queue
is locked before we can do the print. This means that we may not be
printing out latencies if the run queue is locked on another CPU.
This produces inconsistencies in the output.

This patch simply removes the print altogether.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c |   16 ----------------
 1 file changed, 16 deletions(-)

Index: linux-tip.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_irqsoff.c	2008-05-21 20:22:27.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_irqsoff.c	2008-05-22 00:11:10.000000000 -0400
@@ -165,22 +165,6 @@ check_critical_timing(struct trace_array
 
 	update_max_tr_single(tr, current, cpu);
 
-	if (!runqueue_is_locked()) {
-		if (tracing_thresh) {
-			printk(KERN_INFO "(%16s-%-5d|#%d): %lu us critical"
-			       " section violates %lu us threshold.\n",
-			       current->comm, current->pid,
-			       raw_smp_processor_id(),
-			       latency, nsecs_to_usecs(tracing_thresh));
-		} else {
-			printk(KERN_INFO "(%16s-%-5d|#%d): new %lu us"
-			       " maximum-latency critical section.\n",
-			       current->comm, current->pid,
-			       raw_smp_processor_id(),
-			       latency);
-		}
-	}
-
 	max_sequence++;
 
 out_unlock:

-- 
