Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbXGZNbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbXGZNbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759246AbXGZNbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:31:43 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:53130 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754429AbXGZNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:31:41 -0400
Date: Thu, 26 Jul 2007 09:31:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux@bohmer.net,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726133138.GA30559@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070726072858.GC13061@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:29:54 up 9 days,  8:04,  3 users,  load average: 2.04, 1.65, 1.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

See below,

* Ankita Garg (ankita@in.ibm.com) wrote:
> Hi,
> 
> On Mon, Jul 16, 2007 at 12:52:37PM -0700, Arjan van de Ven wrote:
> > On Mon, 2007-07-16 at 21:46 +0200, Remy Bohmer wrote:
> > > So I was wondering if anybody knows some tool/kernel mechanism which
> > > can do this?
> > > If not, I will build a kernel extension for it myself (new extension
> > > to 'latency_trace' ?)
> > 
> > systemtap has been able to do such things for me in the past...
> 
> Was trying to capture similar data as mentioned by Remy using Systemtap.
> The tapset/systemtap script that I used is :
> 
> probe kernel.function("balance_rt_tasks").inline {
>         printf("%s (pid: %d, tid: %d argstr: %s ) \n", execname(),
> pid(), tid(), argstr);
> }
> 
> The probe point did get triggered, and soon after that I had the
> following in dmesg, leading to system hang...
> 
> BUG: scheduling while atomic: softirq-rcu/3/0x00000004/52, CPU#3
> 
> Call Trace:
>  <#DB>  [<ffffffff81033555>] __schedule_bug+0x4b/0x4f
>  [<ffffffff8128b414>] __sched_text_start+0xcc/0xaaa
>  [<ffffffff8100b574>] dump_trace+0x248/0x25d
>  [<ffffffff81068334>] print_traces+0x9/0xb
>  [<ffffffff8100b5e5>] show_trace+0x5c/0x64
>  [<ffffffff8128c1c2>] schedule+0xe4/0x104
>  [<ffffffff8128d10c>] rt_spin_lock_slowlock+0xfc/0x19e
>  [<ffffffff8128d9de>] __rt_spin_lock+0x1f/0x21
>  [<ffffffff8128d9e9>] rt_spin_lock+0x9/0xb
>  [<ffffffff88387dcc>]
> :stap_c1a10b1292b5f87a563f56d89ddfc765_606:_stp_print_flush+0x5f/0xdf

The problem is also in _stp_print_flush, not *only* in relay code:

void _stp_print_flush (void)
...
                spin_lock(&_stp_print_lock);
                ...
                spin_unlock(&_stp_print_lock);

Those will turn into mutexes with -rt.

Mathieu


>  [<ffffffff88389e41>]
> :stap_c1a10b1292b5f87a563f56d89ddfc765_606:probe_1493+0x1f6/0x257
>  [<ffffffff8838bdc3>]
> :stap_c1a10b1292b5f87a563f56d89ddfc765_606:enter_kprobe_probe+0x105/0x22a
>  [<ffffffff8128b511>] __sched_text_start+0x1c9/0xaaa
>  [<ffffffff8128f8ee>] kprobe_handler+0x1b3/0x1f5
>  [<ffffffff8128f96b>] kprobe_exceptions_notify+0x3b/0x7f
>  [<ffffffff81290604>] notifier_call_chain+0x33/0x5b
>  [<ffffffff810461d5>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff810461e6>] raw_notifier_call_chain+0xf/0x11
>  [<ffffffff8105098b>] notify_die+0x2e/0x33
>  [<ffffffff8128ef6d>] do_int3+0x30/0x8d
>  [<ffffffff8128e8a3>] int3+0x93/0xb0
>  [<ffffffff8128b512>] __sched_text_start+0x1ca/0xaaa
>  <<EOE>>  [<ffffffff8107b585>] __free_pages+0x18/0x21
>  [<ffffffff8107b5e3>] free_pages+0x55/0x5a
>  [<ffffffff8109945d>] kmem_freepages+0x112/0x11b
>  [<ffffffff8128c1c2>] schedule+0xe4/0x104
>  [<ffffffff8103edf5>] ksoftirqd+0xbc/0x26f
>  [<ffffffff8103ed39>] ksoftirqd+0x0/0x26f
>  [<ffffffff8103ed39>] ksoftirqd+0x0/0x26f
>  [<ffffffff8104c917>] kthread+0x49/0x76
>  [<ffffffff8100af18>] child_rip+0xa/0x12
>  [<ffffffff8128be67>] thread_return+0x75/0x1d5
>  [<ffffffff8104c8ce>] kthread+0x0/0x76
>  [<ffffffff8100af0e>] child_rip+0x0/0x12
> 
> Looks like printing the data in the tapset resulted in some lock
> issues. The above script is just one of the many probe points that I
> tried. In all cases, printing data from within the probe point resulted in the 
> hang (as when I do the printing at the time the script is stopped,
> everything works just fine!).
> 
> Any idea why this could be happening? An -rt issue or systemtap bug??
> 
> 
> -- 
> Regards,
> Ankita Garg (ankita@in.ibm.com)
> Linux Technology Center
> IBM India Systems & Technology Labs, 
> Bangalore, India   

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
