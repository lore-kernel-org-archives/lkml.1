Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXGYOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXGYOFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXGYOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:05:44 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53806 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbXGYOFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:05:43 -0400
Message-ID: <46A758B5.9070602@free.fr>
Date: Wed, 25 Jul 2007 16:05:41 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr> <20070723160442.GA7995@elte.hu> <46A5B8E3.4060004@free.fr> <46A74A58.1070704@free.fr> <20070725130536.GA12334@elte.hu> <46A74E05.50504@free.fr> <20070725133835.GA17616@elte.hu>
In-Reply-To: <20070725133835.GA17616@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> John Sigler wrote:
> 
>> Ingo Molnar wrote:
>> 
>>> does your test-app have higher priority than softirq--4 ?
>> 
>> PID 4 is [softirq-timer/0] and has priority 50 in SCHED_FIFO. My 
>> process has priority 80 in SCHED_RR. It is waiting for IRQ10.
>> 
>> My user-space app has higher priority than everything except PID 2 
>> which is [posix_cpu_timer]
> 
> well what priority does the IRQ 10 kernel thread have? It should be prio 
> 80 too if it's in your critical path.

Is there some form of priority inheritance? Does the IRQ handler get a 
priority boost if a high priority task is waiting for it?

I didn't dare mess with the default kernel thread priorities.

# ps -eo pid,class,rtprio,ni,pri,stat,comm
   PID CLS RTPRIO  NI PRI STAT COMMAND
     1 TS       -   0  24 Ss   init
     2 FF      99   - 139 S    posix_cpu_timer
     3 FF      50   -  90 S    softirq-high/0
     4 FF      50   -  90 S    softirq-timer/0
     5 FF      50   -  90 S    softirq-net-tx/
     6 FF      50   -  90 S    softirq-net-rx/
     7 FF      50   -  90 S    softirq-block/0
     8 FF      50   -  90 S    softirq-tasklet
     9 FF      50   -  90 S    softirq-sched/0
    10 FF      50   -  90 S    softirq-hrtimer
    11 FF      50   -  90 S    softirq-rcu/0
    12 TS       - -10  34 S<   desched/0
    13 FF       1   -  41 S<   events/0
    14 TS       -  -5  19 S<   khelper
    15 TS       -  -5  19 S<   kthread
    34 TS       -  -5  29 S<   kblockd/0
    35 TS       -  -5  19 S<   kacpid
    36 FF      50   -  90 S<   IRQ-7
    82 TS       -  -5  29 S<   kseriod
   101 TS       -   0  16 S    pdflush
   102 TS       -   0  24 S    pdflush
   103 TS       -  -5  21 S<   kswapd0
   104 TS       -  -5  29 S<   flush_filesd/0
   105 TS       -  -5  21 S<   aio/0
   704 FF      50   -  90 S<   IRQ-14
   720 FF      50   -  90 S<   IRQ-12
   721 FF      50   -  90 S<   IRQ-1
   848 FF      50   -  90 S<   IRQ-11
   913 FF      50   -  90 S<   IRQ-10
   922 TS       -   0  21 Ss   sshd
   925 TS       -   0  24 Ss+  agetty
   926 TS       -   0  21 Ss+  agetty
   931 TS       -   0  24 Rs   sshd
   933 TS       -   0  24 Rs   bash

# cat /proc/interrupts
            CPU0
   0:         37    XT-PIC-XT        timer
   1:          2    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   7:          0    XT-PIC-XT        acpi
  10:        175    XT-PIC-XT        eth2, Dta1xx
  11:       1129    XT-PIC-XT        eth0
  12:          4    XT-PIC-XT        eth1
  14:      21482    XT-PIC-XT        ide0
NMI:          0
LOC:     161632
ERR:          0
MIS:          0

IRQ 10 is shared between a NIC and an I/O board.

For eth2, the kernel said:
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC]
   -> GSI 10 (level, low) -> IRQ 10

For Dta1xx, the kernel said:
ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC]
   -> GSI 10 (level, low) -> IRQ 10

Is it possible to avoid the two boards sharing IRQ 10?

Regards.
