Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXA3XHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXA3XHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXA3XHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:07:24 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:10988 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572AbXA3XHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:07:23 -0500
Message-ID: <45BFCFA2.6000701@cfl.rr.com>
Date: Tue, 30 Jan 2007 18:07:14 -0500
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
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random> <45BE7D99.70200@cfl.rr.com> <20070130023056.GN8030@opteron.random> <45BF65E3.6070102@cfl.rr.com> <20070130164806.GQ8030@opteron.random> <45BF9381.8010108@cfl.rr.com> <20070130195720.GR8030@opteron.random>
In-Reply-To: <20070130195720.GR8030@opteron.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2007 23:07:39.0534 (UTC) FILETIME=[70376AE0:01C744C3]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14966.001
X-TM-AS-Result: No--15.051000-5.000000-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> When you have I/O errors during _writes_ (not Read!!)  the raid must
> kick the disk out of the array before the OS ever notices. And if it's
> software raid that you're using, the OS should kick out the disk
> before your app ever notices any I/O error. when the write I/O error
> happens, it's not a problem for the application to solve.

I thought it obvious that we were talking about non recoverable errors 
that then DO make it to the application.  And any kind of mission 
critical app most definitely does care about write errors.  You don't 
need your db completing the transaction when it was only half recorded. 
  It needs to know it failed so it can back out and/or recover the data 
and record it elsewhere.  You certainly don't want the users to think 
everything is fine, walk away, and have the system continue to limp on 
making things worse by the second.

> when the I/O error reaches the filesystem if you're lucky if the OS
> won't crash (ext3 claims to handle it), if your app receives the I/O
> error all you should be doing is to shutdown things gracefully sending
> all errors you can to the admin.

If the OS crashes due to an IO error reading user data, then there is 
something seriously wrong and beyond the scope of this discussion.  It 
suffices to say that due to the semantics of write() and sound 
engineering practice, the application expects to be notified of errors 
so it can try to recover, or fail gracefully.  Whether it chooses to 
fail gracefully as you say it should, or recovers from the error, it 
needs to know that an error happened, and where it was.

> It doesn't matter much where the error happend, all it matters is that
> you didn't have a fault tolerant raid setup (your fault) and your
> primary disk just died and you're now screwed(tm). If you could trust
> that part of the disk is still sane you could perhaps attempt to avoid
> a restore from the last backup, otherwise all you can do is the
> equivalent of a e2fsck -f on the db metadata after copying what you
> can still read to the new device.

It most certainly matters where the error happened because "you are 
screwd" is not an acceptable outcome in a mission critical application. 
  A well engineered solution will deal with errors as best as possible, 
not simply give up and tell the user they are screwed because the 
designer was lazy.  There is a reason that read and write return the 
number of bytes _actually_ transfered, and the application is supposed 
to check that result to verify proper operation.

> Sorry but as far as ordering is concerned, O_DIRECT, fsync and O_SYNC
> offers exactly the same guarantees. Feel free to check the real life
> db code. Even bdb uses fsync.

No, there is a slight difference.  An fsync() flushes all dirty buffers 
in an undefined order.  Using O_DIRECT or O_SYNC, you can control the 
flush order because you can simply wait for one set of writes to 
complete before starting another set that must not be written until 
after the first are on the disk.  You can emulate that by placing an 
fsync between both sets of writes, but that will flush any other dirty 
buffers whose ordering you do not care about.  Also there is no aio 
version of fsync.

> Please try yourself, it's simple enough:
> 
>        time dd if=/dev/hda of=/dev/null bs=16M count=100
>        time dd if=/dev/hda of=/dev/null bs=16M count=100 iflag=sync
>        time dd if=/dev/hda of=/dev/null bs=16M count=100 iflag=direct
> 
> if you can measure any slowdown in the sync/direct you're welcome (it
> runs faster here... as it should). The pipeline stall is not
> measurable when it's so infrequent, and actually the pipeline stall is
> not a big issue when the I/O is contigous and the dma commands are
> always large.
 >
> aio is mandatory only while dealing with small buffers, especially
> while seeking to take advantage of the elevator.
>


sync has no effect on reading, so that test is pointless.  direct saves 
the cpu overhead of the buffer copy, but isn't good if the cache isn't 
entirely cold.  The large buffer size really has little to do with it, 
rather it is the fact that the writes to null do not block dd from 
making the next read for any length of time.  If dd were blocking on an 
actual output device, that would leave the input device idle for the 
portion of the time that dd were blocked.

In any case, this is a totally different example than your previous one 
which had dd _writing_ to a disk, where it would block for long periods 
of time due to O_SYNC, thereby preventing it from reading from the input 
buffer in a timely manner.  By not reading the input pipe frequently, it 
becomes full and thus, tar blocks.  In that case the large buffer size 
is actually a detriment because with a smaller buffer size, dd would not 
be blocked as long and so it could empty the pipe more frequently 
allowing tar to block less.

> This whole thing is about performance, if you remove performance
> factors from the equation, you can stick to your O_SYNC 512bytes at
> time to the journal design. You're perfectly right that when you
> remove performance from the equation you can claim that O_DIRECT is
> much the same as O_SYNC.

> Guess what, if O_SYNC could run as fast as O_DIRECT by still passing
> through pagecache, O_DIRECT wouldn't exist. You can't pretend to
> describe the semantics of any kernel API if you remove performance
> considerations from it. It must be some not useful university theory
> if they thought you that performance evaluation must not be present in
> the semantics. If that's the case, it's best you stop talking about
> semantics when you discuss about any kernel APIs. A ton of kernel APIs
> are all about improving performance, so they'll all be the same if you
> only look at your performance agnostic semantics, it's not just
> O_DIRECT that would become the same as O_SYNC.

You seem to have missed the point of this thread.  Denis Vlasenko's 
message that you replied to simply pointed out that they are 
semantically equivalent, so O_DIRECT can be dropped provided that O_SYNC 
+ madvise could be fixed to perform as well.  Several people including 
Linus seem to like this idea and think it is quite possible.

