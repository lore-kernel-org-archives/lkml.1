Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZGUVsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZGUVsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbZGUVsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:48:15 -0400
Received: from cmpxchg.org ([85.214.51.133]:56887 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZGUVsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:48:12 -0400
Date: Tue, 21 Jul 2009 23:46:57 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arnd Schneider <arnd@de.ibm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: PM/hibernate swapfile regression
Message-ID: <20090721214657.GA27605@cmpxchg.org>
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <20090720132456.GA29023@osiris.boeblingen.de.ibm.com> <4A659D75.3050004@tuffmail.co.uk> <200907212257.21878.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907212257.21878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 10:57:21PM +0200, Rafael J. Wysocki wrote:
> On Tuesday 21 July 2009, Alan Jenkins wrote:
> > From 643014ec079610a8b01dfd78c6949c1e8727195b Mon Sep 17 00:00:00 2001
> > From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date: Tue, 21 Jul 2009 10:17:30 +0100
> > Subject: [PATCH] PM/hibernate: replace bdget call with bdcopy (simple atomic_inc of i_count)
> > 
> > Create bdcopy().  This function copies an existing reference to a
> > block_device.  It is safe to call from any context.
> > 
> > Hibernation code wishes to copy a reference to the active swap device.
> > Right now it calls bdget() under a spinlock, but this is wrong because
> > bdget() can sleep.  It doesn't need a full bdget() because we already
> > hold a reference to active swap devices (and the spinlock protects
> > against swapoff).
> > 
> > Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > CC: linux-fsdevel@vger.kernel.org
> > ---
> >  fs/block_dev.c     |    8 ++++++++
> >  include/linux/fs.h |    1 +
> >  mm/swapfile.c      |    4 ++--
> >  3 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index 3a6d4fb..0b04974 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -564,6 +564,14 @@ struct block_device *bdget(dev_t dev)
> >  
> >  EXPORT_SYMBOL(bdget);
> >  
> > +struct block_device *bdcopy(struct block_device *bdev)
> > +{
> > +	atomic_inc(&bdev->bd_inode->i_count);
> > +	return bdev;
> > +}
> 
> Hmm.  If you defined bdcopy() as static inline directly in mm/swapfile.c,
> the patch would be slightly simpler.

Please don't do that.

This helper seems to be generic enough to live next to the rest of the
bd interface, don't you think?  swapfile.c is a mess already...

	Hannes
