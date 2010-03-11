Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab0CKSRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:17:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab0CKSRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:17:37 -0500
Date: Thu, 11 Mar 2010 19:16:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
Message-ID: <20100311181646.GA12235@elte.hu>
References: <20100310183102.GC8070@lenovo>
 <1268274775.4996.16.camel@minggr.sh.intel.com>
 <20100311165439.GB5129@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311165439.GB5129@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> x86,perf: Implement minimal P4 PMU driver v15

tried it on a Pentium-D dual core CPU, and it boots fine:

[    0.020009] using mwait in idle threads.
[    0.021004] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.024006] ... version:                0
[    0.025003] ... bit width:              40
[    0.026003] ... generic registers:      18
[    0.027003] ... value mask:             000000ffffffffff
[    0.028003] ... max period:             0000007fffffffff
[    0.029003] ... fixed-purpose events:   0
[    0.030003] ... event mask:             000000000003ffff
[    0.031027] ACPI: Core revision 20100121
[    0.050126] Setting APIC routing to flat
[    0.051010] enabled ExtINT on CPU#0

perf stat seems to work fine as well:

rhea:~> perf stat ls >/dev/null

 Performance counter stats for 'ls':

       6.596037  task-clock-msecs         #      0.439 CPUs 
              1  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            236  page-faults              #      0.036 M/sec
        4745843  cycles                   #    719.499 M/sec
              0  instructions             #      0.000 IPC  
  <not counted>  cache-references        
  <not counted>  cache-misses            

    0.015009286  seconds time elapsed

perf top works fine as well:

------------------------------------------------------------------------------
   PerfTop:   25056 irqs/sec  kernel:25.7% [100000 cycles],  (all, 2 CPUs)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

              845.00 -  6.6% : __switch_to
              785.00 -  6.1% : schedule
              687.00 -  5.3% : perf_poll
              455.00 -  3.5% : _raw_spin_lock_irqsave
              436.00 -  3.4% : delay_tsc
              371.00 -  2.9% : fget_light
              346.00 -  2.7% : pick_next_task_fair
              328.00 -  2.5% : fput
              285.00 -  2.2% : free_poll_entry

i also triggered this:

[  436.224139] PMU: Dep events are not implemented yet

i'm getting a healthy amount of NMIs:

NMI:      44400     108796   Non-maskable interrupts

perf record + report works fine too:

# Samples: 32829281626
#
# Overhead          Command       Shared Object  Symbol
# ........  ...............  ..................  ......
#
    11.22%     pipe-test-1m  [kernel.kallsyms]   [k] __switch_to
     4.82%     pipe-test-1m  [kernel.kallsyms]   [k] switch_mm
     4.37%     pipe-test-1m  [kernel.kallsyms]   [k] schedule
     3.01%     pipe-test-1m  [kernel.kallsyms]   [k] pipe_read
     2.96%     pipe-test-1m  [kernel.kallsyms]   [k] system_call
     2.53%     pipe-test-1m  [kernel.kallsyms]   [k] update_curr
     2.15%     pipe-test-1m  [kernel.kallsyms]   [k] vfs_read

perf annotate __switch_to works too, and sees inside irqs-disabled regions due 
to NMI sampling:

    0.00 :      ffffffff81001664:       48 89 c2                mov    %rax,%rdx
    0.18 :      ffffffff81001667:       b9 00 01 00 c0          mov    $0xc0000100,%ecx
    0.00 :      ffffffff8100166c:       48 c1 ea 20             shr    $0x20,%rdx
    0.00 :      ffffffff81001670:       0f 30                   wrmsr  
   67.80 :      ffffffff81001672:       45 85 ff                test   %r15d,%r15d
    1.85 :      ffffffff81001675:       66 89 b3 8c 04 00 00    mov    %si,0x48c(%rbx)
    5.35 :      ffffffff8100167c:       41 0f b7 bd 8e 04 00    movzwl 0x48e(%r13),%edi
    0.00 :      ffffffff81001683:       00 

(and that wrmsr is indeed one known overhead point in __switch_to.)

All in one, the P4 PMU perf driver works on this box like a charm and all the 
common profiling workflows work out of box, without any serious limitations - 
really nice work! (Obviously some events wont work yet, etc.)

So it's pretty impressive and i've queued up your patch in tip:perf/x86 and 
will merge it into perf/core after others had a chance to test it too.

	Ingo
