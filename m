Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZCYV76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZCYV76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZCYV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:59:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbZCYV7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:59:48 -0400
Message-ID: <49CAA88B.1080102@sandeen.net>
Date: Wed, 25 Mar 2009 16:56:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
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
References: <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org>
In-Reply-To: <20090325212923.GA5620@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On Wed, Mar 25, 2009 at 01:40:37PM -0700, Linus Torvalds wrote:
>> On Wed, 25 Mar 2009, Jeff Garzik wrote:
>>> It is clearly possible to implement an fsync(2) that causes FLUSH CACHE to be
>>> issued, without adding full barrier support to a filesystem.  It is likely
>>> doable to avoid touching per-filesystem code at all, if we issue the flush
>>> from a generic fsync(2) code path in the kernel.
>> We could easily do that. It would even work for most cases. The 
>> problematic ones are where filesystems do their own disk management, but I 
>> guess those people can do their own fsync() management too.
>>
>> Somebody send me the patch, we can try it out.
> 
> This is a simple step that would cover a lot of cases...  sync(2)
> calls sync_blockdev(), and many filesystems do as well via the generic
> filesystem helper file_fsync (fs/sync.c).
> 
> XFS code calls sync_blockdev() a "big hammer", so I hope my patch
> follows with known practice.
> 
> Looking over every use of sync_blockdev(), its most frequent use is
> through fsync(2), for the selected filesystems that use the generic
> file_fsync helper.
> 
> Most callers of sync_blockdev() in the kernel do so infrequently,
> when removing and invalidating volumes (MD) or storing the superblock
> prior to release (put_super) in some filesystems.
> 
> Compile-tested only, of course :)  But it should be work :)
> 
> My main concern is some hidden area that calls sync_blockdev() with
> a high-enough frequency that the performance hit is bad.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 891e1c7..7b9f74a 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -173,9 +173,14 @@ int sync_blockdev(struct block_device *bdev)
>  {
>  	int ret = 0;
>  
> -	if (bdev)
> -		ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
> -	return ret;
> +	if (!bdev)
> +		return 0;
> +	
> +	ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
> +	if (ret)
> +		return ret;
> +	
> +	return blkdev_issue_flush(bdev, NULL);
>  }
>  EXPORT_SYMBOL(sync_blockdev);

What about when you're running over a big raid device with
battery-backed cache, and you trust the cache as much as much as the
disks.  Wouldn't this unconditional cache flush be painful there on any
of the callers even if they're rare?  (fs unmounts, freezes, unmounts,
etc?  Or a fat filesystem on that device doing an fsync?)

xfs, reiserfs, ext4 all avoid the blkdev flush on fsync if barriers are
not enabled, I think for that reason...

(I'm assuming these raid devices still honor a cache flush request even
if they're battery-backed?  I dunno.)

-Eric
