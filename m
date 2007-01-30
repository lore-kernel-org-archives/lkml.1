Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbXA3Suw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbXA3Suw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXA3Suw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:50:52 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:7166 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750896AbXA3Suv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:50:51 -0500
Message-ID: <45BF9381.8010108@cfl.rr.com>
Date: Tue, 30 Jan 2007 13:50:41 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: Denis Vlasenko <vda.linux@googlemail.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random> <45BE7D99.70200@cfl.rr.com> <20070130023056.GN8030@opteron.random> <45BF65E3.6070102@cfl.rr.com> <20070130164806.GQ8030@opteron.random>
In-Reply-To: <20070130164806.GQ8030@opteron.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2007 18:51:02.0734 (UTC) FILETIME=[97022EE0:01C7449F]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14966.001
X-TM-AS-Result: No--12.317700-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Jan 30, 2007 at 10:36:03AM -0500, Phillip Susi wrote:
>> Did you intentionally drop this reply off list?
> 
> No.

Then I'll restore the lkml to the cc list.

>> No, it doesn't... or at least can't report WHERE the error is.
> 
> O_SYNC doesn't report where the error is either, try a write(fd, buf,
> 10*1024*1024).

It should return the number of bytes successfully written before the 
error, giving you the location of the first error.  Also using smaller 
individual writes ( preferably issued in parallel ) also allows the 
problem spot to be isolated.

>> Typically you only want one sector of data to be written before you 
>> continue.  In the cases where you don't, this might be nice, but as I 
>> said above, you can't handle errors properly.
> 
> Sorry but you're dreaming if you're thinking anything in real life
> writes at 512bytes at time with O_SYNC. Try that with any modern
> harddisk.

When you are writing a transaction log, you do; you don't need much 
data, but you do need to be sure it has hit the disk before continuing. 
  You certainly aren't writing many mb across a dozen write() calls and 
only then care to make sure it is all flushed in an unknown order.  When 
order matters, you can not use fsync, which is one of the reasons why 
databases use O_DIRECT; they care about the ordering.

>>> Just grep for fsync in the db code of your choice (try postgresql) and
>>> then explain me why they ever call fsync in their code, if you know
>>> how to do better with O_SYNC ;).
>> Doesn't sound like a very good idea to me.
> 
> Why not a good idea to check any real life app?

I meant it is not a good idea to use fsync as you can't properly handle 
errors.

>> The stalling is caused by cache pollution.  Since you did not specify a 
>> block size dd uses the base block size of the output disk.  When 
>> combined with sync, only one block is written at a time, and no more 
>> until the first block has been flushed.  Only then does dd send down 
>> another block to write.  Without dd the kernel is likely allowing many 
>> mb to be queued in the buffer cache.  Limiting output to one block at a 
>> time is not good for throughput, but allowing half of ram to be used by 
>> dirty pages is not good either.
> 
> Throughput is perfect. I forgot to tell I combine it with ibs=4k
> obs=16M. Like it would be perfect with odirect too for the same
> reason. Stalling the I/O pipeline once every 16M isn't measurable in

Throughput is nowhere near perfect, as the pipeline is stalled for quite 
some time.  The pipe fills up quickly while dd is blocked on the sync 
write, which then blocks tar until all 16 MB have hit the disk.  Only 
then does dd go back to reading from the tar pipe, allowing it to 
continue.  During the time it takes tar to archive another 16 MB of 
data, the write queue is empty.  The only time that the tar process gets 
to continue running while data is written to disk is in the small time 
it takes for the pipe ( 4 KB isn't it? ) to fill up.

>> The semantics of the two are very much the same; they only differ in the 
>> internal implementation.  As far as the caller is concerned, in both 
>> cases, he is sure that writes are safe on the disk when they return, and 
>> reads semantically are no different with either flag.  The internal 
>> implementations lead to different performance characteristics, and the 
>> other post was simply commenting that the performance characteristics of 
>> O_SYNC + madvise() is almost the same as O_DIRECT, or even better in 
>> some cases ( since the data read may already be in cache ).
> 
> The semantics mandates the implementation because the semantics make
> up for the performance expectations. For the same reason you shouldn't
> write 512bytes at time with O_SYNC you also shouldn't use O_SYNC if
> your device risks to create a bottleneck in the CPU and memory.

No, semantics have nothing to do with performance.  Semantics deals with 
the state of the machine after the call, not how quickly it got there. 
Semantics is a question of correct operation, not optimal.

With both O_DIRECT and O_SYNC, the machine state is essentially the same 
after the call: the data has hit the disk.  Aside from the performance 
difference, the application can not tell the difference between O_DIRECT 
and O_SYNC, so if that performance difference can be resolved by 
changing the implementation, Linus can be happy and get rid of O_DIRECT.


