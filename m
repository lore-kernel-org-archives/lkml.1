Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZJLReV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZJLReV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbZJLReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:34:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:47597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbZJLReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:34:19 -0400
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <ada3a5uq1dk.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	 <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	 <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com>
	 <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz>
	 <20090930094456.GD24621@elte.hu> <ada3a61rc3j.fsf@cisco.com>
	 <ada3a5uq1dk.fsf@cisco.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Oct 2009 19:33:22 +0200
Message-Id: <1255368802.8392.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 15:34 -0700, Roland Dreier wrote:
> > So I looked a little deeper into this, and I don't think (even with the
>  > filtering extensions) that perf events are directly applicable to this
>  > problem.  The first issue is that, assuming I'm understanding the
>  > comment in perf_event.c:
>  > 
>  >         /*
>  >          * Raw tracepoint data is a severe data leak, only allow root to
>  >          * have these.
>  >          */
>  > 
>  > currently tracepoints can only be used by privileged processes.  A key
>  > feature of ummunotify is that ordinary unprivileged processes can use it.
>  > 
>  > So would it be acceptable to add something like PERF_TYPE_MMU_NOTIFIER
>  > as a way of letting unprivileged userspace get access to just MMU events
>  > for their own process?  Clearly this touches core infrastructure and is
>  > not as simple as just adding two tracepoints.
>  > 
>  > Then, assuming we have some way to create an "MMU notifier" perf event,
>  > we need a way for userspace to specify which address ranges it would
>  > like events for (I don't think the string filter expression used by
>  > existing trace filtering works, because if userspace is looking at a few
>  > hundred regions, then the size of the filtering expression explodes, and
>  > adding or removing a single range becomes a pain).  So I guess a new
>  > ioctl() to add/remove ranges for MMU_NOTIFIER perf events?
>  > 
>  > I think filtering is needed, because otherwise events for ranges that
>  > are not of interest are just a waste of resources to generate and
>  > process, and make losing good events because of overflow much more
>  > likely.
>  > 
>  > We still have the problem of lost events if the mmap buffer overflows,
>  > but userspace should be able to size the buffer so that such events are
>  > rare I guess.
>  > 
>  > In the end this seems to just take the ummunotify code I have, and make
>  > it be a new type of perf counter instead of a character special device.
>  > I'd actually be OK with that, since having an oddball new char dev
>  > interface is not particularly nice.  But on the other hand just
>  > multiplexing a new type of thing under perf events is not all that much
>  > better.  What do you think?
> 
> Ingo/Peter/<anyone suggesting perf events> -- can you comment on this
> plan of creating PERF_TYPE_MMU_NOTIFIER for perf events to implement
> ummunotify?  To me it looks like a wash -- the main difference is how
> userspace gets the magic ummunotify file descriptor, either by
> open("/dev/ummunotify") or by perf_event_open(...PERF_TYPE_MMU_NOTIFIER...),
> but pretty much everything else stays pretty much the same in terms of
> how much kernel code is involved.  We do reuse the perf events mmap
> buffer code but I think that ends up being more complicated than
> returning events via read().
> 
> Anyway, before I spend the time converting over to the new
> infrastructure and causing the MPI guys to churn their code, I'd like to
> make sure that this is what you guys have in mind.
> 
> (By the way, after thinking about this more, I really do think that
> filtering events by address range is a must-have -- with filtering,
> userspace can map sufficient buffer space to avoid losing events for a
> given number of regions; without filtering, events might get lost just
> because of invalidate events for ranges userspace didn't even care about)

I think something like

PERF_TYPE_SOFTWARE, PERF_COUNT_SW_MUNMAP + $filter

or

PERF_TYPE_TRACEPOINT, //events/vm/munmap/id + $filter

As for the read/poll issue, I think we can do something like
PERF_FORMAT_BLOCK which would make read() block when ->count hasn't
changed, and make poll() work without requiring a mmap().

As to filter, we can do two things, add a simple single range filter to
perf_event_attr, which is something ia64 has hardware support for IIRC,
or we can possibly use this trace filter muck.

Would something like that be sufficient? With such events only
generating a wakeup (poll) when the unmap actually happens, you'd not
even need an mmap() buffer to keep up with that.


