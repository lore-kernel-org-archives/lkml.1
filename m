Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYLLLbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYLLLbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYLLLbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:31:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbYLLLbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:31:41 -0500
Date: Fri, 12 Dec 2008 12:31:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: [PATCH 1/3] tracing/function-graph-tracer:
	introduce __notrace_funcgraph to filter special functions
Message-ID: <20081212113126.GG32640@elte.hu>
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu> <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com> <20081208155018.GB405@elte.hu> <20081209023822.GA3602@elte.hu> <c62985530812090059g27bcb36dg8318123d16a15664@mail.gmail.com> <c62985530812091205r5b5afb29o5d9282076c7094c3@mail.gmail.com> <alpine.DEB.1.10.0812091639390.19875@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812091639390.19875@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 9 Dec 2008, Fr?d?ric Weisbecker wrote:
> > 2008/12/9 Fr?d?ric Weisbecker <fweisbec@gmail.com>:
> > 
> > 
> > I built this config on an smp x86-64 and booted several times (and
> > tested the function tracer manually) with and without the following
> > options:
> > 
> > initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel
> > selinux=0 nmi_watchdog=2 idle=poll
> > 
> > And I can't reproduce this bug.... That might be a very nasty race condition...
> 
> Neither can I :-(
> 
> Ingo, is this on the box that stresses NMIs?

yes. You could try to inject even more NMIs than i normally do, 
artificially, by picking up tip/master and running KernelTop with a 
100,000 cycles IRQ interval:

    http://redhat.com/~mingo/perfcounters/kerneltop.c

run it like this:

    ./kerneltop -c 100000

and run an infinite loop per process:

    while :; do :; done &

to get the NMIs going intensely:

------------------------------------------------------------------------------
 KernelTop:  115437 irqs/sec  [NMI, 100000 cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
  ______     ______   ________________   _______________

           81224.00 - ffffffffff6001a4 : vread_hpet
            3119.00 - ffffffff8027cf99 : perf_read
            2484.00 - ffffffff802227d5 : read_hpet
            1157.00 - ffffffff8056b69a : mutex_lock
            1041.00 - ffffffffff600000 : vgettimeofday
             986.00 - ffffffff80333db5 : avc_has_perm_noaudit
             896.00 - ffffffff8026be2d : audit_syscall_exit
             653.00 - ffffffff8056c8f5 : _spin_lock
             577.00 - ffffffff802ecd14 : dnotify_parent
             528.00 - ffffffff8033679c : file_has_perm
             489.00 - ffffffff802bc060 : dput
             470.00 - ffffffff8026c366 : audit_syscall_entry


	Ingo
