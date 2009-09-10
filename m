Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZIJB0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZIJB0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZIJB0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:26:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:29069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbZIJB0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:26:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185959812"
Date: Thu, 10 Sep 2009 09:26:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] writeback: fix queue_io() ordering
Message-ID: <20090910012624.GA10957@localhost>
References: <20090909145141.293229693@intel.com> <20090909150600.451373732@intel.com> <20090909155330.GE7949@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909155330.GE7949@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 11:53:30PM +0800, Jan Kara wrote:
> On Wed 09-09-09 22:51:43, Wu Fengguang wrote:
> > This was not a bug, since b_io is empty for kupdate writeback.
> > The next patch will do requeue_io() for non-kupdate writeback,
> > so let's fix it.
>   But doesn't this patch also need your "anti-starvation" patch?

Honza, can you show me that patch?

> Looking into the code, we put inode to b_more_io when nr_to_write
> drops to zero and this way we'd just start writing it again
> in the next round...

I'm confused. It's OK to start it in next round. Starvation can
occur if we start it immediately in the next writeback_inodes()
invocation. How can that happen with this patch?

Thanks,
Fengguang

> 							Honza
> > 
> > CC: Dave Chinner <david@fromorbit.com>
> > Cc: Martin Bligh <mbligh@google.com>
> > Cc: Michael Rubin <mrubin@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > ---
> >  fs/fs-writeback.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > --- linux.orig/fs/fs-writeback.c	2009-09-09 21:41:14.000000000 +0800
> > +++ linux/fs/fs-writeback.c	2009-09-09 21:45:15.000000000 +0800
> > @@ -313,11 +313,14 @@ static void move_expired_inodes(struct l
> >  }
> >  
> >  /*
> > - * Queue all expired dirty inodes for io, eldest first.
> > + * Queue all expired dirty inodes for io, eldest first:
> > + * (newly dirtied) => b_dirty inodes
> > + *                 => b_more_io inodes
> > + *                 => remaining inodes in b_io => (dequeue for sync)
> >   */
> >  static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
> >  {
> > -	list_splice_init(&wb->b_more_io, wb->b_io.prev);
> > +	list_splice_init(&wb->b_more_io, &wb->b_io);
> >  	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
> >  }
> >  
> > 
> > -- 
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
