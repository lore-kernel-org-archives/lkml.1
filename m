Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbZATTBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbZATTBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZATTBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:01:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZATTBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:01:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=mfKVZve7NIlptKs5OhWUBncVrIZzdG4kNf0gCmuED3CAtQao44rVt5hUSPA7CqiQ0
	wH50uBO0sfx17dLsOtjZg==
Message-ID: <49761F8D.2070607@google.com>
Date: Tue, 20 Jan 2009 11:01:33 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
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

I'll dig through the archives and try to come up with a response later 
today.

> 
>> Besides various workload testing,
> 
> Details?
> 

I ran a couple different workloads, though I was looking for 
stability/correctness rather than performance.  I ran iozone (ext2 + 
ext4/nojournal), dbench (ext2), tbench (ext2), specjbb, unixbench, 
kernbench as well as a couple internal benchmarks.
