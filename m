Return-Path: <linux-kernel-owner+w=401wt.eu-S934484AbZLKEvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbZLKEvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760688AbZLKEvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:51:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbZLKEue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:50:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=l-YuuxB_ykIA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hlFY-uCeWgtk3xFhYXYA:9 a=4C9ePJDJVfqB0dpwzhoA:7 a=8EPRr_yyIyzlo364h6Vt5eHzN3YA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091211045039.718852320@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Dec 2009 23:50:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] [PATCH 1/2] ring-buffer: Use sync sched protection on ring buffer resizing
References: <20091211045003.107725797@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Use-sync-sched-protection-on-ring-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There was a comment in the ring buffer code that says the calling
layers should prevent tracing or reading of the ring buffer while
resizing. I have discovered that the tracers do not honor this
arrangement.

This patch moves the disabling and synchronizing the ring buffer to
a higher layer during resizing. This guarantees that no writes
are occurring while the resize takes place.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a1ca495..0d64c51 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1193,9 +1193,6 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	struct list_head *p;
 	unsigned i;
 
-	atomic_inc(&cpu_buffer->record_disabled);
-	synchronize_sched();
-
 	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
@@ -1214,9 +1211,6 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
-
-	atomic_dec(&cpu_buffer->record_disabled);
-
 }
 
 static void
@@ -1227,9 +1221,6 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct list_head *p;
 	unsigned i;
 
-	atomic_inc(&cpu_buffer->record_disabled);
-	synchronize_sched();
-
 	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
@@ -1245,8 +1236,6 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
-
-	atomic_dec(&cpu_buffer->record_disabled);
 }
 
 /**
@@ -1254,11 +1243,6 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
  * @buffer: the buffer to resize.
  * @size: the new size.
  *
- * The tracer is responsible for making sure that the buffer is
- * not being used while changing the size.
- * Note: We may be able to change the above requirement by using
- *  RCU synchronizations.
- *
  * Minimum size is 2 * BUF_PAGE_SIZE.
  *
  * Returns -1 on failure.
@@ -1290,6 +1274,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	if (size == buffer_size)
 		return size;
 
+	atomic_inc(&buffer->record_disabled);
+
+	/* Make sure all writers are done with this buffer. */
+	synchronize_sched();
+
 	mutex_lock(&buffer->mutex);
 	get_online_cpus();
 
@@ -1352,6 +1341,8 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 
+	atomic_dec(&buffer->record_disabled);
+
 	return size;
 
  free_pages:
@@ -1361,6 +1352,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	}
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
+	atomic_dec(&buffer->record_disabled);
 	return -ENOMEM;
 
 	/*
@@ -1370,6 +1362,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
  out_fail:
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
+	atomic_dec(&buffer->record_disabled);
 	return -1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
-- 
1.6.5


