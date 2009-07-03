Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZGCM6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZGCM6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZGCM61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:58:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZGCM60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:58:26 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: cpufreq@vger.kernel.org
Subject: [Announce] cpufreq-bench
Date: Fri, 3 Jul 2009 14:58:27 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, ckornacker@suse.de,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031458.27908.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh dear, again with the correct lkml list address in CC, please
do not answer on the previous mail...

Hi,

inspired by Rafaels talk about covering kernel code for regression
testing and the need to be able to debug tunables in the ondemand
governor, Christian produced this IMO excellent micro code benchmark.

What is this benchmark for:
  - Identify worst case performance loss when doing dynamic frequency
    scaling using Linux kernel governors
  - Identify average reaction time of a governor to CPU load changes
  - (Stress) Testing whether a cpufreq low level driver or governor works
    as expected
  - Identify cpufreq related performance regressions between kernels
  - Possibly Real time priority testing? -> what happens if there are
    processes with a higher prio than the governor's kernel thread
  - ...

What this benchmark does *not* cover:
  - Power saving related regressions (In fact as better the performance
    throughput is, the worse the power savings will be, but the first should
    mostly count more...)
  - Real world (workloads)

How it works:
You can specify load (100% CPU load) and sleep (0% CPU load) times in us which
will be run X time in a row (cycles):

         sleep=25000
         load=25000
         cycles=20

This part of the configuration file will create 25ms load/sleep turns, 
repeated 20 times.

Adding this:
         sleep_step=25000
         load_step=25000
         rounds=5
Will increase load and sleep time by 25ms 5 times.
Together you get following test:
25ms  load/sleep time repeated 20 times (cycles).
50ms  load/sleep time repeated 20 times (cycles).
..
100ms load/sleep time repeated 20 times (cycles).

First it is calibrated how long a specific CPU intensive calculation
takes on this machine and needs to be run in a loop using the performance 
governor.
Then the above test runs are processed using the performance governor
and the governor to test. The time the calculation really needed
with the dynamic freq scaling governor is compared with the time needed
on full performance and you get the overall performance loss.


Example of expected results with ondemand governor:

This shows expected results of the first two test run rounds from
above config, you there have:

100% CPU load (load) | 0 % CPU load (sleep)  | round
   25 ms             |    25 ms              |   1
   50 ms             |    50 ms              |   2

For example if ondemand governor is configured to have a 50ms
sampling rate you get:

In round 1, ondemand should have rather static 50% load and probably
won't ever switch up (as long as up_threshold is above).

In round 2, if the ondemand sampling times exactly match the load/sleep 
trigger of the cpufreq-bench, you will see no performance loss (compare with 
below possible ondemand sample kick ins (1)):

But if ondemand always kicks in in the middle of the load sleep cycles, it 
will always see 50% loads and you get worst performance impact never 
switching up (compare with below possible ondemand sample kick ins (2))::

      50     50   50   50ms ->time
load -----|     |-----|     |-----|     |-----|    
          |     |     |     |     |     |     |    
sleep     |-----|     |-----|     |-----|     |----
    |-----|-----|-----|-----|-----|-----|-----|----  ondemand sampling (1)
         100    0    100    0    100    0    100     load seen by ondemand(%)
       |-----|-----|-----|-----|-----|-----|-----|--   ondemand sampling (2)
      50     50    50    50    50    50    50        load seen by ondemand(%)

You can easily test all kind of load/sleep times and check whether your
governor in average behaves as expected.

The tool is available here:
ftp.suse.com/pub/people/ckornacker/cpufreq-bench

If you script a bit with gnuplot you can draw some nice graphs like
that one showing the performance impact with different ondemand sampling rate
tuning parameters:
ftp.suse.com/pub/people/trenn/benchmark_samplingrate_optimized.png
Hmm, let me quickly comment on the picture:
The us axis better had been ms. It shows the load/sleep cycles time of each 
test run, starting with 50ms (50000us) load/sleep cycles and increasing
in 50ms steps.
The different sampling lines are the modified sampling_rate of the ondemand
governor, 40ms, 80ms, 100ms and 500ms ondemand sampling rates are 
tested/compared.

Comments?
Could/should this be integrated into some already existing cpufreq related
project (cpufreq-utils)?
Can the Linux Testing Project profit by that one?

Thanks,
    Thomas
