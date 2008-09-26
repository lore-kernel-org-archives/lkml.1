Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYIZRjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYIZRjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYIZRjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:39:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYIZRjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:39:39 -0400
Date: Fri, 26 Sep 2008 14:31:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v5] Unified trace buffer
Message-ID: <20080926173130.GE15446@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	prasad@linux.vnet.ibm.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	David Wilder <dwilder@us.ibm.com>, hch@lst.de,
	Martin Bligh <mbligh@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <srostedt@redhat.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 26, 2008 at 01:11:57PM -0400, Steven Rostedt escreveu:
> 
> [
>   Note the removal of the RFC in the subject.
>   I am happy with this version. It handles everything I need
>   for ftrace.
> 
>   New since last version:
> 
>    - Fixed timing bug. I did not add the deltas properly when
>      reading the buffer.
> 
>    - Removed "-1" time stamp normalize test. This made the
>      clock go backwards!
> 
>    - Removed page pointer array and replaced it with the ftrace
>      page struct link list trick. Since this is my second time
>      writing this code (first with ftrace), it is actually much
>      cleaner than the ftrace code.
> 
>    - Implemented buffer resizing. By using the page link list trick,
>      this became much simpler.
> 
>    Note, the GOTD part is still not implemented, but can be done
>    later without affecting this interface.
> 
> ]
> 
> This is a unified tracing buffer that implements a ring buffer that
> hopefully everyone will eventually be able to use.
> 
> The events recorded into the buffer have the following structure:
> 
> struct ring_buffer_event {
> 	u32 type:2, len:3, time_delta:27;
> 	u32 array[];
> };
> 
> The minimum size of an event is 8 bytes. All events are 4 byte
> aligned inside the buffer.
> 
> There are 4 types (all internal use for the ring buffer, only
> the data type is exported to the interface users).
> 
> RB_TYPE_PADDING: this type is used to note extra space at the end
> 	of a buffer page.
> 
> RB_TYPE_TIME_EXTENT: This type is used when the time between events
> 	is greater than the 27 bit delta can hold. We add another
> 	32 bits, and record that in its own event (8 byte size).
> 
> RB_TYPE_TIME_STAMP: (Not implemented yet). This will hold data to
> 	help keep the buffer timestamps in sync.
> 
> RB_TYPE_DATA: The event actually holds user data.
> 
> The "len" field is only three bits. Since the data must be
> 4 byte aligned, this field is shifted left by 2, giving a
> max length of 28 bytes. If the data load is greater than 28
> bytes, the first array field holds the full length of the
> data load and the len field is set to zero.
> 
> Example, data size of 7 bytes:
> 
> 	type = RB_TYPE_DATA
> 	len = 2
> 	time_delta: <time-stamp> - <prev_event-time-stamp>
> 	array[0..1]: <7 bytes of data> <1 byte empty>
> 
> This event is saved in 12 bytes of the buffer.
> 
> An event with 82 bytes of data:
> 
> 	type = RB_TYPE_DATA
> 	len = 0
> 	time_delta: <time-stamp> - <prev_event-time-stamp>
> 	array[0]: 84 (Note the alignment)
> 	array[1..14]: <82 bytes of data> <2 bytes empty>
> 
> The above event is saved in 92 bytes (if my math is correct).
> 82 bytes of data, 2 bytes empty, 4 byte header, 4 byte length.
> 
> Do not reference the above event struct directly. Use the following
> functions to gain access to the event table, since the
> ring_buffer_event structure may change in the future.
> 
> ring_buffer_event_length(event): get the length of the event.
> 	This is the size of the memory used to record this
> 	event, and not the size of the data pay load.
> 
> ring_buffer_time_delta(event): get the time delta of the event
> 	This returns the delta time stamp since the last event.
> 	Note: Even though this is in the header, there should
> 		be no reason to access this directly, accept
> 		for debugging.
> 
> ring_buffer_event_data(event): get the data from the event
> 	This is the function to use to get the actual data
> 	from the event. Note, it is only a pointer to the
> 	data inside the buffer. This data must be copied to
> 	another location otherwise you risk it being written
> 	over in the buffer.
> 
> ring_buffer_lock: A way to lock the entire buffer.
> ring_buffer_unlock: unlock the buffer.
> 
> ring_buffer_alloc: create a new ring buffer. Can choose between
> 	overwrite or consumer/producer mode. Overwrite will
> 	overwrite old data, where as consumer producer will
> 	throw away new data if the consumer catches up with the
> 	producer.  The consumer/producer is the default.
> 
> ring_buffer_free: free the ring buffer.
> 
> ring_buffer_resize: resize the buffer. Changes the size of each cpu
> 	buffer. Note, it is up to the caller to provide that
> 	the buffer is not being used while this is happening.
> 	This requirement may go away but do not count on it.
> 
> ring_buffer_lock_reserve: locks the ring buffer and allocates an
> 	entry on the buffer to write to.
> ring_buffer_unlock_commit: unlocks the ring buffer and commits it to
> 	the buffer.
> 
> ring_buffer_write: writes some data into the ring buffer.
> 
> ring_buffer_peek: Look at a next item in the cpu buffer.
> ring_buffer_consume: get the next item in the cpu buffer and
> 	consume it. That is, this function increments the head
> 	pointer.
> 
> ring_buffer_read_start: Start an iterator of a cpu buffer.
> 	For now, this disables the cpu buffer, until you issue
> 	a finish. This is just because we do not want the iterator
> 	to be overwritten. This restriction may change in the future.
> 	But note, this is used for static reading of a buffer which
> 	is usually done "after" a trace. Live readings would want
> 	to use the ring_buffer_consume above, which will not
> 	disable the ring buffer.
> 
> ring_buffer_read_finish: Finishes the read iterator and reenables
> 	the ring buffer.
> 
> ring_buffer_iter_peek: Look at the next item in the cpu iterator.
> ring_buffer_read: Read the iterator and increment it.
> ring_buffer_iter_reset: Reset the iterator to point to the beginning
> 	of the cpu buffer.
> ring_buffer_iter_empty: Returns true if the iterator is at the end
> 	of the cpu buffer.
> 
> ring_buffer_size: returns the size in bytes of each cpu buffer.
> 	Note, the real size is this times the number of CPUs.
> 
> ring_buffer_reset_cpu: Sets the cpu buffer to empty
> ring_buffer_reset: sets all cpu buffers to empty
> 
> ring_buffer_swap_cpu: swaps a cpu buffer from one buffer with a
> 	cpu buffer of another buffer. This is handy when you
> 	want to take a snap shot of a running trace on just one
> 	cpu. Having a backup buffer, to swap with facilitates this.
> 	Ftrace max latencies use this.
> 
> ring_buffer_empty: Returns true if the ring buffer is empty.
> ring_buffer_empty_cpu: Returns true if the cpu buffer is empty.
> 
> ring_buffer_record_disable: disable all cpu buffers (read only)
> ring_buffer_record_disable_cpu: disable a single cpu buffer (read only)
> ring_buffer_record_enable: enable all cpu buffers.
> ring_buffer_record_enabl_cpu: enable a single cpu buffer.
> 
> ring_buffer_entries: The number of entries in a ring buffer.
> ring_buffer_overruns: The number of entries removed due to writing wrap.
> 
> ring_buffer_time_stamp: Get the time stamp used by the ring buffer
> ring_buffer_normalize_time_stamp: normalize the ring buffer time stamp
> 	into nanosecs.
> 
> I still need to implement the GTOD feature. But we need support from
> the cpu frequency infrastructure.  But this can be done at a later
> time without affecting the ring buffer interface.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/ring_buffer.h |  178 +++++
>  kernel/trace/Kconfig        |    4 
>  kernel/trace/Makefile       |    1 
>  kernel/trace/ring_buffer.c  | 1491 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1674 insertions(+)
> 
> Index: linux-trace.git/include/linux/ring_buffer.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-trace.git/include/linux/ring_buffer.h	2008-09-25 21:29:16.000000000 -0400
> @@ -0,0 +1,178 @@
> +#ifndef _LINUX_RING_BUFFER_H
> +#define _LINUX_RING_BUFFER_H
> +
> +#include <linux/mm.h>
> +#include <linux/seq_file.h>
> +
> +struct ring_buffer;
> +struct ring_buffer_iter;
> +
> +/*
> + * Don't reference this struct directly, use the inline items below.
> + */
> +struct ring_buffer_event {
> +	u32		type:2, len:3, time_delta:27;
> +	u32		array[];
> +} __attribute__((__packed__));

Why do you need __packed__ here? With or without it the layout is the
same:

[acme@doppio examples]$ pahole packed
struct ring_buffer_event {
	u32 type:2;               /* 0:30  4 */
	u32 len:3;                /* 0:27  4 */
	u32 time_delta:27;        /* 0: 0  4 */
	u32 array[0];             /* 4     0 */

	/* size: 4, cachelines: 1, members: 4 */
	/* last cacheline: 4 bytes */
};

- Arnaldo
