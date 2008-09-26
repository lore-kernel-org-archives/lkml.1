Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYIZIDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYIZIDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYIZIDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:03:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55780 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYIZIDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:03:14 -0400
Date: Fri, 26 Sep 2008 10:03:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: marty <martyleisner@yahoo.com>
Cc: linux-kernel@vger.kernel.org, martin.leisner@xerox.com
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20080926080300.GR2677@kernel.dk>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <247018.46515.qm@web50603.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26 2008, marty wrote:
> We  have a large ram area on a PCI board (think of a custom
> framebuffer type application).  We're using 2.6.20.
> 
> We have the PCI ram mapped into kernel space, and knew the physical
> addresses.
> 
> We have a raw partition on the block device which we reserve for this.
> 
> We want to be able to stick the contents of selected portion of PCI
> ram onto a block device (disk).  Past incarnations modified the disk
> driver, and developed a special API so the custom driver  constructed
> scatter/gather lists and fed it to the driver (bypassing the elevator
> algorithm, to execute as the "next request".
> 
> What I'm looking is for a more generic/driver independent way of
> sticking contents of PCI ram onto a disk.
> 
> Is offset + length of each bio_vec < pagesize?

Yes, each vec is no more than a page.

> What's the best way to do this (much of my data is already in
> physically contiguous memory [and mapped into virtual memory)). 

You don't need it mapped into virtual memory. Whether the data is contig
or not does not matter, the block layer will handle it either way.

> Any good examples to look at?

Apart from where you get your memory from, you can easily use the
generic infrastructure for this. Something ala:

void my_end_io_function(struct bio *bio, int err)
{
        /*
         * whatever you need to do here, once you get this call IO is
         * done for that bio. put bio at the end to free it again.
         */
        ...

        bio_put(bio);
}

write_my_data(struct block_device, sector_t sector, unsigned int bytes)
{
        struct request_queue *q;
        struct bio *bio = NULL;
        struct page *page;
        unsigned int offset, length;

        q = bdev_get_queue(bdev);
        offset = first_page_offset;

        while (bytes) {
                if (!bio) {
                        unsigned int npages = (bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
                        bio = bio_alloc(GFP_KERNEL, npages);
                        bio->bi_sector = sector;
                        bio->bi_bdev = bdev_to_write_to;
                        bio->bi_end_io = my_end_io_function; /* called on io end */
                        bio->bi_private = some_data; /* if my_end_io_function wants that */
                }

                page = some_func_to_return_you_a_page_in_the_pci_mem(sector);
                length = bytes;
                if (length > PAGE_SIZE)
                        length = PAGE_SIZE;

                /* if this fails, we can't map more at this offset. send
                 * what we have and force a new bio alloc at the top of
                 * the loop
                 */
                if (!bio_add_page(bio, page, length, offset)) {
                        submit_bio(WRITE, bio);
                        bio = NULL;
                }

                bytes -= length;
                sector += length >> 9;
                offset = 0;
        }
}

totally untested, just typed into this email. So probably full of typos,
but you should get the idea.

-- 
Jens Axboe

