Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZFIOxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZFIOxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZFIOw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:52:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:43885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFIOw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:52:57 -0400
Date: Tue, 9 Jun 2009 14:52:02 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1244477919.13761.9042.camel@twins>
References: <1244477919.13761.9042.camel@twins>
Subject: [tip:tracing/core] ring-buffer: pass in lockdep class key for reader_lock
Message-ID: <tip-1f8a6a10fb9437eac3f516ea4324a19087872f30@git.kernel.org>
Git-Commit-ID: 1f8a6a10fb9437eac3f516ea4324a19087872f30
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 09 Jun 2009 14:52:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f8a6a10fb9437eac3f516ea4324a19087872f30
Gitweb:     http://git.kernel.org/tip/1f8a6a10fb9437eac3f516ea4324a19087872f30
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 8 Jun 2009 18:18:39 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 8 Jun 2009 18:50:20 -0400

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


---
 include/linux/ring_buffer.h |   14 +++++++++++++-
 kernel/trace/ring_buffer.c  |    9 +++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

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
