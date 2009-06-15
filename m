Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbZFOTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbZFOTof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZFOTo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:44:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZFOTo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:44:27 -0400
Date: Mon, 15 Jun 2009 21:43:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615194344.GA12554@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > If it's faster, this becomes a legit (albeit complex) 
> > micro-optimization in a _very_ hot codepath.
> 
> I don't think it's all that hot. It's not like it's the return to 
> user mode.

Well i guess it depends. For server apps it is true - syscalls are a 
lot more dominant, MMs are long-running so any startup cost gets 
amortized and pagefaults are avoided.

For something like a kernel build we have 7 times as many pagefaults 
as syscalls:

aldebaran:~/linux/linux> perf stat -- make -j32 >/dev/null
[...]
 Performance counter stats for 'make -j32':

 1444281.076741  task-clock-msecs     #     14.429 CPUs 
         219991  context-switches     #      0.000 M/sec
          18335  CPU-migrations       #      0.000 M/sec
       38465628  page-faults          #      0.027 M/sec
  4374762924204  cycles               #   3029.025 M/sec
  2645979309823  instructions         #      0.605 IPC  
    42398991227  cache-references     #     29.356 M/sec
     4371920878  cache-misses         #      3.027 M/sec

  100.097787566  seconds time elapsed.

So we have 38465628 page-faults, or one every 68788 instructions, 
one every 113731 cycles.

10 cycles saved in the page fault costs means 0.01% performance win 
- or about 10 milliseconds shaven off the kernel build time.
 
100 cycles saved (which is impossible really in the entry/exit path) 
would mean 0.1% win.

5653639 syscalls (according to strace -c) - which is a factor of 6.8 
lower. Same goes for shell scripts or most of the clicking we do on 
a GUI.

It's not a big factor for sure.

Btw., the biggest pagefault cost is in the fault handling itself 
(the page clearing):

      4.14%  [k] do_page_fault
      1.20%  [k] sys_write
      1.10%  [k] sys_open
      0.63%  [k] sys_exit_group
      0.48%  [k] smp_apic_timer_interrupt
      0.37%  [k] sys_read
      0.37%  [k] sys_execve
      0.20%  [k] sys_mmap
      0.18%  [k] sys_close
      0.14%  [k] sys_munmap
      0.13%  [k] sys_poll
      0.09%  [k] sys_newstat
      0.07%  [k] sys_clone
      0.06%  [k] sys_newfstat

it totals to 4.14% of the total cost (user-space cycles included) of 
a kernel build, on a Nehalem box.

	Ingo
