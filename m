Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZA2Lh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZA2Lh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 06:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZA2LhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 06:37:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZA2LhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 06:37:16 -0500
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233224644.5294.52.camel@bugs-laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 12:37:08 +0100
Message-Id: <1233229028.4495.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 11:24 +0100, Thomas Pilarski wrote:
> Some explanation of the test program. 
> 
> ../schedulerissue 1 4096 8 2000
> 1 producer and 1 consumer
> buffer size of 4096 doubles * 8byte 
> 8 buffer (256kB total buffer)
> 2000 messages
> 
> ../schedulerissue 2 4096 8 2000
> 2 producer and 2 consumer
> buffer size of 4096 doubles * 8byte 
> 8 buffer (256kB total buffer)
> 2000 messages
> 
> 
> It was not 512KB bytes in the test before, but 4MB.
> But there is the same problem with a total buffer size of 48kB and 4
> threads (./schedulerissue 2 2048 3 20000).

Linux opteron 2.6.29-rc3-tip #61 SMP PREEMPT Thu Jan 29 11:59:15 CET
2009 x86_64 x86_64 x86_64 GNU/Linux

[root@opteron bench]# schedtool -a 1 -e ./ThreadSchedulingIssue 1 4096 8 20000
All threads finished: 19992 messages in 6.485 seconds / 3082.877 msg/s
[root@opteron bench]# ./ThreadSchedulingIssue 1 4096 8 20000
All threads finished: 19992 messages in 6.496 seconds / 3077.604 msg/s
[root@opteron bench]# ./ThreadSchedulingIssue 1 4096 8 20000 & ./ThreadSchedulingIssue 1 4096 8 20000 &
[1] 10314
[2] 10315
[root@opteron bench]# All threads finished: 19992 messages in 6.720 seconds / 2975.009 msg/s
All threads finished: 19992 messages in 6.792 seconds / 2943.574 msg/s

[1]-  Done                    ./ThreadSchedulingIssue 1 4096 8 20000
[2]+  Done                    ./ThreadSchedulingIssue 1 4096 8 20000
[root@opteron bench]# ./ThreadSchedulingIssue 2 4096 8 20000
All threads finished: 19992 messages in 17.299 seconds / 1155.667 msg/s


[root@opteron bench]# for i in 4 8 16 32 64 128 256 ; do 
> echo -n $((i*1024)) $((80000/i)) " " ; 
> schedtool -a 1 -e ./ThreadSchedulingIssue 1 $((i*1024)) 8 $((80000/i)) ;
> done
4096 20000  All threads finished: 19992 messages in 6.368 seconds / 3139.251 msg/s
8192 10000  All threads finished: 9992 messages in 5.363 seconds / 1863.083 msg/s
16384 5000  All threads finished: 4992 messages in 5.471 seconds / 912.479 msg/s
32768 2500  All threads finished: 2493 messages in 5.730 seconds / 435.059 msg/s
65536 1250  All threads finished: 1242 messages in 5.544 seconds / 224.021 msg/s
131072 625  All threads finished: 617 messages in 5.755 seconds / 107.217 msg/s
262144 312  All threads finished: 305 messages in 6.014 seconds / 50.713 msg/s

[root@opteron bench]# for i in 4 8 16 32 64 128 256 ; do
> echo -n $((i*1024)) $((80000/i)) " " ;
> ./ThreadSchedulingIssue 1 $((i*1024)) 8 $((80000/i)) ;
> done
4096 20000  All threads finished: 19992 messages in 6.462 seconds / 3093.717 msg/s
8192 10000  All threads finished: 9992 messages in 8.767 seconds / 1139.738 msg/s
16384 5000  All threads finished: 5000 messages in 5.366 seconds / 931.798 msg/s
32768 2500  All threads finished: 2494 messages in 20.720 seconds / 120.369 msg/s
65536 1250  All threads finished: 1242 messages in 11.521 seconds / 107.805 msg/s
131072 625  All threads finished: 618 messages in 14.035 seconds / 44.032 msg/s
262144 312  All threads finished: 305 messages in 17.342 seconds / 17.587 msg/s

The above point between 16 and 32 is exactly where the total working set
doesn't fit into cache anymore -- I suspect that pushes the producer's
latency to go to sleep over the edge and everything collapses.


We use wakeup patterns to determine if two tasks are working together
and should thus be kept together.

Task A should wake up B, and B should wake up A. Furthermore, any task
should quickly go to sleep after waking up the other.

This program does neither, with a single pair, the producer continues
production after waking the consumer (until the queue is filled --
which, if the consumer is fast enough, might never happen).

With multiple pairs there is no strict pair relation at all, since they
all work on the same global buffer queue, so P1 can wake Cn etc.

Furthermore the program uses shared memory (not a bad design), and thus
mises out on the explicit affinity hints of pipes, sockets, etc.


In short this program is carefully crafted to defeat all our affinity
tests - and I'm not sure what to do.


