Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZIIPx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZIIPx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZIIPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:53:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZIIPx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:53:28 -0400
Date: Wed, 9 Sep 2009 17:53:30 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] writeback: fix queue_io() ordering
Message-ID: <20090909155330.GE7949@duck.suse.cz>
References: <20090909145141.293229693@intel.com> <20090909150600.451373732@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909150600.451373732@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-09-09 22:51:43, Wu Fengguang wrote:
> This was not a bug, since b_io is empty for kupdate writeback.
> The next patch will do requeue_io() for non-kupdate writeback,
> so let's fix it.
  But doesn't this patch also need your "anti-starvation" patch?
Looking into the code, we put inode to b_more_io when nr_to_write
drops to zero and this way we'd just start writing it again
in the next round...

							Honza
> 
> CC: Dave Chinner <david@fromorbit.com>
> Cc: Martin Bligh <mbligh@google.com>
> Cc: Michael Rubin <mrubin@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/fs-writeback.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c	2009-09-09 21:41:14.000000000 +0800
> +++ linux/fs/fs-writeback.c	2009-09-09 21:45:15.000000000 +0800
> @@ -313,11 +313,14 @@ static void move_expired_inodes(struct l
>  }
>  
>  /*
> - * Queue all expired dirty inodes for io, eldest first.
> + * Queue all expired dirty inodes for io, eldest first:
> + * (newly dirtied) => b_dirty inodes
> + *                 => b_more_io inodes
> + *                 => remaining inodes in b_io => (dequeue for sync)
>   */
>  static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
>  {
> -	list_splice_init(&wb->b_more_io, wb->b_io.prev);
> +	list_splice_init(&wb->b_more_io, &wb->b_io);
>  	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
>  }
>  
> 
> -- 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
