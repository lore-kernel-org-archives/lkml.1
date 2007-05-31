Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbXEaSYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbXEaSYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760772AbXEaSY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:24:28 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:41258 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759232AbXEaSY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:24:26 -0400
Message-ID: <465F12E8.9080203@cfl.rr.com>
Date: Thu, 31 May 2007 14:24:40 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: david@lang.hm, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com>
In-Reply-To: <20070531002011.GC85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2007 18:24:37.0888 (UTC) FILETIME=[F259A000:01C7A3B0]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15210.000
X-TM-AS-Result: No--8.347900-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
>> you are understanding barriers to be the same as syncronous writes. (and 
>> therefor the data is on persistant media before the call returns)
> 
> No, I'm describing the high level behaviour that is expected by
> a filesystem. The reasons for this are below....

You say no, but then you go on to contradict yourself below.

> Ok, that's my understanding of how *device based barriers* can work,
> but there's more to it than that. As far as the filesystem is
> concerned the barrier write needs to *behave* exactly like a sync
> write because of the guarantees the filesystem has to provide
> userspace. Specifically - sync, sync writes and fsync.

There, you just ascribed the synchronous property to barrier requests. 
This is false.  Barriers are about ordering, synchronous writes are 
another thing entirely.  The filesystem is supposed to use barriers to 
maintain ordering for journal data.  If you are trying to handle a 
synchronous write request, that's another flag.

> This is the big problem, right? If we use barriers for commit
> writes, the filesystem can return to userspace after a sync write or
> fsync() and an *ordered barrier device implementation* may not have
> written the blocks to persistent media. If we then pull the plug on
> the box, we've just lost data that sync or fsync said was
> successfully on disk. That's BAD.

That's why for synchronous writes, you set the flag to mark the request 
as synchronous, which has nothing at all to do with barriers.  You are 
trying to use barriers to solve two different problems.  Use one flag to 
indicate ordering, and another to indicate synchronisity.

> Right now a barrier write on the last block of the fsync/sync write
> is sufficient to prevent that because of the FUA on the barrier
> block write. A purely ordered barrier implementation does not
> provide this guarantee.

This is a side effect of the implementation of the barrier, not part of 
the semantics of barriers, so you shouldn't rely on this behavior.  You 
don't have to use FUA to handle the barrier request, and if you don't, 
then the request can be completed while the data is still in the write 
cache.  You just have to make sure to flush it before any subsequent 
requests.

> IOWs, there are two parts to the problem:
> 
> 	1 - guaranteeing I/O ordering
> 	2 - guaranteeing blocks are on persistent storage.
> 
> Right now, a single barrier I/O is used to provide both of these
> guarantees. In most cases, all we really need to provide is 1); the
> need for 2) is a much rarer condition but still needs to be
> provided.

Yep... two problems... two flags.

> Yes, if we define a barrier to only guarantee 1), then yes this
> would be a big win (esp. for XFS). But that requires all filesystems
> to handle sync writes differently, and sync_blockdev() needs to
> call blkdev_issue_flush() as well....
> 
> So, what do we do here? Do we define a barrier I/O to only provide
> ordering, or do we define it to also provide persistent storage
> writeback? Whatever we decide, it needs to be documented....

We do the former or we end up in the same boat as O_DIRECT; where you 
have one flag that means several things, and no way to specify you only 
need some of those and not the others.


