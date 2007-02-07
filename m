Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXBGBbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXBGBbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965596AbXBGBbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:31:19 -0500
Received: from ns.suse.de ([195.135.220.2]:33419 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbXBGBbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:31:18 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Feb 2007 12:30:39 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17865.11199.612391.738320@notabene.brown>
Cc: "Kai" <epimetreus@fastmail.fm>, stable@suse.de, org@suse.de,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at
 mm/filemap.c:537!
In-Reply-To: message from Andrew Morton on Tuesday February 6
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
	<17864.4339.925700.626157@notabene.brown>
	<17865.3776.511594.763544@notabene.brown>
	<20070206171509.f92e0ed2.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 6, akpm@linux-foundation.org wrote:
> On Wed, 7 Feb 2007 10:26:56 +1100
> Neil Brown <neilb@suse.de> wrote:
> 
> > +static int bio_fits_rdev(struct bio *bi)
> > +{
> > +	request_queue_t *q = bdev_get_queue(bi->bi_bdev);
> > +
> > +	if ((bi->bi_size>>9) > q->max_sectors)
> > +		return 0;
> > +	blk_recount_segments(q, bi);
> > +	if (bi->bi_phys_segments > q->max_phys_segments ||
> > +	    bi->bi_hw_segments > q->max_hw_segments)
> > +		return 0;
> > +
> > +	if (q->merge_bvec_fn)
> > +		/* it's too hard to apply the merge_bvec_fn at this stage,
> > +		 * just just give up
> > +		 */
> > +		return 0;
> > +
> > +	return 1;
> > +}
> 
> Isn't think going to return 0 rather a lot of the time?

Why do you say that?

merge_bvec_fn is only set for dm, md, pktcdvd.c so what won't cause a
zero in real-world cases (it rarely makes sense to put a raid5 on top
of those things).
So it will only return zero when ->max_sectors or ->max_*_segments are
less than the default, and while there are certainly quite a few of
those I wouldn't have expected them to be a majority (else we would
have had more complaints from -mm testers).

Yes, we should find the minimum of those values for devices currently
in the array and use that information in raid5's merge_bvec_fn to stop
bios growing too large.  That would make it return 0 somewhat less
often.
But I think for a lot of modern hardware, it won't return 0 at all....
or am I just not seeing some really obvious typo that you can see ??

NeilBrown

