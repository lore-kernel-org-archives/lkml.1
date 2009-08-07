Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbZHGPXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbZHGPXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZHGPXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:23:04 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:33502 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZHGPXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:23:03 -0400
Date: Fri, 7 Aug 2009 11:22:11 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
Message-ID: <20090807152210.GH17129@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Richard Kennedy <richard@rsk.demon.co.uk>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
References: <1245839904.3210.85.camel@localhost.localdomain>
 <1249647601.32113.700.camel@twins>
 <1249655761.2719.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249655761.2719.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A7C46A6.002D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:36:01PM +0100, Richard Kennedy wrote:
> On Fri, 2009-08-07 at 14:20 +0200, Peter Zijlstra wrote:
> > On Wed, 2009-06-24 at 11:38 +0100, Richard Kennedy wrote:
> ...
> > OK, so Chris ran into this bit yesterday, complaining that he'd only get
> > very few write requests and couldn't saturate his IO channel.
> > 
> > Now, since writing out everything once there's something to do sucks for
> > Richard, but only writing out stuff when we're over the limit sucks for
> > Chris (since we can only be over the limit a little), the best thing
> > would be to only write out when we're over the background limit. Since
> > that is the low watermark we use for throttling it makes sense that we
> > try to write out when above that.
> > 
> > However, since there's a lack of bdi_background_thresh, and I don't
> > think introducing one just for this is really justified. How about the
> > below?
> > 
> > Chris how did this work for you? Richard, does this make things suck for
> > you again?
> > 
> > ---
> >  mm/page-writeback.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 81627eb..92f42d6 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -545,7 +545,7 @@ static void balance_dirty_pages(struct address_space *mapping)
> >  		 * threshold otherwise wait until the disk writes catch
> >  		 * up.
> >  		 */
> > -		if (bdi_nr_reclaimable > bdi_thresh) {
> > +		if (bdi_nr_reclaimable > bdi_thresh/2) {

My patch had two extra spaces ;)

> >  			writeback_inodes(&wbc);
> >  			pages_written += write_chunk - wbc.nr_to_write;
> >  			get_dirty_limits(&background_thresh, &dirty_thresh,
> > 
> > 
> I'll run some tests and let you know :)
> 
> But what if someone has changed the vm settings?
> Maybe something like 
> 	(bdi_thresh * dirty_background_ratio / dirty_ratio)
> might be better ?
> 
> Chris, what sort of workload are you having problems with?

So, buffered writeback in general has a bunch of interesting features
right now, and to be honest I'm having a hard time untangling all of it.
It doesn't help that each of our filesystems is reacting differently.

Btrfs and XFS both use helper threads to process IO completion.  This
means that we tend to collect more writeback pages than the other
filesystems do.

The end result of this is that O_DIRECT is dramatically faster than
buffered on every streaming write workload I've tried.  I'm still trying
to sort out exactly where buffered IO is going wrong.

-chris

