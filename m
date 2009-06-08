Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZFHQSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZFHQSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZFHQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:18:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZFHQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:18:41 -0400
Subject: Re: [PATCH 0/5] [GIP PULL] tracing/events/trace_stack: various
 fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com>
References: <20090603151724.144915858@goodmis.org>
	 <20090605145219.GA14830@elte.hu> <20090607082257.GA16761@elte.hu>
	 <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Jun 2009 18:18:39 +0200
Message-Id: <1244477919.13761.9042.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 11:37 -0400, Steven Rostedt wrote:
> [ Added Peter ]
> 
> On Sun, 7 Jun 2009, Ingo Molnar wrote:
> > Testing tracer sched_switch: <6>Starting ring buffer hammer
> > PASSED
> > Testing tracer sysprof: PASSED
> > Testing tracer function: PASSED
> > Testing tracer irqsoff: 
> > =============================================
> > PASSED
> > Testing tracer preemptoff: PASSED
> > Testing tracer preemptirqsoff: [ INFO: possible recursive locking detected ]
> > PASSED
> > Testing tracer branch: 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
> > ---------------------------------------------
> > rb_consumer/431 is trying to acquire lock:
> >  (&cpu_buffer->reader_lock){......}, at: [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70
> > 
> > but task is already holding lock:
> >  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
> > 
> > other info that might help us debug this:
> > 1 lock held by rb_consumer/431:
> >  #0:  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
> 
> Yes this definitely looks like ftrace is tracing the ring buffer benchmark 
> test.
> 
> OK, how do I go about teaching lockdep that this reader lock is not the 
> same reader lock as the one being taken?

Something like this will put each ring-buffer user in its own lock
class.

Patch utterly uncompiled and broken since hotplug would need some care
(you could probably store the key pointer in the rb object and reuse it
on hotplug).

Almost-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/ring_buffer.h |    9 ++++++++-
 kernel/trace/ring_buffer.c  |    7 ++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e1ec431..a77a789 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -109,7 +109,14 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
  * size is in bytes for each per CPU buffer.
  */
 struct ring_buffer *
-ring_buffer_alloc(unsigned long size, unsigned flags);
+__ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key);
+
+#define ring_buffer_alloc(size, flags)			\
+do {							\
+	static struct lock_class_key __key;		\
+	__ring_buffer_alloc((size), (flags), &__key);	\
+} while (0)
+
 void ring_buffer_free(struct ring_buffer *buffer);
 
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index dd20b4d..fae0903 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -551,7 +551,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 }
 
 static struct ring_buffer_per_cpu *
-rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
+rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu, struct lock_clas_key *key)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
@@ -566,6 +566,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
 	spin_lock_init(&cpu_buffer->reader_lock);
+	lockdep_set_class(&cpu_buffer->reader_lock, key);
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
@@ -636,7 +637,7 @@ static int rb_cpu_notify(struct notifier_block *self,
  * when the buffer wraps. If this flag is not set, the buffer will
  * drop data when the tail hits the head.
  */
-struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
+struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key)
 {
 	struct ring_buffer *buffer;
 	int bsize;
@@ -685,7 +686,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 
 	for_each_buffer_cpu(buffer, cpu) {
 		buffer->buffers[cpu] =
-			rb_allocate_cpu_buffer(buffer, cpu);
+			rb_allocate_cpu_buffer(buffer, cpu, key);
 		if (!buffer->buffers[cpu])
 			goto fail_free_buffers;
 	}

