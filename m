Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZEYIvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZEYIvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZEYIvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:51:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39072 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZEYIvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:51:03 -0400
Date: Mon, 25 May 2009 10:51:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 03/12] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090525085104.GO11363@kernel.dk>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-4-git-send-email-jens.axboe@oracle.com> <20090525084225.GB23546@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525084225.GB23546@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Jan Kara wrote:
> On Mon 25-05-09 09:34:38, Jens Axboe wrote:
> > This is a first step at introducing per-bdi flusher threads. We should
> > have no change in behaviour, although sb_has_dirty_inodes() is now
> > ridiculously expensive, as there's no easy way to answer that question.
> > Not a huge problem, since it'll be deleted in subsequent patches.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  fs/fs-writeback.c           |  196 +++++++++++++++++++++++++++---------------
> >  fs/super.c                  |    3 -
> >  include/linux/backing-dev.h |    9 ++
> >  include/linux/fs.h          |    5 +-
> >  mm/backing-dev.c            |   30 +++++++
> >  mm/page-writeback.c         |   11 +--
> >  6 files changed, 170 insertions(+), 84 deletions(-)
> ...
> > @@ -225,9 +231,23 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
> >  }
> >  EXPORT_SYMBOL(bdi_register_dev);
> >  
> > +static void bdi_remove_from_list(struct backing_dev_info *bdi)
> > +{
> > +	mutex_lock(&bdi_lock);
> > +	list_del_rcu(&bdi->bdi_list);
> > +	mutex_unlock(&bdi_lock);
> > +
> > +	/*
> > +	 * In case the bdi is freed right after unregister, we need to
> > +	 * make sure any RCU sections have exited
> > +	 */
> > +	synchronize_rcu();
> > +}
> > +
>   Is this RCU thing still valid? And in bdi_register_dev() as well...

Not it isn't, apparently that bit didn't get killed from the intermedia
steps. The final version doesn't contain any RCU for
bdi_list/bdi_pending_list. I'll shuffle this back as well, thanks for
noticing!

-- 
Jens Axboe

