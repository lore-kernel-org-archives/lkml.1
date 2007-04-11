Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbXDKSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbXDKSBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDKSBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:01:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63796 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbXDKSBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:01:50 -0400
Date: Wed, 11 Apr 2007 11:00:38 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Ken Chen <kenchen@google.com>
Cc: akpm@linux-foundation.org, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411180038.GN28322@mami.zabbo.net>
References: <20070410235353.325A7346F64@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410235353.325A7346F64@localhost>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, I'll NAK this and all AIO patches until the patch description
says that it's been run through the regression tests that we've started
collecting in autotest.  They're trivial to run, never fear:

 cd /usr/local
 svn checkout svn://test.kernel.org/autotest/trunk/client autotest
 cd autotest
 bin/autotest tests/aio_dio_bugs/control

(We'll be moving this to LTP soon, I think, but that will just change
the commands to cut and paste.) 

> Resurrect an old patch that uses atomic operation to update ring buffer
> index on AIO event queue.  This work allows futher application/libaio
> optimization to run fast path io_getevents in user space.

I have mixed feelings.  I think the userspace getevents support was
poorly designed and the simple fact that we've gone this long without it
says just how desperately the feature isn't needed.

At the same time, it's a small change and the code is already there.  So
it's hard to get too worked up about it.  We can always remove support
in the future by never changing the indexes if we require that apps fall
back to sys_io_getevents().

In any case, let's see a test which exercises userspace event collection
before we claim to support it.  I'd prefer a little stand-alone C app
like the ones in autotest for simple unit testing.  A fio patch to
stress test it would probably also be well received.

> I've also added one more change on top of old implementation that rounds
> ring buffer size to power of 2 to allow fast head/tail calculation. With
> the new scheme, there is no more modulo operation on them and we simply
> increment either pointer index directly.  

Please quantify the improvement.  We're allocating more ring elements
than userspace asked for and than were accounted for in aio_max_nr.
That cost, however teeny, will be measured against the benefit.

> -	/* Compensate for the ring buffer's head/tail overlap entry */
> -	nr_events += 2;	/* 1 is required, 2 for good luck */
> +	/* round nr_event to next power of 2 */
> +	nr_events = roundup_pow_of_two(nr_events);

Is that buggy?  How will the code tell if head == tail means a full ring
or an empty ring?  The old code added that extra event to let it tell
the ring was full before head == tail and it would think it's empty
again, I think.  I'm guessing roundup(nr_events + 1) is needed.

> -#define aio_ring_event(info, nr, km) ({					\
> -	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
> +#define aio_ring_event(info, __nr, km) ({				\
> +	unsigned pos = ((__nr) & ((info)->nr - 1)) + AIO_EVENTS_OFFSET;	\
>  	struct io_event *__event;					\
>  	__event = kmap_atomic(						\
>  			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE], km); \

(info) is now evaluated twice.  __info = (info), please, just like
__event there.

>  	put_aio_ring_event(event, KM_IRQ0);
>  	kunmap_atomic(ring, KM_IRQ1);

The ring page, which is mmaped to userspace at some weird address, was
just written through a kmap.  Do we need a flush_dcache_page()?  This
isn't this patch's problem, but it'd need to be addressed if we're using
the ring from userspace.

> -
> -	struct io_event		io_events[0];
> +	struct io_event	io_events[0];

Try to minimize gratuitous reformatting, please.

- z
