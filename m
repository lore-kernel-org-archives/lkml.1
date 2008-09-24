Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYIXQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYIXQOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYIXQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:13:51 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:38795 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbYIXQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:13:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAHID2khMQWq+/2dsb2JhbACBXrtqgWU
Date: Wed, 24 Sep 2008 12:13:47 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Martin Bligh <mbligh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080924161347.GA31451@Krystal>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:55:55 up 111 days, 20:36,  8 users,  load average: 0.43, 0.60,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Bligh (mbligh@google.com) wrote:
> Thanks for creating this so quickly ;-)
> 
> >> We can record either the fast way of reserving a part of the buffer:
> >>
> >> event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
> >> event->data = record_this_data;
> >> ring_buffer_unlock_commit(buffer, event, flags);
> >
> > This can, in generic, not work. Due to the simple fact that we might
> > straddle a page boundary. Therefore I think its best to limit our self
> > to the write interface below, so that it can handle that.
> 
> I'm not sure why this is any harder to deal with in write, than it is
> in reserve? We should be able to make reserve handle this just
> as well?
> 
> If you use write rather than reserve, you have to copy all the data
> twice for every event.
> 

I think we all agree that a supplementary copy is no wanted, but I think
this question is orthogonal to having a write wrapper. The way we can do
both is by using reserve/commit to deal with space reservation, and a
write() to perform the actual data write into the buffers once space has
been reserved.

Reserve/commit would allocate a variable-sized "slot" into the buffer.
We reserve X amount of bytes, and it returns the offset from the
buffer start where the allocated slot is. This reserve/commit mechanism
deals with synchronization (cli/spinlock or cmpxchg_local scheme...).

We can then use this offset to see in which page(s) we have to write.
This offset + len can in fact cross multiple page boundaries.

Doing this elegantly could involve a page array that would represent the
buffer data :

struct page **buffer;

And be given as parameter to the read() and write() methods, which would
deal with page-crossing.

e.g.

/*
 * Perform an aligned write of the input data into the buffer.
 *
 * buffer : page pointer array
 * woffset : offset in the page pointer array where write starts from
 * data : input data
 * len : length of data to copy
 *
 * Note : if a NULL buffer is passed, no copy is performed, but the
 * alignment and offset calculation is done. Useful to calculate the
 * size to reserve.
 *
 * return : length written
 */
size_t write(struct page **buffer, size_t woffset, void *data, size_t len);

Therefore, we could have code which writes in the buffers, without extra
copy, and without using vmap, in multiple writes for a single event,
which would deal with data alignment, e.g. :

size_t woffset, evsize = 0;

evsize += write(NULL, evsize, &var1, sizeof(var1));
evsize += write(NULL, evsize, &var2, sizeof(var2));
evsize += write(NULL, evsize, &var3, sizeof(var3));

woffset = reserve(..., evsize);

woffset += write(buffer, woffset, &var1, sizeof(var1));
woffset += write(buffer, woffset, &var2, sizeof(var2));
woffset += write(buffer, woffset, &var3, sizeof(var3));

commit(..., evsize);

Does that make sense ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
