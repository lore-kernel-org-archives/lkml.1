Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZCEIhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZCEIhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZCEIhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:37:06 -0500
Received: from brick.kernel.dk ([93.163.65.50]:36646 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbZCEIhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:37:04 -0500
Date: Thu, 5 Mar 2009 09:37:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jim Paris <jim@jtan.com>, Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing
	video  RAM as block device
Message-ID: <20090305083701.GQ11787@kernel.dk>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04 2009, Geert Uytterhoeven wrote:
> 	Hi,
> 
> Below is the rewrite of the PS3 Video RAM Storage Driver as a plain block
> device, as requested by Arnd Bergmann.
> 
> The MTD-based PS3 Video RAM Storage Driver was integrated into the mainline
> kernel in 2.6.29-rc1.
> 
> Ideally, we think it would be best if the existing MTD-based ps3vram driver
> would be replaced by the new block-based ps3vram driver before 2.6.29 is
> released. This would relieve the burden of supporting two different swap space
> schemes on PS3 (swap on /dev/mtdblock0 vs. /dev/ps3vram) from the distro
> maintainer's shoulders, as in that case there would never have been a stable
> kernel version containing the MTD-based ps3vram driver.
> 
> What do you think? If this is accepted, I'll submit a patch to remove the MTD
> ps3vram and add the new driver as ps3vram (instead of ps3vram-ng).
> 
> Thanks for your (review and other) comments!

I'd rewrite this as a ->make_request_fn handler instead. Then you can
get rid of the kernel thread. IOW, change

queue = blk_init_queue(ps3vram_request, &priv->lock);

to

queue = blk_alloc_queue(GFP_KERNEL);
blk_queue_make_request(queue, ps3vram_make_request);

Add error handling of course, and call blk_queue_max_*() to set your
limits for this device. Then add a ps3vram_make_request() ala:

static void ps3vram_do_request(struct request_queue *q, struct bio *bio)
{
	struct ps3_system_bus_device *dev = q->queuedata;
	struct ps3vram_priv *priv = dev->core.driver_data;
	int write, res, err = -EIO;
        struct bio_vec *bv;
	sector_t sector;
	loff_t offset;
	size_t len, retlen;
        int i;

	write = bio_data_dir(bio) == WRITE;

	sector = bio->bi_sector;
        bio_for_each_segment(bv, bio, i) {
                char *ptr = page_address(bv->bv_page) + bv->bv_offset;

                len = bv->bv_len;
	        offset = sector << 9;

        	if (write)
	        	res = ps3vram_write(dev, offset, len, &retlen, ptr);
        	else
	        	res = ps3vram_read(dev, offset, len, &retlen, ptr);

	        if (res) {
        		dev_err(&dev->core, "%s failed\n", op);
	        	goto out;
        	}

        	if (retlen != len) {
	        	dev_err(&dev->core, "Short %s\n", op);
		        goto out;
        	}
                sector += (len >> 9);
        }

	dev_dbg(&dev->core, "%s completed\n", op);
        err = 0;
out:
        bio_endio(bio, err);
}

I just typed it here, so if it doesn't compile you get to keep the
pieces :-)

Since ps3 is very RAM limited, I didn't bother with any highmem mapping
for the bio, since I gather that isn't an issue on that platform. You
may want to detail that in a comment above the page_addres() thing at
the top of the loop, though.

-- 
Jens Axboe

