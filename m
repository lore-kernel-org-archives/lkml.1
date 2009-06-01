Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZFAIMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZFAIMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZFAILP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:11:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43766 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbZFAILM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:11:12 -0400
Date: Mon, 1 Jun 2009 17:55:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: linux-next: manual merge of the kmemcheck tree with the tracing
 tree
Message-Id: <20090601175539.67317265.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the kmemcheck tree got a conflict in
kernel/trace/ring_buffer.c between commit
aa20ae8444fc6c318272c643f856d8d8ad3e198d ("ring-buffer: move big if
statement down") from the tracing tree and commits
9b7ff384ee76ced9638ab236db588a6f13916336 ("trace: annotate bitfields in
struct ring_buffer_event") and 3467e18b1cf34c7d316af5717e7053ce845d014e
("kmemcheck: make bitfield annotations be valid C") from the kmemcheck
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/ring_buffer.c
index 3611706,c22506f..0000000
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@@ -1154,156 -1156,132 +1155,157 @@@ static unsigned rb_calculate_event_leng
  	return length;
  }
  
 +
  static struct ring_buffer_event *
 -__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 -		  unsigned type, unsigned long length, u64 *ts)
 +rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 +	     unsigned long length, unsigned long tail,
 +	     struct buffer_page *commit_page,
 +	     struct buffer_page *tail_page, u64 *ts)
  {
 -	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
 -	unsigned long tail, write;
 +	struct buffer_page *next_page, *head_page, *reader_page;
  	struct ring_buffer *buffer = cpu_buffer->buffer;
  	struct ring_buffer_event *event;
 -	unsigned long flags;
  	bool lock_taken = false;
 +	unsigned long flags;
  
 -	commit_page = cpu_buffer->commit_page;
 -	/* we just need to protect against interrupts */
 -	barrier();
 -	tail_page = cpu_buffer->tail_page;
 -	write = local_add_return(length, &tail_page->write);
 -	tail = write - length;
 +	next_page = tail_page;
  
 -	/* See if we shot pass the end of this buffer page */
 -	if (write > BUF_PAGE_SIZE) {
 -		struct buffer_page *next_page = tail_page;
 +	local_irq_save(flags);
 +	/*
 +	 * Since the write to the buffer is still not
 +	 * fully lockless, we must be careful with NMIs.
 +	 * The locks in the writers are taken when a write
 +	 * crosses to a new page. The locks protect against
 +	 * races with the readers (this will soon be fixed
 +	 * with a lockless solution).
 +	 *
 +	 * Because we can not protect against NMIs, and we
 +	 * want to keep traces reentrant, we need to manage
 +	 * what happens when we are in an NMI.
 +	 *
 +	 * NMIs can happen after we take the lock.
 +	 * If we are in an NMI, only take the lock
 +	 * if it is not already taken. Otherwise
 +	 * simply fail.
 +	 */
 +	if (unlikely(in_nmi())) {
 +		if (!__raw_spin_trylock(&cpu_buffer->lock)) {
 +			cpu_buffer->nmi_dropped++;
 +			goto out_reset;
 +		}
 +	} else
 +		__raw_spin_lock(&cpu_buffer->lock);
  
 -		local_irq_save(flags);
 -		/*
 -		 * Since the write to the buffer is still not
 -		 * fully lockless, we must be careful with NMIs.
 -		 * The locks in the writers are taken when a write
 -		 * crosses to a new page. The locks protect against
 -		 * races with the readers (this will soon be fixed
 -		 * with a lockless solution).
 -		 *
 -		 * Because we can not protect against NMIs, and we
 -		 * want to keep traces reentrant, we need to manage
 -		 * what happens when we are in an NMI.
 -		 *
 -		 * NMIs can happen after we take the lock.
 -		 * If we are in an NMI, only take the lock
 -		 * if it is not already taken. Otherwise
 -		 * simply fail.
 -		 */
 -		if (unlikely(in_nmi())) {
 -			if (!__raw_spin_trylock(&cpu_buffer->lock))
 -				goto out_reset;
 -		} else
 -			__raw_spin_lock(&cpu_buffer->lock);
 +	lock_taken = true;
  
 -		lock_taken = true;
 +	rb_inc_page(cpu_buffer, &next_page);
  
 -		rb_inc_page(cpu_buffer, &next_page);
 +	head_page = cpu_buffer->head_page;
 +	reader_page = cpu_buffer->reader_page;
  
 -		head_page = cpu_buffer->head_page;
 -		reader_page = cpu_buffer->reader_page;
 +	/* we grabbed the lock before incrementing */
 +	if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
 +		goto out_reset;
  
 -		/* we grabbed the lock before incrementing */
 -		if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
 -			goto out_reset;
 +	/*
 +	 * If for some reason, we had an interrupt storm that made
 +	 * it all the way around the buffer, bail, and warn
 +	 * about it.
 +	 */
 +	if (unlikely(next_page == commit_page)) {
 +		cpu_buffer->commit_overrun++;
 +		goto out_reset;
 +	}
  
 -		/*
 -		 * If for some reason, we had an interrupt storm that made
 -		 * it all the way around the buffer, bail, and warn
 -		 * about it.
 -		 */
 -		if (unlikely(next_page == commit_page)) {
 -			WARN_ON_ONCE(1);
 +	if (next_page == head_page) {
 +		if (!(buffer->flags & RB_FL_OVERWRITE))
  			goto out_reset;
 -		}
 -
 -		if (next_page == head_page) {
 -			if (!(buffer->flags & RB_FL_OVERWRITE))
 -				goto out_reset;
  
 -			/* tail_page has not moved yet? */
 -			if (tail_page == cpu_buffer->tail_page) {
 -				/* count overflows */
 -				rb_update_overflow(cpu_buffer);
 +		/* tail_page has not moved yet? */
 +		if (tail_page == cpu_buffer->tail_page) {
 +			/* count overflows */
 +			cpu_buffer->overrun +=
 +				local_read(&head_page->entries);
  
 -				rb_inc_page(cpu_buffer, &head_page);
 -				cpu_buffer->head_page = head_page;
 -				cpu_buffer->head_page->read = 0;
 -			}
 +			rb_inc_page(cpu_buffer, &head_page);
 +			cpu_buffer->head_page = head_page;
 +			cpu_buffer->head_page->read = 0;
  		}
 +	}
  
 -		/*
 -		 * If the tail page is still the same as what we think
 -		 * it is, then it is up to us to update the tail
 -		 * pointer.
 -		 */
 -		if (tail_page == cpu_buffer->tail_page) {
 -			local_set(&next_page->write, 0);
 -			local_set(&next_page->page->commit, 0);
 -			cpu_buffer->tail_page = next_page;
 +	/*
 +	 * If the tail page is still the same as what we think
 +	 * it is, then it is up to us to update the tail
 +	 * pointer.
 +	 */
 +	if (tail_page == cpu_buffer->tail_page) {
 +		local_set(&next_page->write, 0);
 +		local_set(&next_page->entries, 0);
 +		local_set(&next_page->page->commit, 0);
 +		cpu_buffer->tail_page = next_page;
 +
 +		/* reread the time stamp */
 +		*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
 +		cpu_buffer->tail_page->page->time_stamp = *ts;
 +	}
  
 -			/* reread the time stamp */
 -			*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
 -			cpu_buffer->tail_page->page->time_stamp = *ts;
 -		}
 +	/*
 +	 * The actual tail page has moved forward.
 +	 */
 +	if (tail < BUF_PAGE_SIZE) {
 +		/* Mark the rest of the page with padding */
 +		event = __rb_page_index(tail_page, tail);
++		kmemcheck_annotate_bitfield(event, bitfield);
 +		rb_event_set_padding(event);
 +	}
  
 -		/*
 -		 * The actual tail page has moved forward.
 -		 */
 -		if (tail < BUF_PAGE_SIZE) {
 -			/* Mark the rest of the page with padding */
 -			event = __rb_page_index(tail_page, tail);
 -			kmemcheck_annotate_bitfield(event, bitfield);
 -			rb_event_set_padding(event);
 -		}
 +	/* Set the write back to the previous setting */
 +	local_sub(length, &tail_page->write);
  
 -		if (tail <= BUF_PAGE_SIZE)
 -			/* Set the write back to the previous setting */
 -			local_set(&tail_page->write, tail);
 +	/*
 +	 * If this was a commit entry that failed,
 +	 * increment that too
 +	 */
 +	if (tail_page == cpu_buffer->commit_page &&
 +	    tail == rb_commit_index(cpu_buffer)) {
 +		rb_set_commit_to_write(cpu_buffer);
 +	}
  
 -		/*
 -		 * If this was a commit entry that failed,
 -		 * increment that too
 -		 */
 -		if (tail_page == cpu_buffer->commit_page &&
 -		    tail == rb_commit_index(cpu_buffer)) {
 -			rb_set_commit_to_write(cpu_buffer);
 -		}
 +	__raw_spin_unlock(&cpu_buffer->lock);
 +	local_irq_restore(flags);
 +
 +	/* fail and let the caller try again */
 +	return ERR_PTR(-EAGAIN);
 +
 + out_reset:
 +	/* reset write */
 +	local_sub(length, &tail_page->write);
  
 +	if (likely(lock_taken))
  		__raw_spin_unlock(&cpu_buffer->lock);
 -		local_irq_restore(flags);
 +	local_irq_restore(flags);
 +	return NULL;
 +}
  
 -		/* fail and let the caller try again */
 -		return ERR_PTR(-EAGAIN);
 -	}
 +static struct ring_buffer_event *
 +__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 +		  unsigned type, unsigned long length, u64 *ts)
 +{
 +	struct buffer_page *tail_page, *commit_page;
 +	struct ring_buffer_event *event;
 +	unsigned long tail, write;
 +
 +	commit_page = cpu_buffer->commit_page;
 +	/* we just need to protect against interrupts */
 +	barrier();
 +	tail_page = cpu_buffer->tail_page;
 +	write = local_add_return(length, &tail_page->write);
 +	tail = write - length;
 +
 +	/* See if we shot pass the end of this buffer page */
 +	if (write > BUF_PAGE_SIZE)
 +		return rb_move_tail(cpu_buffer, length, tail,
 +				    commit_page, tail_page, ts);
  
  	/* We reserved something on the buffer */
  
@@@ -1311,12 -1289,9 +1313,13 @@@
  		return NULL;
  
  	event = __rb_page_index(tail_page, tail);
+ 	kmemcheck_annotate_bitfield(event, bitfield);
  	rb_update_event(event, type, length);
  
 +	/* The passed in type is zero for DATA */
 +	if (likely(!type))
 +		local_inc(&tail_page->entries);
 +
  	/*
  	 * If this is a commit and the tail is zero, then update
  	 * this page's time stamp.
