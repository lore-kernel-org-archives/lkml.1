Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFDNMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFDNMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZFDNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:12:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42762 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZFDNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:11:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Luck\, Tony" <tony.luck@intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next end of partition problems?
References: <4a25b8e987329b28c@agluck-desktop.sc.intel.com>
	<4A25F5F7.9020506@gmail.com>
	<4a26ee864930956be@agluck-desktop.sc.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 04 Jun 2009 09:11:52 -0400
In-Reply-To: <4a26ee864930956be@agluck-desktop.sc.intel.com> (Tony Luck's
	message of "Wed, 03 Jun 2009 14:43:34 -0700")
Message-ID: <x497hzsp2hz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luck, Tony" <tony.luck@intel.com> writes:

>> What kind of controller/drive is this?
>
> lspci says the controller is:
> 06:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
>
> console log says drive is:
> scsi 0:0:1:0: Direct-Access     SEAGATE  ST318406LC       010A PQ: 0 ANSI: 3
>  target0:0:1: Beginning Domain Validation
>  target0:0:1: Ending Domain Validation
>  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
> sd 0:0:1:0: [sdb] 35843670 512-byte hardware sectors: (18.3 GB/17.0 GiB)
> sd 0:0:1:0: [sdb] Write Protect is off
> sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
> scsi 0:0:6:0: Processor         ESG-SHV  SCA HSBP M17     1.0D PQ: 0 ANSI: 2
>  target0:0:6: Beginning Domain Validation
> sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
>  target0:0:6: Ending Domain Validation
>  target0:0:6: asynchronous
>  sdb: sdb1 sdb2 sdb3
> sd 0:0:1:0: [sdb] Attached SCSI disk
>
> A git bisect between v2.6.30-rc7(good) and next-20090602(bad) points
> the finger at this commit (and reverting this change from next-20090602
> confirms it introduces this problem):
>
>
> commit db2dbb12dc47a50c7a4c5678f526014063e486f6
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Wed Apr 22 14:08:13 2009 +0200
>
>     block: implement blkdev_readpages
>     
>     Doing a proper block dev ->readpages() speeds up the crazy dump(8)
>     approach of using interleaved process IO.
>     
>     Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index f45dbc1..a85fe31 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -331,6 +331,12 @@ static int blkdev_readpage(struct file * file, struct page * page)
>  	return block_read_full_page(page, blkdev_get_block);
>  }
>  
> +static int blkdev_readpages(struct file *file, struct address_space *mapping,
> +			struct list_head *pages, unsigned nr_pages)
> +{
> +	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
> +}
> +
>  static int blkdev_write_begin(struct file *file, struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned flags,
>  			struct page **pagep, void **fsdata)
> @@ -1399,6 +1405,7 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
>  
>  static const struct address_space_operations def_blk_aops = {
>  	.readpage	= blkdev_readpage,
> +	.readpages	= blkdev_readpages,
>  	.writepage	= blkdev_writepage,
>  	.sync_page	= block_sync_page,
>  	.write_begin	= blkdev_write_begin,
>
>
> On a random hunch, I wondered whether this error message was connected to
> the fact that ia64 kernel has a 64K page size.  I re-built using a 4k
> pagesize ... and this also make the partition overrun message go away.
>
> So is it plausible that the blkdev_readpages() code is resulting in some
> readahead of a page that overlaps the partition end?  The partition size
> (15832057 * 1K block according to /proc/partitions) is not a multiple of
> the 64K page size ... but then it isn't a multiple of 4K either :-(

Thanks for digging into this, Tony.  I'll take a look at it today.
Jens, you can feel free to pull this for now.  I never did get you real
data showing the improvement anyway, so I'll try to do that as well.

Cheers,
Jeff
