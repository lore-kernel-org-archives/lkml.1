Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbZCYK14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbZCYK14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZCYK1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:27:48 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59234 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbZCYK1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:27:47 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 02/12] DRBD: activity_log
Date: Wed, 25 Mar 2009 11:27:22 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com> <87bprrhzqw.fsf@basil.nowhere.org>
In-Reply-To: <87bprrhzqw.fsf@basil.nowhere.org>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251127.23287.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009 13:27:51 Andi Kleen wrote:

[...]
> > +	u32       tr_number;
> > +	/* u32       tr_generation; TODO */
>
> It would be difficult to "TODO" this because adding that field here would
> break the complete disk format, wouldn't it?
>

Yes, you are right. That is an ancient comment, I just removed it.

[...]
> > +	ok = bio_flagged(bio, BIO_UPTODATE) && md_io.error == 0;
> > +
> > +	/* check for unsupported barrier op.
> > +	 * would rather check on EOPNOTSUPP, but that is not reliable.
> > +	 * don't try again for ANY return value != 0 */
> > +	if (unlikely(bio_barrier(bio) && !ok)) {
>
> That's a good example for some code that shouldn't be in upstream. If
> EOPNOTSUPP for barriers is really not reliable somewhere please just
> fix that somewhere (if it's still true and not some ancient bug), not
> add workarounds like this.
>

Ok. I will fix this, either way. 

> > +int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev
> > *bdev, +			 sector_t sector, int rw)
> > +{
> > +	int hardsect, mask, ok;
> > +	int offset = 0;
> > +	struct page *iop = mdev->md_io_page;
> > +
> > +	D_ASSERT(mutex_is_locked(&mdev->md_io_mutex));
> > +
> > +	if (!bdev->md_bdev) {
> > +		if (DRBD_ratelimit(5*HZ, 5)) {
>
> The kernel has standard functions for this, no need for own macros.
>
> > +			ERR("bdev->md_bdev==NULL\n");
> > +			dump_stack();
> > +		}
>
> And a rate limited dump_stack seems weird anyways.
>

Ok, I changed that particular place to a BUG_ON(!bdev->md_bdev) .
I will etiher remove all the other DRBD_ratelimit()s we have,
or change the one of the kernel ratelemit variants.

[...]
> > +	/* in case hardsect != 512 [ s390 only? ] */
> > +	if (hardsect != MD_HARDSECT) {
> > +		if (!mdev->md_io_tmpp) {
> > +			struct page *page = alloc_page(GFP_NOIO);
>
> At least the conventional wisdom is still that block devices should
> use mempools, not alloc_page even with NOIO, otherwise they might
> not write out in all lowmem situations. There's been some VM work
> to address this, but so far nobody was sure that it is sufficient.
>
> > +			if (!page)
> > +				return 0;
>
> So you get a IO error or what happens here on out of memory?
>

Moved the allocation out of drbd_md_sync_page_io() into the attach
(DRBD speak for associating a backing device with a DRBD device)
code path. In case we need that ip_mpp page and we do not get it
we fail the complete attach now.

[...]
> > +		if (rw == WRITE) {
> > +			void *p = page_address(mdev->md_io_page);
> > +			void *hp = page_address(mdev->md_io_tmpp);
>
> What happens when the page is in highmem?
>

We are sure that they are not in highmem.

md_io_tmpp was allocated with GFP_NOIO (which in turn does not contain 
GFP_HIGHMEM) therefore it can not be in highmem. 

md_io_page gets allocated with GFP_KERNEL (no GFP_HIGHMEM either).


[...]
> > +
> > +		spin_lock_irq(&mdev->al_lock);
> > +		lc_changed(mdev->act_log, al_ext);
> > +		spin_unlock_irq(&mdev->al_lock);
> > +		wake_up(&mdev->al_wait);
>
> The wake_up outside the lock looks a little dangerous.
>

Please share you thoughts, why this looks a little dangerous ?

[...]
> > +	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer, al_tr_cycle,
> > ... */
>
> Doing checksumming inside a lock looks nasty.
>

Well, that is a mutex, not a spinlock. We need to hold that lock here,
to reserve md_io_page. The trivial checksumming done in here is done while
copying the transaction data to the io-page. 

Sorry, no way to shorten the lock holding time here, and BTW no need to.

> Didn't read further. It's a lot of code. This was not a complete review,
> just some quick comments.

Andi,

Thanks a lot for you comments!

I have updated the patch set
http://oss.linbit.com/drbd/mainline_submission/03-25/
and added one point to my todo list:
  * Removed DRBD_ratelimit().

When I am done with the list, I will repost the whole set to LKML.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

