Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZFDVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZFDVUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZFDVUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:20:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZFDVUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:20:36 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Luck\, Tony" <tony.luck@intel.com>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next end of partition problems?
References: <4a25b8e987329b28c@agluck-desktop.sc.intel.com>
	<4A25F5F7.9020506@gmail.com>
	<4a26ee864930956be@agluck-desktop.sc.intel.com>
	<x497hzsp2hz.fsf@segfault.boston.devel.redhat.com>
	<20090604203344.GE11363@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 04 Jun 2009 17:20:29 -0400
In-Reply-To: <20090604203344.GE11363@kernel.dk> (Jens Axboe's message of "Thu,
	4 Jun 2009 22:33:44 +0200")
Message-ID: <x49skifg0gy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Thu, Jun 04 2009, Jeff Moyer wrote:
>> "Luck, Tony" <tony.luck@intel.com> writes:
>> 
>> >> What kind of controller/drive is this?
>> >
>> > lspci says the controller is:
>> > 06:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
>> >
>> > console log says drive is:
>> > scsi 0:0:1:0: Direct-Access     SEAGATE  ST318406LC       010A PQ: 0 ANSI: 3
>> >  target0:0:1: Beginning Domain Validation
>> >  target0:0:1: Ending Domain Validation
>> >  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
>> > sd 0:0:1:0: [sdb] 35843670 512-byte hardware sectors: (18.3 GB/17.0 GiB)
>> > sd 0:0:1:0: [sdb] Write Protect is off
>> > sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
>> > scsi 0:0:6:0: Processor         ESG-SHV  SCA HSBP M17     1.0D PQ: 0 ANSI: 2
>> >  target0:0:6: Beginning Domain Validation
>> > sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
>> >  target0:0:6: Ending Domain Validation
>> >  target0:0:6: asynchronous
>> >  sdb: sdb1 sdb2 sdb3
>> > sd 0:0:1:0: [sdb] Attached SCSI disk
>> >
>> > A git bisect between v2.6.30-rc7(good) and next-20090602(bad) points
>> > the finger at this commit (and reverting this change from next-20090602
>> > confirms it introduces this problem):
>> >
>> >
>> > commit db2dbb12dc47a50c7a4c5678f526014063e486f6
>> > Author: Jeff Moyer <jmoyer@redhat.com>
>> > Date:   Wed Apr 22 14:08:13 2009 +0200
>> >
>> >     block: implement blkdev_readpages
>> >     
>> >     Doing a proper block dev ->readpages() speeds up the crazy dump(8)
>> >     approach of using interleaved process IO.
>> >     
>> >     Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> >     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>> >
>> > diff --git a/fs/block_dev.c b/fs/block_dev.c
>> > index f45dbc1..a85fe31 100644
>> > --- a/fs/block_dev.c
>> > +++ b/fs/block_dev.c
>> > @@ -331,6 +331,12 @@ static int blkdev_readpage(struct file * file, struct page * page)
>> >  	return block_read_full_page(page, blkdev_get_block);
>> >  }
>> >  
>> > +static int blkdev_readpages(struct file *file, struct address_space *mapping,
>> > +			struct list_head *pages, unsigned nr_pages)
>> > +{
>> > +	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
>> > +}
>> > +
>> >  static int blkdev_write_begin(struct file *file, struct address_space *mapping,
>> >  			loff_t pos, unsigned len, unsigned flags,
>> >  			struct page **pagep, void **fsdata)
>> > @@ -1399,6 +1405,7 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
>> >  
>> >  static const struct address_space_operations def_blk_aops = {
>> >  	.readpage	= blkdev_readpage,
>> > +	.readpages	= blkdev_readpages,
>> >  	.writepage	= blkdev_writepage,
>> >  	.sync_page	= block_sync_page,
>> >  	.write_begin	= blkdev_write_begin,
>> >
>> >
>> > On a random hunch, I wondered whether this error message was connected to
>> > the fact that ia64 kernel has a 64K page size.  I re-built using a 4k
>> > pagesize ... and this also make the partition overrun message go away.
>> >
>> > So is it plausible that the blkdev_readpages() code is resulting in some
>> > readahead of a page that overlaps the partition end?  The partition size
>> > (15832057 * 1K block according to /proc/partitions) is not a multiple of
>> > the 64K page size ... but then it isn't a multiple of 4K either :-(
>> 
>> Thanks for digging into this, Tony.  I'll take a look at it today.
>> Jens, you can feel free to pull this for now.  I never did get you real
>> data showing the improvement anyway, so I'll try to do that as well.
>
> OK, I'll revert it for now.

You can keep it reverted... forever and ever.  ;-)  I'm certain this
patch didn't have a *negative* impact when I sent it to you, but it sure
causes problems now!  (That's my story and I'm sticking to it!)  Dump is
~48% slower with the patch applied when using deadline, ~25% slower when
using cfq.  This testing was done using a 4 disk stripe off of a CCISS
controller.  This doesn't make a whole lot of sense to me, though I
don't have the bandwidth to go digging on this just now.

Sorry for the headaches, and thanks for the report, Tony!

Cheers,
Jeff

Dump average transfer rate for 32GB of data:

        | deadline   |    cfq   
--------+------------+-----------
Vanilla | 87353 kB/s | 46132 kB/s
Patched | 45756 kB/s | 34564 kB/s
