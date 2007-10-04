Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXJDSOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXJDSOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXJDSOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:14:36 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18122 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbXJDSOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:14:36 -0400
Date: Thu, 4 Oct 2007 20:16:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Message-ID: <20071004181606.GH5711@kernel.dk>
References: <20071002073943.GC5236@kernel.dk> <20071002092856.GG5236@kernel.dk> <200710031755.21068.arnd@arndb.de> <200710040048.20676.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710040048.20676.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04 2007, Arnd Bergmann wrote:
> On Wednesday 03 October 2007, Arnd Bergmann wrote:
> > Jens, I think the best overall solution would be to have a
> > block/compat_ioctl.c file with all the compat handling for block
> > devices moved over from fs/compat_ioctl.c, and done in a nicer way.
> > If you agree, with this approach, I'd volunteer to come up with a
> > patch.
> 
> Sometimes I find it hard to stop myself once I have the idea.
> The patch below moves all block related ioctl conversion out
> of fs/compat_ioctl.c into the compat_blkdev_ioctl() function.
> 
> Is that a direction we should be heading towards? If so, I
> can do some testing and split this big patch into more
> logical units for better review.

This looks a lot better! I don't mind seperating the block bits, when we
get the whole bunch in there. Just seemed overly silly and complicated
to do it for just one ioctl command. When you are happy with this patch,
I'll add it to the pending block stuff for 2.6.24. The blktrace fix
isn't a regression so need not go into 2.6.23.

It seems some bits are missing though (like BLKTRACESETUP32), did you
send the whole thing?

> I also found a few interesting bugs in the process:
> * BLKRASET is both ULONG_IOCTL and COMPATIBLE_IOCTL, but this should
>   be entirely harmless
> * BLKSECTGET writes 2 bytes normally, our compat_ version writes
>   4 bytes!
> * FDSETPRM32, FDDEFPRM32 and FDGETPRM32 are doing potentially dangerous
>   stuff with kernel pointers. sparse actually warns about this, but
>   from what I could see from floppy.c, the kernel always ignores these
>   pointers. I did not check any other floppy drivers implementing the
>   same calls.

Always nice to find bugs when doing cleanups ;-)


-- 
Jens Axboe

