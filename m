Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYIZKUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYIZKUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYIZKUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:20:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34785 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYIZKUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:20:04 -0400
Date: Fri, 26 Sep 2008 12:19:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: marty <martyleisner@yahoo.com>, linux-kernel@vger.kernel.org,
       martin.leisner@xerox.com
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20080926101954.GW2677@kernel.dk>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com> <20080926094653.1e0a9260@lxorguk.ukuu.org.uk> <20080926091135.GV2677@kernel.dk> <20080926110610.17603d30@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926110610.17603d30@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26 2008, Alan Cox wrote:
> On Fri, 26 Sep 2008 11:11:35 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Sep 26 2008, Alan Cox wrote:
> > > > What I'm looking is for a more generic/driver independent way of sticking
> > > > contents of PCI ram onto a disk.
> > > 
> > > Ermm seriously why not have a userspace task with the PCI RAM mmapped
> > > and just use write() like normal sane people do ?
> > 
> > To avoid the fault and copy, I would assume.
> 
> It's a write to a raw partition so with O_DIRECT you won't have to copy
> and MAP_POPULATE will premap the object if even the first write wants to
> occur without faulting overhead.

You are still going through get_user_pages() for each write. As I would
imagine the writes would generally be large, the hit would not be too
bad (but it's still there).

Depending on the hardware, it may or may not be a big deal. But the path
from device to disk is definitely a lot bigger and more complex with the
mmap/write approach.

Another alternative would be using splice - if the pci device exposed a
char device node, you could support ->splice_read() there which would
just fill the pages into the pipe buffer. Then change the block device
fops ->splice_write() to go direct to the block device through a bio
instead of using the page cache based generic_file_splice_write(). Such
a change would actually make sense to do, if the block device has been
opened with O_DIRECT. And it would get you about the same performance as
doing it in-kernel, the only extra overhead would be two syscalls per
64k (well probably only one extra syscall, since you probably need an
ioctl/syscall to initiate the in-kernel activity as well). So just about
as free as you could get.

-- 
Jens Axboe

