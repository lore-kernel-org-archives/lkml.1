Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZDWL2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZDWL2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZDWL2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:28:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33729 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZDWL2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:28:24 -0400
Date: Thu, 23 Apr 2009 13:28:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority
	requests   in deadline IO scheduler
Message-ID: <20090423112823.GB4593@kernel.dk>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Corrado Zoccolo wrote:
> Hi,
> deadline I/O scheduler currently classifies all I/O requests in only 2
> classes, reads (always considered high priority) and writes (always
> lower).
> The attached patch, intended to reduce latencies for syncronous writes
> and high I/O priority requests, introduces more levels of priorities:
> * real time reads: highest priority and shortest deadline, can starve
> other levels
> * syncronous operations (either best effort reads or RT/BE writes),
> mid priority, starvation for lower level is prevented as usual
> * asyncronous operations (async writes and all IDLE class requests),
> lowest priority and longest deadline
> 
> The patch also introduces some new heuristics:
> * for non-rotational devices, reads (within a given priority level)
> are issued in FIFO order, to improve the latency perceived by readers

Danger danger... I smell nasty heuristics.

> * minimum batch timespan (time quantum): partners with fifo_batch to
> improve throughput, by sending more consecutive requests together. A
> given number of requests will not always take the same time (due to
> amount of seek needed), therefore fifo_batch must be tuned for worst
> cases, while in best cases, having longer batches would give a
> throughput boost.
> * batch start request is chosen fifo_batch/3 requests before the
> expired one, to improve fairness for requests with lower start sector,
> that otherwise have higher probability to miss a deadline than
> mid-sector requests.

This is a huge patch, I'm not going to be reviewing this. Make this a
patchset, each doing that little change separately. Then it's easier to
review, and much easier to pick the parts that can go in directly and
leave the ones that either need more work or are not going be merged
out.

> I did few performance comparisons:
> * HDD, ext3 partition with data=writeback, tiotest with 32 threads,
> each writing 80MB of data

It doesn't seem to make a whole lot of difference, does it?

> ** deadline-original
> Tiotest results for 32 concurrent io threads:
> ,----------------------------------------------------------------------.
> | Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
> +-----------------------+----------+--------------+----------+---------+
> | Write        2560 MBs |  103.0 s |  24.848 MB/s |  10.6 %  | 522.2 % |
> | Random Write  125 MBs |   98.8 s |   1.265 MB/s |  -1.6 %  |  16.1 % |
> | Read         2560 MBs |  166.2 s |  15.400 MB/s |   4.2 %  |  82.7 % |
> | Random Read   125 MBs |  193.3 s |   0.647 MB/s |  -0.8 %  |  14.5 % |
> `----------------------------------------------------------------------'
> Tiotest latency results:
> ,-------------------------------------------------------------------------.
> | Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
> +--------------+-----------------+-----------------+----------+-----------+
> | Write        |        4.122 ms |    17922.920 ms |  0.07980 |   0.00061 |
> | Random Write |        0.599 ms |     1245.200 ms |  0.00000 |   0.00000 |
> | Read         |        8.032 ms |     1125.759 ms |  0.00000 |   0.00000 |
> | Random Read  |      181.968 ms |      972.657 ms |  0.00000 |   0.00000 |
> |--------------+-----------------+-----------------+----------+-----------|
> | Total        |       10.044 ms |    17922.920 ms |  0.03804 |   0.00029 |
> `--------------+-----------------+-----------------+----------+-----------'
> 
> ** deadline-patched
> Tiotest results for 32 concurrent io threads:
> ,----------------------------------------------------------------------.
> | Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
> +-----------------------+----------+--------------+----------+---------+
> | Write        2560 MBs |  105.3 s |  24.301 MB/s |  10.5 %  | 514.8 % |
> | Random Write  125 MBs |   95.9 s |   1.304 MB/s |  -1.8 %  |  17.3 % |
> | Read         2560 MBs |  165.1 s |  15.507 MB/s |   2.7 %  |  61.9 % |
> | Random Read   125 MBs |  110.6 s |   1.130 MB/s |   0.8 %  |  12.2 % |
> `----------------------------------------------------------------------'
> Tiotest latency results:
> ,-------------------------------------------------------------------------.
> | Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
> +--------------+-----------------+-----------------+----------+-----------+
> | Write        |        4.131 ms |    17456.831 ms |  0.08041 |   0.00275 |
> | Random Write |        2.780 ms |     5073.180 ms |  0.07500 |   0.00000 |
> | Read         |        7.748 ms |      936.499 ms |  0.00000 |   0.00000 |
> | Random Read  |      104.849 ms |      695.192 ms |  0.00000 |   0.00000 |
> |--------------+-----------------+-----------------+----------+-----------|
> | Total        |        8.168 ms |    17456.831 ms |  0.04008 |   0.00131 |
> `--------------+-----------------+-----------------+----------+-----------'

Main difference here seems to be random read performance, the rest are
pretty close and could just be noise. Random write is much worse, from a
latency view point. Is this just one run, or did you average several?

For something like this, you also need to consider workloads that
consist of processes with different IO patterns running at the same
time. With this tiotest run, you only test sequential readers competing,
then random readers, etc.

So, please, split the big patch into lots of little separate pieces.
Benchmark each one separately, so they each carry their own
justification.

> * fsync-tester results, on HDD, empty ext3 partition, mounted with
> data=writeback
> ** deadline-original:
> fsync time: 0.7963
> fsync time: 4.5914
> fsync time: 4.2347
> fsync time: 1.1670
> fsync time: 0.8164
> fsync time: 1.9783
> fsync time: 4.9726
> fsync time: 2.4929
> fsync time: 2.5448
> fsync time: 3.9627
> ** cfq 2.6.30-rc2
> fsync time: 0.0288
> fsync time: 0.0528
> fsync time: 0.0299
> fsync time: 0.0397
> fsync time: 0.5720
> fsync time: 0.0409
> fsync time: 0.0876
> fsync time: 0.0294
> fsync time: 0.0485
> ** deadline-patched
> fsync time: 0.0772
> fsync time: 0.0381
> fsync time: 0.0604
> fsync time: 0.2923
> fsync time: 0.2488
> fsync time: 0.0924
> fsync time: 0.0144
> fsync time: 1.4824
> fsync time: 0.0789
> fsync time: 0.0565
> fsync time: 0.0550
> fsync time: 0.0421

At least this test looks a lot better!

-- 
Jens Axboe

