Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZDXF6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZDXF6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 01:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZDXF6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 01:58:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZDXF6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 01:58:38 -0400
Date: Fri, 24 Apr 2009 07:58:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Message-ID: <20090424055837.GX4593@kernel.dk>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090423212314.GK13326@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423212314.GK13326@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23 2009, Jamie Lokier wrote:
> Jens Axboe wrote:
> > The intent was to add some sort of notification mechanism from the file
> > system to inform the IO scheduler (and others?) that this process is how
> > holding a file system wide resource. So if you have a low priority
> > process getting access to such a resource, you want to boost its
> > priority to avoid higher priority apps getting stuck beind it. Sort of a
> > poor mans priority inheritance.
> 
> Very closely related to this: I'm building something where I want one
> particular task to have absolute higher I/O priority than all other
> tasks.  No problem, use the lovely RT I/O priority facility.
> 
> But if that task needs access to a buffer or page which is already
> undergoing I/O started by another task - what happens?  I'd like the
> _I/O_ priority to be boosted in that case, so that the high priority
> task does not have to wait on a long queue of low priority I/Os.
> 
> E.g. this happens when the high priority task reads from a file, and a
> low priority task has already initiated readahead for that file.  It's
> a particular problem if the low priority task's I/O is queued behind a
> lot of other low priority I/O.
> 
> That can be avoided by just not reading the same files :-)  But more
> subtly, the high priority task may find itself waiting on metadata
> blocks which overlap metadata blocks from I/O in a low priority tasks.
> The application can't easily avoid this.
> 
> So I'd like operations which wait for I/O to complete to compare the
> task's I/O priority with the I/O request already queued, and boost the
> request priority if it's lower, moving it forward in the elevator if
> necessary.
> 
> All this to guarantee a high I/O priority task has a maximum response
> time no matter what low priority I/O is doing.  Even O_DIRECT has to
> read metadata sometimes...

So presumably both the RT and normal task end up doing lock_page() on
the same page. Then __wait_on_bit_lock() uses
prepare_to_wait_exclusive() on the wait queue, which does FIFO ordering
of tasks. When IO completes, the first waiter is woken up. If the wait
queue was sorted by process priority, then lock_page() would honor the
task priority and make sure that the highest prio task got woken first.

> It seems if I/O priority boosting were implemented like this, that
> might solve the superblock priority thing too, without needing
> filesystem changes and generically for all metadata?

It's a different situation, one is waiting for some resource (the page)
to become available by being read in, so it's waiting for IO. The other
is holding some shared resource and then performing IO, potentially
waiting for that IO. In the latter case, the RT (or just higher)
priority task can't get access to the shared resource, so we can't do
much more than simply expedite the IO of the lower priority task. The
former case COULD be solved with prioritized wait queues.

-- 
Jens Axboe

