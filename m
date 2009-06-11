Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZFKSKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZFKSKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZFKSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:10:08 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:57565 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbZFKSKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:10:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAP/iMEpMQW1W/2dsb2JhbACBT882gjCBWgU
Date: Thu, 11 Jun 2009 14:09:53 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, ltt-dev@lists.casi.polymtl.ca,
       Robert Wisniewski <bob@watson.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
Message-ID: <20090611180953.GA2955@Krystal>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <20090610221304.GA3240@Krystal> <alpine.DEB.2.00.0906102141410.30552@gandalf.stny.rr.com> <20090611035149.GA13199@Krystal> <20090611035928.GA15035@Krystal> <alpine.DEB.2.00.0906110012060.30552@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906110012060.30552@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:31:14 up 103 days, 13:57,  4 users,  load average: 0.72, 0.98,
	0.97
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 10 Jun 2009, Mathieu Desnoyers wrote:
> 
> > * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > 
> > > > On Wed, 10 Jun 2009, Mathieu Desnoyers wrote:
> > > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > > +The Generic Ring Buffer
> > > > > > +-----------------------
> > > > > > +
> > > > > > +The ring buffer can be used in either an overwrite mode or in
> > > > > > +producer/consumer mode.
> > > > > > +
> > > > > > +Producer/consumer mode is where the producer were to fill up the
> > > > > > +buffer before the consumer could free up anything, the producer
> > > > > > +will stop writing to the buffer. This will lose most recent events.
> > > > > > +
> > > > > > +Overwrite mode is where the produce were to fill up the buffer
> > > > > > +before the consumer could free up anything, the producer will
> > > > > > +overwrite the older data. This will lose the oldest events.
> > > > > > +
> > > > > > +No two writers can write at the same time (on the same per cpu buffer),
> > > > > > +but a writer may preempt another writer, but it must finish writing
> > > > > 
> > > > > Hi Steven,
> > > > > 
> > > > > I would use "interrupt" instead of "preempt" here, given that preemption
> > > > > implies scheduler activity which is specifically forbidden here.
> > > > 
> > > > Good point, I'll update it.
> > > > 
> > > 
> > > Please also look thorough the code... at some places you seem to imply
> > > that the reader "must" be on a remote CPU, when you actually mean
> > > "could" be on a remote or local cpu.
> 
> Yeah, I'll fix up the comments to prevent confusion.
> 
> > > > > > +Nested writes
> > > > > > +-------------
> > > > > > +
> > > > > > +In the pushing forward of the tail page we must first push forward
> > > > > > +the head page if the head page is the next page. If the head page
> > > > > > +is not the next page, the tail page is simply updated with a cmpxchg.
> > > > > > +
> > > > > > +Only writers move the tail page. This must be done atomically to protect
> > > > > > +against nested writers.
> > > > > > +
> > > > > > +  temp_page = tail_page
> > > > > > +  next_page = temp_page->next
> > > > > > +  cmpxchg(tail_page, temp_page, next_page)
> > > > > > +
> > > > > 
> > > > > OK, I'll bite :
> > > > > 
> > > > > What happens if :
> > > > > 
> > > > > - a writer is at the end of a page, 
> > > > > - needs to push the tail_page pointer
> > > > > - reads tail_page
> > > > >   - interrupted.
> > > > >   - nested writers come, successfully updates the tail_page, write
> > > > >     enough data to fill the whole buffer
> > > > >   - concurrently (on another CPU), a reader is consuming all the data
> > > > >   - This brings the tail_page pointer back to its original value
> > > > >   - iret
> > > > > - here, the writer will successfully perform the tail_page cmpxchg,
> > > > >   because the value match. However, the page currently being written to
> > > > >   could be only partially reserved; the writer will not re-check if the
> > > > >   page is really full.
> > > > > 
> > > > > That's actually one of my main concerns with an approach where two
> > > > > separate "pointers" are used to keep track of reserved space within a
> > > > > buffer.
> > > > 
> > > > Actually, the two pointers is exactly what prevents the above scenario.
> > > > 
> > > > We have a commit page pointer and a commit index pointer. The commit page
> > > > points to the page that holds the last true commit. A read can never go 
> > > > pass the commit. That is, it can not read reserved but uncommited data.
> > > > 
> > > 
> > > OK, I see how the commit counter can ensure the reader will not read
> > > reserved-by-yet-uncommitted data.
> > > 
> > > 
> > > > Another key point is that if the tail page meets the commit page, it will 
> > > > not move it and drop the data. If your buffer is not big enough to hold 
> > > > all data in a interrupt, then your buffer is too small. We count these in 
> > > > the "commit_overrun" counter as well as return NULL on the reserve so the 
> > > > tracer will know that it had its data dropped.
> > > > 
> > > 
> > > Ah ok, so the following writer-only scenario :
> > > 
> > > - a writer is at the end of a page, 
> > > - needs to push the tail_page pointer
> > > - reads tail_page
> > >   - interrupted.
> > >   - nested writers come, successfully updates the tail_page, write
> > >     enough data to fill the whole buffer
> > >   - Brings the tail_page pointer back to its original value <----------
> > > 
> > > Cannot happen, because it would meet the commit page.
> > > 
> > > That's a bit weird to drop events in overwrite mode. Normally, one would
> > > expect that mode to just permit to write any amount of events, from any
> > > execution context, be it nested or not, overwriting the oldest events.
> > > 
> > 
> > Hrm, about this specific point, now that I think about it again, LTTng
> > does something similar if nested writes happen to cause a buffer wrap
> > around and meet a non fully committed subbuffer. It will also drop
> > events in overwrite mode.
> > 
> 
> Yeah, and it really should never happen. In my original code I would do a 
> WARN_ON when it did. But I could easily trigger it if I make a two page
> buffer. Which is the default on bootup, until something actually enables 
> ftrace. But the ftrace self tests would use that two page buffer, and it 
> would sometimes cause the warnings.
> 
> > > > 
> > > > > 
> > > > > The same concern applies to moving the head page when concurrent writers
> > > > > are nesting.
> > > > > 
> > > > > More generally, I'm also concerned about the lack of memory barriers
> > > > > around some non-cmpxchg tail/head page set operations in your code, and
> > > > > the lack of proper rcu_dereference-style primitive for list iteration.
> > > > 
> > > > The cmpxchg is a memory barrier. Writes only contend with other writes on 
> > > > the same CPU. When we update the pointer from HEAD to UPDATE a reader will
> > > > not pass that point. The update is done via cmpxchg and thus is a memory 
> > > > barrier. Now if cmpxchg is not a memory barrier, then I need to add 
> > > > smp_mb() by all of them.
> > > > 
> > > 
> > > Documentation/memory-barriers.txt states that cmpxchg must behave as if
> > > it had smp_mb() before and after.
> > > 
> > > > > 
> > > > > For those I've added to CC, I'm referring to the patch at :
> > > > > 
> > > > > http://patchwork.kernel.org/patch/29395/
> > > > > 
> > > > > The great news to me is that no one can say LTTng's lockless buffering
> > > > > algorithm is complex compared to this. ;)
> > > > 
> > > > But can you read without worries about writers? The nice thing about this 
> > > > approach, which a lot of ftrace depends on, is that I don't need call 
> > > > backs or copies to check if what I read from the buffer was not stomped 
> > > > on by a writer. There is a zero copy overhead for readers (when the buffer 
> > > > is more than a page filled) and when a reader has its data, it belongs to 
> > > > that reader.
> > > > 
> > > 
> > > Hrm, now that you bring this question on the table again (I remember we
> > > discussed about it at the collaboration summit), and now that there is
> > > no alcohol involved, I see a way to do it. Here is the idea :
> 
> There may not be alcohol on your end, but speak for yourself ;-)
> 
> I'll look more at what you say here tomorrow.
> 

I agree that, for overwrite mode, having the ability to let the reader
"privatise" its current subbuffer is a very nice thing, especially if
you are doing some live computation on this buffer. For the
post-processing approach LTTng is taking, it does not matter as much
though, given we can detect the subbuffer corruption when doing the
put_subbuf() operation and just trim the output data. However, this
involves a copy (either to disk, to the network or to a separate memory
location) before the data can be considered as consistent in overwrite
mode.

Actually, one much simpler alternative for live buffer read-side
processing in LTTng would be to check the read_offset value after each
event header read and event payload read. This would confirm that the
data is not corrupted. It would be trivial to do, and the copy involved
would only imply sending the event data into the local CPU L1-cache or
registers (very close to zero copy cost). This would imply an added read
memory barrier after each data read, which should not be very costly
neither. This would permit to keep low complexity on the write-side.

Mathieu

P.S.:
There are two elements that would still need to be addressed in the
design presented in my previous mail :

- A first one, simple, involves the fact that the reader should test and
  clear a per-subbuffer flag before reading. The writer should set this
  flag when it produces data into a buffer, so the reader would not
  re-read the subbuffer skipped by the writer until it's populated.
- Taking care of synchronization concerns regarding read_offset and
  write_offset.

So until I have time to spend on this issue (especially the second one),
I'll leave it on the ice (and go back to my thesis). :-)


> -- Steve
> 
> > > 
> > > I assume you remember a bit how the global per-buffer write_offset and
> > > read_offset counters work in LTTng : writer head and reader head are
> > > positions in what we can think of as a virtually contiguous buffer
> > > address space for the whole buffer.
> > > 
> > > First, let's talk in terms of get_subbuf() (reader get a subbuffer
> > > exclusive access for reading) and put_subbuf() (reader releases its
> > > exclusive subbuffer access). get_subbuf() returns the current
> > > read_offset, and put_subbuf() takes this read_offset (the one returned
> > > by get_subbuf()), as parameter.
> > > 
> > > Let's say that we let get_subbuf() use cmpxchg to write a flag in the
> > > read_offset counter to tell the writer it's actively reading, e.g.
> > > OFFSET_READING_FLAG = 0x1. It's reading the read_offset at the same
> > > time because the update is done with a cmpxchg.
> > > 
> > > Now for the writer : in overwrite mode, if the write_offset comes to a
> > > point where it would have to push the reader position (read offset) in
> > > order to be able to reserve space *and* the reader is actively reading
> > > data from the buffer (we know it because OFFSET_READING_FLAG is set),
> > > the writer could set a flag in the read_offset LSBs
> > > (OFFSET_PUSH_FLAG = 0x2). The writer would simply skip over this
> > > specific subbuffer, and that's it : it can continue to write in the
> > > buffer after the subbuffer owned by the reader without problem. If it
> > > loops a few times over the buffer while the reader is still stucked
> > > there (think of a slow serial port), it would simply skip over the
> > > subbuffer owned by the reader.
> > > 
> > > Now, when the reader eventually releases its current subbuffer
> > > (put_subbuf()), it would detect that the read_offset is different than
> > > the one returned by get_subbuf() because the OFFSET_PUSH_FLAG would have
> > > been set. This will inform the reader that it must push its own
> > > read_offset position to the subbuffer following the current
> > > write_offset position. That's it, we're back on track : the next reader
> > > will read the oldest available subbuffer.
> > > 
> > > I took special care in the design above to make sure the case where
> > > tracing starts still works. In this case, where the buffer is only
> > > partially filled, the reader head is not in the subbuffer following the
> > > writer head, because it points to uninitialized data. But the
> > > OFFSET_PUSH_FLAG can only ever be set when a writer has at least
> > > completely filled the buffer once (and meets the read_offset), so we can
> > > consider that it's safe for put_subbuf() to move right after the write
> > > offset subbuffer.
> > > 
> > > I must admit that the flag idea is a bit inspired from your lockless
> > > algo I am currently reviewing. :)
> > > 
> > > Does it make sense ?
> > > 
> > > Mathieu
> > > 
> > > Note : I won't be available for implementation work before July 6th...
> > > got a thesis to write...
> > > 
> > > 
> > > > -- Steve
> > > > 
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
