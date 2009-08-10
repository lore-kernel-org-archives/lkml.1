Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZHJT0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZHJT0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZHJT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:26:54 -0400
Received: from bar.sig21.net ([80.81.252.164]:54916 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZHJT0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:26:53 -0400
Date: Mon, 10 Aug 2009 21:26:58 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810192658.GA15513@sig21.net>
References: <20090807170942.GB9177@sig21.net>
 <87k51cgdt8.fsf@basil.nowhere.org>
 <20090810122731.GA5863@sig21.net>
 <20090810123228.GD6838@basil.fritz.box>
 <20090810125651.GB6082@sig21.net>
 <20090810132923.GA4418@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810132923.GA4418@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.0 (----)
X-Spam-21-Report: No, score=-4.0 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.349,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 03:29:23PM +0200, Ingo Molnar wrote:
> * Johannes Stezenbach <js@sig21.net> wrote:
> > On Mon, Aug 10, 2009 at 02:32:28PM +0200, Andi Kleen wrote:
> > > 
> > > When the BIOS doesn't enable it then force enabling lapic might not work.
> > > 
> > > This could cause either boot failures (obvious) or more subtle 
> > > problems like SMM doing something unexpected. Just saying that 
> > > if you have strange problems later first try disabling this 
> > > option again.
> > 
> > Thanks for the heads-up.  I remember I tried to use oprofile in 
> > the past on this machine and was disappointed that it only got the 
> > timer event.  I'll keep lapic for now unless I see signs of 
> > instability.
> 
> What's the output of something like 'perf stat true', and does 'perf 
> top' output something - i.e. do perfcounters work in general? Once 
> you get to that stage and it works then it should be fine.

# ./perf stat true

 Performance counter stats for 'true':

       0.985808  task-clock-msecs         #      0.779 CPUs 
              0  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            110  page-faults              #      0.112 M/sec
         583873  cycles                   #    592.279 M/sec
         500937  instructions             #      0.858 IPC  
  <not counted>  cache-references        
  <not counted>  cache-misses            

    0.001265524  seconds time elapsed


# ./perf top
------------------------------------------------------------------------------
   PerfTop:     172 irqs/sec  kernel:43.6% [100000 cycles],  (all, 1 CPUs)
------------------------------------------------------------------------------

             samples    pcnt         RIP          kernel function
  ______     _______   _____   ________________   _______________

               96.00 - 16.4% - 00000000c129be10 : acpi_pm_read
               66.00 - 11.3% - 00000000c116fbb1 : delay_tsc
               59.00 - 10.1% - 00000000c1172a83 : ioread32
               26.00 -  4.4% - 00000000c116f567 : vsnprintf
               21.00 -  3.6% - 00000000c11a4721 : acpi_os_read_port
               20.00 -  3.4% - 00000000c136612c : schedule
               19.00 -  3.2% - 00000000c10054b9 : mask_and_ack_8259A
               18.00 -  3.1% - 00000000c11ce8bc : acpi_idle_enter_bm
               17.00 -  2.9% - 00000000c1090dd1 : do_select
               16.00 -  2.7% - 00000000c133f380 : unix_poll
               14.00 -  2.4% - 00000000c116e2b4 : number
               13.00 -  2.2% - 00000000c1002847 : sysenter_past_esp
               10.00 -  1.7% - 00000000c1085b84 : fget_light
                9.00 -  1.5% - 00000000c13666a7 : preempt_schedule
                9.00 -  1.5% - 00000000c102cf1b : get_next_timer_interrupt
^C


First I tried oprofile while running an endless while loop in bash:

# opreport 
CPU: Pentium M (P6 core), speed 1800 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted, and not in a thermal trip) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
   282940 76.5545 bash
    78266 21.1763 libc-2.9.so
     1730  0.4681 Xorg
     1069  0.2892 oprofiled

Looks plausible.


But in demsg I got this:

Delta way too big! 18446744022868427516 ts=18446744022868427516 write stamp = 0
------------[ cut here ]------------
WARNING: at kernel/trace/ring_buffer.c:1392 rb_reserve_next_event+0x150/0x309()
Hardware name: 2373Y4M
Modules linked in: ath5k mac80211 ath cfg80211 oprofile bnep sco rfcomm l2cap bluetooth ehci_hcd uhci_hc
Pid: 13478, comm: opcontrol Not tainted 2.6.31-rc5 #5
Call Trace:
 [<c10248dd>] warn_slowpath_common+0x60/0x90
 [<c102491a>] warn_slowpath_null+0xd/0x10
 [<c1054129>] rb_reserve_next_event+0x150/0x309
 [<c1068c06>] ? get_page_from_freelist+0x86/0x35a
 [<c10544f7>] ring_buffer_lock_reserve+0xe7/0x135
 [<f88622c0>] op_cpu_buffer_write_reserve+0x1a/0x4b [oprofile]
 [<f886239d>] op_add_code+0x57/0x98 [oprofile]
 [<c1068c06>] ? get_page_from_freelist+0x86/0x35a
 [<c1367c08>] ? page_fault+0x0/0x8
 [<f8862409>] log_sample+0x2b/0x6c [oprofile]
 [<c1064c76>] ? filemap_fault+0x74/0x32b
 [<f886249c>] oprofile_add_sample+0x3b/0x6b [oprofile]
 [<f88641d8>] ppro_check_ctrs+0x66/0xdb [oprofile]
 [<c1074bde>] ? __do_fault+0x303/0x32f
 [<f8863907>] profile_exceptions_notify+0x1f/0x26 [oprofile]
 [<c103953b>] notifier_call_chain+0x2b/0x55
 [<c10398e3>] __atomic_notifier_call_chain+0x1a/0x3a
 [<c103990f>] atomic_notifier_call_chain+0xc/0xe
 [<c103993e>] notify_die+0x2d/0x2f
 [<c1003c54>] do_nmi+0x63/0x222
 [<c1367d1d>] nmi_stack_correct+0x28/0x2d
 [<c1367c08>] ? page_fault+0x0/0x8
---[ end trace d174f39c63495e01 ]---


Thanks
Johannes
