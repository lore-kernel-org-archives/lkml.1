Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265Ab0AEWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0AEWGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096Ab0AEWFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:05:45 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40236 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0AEWFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:05:44 -0500
Message-Id: <20100105220438.462143211@quilx.com>
References: <20100105220417.400092933@quilx.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Jan 2010 16:04:19 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V1 2/4] Replace local_t use in trace subsystem
Content-Disposition: inline; filename=remove_local_t_ringbuffer_convert
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the local_t use with longs in the trace subsystem. The longs can then be
updated with the required level of concurrency protection through cmpxchg_local()
and add_local().

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 kernel/trace/ring_buffer.c           |  150 +++++++++++++++++------------------
 kernel/trace/ring_buffer_benchmark.c |    5 -
 kernel/trace/trace_branch.c          |    1 
 3 files changed, 77 insertions(+), 79 deletions(-)

Index: linux-2.6/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer.c	2010-01-05 15:35:35.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer.c	2010-01-05 15:36:07.000000000 -0600
@@ -20,7 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/fs.h>
 
-#include <asm/local.h>
+#include <asm/add-local.h>
 #include "trace.h"
 
 /*
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
@@ -824,8 +824,8 @@ static int rb_tail_page_update(struct ri
 	 *
 	 * We add a counter to the write field to denote this.
 	 */
-	old_write = local_add_return(RB_WRITE_INTCNT, &next_page->write);
-	old_entries = local_add_return(RB_WRITE_INTCNT, &next_page->entries);
+	old_write = add_return_local(&next_page->write, RB_WRITE_INTCNT);
+	old_entries = add_return_local(&next_page->entries, RB_WRITE_INTCNT);
 
 	/*
 	 * Just make sure we have seen our old_write and synchronize
@@ -853,15 +853,15 @@ static int rb_tail_page_update(struct ri
 		 * cmpxchg to only update if an interrupt did not already
 		 * do it for us. If the cmpxchg fails, we don't care.
 		 */
-		(void)local_cmpxchg(&next_page->write, old_write, val);
-		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
+		(void)cmpxchg_local(&next_page->write, old_write, val);
+		(void)cmpxchg_local(&next_page->entries, old_entries, eval);
 
 		/*
 		 * No need to worry about races with clearing out the commit.
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
@@ -1600,7 +1600,7 @@ rb_handle_head_page(struct ring_buffer_p
 		 * it is our responsibility to update
 		 * the counters.
 		 */
-		local_add(entries, &cpu_buffer->overrun);
+		add_local(&cpu_buffer->overrun, entries);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -1741,7 +1741,7 @@ rb_reset_tail(struct ring_buffer_per_cpu
 	 * must fill the old tail_page with padding.
 	 */
 	if (tail >= BUF_PAGE_SIZE) {
-		local_sub(length, &tail_page->write);
+		add_local(&tail_page->write, -length);
 		return;
 	}
 
@@ -1766,7 +1766,7 @@ rb_reset_tail(struct ring_buffer_per_cpu
 		rb_event_set_padding(event);
 
 		/* Set the write back to the previous setting */
-		local_sub(length, &tail_page->write);
+		add_local(&tail_page->write, -length);
 		return;
 	}
 
@@ -1778,7 +1778,7 @@ rb_reset_tail(struct ring_buffer_per_cpu
 
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
-	local_sub(length, &tail_page->write);
+	add_local(&tail_page->write, -length);
 }
 
 static struct ring_buffer_event *
@@ -1801,7 +1801,7 @@ rb_move_tail(struct ring_buffer_per_cpu 
 	 * about it.
 	 */
 	if (unlikely(next_page == commit_page)) {
-		local_inc(&cpu_buffer->commit_overrun);
+		add_local(&cpu_buffer->commit_overrun, 1);
 		goto out_reset;
 	}
 
@@ -1855,7 +1855,7 @@ rb_move_tail(struct ring_buffer_per_cpu 
 				      cpu_buffer->tail_page) &&
 				     (cpu_buffer->commit_page ==
 				      cpu_buffer->reader_page))) {
-				local_inc(&cpu_buffer->commit_overrun);
+				add_local(&cpu_buffer->commit_overrun, 1);
 				goto out_reset;
 			}
 		}
@@ -1894,7 +1894,7 @@ __rb_reserve_next(struct ring_buffer_per
 	unsigned long tail, write;
 
 	tail_page = cpu_buffer->tail_page;
-	write = local_add_return(length, &tail_page->write);
+	write = add_return_local(&tail_page->write, length);
 
 	/* set write to only the index of the write */
 	write &= RB_WRITE_MASK;
@@ -1913,7 +1913,7 @@ __rb_reserve_next(struct ring_buffer_per
 
 	/* The passed in type is zero for DATA */
 	if (likely(!type))
-		local_inc(&tail_page->entries);
+		add_local(&tail_page->entries, 1);
 
 	/*
 	 * If this is the first commit on the page, then update
@@ -1943,7 +1943,7 @@ rb_try_to_discard(struct ring_buffer_per
 
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		unsigned long write_mask =
-			local_read(&bpage->write) & ~RB_WRITE_MASK;
+			bpage->write & ~RB_WRITE_MASK;
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
@@ -1952,7 +1952,7 @@ rb_try_to_discard(struct ring_buffer_per
 		 */
 		old_index += write_mask;
 		new_index += write_mask;
-		index = local_cmpxchg(&bpage->write, old_index, new_index);
+		index = cmpxchg_local(&bpage->write, old_index, new_index);
 		if (index == old_index)
 			return 1;
 	}
@@ -2030,8 +2030,8 @@ rb_add_time_stamp(struct ring_buffer_per
 
 static void rb_start_commit(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	local_inc(&cpu_buffer->committing);
-	local_inc(&cpu_buffer->commits);
+	add_local(&cpu_buffer->committing, 1);
+	add_local(&cpu_buffer->commits, 1);
 }
 
 static void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
@@ -2039,17 +2039,17 @@ static void rb_end_commit(struct ring_bu
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
 
-	local_dec(&cpu_buffer->committing);
+	add_local(&cpu_buffer->committing, -1);
 
 	/* synchronize with interrupts */
 	barrier();
@@ -2059,9 +2059,9 @@ static void rb_end_commit(struct ring_bu
 	 * updating of the commit page and the clearing of the
 	 * committing counter.
 	 */
-	if (unlikely(local_read(&cpu_buffer->commits) != commits) &&
-	    !local_read(&cpu_buffer->committing)) {
-		local_inc(&cpu_buffer->committing);
+	if (unlikely(cpu_buffer->commits != commits) &&
+	    !cpu_buffer->committing) {
+		add_local(&cpu_buffer->committing, 1);
 		goto again;
 	}
 }
@@ -2087,8 +2087,8 @@ rb_reserve_next_event(struct ring_buffer
 	 */
 	barrier();
 	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
-		local_dec(&cpu_buffer->committing);
-		local_dec(&cpu_buffer->commits);
+		add_local(&cpu_buffer->committing, -1);
+		add_local(&cpu_buffer->commits, -1);
 		return NULL;
 	}
 #endif
@@ -2291,7 +2291,7 @@ rb_update_write_stamp(struct ring_buffer
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	local_inc(&cpu_buffer->entries);
+	add_local(&cpu_buffer->entries, -1);
 	rb_update_write_stamp(cpu_buffer, event);
 	rb_end_commit(cpu_buffer);
 }
@@ -2357,7 +2357,7 @@ rb_decrement_entry(struct ring_buffer_pe
 
 	/* Do the likely case first */
 	if (likely(bpage->page == (void *)addr)) {
-		local_dec(&bpage->entries);
+		add_local(&bpage->entries, -1);
 		return;
 	}
 
@@ -2369,7 +2369,7 @@ rb_decrement_entry(struct ring_buffer_pe
 	start = bpage;
 	do {
 		if (bpage->page == (void *)addr) {
-			local_dec(&bpage->entries);
+			add_local(&bpage->entries, -1);
 			return;
 		}
 		rb_inc_page(cpu_buffer, &bpage);
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
--- linux-2.6.orig/kernel/trace/ring_buffer_benchmark.c	2010-01-05 15:35:35.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer_benchmark.c	2010-01-05 15:38:23.000000000 -0600
@@ -8,11 +8,10 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/time.h>
-#include <asm/local.h>
 
 struct rb_page {
 	u64		ts;
-	local_t		commit;
+	long		commit;
 	char		data[4080];
 };
 
@@ -113,7 +112,7 @@ static enum event_status read_page(int c
 	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
 	if (ret >= 0) {
 		rpage = bpage;
-		commit = local_read(&rpage->commit);
+		commit = rpage->commit;
 		for (i = 0; i < commit && !kill_test; i += inc) {
 
 			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
Index: linux-2.6/kernel/trace/trace_branch.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_branch.c	2010-01-05 15:38:39.000000000 -0600
+++ linux-2.6/kernel/trace/trace_branch.c	2010-01-05 15:38:45.000000000 -0600
@@ -13,7 +13,6 @@
 #include <linux/ftrace.h>
 #include <linux/hash.h>
 #include <linux/fs.h>
-#include <asm/local.h>
 
 #include "trace.h"
 #include "trace_stat.h"

-- 
