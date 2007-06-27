Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbXF0Gmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbXF0Gmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbXF0Gm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:42:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57262 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758178AbXF0Gm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:42:28 -0400
Message-ID: <468206C0.90009@sgi.com>
Date: Wed, 27 Jun 2007 16:42:08 +1000
From: Tim Shimmin <tes@sgi.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: Jarek Poplawski <jarkao2@o2.pl>, David Chinner <dgc@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Satyam Sharma <satyam.sharma@gmail.com>,
       Johannes Weiner <hannes-kernel@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
References: <20070626021617.GK989688@sgi.com> <20070626093520.GB2691@ff.dom.local> <20070626125006.GG31489@sgi.com>
In-Reply-To: <20070626125006.GG31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch looks good, Dave.
(though, I stuffed up reviewing that bit of code previously:-)

Oh, previous typo: s/inodes at the some time/inodes at the same time/

--Tim

David Chinner wrote:
> On Tue, Jun 26, 2007 at 11:35:20AM +0200, Jarek Poplawski wrote:
>> On 26-06-2007 04:16, David Chinner wrote:
>>> It does both - parent-first/child-second and ascending inode # order,
>>> which is where the problem is. standing alone, these seem fine, but
>>> they don't appear to work when the child has a lower inode number
>>> than the parent.
>> ...
>>
>> >From xfs_inode.h:
>>
>> /*
>>  * Flags for lockdep annotations.
>>  *
>>  * XFS_I[O]LOCK_PARENT - for operations that require locking two inodes
>>  * (ie directory operations that require locking a directory inode and
>>  * an entry inode).  The first inode gets locked with this flag so it
>>  * gets a lockdep subclass of 1 and the second lock will have a lockdep
>>  * subclass of 0.
>>  *
>>  * XFS_I[O]LOCK_INUMORDER - for locking several inodes at the some time
>>  * with xfs_lock_inodes().  This flag is used as the starting subclass
>>  * and each subsequent lock acquired will increment the subclass by one.
>>  * So the first lock acquired will have a lockdep subclass of 2, the
>>  * second lock will have a lockdep subclass of 3, and so on.
>>  */
>>
>> I don't know xfs code, and probably miss something, but it seems
>> there could be some inconsistency: lockdep warning shows mr_lock/1
>> taken both before and after mr_lock (i.e. /0). According to the
>> above comment there should be always 1 before 0...
> 
> That just fired some rusty neurons.
> 
> #define XFS_IOLOCK_SHIFT        16
> #define XFS_IOLOCK_PARENT       (1 << XFS_IOLOCK_SHIFT)
> #define XFS_IOLOCK_INUMORDER    (2 << XFS_IOLOCK_SHIFT)
> 
> #define XFS_ILOCK_SHIFT         24
> #define XFS_ILOCK_PARENT        (1 << XFS_ILOCK_SHIFT)
> #define XFS_ILOCK_INUMORDER     (2 << XFS_ILOCK_SHIFT)
> 
> So, in a lock_mode parameter, the upper 8 bits are for the ILOCK lockdep
> subclass, and the 16..23 bits are for the IOLOCK lockdep subclass.
> 
> Where do we add them?
> 
> static inline int
> xfs_lock_inumorder(int lock_mode, int subclass)
> {
>         if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
>                 lock_mode |= (subclass + XFS_IOLOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
>         if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
>                 lock_mode |= (subclass + XFS_ILOCK_INUMORDER) << XFS_ILOCK_SHIFT;
> 
>         return lock_mode;
> }
> 
> 
> OH, look at those nice overflow bugs in that in that code. We shift
> the XFS_IOLOCK_INUMORDER and XFS_ILOCK_INUMORDER bits out the far
> side of the lock_mode variable result in lock subclasses of 0-3 instead
> of 2-5....
> 
> Bugger, eh?
> 
> Patch below should fix this (untested).
> 
> Jarek - thanks for pointing what I should have seen earlier.
> 
> Cheers,
> 
> Dave.

