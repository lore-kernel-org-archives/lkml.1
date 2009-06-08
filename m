Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbZFHXBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbZFHXBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZFHXA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZFHXA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:00:57 -0400
Date: Mon, 8 Jun 2009 19:00:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH][GIT PULL] ring-buffer: pass in lockdep class key for
 reader_lock
In-Reply-To: <1244477919.13761.9042.camel@twins>
Message-ID: <alpine.DEB.2.00.0906081858580.9522@gandalf.stny.rr.com>
References: <20090603151724.144915858@goodmis.org>  <20090605145219.GA14830@elte.hu> <20090607082257.GA16761@elte.hu>  <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com> <1244477919.13761.9042.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Peter Zijlstra (1):
      ring-buffer: pass in lockdep class key for reader_lock

----
 include/linux/ring_buffer.h |   14 +++++++++++++-
 kernel/trace/ring_buffer.c  |    9 +++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)
---------------------------
commit 1f8a6a10fb9437eac3f516ea4324a19087872f30
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Jun 8 18:18:39 2009 +0200

    ring-buffer: pass in lockdep class key for reader_lock
    
    On Sun, 7 Jun 2009, Ingo Molnar wrote:
    > Testing tracer sched_switch: <6>Starting ring buffer hammer
    > PASSED
    > Testing tracer sysprof: PASSED
    > Testing tracer function: PASSED
    > Testing tracer irqsoff:
    > =============================================
    > PASSED
    > Testing tracer preemptoff: PASSED
    > Testing tracer preemptirqsoff: [ INFO: possible recursive locking detected ]
    > PASSED
    > Testing tracer branch: 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
    > ---------------------------------------------
    > rb_consumer/431 is trying to acquire lock:
    >  (&cpu_buffer->reader_lock){......}, at: [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70
    >
    > but task is already holding lock:
    >  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
    >
    > other info that might help us debug this:
    > 1 lock held by rb_consumer/431:
    >  #0:  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
    
    The ring buffer is a generic structure, and can be used outside of
    ftrace. If ftrace traces within the use of the ring buffer, it can produce
    false positives with lockdep.
    
    This patch passes in a static lock key into the allocation of the ring
    buffer, so that different ring buffers will have their own lock class.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <1244477919.13761.9042.camel@twins>
    
    [ store key in ring buffer descriptor ]
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index f134582..8670f15 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -105,7 +105,19 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
  * size is in bytes for each per CPU buffer.
  */
 struct ring_buffer *
-ring_buffer_alloc(unsigned long size, unsigned flags);
+__ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key);
+
+/*
+ * Because the ring buffer is generic, if other users of the ring buffer get
+ * traced by ftrace, it can produce lockdep warnings. We need to keep each
+ * ring buffer's lock class separate.
+ */
+#define ring_buffer_alloc(size, flags)			\
+({							\
+	static struct lock_class_key __key;		\
+	__ring_buffer_alloc((size), (flags), &__key);	\
+})
+
 void ring_buffer_free(struct ring_buffer *buffer);
 
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7102d7a..22878b0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -426,6 +426,8 @@ struct ring_buffer {
 	atomic_t			record_disabled;
 	cpumask_var_t			cpumask;
 
+	struct lock_class_key		*reader_lock_key;
+
 	struct mutex			mutex;
 
 	struct ring_buffer_per_cpu	**buffers;
@@ -565,6 +567,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
 	spin_lock_init(&cpu_buffer->reader_lock);
+	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
@@ -635,7 +638,8 @@ static int rb_cpu_notify(struct notifier_block *self,
  * when the buffer wraps. If this flag is not set, the buffer will
  * drop data when the tail hits the head.
  */
-struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
+struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
+					struct lock_class_key *key)
 {
 	struct ring_buffer *buffer;
 	int bsize;
@@ -658,6 +662,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
+	buffer->reader_lock_key = key;
 
 	/* need at least two pages */
 	if (buffer->pages == 1)
@@ -715,7 +720,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	kfree(buffer);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(ring_buffer_alloc);
+EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
 
 /**
  * ring_buffer_free - free a ring buffer.


