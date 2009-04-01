Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZDADwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZDADwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 23:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZDADw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 23:52:27 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48989 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZDADw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 23:52:26 -0400
Message-ID: <49D2E4F7.40701@oss.ntt.co.jp>
Date: Wed, 01 Apr 2009 12:52:23 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, tj@kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH 6/7] xfs: propagate issue-flush error code
References: <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0BC0A.9050909@oss.ntt.co.jp> <20090331233718.GT26138@disturbed>
In-Reply-To: <20090331233718.GT26138@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Mon, Mar 30, 2009 at 09:33:14PM +0900, Fernando Luis Vázquez Cao wrote:
>> blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
>> command execution) so its users should check for the return value.
>>
>> (This issues was first spotted Bartlomiej Zolnierkiewicz)
>>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> 
> I think this patch is unnecessary as well as being broken.
> 
> 
>> diff -urNp linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c linux-2.6.29/fs/xfs/xfs_vnodeops.c
>> --- linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c	2009-03-24 08:12:14.000000000 +0900
>> +++ linux-2.6.29/fs/xfs/xfs_vnodeops.c	2009-03-30 15:08:21.000000000 +0900
>> @@ -678,20 +678,20 @@ xfs_fsync(
>>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>  	}
>>
>> -	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
>> +	if (!error && (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
> 
> That is wrong. Even if there was a error, we still need to
> flush the device if it hasn't already been done.

If any of the previous writes failed there is no way to know what we are actually
flushing. When we know things went awry I do not see the point in flushing the
device since part of the data we were trying to sync might not have made it to
the device.

Anyway this is a minor nitpick/policy issue that can be easily reverted to keep
the previous behavior.

>>  		/*
>>  		 * If the log write didn't issue an ordered tag we need
>>  		 * to flush the disk cache for the data device now.
>>  		 */
>>  		if (!log_flushed)
>> -			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
>> +			error = xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
> 
> What happens if we get an EOPNOTSUPP here?
> That is a meaningless error to return to fsync()....

Please look at the code again. xfs_blkdev_issue_flush() calls blkdev_issue_flush()
which turns EOPNOTSUPP into 0 to hide that error from filesystems. It is the
non-EOPNOTSUPP errors that XFS should handle: the underlying device may support
write cache flushes and still fail to flush (due to hardware errors)!

This patch is an attempt to fix the current situation.

>>  		/*
>>  		 * If this inode is on the RT dev we need to flush that
>>  		 * cache as well.
>>  		 */
>> -		if (XFS_IS_REALTIME_INODE(ip))
>> -			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
>> +		if (!error && XFS_IS_REALTIME_INODE(ip))
>> +			error = xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
> 
> That is broken, too. The realtime device is a different device,
> so always should be flushed regardless of the return from the
> log device.

Does it still make sense when writes to the log have failed?

Thanks!

- Fernando
