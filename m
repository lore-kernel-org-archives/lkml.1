Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZI2QNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZI2QNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZI2QNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:13:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:51923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbZI2QNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:13:37 -0400
Date: Tue, 29 Sep 2009 18:13:39 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, jack@suse.cz, npiggin@suse.de
Subject: Re: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-ID: <20090929161339.GB11573@duck.suse.cz>
References: <20090925141014.GB15853@think> <20090927013458.53e43459.akpm@linux-foundation.org> <20090927164431.GB23126@kernel.dk> <20090927095202.717fdf64.akpm@linux-foundation.org> <20090927165513.GC23126@kernel.dk> <20090927101035.e8712819.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927101035.e8712819.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 27-09-09 10:10:35, Andrew Morton wrote:
> On Sun, 27 Sep 2009 18:55:14 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > I wasn't referring to this patch actually.  The code as it stands in
> > > Linus's tree right now attempts to write back up to 2^63 pages...  
> > 
> > I agree, it could make the fs sync take a looong time. This is not a new
> > issue, though.
> 
> It _should_ be a new issue.  The old code would estimate the number of
> dirty pages up-front and would then add a +50% fudge factor, so if we
> started the sync with 1GB dirty memory, we write back a max of 1.5GB.
> 
> However that might have got broken.
> 
> void sync_inodes_sb(struct super_block *sb, int wait)
> {
> 	struct writeback_control wbc = {
> 		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_NONE,
> 		.range_start	= 0,
> 		.range_end	= LLONG_MAX,
> 	};
> 
> 	if (!wait) {
> 		unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
> 		unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> 
> 		wbc.nr_to_write = nr_dirty + nr_unstable +
> 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> 	} else
> 		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */
> 
> 	sync_sb_inodes(sb, &wbc);
> }
> 
> a) the +50% isn't there in 2.6.31
> 
> b) the wait=true case appears to be vulnerable to livelock in 2.6.31.
> 
> whodidthat
> 
> 38f21977663126fef53f5585e7f1653d8ebe55c4 did that back in January.
  Yes, I even remember the (long) discussion:
http://lkml.org/lkml/2008/9/22/361
  The problem with using .nr_to_write in WB_SYNC_ALL mode is that
write_cache_pages() can return before it actually wrote the pages we
wanted to write (because someone dirtied other pages in the mean time).
So Nick rather removed the .nr_to_write thing to guarantee proper data
integrity semantics. I'm not sure what is the status of the fixes of
livelock he proposed (added him to CC).
  Maybe we could at least fix some cases of possible livelock by setting
.range_end to current i_size when calling writepages(). That would solve a
common case when somebody is extending the file. For the case when someone
writes to a huge hole, we would at least provide a finite upper bound,
although practically it might be just the same as without .range_end.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
