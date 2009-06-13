Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbZFMWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbZFMWgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZFMWgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:36:43 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59877 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZFMWgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LDEMtLGqiCE6NoOzXvqpXG6XpBXWhHppIfMw8T7X7hHgODjbkxoMeSFnqCLtivNC4w
         IBwuZHNL6Iij4kxYjKqsoLpR07gv7NYOswEJKmDxqUGbaYNyN18gjxJFSkgwtiSPU0Gg
         7LI/6UbxpzDkYk54+SMoJaSiMy2jeX29hCbIY=
Date: Sun, 14 Jun 2009 00:36:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
Message-ID: <20090613223636.GB5986@nowhere>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <20090613015410.GB5234@nowhere> <alpine.DEB.2.00.0906122203100.16299@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906122203100.16299@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:16:45PM -0400, Steven Rostedt wrote:
> 
> On Sat, 13 Jun 2009, Frederic Weisbecker wrote:
> 
> > On Wed, Jun 10, 2009 at 03:53:14PM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > This adds the design document for the ring buffer and also
> > > explains how it is designed to have lockless writes.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  Documentation/trace/ring-buffer-design.txt |  949 ++++++++++++++++++++++++++++
> > >  1 files changed, 949 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/trace/ring-buffer-design.txt
> > > 
> > > diff --git a/Documentation/trace/ring-buffer-design.txt b/Documentation/trace/ring-buffer-design.txt
> > > new file mode 100644
> > > index 0000000..cca290b
> > > --- /dev/null
> > > +++ b/Documentation/trace/ring-buffer-design.txt
> > > @@ -0,0 +1,949 @@
> > > +		Lockless Ring Buffer Design
> > > +		===========================
> > > +
> > > +Copyright 2009 Red Hat Inc.
> > > +   Author:   Steven Rostedt <srostedt@redhat.com>
> > > +  License:   The GNU Free Documentation License, Version 1.2
> > > +               (dual licensed under the GPL v2)
> > > +
> > > +Written for: 2.6.31
> > > +
> > > +Terminology used in this Document
> > > +---------------------------------
> > > +
> > > +tail - where new writes happen in the ring buffer.
> > > +
> > > +head - where new reads happen in the ring buffer.
> > > +
> > > +producer - the task that writes into the ring buffer (same as writer)
> > > +
> > > +writer - same as producer
> > > +
> > > +consumer - the task that reads from the buffer (same as reader)
> > > +
> > > +reader - same as consumer.
> > > +
> > > +reader_page - A page outside the ring buffer used solely (for the most part)
> > > +    by the reader.
> > > +
> > > +head_page - a pointer to the page that the reader will use next
> > > +
> > > +tail_page - a pointer to the page that will be written to next
> > > +
> > > +commit_page - a pointer to the page with the last finished non nested write.
> > > +
> > > +cmpxchg - hardware assisted atomic transaction that performs the following:
> > > +
> > > +   A = B iff previous A == C
> > > +
> > > +   R = cmpxchg(A, C, B) is saying that we replace A with B if and only if
> > > +      current A is equal to C, and we put the old (current) A into R
> > > +
> > > +   R gets the previous A regardless if A is updated with B or not.
> > > +
> > > +   To see if the update was successful a compare of R == C may be used.
> > > +
> > > +The Generic Ring Buffer
> > > +-----------------------
> > > +
> > > +The ring buffer can be used in either an overwrite mode or in
> > > +producer/consumer mode.
> > > +
> > > +Producer/consumer mode is where the producer were to fill up the
> > > +buffer before the consumer could free up anything, the producer
> > > +will stop writing to the buffer. This will lose most recent events.
> > > +
> > > +Overwrite mode is where the produce were to fill up the buffer
> > > +before the consumer could free up anything, the producer will
> > > +overwrite the older data. This will lose the oldest events.
> > > +
> > > +No two writers can write at the same time (on the same per cpu buffer),
> > > +but a writer may preempt another writer, but it must finish writing
> > > +before the previous writer may continue. This is very important to the
> > > +algorithm. The writers act like a "stack".
> > > +
> > > +
> > > +  writer1 start
> > > +     <preempted> writer2 start
> > > +         <preempted> writer3 start
> > > +                     writer3 finishes
> > > +                 writer2 finishes
> > > +  writer1 finishes
> > > +
> > > +This is very much like a writer being preempted by an interrupt and
> > > +the interrupt doing a write as well.
> > > +
> > > +Readers can happen at any time. But no two readers may run at the
> > > +same time, nor can a reader preempt another reader. A reader can not preempt
> > > +a writer, but it may read/consume from the buffer at the same time as
> > > +a writer is writing, but the reader must be on another processor.
> > > +
> > > +A writer can preempt a reader, but a reader can not preempt a writer.
> > > +But a reader can read the buffer at the same time (on another processor)
> > > +as a writer.
> > > +
> > > +The ring buffer is made up of a list of pages held together by a link list.
> > > +
> > > +At initialization a reader page is allocated for the reader that is not
> > > +part of the ring buffer.
> > > +
> > > +The head_page, tail_page and commit_page are all initialized to point
> > > +to the same page.
> > > +
> > > +The reader page is initialized to have its next pointer pointing to
> > > +the head page, and its previous pointer pointing to a page before
> > > +the head page.
> > > +
> > > +The reader has its own page to use. At start up time, this page is
> > > +allocated but is not attached to the list. When the reader wants
> > > +to read from the buffer, if its page is empty (like it is on start up)
> > > +it will swap its page with the head_page. The old reader page will
> > > +become part of the ring buffer and the head_page will be removed.
> > > +A new head page goes to the page after the old head page (but not
> > > +the page that was swapped in).
> > 
> > 
> > 
> > I wonder if you could reformulate this last sentence. It took me
> > some time to understand it.
> 
> Yuck, that last sentence is ugly.
> 
> > 
> > 
> > I first understood it as:
> > 
> > """
> > A new page which comes from nowhere is
> > going to become a (and not "the") head page. Moreover, it will
> > be pointed by old_head_page->next...(which is actually true btw),
> > but this new head page will not be the next pointer on the page
> > that has just been swapped in.
> > """
> > 
> > Well, actually may be it's because my english understanding is a bit....
> 
> No, I think I wrote that at 3am.
> 
> How about this:
> 
> "The page after the inserted page (old reader_page) will become the new 
> head page."
> 
> ?


Perfect!

 
> > 
> > 
> > 
> > > +
> > > +Once the new page is given to the reader, the reader could do what
> > > +it wants with it, as long as a writer has left that page.
> > > +
> 
> 
> 
> > > +A sample of how the reader page is swapped: Note this does not
> > > +show the head page in the buffer, it is for demonstrating a swap
> > > +only.
> 
> Note above.
> 
> 
> > > +
> > > +  +------+
> > > +  |reader|          RING BUFFER
> > > +  |page  |
> > > +  +------+
> > > +                  +---+   +---+   +---+
> > > +                  |   |-->|   |-->|   |
> > > +                  |   |<--|   |<--|   |
> > > +                  +---+   +---+   +---+
> > > +                   ^ |             ^ |
> > > +                   | +-------------+ |
> > > +                   +-----------------+
> > 
> > 
> > 
> > But may be you could also show the head page at the same time,
> > that would help the readers IMO (not those on the ring buffer,
> > but at least those from real life who can preempt several things..)
> 
> I could add the H, but I just wanted to concentrate on the swap without 
> having too many details. But if you think the H would help, I'm fine with 
> it.
> 


You're right. It's better to only keep the page swapping picture. The
header page is explained just after anyway.


> > 
> > 
> >   +------+
> >   |reader|          RING BUFFER
> >   |page  |
> >   +------+
> >                   +---+   +---+   +---+
> >                   |   |-->|   |-->|   |
> >                   | H |<--|   |<--|   |
> >                   +---+   +---+   +---+
> >                    ^ |             ^ |
> >                    | +-------------+ |
> >                    +-----------------+
> > 
> > 
> > 
> > 
> > > +
> > > +  +------+
> > > +  |reader|          RING BUFFER
> > > +  |page  |-------------------+
> > > +  +------+                   v
> > > +    |             +---+   +---+   +---+
> > > +    |             |   |-->|   |-->|   |
> > > +    |             |   |<--|   |<--|   |<-+
> > > +    |             +---+   +---+   +---+  |
> > > +    |              ^ |             ^ |   |
> > > +    |              | +-------------+ |   |
> > > +    |              +-----------------+   |
> > > +    +------------------------------------+
> > 
> > 
> > 
> >   +------+
> >   |reader|          RING BUFFER
> >   |page  |-------------------+
> >   +------+                   v
> >     |             +---+   +---+   +---+
> >     |             |   |-->|   |-->|   |
> >     |             | H |<--|   |<--|   |<-+
> >     |             +---+   +---+   +---+  |
> >     |              ^ |             ^ |   |
> >     |              | +-------------+ |   |
> >     |              +-----------------+   |
> >     +------------------------------------+
> > 
> > 
> > 
> > > +  +------+
> > > +  |reader|          RING BUFFER
> > > +  |page  |-------------------+
> > > +  +------+ <---------------+ v
> > > +    |  ^          +---+   +---+   +---+
> > > +    |  |          |   |-->|   |-->|   |
> > > +    |  |          |   |<--|   |<--|   |<-+
> > > +    |  |          +---+   +---+   +---+  |
> > > +    |  |             |             ^ |   |
> > > +    |  |             +-------------+ |   |
> > > +    |  +-----------------------------+   |
> > > +    +------------------------------------+
> > 
> > 
> > 
> >   +------+
> >   |reader|          RING BUFFER
> >   |page  |-------------------+
> >   +------+ <---------------+ v
> >     |  ^          +---+   +---+   +---+
> >     |  |          |   |-->|   |-->|   |
> >     |  |          | H |<--|   |<--|   |<-+
> >     |  |          +---+   +---+   +---+  |
> >     |  |             |             ^ |   |
> >     |  |             +-------------+ |   |
> >     |  +-----------------------------+   |
> >     +------------------------------------+
> 
> Oooh, you cut and paste the error in the above. Do you see it?



Yeah but I was too lazy to fix it, and the mistake has already
been reported :)



> > 
> > 
> > 
> > 
> > > +  +------+
> > > +  |buffer|          RING BUFFER
> > > +  |page  |-------------------+
> > > +  +------+ <---------------+ v
> > > +    |  ^          +---+   +---+   +---+
> > > +    |  |          |   |   |   |-->|   |
> > > +    |  |  New     |   |   |   |<--|   |<-+
> > > +    |  | Reader   +---+   +---+   +---+  |
> > > +    |  |  page ----^                 |   |
> > > +    |  |                             |   |
> > > +    |  +-----------------------------+   |
> > > +    +------------------------------------+
> > > +
> > 
> > 
> > 
> >   +------+
> >   |buffer|          RING BUFFER
> >   |page  |-------------------+
> >   +------+ <---------------+ v
> >     |  ^          +---+   +---+   +---+
> >     |  |          |   |   |   |-->|   |
> >     |  |  New     |   |   | H |<--|   |<-+
> >     |  | Reader   +---+   +---+   +---+  |
> >     |  |  page ----^                 |   |
> >     |  |                             |   |
> >     |  +-----------------------------+   |
> >     +------------------------------------+
> > 
> > 
> > Sorry it was too tempting to try out some ascii art too,
> > but also it's an occasion to tell me if I misunderstood something
> > about the head page.
> 
> Yeah, the above seems correct (except for the error you left in).
> 
> > 
> > 
> > > +
> > > +It is possible that the page swapped is the commit page and the tail page,
> > > +if what is in the ring buffer is less than what is held in a buffer page.
> > > +
> > > +
> > > +          reader page    commit page   tail page
> > > +              |              |             |
> > > +              v              |             |
> > > +             +---+           |             |
> > > +             |   |<----------+             |
> > > +             |   |<------------------------+
> > > +             |   |------+
> > > +             +---+      |
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |--->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +This case is still legal for this algorithm.
> > > +When the writer leaves the page, it simply goes into the ring buffer
> > > +since the reader page still points to the next location in the ring
> > > +buffer.
> > > +
> > > +
> > > +The main pointers:
> > > +
> > > +  reader page - The page used solely by the reader and is not part
> > > +                of the ring buffer (may be swapped in)
> > > +
> > > +  head page - the next page in the ring buffer that will be swapped
> > > +              with the reader page.
> > > +
> > > +  tail page - the page where the next write will take place.
> > > +
> > > +  commit page - the page that last finished a write.
> > > +
> > > +The commit page only is updated by the outer most writer in the
> > > +writer stack. A writer that preempts another writer will not move the
> > > +commit page.
> > 
> > 
> > 
> > Btw, how do you check that? Is there a nesting counter or something?
> 
> Because only the writer that reserves the pointer after the commit, is the 
> committer.
> 
> static int
> rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
>              struct ring_buffer_event *event)
> {
>         unsigned long addr = (unsigned long)event;
>         unsigned long index;
> 
>         index = rb_event_index(event);
>         addr &= PAGE_MASK;
> 
>         return cpu_buffer->commit_page->page == (void *)addr &&
>                 rb_commit_index(cpu_buffer) == index;
> }
> 
> 
> Although, I'm thinking of replacing it with a counter. May eliminate some 
> of the tight races I need to prevent. And may even clean up the code, and 
> speed it up.
> 
> Hmm, I may implement that now.
> 


Yeah it should be sufficient I guess.



> > 
> > 
> > 
> > > +
> > > +When data is written into the ring buffer, a position is reserved
> > > +in the ring buffer and passed back to the writer. When the writer
> > > +is finished writing data into that position, it commits the write.
> > > +
> > > +Another write (or a read) may take place at anytime during this
> > > +transaction. If another write happens it must finish before continuing
> > > +with the previous write.
> > 
> > 
> > [...]
> > 
> > 
> > > +Nested writes
> > > +-------------
> > > +
> > > +In the pushing forward of the tail page we must first push forward
> > > +the head page if the head page is the next page. If the head page
> > > +is not the next page, the tail page is simply updated with a cmpxchg.
> > > +
> > > +Only writers move the tail page. This must be done atomically to protect
> > > +against nested writers.
> > > +
> > > +  temp_page = tail_page
> > > +  next_page = temp_page->next
> > > +  cmpxchg(tail_page, temp_page, next_page)
> > > +
> > > +The above will update the tail page if it is still pointing to the expected
> > > +page. If this fails, a nested write pushed it forward, the the current write
> > > +does not need to push it.
> > > +
> > > +
> > > +           temp page
> > > +               |
> > > +               v
> > > +            tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |--->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +Nested write comes in and moves the tail page forward:
> > > +
> > > +                    tail page (moved by nested writer)
> > > +            temp page   |
> > > +               |        |
> > > +               v        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |--->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +The above would fail the cmpxchg, but since the tail page has already
> > > +been moved forward, the writer will just try again to reserve storage
> > > +on the new tail page.
> > > +
> > > +But the moving of the head page is a bit more complex.
> > > +
> > > +            tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-H->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +The write converts the head page pointer to UPDATE.
> > > +
> > > +            tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +But if a nested writer preempts here. It will see that the next
> > > +page is a head page, but it is also nested. It will detect that
> > > +it is nested and will save that information. The detection is the
> > > +fact that it sees the UPDATE flag instead of a HEADER or NORMAL
> > > +pointer.
> > > +
> > > +The nested writer will set the new head page pointer.
> > > +
> > > +           tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-H->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +But it will not reset the update back to normal. Only the writer
> > > +that converted a pointer from HEAD to UPDATE will convert it back
> > > +to NORMAL.
> > > +
> > > +                    tail page
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-H->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +After the nested writer finishes, the outer most writer will convert
> > > +the UPDATE pointer to NORMAL.
> > > +
> > > +
> > > +                    tail page
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |--->|   |-H->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +
> > > +It can be even more complex if several nested writes came in and moved
> > > +the tail page ahead several pages:
> > > +
> > > +
> > > +(first writer)
> > > +
> > > +            tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-H->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +The write converts the head page pointer to UPDATE.
> > > +
> > > +            tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |--->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +Next writer comes in, and sees the update and sets up the new
> > > +head page.
> > > +
> > > +(second writer)
> > > +
> > > +           tail page
> > > +               |
> > > +               v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-H->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +The nested writer moves the tail page forward. But does not set the old
> > > +update page to NORMAL because it is not the outer most writer.
> > > +
> > > +                    tail page
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-H->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +Another writer preempts and sees the page after the tail page is a head page.
> > > +It changes it from HEAD to UPDATE.
> > > +
> > > +(third writer)
> > > +
> > > +                    tail page
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-U->|   |--->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +The writer will move the head page forward:
> > > +
> > > +
> > > +(third writer)
> > > +
> > > +                    tail page
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-U->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +But now that the third writer did change the HEAD flag to UPDATE it
> > > +will convert it to normal:
> > > +
> > > +
> > > +(third writer)
> > > +
> > > +                    tail page
> > > +                        |
> > > +                        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |--->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +
> > > +Then it will move the tail page, and return back to the second writer.
> > > +
> > > +
> > > +(second writer)
> > > +
> > > +                             tail page
> > > +                                 |
> > > +                                 v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |--->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +
> > > +The second writer will fail to move the tail page because it was already
> > > +moved, so it will try again and add its data to the new tail page.
> > > +It will return to the first writer.
> > > +
> > > +
> > > +(first writer)
> > > +
> > > +                             tail page
> > > +                                 |
> > > +                                 v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |--->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +The first writer can not know atomically test if the tail page moved
> > > +while it updates the HEAD page. It will then update the head page to
> > > +what it thinks is the new head page.
> > > +
> > > +
> > > +(first writer)
> > > +
> > > +                             tail page
> > > +                                 |
> > > +                                 v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-H->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +Since the cmpxchg returns the old value of the pointer the first writer
> > > +will see it succeeded in updating the pointer from NORMAL to HEAD.
> > > +But as we can see, this is not good enough. It must also check to see
> > > +if the tail page is either where it use to be or on the next page:
> > > +
> > > +
> > > +(first writer)
> > > +
> > > +               A        B    tail page
> > > +               |        |        |
> > > +               v        v        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |-H->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +If tail page != A and tail page does not equal B, then it must reset the
> > > +pointer back to NORMAL. The fact that it only needs to worry about
> > > +nested writers, it only needs to check this after setting the HEAD page.
> > > +
> > > +
> > > +(first writer)
> > > +
> > > +               A        B    tail page
> > > +               |        |        |
> > > +               v        v        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |-U->|   |--->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > > +
> > > +Now the writer can update the head page. This is also why the head page must
> > > +remain in UPDATE and only reset by the outer most writer. This prevents
> > > +the reader from seeing the incorrect head page.
> > > +
> > > +
> > > +(first writer)
> > > +
> > > +               A        B    tail page
> > > +               |        |        |
> > > +               v        v        v
> > > +    +---+    +---+    +---+    +---+
> > > +<---|   |--->|   |--->|   |--->|   |-H->
> > > +--->|   |<---|   |<---|   |<---|   |<---
> > > +    +---+    +---+    +---+    +---+
> > 
> > 
> > Even more tricky!
> > 
> > I just have a stupid question: why can't this be done
> > only through HEAD and NORMAL flags?
> > 
> > There is something certainly very obvious that I'm missing
> > with the point of the UPDATE flag.
> 
> If you can demonstrate how to do the above lockless with just HEAD and 
> NORMAL, then sure, I'm all ears ;-)
> 
> When we switch the HEAD to UPDATE, we stop the reader from moving forward 
> and being another thing to handle while we move the HEAD forward. A reader 
> does a cmpxchg to move the head too, and that cmpxchg will always fail if 
> the pointer is has UPDATE set. The reader will just spin until it 
> succeeds.


Aah, so it's here to protect against paralell readers from another cpu
reading the current cpu buffer, right?


> Then, the rest of the moving of the header is just races with other 
> writers that are always on the same CPU, and it becomes a recursive 
> problem and not a parallel one.
> 
> -- Steve
> 

