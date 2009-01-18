Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZARVNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZARVNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZARVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:12:52 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:48626 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755312AbZARVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:12:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAJgnc0lMQWt2/2dsb2JhbACBbM1ShDeBPA
Date: Sun, 18 Jan 2009 16:12:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090118211234.GA4913@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090117190437.GZ30821@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:48:14 up 17 days, 20:46,  4 users,  load average: 0.78, 0.47,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (jens.axboe@oracle.com) wrote:
> On Sat, Jan 17 2009, Mathieu Desnoyers wrote:
> > A long standing I/O regression (since 2.6.18, still there today) has hit
> > Slashdot recently :
> > http://bugzilla.kernel.org/show_bug.cgi?id=12309
> > http://it.slashdot.org/article.pl?sid=09/01/15/049201
> > 
> > I've taken a trace reproducing the wrong behavior on my machine and I
> > think it's getting us somewhere.
> > 
> > LTTng 0.83, kernel 2.6.28
> > Machine : Intel Xeon E5405 dual quad-core, 16GB ram
> > (just created a new block-trace.c LTTng probe which is not released yet.
> > It basically replaces blktrace)
> > 
> > 
> > echo 3 > /proc/sys/vm/drop_caches
> > 
> > lttctl -C -w /tmp/trace -o channel.mm.bufnum=8 -o channel.block.bufnum=64 trace
> > 
> > dd if=/dev/zero of=/tmp/newfile bs=1M count=1M
> > cp -ax music /tmp   (copying 1.1GB of mp3)
> > 
> > ls  (takes 15 seconds to get the directory listing !)
> > 
> > lttctl -D trace
> > 
> > I looked at the trace (especially at the ls surroundings), and bash is
> > waiting for a few seconds for I/O in the exec system call (to exec ls).
> > 
> > While this happens, we have dd doing lots and lots of bio_queue. There
> > is a bio_backmerge after each bio_queue event. This is reasonable,
> > because dd is writing to a contiguous file.
> > 
> > However, I wonder if this is not the actual problem. We have dd which
> > has the head request in the elevator request queue. It is progressing
> > steadily by plugging/unplugging the device periodically and gets its
> > work done. However, because requests are being dequeued at the same
> > rate others are being merged, I suspect it stays at the top of the queue
> > and does not let the other unrelated requests run.
> > 
> > There is a test in the blk-merge.c which makes sure that merged requests
> > do not get bigger than a certain size. However, if the request is
> > steadily dequeued, I think this test is not doing anything.
> > 
> > 
> > This patch implements a basic test to make sure we never merge more
> > than 128 requests into the same request if it is the "last_merge"
> > request. I have not been able to trigger the problem again with the
> > fix applied. It might not be in a perfect state : there may be better
> > solutions to the problem, but I think it helps pointing out where the
> > culprit lays.
> 
> To be painfully honest, I have no idea what you are attempting to solve
> with this patch. First of all, Linux has always merged any request
> possible. The one-hit cache is just that, a one hit cache frontend for
> merging. We'll be hitting the merge hash and doing the same merge if it
> fails. Since we even cap the size of the request, the merging is also
> bounded.
> 

Hi Jens,

I was mostly trying to poke around and try to figure out what was going
on in the I/O elevator. Sorry if my first attempts did not make much
sense. Following your advice, I've looked more deeply into the test
cases.

> Furthermore, the request being merged is not considered for IO yet. It
> has not been dispatched by the io scheduler. IOW, I'm surprised your
> patch makes any difference at all. Especially with your 128 limit, since
> 4kbx128kb is 512kb which is the default max merge size anyway. These
> sort of test cases tend to be very sensitive and exhibit different
> behaviour for many runs, so call me a bit skeptical and consider that an
> enouragement to do more directed testing. You could use fio for
> instance. Have two jobs in your job file. One is a dd type process that
> just writes a huge file, the other job starts eg 10 seconds later and
> does a 4kb read of a file.
> 

I looked at the "ls" behavior (while doing a dd) within my LTTng trace
to create a fio job file.  The said behavior is appended below as "Part
1 - ls I/O behavior". Note that the original "ls" test case was done
with the anticipatory I/O scheduler, which was active by default on my
debian system with custom vanilla 2.6.28 kernel. Also note that I am
running this on a raid-1, but have experienced the same problem on a
standard partition I created on the same machine.

I created the fio job file appended as "Part 2 - dd+ls fio job file". It
consists of one dd-like job and many small jobs reading as many data as
ls did. I used the small test script to batch run this ("Part 3 - batch
test").

The results for the ls-like jobs are interesting :

I/O scheduler        runt-min (msec)   runt-max (msec)
noop                       41             10563
anticipatory               63              8185
deadline                   52             33387
cfq                        43              1420


> As a quick test, could you try and increase the slice_idle to eg 20ms?
> Sometimes I've seen timing being slightly off, which makes us miss the
> sync window for the ls (in your case) process. Then you get a mix of
> async and sync IO all the time, which very much slows down the sync
> process.
> 

Just to confirm, the quick test you are taking about would be :

---
 block/cfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/block/cfq-iosched.c
===================================================================
--- linux-2.6-lttng.orig/block/cfq-iosched.c	2009-01-18 15:17:32.000000000 -0500
+++ linux-2.6-lttng/block/cfq-iosched.c	2009-01-18 15:46:38.000000000 -0500
@@ -26,7 +26,7 @@ static const int cfq_back_penalty = 2;
 static const int cfq_slice_sync = HZ / 10;
 static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
-static int cfq_slice_idle = HZ / 125;
+static int cfq_slice_idle = 20;
 
 /*
  * offset from end of service tree


It does not make much difference with the standard cfq test :

I/O scheduler        runt-min (msec)   runt-max (msec)
cfq (standard)             43              1420
cfq (20ms slice_idle)      31              1573


So, I guess 1.5s delay to run ls on a directory when the cache is cold
with a cfq I/O scheduler is somewhat acceptable, but I doubt the 8, 10
and 33s response times for the anticipatory, noop and deadline I/O
schedulers are. I wonder why on earth is the anticipatory I/O scheduler
activated by default with my kernel given it results in so poor
interactive behavior when doing large I/O ?

Thanks for the advices,

Mathieu



* Part 1 - ls I/O behavior

lttv -m textDump -t /traces/block-backmerge \
     -e "state.pid=4145&event.subname=bio_queue"

block.bio_queue: 662.707321959 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, SYSCALL { sector = 327680048, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 662.707331445 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, SYSCALL { sector = 349175018, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.968214766 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, SYSCALL { sector = 327696968, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.968222110 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, SYSCALL { sector = 349191938, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971662800 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 327697032, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971670417 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 349192002, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971684184 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 327697040, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971689854 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 349192010, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971695762 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 327697048, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971701135 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 349192018, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971706301 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 327697056, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971711698 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 349192026, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971723359 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 327697064, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.971729035 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 349192034, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.999391873 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 327697072, size = 53248, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 662.999397864 (/traces/block-backmerge/block_2), 4145, 4145, bash, , 4063, 0x0, TRAP { sector = 349192042, size = 53248, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 670.809328737 (/traces/block-backmerge/block_7), 4145, 4145, /bin/ls, , 4063, 0x0, TRAP { sector = 327697000, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 670.809337500 (/traces/block-backmerge/block_7), 4145, 4145, /bin/ls, , 4063, 0x0, TRAP { sector = 349191970, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 671.161036834 (/traces/block-backmerge/block_5), 4145, 4145, /bin/ls, , 4063, 0x0, SYSCALL { sector = 360714880, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 671.161047247 (/traces/block-backmerge/block_5), 4145, 4145, /bin/ls, , 4063, 0x0, SYSCALL { sector = 382209850, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 671.653601399 (/traces/block-backmerge/block_7), 4145, 4145, /bin/ls, , 4063, 0x0, SYSCALL { sector = 360712184, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 671.653611077 (/traces/block-backmerge/block_7), 4145, 4145, /bin/ls, , 4063, 0x0, SYSCALL { sector = 382207154, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }


* Part 2 - dd+ls fio job file (test.job5)

[job1]
rw=write
size=10240m
direct=0
blocksize=1024k

[global]
rw=randread
size=96k
filesize=30m
direct=0
bsrange=4k-52k

[file1]
startdelay=0

[file2]
startdelay=4

[file3]
startdelay=8

[file4]
startdelay=12

[file5]
startdelay=16

[file6]
startdelay=20

[file7]
startdelay=24

[file8]
startdelay=28

[file9]
startdelay=32

[file10]
startdelay=36

[file11]
startdelay=40

[file12]
startdelay=44

[file13]
startdelay=48

[file14]
startdelay=52

[file15]
startdelay=56

[file16]
startdelay=60

[file17]
startdelay=64

[file18]
startdelay=68

[file19]
startdelay=72

[file20]
startdelay=76

[file21]
startdelay=80

[file22]
startdelay=84

[file23]
startdelay=88

[file24]
startdelay=92

[file25]
startdelay=96

[file26]
startdelay=100

[file27]
startdelay=104

[file28]
startdelay=108

[file29]
startdelay=112

[file30]
startdelay=116

[file31]
startdelay=120

[file32]
startdelay=124

[file33]
startdelay=128

[file34]
startdelay=132

[file35]
startdelay=134

[file36]
startdelay=138

[file37]
startdelay=142

[file38]
startdelay=146

[file39]
startdelay=150

[file40]
startdelay=200

[file41]
startdelay=260


* Part 3 - batch test (do-tests.sh)

#!/bin/sh

TESTS="anticipatory noop deadline cfq"

for TEST in ${TESTS}; do 
	echo "Running ${TEST}"
	
	rm -f file*.0 job*.0

	echo ${TEST} > /sys/block/sda/queue/scheduler
	echo ${TEST} > /sys/block/sdb/queue/scheduler
	sync
	echo 3 > /proc/sys/vm/drop_caches
	sleep 5
	
	./fio test.job5 --output test.result.${TEST}
done


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
