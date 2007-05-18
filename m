Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbXERCLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbXERCLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbXERCLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:11:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43343 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754892AbXERCLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:11:34 -0400
Date: Fri, 18 May 2007 12:11:14 +1000
From: David Chinner <dgc@sgi.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
Message-ID: <20070518021114.GV86004887@sgi.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org> <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de> <464CB577.5080106@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464CB577.5080106@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 10:05:11PM +0200, Michal Piotrowski wrote:
> I applied your patch and I get another oops
> 
> [  261.491499] XFS mounting filesystem loop0
> [  261.501641] Ending clean XFS mount for filesystem: loop0
> [  261.507698] SELinux: initialized (dev loop0, type xfs), uses xattr
> [  261.567441] XFS mounting filesystem loop0
> [  261.573931] allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
> [  261.582935] xfs_buf_get_noaddr: failed to map pages
> [  261.592478] Ending clean XFS mount for filesystem: loop0
> [  261.618543] SELinux: initialized (dev loop0, type xfs), uses xattr
> [  261.691563] XFS mounting filesystem loop0
> [  261.698927] allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
>                                   ^^^^^^^^^^^^^^^^^^^^
>                                   interesting

Yeah, looks like a vmalloc leak is occurring. I haven't noticed
it before because:

VmallocTotal: 137427898368 kB
VmallocUsed:   3128272 kB
VmallocChunk: 137424770048 kB

It takes a long time to leak enough vmapped space to run out on ia64...

That tends to imply we have a mapped buffer being leaked somewhere.
Interestingly, I don't see a memory leak so we must be freeing the
memory associated with the buffer, just not unmapping it first. Not
sure how that can happen yet.....

mount xfsVmallocUsed:    177808 kB
unmount xfs
mount xfsVmallocUsed:    178080 kB
unmount xfs
mount xfsVmallocUsed:    178352 kB
unmount xfs
mount xfsVmallocUsed:    178624 kB
unmount xfs
mount xfsVmallocUsed:    178896 kB
unmount xfs
mount xfsVmallocUsed:    179168 kB
unmount xfs
mount xfsVmallocUsed:    179440 kB
unmount xfs
mount xfsVmallocUsed:    179712 kB
unmount xfs
mount xfsVmallocUsed:    179984 kB

Looks like we're leaking 272kB of vmalloc space on each mount/unmount
cycle. I'm trying to track this down now....

> [  265.856480] Ending clean XFS mount for filesystem: loop0
> [  265.862260] SELinux: initialized (dev loop0, type xfs), uses xattr
> [  265.921288] XFS mounting filesystem loop0
> [  265.927123] xfs_buf_get_noaddr: failed to map pages
> [  265.932575] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
....
> [  266.077866] Call Trace:
> [  266.080611]  [<fdc75a12>] xlog_alloc_log+0x1b9/0x2cd [xfs]
> [  266.086286]  [<fdc75cd1>] xfs_log_mount+0x6b/0xf1 [xfs]
> [  266.091688]  [<fdc7ec47>] xfs_mountfs+0x959/0xc4a [xfs]

Groan - ASSERT(0) is the error handling there for debug kernels. If we fail
to allocate an iclogbuf on a non-debug kernel, it will panic like this.

I'll deal with that later....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
