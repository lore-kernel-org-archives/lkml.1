Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZEAJLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZEAJLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEAJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:10:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbZEAJKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:10:51 -0400
Date: Fri, 1 May 2009 02:01:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 03/16] DRBD: activity_log
Message-Id: <20090501020149.83f0990b.akpm@linux-foundation.org>
In-Reply-To: <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 13:26:39 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Within DRBD the activity log is used to track extents (4MB each) in which IO
> happens (or happened recently). It is based on the LRU cache. Each change of
> the activity log causes a meta data update (single sector write).  The size
> of the activity log is configured by the user, and is a tradeoff between
> minimizing updates to the meta data and the resync time after the crash of a
> primary node.
> 

OK, this is where I lose the plot and start bikeshed-painting.

Has anyone done a serious review of this stuff yet?  If so, a link
would be appreciated.

> 
> ---
> diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
> new file mode 100644
> index 0000000..c894b4f
> --- /dev/null
> +++ b/drivers/block/drbd/drbd_actlog.c
> @@ -0,0 +1,1458 @@
> +/*
> +   drbd_actlog.c
> +
> +   This file is part of DRBD by Philipp Reisner and Lars Ellenberg.
> +
> +   Copyright (C) 2003-2008, LINBIT Information Technologies GmbH.
> +   Copyright (C) 2003-2008, Philipp Reisner <philipp.reisner@linbit.com>.
> +   Copyright (C) 2003-2008, Lars Ellenberg <lars.ellenberg@linbit.com>.
> +
> +   drbd is free software; you can redistribute it and/or modify
> +   it under the terms of the GNU General Public License as published by
> +   the Free Software Foundation; either version 2, or (at your option)
> +   any later version.
> +
> +   drbd is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with drbd; see the file COPYING.  If not, write to
> +   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> +
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/drbd.h>
> +#include "drbd_int.h"
> +#include "drbd_tracing.h"
> +#include "drbd_wrappers.h"
> +
> +/* I do not believe that all storage medias can guarantee atomic
> + * 512 byte write operations.

ooh.  I think you'd be safe assuming that in the Linux context. 
Everything else does.

Not sure what this means, really.

> When the journal is read, only
> + * transactions with correct xor_sums are considered.
> + * sizeof() = 512 byte */
> +struct __attribute__((packed)) al_transaction {
> +	u32       magic;
> +	u32       tr_number;
> +	struct __attribute__((packed)) {
> +		u32 pos;
> +		u32 extent; } updates[1 + AL_EXTENTS_PT];
> +	u32       xor_sum;
> +};

Please use __packed (whole patchset).

> +struct update_odbm_work {
> +	struct drbd_work w;
> +	unsigned int enr;
> +};
> +
> +struct update_al_work {
> +	struct drbd_work w;
> +	struct lc_element *al_ext;
> +	struct completion event;
> +	unsigned int enr;
> +	/* if old_enr != LC_FREE, write corresponding bitmap sector, too */
> +	unsigned int old_enr;
> +};
> +
> +struct drbd_atodb_wait {
> +	atomic_t           count;
> +	struct completion  io_done;
> +	struct drbd_conf   *mdev;
> +	int                error;
> +};
> +
> +
> +int w_al_write_transaction(struct drbd_conf *, struct drbd_work *, int);
> +
> +/* The actual tracepoint needs to have constant number of known arguments...
> + */
> +void trace_drbd_resync(struct drbd_conf *mdev, int level, const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	trace__drbd_resync(mdev, level, fmt, ap);
> +	va_end(ap);
> +}


The "trace_" namespace is already taken.

I suggest that all globally visible symbols in this driver start with
"drbd_".

> +STATIC int _drbd_md_sync_page_io(struct drbd_conf *mdev,
> +				 struct drbd_backing_dev *bdev,
> +				 struct page *page, sector_t sector,
> +				 int rw, int size)
> +{
> +	struct bio *bio;
> +	struct drbd_md_io md_io;
> +	int ok;
> +
> +	md_io.mdev = mdev;
> +	init_completion(&md_io.event);

urgh, you're going to have to scratch your head over
DECLARE_COMPLETION_ONSTACK() here.

Has this code all been tested with all kernel debug options enabled? 
inclusing lockdep?

> +	md_io.error = 0;
> +
> +	if (rw == WRITE && !test_bit(MD_NO_BARRIER, &mdev->flags))
> +		rw |= (1<<BIO_RW_BARRIER);
> +	rw |= ((1<<BIO_RW_UNPLUG) | (1<<BIO_RW_SYNCIO));

The semantics of these flags seem to have been changing at 15Hz lately.
You might want to check that this code still does what you think it
does.

It would be prudent to add comments explaining precisely what behaviour
the driver is expecting from the lower layers, and why it wants that
behaviour.

> + retry:
> +	bio = bio_alloc(GFP_NOIO, 1);
> +	bio->bi_bdev = bdev->md_bdev;
> +	bio->bi_sector = sector;
> +	ok = (bio_add_page(bio, page, size, 0) == size);
> +	if (!ok)
> +		goto out;
> +	bio->bi_private = &md_io;
> +	bio->bi_end_io = drbd_md_io_complete;
> +	bio->bi_rw = rw;
> +
> +	trace_drbd_bio(mdev, "Md", bio, 0, NULL);
> +
> +	if (FAULT_ACTIVE(mdev, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
> +		bio_endio(bio, -EIO);
> +	else
> +		submit_bio(rw, bio);
> +	wait_for_completion(&md_io.event);
> +	ok = bio_flagged(bio, BIO_UPTODATE) && md_io.error == 0;
> +
> +	/* check for unsupported barrier op.
> +	 * would rather check on EOPNOTSUPP, but that is not reliable.
> +	 * don't try again for ANY return value != 0 */
> +	if (unlikely(bio_barrier(bio) && !ok)) {
> +		/* Try again with no barrier */
> +		dev_warn(DEV, "Barriers not supported on meta data device - disabling\n");
> +		set_bit(MD_NO_BARRIER, &mdev->flags);
> +		rw &= ~(1 << BIO_RW_BARRIER);
> +		bio_put(bio);

Maybe the original bio could be reused.

> +		goto retry;
> +	}
> + out:
> +	bio_put(bio);
> +	return ok;
> +}
> +
> +int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
> +			 sector_t sector, int rw)
> +{
> +	int hardsect, mask, ok;
> +	int offset = 0;
> +	struct page *iop = mdev->md_io_page;
> +
> +	D_ASSERT(mutex_is_locked(&mdev->md_io_mutex));
> +
> +	BUG_ON(!bdev->md_bdev);
> +
> +	hardsect = drbd_get_hardsect(bdev->md_bdev);

hm.  Sounds like hardsect shold have type sector_t.

> +	if (hardsect == 0)
> +		hardsect = MD_HARDSECT;
> +
> +	/* in case hardsect != 512 [ s390 only? ] */

Nope, it looks like it should have been called hardsect_size?

> +	if (hardsect != MD_HARDSECT) {
> +		mask = (hardsect / MD_HARDSECT) - 1;
> +		D_ASSERT(mask == 1 || mask == 3 || mask == 7);
> +		D_ASSERT(hardsect == (mask+1) * MD_HARDSECT);
> +		offset = sector & mask;
> +		sector = sector & ~mask;
> +		iop = mdev->md_io_tmpp;
> +
> +		if (rw == WRITE) {

This will evaluate to false if someone passed you WRITE_SYNC.  Maybe it
should have been `if (rw & WRITE)'?

> +			void *p = page_address(mdev->md_io_page);
> +			void *hp = page_address(mdev->md_io_tmpp);

I trust these pages cannot be in highmem.  If they are, they'll need
kmapping.

> +			ok = _drbd_md_sync_page_io(mdev, bdev, iop,
> +						   sector, READ, hardsect);
> +
> +			if (unlikely(!ok)) {
> +				dev_err(DEV, "drbd_md_sync_page_io(,%llus,"
> +				    "READ [hardsect!=512]) failed!\n",
> +				    (unsigned long long)sector);
> +				return 0;
> +			}
> +
> +			memcpy(hp + offset*MD_HARDSECT , p, MD_HARDSECT);

whitespace went funny.

> +		}
> +	}
> +
> +	if (sector < drbd_md_first_sector(bdev) ||
> +	    sector > drbd_md_last_sector(bdev))
> +		dev_alert(DEV, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
> +		     current->comm, current->pid, __func__,
> +		     (unsigned long long)sector, rw ? "WRITE" : "READ");
> +
> +	ok = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, hardsect);
> +	if (unlikely(!ok)) {
> +		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed!\n",
> +		    (unsigned long long)sector, rw ? "WRITE" : "READ");
> +		return 0;
> +	}
> +
> +	if (hardsect != MD_HARDSECT && rw == READ) {
> +		void *p = page_address(mdev->md_io_page);
> +		void *hp = page_address(mdev->md_io_tmpp);
> +
> +		memcpy(p, hp + offset*MD_HARDSECT, MD_HARDSECT);
> +	}
> +
> +	return ok;
> +}
> +
> +static inline
> +struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
> +{
> +	struct lc_element *al_ext;
> +	struct bm_extent  *bm_ext;
> +	unsigned long     al_flags = 0;
> +
> +	spin_lock_irq(&mdev->al_lock);
> +	bm_ext = (struct bm_extent *)
> +		lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);

OK, what's going on here.

lc_find() returns an lc_element* and it's getting cast to a bm_extent*.

<tries to find the definition of bm_extent>

OK, it's defined five patches in the future.  Tricky!

+struct bm_extent {
+	struct lc_element lce;
+	int rs_left; /* number of bits set (out of sync) in this extent. */
+	int rs_failed; /* number of failed resync requests in this extent. */
+	unsigned long flags;
+};
	
I see what you did there.

Please use container_of().  It makes things much clearer and removes
the requirement that the embedded lc_element be the first element in
the outer strut.

A good way of doing this is to implement the container_of() in a single
helper function and to then call that helper function in all the
relevant places.  This improves readability and provides a much better
level of typechecking.

Doubtless these comments apply to many places in this patchset.

> +	if (unlikely(bm_ext != NULL)) {
> +		if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
> +			spin_unlock_irq(&mdev->al_lock);
> +			return NULL;
> +		}
> +	}
> +	al_ext   = lc_get(mdev->act_log, enr);
> +	al_flags = mdev->act_log->flags;
> +	spin_unlock_irq(&mdev->al_lock);
> +
> +	/*
> +	if (!al_ext) {
> +		if (al_flags & LC_STARVING)
> +			dev_warn(DEV, "Have to wait for LRU element (AL too small?)\n");
> +		if (al_flags & LC_DIRTY)
> +			dev_warn(DEV, "Ongoing AL update (AL device too slow?)\n");
> +	}
> +	*/
> +
> +	return al_ext;
> +}
> +
> +void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
> +{
> +	unsigned int enr = (sector >> (AL_EXTENT_SIZE_B-9));

This limits the maximum size of a device to 4 gigasectors * <however
much that is>.

Do we have a problem here?

> +	struct lc_element *al_ext;
> +	struct update_al_work al_work;
> +
> +	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
> +
> +	trace_drbd_actlog(mdev, sector, "al_begin_io");
> +
> +	wait_event(mdev->al_wait, (al_ext = _al_get(mdev, enr)));
> +
> +	if (al_ext->lc_number != enr) {
> +		/* drbd_al_write_transaction(mdev,al_ext,enr);
> +		   generic_make_request() are serialized on the
> +		   current->bio_tail list now. Therefore we have
> +		   to deligate writing something to AL to the
> +		   worker thread. */
> +		init_completion(&al_work.event);
> +		al_work.al_ext = al_ext;
> +		al_work.enr = enr;
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
> +	}
> +}
> +
> +void drbd_al_complete_io(struct drbd_conf *mdev, sector_t sector)
> +{
> +	unsigned int enr = (sector >> (AL_EXTENT_SIZE_B-9));
> +	struct lc_element *extent;
> +	unsigned long flags;
> +
> +	trace_drbd_actlog(mdev, sector, "al_complete_io");
> +
> +	spin_lock_irqsave(&mdev->al_lock, flags);
> +
> +	extent = lc_find(mdev->act_log, enr);
> +
> +	if (!extent) {
> +		spin_unlock_irqrestore(&mdev->al_lock, flags);
> +		dev_err(DEV, "al_complete_io() called on inactive extent %u\n", enr);
> +		return;
> +	}
> +
> +	if (lc_put(mdev->act_log, extent) == 0)
> +		wake_up(&mdev->al_wait);
> +
> +	spin_unlock_irqrestore(&mdev->al_lock, flags);
> +}
> +
> +int
> +w_al_write_transaction(struct drbd_conf *mdev, struct drbd_work *w, int unused)
> +{

We're getting deep into uncommented territory here.  Ths makes the code
much harder to review, and makes the review less effective and makes
the code harder to maintain and all those other things you already know ;)

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

strange newline in middle of local definitions.

> +	if (!inc_local(mdev)) {

<tries to find inc_local>

<finds it four patches in the future>

this is harder than it needs to be

<considers hunting for _inc_local_if_state>

<changes mind>

inc_local() isn't a very good choice of identifier, given its
potentially-global scope.

The amount of inlining in drbd_int.h is bizarre.

> +		dev_err(DEV, "inc_local() failed in w_al_write_transaction\n");
> +		complete(&((struct update_al_work *)w)->event);
> +		return 1;
> +	}
> +	/* do we have to do a bitmap write, first?
> +	 * TODO reduce maximum latency:
> +	 * submit both bios, then wait for both,
> +	 * instead of doing two synchronous sector writes. */
> +	if (mdev->state.conn < C_CONNECTED && evicted != LC_FREE)
> +		drbd_bm_write_sect(mdev, evicted/AL_EXT_PER_BM_SECT);
> +
> +	mutex_lock(&mdev->md_io_mutex); /* protects md_io_page, al_tr_cycle, ... */
> +	buffer = (struct al_transaction *)page_address(mdev->md_io_page);
> +
> +	buffer->magic = __constant_cpu_to_be32(DRBD_MAGIC);

DRBD_MAGIC should be defined in magic.h.  Maybe it was - I didn't check.

> +	buffer->tr_number = cpu_to_be32(mdev->al_tr_number);
> +
> +	n = lc_index_of(mdev->act_log, updated);
> +
> +	buffer->updates[0].pos = cpu_to_be32(n);
> +	buffer->updates[0].extent = cpu_to_be32(new_enr);
> +
> +	xor_sum ^= new_enr;
> +
> +	mx = min_t(int, AL_EXTENTS_PT,
> +		   mdev->act_log->nr_elements - mdev->al_tr_cycle);
> +	for (i = 0; i < mx; i++) {
> +		extent_nr = lc_entry(mdev->act_log,
> +				     mdev->al_tr_cycle+i)->lc_number;
> +		buffer->updates[i+1].pos = cpu_to_be32(mdev->al_tr_cycle+i);
> +		buffer->updates[i+1].extent = cpu_to_be32(extent_nr);
> +		xor_sum ^= extent_nr;
> +	}
> +	for (; i < AL_EXTENTS_PT; i++) {
> +		buffer->updates[i+1].pos = __constant_cpu_to_be32(-1);
> +		buffer->updates[i+1].extent = __constant_cpu_to_be32(LC_FREE);
> +		xor_sum ^= LC_FREE;
> +	}
> +	mdev->al_tr_cycle += AL_EXTENTS_PT;
> +	if (mdev->al_tr_cycle >= mdev->act_log->nr_elements)
> +		mdev->al_tr_cycle = 0;
> +
> +	buffer->xor_sum = cpu_to_be32(xor_sum);
> +
> +	sector =  mdev->bc->md.md_offset
> +		+ mdev->bc->md.al_offset + mdev->al_tr_pos;
> +
> +	if (!drbd_md_sync_page_io(mdev, mdev->bc, sector, WRITE)) {
> +		drbd_chk_io_error(mdev, 1, TRUE);
> +		drbd_io_error(mdev, TRUE);
> +	}
> +
> +	if (++mdev->al_tr_pos >
> +	    div_ceil(mdev->act_log->nr_elements, AL_EXTENTS_PT))
> +		mdev->al_tr_pos = 0;
> +
> +	D_ASSERT(mdev->al_tr_pos < MD_AL_MAX_SIZE);
> +	mdev->al_tr_number++;
> +
> +	mutex_unlock(&mdev->md_io_mutex);
> +
> +	complete(&((struct update_al_work *)w)->event);
> +	dec_local(mdev);
> +
> +	return 1;
> +}
> +
> +/**
> + * drbd_al_read_tr: Reads a single transaction record form the

"from"

> + * on disk activity log.
> + * Returns -1 on IO error, 0 on checksum error and 1 if it is a valid
> + * record.
> + */
> +STATIC int drbd_al_read_tr(struct drbd_conf *mdev,

Can we please do s/STATIC/static/g and remove the definition of STATIC,
whereever it is?

> +			   struct drbd_backing_dev *bdev,
> +			   struct al_transaction *b,
> +			   int index)
> +{
> +	sector_t sector;
> +	int rv, i;
> +	u32 xor_sum = 0;
> +
> +	sector = bdev->md.md_offset + bdev->md.al_offset + index;

Strange that `index' doesn't have sector_t type, but I don't know (and
wasn't told) what it represents.

> +	/* Dont process error normally,
> +	 * as this is done before disk is atached! */
> +	if (!drbd_md_sync_page_io(mdev, bdev, sector, READ))
> +		return -1;
> +
> +	rv = (be32_to_cpu(b->magic) == DRBD_MAGIC);
> +
> +	for (i = 0; i < AL_EXTENTS_PT + 1; i++)
> +		xor_sum ^= be32_to_cpu(b->updates[i].extent);
> +	rv &= (xor_sum == be32_to_cpu(b->xor_sum));
> +
> +	return rv;
> +}
> +
>
> ...
>
> +#define S2W(s)	((s)<<(BM_EXT_SIZE_B-BM_BLOCK_SIZE_B-LN2_BPL))

S2W means, umm, "sector to ..."?

Optimise the code for the code reader, please.

> +/* activity log to on disk bitmap -- prepare bio unless that sector
> + * is already covered by previously prepared bios */
> +STATIC int atodb_prepare_unless_covered(struct drbd_conf *mdev,
> +					struct bio **bios,
> +					unsigned int enr,
> +					struct drbd_atodb_wait *wc) __must_hold(local)
> +{
> +	struct bio *bio;
> +	struct page *page;
> +	sector_t on_disk_sector = enr + mdev->bc->md.md_offset
> +				      + mdev->bc->md.bm_offset;
> +	unsigned int page_offset = PAGE_SIZE;
> +	int offset;
> +	int i = 0;
> +	int err = -ENOMEM;
> +
> +	/* Check if that enr is already covered by an already created bio.
> +	 * Caution, bios[] is not NULL terminated,
> +	 * but only initialized to all NULL.
> +	 * For completely scattered activity log,
> +	 * the last invocation iterates over all bios,
> +	 * and finds the last NULL entry.
> +	 */
> +	while ((bio = bios[i])) {
> +		if (bio->bi_sector == on_disk_sector)
> +			return 0;
> +		i++;
> +	}
> +	/* bios[i] == NULL, the next not yet used slot */
> +
> +	bio = bio_alloc(GFP_KERNEL, 1);

Should it be GFP_NOIO?

> +	if (bio == NULL)
> +		return -ENOMEM;
> +
> +	if (i > 0) {
> +		const struct bio_vec *prev_bv = bios[i-1]->bi_io_vec;
> +		page_offset = prev_bv->bv_offset + prev_bv->bv_len;
> +		page = prev_bv->bv_page;
> +	}
> +	if (page_offset == PAGE_SIZE) {
> +		page = alloc_page(__GFP_HIGHMEM);
> +		if (page == NULL)
> +			goto out_bio_put;
> +		page_offset = 0;
> +	} else {
> +		get_page(page);
> +	}
> +
> +	offset = S2W(enr);
> +	drbd_bm_get_lel(mdev, offset,
> +			min_t(size_t, S2W(1), drbd_bm_words(mdev) - offset),
> +			kmap(page) + page_offset);
> +	kunmap(page);
> +
> +	bio->bi_private = wc;
> +	bio->bi_end_io = atodb_endio;
> +	bio->bi_bdev = mdev->bc->md_bdev;
> +	bio->bi_sector = on_disk_sector;
> +
> +	if (bio_add_page(bio, page, MD_HARDSECT, page_offset) != MD_HARDSECT)
> +		goto out_put_page;
> +
> +	atomic_inc(&wc->count);
> +	/* we already know that we may do this...
> +	 * inc_local_if_state(mdev,D_ATTACHING);
> +	 * just get the extra reference, so that the local_cnt reflects
> +	 * the number of pending IO requests DRBD at its backing device.
> +	 */
> +	atomic_inc(&mdev->local_cnt);
> +
> +	bios[i] = bio;
> +
> +	return 0;
> +
> +out_put_page:
> +	err = -EINVAL;
> +	put_page(page);
> +out_bio_put:
> +	bio_put(bio);
> +	return err;
> +}
> +
> +/**
> + * drbd_al_to_on_disk_bm:
> + * Writes the areas of the bitmap which are covered by the AL.

what's an AL?

> + * called when we detach (unconfigure) local storage,
> + * or when we go from R_PRIMARY to R_SECONDARY state.
> + */
> +void drbd_al_to_on_disk_bm(struct drbd_conf *mdev)
> +{
> +	int i, nr_elements;
> +	unsigned int enr;
> +	struct bio **bios;
> +	struct drbd_atodb_wait wc;
> +
> +	ERR_IF (!inc_local_if_state(mdev, D_ATTACHING))
> +		return; /* sorry, I don't have any act_log etc... */
> +
> +	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
> +
> +	nr_elements = mdev->act_log->nr_elements;
> +
> +	bios = kzalloc(sizeof(struct bio *) * nr_elements, GFP_KERNEL);

Please check all GFP_KERNELS, see if they should have been GFP_NOIO.

> +	if (!bios)
> +		goto submit_one_by_one;
> +
> +	atomic_set(&wc.count, 0);
> +	init_completion(&wc.io_done);

Again, we have the DECLARE_COMPLETION_ONSTACK() thing to worry about here.

<attention span exhausted, sorry>

>
> ...
>
