Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZIDHTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZIDHTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZIDHTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:19:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39673 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbZIDHTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:19:23 -0400
Date: Fri, 4 Sep 2009 09:19:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090904071925.GQ18599@kernel.dk>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com> <20090904024628.GA3658@infradead.org> <20090904025017.GB3658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904025017.GB3658@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 10:46:29PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 02, 2009 at 10:42:41AM +0200, Jens Axboe wrote:
> > This is a first step at introducing per-bdi flusher threads. We should
> > have no change in behaviour, although sb_has_dirty_inodes() is now
> > ridiculously expensive, as there's no easy way to answer that question.
> > Not a huge problem, since it'll be deleted in subsequent patches.
> 
> After this patch generic_sync_sb_inodes becomes pretty useless.  We
> have two callers which each want to call bdi_writeback_all, and one of
> them wants to wait, so just split that into a separate helper.

Looks good.

> Also move wakeup_flusher_threads into fs-writeback.c, that allows us
> to make bdi_writeback_all static.

Ditto, I'll fold these in.

> Btw, I do not think implementing sync_inodes_sb/sync_inodes_sb_wait
> is a smart and efficient idea.  Right now we have a n:1 superblock:bdi
> relation, so we really should make use of that instead of doing linear
> search of all bdis in the system.  If we introduce multiple bdis per
> superblock we should add an efficient lookup data structure for them.

Yes definitely, the scan will get optimized. Once this is merged, I'll
attack the multiple bdis per superblock issue, since we'll need that
sooner rather than later. Pushing 2-3GB/s and up with buffered writeback
will require more than one thread.

-- 
Jens Axboe

