Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZAKIfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZAKIfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZAKIfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:35:46 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:41638 "EHLO
	smarthost1.samage.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbZAKIfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:35:45 -0500
From: Indan Zupancic <indan@nul.nu>
To: srostedt@redhat.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Indan Zupancic <indan@nul.nu>
Subject: [PATCH] Minor cleanups in ring_buffer.c
Date: Sun, 11 Jan 2009 19:35:28 +1100
Message-Id: <1231662928-19740-1-git-send-email-indan@nul.nu>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1231168176.15476.6.camel@localhost.localdomain>
References: <1231168176.15476.6.camel@localhost.localdomain>
X-Spam-Score: 0.1
X-Scan-Signature: 27c1264e312f7e45ec0349526d776c80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Indan Zupancic <indan@nul.nu>
---
 kernel/trace/ring_buffer.c |   37 +++++++++++++------------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4832ffa..11560b3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1849,7 +1849,7 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 }
 
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+rb_get_event(struct ring_buffer *buffer, int cpu, u64 *ts, int consume)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
@@ -1900,6 +1900,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 			*ts = cpu_buffer->read_stamp + event->time_delta;
 			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
 		}
+		if (consume)
+			rb_advance_reader(cpu_buffer);
 		return event;
 
 	default:
@@ -1908,10 +1910,9 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(ring_buffer_peek);
 
 static struct ring_buffer_event *
-rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+rb_iter_get(struct ring_buffer_iter *iter, u64 *ts, int consume)
 {
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -1961,6 +1962,8 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 			*ts = iter->read_stamp + event->time_delta;
 			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
 		}
+		if (consume)
+			rb_advance_iter(iter);
 		return event;
 
 	default:
@@ -1988,11 +1991,12 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_get_event(buffer, cpu, ts, 0);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_peek);
 
 /**
  * ring_buffer_iter_peek - peek at the next event to be read
@@ -2010,7 +2014,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-	event = rb_iter_peek(iter, ts);
+	event = rb_iter_peek(iter, ts, 0);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
@@ -2031,18 +2035,8 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_event *event;
 	unsigned long flags;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return NULL;
-
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-
-	event = rb_buffer_peek(buffer, cpu, ts);
-	if (!event)
-		goto out;
-
-	rb_advance_reader(cpu_buffer);
-
- out:
+	event = rb_get_event(buffer, cpu, ts, 1);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
@@ -2124,12 +2118,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-	event = rb_iter_peek(iter, ts);
-	if (!event)
-		goto out;
-
-	rb_advance_iter(iter);
- out:
+	event = rb_iter_peek(iter, ts, 1);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
@@ -2404,10 +2393,10 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	/*
-	 * rb_buffer_peek will get the next ring buffer if
+	 * rb_get_event will get the next ring buffer if
 	 * the current reader page is empty.
 	 */
-	event = rb_buffer_peek(buffer, cpu, NULL);
+	event = rb_get_event(buffer, cpu, NULL, 0);
 	if (!event)
 		goto out;
 
-- 
1.6.1

