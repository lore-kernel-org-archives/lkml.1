Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYJGRQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYJGRQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYJGRQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:16:34 -0400
Received: from mail.lang.hm ([64.81.33.126]:58648 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYJGRQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:16:33 -0400
Date: Tue, 7 Oct 2008 10:16:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mikulas Patocka <mpatocka@redhat.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: application syncing options (was Re: [PATCH] Memory management
 livelock)
In-Reply-To: <Pine.LNX.4.64.0810071126001.504@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.DEB.1.10.0810071006400.17288@asgard.lang.hm>
References: <20080911101616.GA24064@agk.fab.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au> <200810031254.29121.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
 <Pine.LNX.4.64.0810052002520.5798@hs20-bc2-1.build.redhat.com> <alpine.DEB.1.10.0810051714330.17288@asgard.lang.hm> <Pine.LNX.4.64.0810052332040.3074@hs20-bc2-1.build.redhat.com> <alpine.DEB.1.10.0810062025301.19471@asgard.lang.hm>
 <Pine.LNX.4.64.0810071126001.504@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Mikulas Patocka wrote:

>>> If you invent new interface that allows submitting several ordered IOs
>>> from userspace, it will require excessive maintenance overhead over long
>>> period of time. So it should be only justified, if the performance
>>> improvement is excessive as well.
>>>
>>> It should not be like "here you improve 10% performance on some synthetic
>>> benchmark in one application that was rewritten to support the new
>>> interface" and then create a few more security vulnerabilities (because of
>>> the complexity of the interface) and damage overall Linux progress,
>>> because everyone is catching bugs in the new interface and checking it for
>>> correctness.
>>
>> the same benchmarks that show that it's far better for the in-kernel
>> filesystem code to use write barriers should apply for FUSE filesystems.
>
> FUSE is slow by design, and it is used in cases where performance isn't
> crucial.

FUSE is slow, but I don't believe that it's a design goal for it to be 
slow, it's a limitation of the implementation. so things that could speed 
it up would be a good thing.

>> this isn't a matter of a few % in performance, if an application is
>> sync-limited in a way that can be converted to write-ordered the potential is
>> for the application to speed up my many times.
>>
>> programs that maintain indexes or caches of data that lives in other files
>> will be able to write data && barrier && write index && fsync and double their
>> performance vs write data && fsync && write index && fsync
>
> They can do: write data with O_SYNC; write another piece of data with
> O_SYNC.
>
> And the only difference from barriers is the waiting time after the first
> O_SYNC before the second I/O is submitted (such delay wouldn't happen with
> barriers).
>
> And now I/O delay is in milliseconds and process wakeup time is tens of
> microseconds, it doesn't look like eliminating process wakeup time would
> do more than few percents.

each sync write needs to wait for a disk rotation (and a seek if you are 
writing to different files). if you only do two writes you save one disk 
rotation, if you do five writes you save four disk rotations

>> databases can potentially do even better, today they need to fsync data to
>> disk before they can update their journal to indicate that the data has been
>> written, with a barrier they could order the writes so that the write to the
>> journal doesn't happen until the writes of the data. they would neve need to
>> call an fsync at all (when emptying the journal)
>
> Good databases can pack several user transactions into one fsync() write.
> If the database server is properly engineered, it accumulates all user
> transactions committed so far into one chunk, writes that chunk with one
> fsync() call and then reports successful commit to the clients.

if there are multiple users doing transactions at the same time they will 
benifit from overlapping the fsyncs. but each user session cannot complete 
their transaction until the fsync completes

> So if you increase fsync() latency, it should have no effect on the
> transactional throughput --- only on latency of transactions. Similarly,
> if you decrease fsync() latency, it won't increase number of processed
> transactions.

only if you have all your transactions happening in parallel. in the real 
world programs sometimes need to wait for one transaction to complete so 
that they can do the next one.

> Certainly, there are primitive embedded database libraries that fsync()
> after each transaction, but they don't have good performance anyway.
>
>> for systems without solid-state drives or battery-backed caches, the ability
>> to eliminate fsyncs by being able to rely on the order of the writes is a huge
>> benifit.
>
> I may ask --- where are the applications that require extra slow fsync()
> latency? Databases are not that, they batch transactions.
>
> If you want to improve things, you can try:
> * implement O_DSYNC (like O_SYNC, but doesn't update inode mtime)
> * implement range_fsync and range_fdatasync (sync on file range --- the
> kernel has already support for that, you can just add a syscall)
> * turn on FUA bit for O_DSYNC writes, that eliminates the need to flush
> drive cache in O_DSYNC call
>
> --- these are definitely less invasive than new I/O submitting interface.

but all of these require that the application stop and wait for each 
seperate write to take place before proceeding to the next step.

if this doesn't matter, then why the big push to have the in-kernel 
filesystems start using barriers? I understood that this resulted in large 
performance increases in the places that they are used from just being 
able to avoid having to drain the entire request queue, and you are saying 
that the applications would not only need to wait for the queue to flush, 
but for the disk to acknowledge the write.

syncs are slow, in some cases _very_ slow.

David Lang
