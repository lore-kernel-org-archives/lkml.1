Return-Path: <linux-kernel-owner+w=401wt.eu-S1765552AbXKOTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765552AbXKOTOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbXKOTOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:14:11 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50659 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbXKOTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:14:10 -0500
Date: Thu, 15 Nov 2007 11:14:08 -0800
From: Micah Dowty <micah@vmware.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071115191408.GA4914@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 15, 2007 at 01:48:20PM -0500, Kyle Moffett wrote:
>> In general, boosting the MAINTHREAD_PRIORITY even more and increasing the 
>> WAKE_HZ should exaggerate the problem. These parameters reproduce the 
>> problem very reliably on my system:
>>
>> #define NUM_BUSY_THREADS            2
>> #define MAINTHREAD_PRIORITY       -20
>> #define MAINTHREAD_WAKE_HZ       1024
>> #define MAINTHREAD_LOAD_PERCENT     5
>> #define MAINTHREAD_LOAD_CYCLES      2
>
> Well from these statistics; if you are requesting wakeups that often then 
> it is probably *not* correct to try to move another thread to that CPU in 
> the mean-time.  Essentially the migration cost will likely far outweigh the 
> advantage of letting it run a little bit of extra time, and in addition it 
> will dump out cache from the high-priority thread.  As per the description 
> I think that an increased a priority and increased WAKE_HZ will certainly 
> cause the "problem" to occur more, simply because it reduces the time 
> between wakeups of the high-priority process and makes it less helpful to 
> migrate another process over to that CPU during the sleep periods.  This 
> will also depend on your hardware and possibly other configuration 
> parameters.

The real problem, though, is that the high priority thread only needs
a total of a few percent worth of CPU time. The behaviour which I'm
reporting as a potential bug is that this process which needs very
little CPU time is effectively getting an entire CPU to itself,
despite the fact that other CPU-bound threads could benefit from
having time on that CPU.

One could argue that a thread with a high enough priority *should* get
a CPU all to itself even if it won't use that CPU- but that isn't the
behaviour I want. If this is in fact the intended effect of having a
high-priority thread wake very frequently, I should start a different
discussion about how to solve my specific problem without the use of
elevated priorities :)

I don't have any reason to believe, though, that this behaviour was
intentional. I just finished my "git bisect" run, and I found the
first commit after which I can reproduce the problem:

c9819f4593e8d052b41a89f47140f5c5e7e30582 is first bad commit
commit c9819f4593e8d052b41a89f47140f5c5e7e30582
Author: Christoph Lameter <clameter@sgi.com>
Date:   Sun Dec 10 02:20:25 2006 -0800

    [PATCH] sched: use softirq for load balancing
    
    Call rebalance_tick (renamed to run_rebalance_domains) from a newly introduced
    softirq.
    
    We calculate the earliest time for each layer of sched domains to be rescanned
    (this is the rescan time for idle) and use the earliest of those to schedule
    the softirq via a new field "next_balance" added to struct rq.
    
    Signed-off-by: Christoph Lameter <clameter@sgi.com>
    Cc: Peter Williams <pwil3058@bigpond.net.au>
    Cc: Nick Piggin <nickpiggin@yahoo.com.au>
    Cc: Christoph Lameter <clameter@sgi.com>
    Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
    Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

:040000 040000 2b66e4b500403869cf5925367b1ddcbb63948d01 33a27ddb470473f129a78ce310cfc59a605e173b M      include
:040000 040000 939b60deffb2af2689b4aab63e21ff6c98a3b782 dd3bf32eea9556d5a099db129adc048396368adc M      kernel

> I'm not really that much of an expert in this particular area, though, so 
> it's entirely possible that one of the above-mentioned scheduler 
> head-honchos will poke holes in my argument and give a better explanation 
> or a possible patch.

Thanks! I've also CC'ed Christoph.

For reference, the exact test I used with git-bisect is attached. The
C program (priosched) starts two busy-looping threads and a
high-priority high-frequency thread which uses relatively little
CPU. The Python program repeatedly starts the C program, runs it for a
half second, and measures the resulting imbalance in CPU usage. On
kernels prior to the above commit, this reports values within about
10% of 1.0. On later kernels, it crashes within a couple iterations
due to a divide-by-zero error :)

Thanks again,
--Micah

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="test-priosched.py"

from __future__ import division
import sys, os, time

def getCpuTimes():
    cpu0 = 0
    cpu1 = 1
    for line in open("/proc/stat"):
        tokens = line.split()
        if tokens[0] == "cpu0":
            cpu0 = int(tokens[1]) + int(tokens[3])
        elif tokens[0] == "cpu1":
            cpu1 = int(tokens[1]) + int(tokens[3])
    return cpu0, cpu1

def measureCpuImbalance(workload):
    baseline = getCpuTimes()
    workload()
    final = getCpuTimes()
    return (final[0] - baseline[0]) / (final[1] - baseline[1])

def myWorkload():
    pid = os.spawnl(os.P_NOWAIT, "./priosched")
    time.sleep(0.5)
    os.kill(pid, 9)
    os.wait()

while True:
    print "%.04f" % measureCpuImbalance(myWorkload)


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="priosched.c"

/*
 * This is a demonstration of unwanted SMP scheduler side-effects
 * caused by high-priority threads.
 *
 * In this demo, we have three threads:
 *
 *   1. A busy-loop (CPU bound) at nice level 0.
 *
 *   2. Another busy-loop at nice level 0.
 *
 *   3. A high-priority thread (nice -10) which spends
 *      most of its time sleeping, but it wakes up
 *      frequently and spends a little bit of CPU each time.
 *
 * This is meant to model three of our threads in the vmware-vmx: a
 * VCPU thread, the MKS thread, and the main VMX thread. Ideally, the
 * VCPU and MKS would spend most of their time running on separate
 * CPUs on an SMP system. The VMX thread would wake up frequently,
 * interrupt an arbitrary cpu-bound thread, then go back to sleep.
 *
 * The actual behaviour I see on Linux 2.6 is that the system
 * oscillates between two states, with a period of a few seconds. In
 * the "good" state, the two busy-loop threads run on separate CPU. In
 * the "bad" state, both of the busy-loop threads run on the same
 * physical CPU and the other CPU sits idle.
 *
 * Taking a closer look at the kernel's scheduler debug output
 * (/proc/sched_debug and /proc/schedstat) the problem becomes
 * clearer: Even though the VMX thread spends very little time
 * running, its runtime is given extra weight according to its
 * priority. The "load" calculated by the scheduler for its CPU is
 * low, but the load average calculated via delta_exec and delta_fair
 * can become quite high. The result is that the physical CPU where
 * the VMX was running gets stuck with a high load average even after
 * the VMX thread is sleeping again. This high load average causes all
 * running tasks to be rebalanced onto the other CPU until the high
 * load subsides.
 *
 * This example requires a machine with exactly 2 CPUs.
 *
 * Usage:
 *   cc -o priosched priosched.c -lpthread
 *   sudo ./priosched
 *
 * Now observe the load on both CPUs. In the "good" state, both CPUs
 * will be busy. In the "bad" state, both of the busyThreads will be
 * stuck on the same CPU and the other CPU will be idle. 
 *
 * If you have a kernel with scheduler debugging compiled in, try "cat
 * /proc/sched_debug". In the "bad" state, one CPU will have an empty
 * runnable task list and a list of cpu_load[] averages around 9000.
 *
 * -- Micah Dowty <micah@vmware.com>
 */

#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <linux/ioctl.h>
#include <linux/rtc.h>
#include <time.h>

/*
 * Knobs.
 * You may have to tweak these to reproduce the problem on your machine.
 */
#define NUM_BUSY_THREADS          2
#define MAINTHREAD_PRIORITY     -19   // Nice level
#define MAINTHREAD_WAKE_HZ     1024   // Frequency to wake up at
#define MAINTHREAD_LOAD_PERCENT  20   // Percent of time to wake up and generate load
#define MAINTHREAD_LOAD_CYCLES    1   // Consecutive clock ticks to generate load for

void  *busyThreadFunc(void *arg)
{
   while (1);
}

int main()
{
   pthread_t busyThreads[NUM_BUSY_THREADS];
   int i, rtc;

   for (i = 0; i < NUM_BUSY_THREADS; i++) {
      if (pthread_create(&busyThreads[i], NULL, busyThreadFunc, NULL)) {
         perror("pthread_create");
         return 1;
      }
   }

   if (nice(MAINTHREAD_PRIORITY) == -1) {
      fprintf(stderr, "This program must be run as root.\n");
      return 1;
   }

   rtc = open("/dev/rtc", O_RDONLY);
   if (rtc == -1) {
      perror("/dev/rtc");
      return 1;
   }

   if (ioctl(rtc, RTC_IRQP_SET, MAINTHREAD_WAKE_HZ) ||
       ioctl(rtc, RTC_PIE_ON, 0)) {
      perror("ioctl");
      return 1;
   }

   while (1) {
      unsigned long data;
      if (read(rtc, &data, sizeof data) != sizeof data) {
         perror("read");
         return 1;
      }

      if (random() % 100 <= MAINTHREAD_LOAD_PERCENT) {
         for (i = 0; i < MAINTHREAD_LOAD_CYCLES; i++) {
            fcntl(rtc, F_SETFL, O_NONBLOCK);
            while (read(rtc, &data, sizeof data) < 0);
            fcntl(rtc, F_SETFL, 0);
         }
      }
   }

   return 0;
}

--ReaqsoxgOBHFXBhH--
