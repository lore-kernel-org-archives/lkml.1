Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZHQWAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZHQWAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZHQWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:00:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZHQWAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:00:03 -0400
Date: Mon, 17 Aug 2009 18:00:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com
Subject: Re: [PATCH 0/3] Page based O_DIRECT and O_DIRECT loop
Message-ID: <20090817220003.GA1094@infradead.org>
References: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 12:34:31PM +0200, Jens Axboe wrote:
> Hi,
> 
> Currently it's not feasible to use loop for O_DIRECT workloads
> that expect some sort of data integrity, since loop always
> uses page cache IO. Some time ago, I posted a variant of loop
> that used remapping to function like a proper disk, but that patch
> was a bit fragile in that it relied loop maintaining a fs block
> remapping tree. This time I wanted to take a different approach.
> 
> The first two patches in this series convert the O_DIRECT IO path
> to be page based instead of passing down the iovecs. This is
> basically a first version so don't expect too much of it, but it
> does seem to work fine for me. Most O_DIRECT users were one-liner
> conversions, NFS required a bit more effort (and that effort has, btw,
> not been tested at all yet). At least the diffstat for the core bits
> don't look too bad:

Nice!  I took a quick look and here are some superficial comments:

 - right nbow this loveses all the benefits of using preadv/pwritev.
   Qemu/KVM will not be happy about this.  We need some way to submit
   each vector asynchronously first and then only wait for all of them
   to complete.
 - do_dio is a rather odd name.  What about resurrecting
   generic_file_direct_IO?
 - it would be great if we could kill dio_args.user_addr and move
   everything that deals with it to do_dio/generic_file_direct_IO.
   Given that only look at it in __blockdev_direct_IO and
   direct_io_worker beforew we start the real work that sounds doable
   relatively easily.  The only issue might be NFS.
   After this all the bits that deal with user addresses could live
   in filemap.c and keep this totally out of direct-io.c
 - why is the rw argument no part of struct dio_args?  IMHO it
   should move in there.
 - patch 1 should probably be split further into a first patch just
   introducing struct dio_args, and then doing the heavy lifting without
   touching all the filesystems.

Also this stuff will massively catch with my patch to sort out the
locking mess in __blockdev_direct_IO, you might consider working ontop
of that.
