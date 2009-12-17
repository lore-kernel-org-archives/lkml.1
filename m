Return-Path: <linux-kernel-owner+w=401wt.eu-S1764261AbZLQJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764261AbZLQJwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763249AbZLQJwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:52:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbZLQJwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:52:39 -0500
Date: Thu, 17 Dec 2009 10:52:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Alex Elder <aelder@sgi.com>, Mark Fasheh <mfasheh@suse.com>,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091217095214.GA16810@elte.hu>
References: <20091217090250.GA4844@elte.hu>
 <20091217093216.GZ14381@ZenIV.linux.org.uk>
 <20091217094448.GB12228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217094448.GB12228@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Thu, Dec 17, 2009 at 10:02:50AM +0100, Ingo Molnar wrote:
> > > 
> > > Today's -tip crashes during bootup on one of my testsystems, and i've bisected 
> > > it back to this commit:
> > > 
> > > | 5fe878ae7f82fbf0830dbfaee4c5ca18f3aee442 is the first bad commit
> > > | commit 5fe878ae7f82fbf0830dbfaee4c5ca18f3aee442
> > > | Author: Christoph Hellwig <hch@lst.de>
> > > | Date:   Tue Dec 15 16:47:50 2009 -0800
> > > |
> > > |    direct-io: cleanup blockdev_direct_IO locking
> > > |
> > > |    Currently the locking in blockdev_direct_IO is a mess, we have three
> > > |    different locking types and very confusing checks for some of them.  The
> > > |    most complicated one is DIO_OWN_LOCKING for reads, which happens to not
> > > |    actually be used.
> > > 
> > > I have no bootlog available currently. The kernel config is attached.
> > > 
> > > I've reverted the patch from -tip for now.
> > 
> > How about this:
> > 
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 4012885..e82adc2 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -1206,7 +1206,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
> >  	 * NOTE: filesystems with their own locking have to handle this
> >  	 * on their own.
> >  	 */
> > -	if (dio->flags & DIO_LOCKING) {
> > +	if (flags & DIO_LOCKING) {
> >  		if (unlikely((rw & WRITE) && retval < 0)) {
> >  			loff_t isize = i_size_read(inode);
> >  			if (end > isize)
> 
> thanks, will check this.

Fixes the crash, thanks Al!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
