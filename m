Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbZCXM22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbZCXM22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZCXM14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:27:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53518 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbZCXM1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:27:55 -0400
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 02/12] DRBD: activity_log
From: Andi Kleen <andi@firstfloor.org>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
	<1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
	<1237823287-12734-3-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com> (Philipp Reisner's message of "Mon, 23 Mar 2009 16:47:57 +0100")
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
Date: Tue, 24 Mar 2009 13:27:51 +0100
Message-ID: <87bprrhzqw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Reisner <philipp.reisner@linbit.com> writes:
> +
> +/* I do not believe that all storage medias can guarantee atomic
> + * 512 byte write operations. When the journal is read, only
> + * transactions with correct xor_sums are considered.
> + * sizeof() = 512 byte */
> +struct __attribute__((packed)) al_transaction {
> +	u32       magic;
> +	u32       tr_number;
> +	/* u32       tr_generation; TODO */

It would be difficult to "TODO" this because adding that field here would
break the complete disk format, wouldn't it?

> +	struct __attribute__((packed)) {
> +		u32 pos;
> +		u32 extent; } updates[1 + AL_EXTENTS_PT];
> +	u32       xor_sum;
> +};
> +	ok = bio_flagged(bio, BIO_UPTODATE) && md_io.error == 0;
> +
> +	/* check for unsupported barrier op.
> +	 * would rather check on EOPNOTSUPP, but that is not reliable.
> +	 * don't try again for ANY return value != 0 */
> +	if (unlikely(bio_barrier(bio) && !ok)) {

That's a good example for some code that shouldn't be in upstream. If
EOPNOTSUPP for barriers is really not reliable somewhere please just
fix that somewhere (if it's still true and not some ancient bug), not
add workarounds like this.

> +int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
> +			 sector_t sector, int rw)
> +{
> +	int hardsect, mask, ok;
> +	int offset = 0;
> +	struct page *iop = mdev->md_io_page;
> +
> +	D_ASSERT(mutex_is_locked(&mdev->md_io_mutex));
> +
> +	if (!bdev->md_bdev) {
> +		if (DRBD_ratelimit(5*HZ, 5)) {

The kernel has standard functions for this, no need for own macros.

> +			ERR("bdev->md_bdev==NULL\n");
> +			dump_stack();
> +		}


And a rate limited dump_stack seems weird anyways.

> +		return 0;
> +	}
> +
> +	hardsect = drbd_get_hardsect(bdev->md_bdev);
> +	if (hardsect == 0)
> +		hardsect = MD_HARDSECT;
> +
> +	/* in case hardsect != 512 [ s390 only? ] */
> +	if (hardsect != MD_HARDSECT) {
> +		if (!mdev->md_io_tmpp) {
> +			struct page *page = alloc_page(GFP_NOIO);

At least the conventional wisdom is still that block devices should 
use mempools, not alloc_page even with NOIO, otherwise they might
not write out in all lowmem situations. There's been some VM work
to address this, but so far nobody was sure that it is sufficient.


> +			if (!page)
> +				return 0;

So you get a IO error or what happens here on out of memory?

> +
> +			drbd_WARN("Meta data's bdev hardsect = %d != %d\n",
> +			     hardsect, MD_HARDSECT);
> +			drbd_WARN("Workaround engaged (has performace impact).\n");
> +
> +			mdev->md_io_tmpp = page;
> +		}
> +
> +		mask = (hardsect / MD_HARDSECT) - 1;
> +		D_ASSERT(mask == 1 || mask == 3 || mask == 7);
> +		D_ASSERT(hardsect == (mask+1) * MD_HARDSECT);
> +		offset = sector & mask;
> +		sector = sector & ~mask;
> +		iop = mdev->md_io_tmpp;
> +
> +		if (rw == WRITE) {
> +			void *p = page_address(mdev->md_io_page);
> +			void *hp = page_address(mdev->md_io_tmpp);

What happens when the page is in highmem?

> +		al_work.old_enr = al_ext->lc_number;
> +		al_work.w.cb = w_al_write_transaction;
> +		drbd_queue_work_front(&mdev->data.work, &al_work.w);
> +		wait_for_completion(&al_work.event);
> +
> +		mdev->al_writ_cnt++;
> +
> +		spin_lock_irq(&mdev->al_lock);
> +		lc_changed(mdev->act_log, al_ext);
> +		spin_unlock_irq(&mdev->al_lock);
> +		wake_up(&mdev->al_wait);

The wake_up outside the lock looks a little dangerous.

> +int
> +w_al_write_transaction(struct drbd_conf *mdev, struct drbd_work *w, int unused)
> +{
> +	struct update_al_work *aw = (struct update_al_work *)w;
> +	struct lc_element *updated = aw->al_ext;
> +	const unsigned int new_enr = aw->enr;
> +	const unsigned int evicted = aw->old_enr;
> +
> +	struct al_transaction *buffer;
> +	sector_t sector;
> +	int i, n, mx;
> +	unsigned int extent_nr;
> +	u32 xor_sum = 0;
> +
> +	if (!inc_local(mdev)) {
> +		ERR("inc_local() failed in w_al_write_transaction\n");
> +		complete(&((struct update_al_work *)w)->event);
> +		return 1;
> +	}
> +	/* do we have to do a bitmap write, first?
> +	 * TODO reduce maximum latency:
> +	 * submit both bios, then wait for both,
> +	 * instead of doing two synchronous sector writes. */
> +	if (mdev->state.conn < Connected && evicted != LC_FREE)
> +		drbd_bm_write_sect(mdev, evicted/AL_EXT_PER_BM_SECT);
> +
> +	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer, al_tr_cycle, ... */

Doing checksumming inside a lock looks nasty.

Didn't read further. It's a lot of code. This was not a complete review,
just some quick comments.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
