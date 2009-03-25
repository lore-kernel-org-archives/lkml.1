Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZCYXJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZCYXJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZCYXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:08:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51950 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYXIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:08:50 -0400
Message-ID: <49CAB957.4050402@garzik.org>
Date: Wed, 25 Mar 2009 19:08:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] issue storage device flush via sync_blockdev() (was Re:
 Linux 2.6.29)
References: <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <49CAA88B.1080102@sandeen.net>
In-Reply-To: <49CAA88B.1080102@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Jeff Garzik wrote:
>> On Wed, Mar 25, 2009 at 01:40:37PM -0700, Linus Torvalds wrote:
>>> On Wed, 25 Mar 2009, Jeff Garzik wrote:
>>>> It is clearly possible to implement an fsync(2) that causes FLUSH CACHE to be
>>>> issued, without adding full barrier support to a filesystem.  It is likely
>>>> doable to avoid touching per-filesystem code at all, if we issue the flush
>>>> from a generic fsync(2) code path in the kernel.
>>> We could easily do that. It would even work for most cases. The 
>>> problematic ones are where filesystems do their own disk management, but I 
>>> guess those people can do their own fsync() management too.
>>>
>>> Somebody send me the patch, we can try it out.
>> This is a simple step that would cover a lot of cases...  sync(2)
>> calls sync_blockdev(), and many filesystems do as well via the generic
>> filesystem helper file_fsync (fs/sync.c).
>>
>> XFS code calls sync_blockdev() a "big hammer", so I hope my patch
>> follows with known practice.
>>
>> Looking over every use of sync_blockdev(), its most frequent use is
>> through fsync(2), for the selected filesystems that use the generic
>> file_fsync helper.
>>
>> Most callers of sync_blockdev() in the kernel do so infrequently,
>> when removing and invalidating volumes (MD) or storing the superblock
>> prior to release (put_super) in some filesystems.
>>
>> Compile-tested only, of course :)  But it should be work :)
>>
>> My main concern is some hidden area that calls sync_blockdev() with
>> a high-enough frequency that the performance hit is bad.
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 891e1c7..7b9f74a 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -173,9 +173,14 @@ int sync_blockdev(struct block_device *bdev)
>>  {
>>  	int ret = 0;
>>  
>> -	if (bdev)
>> -		ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
>> -	return ret;
>> +	if (!bdev)
>> +		return 0;
>> +	
>> +	ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
>> +	if (ret)
>> +		return ret;
>> +	
>> +	return blkdev_issue_flush(bdev, NULL);
>>  }
>>  EXPORT_SYMBOL(sync_blockdev);
> 
> What about when you're running over a big raid device with
> battery-backed cache, and you trust the cache as much as much as the
> disks.  Wouldn't this unconditional cache flush be painful there on any
> of the callers even if they're rare?  (fs unmounts, freezes, unmounts,
> etc?  Or a fat filesystem on that device doing an fsync?)

What exactly do you think sync_blockdev() does?  :)

It is used right before a volume goes away.  If that's not a time to 
flush the cache, I dunno what is.

The _whole purpose_ of sync_blockdev() is to push out the data to 
permanent storage.  Look at the users -- unmount volume, journal close, 
etc.  Things that are OK to occur after those points include: power off, 
device unplug, etc.

A secondary purpose of sync_blockdev() is as a hack, for simple/ancient 
bdev-based filesystems that do not wish to bother with barriers and all 
the associated complexity to tracking what writes do/do not need flushing.


> xfs, reiserfs, ext4 all avoid the blkdev flush on fsync if barriers are
> not enabled, I think for that reason...

Enabling barriers causes slowdowns far greater than that of simply 
causing fsync(2) to trigger FLUSH CACHE, because barriers imply FLUSH 
CACHE issuance for all in-kernel filesystem journalled/atomic 
transactions, in addition to whatever syscalls userspace is issuing.

The number of FLUSH CACHES w/ barriers is orders of magnitude larger 
than the number of fsync/fdatasync calls.

	Jeff



