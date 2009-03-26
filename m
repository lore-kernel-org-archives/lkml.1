Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZCZCeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZCZCeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCZCeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:34:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZCZCeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:34:04 -0400
Message-ID: <49CAE8E7.4010904@sandeen.net>
Date: Wed, 25 Mar 2009 21:31:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
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
References: <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <49CAA88B.1080102@sandeen.net> <49CAB957.4050402@garzik.org>
In-Reply-To: <49CAB957.4050402@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Eric Sandeen wrote:

>> What about when you're running over a big raid device with
>> battery-backed cache, and you trust the cache as much as much as the
>> disks.  Wouldn't this unconditional cache flush be painful there on any
>> of the callers even if they're rare?  (fs unmounts, freezes, unmounts,
>> etc?  Or a fat filesystem on that device doing an fsync?)
> 
> What exactly do you think sync_blockdev() does?  :)

It used to push os cached data to the storage.  Now it tells the storage
to flush cache too (with your patch).  This seems fine in general,
although it's not a panacea for all the various data integrity issues
that are being tossed about in this thread.  :)

> It is used right before a volume goes away.  If that's not a time to 
> flush the cache, I dunno what is.
> 
> The _whole purpose_ of sync_blockdev() is to push out the data to 
> permanent storage.  Look at the users -- unmount volume, journal close, 
> etc.  Things that are OK to occur after those points include: power off, 
> device unplug, etc.

Sure.  But I was thinking about enterprise raids with battery backup
which may last for days.

But, ok, I wasn't thinking quite right about the unmount situations etc;
even on enterprise raids like this, flushing things out on unmount makes
sense in the case where you lose power post-unmount and can't restore
power before the battery backup dies.

I also wondered if a cache flush on one lun issues a cache flush for the
entire controller, or just for that lun.  Hopefully the latter, in which
case it's not as big a deal.

> A secondary purpose of sync_blockdev() is as a hack, for simple/ancient 
> bdev-based filesystems that do not wish to bother with barriers and all 
> the associated complexity to tracking what writes do/do not need flushing.

Yep, I get that and it seems reasonable except ....

>> xfs, reiserfs, ext4 all avoid the blkdev flush on fsync if barriers are
>> not enabled, I think for that reason...
> 
> Enabling barriers causes slowdowns far greater than that of simply 
> causing fsync(2) to trigger FLUSH CACHE, because barriers imply FLUSH 
> CACHE issuance for all in-kernel filesystem journalled/atomic 
> transactions, in addition to whatever syscalls userspace is issuing.
> 
> The number of FLUSH CACHES w/ barriers is orders of magnitude larger 
> than the number of fsync/fdatasync calls.

I understand all that.

My point is that the above filesystems (xfs, reiserfs, ext4) skip the
blkdev flush on fsync when barriers are explicitly disabled.

They do this because if an admin disables barriers, they are trusting
that the write cache is nonvolatile and will be able to destage fully
even if external power is lost for some time.

In that case you don't need a blkdev_issue_flush on fsync either (or are
at least willing to live with the diminished risk, thanks to the battery
backup), and on xfs, ext4 etc you can turn it off (it goes away w/ the
barriers off setting).  With this change to the simple generic fsync
path, you can't turn it off for those filesystems that use it for fsync.

But I suppose it's rare that anybody ever uses a filesystem which uses
this generic sync method on any sort of interesting storage like I'm
talking about, and it's not a big deal...  (or maybe that interesting
storage just ignores cache flushes anyway, I dunno).

My main concerns were that these extra cache flushes for fsync aren't
tunable, and that flushes on one lun might affect other luns.  I guess
I've talked myself out of those concerns in a couple different ways now.  ;)

-Eric
