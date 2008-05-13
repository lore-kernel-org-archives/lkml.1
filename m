Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYEMQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYEMQh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbYEMQhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:37:48 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47321 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542AbYEMQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:37:47 -0400
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080513145449.GC20806@duck.suse.cz>
References: <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 13 May 2008 09:37:37 -0700
Message-Id: <1210696657.3638.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 16:54 +0200, Jan Kara wrote:
> On Mon 12-05-08 17:39:43, Mingming Cao wrote:
> > Index: linux-2.6.26-rc1/fs/ext3/inode.c
> > ===================================================================
> > --- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-03 11:59:44.000000000 -0700
> > +++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-12 12:41:27.000000000 -0700
> > @@ -1766,6 +1766,23 @@ static int ext3_journalled_set_page_dirt
> >  	return __set_page_dirty_nobuffers(page);
> >  }
> >  
> > +static int ext3_launder_page(struct page *page)
> > +{
> > +        int ret;
> > +	int retry = 5;
> > +
> > +	while (retry --) {
> > +		ret = ext3_releasepage(page, GFP_KERNEL);
> > +		if (ret == 1)
> > +			break;
> > +		else
> > +			schedule();
> > +	}
> > +
> > +        return ret;
> > +}
> > +
> > +
>   Yes, I meant something like this. We could be more clever and do:
> 
> 	head = bh = page_buffers(page);
> 	do {
> 		wait_on_buffer(bh);
> 		bh = bh->b_this_page;
> 	} while (bh != head);
> 	/*
> 	 * Now commit code should have been able to proceed and release
>          * those buffers
> 	 */
>         schedule();
> 
Thanks.
We could recheck if buffer_busy() before calling wait_on_buffer(bh) to
wait for buffer unlocked. This will handles the mapped IO re-dirty race
case, but still need the schedule() and retry to handle the buffered IO
race.

> 
> or we could do simple:
> 	log_wait_commit(...);
> 
> That would impose larger perf. penalty but on the other hand you shouldn't
> hit this path too often.

My concern with doing log_wait_commit() here is the perf penalty. In the
case the buffers is at the end of the queue to commit, we have to wait
for all other previous transactions to finish committing before we could
continue...

>  But maybe the code above would be fine and would
> handle most cases. Also please add a big comment to that function to explain
> why this magic is needed.
> 
Will do.
> >  static const struct address_space_operations ext3_ordered_aops = {
> >  	.readpage	= ext3_readpage,
> >  	.readpages	= ext3_readpages,
> > @@ -1778,6 +1795,7 @@ static const struct address_space_operat
> >  	.releasepage	= ext3_releasepage,
> >  	.direct_IO	= ext3_direct_IO,
> >  	.migratepage	= buffer_migrate_page,
> > +	.launder_page	= ext3_launder_page,
> >  };
> >  
> >  static const struct address_space_operations ext3_writeback_aops = {
> > @@ -1792,6 +1810,7 @@ static const struct address_space_operat
> >  	.releasepage	= ext3_releasepage,
> >  	.direct_IO	= ext3_direct_IO,
> >  	.migratepage	= buffer_migrate_page,
> > +	.launder_page	= ext3_launder_page,
> >  };
> >  
> >  static const struct address_space_operations ext3_journalled_aops = {
> > @@ -1805,6 +1824,7 @@ static const struct address_space_operat
> >  	.bmap		= ext3_bmap,
> >  	.invalidatepage	= ext3_invalidatepage,
> >  	.releasepage	= ext3_releasepage,
> > +	.launder_page	= ext3_launder_page,
> >  };
> >  
> >  void ext3_set_aops(struct inode *inode)
>   Actually, we need .launder_page callback only in data=order mode.
> data=writeback mode doesn't need it at all (journal code doesn't touch data
> buffers there) and for data=journal mode DIO could have never worked
> reasonably when mixed with buffered IO and it would have to do a different
> and much more expensive trickery (like flushing the journal, or at least
> forcing current transaction to commit).
> 

You are right, thanks for pointing this out.
Will post an updated patch.

Mingming

