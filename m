Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZHYSCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZHYSCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZHYSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:02:35 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33624 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbZHYSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:02:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFADPEk0pMROOX/2dsb2JhbACBU9dShBoF
Date: Tue, 25 Aug 2009 14:02:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josht@linux.vnet.ibm.com, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug
	CPU
Message-ID: <20090825180233.GA2448@Krystal>
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825080047.GA16139@elte.hu> <20090825161208.GE6616@linux.vnet.ibm.com> <20090825162549.GB25058@Krystal> <20090825171136.GG6616@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825171136.GG6616@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:57:02 up 7 days,  4:46,  2 users,  load average: 0.70, 0.41,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Aug 25, 2009 at 12:25:49PM -0400, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Tue, Aug 25, 2009 at 10:00:47AM +0200, Ingo Molnar wrote:
> > > > 
> > > > btw., i'm still seeing crashes with the latest RCU bits:
> > > > 
> > > > [   20.621740] Testing event sys_enter_futex: OK
> > > > [   20.629738] Testing event sys_exit_futex: OK
> > > > [   20.637737] Testing event lock_acquire: [reboot]
> > > > 
> > > > Possibly due to infinite recursion as well. Config attached.
> > > 
> > > Color me confused...
> > > 
> > > Unless someone has a better idea, I will send in a patch that adds
> > > "notrace" to every RCU API member used by any file in the kernel
> > > that has "trace" in its name (excluding ptrace.c and rcutree_trace.c,
> > > of course).  This list is as follows:
> > > 
> > > 	call_rcu()
> > > 	call_rcu_sched()
> > > 	rcu_read_lock()
> > > 	rcu_read_unlock()
> > > 
> > > So, any better ideas?
> > 
> > Tracers using RCU should use the _notrace() version of read_lock/unlock.
> > I think the callers should be fixed rather than RCU.
> > 
> > Tracepoints have been designed to use the _notrace variant on the
> > instrumentation site. The core of tracepoint management use
> > call_rcu_sched(), which can be traced without any problem.
> > 
> > I have not followed the late tracing development as closely though, so
> > errors might have crept in.
> 
> Or I might have inadvertently broken something in a non-obvious (to me,
> anyway) manner.
> 
> So, would you be willing to look at commit bc33f24bd in the -tip
> tree and see if there is anything I broke other than the now-fixed
> rcu_read_lock_sched_notrace() and rcu_read_unlock_sched_notrace()?
> And for that matter, whether my alleged fix for these two API members
> really does fix the problem (-tip commit 7c614d6461)?
> 
> The -tip tree is at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> 
> And these patches are on the tip/core/rcu branch.
> 

sure, here we go:

 static inline void rcu_read_lock_sched_notrace(void)
 {
        preempt_disable_notrace();
+       __acquire(RCU_SCHED);
+       rcu_read_acquire();
 }
 
and


 static inline void rcu_read_unlock_sched_notrace(void)
 {
+       rcu_read_release();
+       __release(RCU_SCHED);
        preempt_enable_notrace();
 }

will make those _notrace primitives call into lockdep. I don't think
this is correct, and this might be causing your problem.

rcu_read_acquire/release are calling lock_acquire/release, those should
be removed.

__acquire() simply seems to be defined to a gcc "context" attribute,
probably for the sparse checker. I think it should be safe to leave them
there.

Mathieu

> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
