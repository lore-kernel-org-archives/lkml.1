Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbYBZBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbYBZBh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYBZBhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:37:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYBZBhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:37:18 -0500
Date: Tue, 26 Feb 2008 01:36:56 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Anders Henke <anders.henke@1und1.de>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: device mapper not reporting no-barrier-support?
Message-ID: <20080226013656.GE1788@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Anders Henke <anders.henke@1und1.de>,
	Jens Axboe <jens.axboe@oracle.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <20080225132615.GA21990@1und1.de> <20080225152050.94788622.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225152050.94788622.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 03:20:50PM -0800, Andrew Morton wrote:
> On Mon, 25 Feb 2008 14:26:15 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > I'm currently stuck between Kernel LVM and DRBD, as I'm using Kernel
> > 2.6.24.2 with DRBD 8.2.5 on top of an LVM2 device (LV).
> > -LVM2/device mapper doesn't support write barriers

That's right.

> > -DRBD uses blkdev_issue_flush() to flush its metadata to disk.

Which won't work if device-mapper is underneath.

> >  On a no-barrier-device, DRBD should receive EOPNOTSUPP, but
> >  it really does receive an EIO. Promptly, DRBD gives the
> >  error message "drbd0: local disk flush failed with status -5".
> > I've posted a lengty summary of my findings to
> > http://lists.linbit.com/pipermail/drbd-user/2008-February/008665.html
> > ... that DRBD does catch the EOPNOTSUPP for blkdev_issue_flush and
> > BIO_RW_BARRIER, but the lvm implementation of blkdev_issue_flush in
> > 2.6.24.2 aparently does return EIO for blkdev_issue_flush.
> I'd say it's a DM bug.

The dm code is unchanged, but look at the limited endio handling in
ll_rw_blk.c:

static void bio_end_empty_barrier(struct bio *bio, int err)
{
        if (err)
                clear_bit(BIO_UPTODATE, &bio->bi_flags);

        complete(bio->bi_private);
}

int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
{
...
        wait_for_completion(&wait);
        if (error_sector)
                *error_sector = bio->bi_sector;
        ret = 0;
        if (!bio_flagged(bio, BIO_UPTODATE))
                ret = -EIO;

Alasdair
-- 
agk@redhat.com
