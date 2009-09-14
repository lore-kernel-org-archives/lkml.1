Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZINLLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZINLLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZINLLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:11:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48569 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbZINLLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:11:18 -0400
Date: Mon, 14 Sep 2009 13:11:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 4/7] writeback: use RCU to protect bdi_list
Message-ID: <20090914111121.GC14984@kernel.dk>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-5-git-send-email-jens.axboe@oracle.com> <20090914201002.0ca94166.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914201002.0ca94166.minchan.kim@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14 2009, Minchan Kim wrote:
> On Mon, 14 Sep 2009 11:36:31 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Now that bdi_writeback_all() no longer handles integrity writeback,
> > it doesn't have to block anymore. This means that we can switch
> > bdi_list reader side protection to RCU.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  fs/fs-writeback.c           |    4 +-
> >  include/linux/backing-dev.h |    1 +
> >  mm/backing-dev.c            |   76 +++++++++++++++++++++++++++++++------------
> >  mm/page-writeback.c         |    8 ++--
> >  4 files changed, 62 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 5d4bd1c..d7592c7 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -849,7 +849,7 @@ static void bdi_writeback_all(struct writeback_control *wbc)
> >  
> >  	WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
> >  
> > -	spin_lock(&bdi_lock);
> > +	rcu_read_lock();
> >  
> >  	list_for_each_entry(bdi, &bdi_list, bdi_list) {
> 
> list_for_each_entry_rcu?

Indeed, pretty silly. Thanks!

-- 
Jens Axboe

