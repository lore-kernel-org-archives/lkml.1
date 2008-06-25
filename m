Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYFYJhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYFYJhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYFYJhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:37:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:47292 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752034AbYFYJhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:37:02 -0400
Date: Wed, 25 Jun 2008 11:37:00 +0200
From: Jan Kara <jack@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Oops when using growisofs
Message-ID: <20080625093700.GB15865@duck.suse.cz>
References: <200806221818.24372.mb@bu3sch.de> <20080622233448.4b27c131.akpm@linux-foundation.org> <20080624172812.GD22586@atrey.karlin.mff.cuni.cz> <200806242039.18755.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806242039.18755.mb@bu3sch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-06-08 20:39:18, Michael Buesch wrote:
> On Tuesday 24 June 2008 19:28:12 Jan Kara wrote:
> > > On Mon, 23 Jun 2008 00:28:20 +0200 Michael Buesch <mb@bu3sch.de> wrote:
> > > 
> > > > On Monday 23 June 2008 00:05:51 Michael Buesch wrote:
> > > > > > Note: r9 and r3 are both NULL pointers. r3 is the value returned from alloc_page_buffers.
> > > > > > R9 is a copy of that, which gets accessed.
> > > > > 
> > > > > Hm, yeah. I looked at that code already, but I can't see how it could return
> > > > > a NULL pointer.
> > > > 
> > > > Well, actually, it can return a NULL pointer.
> > > > 
> > > >  928         head = NULL;
> > > >  929         offset = PAGE_SIZE;
> > > >  930         while ((offset -= size) >= 0) {
> > > > ...
> > > >  949         }
> > > >  950         return head;
> > > > 
> > > > So if size, which is a passed in as parameter, is > PAGE_SIZE it will return NULL.
> > > > 
> > > > The size parameter is calculated by doing
> > > > blocksize = 1 << inode->i_blkbits;
> > > > in an earlier function in the callchain.
> > > 
> > > Yes, that's a more likely scenario.  isofs has a history of passing
> > > garbage into the VFS.
> > > 
> > > > So, well. I dunno what i_blkbits is. There's no docs in struct inode.
> > > 
> > > It's log2 of the filesystem blocksize.  It'd be interesting to work out
> > > what value isofs is setting it to, and why.
> >   Well, yes, that looks as a reason at the first sight. But what I don't
> > get is, how can isofs possibly set such a blocksize when it uses
> > sb_set_blocksize() which checks whether blocksize isn't larger than page
> > size... So it must be something less obvious.
> >   bd_set_size() can possibly set blocksize larger than PAGE_SIZE and
> > it's called from do_open() but it uses bdev_hardsect_size() and that
> > shouldn't be larger than PAGE_SIZE either (at least drivers seem to take
> > care of this).
> >   I have seen one more report of this Oops for SLES10 kernel and also in that
> > case an IO error happened so probably that is a trigger... But so far I
> > don't get the details.
> 
> Yeah the IO error is the trigger.
> I noticed that it had obvious troubles accessing the DVD that was in the drive.
> It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> and then oopsed. But after that everything continued to work as usual.
> (Except kded of course)
  Hmm, by "accessing" do you mean that you've mounted the burned DVD and when
browsing it the IO error and the oops occured or that IO error happened
when burning? It is important because in the first case i_blkbits would be
taken from some ISOFS inode desribing some file while in the second case
i_blkbits are from the inode of the device...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
