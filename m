Return-Path: <linux-kernel-owner+w=401wt.eu-S1423217AbXEEPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423217AbXEEPoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423192AbXEEPoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:44:21 -0400
Received: from thunk.org ([69.25.196.29]:40466 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423229AbXEEPoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:44:11 -0400
Date: Sat, 5 May 2007 09:45:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: Xu CanHao <xucanhao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070505134504.GA21049@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Xu CanHao <xucanhao@gmail.com>, linux-kernel@vger.kernel.org
References: <6ec7a4340705042013r4a78a705s43f07da97ec43569@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ec7a4340705042013r4a78a705s43f07da97ec43569@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 11:13:36AM +0800, Xu CanHao wrote:
> On 5 Mai, 10:20, Theodore Tso <t...@mit.edu> wrote:
> >
> >This is being worked on already.  XFS has a per-filesystem ioctl, but
> >we want to create a filesystem-independent system call,
> >sys_fallocate(), that would wired into the already existing
> >posix_fallocate() function exported by glibc.
> 
> The story told us: an application must look to the file-systems, ext3
> is good at aaa, is not good at bbb; XFS is good at ccc, is not good at
> ddd; reiserfs is good at eee, is not good at fff........
> 
> For this scenario, XFS is good at dealing with fragmentation while ext3 not.

That's true.  XFS has the ability to do delayed allocations, so that
the blocks don't get allocated until they are written out.  Hence, a
workload that writes a pattern which uses random access writes in
strides of 128k, and then goes back to fill them in, will result in
fragmentation given ext3's current block reservation allocation
algorithm --- but, as long as the system isn't under high memory
pressure, XFS will do better in this particular scenario.

Actually, ext3 does have a block reservation system, which will
prevent this scenario if the random access writes are within a range
of 32k or so --- which is enough to protect against the bad effects of
more common random access write patterns, such as those used when
writing out ELF object files, for example.  Increasing
EXT3_DEFAULT_RESERVE_BLOCKS by a factor of 4 would adaopt the ext3
block reservation system to this pathalogical workload, and we could
easily add a tunable mount option to change the reservation size used
by ext3.  Unfortunately, this could make fragmentation work for other
workloads.  So adding delayed allocation to ext4 is a better solution.

But as has already been discussed on this thread, in situations where
the fileserver is under high memory pressure, any filesystem (XFS or
ext4) would still end up allocating blocks out of order, resulting in
fragmentation.  Explicit preallocation, as opposed to delayed
allocation, is really the best long-term solution; and in order to do
that, Samba needs to detect this scenario --- which as has been noted,
there appears to be no good reason for the Windows CIFS client (or any
other application)to be doing this, other than perhaps to deliberate
trigger a worst case allocation pattern in ext3 --- and translate it
into a explicit preallocation request.

Regards,

						- Ted
