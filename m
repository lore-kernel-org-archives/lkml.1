Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZIFSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZIFSn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZIFSn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:43:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50919 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758117AbZIFSn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:43:57 -0400
Date: Sun, 6 Sep 2009 20:43:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090906184358.GM18599@kernel.dk>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com> <20090904025609.GC3658@infradead.org> <20090904065357.GP18599@kernel.dk> <20090904154305.GA10002@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904154305.GA10002@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, Christoph Hellwig wrote:
> On Fri, Sep 04, 2009 at 08:53:57AM +0200, Jens Axboe wrote:
> > > +	if (wbc->sync_mode == WB_SYNC_ALL)
> > > +		bdi_wait_on_work_clear(&work);
> > >  }
> > 
> > That doesn't work, you have to wait for on-stack work. So either we just
> > punt and not do anything for WB_SYNC_NONE if the allocation fails, or we
> > punt to stack and do the wait. Since it's a cleaning action and
> > allocation fails, falling back to the stack and waiting seems like the
> > most appropriate choice.
> 
> True, the wait needs to be unconditional.  Updated version below.

(did you forget that patch? it's not there).

> But now that I look at it, I wonder if we should even bother with it.
> bdi_start_writeback is only used in WC_SYNC_NONE mode in
> balance_dirty_pages.  So if we really run so much out of memory that we
> can't allocate the bdi_work we might just throttle and wait for the
> flusher thread to do it's work.  That would get rid of all the
> special cases for the on-stack bdi_work instances.

Dunno, it feels a lot saner to always block there and ensure that we get
the message across.

-- 
Jens Axboe

