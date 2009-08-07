Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbZHGOjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbZHGOjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558AbZHGOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:39:08 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:54346 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbZHGOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:39:07 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1249655761.2719.11.camel@localhost.localdomain>
References: <1245839904.3210.85.camel@localhost.localdomain>
	 <1249647601.32113.700.camel@twins>
	 <1249655761.2719.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:38:47 +0200
Message-Id: <1249655927.32113.712.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 15:36 +0100, Richard Kennedy wrote:
> On Fri, 2009-08-07 at 14:20 +0200, Peter Zijlstra wrote:
> > On Wed, 2009-06-24 at 11:38 +0100, Richard Kennedy wrote:
> ....
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

Yeah, but that's a mult and a div extra, all that really matters is
being able to generate plenty of IO. I think the 1/2 approximation
should suffice, but we'll see.

Thanks for testing.

