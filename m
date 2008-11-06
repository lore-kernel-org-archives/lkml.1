Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYKFFbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYKFFbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYKFFb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:31:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYKFFb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:31:28 -0500
Message-Id: <20081106053126.344817817@goodmis.org>
References: <20081106053029.595679750@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 06 Nov 2008 00:30:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/1] ring-buffer: convert to raw spinlocks
Content-Disposition: inline; filename=0001-ring-buffer-convert-to-raw-spinlocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: no lockdep debugging of ring buffer

The problem with running lockdep on the ring buffer is that the
ring buffer is the core infrastructure of ftrace. What happens is
that the tracer will start tracing the lockdep code while lockdep
is testing the ring buffers locks.  This can cause lockdep to
fail due to testing cases that have not fully finished their
locking transition.

This patch converts the spin locks used by the ring buffer back
into raw spin locks which lockdep does not check.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a84a187..6781e9a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -154,7 +154,7 @@ static inline int test_time_stamp(u64 delta)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
-	spinlock_t			lock;
+	raw_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		pages;
 	struct buffer_page		*head_page;	/* read from head */
@@ -291,7 +291,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	spin_lock_init(&cpu_buffer->lock);
+	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
 	page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
@@ -854,7 +854,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	if (write > BUF_PAGE_SIZE) {
 		struct buffer_page *next_page = tail_page;
 
-		spin_lock_irqsave(&cpu_buffer->lock, flags);
+		local_irq_save(flags);
+		__raw_spin_lock(&cpu_buffer->lock);
 
 		rb_inc_page(cpu_buffer, &next_page);
 
@@ -930,7 +931,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 			rb_set_commit_to_write(cpu_buffer);
 		}
 
-		spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+		__raw_spin_unlock(&cpu_buffer->lock);
+		local_irq_restore(flags);
 
 		/* fail and let the caller try again */
 		return ERR_PTR(-EAGAIN);
@@ -953,7 +955,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
 	return NULL;
 }
 
@@ -1540,7 +1543,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	unsigned long flags;
 	int nr_loops = 0;
 
-	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
 
  again:
 	/*
@@ -1602,7 +1606,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	goto again;
 
  out:
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
 
 	return reader;
 }
@@ -1871,9 +1876,11 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
-	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
 	ring_buffer_iter_reset(iter);
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
 
 	return iter;
 }
@@ -1959,11 +1966,13 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return;
 
-	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
-	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
 }
 
 /**
-- 
1.5.6.5

-- 
