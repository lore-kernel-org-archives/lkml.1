Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYKCACS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYKCACS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 19:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYKCACB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 19:02:01 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:51359 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbYKCACA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 19:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=sdi4a6SR6meV6DCzx1cApbpq45bFh4KuJ2rm/xGAYwf25SgNJec+wq0UL1eaPqSPeQ
         p8AY0wthCcBmcsH0WBpsW9h8Vm1BlQocNvh59MYOax5XvzXoKuUWvid8ZYHPglUH5FKB
         fpO8EiTpvAJ2GbFWAFigVGkE9LZcs0KLkbYH8=
Message-ID: <490E3F73.1000405@gmail.com>
Date: Mon, 03 Nov 2008 01:01:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: use raw spinlocks instead of spinlocks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I tried to figure out why my experimental function's return tracer was hanging, I discovered
that it was partially caused by the fact that the ring buffer might use the usual spinlocks during
entry insertion.

ring_buffer_lock_reserve() -> rb_reserve_next_event() -> __rb_reserve_next() -> spin_lock_irqsave()

Since this last function is traced, the result is a recursion during the trace. I guess it
happens too with the function tracer.

We should use the raw_spin_locks which are not traced.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ring_buffer.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cedf4e2..3e5a723 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -152,7 +152,7 @@ static inline int test_time_stamp(u64 delta)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
-	spinlock_t			lock;
+	raw_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		pages;
 	struct buffer_page		*head_page;	/* read from head */
@@ -289,7 +289,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	spin_lock_init(&cpu_buffer->lock);
+	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
 	page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
@@ -851,8 +851,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	/* See if we shot pass the end of this buffer page */
 	if (write > BUF_PAGE_SIZE) {
 		struct buffer_page *next_page = tail_page;
-
-		spin_lock_irqsave(&cpu_buffer->lock, flags);
+		raw_local_irq_save(flags);
+		__raw_spin_lock(&cpu_buffer->lock);
 
 		rb_inc_page(cpu_buffer, &next_page);
 
@@ -927,8 +927,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		    tail == rb_commit_index(cpu_buffer)) {
 			rb_set_commit_to_write(cpu_buffer);
 		}
-
-		spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+		__raw_spin_unlock(&cpu_buffer->lock);
+		raw_local_irq_restore(flags);
 
 		/* fail and let the caller try again */
 		return ERR_PTR(-EAGAIN);
@@ -951,7 +951,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
 	return NULL;
 }
 
@@ -1533,7 +1534,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
 
  again:
 	reader = cpu_buffer->reader_page;
@@ -1583,7 +1585,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	goto again;
 
  out:
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
 
 	return reader;
 }
@@ -1824,9 +1827,11 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
-	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
 	ring_buffer_iter_reset(iter);
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
 
 	return iter;
 }
@@ -1912,11 +1917,13 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return;
 
-	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
 }
 
 /**
