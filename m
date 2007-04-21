Return-Path: <linux-kernel-owner+w=401wt.eu-S1030768AbXDUMNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030768AbXDUMNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXDUMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:13:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2076 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030768AbXDUMNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:13:30 -0400
Date: Sat, 21 Apr 2007 14:12:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421121235.GA2044@1wt.eu>
References: <20070420140457.GA14017@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420140457.GA14017@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Hi Con,

I promised to perform some tests on your code. I'm short in time right now,
but I observed behaviours that should be commented on.

1) machine : dual athlon 1533 MHz, 1G RAM, kernel 2.6.21-rc7 + either scheduler
   Test:  ./ocbench -R 250000 -S 750000 -x 8 -y 8
   ocbench: http://linux.1wt.eu/sched/

2) SD-0.44

   Feels good, but becomes jerky at moderately high loads. I've started
   64 ocbench with a 250 ms busy loop and 750 ms sleep time. The system
   always responds correctly but under X, mouse jumps quite a bit and
   typing in xterm or even text console feels slightly jerky. The CPU is
   not completely used, and the load varies a lot (see below). However,
   the load is shared equally between all 64 ocbench, and they do not
   deviate even after 4000 iterations. X uses less than 1% CPU during
   those tests.

   Here's the vmstat output :

willy@pcw:~$ vmstat 1
   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
 0  0  0      0 919856   6648  57788    0    0    22     2    4   148 31 49 20
 0  0  0      0 919856   6648  57788    0    0     0     0    2   285 32 50 19
28  0  0      0 919836   6648  57788    0    0     0     0    0   331 24 40 36
64  0  0      0 919836   6648  57788    0    0     0     0    1   618 23 40 37
65  0  0      0 919836   6648  57788    0    0     0     0    0   571 21 36 43
35  0  0      0 919836   6648  57788    0    0     0     0    3   382 32 50 18
 2  0  0      0 919836   6648  57788    0    0     0     0    0   308 37 61  2
 8  0  0      0 919836   6648  57788    0    0     0     0    1   533 36 65  0
32  0  0      0 919768   6648  57788    0    0     0     0   93   706 33 62  5
62  0  0      0 919712   6648  57788    0    0     0     0   65   617 32 54 13
63  0  0      0 919712   6648  57788    0    0     0     0    1   569 28 48 23
40  0  0      0 919712   6648  57788    0    0     0     0    0   427 26 50 24
 4  0  0      0 919712   6648  57788    0    0     0     0    1   382 29 48 23
 4  0  0      0 919712   6648  57788    0    0     0     0    0   383 34 65  0
14  0  0      0 919712   6648  57788    0    0     0     0    1   769 39 61  0
40  0  0      0 919712   6648  57788    0    0     0     0    0   384 37 52 11
54  0  0      0 919712   6648  57788    0    0     0     0    1   715 31 60  8
58  0  2      0 919712   6648  57788    0    0     0     0    1   611 34 65  0
41  0  0      0 919712   6648  57788    0    0     0     0   19   395 28 45 27
 0  0  0      0 919712   6648  57788    0    0     0     0   31   421 23 32 45
 0  0  0      0 919712   6648  57788    0    0     0     0   31   328 34 44 22
29  0  0      0 919712   6648  57788    0    0     0     0   34   369 32 43 25
65  0  0      0 919712   6648  57788    0    0     0     0   31   410 24 35 40
47  0  1      0 919712   6648  57788    0    0     0     0   42   538 25 39 35

3) CFS-v4

  Feels even better, mouse movements are very smooth even under high load.
  I noticed that X gets reniced to -19 with this scheduler. I've not looked
  at the code yet but this looked suspicious to me. I've reniced it to 0 and
  it did not change any behaviour. Still very good. The 64 ocbench share
  equal CPU time and show exact same progress after 2000 iterations. The CPU
  load is more smoothly spread according to vmstat, and there's no idle (see
  below). BUT I now think it was wrong to let new processes start with no
  timeslice at all, because it can take tens of seconds to start a new process
  when only 64 ocbench are there. Simply starting "killall ocbench" takes about
  10 seconds. On a smaller machine (VIA C3-533), it took me more than one
  minute to do "su -", even from console, so that's not X. BTW, X uses less
  than 1% CPU during those tests.

willy@pcw:~$ vmstat 1
   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
12  0  2      0 922120   6532  57540    0    0   299    29   31   386 17 27 57
12  0  2      0 922096   6532  57556    0    0     0     0    1   776 37 63  0
14  0  2      0 922096   6532  57556    0    0     0     0    1   782 35 65  0
13  0  1      0 922096   6532  57556    0    0     0     0    0   782 38 62  0
14  0  1      0 922096   6532  57556    0    0     0     0    1   782 36 64  0
13  0  1      0 922096   6532  57556    0    0     0     0    2   785 38 62  0
13  0  1      0 922096   6532  57556    0    0     0     0    1   774 35 65  0
14  0  1      0 922096   6532  57556    0    0     0     0    0   784 36 64  0
13  0  1      0 922096   6532  57556    0    0     0     0    1   767 37 63  0
13  0  1      0 922096   6532  57556    0    0     0     0    1   785 41 59  0
14  0  1      0 922096   6532  57556    0    0     0     0    0   779 38 62  0
19  0  1      0 922096   6532  57556    0    0     0     0    1   816 38 62  0
22  0  1      0 922096   6532  57556    0    0     0     0    0   817 35 65  0
19  0  1      0 922096   6532  57556    0    0     0     0    1   817 39 61  0
21  0  1      0 922096   6532  57556    0    0     0     0    0   849 36 64  0
20  0  0      0 922096   6532  57556    0    0     0     0    1   793 36 64  0
21  0  0      0 922096   6532  57556    0    0     0     0    0   815 37 63  0
19  0  0      0 922096   6532  57556    0    0     0     0    1   824 35 65  0
21  0  0      0 922096   6532  57556    0    0     0     0    0   817 35 65  0
26  0  0      0 922096   6532  57556    0    0     0     0    1   824 38 62  0
26  0  0      0 922096   6532  57556    0    0     0     0    1   817 35 65  0
26  0  0      0 922096   6532  57556    0    0     0     0    0   811 37 63  0
26  0  0      0 922096   6532  57556    0    0     0     0    1   804 34 66  0
16  0  0      0 922096   6532  57556    0    0     0     0   39   850 35 65  0
18  0  0      0 922096   6532  57556    0    0     0     0    1   801 39 61  0


4) first impressions

I think that CFS is based on a more promising concept but is less mature
and is dangerous right now with certain workloads. SD shows some strange
behaviours like not using all CPU available and a little jerkyness, but is
more robust and may be the less risky solution for a first step towards
a better scheduler in mainline, but it may also probably be the last O(1)
scheduler, which may be replaced sometime later when CFS (or any other one)
shows at the same time the smoothness of CFS and the robustness of SD.

I'm sorry not to spend more time on them right now, I hope that other people
will do.

Regards,
Willy

