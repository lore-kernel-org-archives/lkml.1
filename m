Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZATCQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZATCQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZATCQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:16:11 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:34887 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbZATCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:16:08 -0500
Date: Mon, 19 Jan 2009 21:10:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090120021055.GA6990@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090119182654.GT30821@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:23:12 up 19 days, 21 min,  2 users,  load average: 0.52, 0.45,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (jens.axboe@oracle.com) wrote:
> On Sun, Jan 18 2009, Mathieu Desnoyers wrote:
> > I looked at the "ls" behavior (while doing a dd) within my LTTng trace
> > to create a fio job file.  The said behavior is appended below as "Part
> > 1 - ls I/O behavior". Note that the original "ls" test case was done
> > with the anticipatory I/O scheduler, which was active by default on my
> > debian system with custom vanilla 2.6.28 kernel. Also note that I am
> > running this on a raid-1, but have experienced the same problem on a
> > standard partition I created on the same machine.
> > 
> > I created the fio job file appended as "Part 2 - dd+ls fio job file". It
> > consists of one dd-like job and many small jobs reading as many data as
> > ls did. I used the small test script to batch run this ("Part 3 - batch
> > test").
> > 
> > The results for the ls-like jobs are interesting :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > noop                       41             10563
> > anticipatory               63              8185
> > deadline                   52             33387
> > cfq                        43              1420
> 

Extra note : I have a HZ=250 on my system. Changing to 100 or 1000 did
not make much difference (also tried with NO_HZ enabled).

> Do you have queuing enabled on your drives? You can check that in
> /sys/block/sdX/device/queue_depth. Try setting those to 1 and retest all
> schedulers, would be good for comparison.
> 

Here are the tests with a queue_depth of 1 :

I/O scheduler        runt-min (msec)   runt-max (msec)
noop                       43             38235
anticipatory               44              8728
deadline                   51             19751
cfq                        48               427


Overall, I wouldn't say it makes much difference.


> raid personalities or dm complicates matters, since it introduces a
> disconnect between 'ls' and the io scheduler at the bottom...
> 

Yes, ideally I should re-run those directly on the disk partitions.

I am also tempted to create a fio job file which acts like a ssh server
receiving a connexion after it has been pruned from the cache while the
system if doing heavy I/O. "ssh", in this case, seems to be doing much
more I/O than a simple "ls", and I think we might want to see if cfq
behaves correctly in such case. Most of this I/O is coming from page
faults (identified as traps in the trace) probably because the ssh
executable has been thrown out of the cache by

echo 3 > /proc/sys/vm/drop_caches

The behavior of an incoming ssh connexion after clearing the cache is
appended below (Part 1 - LTTng trace for incoming ssh connexion). The
job file created (Part 2) reads, for each job, a 2MB file with random
reads each between 4k-44k. The results are very interesting for cfq :

I/O scheduler        runt-min (msec)   runt-max (msec)
noop                       586           110242
anticipatory               531            26942
deadline                   561           108772
cfq                        523            28216

So, basically, ssh being out of the cache can take 28s to answer an
incoming ssh connexion even with the cfq scheduler. This is not exactly
what I would call an acceptable latency.

Mathieu


* Part 1 - LTTng trace for incoming ssh connexion


block.bio_queue: 14270.987362011 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, sshd, , 4159, 0x0, SYSCALL { sector = 12312, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14270.987370577 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, sshd, , 4159, 0x0, SYSCALL { sector = 21507282, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14271.002701211 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, sshd, , 4159, 0x0, SYSCALL { sector = 376717312, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14271.002708852 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, sshd, , 4159, 0x0, SYSCALL { sector = 398212282, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14271.994249134 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, sshd, , 4159, 0x0, SYSCALL { sector = 376762504, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14271.994258500 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, sshd, , 4159, 0x0, SYSCALL { sector = 398257474, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.005047300 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 186581088, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.005054182 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 208076058, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.197046688 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 186581680, size = 45056, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.197056120 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 208076650, size = 45056, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.214463959 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 376983192, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.214469777 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 398478162, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.358980449 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 376983312, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.358986893 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, sshd, , 4159, 0x0, TRAP { sector = 398478282, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366179882 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504036296, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366188841 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525531266, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366228133 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504037392, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366233770 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525532362, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366245471 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504070144, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366250460 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525565114, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366258431 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172624, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366263414 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667594, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366271329 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172640, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366275709 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667610, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366305707 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172664, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366311569 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667634, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366320581 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172680, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366327005 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667650, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366334928 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172688, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366339671 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667658, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366351578 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172696, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.366356064 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667666, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.394371136 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172704, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.394378840 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667674, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.394396826 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 504172744, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.394402397 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525667714, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.504393076 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 376762496, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14272.504399733 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 398257466, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.651642743 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376819168, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.651650198 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398314138, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.651668568 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376819192, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.651673473 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398314162, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.813095173 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376930384, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.813103780 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398425354, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.818773204 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376983360, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.818779958 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398478330, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.867827280 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376871792, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.867834786 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398366762, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.867857878 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376871816, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14272.867863845 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398366786, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.000933599 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376871832, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.000941927 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398366802, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.000962547 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376871856, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.000967971 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398366826, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.000988999 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376871896, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.000994441 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398366866, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.016781818 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557798168, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.016787698 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579293138, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.027449494 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557798264, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.027455846 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579293234, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.079950572 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557801192, size = 69632, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.079957430 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579296162, size = 69632, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.087728033 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557800984, size = 106496, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.087734033 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579295954, size = 106496, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.205730103 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376977904, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.205735312 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398472874, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.213716615 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557596672, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.213725447 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579091642, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.376105867 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557632888, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.376113769 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579127858, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390329162 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744176, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390338057 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239146, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390366345 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744184, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390371136 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239154, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390384775 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744192, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390389617 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239162, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390402469 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744200, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390407113 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239170, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390420125 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744208, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390424982 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239178, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390432638 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744216, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390436805 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239186, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390462732 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744224, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.390467689 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239194, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.548801789 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744232, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.548812506 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239202, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.548844346 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557744256, size = 32768, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.548850571 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579239226, size = 32768, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555483129 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978008, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555489558 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398472978, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555502566 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978016, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555507462 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398472986, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555513691 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978024, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555518362 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398472994, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555522790 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978032, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555527365 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473002, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555531940 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978040, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555536359 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473010, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555540953 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978048, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555545306 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473018, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555549707 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978056, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555554228 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473026, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555565226 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978064, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.555583185 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473034, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.556111195 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978072, size = 12288, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.556116436 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473042, size = 12288, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.556132550 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978104, size = 24576, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.556137395 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473074, size = 24576, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.557633755 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376979192, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.557639746 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398474162, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.557651417 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376979240, size = 12288, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.557655782 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398474210, size = 12288, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.558790122 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978680, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.558797670 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473650, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.558810157 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978688, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.558815023 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473658, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.558826051 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978736, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.558830869 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473706, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.559618325 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978744, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.559624455 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473714, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.559648476 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978760, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.559653673 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473730, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.560470401 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557632776, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.560475954 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579127746, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.564633093 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557647824, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.564639949 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579142794, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.570412202 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557647944, size = 36864, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.570417494 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579142914, size = 36864, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.570432050 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557648024, size = 28672, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.570436544 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579142994, size = 28672, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.573250317 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557648112, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.573255825 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579143082, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.573813668 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557648208, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.573819380 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579143178, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.574357597 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557649240, size = 69632, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.574363720 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579144210, size = 69632, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.579745509 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557632816, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.579750936 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579127786, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.580137575 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557649536, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.580143137 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579144506, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.581782686 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557649648, size = 28672, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.581787972 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579144618, size = 28672, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.581798890 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557649712, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.581803213 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579144682, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.583373838 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376980416, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.583379589 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398475386, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.592597554 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376982864, size = 77824, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.592603461 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398477834, size = 77824, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.605484632 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 557649424, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.605490392 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 579144394, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.606285537 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376766472, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.606292749 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398261442, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.618255248 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503841136, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.618262031 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525336106, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.766848612 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957088, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.766854819 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452058, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.779173851 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503857536, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.779179020 (/traces/trace-slow-ssh-pid-5555/block_3), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525352506, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.956064108 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 383516688, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.956073127 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 405011658, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14273.963661833 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504172672, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14273.963667482 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525667642, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.105890774 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503857200, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.105897887 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525352170, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.114466614 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 639844352, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14274.114471721 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 661339322, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.194546003 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503857392, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.194551112 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525352362, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.195244833 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376978584, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.195250131 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398473554, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.342679172 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376977824, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.342686069 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398472794, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.342702066 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376977864, size = 12288, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.342706689 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398472834, size = 12288, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514308041 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376979128, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514316219 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398474098, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514332549 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376979144, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514337418 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398474114, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514354278 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376979160, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514358806 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398474130, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514371841 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376979176, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.514376353 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398474146, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.671607720 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 110366736, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.671614533 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 131861706, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.688855653 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503841144, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14274.688861789 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525336114, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.710775517 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957224, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14274.710783249 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452194, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.711178453 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504036272, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14274.711185887 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525531242, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14275.753947620 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 557727992, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14275.753956191 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579222962, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14275.891101527 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 558242792, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14275.891109390 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 579737762, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.054306664 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566165504, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14276.054312781 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587660474, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.202061219 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169560, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.202067900 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664530, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.343169743 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169656, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.343177097 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664626, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.435036005 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566171584, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.435042329 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587666554, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.587967625 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170576, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.587975446 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665546, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.714877542 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566171080, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.714885441 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587666050, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.885331923 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170824, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14276.885338400 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665794, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.041004774 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170696, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.041011242 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665666, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.090024321 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170760, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.090030807 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665730, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.139160617 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170792, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.139166503 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665762, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.146527238 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170808, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.146532806 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665778, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.147041642 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170816, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.147046664 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665786, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.147056378 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566170832, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.147060909 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587665802, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.149654636 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504086544, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.149661995 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525581514, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.299441568 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566165512, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.299449098 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587660482, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.316058849 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566165608, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.316064702 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587660578, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.316655231 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566167536, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.316661231 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587662506, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.319198772 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566168544, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.319204644 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587663514, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.325427594 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169048, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.325432190 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664018, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.327980237 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169296, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.327985268 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664266, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.329234978 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169168, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.329239811 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664138, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.330769742 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169104, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.330775631 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664074, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.331300113 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169136, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.331305777 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664106, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.331634685 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169120, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.331640664 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664090, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.332191280 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169112, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.332198036 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664082, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.332857870 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 641990688, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14277.332863016 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 663485658, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.339925356 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504086552, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.339930549 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525581522, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.350000251 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503840960, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14277.350007112 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525335930, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.360440736 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503844888, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.360446037 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525339858, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.417649469 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503841152, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14277.417655383 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525336122, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418058555 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957240, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418063403 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452210, size = 16384, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418555076 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957272, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418560377 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452242, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418570217 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957280, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418574897 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452250, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418581063 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957288, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418585764 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452258, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418590078 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957296, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418594614 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452266, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418598451 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957304, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418602756 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452274, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418606908 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957312, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418611238 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452282, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418615216 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957320, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418619527 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452290, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418623322 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957328, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418627663 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452298, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418836246 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957336, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.418841193 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452306, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.419381341 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957344, size = 65536, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.419386225 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452314, size = 65536, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.419849133 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503957472, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.419853747 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525452442, size = 20480, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.576690908 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 110510128, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.576698949 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 132005098, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.588845789 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503988328, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.588852656 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525483298, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.601952879 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503873536, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14277.601959539 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525368506, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.060232543 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376983048, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.060241912 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398478018, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.064129159 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503857272, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14278.064138655 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525352242, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.071310370 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504037776, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.071330264 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525532746, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.080891196 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503939072, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.080897109 (/traces/trace-slow-ssh-pid-5555/block_1), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525434042, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084320641 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376947512, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084328574 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398442482, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084343616 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376947552, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084348755 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398442522, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084358266 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376947568, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084363390 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398442538, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084378252 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376947576, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.084383308 (/traces/trace-slow-ssh-pid-5555/block_0), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398442546, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.096592889 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376947584, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.096599909 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398442554, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.096953622 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 376946984, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.096958890 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 398441954, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.101879473 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503955464, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.101885305 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525450434, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.118154240 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503971864, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.118162137 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525466834, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.126133387 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503988608, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.126139687 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525483578, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.136351623 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503857280, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.136357399 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525352250, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.138499766 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169080, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.138506375 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664050, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.139160026 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169064, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.139165315 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664034, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.139782848 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169072, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.139788161 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664042, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.139799535 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 566169088, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.139804017 (/traces/trace-slow-ssh-pid-5555/block_5), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 587664058, size = 8192, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.141005857 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503841632, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14278.141012172 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525336602, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.149367501 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 503956240, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.149373775 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525451210, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.155173707 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 315408384, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14278.155179359 (/traces/trace-slow-ssh-pid-5555/block_6), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 336903354, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.169842985 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 483393984, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14278.169849091 (/traces/trace-slow-ssh-pid-5555/block_7), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504888954, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.180896269 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 483400808, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14278.180903577 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 504895778, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.184431117 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 483795656, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.184437162 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 505290626, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.209624125 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 503923064, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.209631628 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, TRAP { sector = 525418034, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.221083451 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 503873552, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.221090019 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 525368522, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.318767351 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 640040968, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 10, not_uptodate = 0 }
block.bio_queue: 14278.318773435 (/traces/trace-slow-ssh-pid-5555/block_4), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 661535938, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.325009226 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 641367208, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.325014566 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 662862178, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.330573352 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 641367216, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }
block.bio_queue: 14278.330579649 (/traces/trace-slow-ssh-pid-5555/block_2), 5555, 5555, /usr/sbin/sshd, , 4159, 0x0, SYSCALL { sector = 662862186, size = 4096, rw(FAILFAST_DRIVER,FAILFAST_TRANSPORT, = 0, not_uptodate = 0 }


* Part 2 - ssh connexion job file (test.job.ssh)

[job1]
rw=write
size=10240m
direct=0
blocksize=1024k

[global]
rw=randread
size=2048k
filesize=30m
direct=0
bsrange=4k-44k

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

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
