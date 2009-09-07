Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZIGSpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZIGSpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZIGSpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:45:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57127 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZIGSpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:45:15 -0400
Date: Mon, 7 Sep 2009 20:45:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data v2
Message-ID: <20090907184517.GF18599@kernel.dk>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com> <20090904105403.GD19857@duck.suse.cz> <20090904115858.GT18599@kernel.dk> <20090904120407.GV18599@kernel.dk> <20090907183659.GB29103@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907183659.GB29103@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Jan Kara wrote:
>   Hi Jens,
> 
>   now I've found just two minor things (see below). Besides them the only
> thing which is blocking my ack is a way to effectively lookup a BDI from a
> superblock so that we can reasonably effectively fsync a superblock...

Can we side step that as an inclusion criteria, please? I'd really like
to work on adding that quick lookup, but I'd also hate to potentiall
destabilize anything at this point. So we can probably quite easily make
.32 as well for that, but I'd rather not risk doing a version and
include that from the beginning. OK?

> > +	/*
> > +	 * Check for periodic writeback, kupdated() style
> > +	 */
> > +	if (!wrote)
> > +		wrote = wb_check_old_data_flush(wb);
>   Why is here the !wrote check? It would feel safer if we just did
> wrote += wb_check_old_data_flush(wb);
>   Otherwise we cannot guarantee syncing of inodes every writeback_interval.

Yes good point, that check should not be there or the logic is still
broken wrt old data flushing. Will fix that, thanks!

> > +		/*
> > +		 * If work allocation fails, do the writes inline. We drop
> > +		 * the lock and restart the list writeout. This should be OK,
> > +		 * since this happens rarely and because the writeout should
> > +		 * eventually make more free memory available.
> > +		 */
> > +		work = bdi_alloc_work(wbc);
> > +		if (!work) {
> > +			struct writeback_control __wbc = *wbc;
> >
> > -			cond_resched();
> > +			/*
> > +			 * Not a data integrity writeout, just continue
> > +			 */
> > +			if (!must_wait)
> > +				continue;
> >  
> > -			spin_lock(&inode_lock);
> > +			spin_unlock(&bdi_lock);
> > +			__wbc = *wbc;
>   You initialize the variable twice...

Indeed, the latter should just go. Good spotting, fixed.

-- 
Jens Axboe

