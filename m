Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbZDBBgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbZDBBgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZDBBga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:36:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbZDBBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:36:29 -0400
Date: Wed, 1 Apr 2009 21:36:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tom Zanussi <tzanussi@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: add run-time field descriptions to
 TRACE_EVENT_FORMAT events
In-Reply-To: <20090401122516.GH12966@elte.hu>
Message-ID: <alpine.DEB.2.00.0904011102421.7942@gandalf.stny.rr.com>
References: <1238390524.6368.64.camel@bookworm> <20090330103808.GB6058@nowhere> <1238474638.10508.51.camel@bookworm> <20090401122516.GH12966@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Apr 2009, Ingo Molnar wrote:

> 
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > > Oh, do you know why these unfiltered event are disappearing?
> > 
> > It's because of the way ring_buffer_discard() currently works - 
> > the filtered events are still there in the ring buffer taking up 
> > space; they just aren't visible in the output because the read 
> > skips over them.
> > 
> > So if there's a high volume of events being recorded, any given 
> > event can be quickly overwritten before it has a chance to be 
> > read, or it may have been read and appeared in the output, but 
> > between the time it was read and the next cat, could easily have 
> > been overwritten, and therefore 'disappears' on the next cat.
> > 
> > It's really no different from the normal case where there is no 
> > filtering in place - the same thing would happen but you wouldn't 
> > notice whether a particular event was still there or not the next 
> > time you cat'ed the file, because of the large volume of events 
> > being displayed. It's just more apparent when most of the events 
> > are discarded and invisible.
> > 
> > At least that's my theory based on my understanding of how the 
> > ring-buffer works...
> 
> Correct, and this needs to be fixed.

The problem is the old performance vs functionality.

The thing is, to help with performance we need to copy directly into the 
ring buffer. The user reserves a location in the ring buffer that is 
guaranteed to not go away until the user commits. We also want to allow 
re-entrant recording into the buffer. But if data has already been 
reservered, it must go after the record:

  ring_buffer_lock_reserve()

     +--------------+
     | some data    |
     +--------------+  <-- pointer returned by ring_buffer_lock_reserve
     | reserved data|
     +--------------+
     | empty        |
     +--------------+

The caller can then write directly into the ring buffer. When they are 
through, the caller would call ring_buffer_unlock_commit which would
do the following.

     +--------------+
     | some data    |
     +--------------+
     | written data |
     +--------------+
     | empty        |
     +--------------+

Now what Tom wants to do is write to that reserve data, test that data and 
then remove it if we do not want it. The problem with this idea is that we 
could have a second write already adding data of its own:



  ring_buffer_lock_reserve()

     +--------------+
     | some data    |
     +--------------+  <-- pointer returned by ring_buffer_lock_reserve
     | reserved data|
     +--------------+
     | empty        |
     +--------------+

Interrupt comes in and reserves and writes data:

     +--------------+
     | some data    |
     +--------------+  <-- pointer returned by ring_buffer_lock_reserve
     | reserved data|
     +--------------+
     | data from    |
     | interrupt    |
     +--------------+
     | empty        |
     +--------------+
 
Now we have a hole in the buffer. If we discard the reserved data it we 
can not reuse it.

Now what I could do, is to add a cmpxchg. If there's no data after the 
data that we want to discard, then we discard it. Note, this can only 
happen before the commit is made.

I'll see if I can implement that.

-- Steve

