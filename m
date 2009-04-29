Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbZD2FD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbZD2FD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZD2FDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:03:47 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57291 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZD2FDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:03:46 -0400
Message-ID: <49F7DF44.8090907@cosmosbay.com>
Date: Wed, 29 Apr 2009 07:01:56 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrew Gallatin <gallatin@myri.com>, linux-kernel@vger.kernel.org,
       rick.jones2@hp.com, brice@myri.com, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: IRQ / SoftIRQ CPU time accounting broken by 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
References: <49F078FA.6010507@myri.com> <20090428163004.46733752.akpm@linux-foundation.org>
In-Reply-To: <20090428163004.46733752.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 29 Apr 2009 07:01:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> (cc's added)
> 
> On Thu, 23 Apr 2009 10:19:38 -0400
> Andrew Gallatin <gallatin@myri.com> wrote:
> 
>> When running netperf for some 10GbE tests, I noticed
>> that  IRQ and SOFTIRQ CPU time is no longer reported for an
>> otherwise idle CPU on recent kernels, at least for x86_64.
>>
>> If I take a 2-CPU system, and bind the NIC IRQ to CPU0, and
>> bind the user-space netserver daemon to CPU1, the problem
>> is obvious when blasting 10Gb/s of traffic at it.  I see
>> no CPU used for irq or softirq on CPU0, even though it is
>> handling 13K interrupts/sec:
>>
>>
>>
>> % mpstat -P 0 1
>> Linux 2.6.30-rc1 (venice)       04/22/09
>>
>> 11:25:25     CPU   %user   %nice %system %iowait    %irq   %soft   %idle 
>>     intr/s
>> 11:25:26       0    0.00    0.00    0.00    0.00    0.00    0.00  100.00 
>>   13248.00
>> 11:25:27       0    0.00    0.00    0.00    0.00    0.00    0.00  100.00 
>>   13280.00
>>
>> Common sense tells me that is wrong, and oprofile verifies there is
>> a lot happening on CPU0.  Further, when I run a cpu-soaker in
>> usermode bound to CPU0, I start to see irq, softirq, etc,
>> being correctly identified:
>>
>> 11:28:02     CPU   %user   %nice %system %iowait    %irq   %soft   %idle 
>>     intr/s
>> 11:28:03       0   45.10    0.00    0.00    0.00    1.96   52.94    0.00 
>>   13019.61
>> 11:28:04       0   46.46    0.00    0.00    0.00    2.02   51.52    0.00 
>>   13414.14
>>
>> The problem is observable, but much less obvious when using a more
>> common, e1000 1GbE NIC (15% softirq is missing, rather than 50%).
>>
>> I spent a few hours git-bisecting until I finally got here:
>>
>> % git-bisect bad
>> Bisecting: 0 revisions left to test after this
>> [457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4] fix scaled & unscaled cputime 
>> accounting
>>
>> I have neither CONFIG_NO_HZ, CONFIG_VIRT_CPU_ACCOUNTING, or XEN configured.
>>
> 
> Thanks for doing the bisection.
> 
> 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4 was merged late last year, so
> this regression has been around for a while.
> 
> We might have fixed it in more recent kernels - stranger things have
> happened ;)
> 

Same problem here on 32 bit current git kernel, 8 cpus machine.
Easily reproductible with a ping flood, NIC interrupts bonded to CPU0
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 396260 474568 2881560    0    0     0     4 43642 2859  0  0 100  0
 0  0      0 396260 474568 2881560    0    0     0     0 55802 2840  0  0 100  0
 0  0      0 396260 474576 2881560    0    0     0     4 51239 2861  0  0 100  0
 0  0      0 396260 474576 2881560    0    0     0     0 47848 2847  0  0 100  0
 0  0      0 396260 474576 2881560    0    0     0     4 54245 2841  0  0 100  0
 0  0      0 396260 474576 2881560    0    0     0     0 46500 2851  0  0 100  0
 0  0      0 396260 474576 2881560    0    0     0     4 48035 2839  0  0 100  0
 0  0      0 396136 474580 2881560    0    0     0     0 41994 2855  0  0 100  0
 0  0      0 396136 474580 2881560    0    0     0     4 46701 2842  0  0 100  0

If load is large enough to trigger ksoftirqd, then softirq time is correctly reported.

Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,100.0%si,  0.0%st

CONFIG_GENERIC_TIME=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_KTIME_SCALAR=y
CONFIG_TIMERFD=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_HPET_TIMER=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_X86_PM_TIMER=y
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_PRINTK_TIME=y
CONFIG_TIMER_STATS=y


ping flood received on eth0 / eth1 interfaces (PCI-MSI-edge IRQS)

$ cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7
  0:        343          0          0          0          0          0          0          0   IO-APIC-edge      timer
  1:          1          0          1          0          0          0          0          0   IO-APIC-edge      i8042
  9:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          1          1          1          1          1   IO-APIC-edge      i8042
 14:          0          0          0          0          0          0          0          0   IO-APIC-edge      ide0
 15:          0          0          0          0          0          0          0          0   IO-APIC-edge      ide1
 16:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb1
 17:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 18:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 22:         12         10         13          9         14         14         14          8   IO-APIC-fasteoi   uhci_hcd:usb5
 33:     109191     165558     162520     156506     160469     161549     162655     161780   PCI-MSI-edge      cciss0
 34:   91628623          0          0          0          0          0          0          0   PCI-MSI-edge      eth1
 36:   18517783          0          0          0          0          0          0          0   PCI-MSI-edge      eth0
NMI:  227238100  165960221  154895362  165425712  111786333  116776935  114633666  111315114   Non-maskable interrupts
LOC:   88434578   80673549   73277767   78134420   77183920   71046805   68905716   70869751   Local timer interrupts
SPU:          0          0          0          0          0          0          0          0   Spurious interrupts
RES:      16425     216454      73793     347021     125963      30655      47623      31300   Rescheduling interrupts
CAL:      13164      13182      13184      13175        100      13169      13151      13163   Function call interrupts
TLB:      45488      52740      50498      53806      57548      54933      58091      56249   TLB shootdowns
TRM:          0          0          0          0          0          0          0          0   Thermal event interrupts



commit 79741dd35713ff4f6fd0eafd59fa94e8a4ba922d did :

void account_process_tick(struct task_struct *p, int user_tick)
{
       cputime_t one_jiffy = jiffies_to_cputime(1);
       cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
       struct rq *rq = this_rq();

       if (user_tick)
               account_user_time(p, one_jiffy, one_jiffy_scaled);
       else if (p != rq->idle)
               account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
                                   one_jiffy_scaled);
       else
               account_idle_time(one_jiffy);
}

So, if IRQs are interrupting idle task, I guess if (p != rq->idle) will be false.

