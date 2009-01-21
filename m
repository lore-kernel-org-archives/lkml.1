Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbZAUGVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbZAUGVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 01:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZAUGU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 01:20:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:48479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZAUGU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 01:20:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=dgw31vZ+MYNAt1WS3eMdhoGG1OsalIVU0RKwQpIY+/skeTV8JHMl6DPwuqcR3cN2M
	rcWNBQCRoResvpGoiuYRw==
Message-ID: <4976BF08.90306@google.com>
Date: Tue, 20 Jan 2009 22:22:00 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <877i4pdx4f.fsf@basil.nowhere.org>
In-Reply-To: <877i4pdx4f.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.37
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Mike Waychison <mikew@google.com> writes:
> 
>> livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) 
> 
> I'm not sure how something can livelock in atomic_dec_and_lock which
> doesn't take a spinlock itself? Are you saying you run into NUMA memory
> unfairness here? Or did I misparse you?

By atomic_dec_and_lock, I really meant to say _atomic_dec_and_lock(). 
It takes the spinlock if the cmpxchg hidden inside atomic_dec_unless fails.

There are likely NUMA unfairness issues at play, but it's not the main 
worry at this point.

> 
>> This patchset is an attempt to try and reduce the locking overheads associated
>> with final dput() and final iput().  This is done by batching dentries and
>> inodes into per-process queues and processing them in 'parallel' to consolidate
>> some of the locking.
> 
> I was wondering what this does to the latencies when dput/iput
> is only done for very objects. Does it increase costs then
> significantly?

very objects?

> 
> As a high level comment it seems like a lot of work to work
> around global locks, like the inode_lock, where it might be better to 
> just split the lock up? Mind you I don't have a clear proposal
> how to do that, but surely it's doable somehow.
> 

Perhaps.. the only plausible way I can think this would be doable would 
be to rework the global resources (like the global inode_unused LRU list 
and deal with inode state transitions), but even then, some sort of 
consistency needs to happen at the super_block level, which means the 
smallest I can see the lock becoming would be per-super_block, which 
doesn't solve the problem afaict.
