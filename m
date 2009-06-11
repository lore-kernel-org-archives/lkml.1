Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbZFKBzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbZFKBzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZFKBzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:55:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbZFKBze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:55:34 -0400
Date: Wed, 10 Jun 2009 21:55:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20090610221304.GA3240@Krystal>
Message-ID: <alpine.DEB.2.00.0906102141410.30552@gandalf.stny.rr.com>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <20090610221304.GA3240@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > +The Generic Ring Buffer
> > +-----------------------
> > +
> > +The ring buffer can be used in either an overwrite mode or in
> > +producer/consumer mode.
> > +
> > +Producer/consumer mode is where the producer were to fill up the
> > +buffer before the consumer could free up anything, the producer
> > +will stop writing to the buffer. This will lose most recent events.
> > +
> > +Overwrite mode is where the produce were to fill up the buffer
> > +before the consumer could free up anything, the producer will
> > +overwrite the older data. This will lose the oldest events.
> > +
> > +No two writers can write at the same time (on the same per cpu buffer),
> > +but a writer may preempt another writer, but it must finish writing
> 
> Hi Steven,
> 
> I would use "interrupt" instead of "preempt" here, given that preemption
> implies scheduler activity which is specifically forbidden here.

Good point, I'll update it.

> 
> > +before the previous writer may continue. This is very important to the
> > +algorithm. The writers act like a "stack".
> > +
> > +
> > +  writer1 start
> > +     <preempted> writer2 start
> > +         <preempted> writer3 start
> > +                     writer3 finishes
> > +                 writer2 finishes
> > +  writer1 finishes
> > +
> > +This is very much like a writer being preempted by an interrupt and
> > +the interrupt doing a write as well.
> > +
> > +Readers can happen at any time. But no two readers may run at the
> > +same time, nor can a reader preempt another reader. A reader can not preempt
> > +a writer, but it may read/consume from the buffer at the same time as
> > +a writer is writing, but the reader must be on another processor.
> > +
> > +A writer can preempt a reader, but a reader can not preempt a writer.
> > +But a reader can read the buffer at the same time (on another processor)
> > +as a writer.
> > +
> 
> This comment is inconsistent with the following code comment :
> 
> "* Reads can happen on any CPU."
> 
> Readers should be allowed to read from their own cpu's buffers too, and
> support being interrupted by an incoming interrupt writer, but this
> design document does not discuss this case. Is it at all supported ? If
> not, then this algorithm would not work on uniprocessor.

Yes it is supported. That's what I mean by "A writer can preempt a 
reader". I'll change it to "A writer can interrupt a reader". Would that 
sound better?

But a reader can not interrupt a writer. I hope you don't plan on doing 
reads of the ring buffer from an interrupt.


> 
> > +The ring buffer is made up of a list of pages held together by a link list.
> > +
> > +At initialization a reader page is allocated for the reader that is not
> > +part of the ring buffer.
> > +
> > +The head_page, tail_page and commit_page are all initialized to point
> > +to the same page.
> > +
> > +The reader page is initialized to have its next pointer pointing to
> > +the head page, and its previous pointer pointing to a page before
> > +the head page.
> > +
> > +The reader has its own page to use. At start up time, this page is
> > +allocated but is not attached to the list. When the reader wants
> > +to read from the buffer, if its page is empty (like it is on start up)
> > +it will swap its page with the head_page. The old reader page will
> > +become part of the ring buffer and the head_page will be removed.
> > +A new head page goes to the page after the old head page (but not
> > +the page that was swapped in).
> > +
> > +Once the new page is given to the reader, the reader could do what
> > +it wants with it, as long as a writer has left that page.
> > +
> > +A sample of how the reader page is swapped: Note this does not
> > +show the head page in the buffer, it is for demonstrating a swap
> > +only.
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |
> > +  +------+
> > +                  +---+   +---+   +---+
> > +                  |   |-->|   |-->|   |
> > +                  |   |<--|   |<--|   |
> > +                  +---+   +---+   +---+
> > +                   ^ |             ^ |
> > +                   | +-------------+ |
> > +                   +-----------------+
> > +
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------------------+
> > +  +------+                   v
> > +    |             +---+   +---+   +---+
> > +    |             |   |-->|   |-->|   |
> > +    |             |   |<--|   |<--|   |<-+
> > +    |             +---+   +---+   +---+  |
> > +    |              ^ |             ^ |   |
> > +    |              | +-------------+ |   |
> > +    |              +-----------------+   |
> > +    +------------------------------------+
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------------------+
> > +  +------+ <---------------+ v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |-->|   |-->|   |
> > +    |  |          |   |<--|   |<--|   |<-+
> > +    |  |          +---+   +---+   +---+  |
> > +    |  |             |             ^ |   |
> > +    |  |             +-------------+ |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> > +
> > +  +------+
> > +  |buffer|          RING BUFFER
> > +  |page  |-------------------+
> > +  +------+ <---------------+ v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |   |   |-->|   |
> > +    |  |  New     |   |   |   |<--|   |<-+
> > +    |  | Reader   +---+   +---+   +---+  |
> > +    |  |  page ----^                 |   |
> > +    |  |                             |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> > +
> 
> Nice ascii art ;)
> 
> Some important comments below,

I draw best with plus's and minus's ;-)

> 
> > +
> > +
> > +It is possible that the page swapped is the commit page and the tail page,
> > +if what is in the ring buffer is less than what is held in a buffer page.
> > +
> > +
> > +          reader page    commit page   tail page
> > +              |              |             |
> > +              v              |             |
> > +             +---+           |             |
> > +             |   |<----------+             |
> > +             |   |<------------------------+
> > +             |   |------+
> > +             +---+      |
> > +                        |
> > +                        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +This case is still legal for this algorithm.
> > +When the writer leaves the page, it simply goes into the ring buffer
> > +since the reader page still points to the next location in the ring
> > +buffer.
> > +
> > +
> > +The main pointers:
> > +
> > +  reader page - The page used solely by the reader and is not part
> > +                of the ring buffer (may be swapped in)
> > +
> > +  head page - the next page in the ring buffer that will be swapped
> > +              with the reader page.
> > +
> > +  tail page - the page where the next write will take place.
> > +
> > +  commit page - the page that last finished a write.
> > +
> > +The commit page only is updated by the outer most writer in the
> > +writer stack. A writer that preempts another writer will not move the
> > +commit page.
> > +
> > +When data is written into the ring buffer, a position is reserved
> > +in the ring buffer and passed back to the writer. When the writer
> > +is finished writing data into that position, it commits the write.
> > +
> > +Another write (or a read) may take place at anytime during this
> > +transaction. If another write happens it must finish before continuing
> > +with the previous write.
> > +
> > +
> > +   Write reserve:
> > +
> > +       Buffer page
> > +      +---------+
> > +      |written  |
> > +      +---------+  <--- given back to writer (current commit)
> > +      |reserved |
> > +      +---------+ <--- tail pointer
> > +      | empty   |
> > +      +---------+
> > +
> > +   Write commit:
> > +
> > +       Buffer page
> > +      +---------+
> > +      |written  |
> > +      +---------+
> > +      |written  |
> > +      +---------+  <--- next positon for write (current commit)
> > +      | empty   |
> > +      +---------+
> > +
> > +
> > + If a write happens after the first reserve:
> > +
> > +       Buffer page
> > +      +---------+
> > +      |written  |
> > +      +---------+  <-- current commit
> > +      |reserved |
> > +      +---------+  <--- given back to second writer
> > +      |reserved |
> > +      +---------+ <--- tail pointer
> > +
> > +  After second writer commits:
> > +
> > +
> > +       Buffer page
> > +      +---------+
> > +      |written  |
> > +      +---------+  <--(last full commit)
> > +      |reserved |
> > +      +---------+
> > +      |pending  |
> > +      |commit   |
> > +      +---------+ <--- tail pointer
> > +
> > +  When the first writer commits:
> > +
> > +       Buffer page
> > +      +---------+
> > +      |written  |
> > +      +---------+
> > +      |written  |
> > +      +---------+
> > +      |written  |
> > +      +---------+  <--(last full commit and tail pointer)
> > +
> > +
> > +The commit pointer points to the last write location that was
> > +committed without preempting another write. When a write that
> > +preempted another write is committed, it only becomes a pending commit
> > +and will not be a full commit till all writes have been committed.
> > +
> > +The commit page points to the page that has the last full commit.
> > +The tail page points to the page with the last write (before
> > +committing).
> > +
> > +The tail page is always equal to or after the commit page. It may
> > +be several pages ahead. If the tail page catches up to the commit
> > +page then no more writes may take place (regardless of the mode
> > +of the ring buffer: overwrite and produce/consumer).
> > +
> > +The order of pages are:
> > +
> > + head page
> > + commit page
> > + tail page
> > +
> > +Possible scenario:
> > +                             tail page
> > +  head page         commit page  |
> > +      |                 |        |
> > +      v                 v        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +There is a special case that the head page is after either the commit page
> > +and possibly the tail page. That is when the commit (and tail) page has been
> > +swapped with the reader page. This is because the head page is always
> > +part of the ring buffer, but the reader page is not. When ever there
> > +has been less than a full page that has been committed inside the ring buffer,
> > +and a reader swaps out a page, it will be swapping out the commit page.
> > +
> > +
> > +          reader page    commit page   tail page
> > +              |              |             |
> > +              v              |             |
> > +             +---+           |             |
> > +             |   |<----------+             |
> > +             |   |<------------------------+
> > +             |   |------+
> > +             +---+      |
> > +                        |
> > +                        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +                        ^
> > +                        |
> > +                    head page
> > +
> > +
> > +In this case, the head page will not move when the tail and commit
> > +move back into the ring buffer.
> > +
> > +The reader can not swap a page into the ring buffer if the commit page
> > +is still on that page. If the read meets the last commit (real commit
> > +not pending or reserved), then there is nothing more to read.
> > +The buffer is considered empty until another full commit finishes.
> > +
> > +When the tail meets the head page, if the buffer is in overwrite mode,
> > +the head page will be pushed ahead one. If the buffer is in producer/consumer
> > +mode, the write will fail.
> > +
> > +Overwrite mode:
> > +
> > +            tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +                        ^
> > +                        |
> > +                    head page
> > +
> > +
> > +            tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +                                 ^
> > +                                 |
> > +                             head page
> > +
> > +
> > +                    tail page
> > +                        |
> > +                        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +                                 ^
> > +                                 |
> > +                             head page
> > +
> > +Note, the reader page will still point to the previous head page.
> > +But when a swap takes place, it will use the most recent head page.
> > +
> > +
> > +Making the Ring Buffer Lockless:
> > +--------------------------------
> > +
> > +The main idea behind the lockless algorithm is to combine the moving
> > +of the head_page pointer with the swapping of pages with the reader.
> > +State flags are placed inside the pointer to the page. To do this,
> > +each page must be aligned in memory by 4 bytes. This will allow the 2
> > +least significant bits of the address to be used as flags. Since
> > +they will always be zero for the address. To get the address,
> > +simply mask out the flags.
> > +
> > +  MASK = ~3
> > +
> > +  address & MASK
> > +
> > +Two flags will be kept by these two bits:
> > +
> > +   HEADER - the page being pointed to is a head page
> > +
> > +   UPDATE - the page being pointed to is being updated by a writer
> > +          and was or is about to be a head page.
> > +
> > +
> > +          reader page
> > +              |
> > +              v
> > +             +---+
> > +             |   |------+
> > +             +---+      |
> > +                        |
> > +                        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-H->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +
> > +The above pointer "-H->" would have the HEADER flag set. That is
> > +the next page is the next page to be swapped out by the reader.
> > +This pointer means the next page is the head page.
> > +
> > +When the tail page meets the head pointer, it will use cmpxchg to
> > +change the pointer to the UPDATE state:
> > +
> > +
> > +            tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-H->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +            tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-U->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +"-U->" represents a pointer in the UPDATE state.
> > +
> > +Any access to the reader will need to take some sort of lock to serialize
> > +the readers. But the writers will never take a lock to write to the
> > +ring buffer. This means we only need to worry about a single reader,
> > +and writes only preempt in "stack" formation.
> > +
> > +When the reader tries to swap the page with the ring buffer, it
> > +will also use cmpxchg. If the flag bit in the pointer to the
> > +head page does not have the HEADER flag set, the compare will fail
> > +and the reader will need to look for the new head page and try again.
> > +Note, the flag UPDATE and HEADER are never set at the same time.
> > +
> > +The reader swaps the reader page as follows:
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |
> > +  +------+
> > +                  +---+    +---+    +---+
> > +                  |   |--->|   |--->|   |
> > +                  |   |<---|   |<---|   |
> > +                  +---+    +---+    +---+
> > +                   ^ |               ^ |
> > +                   | +---------------+ |
> > +                   +-----H-------------+
> > +
> > +The reader sets the reader page next pointer as HEADER to the page after
> > +the head page.
> > +
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------H-----------+
> > +  +------+                   v
> > +    |             +---+    +---+    +---+
> > +    |             |   |--->|   |--->|   |
> > +    |             |   |<---|   |<---|   |<-+
> > +    |             +---+    +---+    +---+  |
> > +    |              ^ |               ^ |   |
> > +    |              | +---------------+ |   |
> > +    |              +-----H-------------+   |
> > +    +--------------------------------------+
> > +
> > +It does a cmpxchg with the pointer to the previous head page to make it
> > +point to the reader page. Note that the new pointer does not have the HEADER
> > +flag set.  This action atomically moves the head page forward.
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------H-----------+
> > +  +------+ <---------------+ v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |-->|   |-->|   |
> > +    |  |          |   |<--|   |<--|   |<-+
> > +    |  |          +---+   +---+   +---+  |
> > +    |  |             |             ^ |   |
> > +    |  |             +-------------+ |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> > +
> > +After the new head page is set, the previous pointer of the head page is
> > +updated to the reader page.
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------H-----------+
> > +  +------+                   v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |-->|   |-->|   |
> > +    |  |          |   |<--|   |<--|   |<-+
> > +    |  |          +---+   +---+   +---+  |
> > +    |  |             |             ^ |   |
> > +    |  |             +-------------+ |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> > +
> > +  +------+
> > +  |buffer|          RING BUFFER
> > +  |page  |-------H-----------+  <--- New head page
> > +  +------+ <---------------+ v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |   |   |-->|   |
> > +    |  |  New     |   |   |   |<--|   |<-+
> > +    |  | Reader   +---+   +---+   +---+  |
> > +    |  |  page ----^                 |   |
> > +    |  |                             |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> > +
> > +Another important point. The page that the reader page points back to
> > +by its previous pointer (the one that now points to the new head page)
> > +never points back to the reader page. That is because the reader page is
> > +not part of the ring buffer. Traversing the ring buffer via the next pointers
> > +will always stay in the ring buffer. Traversing the ring buffer via the
> > +prev pointers may not.
> > +
> > +Note, the way to determine a reader page is simply by examining the previous
> > +pointer of the page. If the next pointer of the previous page does not
> > +point back to the original page, then the original page is a reader page:
> > +
> > +                                  
> > +             +--------+
> > +             | reader |  next   +----+
> > +             |  page  |-------->|    |<====== (buffer page)
> > +             +--------+         +----+
> > +                 |                | ^
> > +                 |                v | next
> > +            prev |              +----+
> > +                 +------------->|    |
> > +                                +----+
> > +
> > +The way the head page moves forward:
> > +
> > +When the tail page meets the head page and the buffer is in overwrite mode
> > +and more writes take place, the head page must be moved forward before the
> > +writer may move the tail page. The way this is done is that the writer
> > +performs a cmpxchg to convert the pointer to the head page from the HEADER
> > +flag to have the UPDATE flag set. Once this is done, the reader will
> > +not be able to swap the head page from the buffer, nor will it be able to
> > +move the head page, until the writer is finished with the move.
> > +
> > +This eliminates any races that the reader can have on the writer. The reader
> > +must spin, and this is why the reader can not preempt the writer.
> > +
> > +            tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-H->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +            tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-U->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +The following page will be made into the new head page.
> > +
> > +           tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-U->|   |-H->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +After the new head page has been set, we can set the old head page
> > +pointer back to NORMAL.
> > +
> > +           tail page
> > +               |
> > +               v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |-H->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +After the head page has been moved, the tail page may now move forward.
> > +
> > +                    tail page
> > +                        |
> > +                        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |--->|   |-H->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +
> > +
> > +The above are the trivial updates. Now for the more complex scenarios.
> > +
> > +
> > +As stated before, if enough writes preempt the first write, the
> > +tail page may make it all the way around the buffer and meet the commit
> > +page. At this time, we must start dropping writes (usually with some kind
> > +of warning to the user). But what happens if the commit was still on the
> > +reader page? The commit page is not part of the ring buffer. The tail page
> > +must account for this.
> > +
> > +
> > +          reader page    commit page
> > +              |              |
> > +              v              |
> > +             +---+           |
> > +             |   |<----------+
> > +             |   |
> > +             |   |------+
> > +             +---+      |
> > +                        |
> > +                        v
> > +    +---+    +---+    +---+    +---+
> > +<---|   |--->|   |-H->|   |--->|   |--->
> > +--->|   |<---|   |<---|   |<---|   |<---
> > +    +---+    +---+    +---+    +---+
> > +               ^
> > +               |
> > +           tail page
> > +
> > +If the tail page were to simply push the head page forward, the commit when
> > +leaving the reader page would not be pointing to the correct page.
> > +
> > +The solution to this is to test if the commit page is on the reader page
> > +before pushing the head page. If it is, then it can be assumed that the
> > +tail page wrapped the buffer, and we must drop new writes.
> > +
> > +This is not a race condition, because the commit page can only be moved
> > +by the outter most writer (the writer that was preempted).
> > +This means that the commit will not move while a writer is moving the
> > +tail page. The reader can not swap the reader page if it is also being
> > +used as the commit page. The reader can simply check that the commit
> > +is off the reader page. Once the commit page leaves the reader page
> > +it will never go back on it unless a reader does another swap with the
> > +buffer page that is also the commit page.
> > +
> > +
> > +Nested writes
> > +-------------
> > +
> > +In the pushing forward of the tail page we must first push forward
> > +the head page if the head page is the next page. If the head page
> > +is not the next page, the tail page is simply updated with a cmpxchg.
> > +
> > +Only writers move the tail page. This must be done atomically to protect
> > +against nested writers.
> > +
> > +  temp_page = tail_page
> > +  next_page = temp_page->next
> > +  cmpxchg(tail_page, temp_page, next_page)
> > +
> 
> OK, I'll bite :
> 
> What happens if :
> 
> - a writer is at the end of a page, 
> - needs to push the tail_page pointer
> - reads tail_page
>   - interrupted.
>   - nested writers come, successfully updates the tail_page, write
>     enough data to fill the whole buffer
>   - concurrently (on another CPU), a reader is consuming all the data
>   - This brings the tail_page pointer back to its original value
>   - iret
> - here, the writer will successfully perform the tail_page cmpxchg,
>   because the value match. However, the page currently being written to
>   could be only partially reserved; the writer will not re-check if the
>   page is really full.
> 
> That's actually one of my main concerns with an approach where two
> separate "pointers" are used to keep track of reserved space within a
> buffer.

Actually, the two pointers is exactly what prevents the above scenario.

We have a commit page pointer and a commit index pointer. The commit page
points to the page that holds the last true commit. A read can never go 
pass the commit. That is, it can not read reserved but uncommited data.

Another key point is that if the tail page meets the commit page, it will 
not move it and drop the data. If your buffer is not big enough to hold 
all data in a interrupt, then your buffer is too small. We count these in 
the "commit_overrun" counter as well as return NULL on the reserve so the 
tracer will know that it had its data dropped.


> 
> The same concern applies to moving the head page when concurrent writers
> are nesting.
> 
> More generally, I'm also concerned about the lack of memory barriers
> around some non-cmpxchg tail/head page set operations in your code, and
> the lack of proper rcu_dereference-style primitive for list iteration.

The cmpxchg is a memory barrier. Writes only contend with other writes on 
the same CPU. When we update the pointer from HEAD to UPDATE a reader will
not pass that point. The update is done via cmpxchg and thus is a memory 
barrier. Now if cmpxchg is not a memory barrier, then I need to add 
smp_mb() by all of them.

> 
> For those I've added to CC, I'm referring to the patch at :
> 
> http://patchwork.kernel.org/patch/29395/
> 
> The great news to me is that no one can say LTTng's lockless buffering
> algorithm is complex compared to this. ;)

But can you read without worries about writers? The nice thing about this 
approach, which a lot of ftrace depends on, is that I don't need call 
backs or copies to check if what I read from the buffer was not stomped 
on by a writer. There is a zero copy overhead for readers (when the buffer 
is more than a page filled) and when a reader has its data, it belongs to 
that reader.

-- Steve

