Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYIOOOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYIOOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 10:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYIOOOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 10:14:40 -0400
Received: from services110.cs.uwaterloo.ca ([129.97.152.166]:59024 "EHLO
	services110.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbYIOOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 10:14:39 -0400
Message-ID: <48CE6E2E.4090106@users.sourceforge.net>
Date: Mon, 15 Sep 2008 10:16:14 -0400
From: Elad Lahav <elad_lahav@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Soft IRQ statistics under /proc/stat
References: <48C9C7FD.3060609@users.sourceforge.net>
In-Reply-To: <48C9C7FD.3060609@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Miltered: at mailchk-m01 with ID 48CE6DCC.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 6cd1fbb1-5092-4d90-a4d1-3d542408def6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been observing some oddities in the statistics produced by mpstat 
> with respect to soft IRQs (for example, considerable soft IRQ time on 
> processors sending UDP packets on dummy NICs).

Here's some data to support my claims.
The first experiment consists of sending UDP packets on a dummy network interface. No 
interrupts are generated, so there should be no soft IRQs. Nevertheless, /proc/stat shows 
that a considerable share of CPU time is taken by soft IRQs:

CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
   0    4.52    0.00   67.84    0.00    0.00   27.64    0.00    0.00    0.00
   0    4.00    0.00   70.00    0.00    0.00   26.00    0.00    0.00    0.00
   0    4.98    0.00   68.16    0.00    0.00   26.87    0.00    0.00    0.00
   0    4.02    0.00   69.85    0.00    0.00   26.13    0.00    0.00    0.00

In a second experiment, UDP packets are sent over a real NIC by a process pinned to CPU 0, 
while the respective network interrupts are pinned to CPU 2. Here, you can see that CPU 0 
is executing soft IRQs, despite the interrupt affinity:

CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
   0    4.02    0.00   63.82    0.00    0.00   32.16    0.00    0.00    0.00
   2    0.00    0.00    0.00    0.00    6.47   40.30    0.00    0.00   53.23
   0    2.48    0.00   67.33    0.00    0.00   30.20    0.00    0.00    0.00
   2    0.00    0.00    0.00    0.00    6.47   41.79    0.00    0.00   51.74

I have verified, from /proc/interrupts, that in both cases the number of interrupts per 
second on CPU 0 is negligible.

Next, I modified the kernel code to raise a per-CPU flag at the beginning of 
__do_softirq(), and clear it at the end. Using this flag, account_system_time() can 
differentiate between a "true" soft IRQ, and code running under local_bh_disable(). The 
results of the first experiment (dummy NIC) are as follows:

CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal  %guest %bh_dis   %idle
   0    4.50    0.00   71.00    0.00    0.00    0.00    0.00    0.00   24.50    0.00
   0    4.00    0.00   67.00    0.00    0.00    0.00    0.00    0.00   29.00    0.00
   0    3.98    0.00   69.15    0.00    0.00    0.00    0.00    0.00   26.87    0.00
   0    3.50    0.00   69.00    0.00    0.00    0.00    0.00    0.00   27.50    0.00

where bh_dis refers to code executing with softirq_count() greater than 0, but with the 
soft IRQ flag cleared. The results for the second experiment (real NIC):

CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal  %guest %bh_dis   %idle
   0    3.00    0.00   67.50    0.00    0.00    0.00    0.00    0.00   29.50    0.00
   2    0.00    0.00    0.00    0.00    3.48   40.30    0.00    0.00    0.00   56.22
   0    1.99    0.00   66.67    0.00    0.00    0.00    0.00    0.00   31.34    0.00
   2    0.00    0.00    0.00    0.49    3.45   39.41    0.00    0.00    0.00   56.65

These results make much more sense.

Elad

P.S.,

For reference, here's the patch I applied to the kernel in order to differentiate between 
"true" and "false" soft IRQs (I am not suggesting it as a permanent patch, it's just for 
testing and verification purposes):

diff -u -r --exclude='*.o' --exclude='*.cmd' linux-2.6.26.5/fs/proc/proc_misc.c 
linux-2.6.26.5-bh/fs/proc/proc_misc.c
--- linux-2.6.26.5/fs/proc/proc_misc.c  2008-09-08 13:40:20.000000000 -0400
+++ linux-2.6.26.5-bh/fs/proc/proc_misc.c       2008-09-11 19:39:52.000000000 -0400
@@ -478,6 +478,7 @@
         unsigned long jif;
         cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
         cputime64_t guest;
+       cputime64_t bh_disabled;
         u64 sum = 0;
         struct timespec boottime;
         unsigned int *per_irq_sum;
@@ -489,6 +490,7 @@
         user = nice = system = idle = iowait =
                 irq = softirq = steal = cputime64_zero;
         guest = cputime64_zero;
+       bh_disabled = cputime64_zero;
         getboottime(&boottime);
         jif = boottime.tv_sec;

@@ -504,6 +506,8 @@
                 softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
                 steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
                 guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+               bh_disabled = cputime64_add(bh_disabled,
+                                           kstat_cpu(i).cpustat.bh_disabled);
                 for (j = 0; j < NR_IRQS; j++) {
                         unsigned int temp = kstat_cpu(i).irqs[j];
                         sum += temp;
@@ -511,7 +515,7 @@
                 }
         }

-       seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+       seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
                 (unsigned long long)cputime64_to_clock_t(user),
                 (unsigned long long)cputime64_to_clock_t(nice),
                 (unsigned long long)cputime64_to_clock_t(system),
@@ -520,7 +524,8 @@
                 (unsigned long long)cputime64_to_clock_t(irq),
                 (unsigned long long)cputime64_to_clock_t(softirq),
                 (unsigned long long)cputime64_to_clock_t(steal),
-               (unsigned long long)cputime64_to_clock_t(guest));
+               (unsigned long long)cputime64_to_clock_t(guest),
+               (unsigned long long)cputime64_to_clock_t(bh_disabled));
         for_each_online_cpu(i) {

                 /* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -533,8 +538,9 @@
                 softirq = kstat_cpu(i).cpustat.softirq;
                 steal = kstat_cpu(i).cpustat.steal;
                 guest = kstat_cpu(i).cpustat.guest;
+               bh_disabled = kstat_cpu(i).cpustat.bh_disabled;
                 seq_printf(p,
-                       "cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+                       "cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
                         i,
                         (unsigned long long)cputime64_to_clock_t(user),
                         (unsigned long long)cputime64_to_clock_t(nice),
@@ -544,7 +550,8 @@
                         (unsigned long long)cputime64_to_clock_t(irq),
                         (unsigned long long)cputime64_to_clock_t(softirq),
                         (unsigned long long)cputime64_to_clock_t(steal),
-                       (unsigned long long)cputime64_to_clock_t(guest));
+                       (unsigned long long)cputime64_to_clock_t(guest),
+                       (unsigned long long)cputime64_to_clock_t(bh_disabled));
         }
         seq_printf(p, "intr %llu", (unsigned long long)sum);

diff -u -r --exclude='*.o' --exclude='*.cmd' linux-2.6.26.5/include/linux/kernel_stat.h 
linux-2.6.26.5-bh/include/linux/kernel_stat.h
--- linux-2.6.26.5/include/linux/kernel_stat.h  2008-09-08 13:40:20.000000000 -0400
+++ linux-2.6.26.5-bh/include/linux/kernel_stat.h       2008-09-11 19:32:00.000000000 -0400
@@ -24,6 +24,7 @@
         cputime64_t iowait;
         cputime64_t steal;
         cputime64_t guest;
+       cputime64_t bh_disabled;
  };

  struct kernel_stat {
@@ -32,6 +33,7 @@
  };

  DECLARE_PER_CPU(struct kernel_stat, kstat);
+DECLARE_PER_CPU(int, in_softirq);

  #define kstat_cpu(cpu) per_cpu(kstat, cpu)
  /* Must have preemption disabled for this to be meaningful. */
diff -u -r --exclude='*.o' --exclude='*.cmd' linux-2.6.26.5/kernel/sched.c 
linux-2.6.26.5-bh/kernel/sched.c
--- linux-2.6.26.5/kernel/sched.c       2008-09-08 13:40:20.000000000 -0400
+++ linux-2.6.26.5-bh/kernel/sched.c    2008-09-11 20:56:31.000000000 -0400
@@ -3950,8 +3950,12 @@
         tmp = cputime_to_cputime64(cputime);
         if (hardirq_count() - hardirq_offset)
                 cpustat->irq = cputime64_add(cpustat->irq, tmp);
-       else if (softirq_count())
-               cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+       else if (softirq_count()) {
+               if (__get_cpu_var(in_softirq))
+                       cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+               else
+                       cpustat->bh_disabled = cputime64_add(cpustat->bh_disabled, tmp);
+       }
         else if (p != rq->idle)
                 cpustat->system = cputime64_add(cpustat->system, tmp);
         else if (atomic_read(&rq->nr_iowait) > 0)
diff -u -r --exclude='*.o' --exclude='*.cmd' linux-2.6.26.5/kernel/softirq.c 
linux-2.6.26.5-bh/kernel/softirq.c
--- linux-2.6.26.5/kernel/softirq.c     2008-09-08 13:40:20.000000000 -0400
+++ linux-2.6.26.5-bh/kernel/softirq.c  2008-09-11 19:34:33.000000000 -0400
@@ -49,6 +49,7 @@
  static struct softirq_action softirq_vec[32] __cacheline_aligned_in_smp;

  static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(int, in_softirq);

  /*
   * we cannot loop indefinitely here to avoid userspace starvation,
@@ -214,6 +215,8 @@
         int max_restart = MAX_SOFTIRQ_RESTART;
         int cpu;

+       __get_cpu_var(in_softirq) = 1;
+
         pending = local_softirq_pending();
         account_system_vtime(current);

@@ -251,6 +254,8 @@

         account_system_vtime(current);
         _local_bh_enable();
+
+       __get_cpu_var(in_softirq) = 0;
  }

  #ifndef __ARCH_HAS_DO_SOFTIRQ
