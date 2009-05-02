Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZEBRB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZEBRB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZEBRBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:01:18 -0400
Received: from [212.69.161.110] ([212.69.161.110]:42027 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZEBRBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:01:16 -0400
Date: Sat, 2 May 2009 19:00:19 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 03/16] DRBD: activity_log
Message-ID: <20090502170019.GB6466@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com> <20090501020149.83f0990b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501020149.83f0990b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 02:01:49AM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 13:26:39 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> 
> > Within DRBD the activity log is used to track extents (4MB each) in which IO
> > happens (or happened recently). It is based on the LRU cache. Each change of
> > the activity log causes a meta data update (single sector write).  The size
> > of the activity log is configured by the user, and is a tradeoff between
> > minimizing updates to the meta data and the resync time after the crash of a
> > primary node.
> > 
> 
> OK, this is where I lose the plot and start bikeshed-painting.

:(


> > +/* I do not believe that all storage medias can guarantee atomic
> > + * 512 byte write operations.
> 
> ooh.  I think you'd be safe assuming that in the Linux context. 
> Everything else does.
> 
> Not sure what this means, really.


there has been observations of real world hard disks,
which had _half_ updated 512 byte sectors after power loss.
sorry, I lost the link. I believe that was some 10 years ago,
and somehow one of the university collegues of Phil had been
involved in that testing. Maybe Phil can dig up the link
somewhere.

But actually that comment is not necessary to give a reason
for adding a (simplistic xor) checksum to an on-disk transaction,
and for having some more room for transactions in the on disk
transaction ring buffer than theoretically necessary.

> Please use __packed (whole patchset).

ack.

> > +void trace_drbd_resync(struct drbd_conf *mdev, int level, const char *fmt, ...)

> The "trace_" namespace is already taken.
> 
> I suggest that all globally visible symbols in this driver start with
> "drbd_".

well, it is a va_args wrapper around the in kernel tracing framework,
drbd tracepoints being declared in drbd_tracing.h.
so this _is_ the namespace you are talking about.

> > +STATIC int _drbd_md_sync_page_io(struct drbd_conf *mdev,
> > +				 struct drbd_backing_dev *bdev,
> > +				 struct page *page, sector_t sector,
> > +				 int rw, int size)
> > +{
> > +	struct bio *bio;
> > +	struct drbd_md_io md_io;
> > +	int ok;
> > +
> > +	md_io.mdev = mdev;
> > +	init_completion(&md_io.event);
> 
> urgh, you're going to have to scratch your head over
> DECLARE_COMPLETION_ONSTACK() here.
> 
> Has this code all been tested with all kernel debug options enabled? 
> inclusing lockdep?

Yes, last year I did that regularly.  Not sure if we still have that
enabled in one of our test clusters now, I need to double check.


> > +	md_io.error = 0;
> > +
> > +	if (rw == WRITE && !test_bit(MD_NO_BARRIER, &mdev->flags))
> > +		rw |= (1<<BIO_RW_BARRIER);
> > +	rw |= ((1<<BIO_RW_UNPLUG) | (1<<BIO_RW_SYNCIO));
> 
> The semantics of these flags seem to have been changing at 15Hz lately.
> You might want to check that this code still does what you think it
> does.

I know, I followed that closely.
Currently it does.

> It would be prudent to add comments explaining precisely what behaviour
> the driver is expecting from the lower layers, and why it wants that
> behaviour.

Ok.

...
> > +	if (unlikely(bio_barrier(bio) && !ok)) {
> > +		/* Try again with no barrier */
> > +		dev_warn(DEV, "Barriers not supported on meta data device - disabling\n");
> > +		set_bit(MD_NO_BARRIER, &mdev->flags);
> > +		rw &= ~(1 << BIO_RW_BARRIER);
> > +		bio_put(bio);
> 
> Maybe the original bio could be reused.

yes. and we used to do that, I think.  though which members of the bio
would needed to be re-init-ed to what, exactly, changed a few times in
the past iirc, so we went for "lets the block layer do it", to be on the
safe side.
you suggest to re-implement (oops. sorry. out-of-tree coder behind the
keyboard; re-use, of course!) drivers/md/dm-bio-record.h all over again?
or can we shorten that?

> > +	hardsect = drbd_get_hardsect(bdev->md_bdev);
> 
> hm.  Sounds like hardsect shold have type sector_t.
> 
> > +	if (hardsect == 0)
> > +		hardsect = MD_HARDSECT;
> > +
> > +	/* in case hardsect != 512 [ s390 only? ] */
> 
> Nope, it looks like it should have been called hardsect_size?

ok.

> 
> > +	if (hardsect != MD_HARDSECT) {
> > +		mask = (hardsect / MD_HARDSECT) - 1;
> > +		D_ASSERT(mask == 1 || mask == 3 || mask == 7);
> > +		D_ASSERT(hardsect == (mask+1) * MD_HARDSECT);
> > +		offset = sector & mask;
> > +		sector = sector & ~mask;
> > +		iop = mdev->md_io_tmpp;
> > +
> > +		if (rw == WRITE) {
> 
> This will evaluate to false if someone passed you WRITE_SYNC.  Maybe it
> should have been `if (rw & WRITE)'?

as this is a drbd internal function, and rw passes in only the data
direction, it will always become "sync" | "unplug" (though there is
one code path during initialization where we could optimize the unplug
away, if we preallocate a few pages), and for writes usually (unless
disabled in the config) also barrier, this code is correct.
though (rw & WRITE) would not make it wrong, of course, and more
flexible (e.g. if we "optimize" that initialization code path).

ok, will do.

> > +			void *p = page_address(mdev->md_io_page);
> > +			void *hp = page_address(mdev->md_io_tmpp);
> 
> I trust these pages cannot be in highmem.  If they are, they'll need
> kmapping.

these are alloc_page(GFP_KERNEL), allocated during device creation.
they are good.

> whitespace went funny.

yeah, that sometimes still happens :(

> > +		}
> > +	}
> > +
> > +	if (sector < drbd_md_first_sector(bdev) ||
> > +	    sector > drbd_md_last_sector(bdev))
> > +		dev_alert(DEV, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
> > +		     current->comm, current->pid, __func__,
> > +		     (unsigned long long)sector, rw ? "WRITE" : "READ");
> > +
> > +	ok = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, hardsect);
> > +	if (unlikely(!ok)) {
> > +		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed!\n",
> > +		    (unsigned long long)sector, rw ? "WRITE" : "READ");
> > +		return 0;
> > +	}
> > +
> > +	if (hardsect != MD_HARDSECT && rw == READ) {
> > +		void *p = page_address(mdev->md_io_page);
> > +		void *hp = page_address(mdev->md_io_tmpp);
> > +
> > +		memcpy(p, hp + offset*MD_HARDSECT, MD_HARDSECT);
> > +	}
> > +
> > +	return ok;
> > +}
> > +
> > +static inline
> > +struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
> > +{
> > +	struct lc_element *al_ext;
> > +	struct bm_extent  *bm_ext;
> > +	unsigned long     al_flags = 0;
> > +
> > +	spin_lock_irq(&mdev->al_lock);
> > +	bm_ext = (struct bm_extent *)
> > +		lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);
> 
> OK, what's going on here.
> 
> lc_find() returns an lc_element* and it's getting cast to a bm_extent*.
> 
> <tries to find the definition of bm_extent>
> 
> OK, it's defined five patches in the future.  Tricky!
> 
> +struct bm_extent {
> +	struct lc_element lce;
> +	int rs_left; /* number of bits set (out of sync) in this extent. */
> +	int rs_failed; /* number of failed resync requests in this extent. */
> +	unsigned long flags;
> +};
> 	
> I see what you did there.
> 
> Please use container_of().  It makes things much clearer and removes
> the requirement that the embedded lc_element be the first element in
> the outer strut.

we could.
but it would obscure the fact that in the current implementation of the
lru_cache, the struct lc_element _must_ be the first member of any such
user structure, see my other mail RE your lru_cache comments.

I guess we could simply remove the flexibility of the lru_cache and
lc_element, embedding "u64 payload[2]" into the struct lc_element,
and be done with it. would waste 16 bytes * nr_elements for the activity
log lru_cache, though.

> > +void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
> > +{
> > +	unsigned int enr = (sector >> (AL_EXTENT_SIZE_B-9));
> 
> This limits the maximum size of a device to 4 gigasectors * <however
> much that is>.


AL_EXTENT_SIZE is 4 MiB. 4 gigasectors * 4 MB is 16 PB.
currently maximum device size allowed in DRBD is 16 TB
(for dirty bitmap granularity reasons).

> Do we have a problem here?

depending on how you define "problem", yes.  this is not going to be
much use once the retailers start selling petabyte storage units.
we are working on it, though.

> We're getting deep into uncommented territory here.  Ths makes the code
> much harder to review, and makes the review less effective and makes
> the code harder to maintain and all those other things you already know ;)

yes. sorry.
going to improve on that next time around.

> > +	if (!inc_local(mdev)) {
> 
> <tries to find inc_local>
> 
> <finds it four patches in the future>
> 
> this is harder than it needs to be
> 
> <considers hunting for _inc_local_if_state>
> 
> <changes mind>
> 
> inc_local() isn't a very good choice of identifier, given its
> potentially-global scope.

oh, well, it "increases" the reference count on the "local disk".
but only "if" the "state" of the local disk is "as good or better"
than its argument ;)
there.

guess that was covered by the "missing documentation" rant above
already.

> The amount of inlining in drbd_int.h is bizarre.

hm. I'm not even sure were it comes from.

> > +	buffer->magic = __constant_cpu_to_be32(DRBD_MAGIC);
> 
> DRBD_MAGIC should be defined in magic.h.  Maybe it was - I didn't check.

ok.
we have a few variants of that magic, adding or xoring with it.
we'll discuss whether we need explicit defines of those,
and which one we can drop entirely.

> > +STATIC int drbd_al_read_tr(struct drbd_conf *mdev,
> 
> Can we please do s/STATIC/static/g and remove the definition of STATIC,
> whereever it is?

ok.

> > +			   struct drbd_backing_dev *bdev,
> > +			   struct al_transaction *b,
> > +			   int index)
> > +{
> > +	sector_t sector;
> > +	int rv, i;
> > +	u32 xor_sum = 0;
> > +
> > +	sector = bdev->md.md_offset + bdev->md.al_offset + index;
> 
> Strange that `index' doesn't have sector_t type, but I don't know (and
> wasn't told) what it represents.

no, actually it is the index into the fixed number of lc_elements
covered by the activity log lru_cache (AL).
and it is small by design, currently the maximum number we allow is 3833.
yes, that again should be documented better in the code.
it is documented in the man pages of the userland tools, though.

> > +#define S2W(s)	((s)<<(BM_EXT_SIZE_B-BM_BLOCK_SIZE_B-LN2_BPL))
> 
> S2W means, umm, "sector to ..."?

sector to "word", where word is meant as "unsigned long".

> Optimise the code for the code reader, please.

aye.

> > +	bio = bio_alloc(GFP_KERNEL, 1);
> 
> Should it be GFP_NOIO?

does not need to be.
happens outside the io path.

> > + * drbd_al_to_on_disk_bm:
> > + * Writes the areas of the bitmap which are covered by the AL.
> 
> what's an AL?

the "activity log".

> Please check all GFP_KERNELS, see if they should have been GFP_NOIO.

done years ago ;-)

> Again, we have the DECLARE_COMPLETION_ONSTACK() thing to worry about here.

I think we are good.
But we can change to use that anyways.

> <attention span exhausted, sorry>

Thank you very much.

Cheers,

	Lars
