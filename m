Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbZDHI5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbZDHI5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZDHI5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:57:44 -0400
Received: from exc03vs1.exchange.cysonet.com ([85.158.200.86]:36943 "EHLO
	exc03vs1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562AbZDHI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:57:42 -0400
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Wed, 08 Apr 2009 10:57:38 +0200
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads
From: Jos Houtman <jos@hyves.nl>
To: Jens Axboe <jens.axboe@oracle.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: <linux-kernel@vger.kernel.org>
Message-ID: <C60233A2.EEB9%jos@hyves.nl>
Thread-Topic: [PATCH 0/7] Per-bdi writeback flusher threads
Thread-Index: Acm4EkAcEiZMtp+0S9S4T/aSXMO6TQAFdDhK
In-Reply-To: <20090408062056.GP5178@kernel.dk>
X-Priority: 10
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2009 08:57:39.0723 (UTC) FILETIME=[120415B0:01C9B828]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 
>> Hi Jos, you said that this simple patch solved the problem, however you
>> mentioned somehow suboptimal performance. Can you elaborate that?  So
>> that I can push or improve it.
>> 
>> Thanks,
>> Fengguang
>> ---
>>  fs/fs-writeback.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> --- mm.orig/fs/fs-writeback.c
>> +++ mm/fs/fs-writeback.c
>> @@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
>>                                * soon as the queue becomes uncongested.
>>                                */
>>                               inode->i_state |= I_DIRTY_PAGES;
>> -                             if (wbc->nr_to_write <= 0) {
>> +                             if (wbc->nr_to_write <= 0 ||
>> +                                 wbc->encountered_congestion) {
>>                                       /*
>>                                        * slice used up: queue for next turn
>>                                        */
>> 
>>> But the second problem seen in that thread, a write-starve-read problem does
>>> not seem to solved. In this problem the writes of the writeback algorithm
>>> starve the ongoing reads, no matter what io-scheduler is picked.
> 
> What kind of SSD drive are you using? Does it support queuing or not?

First Jens his question: We use the MTRON PRO 7500 ( MTRON MSP-SATA75 ) with
64GB and 128GB and I don't know whether it supports queuing or not. How can
I check? The data-sheet doesn't mention NCQ, if you meant that.

As for a more elaborate description of the problem (please bare with me):
There are actually two problems:
The first is that the the writeback algorithm couldn't keep up with the
number of pages being dirtied by our database, even though it should. The
number of pages would rise for hours and level and stabilize around the
dirty_background_ratio treshold.

The second problem is that the io-writes triggered by the writeback
algorithm happens in bursts and all read activity on the device is starved
for the duration of the write-burst, sometimes periods of up to 15 seconds.
My conclusion: There is no proper interleaving of writes and reads, _NO_
matter what IO-scheduler I choose to use.

See the graph below for a plot of this behavior:
Select queries vs disk read/write operations (measures every second). This
was measured using Wu's patch, the per-bdi writeback patchset somehow
wrote-back every 5 seconds and as a result created smaller but more frequent
drops in the selects.
http://94.100.113.33/535450001-535500000/535451701-535451800/535451800_5VNp.
jpg


The patch posted by Wu and the per-bdi writeback patchset both solve the
first problem, at the cost of increasing the occurrence of problem number
two. 
Fixed writeback => more write bursts => more frequent starvation of the
reads.  



Background: 
The machines that have these problems are databases, with large datasets
that need to read quite a lot of data from disk (as it won't fit in
filecache). These write-bursts lock queries that normally take only a few ms
up to a several seconds. As a result of this lockup a backlog is created,
and in our current database setup the backlog is actively purged. Forcing a
reconnect to the same set of suffering database servers, further increasing
the load. 

We are actively working on application level solutions that don't trigger
the write-starve-read problem, mainly by reducing the physical read load.
But this is a lengthy process.

Besides what we can do ourselves, I think that this write-starve-read
behaviour should not happen or should at least be controllable by picking an
IO-scheduler that suits you.

The most extreme solutions as I see them:

If your data is sacred:
Writes have priority and the IO-scheduler should do its best to smooth the
write burst and interleave them properly without hampering the read load too
much. 

If your data is not so sacred (we have 30 machines with the same dataset):
Reads have a priority and writes are the lowest priority and are
interleaved whenever possible. This could mean writeback being postponed
untill the off-hours.


But I would be really glad if I could just use the deadline scheduler to do
1 write for every 10 reads and make the write-expire timeout very high.


Thanks,

Jos


