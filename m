Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXEYTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXEYTkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764401AbXEYTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:40:44 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45490 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764383AbXEYTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:40:43 -0400
Date: Fri, 25 May 2007 21:40:42 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
In-Reply-To: <200705251826.25572.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0705252137230.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.575306000@sonycom.com>
 <200705251826.25572.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Arnd Bergmann wrote:
> On Friday 25 May 2007, Geert.Uytterhoeven@sonycom.com wrote:
> > +static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
> > +				   struct request *req, int gather)
> > +{
> > +	unsigned int sectors = 0, offset = 0;
> > +	struct bio *bio;
> > +	sector_t sector;
> > +	struct bio_vec *bvec;
> > +	unsigned int i = 0, j;
> > +	size_t size;
> > +	void *buf;
> > +
> > +	rq_for_each_bio(bio, req) {
> > +		sector = bio->bi_sector;
> > +		dev_dbg(&dev->sbd.core,
> > +			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> > +			__func__, __LINE__, i, bio_segments(bio),
> > +			bio_sectors(bio), sector);
> > +		bio_for_each_segment(bvec, bio, j) {
> > +			size = bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
> > +			buf = __bio_kmap_atomic(bio, j, KM_USER0);
> > +			if (gather)
> > +				memcpy(dev->bounce_buf+offset, buf, size);
> > +			else
> > +				memcpy(buf, dev->bounce_buf+offset, size);
> > +			offset += size;
> > +			__bio_kunmap_atomic(bio, KM_USER0);
> > +		}
> > +		sectors += bio_sectors(bio);
> > +		i++;
> > +	}
> > +}
> 
> So the hypervison uses guest-real addresses here? I would have expected
> it to use the kernel page tables, which lets you use vmap() to do
> scatter-gather.

Yes, it uses logical partion addresses, so we cannot create a virtually
contiguous mapping.

> > +static int ps3disk_thread(void *data)
> > +{
> > +	struct ps3_storage_device *dev = data;
> > +	struct ps3disk_private *priv = ps3disk_priv(dev);
> > +	request_queue_t *q = priv->queue;
> > +	struct request *req;
> > +
> > +	dev_dbg(&dev->sbd.core, "%s thread init\n", __func__);
> > +
> > +	current->flags |= PF_NOFREEZE;
> > +
> > +	while (!kthread_should_stop()) {
> > +		spin_lock_irq(&priv->lock);
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +		req = elv_next_request(q);
> > +		if (!req) {
> > +			spin_unlock_irq(&priv->lock);
> > +			schedule();
> > +			continue;
> > +		}
> > +		if (!blk_fs_request(req)) {
> > +			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
> > +			end_request(req, 0);
> > +			spin_unlock_irq(&priv->lock);
> > +			continue;
> > +		}
> > +		spin_unlock_irq(&priv->lock);
> > +		ps3disk_handle_request_sg(dev, req);
> > +	}
> > +
> > +	dev_dbg(&dev->sbd.core, "%s thread exit\n", __func__);
> > +	return 0;
> > +}
> 
> I don't really understand what the kthread is needed for. You probably
> thought about multiple options and ended up with this, but having
> a comment in front of it might be helpful.

I used a kthread because the request function of a block device driver must be
non-blocking, and ps3stor_read_write_sectors() calls wait_for_completion().

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
