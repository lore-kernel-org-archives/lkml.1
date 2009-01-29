Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZA2CJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZA2CJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZA2CJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:09:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZA2CJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:09:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=WjtgzhEiKKFySBMAo2qezPOV9G26dhmCHbj8+whqZaW7vK6ED2BI2gC7OdZ2TbbE5
	iVKjlRel85dfFAkZmK7aA==
Message-ID: <49810FD6.2080501@google.com>
Date: Wed, 28 Jan 2009 18:09:26 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock	contention
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <20090117081210.GL8071@disturbed>
In-Reply-To: <20090117081210.GL8071@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.76
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Fri, Jan 16, 2009 at 06:29:36PM -0800, Mike Waychison wrote:
>> We've noticed that at times it can become very easy to have a system begin to
>> livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) when
>> a lot of dentries are getting finalized at the same time (massive delete and
>> large fdtable destructions are two paths I've seen cause problems).
>>
>> This patchset is an attempt to try and reduce the locking overheads associated
>> with final dput() and final iput().  This is done by batching dentries and
>> inodes into per-process queues and processing them in 'parallel' to consolidate
>> some of the locking.
> 
> Hmmmm. This deferring of dput/iput will have the same class of
> effects on filesystems as the recent reverted changes to make
> generic_delete_inode() an asynchronous process. That is, it
> temporally separates the transaction for namespace deletion (i.e.
> unlink) from the transaction that completes the inode deletion that
> occurs, typically, during ->clear_inode. See the recent thread
> titled:
> 
> [PATCH] async: Don't call async_synchronize_full_special() while holding sb_lock
> 
> For more details.
> 
> I suspect that change is likely to cause worse problems than the
> async changes in that it doesn't have a cap on the number of
> deferred operations.....

*sigh*.  So I did some testing with XFS today and you're right, 
separating the namespace operation from the actual file delete really 
slows things down.

I'll follow up with a v2 patchset with more precise details, but 
basically, I create (on one fs) 100K files (each empty) per cpu (8 core 
machine).  I then time how long it takes to have one-process-per-cpu 
delete it's own file hierarchy of 100K files.

XFS performs horribly at this test (taking approx 34 minutes to 
complete).  With my changes, it takes approx 57 minutes.  For 
comparison, ext2 takes ~4.5 seconds, ext4 ~30 seconds and ext4 without a 
journal ~4.1 seconds.

Seems to me like there is a design issue causing XFS to suck at mass 
deletes, and I can understand why you wouldn't want to separate the 
namespace+inode drop.

What say you to letting the fs itself specify whether it's inodes should 
be handled serially (like it is today) or in deferred batches?  Patch 4 
of this series introduced an I_SYNCIPUT flag to deal with umount issues; 
perhaps it would make sense to have inodes from XFS tagged with this flag?

Mike Waychison
