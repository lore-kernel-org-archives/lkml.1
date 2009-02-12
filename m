Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZBLQ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZBLQ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbZBLQ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:58:46 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34484 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbZBLQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:58:45 -0500
Date: Thu, 12 Feb 2009 22:28:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: res_counter fix, v2
Message-ID: <20090212165833.GB6298@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212101650.GA1096@elte.hu> <20090212102113.GA10031@elte.hu> <20090212194644.98d275cf.kamezawa.hiroyu@jp.fujitsu.com> <20090212112854.GD31613@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090212112854.GD31613@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-02-12 12:28:54]:

> 
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 12 Feb 2009 11:21:13 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Frederic, could you try the patch below?
> > > 
> > > Please try v2 below - it might even build ;-)
> > > 
> > > 	Ingo
> > > 
> > > ------------------->
> > > Subject: rt: res_counter fix
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Date: Thu Feb 12 11:11:47 CET 2009
> > > 
> > > Frederic Weisbecker reported this warning:
> > > 
> > > [   45.228562] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
> > > [   45.228571] in_atomic(): 0, irqs_disabled(): 1, pid: 4290, name: ntpdate
> > > [   45.228576] INFO: lockdep is turned off.
> > > [   45.228580] irq event stamp: 0
> > > [   45.228583] hardirqs last  enabled at (0): [<(null)>] (null)
> > > [   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > > [   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > > [   45.228609] softirqs last disabled at (0): [<(null)>] (null)
> > > [   45.228617] Pid: 4290, comm: ntpdate Tainted: G        W  2.6.29-rc4-rt1-tip #1
> > > [   45.228622] Call Trace:
> > > [   45.228632]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
> > > [   45.228639]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
> > > [   45.228646]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
> > > [   45.228653]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
> > > [   45.228660]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
> > > [   45.228667]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
> > > [   45.228674]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
> > > [   45.228680]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
> > > [   45.228688]  [<ffffffff802d94ce>] __do_fault+0x29e/0x4c0
> > > [   45.228694]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
> > > [   45.228700]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
> > > [   45.228707]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
> > > [   45.228714]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
> > > [   45.228720]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
> > > [   45.228727]  [<ffffffff8043e1ed>] ? __clear_user+0x3d/0x70
> > > [   45.228733]  [<ffffffff8043e1d1>] ? __clear_user+0x21/0x70
> > > 
> > > The reason is the raw IRQ flag use of kernel/res_counter.c.
> > > 
> > > The irq flags tricks there seem a bit pointless: it cannot
> > > protect the c->parent linkage because local_irq_save() is
> > > only per CPU.
> > > 
> > > So replace it with _nort(). This code needs a second look.
> > > 
> > I'm sorry for no knowledge about RT. Could you teach me what
> > local_irq_save_nort() does ?
> > 
> > Hmm, how about just replacaing _irq() with preempt_disable()/enable() ?
> > xxx_nort() is better ?
> > 
> > AFAIK, these will not be called from irq context. (Added Balbir to CC:)
> 
> _nort() will just turn them into NOPs in essence.
> 
> The question is, are these local IRQ flags manipulations really needed
> in this code, and if yes, why?

We needed the local IRQ flags, since these counters are updated from
page fault context and from reclaim context with lru_lock held with
IRQ's disabled. I've been thinking about replacing the spin lock with
seq lock, but have not gotten to it yet.

-- 
	Balbir
