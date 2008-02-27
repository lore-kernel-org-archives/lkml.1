Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYB0KQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYB0KQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYB0KQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:16:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20162 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbYB0KQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:16:10 -0500
Date: Wed, 27 Feb 2008 13:13:29 +0300
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] mm: fix blkdev size calculation in generic_write_checks
Message-ID: <20080227101329.GB3119@dmon-lap.sw.ru>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, axboe@kernel.dk
References: <20070815135228.GA10616@dnb.acronis.ru> <20080226154948.29043b44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226154948.29043b44.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:49 Tue 26 Feb     , Andrew Morton wrote:
> On Wed, 15 Aug 2007 17:52:28 +0400 Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> 
> > Currently block device size calculated regardless its
> > bd_block_size. This may result attempt to write outside
> > block device if i_size not aligned to bdev->bd_block_size
> > and result in EIO.
> > 
> > #### TEST_CASE_BEGIN
> > # fdisk -l /dev/sdc
> > Disk /dev/sdc: 36.7 GB, 36703918080 bytes
> > 255 heads, 63 sectors/track, 4462 cylinders
> > Units = cylinders of 16065 * 512 = 8225280 bytes
> > 
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdc1   *           1         254     2040223+  83  Ldinux
> > /dev/sdc2             255         379     1004062+  83  Linux
> > ####
> > #### /dev/sdc2 size not aligned to 4K
> > 
> > #### at this time bd_block_size == 512 so generic_write_check
> > #### performed correctly
> > # dd if=/dev/zero of=/dev/sdc2 bs=1k count=7 seek=1004058
> > dd: writing `/dev/sdc2': No space left on device
> > 5+0 records in
> > 4+0 records out
> > 
> > #### this bdev contain ext4fs with blksize = 4K
> > # mount /dev/sdc2 /mnt/
> > #### after we mounted this bdev bd_block_size == fsblksize == 4K
> > 
> > #### the same write operation failed with EIO
> > # dd if=/dev/zero of=/dev/sdc2 bs=1k count=7 seek=1004058
> > dd: writing `/dev/sdc2': Input/output error
> > 3+0 records in
> > 2+0 records out
> > #### Attempt to write whole fsblock result write access outside
> > #### blkdevice and cause -EIO (returned by blkdev_get_block)
> > #### TEST_CASE_END
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  mm/filemap.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 2c8776b..a23ee8a 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1867,9 +1867,11 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
> >  	} else {
> >  #ifdef CONFIG_BLOCK
> >  		loff_t isize;
> > +		unsigned int blksize;
> >  		if (bdev_read_only(I_BDEV(inode)))
> >  			return -EPERM;
> > -		isize = i_size_read(inode);
> > +		blksize = block_size(I_BDEV(inode));
> > +		isize = i_size_read(inode) & ~(blksize - 1);
> >  		if (*pos >= isize) {
> >  			if (*count || *pos > isize)
> >  				return -ENOSPC;
> 
> I'm trying to work out how the heck we fixed
In fact original issue (wich was reported by me) stil exist
# uname -a
Linux ts52 2.6.25-rc3 #8 SMP Wed Feb 27 11:41:29 MSK 2008 x86_64 x86_64 x86_64
GNU/Linux
# blockdev --getsz /dev/sda7 
208782
# blockdev --getbsz /dev/sda7 
4096
# dd if=/dev/zero of=/dev/sda7 bs=1k seek=104390 count=1
dd: writing `/dev/sda7': Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000918887 seconds, 0.0 kB/s

This issue triggered in blkdev_get_block(), which is VFS layer

> http://bugzilla.kernel.org/show_bug.cgi?id=10116
Issue from the bug was triggered in 
__generic_make_request()
  ->bio_check_eod()
    ->handle_bad_sector()
###Bug's log:
Feb 26 19:17:25 tux attempt to access beyond end of device
Feb 26 19:17:25 tux sr0: rw=0, want=4911744, limit=2097151
###Corresponding code:
 printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
                        bdevname(bio->bi_bdev, b),
                        bio->bi_rw,
                        (unsigned long long)bio->bi_sector + bio_sectors(bio),
                        (long long)(bio->bi_bdev->bd_inode->i_size >> 9));
This means that all vfs checks was already done 
(iblock >=max_block(I_BDEV(inode))) was TRUE at this time.
But during __generic_make_request() we have found what "want" was more whan x2
times biger than "limit". 
IMHO: this may happens because of bug in DVD driver itself.
> 
> We never merged your patch because it introduced problems.  But did we
> merge some alternative fix, or does the bug remain in there?
> 
