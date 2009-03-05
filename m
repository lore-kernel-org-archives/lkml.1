Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZCEKvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZCEKvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZCEKu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:50:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42609 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbZCEKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:50:57 -0500
Date: Thu, 5 Mar 2009 11:50:54 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jim Paris <jim@jtan.com>, Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing video
  RAM as block device
In-Reply-To: <20090305083701.GQ11787@kernel.dk>
Message-ID: <alpine.LRH.2.00.0903051146440.2618@vixen.sonytel.be>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <20090305083701.GQ11787@kernel.dk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Jens,

On Thu, 5 Mar 2009, Jens Axboe wrote:
> On Wed, Mar 04 2009, Geert Uytterhoeven wrote:
> > Below is the rewrite of the PS3 Video RAM Storage Driver as a plain block
> > device, as requested by Arnd Bergmann.
> > 
> > The MTD-based PS3 Video RAM Storage Driver was integrated into the mainline
> > kernel in 2.6.29-rc1.
> > 
> > Ideally, we think it would be best if the existing MTD-based ps3vram driver
> > would be replaced by the new block-based ps3vram driver before 2.6.29 is
> > released. This would relieve the burden of supporting two different swap space
> > schemes on PS3 (swap on /dev/mtdblock0 vs. /dev/ps3vram) from the distro
> > maintainer's shoulders, as in that case there would never have been a stable
> > kernel version containing the MTD-based ps3vram driver.
> > 
> > What do you think? If this is accepted, I'll submit a patch to remove the MTD
> > ps3vram and add the new driver as ps3vram (instead of ps3vram-ng).
> > 
> > Thanks for your (review and other) comments!
> 
> I'd rewrite this as a ->make_request_fn handler instead. Then you can
> get rid of the kernel thread. IOW, change
> 
> queue = blk_init_queue(ps3vram_request, &priv->lock);
> 
> to
> 
> queue = blk_alloc_queue(GFP_KERNEL);
> blk_queue_make_request(queue, ps3vram_make_request);

Thanks, I didn't know that part...

> Add error handling of course, and call blk_queue_max_*() to set your
> limits for this device.

I took out the blk_queue_max_*() calls (compared to ps3disk.c), as none of the
limits apply, and the defaults are fine.

Is that OK, or is it better to make it explicit?

> Then add a ps3vram_make_request() ala:

> static void ps3vram_do_request(struct request_queue *q, struct bio *bio)
> {
> 	struct ps3_system_bus_device *dev = q->queuedata;
> 	struct ps3vram_priv *priv = dev->core.driver_data;
> 	int write, res, err = -EIO;
>         struct bio_vec *bv;
> 	sector_t sector;
> 	loff_t offset;
> 	size_t len, retlen;
>         int i;
> 
> 	write = bio_data_dir(bio) == WRITE;
> 
> 	sector = bio->bi_sector;
>         bio_for_each_segment(bv, bio, i) {
>                 char *ptr = page_address(bv->bv_page) + bv->bv_offset;
> 
>                 len = bv->bv_len;
> 	        offset = sector << 9;
> 
>         	if (write)
> 	        	res = ps3vram_write(dev, offset, len, &retlen, ptr);
>         	else
> 	        	res = ps3vram_read(dev, offset, len, &retlen, ptr);
> 
> 	        if (res) {
>         		dev_err(&dev->core, "%s failed\n", op);
> 	        	goto out;
>         	}
> 
>         	if (retlen != len) {
> 	        	dev_err(&dev->core, "Short %s\n", op);
> 		        goto out;
>         	}
>                 sector += (len >> 9);
>         }
> 
> 	dev_dbg(&dev->core, "%s completed\n", op);
>         err = 0;
> out:
>         bio_endio(bio, err);
> }
> 
> I just typed it here, so if it doesn't compile you get to keep the
> pieces :-)

OK, I'll give it a try...

BTW, does this mean the `simple' way, which I used based on LDD3, is
deprecated?

> Since ps3 is very RAM limited, I didn't bother with any highmem mapping
> for the bio, since I gather that isn't an issue on that platform. You
> may want to detail that in a comment above the page_addres() thing at
> the top of the loop, though.

PS3 is ppc64, so no highmem. But I guess I best add the code for that anyway,
in case people will copy the driver in the future (I remember receiving a
similar comment for ps3disk).

Thanks for your comments!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
