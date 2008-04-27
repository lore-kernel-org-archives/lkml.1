Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbYD0Thf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbYD0Thf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763294AbYD0ThR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:37:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:53723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764095AbYD0ThO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=eSaROuFNCAg2FehzsiZ5riGr7djryxlEUrA3OU0eQTbWqkbpa3ARCDyO6J1d6DW1O2/7WYn7vXEEa/kTq4QeHO19IqMaFLLSV82ycaxp4jiijgf7gQDif7AXkB4qiVKU0FuRDamFAvZWjMinLYU9r0NB8agWxp5z7YocvpUuThM=
Date: Sun, 27 Apr 2008 22:37:08 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/5] mmiotrace: print overrun counts
Message-ID: <20080427223708.2137ba95@daedalus.pq.iki.fi>
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d5c3a38d48e223bcf192f48a8b202fdffa616390 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 27 Apr 2008 00:00:33 +0300
Subject: [PATCH] mmiotrace: print overrun counts

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/trace/trace_mmiotrace.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 6d2edbd..d0f649a 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -17,11 +17,13 @@ struct header_iter {
 };
 
 static struct trace_array *mmio_trace_array;
+static bool overrun_detected;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
 	int cpu;
 
+	overrun_detected = false;
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
@@ -124,12 +126,34 @@ static void mmio_close(struct trace_iterator *iter)
 	iter->private = NULL;
 }
 
+static unsigned long count_overruns(struct trace_iterator *iter)
+{
+	int cpu;
+	unsigned long cnt = 0;
+	for_each_online_cpu(cpu) {
+		cnt += iter->overrun[cpu];
+		iter->overrun[cpu] = 0;
+	}
+	return cnt;
+}
+
 static ssize_t mmio_read(struct trace_iterator *iter, struct file *filp,
 				char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	ssize_t ret;
 	struct header_iter *hiter = iter->private;
 	struct trace_seq *s = &iter->seq;
+	unsigned long n;
+
+	n = count_overruns(iter);
+	if (n) {
+		/* XXX: This is later than where events were lost. */
+		trace_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);
+		if (!overrun_detected)
+			pr_warning("mmiotrace has lost events.\n");
+		overrun_detected = true;
+		goto print_out;
+	}
 
 	if (!hiter)
 		return 0;
@@ -142,6 +166,7 @@ static ssize_t mmio_read(struct trace_iterator *iter, struct file *filp,
 		iter->private = NULL;
 	}
 
+print_out:
 	ret = trace_seq_to_user(s, ubuf, cnt);
 	return (ret == -EBUSY) ? 0 : ret;
 }
-- 
1.5.3.7

