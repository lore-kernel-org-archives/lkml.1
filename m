Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXKIWe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXKIWe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXKIWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:34:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39821 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXKIWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:34:19 -0500
Date: Fri, 9 Nov 2007 14:34:17 -0800
From: Micah Dowty <micah@vmware.com>
To: linux-kernel@vger.kernel.org
Subject: High priority tasks break SMP balancer?
Message-ID: <20071109223417.GB16250@vmware.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've been investigating a problem recently, in which N runnable
CPU-bound tasks on an N-way machine run on only N-1 CPUs. The
remaining CPU is almost 100% idle. I have seen it occur with both the
CFS and O(1) schedulers.

I've traced this down to what seems to be a quirk in the SMP balancer,
whereby a high-priority thread which spends most of its time sleeping
can artificially inflate the CPU load average calculated for one
processor. Most of the time this CPU is idle (nr_running==0) yet its
CPU load average is much higher than that of any other CPU.

Please find attached a sample program which demonstrates this
behaviour on a 2-way SMP machine. It creates three threads: two are
CPU bound and run at the default priority, the third spends most of
its time sleeping and runs at an elevated priority. It wakes up
frequently (using /dev/rtc) and randomly generates some CPU load.

On my machine (2-way Opteron with a vanilla 2.6.23.1 kernel) this test
program will reliably put the scheduler into a state where one CPU has
both of the busy-looping processes in its runqueue, and the other CPU
is usually idle. The usually-idle CPU will have a very high cpu_load,
as reported by /proc/sched_debug.

Your mileage may vary. On some machines, this test program will only
enter the "bad" state for a few seconds. Sometimes we bounce back and
forth between good and bad states every few seconds. In all cases,
removing the priority elevation fixes the balancing problem.

Is this a behaviour any of the scheduler developers are aware of? I
would be very greatful if anyone could shed some light on the root
cause behind the inflated cpu_load average. If this turns out to be a
real bug, I would be happy to work on a patch.

Thanks in advance,
Micah Dowty

--bg08WKrSYDhXBjb5
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
#define MAINTHREAD_PRIORITY     -15   // Nice level
#define MAINTHREAD_WAKE_HZ      256   // Frequency to wake up at
#define MAINTHREAD_LOAD_PERCENT   5   // Percent of time to wake up and generate load
#define MAINTHREAD_LOAD_CYCLES   10   // Consecutive clock ticks to generate load for

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

--bg08WKrSYDhXBjb5--
