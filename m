Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZJHBUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZJHBUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZJHBUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:20:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZJHBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:20:03 -0400
Message-Id: <20091008011805.830524621@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 21:17:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] [PATCH 1/3] tracing: fix transposed numbers of lock_depth and preempt_count
References: <20091008011711.701283454@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-fix-transposed-numbers-of-lock_depth-and-pre.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The lock_depth and preempt_count numbers in the latency format is
transposed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cda766f..ed17565 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -486,16 +486,18 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 				hardirq ? 'h' : softirq ? 's' : '.'))
 		return 0;
 
-	if (entry->lock_depth < 0)
-		ret = trace_seq_putc(s, '.');
+	if (entry->preempt_count)
+		ret = trace_seq_printf(s, "%x", entry->preempt_count);
 	else
-		ret = trace_seq_printf(s, "%d", entry->lock_depth);
+		ret = trace_seq_putc(s, '.');
+
 	if (!ret)
 		return 0;
 
-	if (entry->preempt_count)
-		return trace_seq_printf(s, "%x", entry->preempt_count);
-	return trace_seq_putc(s, '.');
+	if (entry->lock_depth < 0)
+		return trace_seq_putc(s, '.');
+
+	return trace_seq_printf(s, "%d", entry->lock_depth);
 }
 
 static int
-- 
1.6.3.3


