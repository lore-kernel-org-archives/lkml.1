Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624Ab0AGWg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0AGWg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334Ab0AGWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:36:36 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46412 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0AGWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:36:34 -0500
Message-Id: <20100107223548.270401090@quilx.com>
References: <20100107223524.760517016@quilx.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jan 2010 16:35:26 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V2 2/3] Remove local_t type from tree.
Content-Disposition: inline; filename=remove_local_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be better if local ops would generically work on any scalar. local_t
only allows the use of long. local_t also requires initializers and a read
function that never does anything aside from setting or reading a variable.

Remove local_t and replace with long. For now the API still only supports
a single type but asm-generic/local.h shows how it can be genericized similar
to what cmpxchg_local() does.

With that we can get rid of local_read/set and LOCAL_INIT too.

We need to update the ringbuffer users to no longer refer to these functions.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/alpha/include/asm/local.h       |   29 +++------
 arch/m32r/include/asm/local.h        |   37 +-----------
 arch/mips/include/asm/local.h        |   39 ++++---------
 arch/powerpc/include/asm/local.h     |   26 ++------
 arch/x86/include/asm/local.h         |   35 ++++-------
 include/asm-generic/local.h          |   66 +++++++++++++---------
 kernel/trace/ring_buffer.c           |  104 +++++++++++++++++------------------
 kernel/trace/ring_buffer_benchmark.c |    4 -
 8 files changed, 141 insertions(+), 199 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/local.h	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/arch/powerpc/include/asm/local.h	2010-01-07 16:25:53.000000000 -0600
@@ -4,22 +4,7 @@
 #include <linux/percpu.h>
 #include <asm/atomic.h>
 
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-
-#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
-#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-
-static __inline__ long local_add_return(long a, local_t *l)
+static __inline__ long local_add_return(long a, long *l)
 {
 	long t;
 
@@ -30,13 +15,18 @@ static __inline__ long local_add_return(
 	PPC_STLCX	"%0,0,%2 \n\
 	bne-	1b"
 	: "=&r" (t)
-	: "r" (a), "r" (&(l->a.counter))
+	: "r" (a), "r" (*l)
 	: "cc", "memory");
 
 	return t;
 }
 
+#define local_add(i, l)	local_add_return((i), (l))
+#define local_sub(i, l)	local_add_return(-(i), (l))
+#define local_inc(l)	local_add_return(1, (l))
+#define local_dec(l)	local_add_return(-1, (l))
+
 #define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
+	(cmpxchg_local((l), (o), (n)))
 
 #endif /* _ARCH_POWERPC_LOCAL_H */
Index: linux-2.6/arch/x86/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/local.h	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/local.h	2010-01-07 16:25:54.000000000 -0600
@@ -7,38 +7,29 @@
 #include <asm/atomic.h>
 #include <asm/asm.h>
 
-typedef struct {
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l, i)	atomic_long_set(&(l)->a, (i))
-
-static inline void local_inc(local_t *l)
+static inline void local_inc(long *l)
 {
 	asm volatile(_ASM_INC "%0"
-		     : "+m" (l->a.counter));
+		     : "+m" (*l));
 }
 
-static inline void local_dec(local_t *l)
+static inline void local_dec(long *l)
 {
 	asm volatile(_ASM_DEC "%0"
-		     : "+m" (l->a.counter));
+		     : "+m" (*l));
 }
 
-static inline void local_add(long i, local_t *l)
+static inline void local_add(long i, long *l)
 {
 	asm volatile(_ASM_ADD "%1,%0"
-		     : "+m" (l->a.counter)
+		     : "+m" (*l)
 		     : "ir" (i));
 }
 
-static inline void local_sub(long i, local_t *l)
+static inline void local_sub(long i, long *l)
 {
 	asm volatile(_ASM_SUB "%1,%0"
-		     : "+m" (l->a.counter)
+		     : "+m" (*l)
 		     : "ir" (i));
 }
 
@@ -49,7 +40,7 @@ static inline void local_sub(long i, loc
  *
  * Atomically adds @i to @l and returns @i + @l
  */
-static inline long local_add_return(long i, local_t *l)
+static inline long local_add_return(long i, long *l)
 {
 	long __i;
 #ifdef CONFIG_M386
@@ -60,21 +51,21 @@ static inline long local_add_return(long
 	/* Modern 486+ processor */
 	__i = i;
 	asm volatile(_ASM_XADD "%0, %1;"
-		     : "+r" (i), "+m" (l->a.counter)
+		     : "+r" (i), "+m" (*l)
 		     : : "memory");
 	return i + __i;
 
 #ifdef CONFIG_M386
 no_xadd: /* Legacy 386 processor */
 	local_irq_save(flags);
-	__i = local_read(l);
-	local_set(l, i + __i);
+	__i = *l;
+	*l = i + __i;
 	local_irq_restore(flags);
 	return i + __i;
 #endif
 }
 
 #define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
+	(cmpxchg_local((l), (o), (n)))
 
 #endif /* _ASM_X86_LOCAL_H */
Index: linux-2.6/include/asm-generic/local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/local.h	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/include/asm-generic/local.h	2010-01-07 16:26:19.000000000 -0600
@@ -1,39 +1,53 @@
 #ifndef _ASM_GENERIC_LOCAL_H
 #define _ASM_GENERIC_LOCAL_H
 
-#include <linux/percpu.h>
-#include <asm/atomic.h>
 #include <asm/types.h>
+#include <linux/kernel.h>
 
 /*
- * A signed long type for operations which are atomic for a single CPU.
- * Usually used in combination with per-cpu variables.
+ * The whole point here is to allow the use of atomic wrt IRQ operations of
+ * some cpus. local_xx ops allow to exploit such operations.
  *
- * This is the default implementation, which uses atomic_long_t.  Which is
- * rather pointless.  The whole point behind local_t is that some processors
- * can perform atomic adds and subtracts in a manner which is atomic wrt IRQs
- * running on this CPU.  local_t allows exploitation of such capabilities.
+ * Note that the percpu subsystem contains similar operations that also
+ * perform relocation to the per cpu area of the current processor in the
+ * same instruction. This guarantees that each processor has its own variable.
+ *
+ * The use of these operations here requires that the user has made his
+ * own arrangements to guarantee that concurrrent modifications / accesses
+ * to the specified variable from different processors does not occur.
  */
 
-/* Implement in terms of atomics. */
-
-/* Don't use typedef: don't want them to be mixed with atomic_t's. */
-typedef struct
+/*
+ * Generic version of __add_return_local (disables interrupts). Takes an
+ * unsigned long parameter, supporting various types of architectures.
+ */
+static inline unsigned long __local_add_return(volatile void *ptr,
+				unsigned long value, size_t size)
 {
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set((&(l)->a),(i))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
-#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
+	unsigned long flags, r;
 
-#define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
+	local_irq_save(flags);
+	switch (size) {
+	case 1: r = (*((u8 *)ptr) += value);
+		break;
+	case 2: r = (*((u16 *)ptr) += value);
+		break;
+	case 4: r = (*((u32 *)ptr) += value);
+		break;
+	case 8: r = (*((u64 *)ptr) += value);
+		break;
+	}
+	local_irq_restore(flags);
+	return r;
+}
+
+#define local_add_return(i, l) __local_add_return((l), (i), sizeof(*(l)))
+
+#define local_inc(l)	local_add_return(1, (l))
+#define local_dec(l)	local_add_return(-1, (l))
+#define local_add(i,l)	local_add_return((i), (l))
+#define local_sub(i,l)	local_add_return(-(i), (l))
 
-#define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
+#define local_cmpxchg(l, o, n) cmpxchg_local((l), (o), (n))
 
-#endif /* _ASM_GENERIC_LOCAL_H */
+#endif /* _ASM_GENERIC_LOCAL_i */
Index: linux-2.6/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer.c	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer.c	2010-01-07 16:25:54.000000000 -0600
@@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data
 
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
-	local_t		 commit;	/* write committed index */
+	long		 commit;	/* write committed index */
 	unsigned char	 data[];	/* data of buffer page */
 };
 
@@ -326,9 +326,9 @@ struct buffer_data_page {
  */
 struct buffer_page {
 	struct list_head list;		/* list of buffer pages */
-	local_t		 write;		/* index for next write */
+	long		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
-	local_t		 entries;	/* entries on this page */
+	long		 entries;	/* entries on this page */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -349,7 +349,7 @@ struct buffer_page {
 
 static void rb_init_page(struct buffer_data_page *bpage)
 {
-	local_set(&bpage->commit, 0);
+	bpage->commit = 0;
 }
 
 /**
@@ -360,7 +360,7 @@ static void rb_init_page(struct buffer_d
  */
 size_t ring_buffer_page_len(void *page)
 {
-	return local_read(&((struct buffer_data_page *)page)->commit)
+	return ((struct buffer_data_page *)page)->commit
 		+ BUF_PAGE_HDR_SIZE;
 }
 
@@ -431,11 +431,11 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
-	local_t				commit_overrun;
-	local_t				overrun;
-	local_t				entries;
-	local_t				committing;
-	local_t				commits;
+	long				commit_overrun;
+	long				overrun;
+	long				entries;
+	long				committing;
+	long				commits;
 	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
@@ -861,7 +861,7 @@ static int rb_tail_page_update(struct ri
 		 * it only can increment when a commit takes place. But that
 		 * only happens in the outer most nested commit.
 		 */
-		local_set(&next_page->page->commit, 0);
+		next_page->page->commit = 0;
 
 		old_tail = cmpxchg(&cpu_buffer->tail_page,
 				   tail_page, next_page);
@@ -1394,17 +1394,17 @@ rb_iter_head_event(struct ring_buffer_it
 
 static inline unsigned long rb_page_write(struct buffer_page *bpage)
 {
-	return local_read(&bpage->write) & RB_WRITE_MASK;
+	return bpage->write & RB_WRITE_MASK;
 }
 
 static inline unsigned rb_page_commit(struct buffer_page *bpage)
 {
-	return local_read(&bpage->page->commit);
+	return bpage->page->commit;
 }
 
 static inline unsigned long rb_page_entries(struct buffer_page *bpage)
 {
-	return local_read(&bpage->entries) & RB_WRITE_MASK;
+	return bpage->entries & RB_WRITE_MASK;
 }
 
 /* Size is determined by what has been commited */
@@ -1463,8 +1463,8 @@ rb_set_commit_to_write(struct ring_buffe
 		if (RB_WARN_ON(cpu_buffer,
 			       rb_is_reader_page(cpu_buffer->tail_page)))
 			return;
-		local_set(&cpu_buffer->commit_page->page->commit,
-			  rb_page_write(cpu_buffer->commit_page));
+		cpu_buffer->commit_page->page->commit =
+			  rb_page_write(cpu_buffer->commit_page);
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
 		cpu_buffer->write_stamp =
 			cpu_buffer->commit_page->page->time_stamp;
@@ -1474,10 +1474,10 @@ rb_set_commit_to_write(struct ring_buffe
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
 
-		local_set(&cpu_buffer->commit_page->page->commit,
-			  rb_page_write(cpu_buffer->commit_page));
+		cpu_buffer->commit_page->page->commit =
+			  rb_page_write(cpu_buffer->commit_page);
 		RB_WARN_ON(cpu_buffer,
-			   local_read(&cpu_buffer->commit_page->page->commit) &
+			   cpu_buffer->commit_page->page->commit &
 			   ~RB_WRITE_MASK);
 		barrier();
 	}
@@ -1943,7 +1943,7 @@ rb_try_to_discard(struct ring_buffer_per
 
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		unsigned long write_mask =
-			local_read(&bpage->write) & ~RB_WRITE_MASK;
+			bpage->write & ~RB_WRITE_MASK;
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
@@ -2039,14 +2039,14 @@ static void rb_end_commit(struct ring_bu
 	unsigned long commits;
 
 	if (RB_WARN_ON(cpu_buffer,
-		       !local_read(&cpu_buffer->committing)))
+		       !cpu_buffer->committing))
 		return;
 
  again:
-	commits = local_read(&cpu_buffer->commits);
+	commits = cpu_buffer->commits;
 	/* synchronize with interrupts */
 	barrier();
-	if (local_read(&cpu_buffer->committing) == 1)
+	if (cpu_buffer->committing == 1)
 		rb_set_commit_to_write(cpu_buffer);
 
 	local_dec(&cpu_buffer->committing);
@@ -2059,8 +2059,8 @@ static void rb_end_commit(struct ring_bu
 	 * updating of the commit page and the clearing of the
 	 * committing counter.
 	 */
-	if (unlikely(local_read(&cpu_buffer->commits) != commits) &&
-	    !local_read(&cpu_buffer->committing)) {
+	if (unlikely(cpu_buffer->commits != commits) &&
+	    !cpu_buffer->committing) {
 		local_inc(&cpu_buffer->committing);
 		goto again;
 	}
@@ -2415,7 +2415,7 @@ void ring_buffer_discard_commit(struct r
 	 * committed yet. Thus we can assume that preemption
 	 * is still disabled.
 	 */
-	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
+	RB_WARN_ON(buffer, !cpu_buffer->committing);
 
 	rb_decrement_entry(cpu_buffer, event);
 	if (rb_try_to_discard(cpu_buffer, event))
@@ -2604,7 +2604,7 @@ unsigned long ring_buffer_entries_cpu(st
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = (local_read(&cpu_buffer->entries) - local_read(&cpu_buffer->overrun))
+	ret = cpu_buffer->entries - cpu_buffer->overrun
 		- cpu_buffer->read;
 
 	return ret;
@@ -2625,7 +2625,7 @@ unsigned long ring_buffer_overrun_cpu(st
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = local_read(&cpu_buffer->overrun);
+	ret = cpu_buffer->overrun;
 
 	return ret;
 }
@@ -2646,7 +2646,7 @@ ring_buffer_commit_overrun_cpu(struct ri
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = local_read(&cpu_buffer->commit_overrun);
+	ret = cpu_buffer->commit_overrun;
 
 	return ret;
 }
@@ -2668,8 +2668,8 @@ unsigned long ring_buffer_entries(struct
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		entries += (local_read(&cpu_buffer->entries) -
-			    local_read(&cpu_buffer->overrun)) - cpu_buffer->read;
+		entries += cpu_buffer->entries -
+			    cpu_buffer->overrun - cpu_buffer->read;
 	}
 
 	return entries;
@@ -2692,7 +2692,7 @@ unsigned long ring_buffer_overruns(struc
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		overruns += local_read(&cpu_buffer->overrun);
+		overruns += cpu_buffer->overrun;
 	}
 
 	return overruns;
@@ -2861,9 +2861,9 @@ rb_get_reader_page(struct ring_buffer_pe
 	/*
 	 * Reset the reader page to size zero.
 	 */
-	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->entries, 0);
-	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	cpu_buffer->reader_page->write = 0;
+	cpu_buffer->reader_page->entries = 0;
+	cpu_buffer->reader_page->page->commit = 0;
 
  spin:
 	/*
@@ -3354,9 +3354,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu 
 
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages, struct buffer_page, list);
-	local_set(&cpu_buffer->head_page->write, 0);
-	local_set(&cpu_buffer->head_page->entries, 0);
-	local_set(&cpu_buffer->head_page->page->commit, 0);
+	cpu_buffer->head_page->write = 0;
+	cpu_buffer->head_page->entries = 0;
+	cpu_buffer->head_page->page->commit = 0;
 
 	cpu_buffer->head_page->read = 0;
 
@@ -3364,16 +3364,16 @@ rb_reset_cpu(struct ring_buffer_per_cpu 
 	cpu_buffer->commit_page = cpu_buffer->head_page;
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
-	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->entries, 0);
-	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	cpu_buffer->reader_page->write = 0;
+	cpu_buffer->reader_page->entries = 0;
+	cpu_buffer->reader_page->page->commit = 0;
 	cpu_buffer->reader_page->read = 0;
 
-	local_set(&cpu_buffer->commit_overrun, 0);
-	local_set(&cpu_buffer->overrun, 0);
-	local_set(&cpu_buffer->entries, 0);
-	local_set(&cpu_buffer->committing, 0);
-	local_set(&cpu_buffer->commits, 0);
+	cpu_buffer->commit_overrun = 0;
+	cpu_buffer->overrun = 0;
+	cpu_buffer->entries = 0;
+	cpu_buffer->committing = 0;
+	cpu_buffer->commits = 0;
 	cpu_buffer->read = 0;
 
 	cpu_buffer->write_stamp = 0;
@@ -3399,7 +3399,7 @@ void ring_buffer_reset_cpu(struct ring_b
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
-	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
+	if (RB_WARN_ON(cpu_buffer, cpu_buffer->committing))
 		goto out;
 
 	arch_spin_lock(&cpu_buffer->lock);
@@ -3547,9 +3547,9 @@ int ring_buffer_swap_cpu(struct ring_buf
 	atomic_inc(&cpu_buffer_b->record_disabled);
 
 	ret = -EBUSY;
-	if (local_read(&cpu_buffer_a->committing))
+	if (cpu_buffer_a->committing)
 		goto out_dec;
-	if (local_read(&cpu_buffer_b->committing))
+	if (cpu_buffer_b->committing)
 		goto out_dec;
 
 	buffer_a->buffers[cpu] = cpu_buffer_b;
@@ -3733,7 +3733,7 @@ int ring_buffer_read_page(struct ring_bu
 		} while (len > size);
 
 		/* update bpage */
-		local_set(&bpage->commit, pos);
+		bpage->commit = pos;
 		bpage->time_stamp = save_timestamp;
 
 		/* we copied everything to the beginning */
@@ -3746,8 +3746,8 @@ int ring_buffer_read_page(struct ring_bu
 		rb_init_page(bpage);
 		bpage = reader->page;
 		reader->page = *data_page;
-		local_set(&reader->write, 0);
-		local_set(&reader->entries, 0);
+		reader->write = 0;
+		reader->entries = 0;
 		reader->read = 0;
 		*data_page = bpage;
 	}
Index: linux-2.6/kernel/trace/ring_buffer_benchmark.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer_benchmark.c	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer_benchmark.c	2010-01-07 16:12:46.000000000 -0600
@@ -12,7 +12,7 @@
 
 struct rb_page {
 	u64		ts;
-	local_t		commit;
+	long		commit;
 	char		data[4080];
 };
 
@@ -113,7 +113,7 @@ static enum event_status read_page(int c
 	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
 	if (ret >= 0) {
 		rpage = bpage;
-		commit = local_read(&rpage->commit);
+		commit = rpage->commit;
 		for (i = 0; i < commit && !kill_test; i += inc) {
 
 			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
Index: linux-2.6/arch/alpha/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/local.h	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/arch/alpha/include/asm/local.h	2010-01-07 16:25:53.000000000 -0600
@@ -1,23 +1,9 @@
 #ifndef _ALPHA_LOCAL_H
 #define _ALPHA_LOCAL_H
 
-#include <linux/percpu.h>
-#include <asm/atomic.h>
+#include <linux/types.h>
 
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
-#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
-
-static __inline__ long local_add_return(long i, local_t * l)
+static __inline__ long local_add_return(long i, long *l)
 {
 	long temp, result;
 	__asm__ __volatile__(
@@ -29,12 +15,17 @@ static __inline__ long local_add_return(
 	".subsection 2\n"
 	"2:	br 1b\n"
 	".previous"
-	:"=&r" (temp), "=m" (l->a.counter), "=&r" (result)
-	:"Ir" (i), "m" (l->a.counter) : "memory");
+	:"=&r" (temp), "=m" (*l), "=&r" (result)
+	:"Ir" (i), "m" (*l) : "memory");
 	return result;
 }
 
+#define local_inc(l)	local_add_return(1, (l))
+#define local_dec(l)	local_add_return(-1, (l))
+#define local_add(i,l)	local_add_return((i),(l))
+#define local_sub(i,l)	local_add_return(-(i),(l))
+
 #define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
+	(cmpxchg_local((l), (o), (n)))
 
 #endif /* _ALPHA_LOCAL_H */
Index: linux-2.6/arch/m32r/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/local.h	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/arch/m32r/include/asm/local.h	2010-01-07 16:25:54.000000000 -0600
@@ -15,37 +15,6 @@
 #include <asm/system.h>
 #include <asm/local.h>
 
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } local_t;
-
-#define LOCAL_INIT(i)	{ (i) }
-
-/**
- * local_read - read local variable
- * @l: pointer of type local_t
- *
- * Atomically reads the value of @l.
- */
-#define local_read(l)	((l)->counter)
-
-/**
- * local_set - set local variable
- * @l: pointer of type local_t
- * @i: required value
- *
- * Atomically sets the value of @l to @i.
- */
-#define local_set(l, i)	(((l)->counter) = (i))
-
 /**
  * local_add_return - add long to local variable and return it
  * @i: long value to add
@@ -53,7 +22,7 @@ typedef struct { volatile int counter; }
  *
  * Atomically adds @i to @l and return (@i + @l).
  */
-static inline long local_add_return(long i, local_t *l)
+static inline long local_add_return(long i, long *l)
 {
 	unsigned long flags;
 	long result;
@@ -66,7 +35,7 @@ static inline long local_add_return(long
 		"add	%0, %2;			\n\t"
 		"st %0, @%1;			\n\t"
 		: "=&r" (result)
-		: "r" (&l->counter), "r" (i)
+		: "r" (*l), "r" (i)
 		: "memory"
 #ifdef CONFIG_CHIP_M32700_TS1
 		, "r4"
@@ -111,7 +80,7 @@ static inline long local_add_return(long
  */
 #define local_dec(l) local_sub(1, (l))
 
-#define local_cmpxchg(l, o, n) (cmpxchg_local(&((l)->counter), (o), (n)))
+#define local_cmpxchg(l, o, n) (cmpxchg_local((l), (o), (n)))
 
 static inline void local_clear_mask(unsigned long  mask, local_t *addr)
 {
Index: linux-2.6/arch/mips/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/local.h	2010-01-07 16:09:45.000000000 -0600
+++ linux-2.6/arch/mips/include/asm/local.h	2010-01-07 16:25:53.000000000 -0600
@@ -7,25 +7,7 @@
 #include <asm/cmpxchg.h>
 #include <asm/war.h>
 
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l, i)	atomic_long_set(&(l)->a, (i))
-
-#define local_add(i, l)	atomic_long_add((i), (&(l)->a))
-#define local_sub(i, l)	atomic_long_sub((i), (&(l)->a))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-
-/*
- * Same as above, but return the result value
- */
-static __inline__ long local_add_return(long i, local_t * l)
+static __inline__ long local_add_return(long i, long * l)
 {
 	unsigned long result;
 
@@ -40,8 +22,8 @@ static __inline__ long local_add_return(
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
+		: "=&r" (result), "=&r" (temp), "=m" (*l)
+		: "Ir" (i), "m" (*l)
 		: "memory");
 	} else if (kernel_uses_llsc) {
 		unsigned long temp;
@@ -54,23 +36,28 @@ static __inline__ long local_add_return(
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
+		: "=&r" (result), "=&r" (temp), "=m" (*l)
+		: "Ir" (i), "m" (*l)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = l->a.counter;
+		result = *l;
 		result += i;
-		l->a.counter = result;
+		*l = result;
 		local_irq_restore(flags);
 	}
 
 	return result;
 }
 
+#define local_add(i, l)	local_add_return((i), (l))
+#define local_sub(i, l)	local_add_return(-(i), (l))
+#define local_inc(l)	local_add_return(-1, (l))
+#define local_dec(l)	local_add_return(-1, (l))
+
 #define local_cmpxchg(l, o, n) \
-	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
+	((long)cmpxchg_local((l), (o), (n)))
 
 #endif /* _ARCH_MIPS_LOCAL_H */

-- 
