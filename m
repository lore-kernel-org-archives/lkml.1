Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbZI3QCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbZI3QCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZI3QCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:02:50 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:42227 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754557AbZI3QCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:02:49 -0400
Date: Wed, 30 Sep 2009 10:02:32 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20090930160232.GZ22310@obsidianresearch.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930094456.GD24621@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:44:56AM +0200, Ingo Molnar wrote:
> > > OK.  It would be nice to tie into something more general, but I 
> > > think I agree -- perf counters are missing the filtering and the "no 
> > > lost events" that ummunotify does have. [...]
> 
> Performance events filtering is being worked on and now with the proper 
> non-DoS limit you've added you can lose events too, dont you? So it's 
> all a question of how much buffering to add - and with perf events too 
> you can buffer arbitrary large amount of events.

No, the ummunotify does not loose events, that is the fundamental
difference between it and all tracing schemes.

Every call to ibv_reg_mr is paired with a call to ummunotify to create
a matching watcher. Both calls allocate some kernel memory, if one
fails the entire operation fails and userspace can do whatever it does
on memory allocation failure.

After that point the scheme is perfectly lossless.

Performance event filtering would use the same kind of kernel memory,
call ibv_reg_mr, then install a filter, both allocate kernel memory,
if one fails the op fails. But then when the ring buffer overflows
you've lost events.

All the tracing schemes are lossy - since they loose events when the
ring buffer fills up. So to do that we either need to make a recovery
scheme of some sort, or make trace points that are blocking..

So, here is a concrete proposal how ummunotify could be absorbed by
perf events tracing, with filters.
- The filter expression must be able to trigger on a MMU event,
  triggering on the intersection of the MMU event address range and
  filter expression address range.
- The traces must be choosen so that there is exactly one filter
  expression per ibv_reg_mr region
- Each filter has a clearable saturating counter that increments every
  time the filter matches an event
- Each filter has a 64 bit user space assigned tag.
- An API similar to ummunotify exists:
     struct perf_filter_tag foo[100]
     int rc = perf_filters_read_and_clear_non_zero_counters(foo,100);
- Optionally - the mmap ring would contain only 64 bit user space
  filter tags, not trace events.

This would then duplicate the functions of ummunotify, including the
lossless collection of events. The flow would more or less be the
same:

 struct my_data *ptr = calloc()
 ptr->reg_handle = ibv_reg_mr(base,len)
 ptr->filter_handle = perf_filter_register("string matching base->len",ptr)

 [..]
 // fast path
 if (atomically(perf_map->head) != last_perf_map_head) {
     struct perf_filter_tag foo[100]
     int rc = perf_filters_read_and_clear_non_zero_counters(foo,100);
     for (unsigned int i = 0; i != rc; i++)
         ((struct my_data *)foo[i])->invalid = 1;

     perf_empty_mmap_ring(perf_map);
 }

If 'optionally' is done then the app can trundle through the mmap
and only use the above syscall loop if the mmap overflows. That would
be quite ideal.

It also must be guarenteed that when a trace point is hit the mmap
atomics are updated and visible to another user space thread before
the trace point returns - otherwise it is not synchronous enough and
will be racey.

> A question: what is the typical size/scope of the rbtree of the watched 
> regions of memory in practical (test) deployments of the ummunofity 
> code?

Jeff can you comment?

IIRC it is many tens (hundreds?) of thousands of watches.

> Per tracepoint filtering is possible via the perf event patches Li Zefan 
> has posted to lkml recently, under this subject:

Performance of the filter add is probably a bit of a concern..

Regards,
Jason
