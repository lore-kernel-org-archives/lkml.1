Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbXHQHNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbXHQHNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXHQHNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:13:22 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44692 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755697AbXHQHNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:13:21 -0400
Message-ID: <387334797.23195@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 17 Aug 2007 15:13:17 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] writeback: remove pages_skipped accounting in
	__block_write_full_page()
Message-ID: <20070817071317.GA8965@mail.ustc.edu.cn>
References: <20070812091120.189651872@mail.ustc.edu.cn> <20070812092052.848213359@mail.ustc.edu.cn> <20070813010321.GT12413810@sgi.com> <20070813103000.GA8520@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813103000.GA8520@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 06:30:00PM +0800, Fengguang Wu wrote:
> > On Sun, Aug 12, 2007 at 05:11:23PM +0800, Fengguang Wu wrote:
> > > Miklos Szeredi <miklos@szeredi.hu> and me identified a writeback bug:
> > > Basicly they are
> > > - during the dd: ~16M 
> > > - after 30s:      ~4M
> > > - after 5s:       ~4M
> > > - after 5s:     ~176M
> > > 
> > > The box has 2G memory.
> > > 
> > > Question 1:
> > > How come the 5s delays? I run 4 tests in total, 2 of which have such 5s delays.
> > 
> > pdflush runs every five seconds, so that is indicative of the inode being
> > written once for 1024 pages, and then delayed to the next pdflush run 5s later.
> > perhaps the inodes aren't moving between the lists exactly the way you
> > think they are...
> 
> Now I figured out the exact situation. When the scan of s_io finishes
> with some small inodes, nr_to_write will be positive, fooling kupdate
> to quit prematurely. But in fact the big dirty file is on s_more_io
> waiting for more io... The attached patch fixes it.
> 
> Fengguang
> ===
> 
> Subject: writeback: introduce writeback_control.more_io to indicate more io
> 
> After making dirty a 100M file, the normal behavior is to
> start the writeback for all data after 30s delays. But
> sometimes the following happens instead:
> 
> 	- after 30s:    ~4M
> 	- after 5s:     ~4M
> 	- after 5s:     all remaining 92M
> 
> Some analyze shows that the internal io dispatch queues goes like this:
> 
> 		s_io            s_more_io
> 		-------------------------
> 	1)	100M,1K         0
> 	2)	1K              96M
> 	3)	0               96M
> 
> 1) initial state with a 100M file and a 1K file
> 2) 4M written, nr_to_write <= 0, so write more
> 3) 1K written, nr_to_write > 0, no more writes(BUG)
> 
> nr_to_write > 0 in 3) fools the upper layer to think that data have all been
> written out. Bug the big dirty file is still sitting in s_more_io. We cannot
> simply splice s_more_io back to s_io as soon as s_io becomes empty, and let the
> loop in generic_sync_sb_inodes() continue: this may starve newly expired inodes
> in s_dirty.  It is also not an option to draw inodes from both s_more_io and
> s_dirty, an let the loop go on: this might lead to live locks, and might also
> starve other superblocks in sync time(well kupdate may still starve some
> superblocks, that's another bug).
> 
> So we have to return when a full scan of s_io completes. So nr_to_write > 0 does
> not necessarily mean that "all data are written". This patch introduces a flag
> writeback_control.more_io to indicate this situation. With it the big dirty file
> no longer has to wait for the next kupdate invocation 5s later.

Sorry, this patch is found to be dangerous. It locks up my desktop
on heavy I/O: kupdate *immediately* returns to push the file in
s_more_io for writeback, but it *could* still not able to make
progress(locks etc.). Now kupdate ends up *busy looping*.  That could
be fixed by wait for somehow 100ms and retry the io. Should we do
it?(or: Is 5s interval considered too long a wait?)

> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/fs-writeback.c         |    2 ++
>  include/linux/writeback.h |    1 +
>  mm/page-writeback.c       |    9 ++++++---
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
> +++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
> @@ -560,6 +560,8 @@ int generic_sync_sb_inodes(struct super_
>  		if (wbc->nr_to_write <= 0)
>  			break;
>  	}
> +	if (!list_empty(&sb->s_more_io))
> +		wbc->more_io = 1;
>  	spin_unlock(&inode_lock);
>  	return ret;		/* Leave any unwritten inodes on s_io */
>  }
> --- linux-2.6.23-rc2-mm2.orig/include/linux/writeback.h
> +++ linux-2.6.23-rc2-mm2/include/linux/writeback.h
> @@ -61,6 +61,7 @@ struct writeback_control {
>  	unsigned for_reclaim:1;		/* Invoked from the page allocator */
>  	unsigned for_writepages:1;	/* This is a writepages() call */
>  	unsigned range_cyclic:1;	/* range_start is cyclic */
> +	unsigned more_io:1;		/* more io to be dispatched */
>  
>  	void *fs_private;		/* For use by ->writepages() */
>  };
> --- linux-2.6.23-rc2-mm2.orig/mm/page-writeback.c
> +++ linux-2.6.23-rc2-mm2/mm/page-writeback.c
> @@ -382,6 +382,7 @@ static void background_writeout(unsigned
>  			global_page_state(NR_UNSTABLE_NFS) < background_thresh
>  				&& min_pages <= 0)
>  			break;
> +		wbc.more_io = 0;
>  		wbc.encountered_congestion = 0;
>  		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
>  		wbc.pages_skipped = 0;
> @@ -389,8 +390,9 @@ static void background_writeout(unsigned
>  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
>  			/* Wrote less than expected */
> -			congestion_wait(WRITE, HZ/10);
> -			if (!wbc.encountered_congestion)
> +			if (wbc.encountered_congestion)
> +				congestion_wait(WRITE, HZ/10);
> +			else if (!wbc.more_io)
>  				break;
>  		}
>  	}
> @@ -455,13 +457,14 @@ static void wb_kupdate(unsigned long arg
>  			global_page_state(NR_UNSTABLE_NFS) +
>  			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
>  	while (nr_to_write > 0) {
> +		wbc.more_io = 0;
>  		wbc.encountered_congestion = 0;
>  		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
>  		writeback_inodes(&wbc);
>  		if (wbc.nr_to_write > 0) {
>  			if (wbc.encountered_congestion)
>  				congestion_wait(WRITE, HZ/10);
> -			else
> +			else if (!wbc.more_io)
>  				break;	/* All the old data is written */
>  		}
>  		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

