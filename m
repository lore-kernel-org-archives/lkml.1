Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZG1JA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZG1JA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZG1JA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:00:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:6315 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZG1JA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:00:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,282,1246863600"; 
   d="scan'208";a="433940876"
Subject: Re: Dynamic configure max_cstate
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
	 <1248748935.2560.669.camel@ymzhang>
	 <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Jul 2009 17:00:35 +0800
Message-Id: <1248771635.2560.682.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 09:20 +0200, Corrado Zoccolo wrote:
> Hi,
> On Tue, Jul 28, 2009 at 4:42 AM, Zhang,
> Yanmin<yanmin_zhang@linux.intel.com> wrote:
> > On Mon, 2009-07-27 at 09:33 +0200, Andreas Mohr wrote:
> >> Hi,
> >>
> >> > When running a fio workload, I found sometimes cpu C state has
> >> > big impact on the result. Mostly, fio is a disk I/O workload
> >> > which doesn't spend much time with cpu, so cpu switch to C2/C3
> >> > freqently and the latency is big.
> >>
> >> Rather than inventing ways to limit ACPI Cx state usefulness, we should
> >> perhaps be thinking of what's wrong here.
> > Andreas,
> >
> > Thanks for your kind comments.
> >
> >>
> >> And your complaint might just fit into a thought I had recently:
> >> are we actually taking ACPI Cx exit latency into account, for timers???
> > I tried both tickless kernel and non-tickless kernels. The result is similiar.
> >
> > Originally, I also thought it's related to timer. As you know, I/O block layer
> > has many timers. Such timers don't expire normally. For example, an I/O request
> > is submitted to driver and driver delievers it to disk and hardware triggers
> > an interrupt after finishing I/O. Mostly, the I/O submit and interrupt, not
> > the timer, drive the I/O.
> >
> >>
> >> If we program a timer to fire at some point, then it is quite imaginable
> >> that any ACPI Cx exit latency due to the CPU being idle at that moment
> >> could add to actual timer trigger time significantly.
> >>
> >> To combat this, one would need to tweak the timer expiration time
> >> to include the exit latency. But of course once the CPU is running
> >> again, one would need to re-add the latency amount (read: reprogram the
> >> timer hardware, ugh...) to prevent the timer from firing too early.
> >>
> >> Given that one would need to reprogram timer hardware quite often,
> >> I don't know whether taking Cx exit latency into account is feasible.
> >> OTOH analysis of the single next timer value and actual hardware reprogramming
> >> would have to be done only once (in ACPI sleep and wake paths each),
> >> thus it might just turn out to be very beneficial after all
> >> (minus prolonging ACPI Cx path activity and thus aggravating CPU power
> >> savings, of course).
> >>
> >> Arjan mentioned examples of maybe 10us for C2 and 185us for C3/C4 in an
> >> article.
> >>
> >> OTOH even 185us is only 0.185ms, which, when compared to disk seek
> >> latency (around 7ms still, except for SSD), doesn't seem to be all that much.
> >> Or what kind of ballpark figure do you have for percentage of I/O
> >> deterioration?
> > I have lots of FIO sub test cases which test I/O on single disk and JBOD (a disk
> > bos which mostly has 12~13 disks) on nahelam machines. Your analysis on disk seek
> > is reasonable. I found sequential buffered read has the worst regression while rand
> > read is far better. For example, I start 12 processes per disk and every disk has 24
> > 1-G files. There are 12 disks. The sequential read fio result is about 593MB/second
> > with idle=poll, and about 375MB/s without idle=poll. Read block size is 4KB.
> >
> > Another exmaple is single fio direct seqential read (block size is 4K) on a single
> > SATA disk. The result is about 28MB/s without idle=poll and about 32.5MB with
> > idle=poll.
> >
> > How did I find C state has impact on disk I/O result? Frankly, I found a regression
> > between kernel 2.6.27 and 2.6.28. Bisect located a nonstop tsc patch, but the patch
> > is quite good. I found the patch changes the default clocksource from hpet to
> > tsc. Then, I tried all clocksources and got the best result with acpi_pm clocksource.
> > But oprofile data shows acpi_pm has more cpu utilization. clocksource jiffies has
> > worst result but least cpu utilization. As you know, fio calls gettimeofday frequently.
> > Then, I tried boot parameter processor.max_cstate and idle=poll.
> > I get the similar result with ﻿processor.max_cstate=1 like the one with idle=poll.
> >
> 
> Is it possible that the different bandwidths figures are due to
> incorrect timing, instead of C-state latencies?
I'm not sure.

> Entering a deep C state can cause strange things to timers: some of
> them, especially tsc, become unreliable.
> Maybe the patch you found that re-enables tsc is actually wrong for
> your machine, for which tsc is unreliable in deep C states.
I'm using a SDV machine, not an official product. But it's rare that cpuid
reports non-stop tsc feature while it doesn't support it.

I tried different clocksources. For exmaple, I could get a better (30%) result with
hpet. With hpet, cpu utilization is about 5~8%. Function hpet_read uses too much cpu
time. With tsc, cpu utilization is about 2~3%. I think more cpu utilization causes fewer
C state transitions.

With idle=poll, the result is about 10% better than the one of hpet. If using idle=poll,
I didn't find result difference among different clocksources.

> 
> > I also run the testing on 2 stoakley machines and don't find such issues.
> > /proc/acpi/processor/CPUXXX/power shows stoakley cpu only has C1.
> >
> >> I'm wondering whether we might have an even bigger problem with disk I/O
> >> related to this than just the raw ACPI exit latency value itself.
> > We might have. I'm still doing more testing. With Venki's tool (write/read MSR registers),
> > I collected some C state switch stat.
> >
> You can see the latencies (expressed in us) on your machine with:
> [root@localhost corrado]# cat
> /sys/devices/system/cpu/cpu0/cpuidle/state*/latency
> 0
> 0
> 1
> 133
> 
> Can you post your numbers, to see if they are unusually high?
[ymzhang@lkp-ne02 ~]$ cat /proc/acpi/processor/CPU0/power 
active state:            C0
max_cstate:              C8
maximum allowed latency: 2000000000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--] latency[003] usage[00001661] duration[00000000000000000000]
    C2:                  type[C3] promotion[--] demotion[--] latency[205] usage[00000687] duration[00000000000000732028]
    C3:                  type[C3] promotion[--] demotion[--] latency[245] usage[00011509] duration[00000000000115186065]

[ymzhang@lkp-ne02 ~]$ cat /sys/devices/system/cpu/cpu0/cpuidle/state*/latency
0
3
205
245

> 
> > Current cpuidle has a good consideration on cpu utilization, but doesn't have
> > consideration on devices. So with I/O delivery and interrupt drive model
> > with little cpu utilization, performance might be hurt if C state exit has a long
> > latency.


