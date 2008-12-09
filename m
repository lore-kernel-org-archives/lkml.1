Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYLIPOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYLIPOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 10:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYLIPOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 10:14:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:16293 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYLIPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 10:14:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RpUtSW7k0fAIwyGoVGaX1ah0uVINETBKIuVt01PsmxnVDwgAz6QS+HMnYh4mYKD8kA
         d5HWKlWGn50im5Kpah6hfeOEhXlyQ0e7XCLsi/73F3lgcbQ8CS24m2vHjzRwt32GZocl
         2DuQDORtToGMnHSZQ4uxLsAqO6ah5nM/LiL9U=
Message-ID: <6278d2220812090714o33228f09u66768c198df65ebd@mail.gmail.com>
Date: Tue, 9 Dec 2008 15:14:16 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Fabio Checconi" <fchecconi@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: Matthew <jackdachef@gmail.com>, "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080825170641.GA4720@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513184057.GU16217@kernel.dk>
	 <20080514082622.GA16217@kernel.dk>
	 <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com>
	 <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com>
	 <20080515070127.GH16217@kernel.dk>
	 <20080515122156.GA11600@gandalf.sssup.it>
	 <6278d2220808241324j117725efq8e87025313fb025f@mail.gmail.com>
	 <20080825202936.GA3608@gandalf.sssup.it>
	 <6278d2220808250839j1dc25c02uda7bf8b6b150acb7@mail.gmail.com>
	 <20080825170641.GA4720@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, Fabio,

On Mon, Aug 25, 2008 at 5:06 PM, Fabio Checconi <fchecconi@gmail.com> wrote:
>> From: Daniel J Blueman <daniel.blueman@gmail.com>
>> Date: Mon, Aug 25, 2008 04:39:01PM +0100
>>
>> On Mon, Aug 25, 2008 at 9:29 PM, Fabio Checconi <fchecconi@gmail.com> wrote:
>> > Hi,
>> >
>> >> From: Daniel J Blueman <daniel.blueman@gmail.com>
>> >> Date: Sun, Aug 24, 2008 09:24:37PM +0100
>> >>
>> >> Hi Fabio, Jens,
>> >>
>> > ...
>> >> This was the last test I didn't get around to. Alas, is did help, but
>> >> didn't give the merging required for full performance:
>> >>
>> >> # echo 1 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
>> >> bs=128k count=2000
>> >> 262144000 bytes (262 MB) copied, 2.47787 s, 106 MB/s
>> >>
>> >> # echo 1 >/proc/sys/vm/drop_caches; hdparm -t /dev/sda
>> >> Timing buffered disk reads:  308 MB in  3.01 seconds = 102.46 MB/sec
>> >>
>> >> It is an improvement over the baseline performance of 2.6.27-rc4:
>> >>
>> >> # echo 1 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
>> >> bs=128k count=2000
>> >> 262144000 bytes (262 MB) copied, 2.56514 s, 102 MB/s
>> >>
>> >> # echo 1 >/proc/sys/vm/drop_caches; hdparm -t /dev/sda
>> >> Timing buffered disk reads:  294 MB in  3.02 seconds =  97.33 MB/sec
>> >>
>> >> Note that platter speed is around 125MB/s (which I get near at smaller
>> >> read sizes).
>> >>
>> >> I feel 128KB read requests are perhaps important, as this is a
>> >> commonly-used RAID stripe size, and may explain the read-performance
>> >> drop sometimes we see in hardware vs software RAID benchmarks.
>> >>
>> >> How can we generate some ideas or movement on fixing/improving this behaviour?
>> >>
>> >
>> > Thank you for testing.  The blktrace output for this run should be
>> > interesting, esp. to compare it with a blktrace obtained from anticipatory
>> > with the same workload - IIRC anticipatory didn't suffer from the problem,
>> > and anticipatory has a slightly different dispatching mechanism that
>> > this patch tried to bring into cfq.
>> >
>> > Even if a proper fix may not belong to the elevator itself, I think
>> > that this couple (this last test + anticipatory) of traces should help
>> > in better understanding what is still going wrong.
>> >
>> > Thank you in advance.
>>
>> See http://quora.org/blktrace-n.tar.bz2
>>
>> Where n is:
>>  0 - 2.6.27-rc4 unpatched
>>  1 - 2.6.27-rc4 with your CFQ patch, CFQ scheduler
>>  2 - 2.6.27-rc4 with your CFQ patch, anticipatory scheduler
>>  3 - 2.6.27-rc4 with your CFQ patch, deadline scheduler
>>
>> I have found it's not always possible to reproduce this issue, eg now,
>> with stock CFQ, I'm seeing consistent 117-123MB/s with hdparm and dd
>> (as above), whereas I was seeing a consistent 95-103MB/s, so the
>> blktraces may not show the slower-performance pattern - even with
>> precisely the same (controlled) environment.
>>
>
> If I read them correctly, all the traces show dispatches with
> requests still growing; the elevator cannot know if a request
> will grow or not once it has been queued, and the heuristics
> we tried so far to postpone dispatches gave no results.
>
> I don't see any elevator-only solution to the problem...

I was running into this performance issue again:

Everything same as before, 2.6.24, CFQ scheduler, Seagate 7200.11
320GB SATA (SD11 firmware) on a quiescent and well-powered system:

# sync; echo 3 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
bs=128k count=1000
1000+0 records in
1000+0 records out
131072000 bytes (131 MB) copied, 2.24231 s, 58.5 MB/s

I found that tuning the AHCI SATA TCQ depth to 2 provides exactly the
performance we expect:

# echo 2 >/sys/block/sda/device/queue_depth
# sync; echo 3 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
bs=128k count=1000
1000+0 records in
1000+0 records out
131072000 bytes (131 MB) copied, 0.98503 s, 133 MB/s

depth 1: 132 MB/s
depth 2: 133 MB/s
depth 3: 69.1 MB/s
depth 4: 59.7 MB/s
depth 8: 54.9 MB/s
depth 16: 57.1 MB/s
depth 31: 58.0 MB/s

Very interesting interaction, and the figures are very stable. Could
this be a product of the maximum time the drive waits to coalesce
requests before acting on them? If so, how can we diagnose this, apart
from you guys getting one of these disks?

Thanks,
  Daniel
-- 
Daniel J Blueman
