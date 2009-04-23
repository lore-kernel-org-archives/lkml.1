Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZDWMCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZDWMCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZDWMBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:01:52 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:45158 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbZDWMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:01:51 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 08:01:50 EDT
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Corrado Zoccolo <czoccolo@gmail.com>
Date: Thu, 23 Apr 2009 21:52:57 +1000
Message-ID: <49F05699.2070006@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.19 (X11/20090126)
MIME-Version: 1.0
CC: jens.axboe@oracle.com, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority
 requests in deadline IO scheduler
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
In-Reply-To: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo wrote:
> Hi,
> deadline I/O scheduler currently classifies all I/O requests in only 2
> classes, reads (always considered high priority) and writes (always
> lower).
> The attached patch, intended to reduce latencies for syncronous writes

Can be achieved by switching to sync/async rather than read/write.  No
one has shown results where this makes an improvement.  Let us know if
you have a good example.

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

This might be a good idea.  Can you make this a separate patch?
Is there a good reason not to do the same for writes?

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

I don't like the rest of it.  I use deadline because it's a simple,
no surprises, no bullshit scheduler with reasonably good performance
in all situations.  Is there some reason why CFQ won't work for you?

> I did few performance comparisons:
> * HDD, ext3 partition with data=writeback, tiotest with 32 threads,
> each writing 80MB of data
> 
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
> ** cfq (2.6.30-rc2)
> Tiotest results for 32 concurrent io threads:
> ,----------------------------------------------------------------------.
> | Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
> +-----------------------+----------+--------------+----------+---------+
> | Write        2560 MBs |  132.4 s |  19.342 MB/s |   8.5 %  | 400.4 % |
> | Random Write  125 MBs |  107.8 s |   1.159 MB/s |  -1.6 %  |  16.8 % |
> | Read         2560 MBs |  107.6 s |  23.788 MB/s |   5.4 %  |  95.7 % |
> | Random Read   125 MBs |  158.4 s |   0.789 MB/s |   0.9 %  |   7.7 % |
> `----------------------------------------------------------------------'
> Tiotest latency results:
> ,-------------------------------------------------------------------------.
> | Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
> +--------------+-----------------+-----------------+----------+-----------+
> | Write        |        5.362 ms |    21081.012 ms |  0.09811 |   0.00244 |
> | Random Write |       23.310 ms |    31865.095 ms |  0.13437 |   0.06250 |
> | Read         |        5.048 ms |     3694.001 ms |  0.15167 |   0.00000 |
> | Random Read  |      146.523 ms |     2880.409 ms |  0.52187 |   0.00000 |
> |--------------+-----------------+-----------------+----------+-----------|
> | Total        |        8.916 ms |    31865.095 ms |  0.13435 |   0.00262 |
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
> 
> * SD card, nilfs2 partition, tiotest with 16 threads, each writing 80MB of data
> ** cfq(2.6.30-rc2)
> Tiotest results for 16 concurrent io threads:
> ,----------------------------------------------------------------------.
> | Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
> +-----------------------+----------+--------------+----------+---------+
> | Write        1280 MBs |  217.8 s |   5.878 MB/s |   3.7 %  |  92.2 % |
> | Random Write   62 MBs |   18.2 s |   3.432 MB/s |  -2.3 %  |  28.7 % |
> | Read         1280 MBs |  114.7 s |  11.156 MB/s |   7.3 %  |  76.6 % |
> | Random Read    62 MBs |    3.4 s |  18.615 MB/s |  -5.4 %  | 274.2 % |
> `----------------------------------------------------------------------'
> Tiotest latency results:
> ,-------------------------------------------------------------------------.
> | Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
> +--------------+-----------------+-----------------+----------+-----------+
> | Write        |        9.943 ms |    10223.581 ms |  0.14252 |   0.00488 |
> | Random Write |       12.287 ms |     5097.196 ms |  0.25625 |   0.00000 |
> | Read         |        5.352 ms |     1550.162 ms |  0.00000 |   0.00000 |
> | Random Read  |        3.051 ms |     1507.837 ms |  0.00000 |   0.00000 |
> |--------------+-----------------+-----------------+----------+-----------|
> | Total        |        7.649 ms |    10223.581 ms |  0.07391 |   0.00233 |
> `--------------+-----------------+-----------------+----------+-----------'
> 
> ** deadline-patched:
> Tiotest results for 16 concurrent io threads:
> ,----------------------------------------------------------------------.
> | Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
> +-----------------------+----------+--------------+----------+---------+
> | Write        1280 MBs |  220.9 s |   5.794 MB/s |   4.0 %  |  93.9 % |
> | Random Write   62 MBs |   20.5 s |   3.044 MB/s |  -2.2 %  |  24.9 % |
> | Read         1280 MBs |  113.2 s |  11.304 MB/s |   6.8 %  |  72.8 % |
> | Random Read    62 MBs |    2.9 s |  21.896 MB/s |   5.1 %  | 293.8 % |
> `----------------------------------------------------------------------'
> Tiotest latency results:
> ,-------------------------------------------------------------------------.
> | Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
> +--------------+-----------------+-----------------+----------+-----------+
> | Write        |       10.078 ms |    13303.036 ms |  0.14160 |   0.00031 |
> | Random Write |       14.350 ms |     5265.088 ms |  0.40000 |   0.00000 |
> | Read         |        5.455 ms |      434.495 ms |  0.00000 |   0.00000 |
> | Random Read  |        2.685 ms |       12.652 ms |  0.00000 |   0.00000 |
> |--------------+-----------------+-----------------+----------+-----------|
> | Total        |        7.801 ms |    13303.036 ms |  0.07682 |   0.00015 |
> `--------------+-----------------+-----------------+----------+-----------'
> 
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
> ** deadline-patched, ionice -c1:
> fsync time: 0.2569
> fsync time: 0.0500
> fsync time: 0.0681
> fsync time: 0.2863
> fsync time: 0.0140
> fsync time: 0.0171
> fsync time: 0.1198
> fsync time: 0.0530
> fsync time: 0.0503
> fsync time: 0.0462
> fsync time: 0.0484
> fsync time: 0.0328
> fsync time: 0.0562
> fsync time: 0.0451
> fsync time: 0.0576
> fsync time: 0.0444
> fsync time: 0.0469
> fsync time: 0.0368
> fsync time: 0.2865
> 
> Corrado
> 

