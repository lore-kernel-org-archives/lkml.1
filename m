Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbXEFFEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbXEFFEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 01:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXEFFEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 01:04:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60508 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbXEFFEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 01:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NGGRjP/XR/WNTZ9VZrVuBsu/j5Zjr+rPi8fKvGbzYFZbyf31QqcNLB112HrD9Sa03YREap6P7NogPhlajikTNgnk5AO6uC3dqD2VyXPPUeytge6tRfXGW99i69Ney+ITk69Ym3NEK/tIv6bcEcKp30FBmlhrl9tswKkoYn7rz80=
Message-ID: <6ec7a4340705052204n35f92d8bifb9e22b42cccaa53@mail.gmail.com>
Date: Sun, 6 May 2007 13:04:10 +0800
From: "Xu CanHao" <xucanhao@gmail.com>
To: 7eggert@gmx.de
Subject: Re: Ext3 vs NTFS performance
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <E1HkShF-0000zR-Ez@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <8hiYr-2fJ-1@gated-at.bofh.it> <8huGm-2W4-33@gated-at.bofh.it>
	 <E1HkShF-0000zR-Ez@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/6, Bodo Eggert <7eggert@gmx.de>:
> Theodore Tso <tytso@mit.edu> wrote:
>
> > But as has already been discussed on this thread, in situations where
> > the fileserver is under high memory pressure, any filesystem (XFS or
> > ext4) would still end up allocating blocks out of order, resulting in
> > fragmentation.  Explicit preallocation, as opposed to delayed
> > allocation, is really the best long-term solution; and in order to do
> > that, Samba needs to detect this scenario --- which as has been noted,
> > there appears to be no good reason for the Windows CIFS client (or any
> > other application)to be doing this, other than perhaps to deliberate
> > trigger a worst case allocation pattern in ext3 --- and translate it
> > into a explicit preallocation request.
>
> There is an interface to tell the kernel about the way the file will be
> accessed. IMO this interface should be used to do the preallocation, too.
>
> The other question is: How to tell the poor-bill's preallocation from a
> very clever application that communicates with another application and
> which is supposed to zero out that exact byte from the data the other
> application sent. I was tempted to say "just let samba cache these calls",
> but it would be wrong. You'll need magic in the kernel to DTRT.
>
> There are three correct ways of handling these one-zerobyte-writes after EOF:
>
> 1) Extend the file like truncate
> 2) Extend the file like write() (current behaviour)
> 3) Preallocate these blocks (to be implemented)
> 4) Write all zeroes (current behaviour for FAT)
>
> (2) will cause bad allocations, it's obviously worse than (1). (3) would be
> better than (1) and (2), but only xfs(?) and ext4 will support this in the
> near future. (4) should double the write time, but give the best possible
> read speed. According to [1], the expected read speed is about as high as (1)
> gives, "playback performance improves to expected levels". If preallocation
> does not seem to make a big difference, I don't think we should do (4) as
> a replacement untill the filesystem does support real preallocations.
>
>
> I suggest:
>
> 1) Make samba use fadvise(MIGHT_PREALLOCATE)
> 2) Make the kernel turn these 1-byte-writes-after-EOF into truncates
>    on MIGHT_PREALLOCATE, and possibly turn off MIGHT_PREALLOCATE on
>    other read/writes
> 3) Make the kernel fadvise(PREALLOCATE, $filesize)
>    on MIGHT_PREALLOCATE + lseek(0), turning off the MIGHT_PREALLOCATE
>    Possibly it might also turn on FADV_SEQUENTIAL.
> 4) Make the filesystems optionally preallocate the desired area, or
>    ignore fadvise(PREALLOCATE, $filesize) instead.
>
>
> [1] http://softwarecommunity.intel.com/articles/eng/1259.htm
> --
> It is still called paranoia when they really are out to get you.
>
> Friß, Spammer: oA@cvb2dX.7eggert.dyndns.org
>  CZCkzfiaNb@7eggert.dyndns.org nkp@7eggert.dyndns.org
>

So it would be possible, that "Explicit Preallocation" + "Delayed
Allocation" + (some other technology) would minimize file-system
fragmentation. And further more, massive fragments of large downloads
may could be solved by "Explicit Preallocation" too.
