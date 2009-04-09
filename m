Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZDILnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZDILnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZDILnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:43:39 -0400
Received: from mail1.exchange.cysonet.com ([217.170.2.100]:40651 "EHLO
	mail1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbZDILni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:43:38 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 07:43:37 EDT
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Thu, 09 Apr 2009 13:37:25 +0200
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads
From: Jos Houtman <jos@hyves.nl>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, <linux-kernel@vger.kernel.org>
Message-ID: <C603AA95.F2C7%jos@hyves.nl>
Thread-Topic: [PATCH 0/7] Per-bdi writeback flusher threads
Thread-Index: Acm4Kj+fq4QSep74Se+ZzMlEKis+5QA3U4XT
In-Reply-To: <20090408091311.GY5178@kernel.dk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2009 11:37:26.0920 (UTC) FILETIME=[8ED80080:01C9B907]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


As a side note:
It is correct that 2.6.30-r1 points to the 2.6.29 tar file?


> They do not. The MTRONs are in the "crap" ssd category, irregardless of
> their (seemingly undeserved) high price tag. I tested a few of them some
> months ago and was less than impressed. It still sits behind a crap pata
> bridge and its random write performance was abysmal.

Hmm, that is something to look into on our end. I know we did a performance
comparison mid-summer 2008 and the Mtron came out pretty good, obviously we
did something wrong or the competition was even worse.
Do you have any top-of-the-head tips on brands/tooling or comparison points.
So we can more easily separate the good from the bad? Random write IOPS is
obviously important.


> So in general I find it quite weird that the writeback cannot keep up,
> there's not that much to keep up with. I'm guessing it's because of the
> quirky nature of the device when it comes to writes.

Wu said that the device was congested before it used up its
MAX_WRITEBACK_PAGES.  Which could be explained by bad write performance of
the device.

> As to the other problem, we usually do quite well on read-vs-write
> workloads. CFQ performs great for those, if I test the current
> 2.6.30-rc1 kernel, a read goes at > 90% of full performance with a
> 
> dd if=/dev/zero of=foo bs=1M
> 
> running in the background. On both NCQ and non-NCQ drives. Could you try
> 2.6.30-rc1, just in case it works better for you? At least CFQ will
> behave better there in any case. AS should work fine for that as well,
> but don't expect very good read-vs-write performance with deadline or
> noop. Doing some sort of anticipation is crucial to get that right.

Running the dd test and an adjusted fsync-tester todo random 4k writes in a
large 8GB file I come to the same conclusion.  CFQ beats noop, avarages and
std-dev of the reads per interval are better in both tests. (I append the
results below)

But the application level stress test perform better and worse, better
averages with cfq that are explained by the increased number of errors due
to timeout (so the worst latencies are hidden by the timeout).

I'am gonna run the tests again without the timeout but that takes a few
hours.

> 
> What kind of read workload are you running? May small files, big files,
> one big file, or?
Several bigfiles, that get lots of small random updates next to a steady
load of new inserts which I guess are sequentially appended in the data file
but randomly inserted in the index file.

The reads are also small and random in the same files.

> OK, so I'm guessing it's bursty smallish reads. That is the hardest
> case. If your MTRON has a write cache, it's very possible that by the
> time we stop the writes and issue the read, the device takes a long time
> to service that read. And if we then mix reads and writes, it's
> basically impossible to get any sort of interactiveness out of it.

So If I understand correctly: the write-cache would speed up the write from
the OS points of view. But each command given after the write still has to
wait untill the write-cache is processed?

Is there anyway I can check for the presence of such a write-cache?


> With the second rate SSD devices, you probably need to tweak the IO
> scheduling a bit to make that work well. If you try 2.6.30-rc1, you
> could try and set 'slice_async_rq' to 1 and slice_async to 5 in
> /sys/block/sda/queue/iosched/ (or sdX whatever is your device) with CFQ
> and see if that makes a difference. If the device is really slow,
> perhaps try and increase slice_idle as well.

Those tweaks indeed give an performance increase in the dd and write-test
testcases. 

> It wont help a lot because of the dependent nature of the reads you are
> doing. By the time you issue 1 read and it completes and until you issue
> the next read, you could very well have sent enough writes to the device
> that the next read will take equally long to complete.

I don't really get this: I assume that by dependent you mean that the first
read gives the information necessary to issue the next read request?
I would expect a database (knowing the table schema) to make an good
estimate on which data it needs to retrieve from the datafile.

The only dependency there is on the index, which is needed to know which
rows the query needs. But the majority of the index is cache in memory
anyway. Hmm, but that majority would probably point to the datafile part
that is kept in memory. It is an LRU after all...  So a physical read on the
index file would have a high probability of causing a physical read on the
datafile.  Ok, point taken..


Thanks,

Jos

Performance tests:
29-dirty = the writeback branch with the blk-latency patches applied.
30- = 2.6.30-r1
Write-test = random 4k writes to a 8GB file.
Dd = dd if=/dev/zero of=foo bs=1M

                                  read bytes per second  -  std dev samples
29-dirty-apr-dd-noop.text:                 2.39144e+06 - 1.54062e+06
30-apr-dd-noop.txt:                        291065 - 41556.6
29-dirty-apr-write-test-noop.text:         2.4075e+07 - 4.29928e+06
30-apr-write-test-noop.txt:                5.82404e+07 - 3.39006e+06

29-dirty-apr-dd-cfq.text:                   6.71294e+07 - 1.64957e+06
30-apr-dd-cfq.txt:                          5.31077e+07 - 3.14862e+06
29-dirty-apr-write-test-cfq.text:           6.57578e+07 - 2.31241e+06
30-apr-write-test-cfq.txt:                  6.87535e+07 - 2.23881e+06

29-dirty-apr-write-test-cfq-tuned.txt:      7.12343e+07 - 1.79695e+06
30-apr-write-test-cfq-tuned.txt:            7.74155e+07 - 2.16096e+06
29-dirty-apr-dd-cfq-tuned.txt:              9.98722e+07 - 2.20931e+06
30-apr-dd-cfq-tuned.txt:                    7.08474e+07 - 2.58305e+06









