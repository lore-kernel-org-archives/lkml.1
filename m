Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZEZI44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZEZI44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZEZI4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:56:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50299 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZEZI4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:56:47 -0400
Date: Tue, 26 May 2009 10:56:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 04/12] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090526085648.GD11363@kernel.dk>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-5-git-send-email-jens.axboe@oracle.com> <20090525095816.GC23546@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525095816.GC23546@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Jan Kara wrote:
> > +static void bdi_kupdated(struct backing_dev_info *bdi)
> > +{
> > +	unsigned long oldest_jif;
> > +	long nr_to_write;
> > +	struct writeback_control wbc = {
> > +		.bdi			= bdi,
> > +		.sync_mode		= WB_SYNC_NONE,
> > +		.older_than_this	= &oldest_jif,
> > +		.nr_to_write		= 0,
> > +		.for_kupdate		= 1,
> > +		.range_cyclic		= 1,
> > +	};
> > +
> > +	sync_supers();
>   Hmm, so each BDI flusher thread is going to sync all the superblocks?
> Isn't there a better way? I suppose we *should* be able to somehow go
> from a BDI to a superblock (or maybe a list of those) so that we can write
> per-fs metadata not bound to inodes.

I just moved the sync_supers() to the bdi_forker_task(). That makes it
global at the same interval of wakeups, instead of doing in the bdi
threads. It would be nice to sync locally instead, but that's something
that can wait for later (if ever).

-- 
Jens Axboe

