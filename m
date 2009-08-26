Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZHZBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZHZBbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932631AbZHZBbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:31:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59891 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZHZBbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:31:35 -0400
Date: Tue, 25 Aug 2009 18:31:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip] Re: [PATCH -tip 0/2] Temporary RCU fixes for
	notrace and hotplug CPU
Message-ID: <20090826013136.GT6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825080047.GA16139@elte.hu> <20090825161208.GE6616@linux.vnet.ibm.com> <20090825162549.GB25058@Krystal> <20090825171136.GG6616@linux.vnet.ibm.com> <20090825180233.GA2448@Krystal> <20090825183613.GJ6616@linux.vnet.ibm.com> <4A948780.6030005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A948780.6030005@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 08:53:20AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Tue, Aug 25, 2009 at 02:02:33PM -0400, Mathieu Desnoyers wrote:
> >> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> >>> On Tue, Aug 25, 2009 at 12:25:49PM -0400, Mathieu Desnoyers wrote:
> >>>> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> >>>>> On Tue, Aug 25, 2009 at 10:00:47AM +0200, Ingo Molnar wrote:
> >>>>>> btw., i'm still seeing crashes with the latest RCU bits:
> >>>>>>
> >>>>>> [   20.621740] Testing event sys_enter_futex: OK
> >>>>>> [   20.629738] Testing event sys_exit_futex: OK
> >>>>>> [   20.637737] Testing event lock_acquire: [reboot]
> >>>>>>
> >>>>>> Possibly due to infinite recursion as well. Config attached.
> >>>>> Color me confused...
> >>>>>
> >>>>> Unless someone has a better idea, I will send in a patch that adds
> >>>>> "notrace" to every RCU API member used by any file in the kernel
> >>>>> that has "trace" in its name (excluding ptrace.c and rcutree_trace.c,
> >>>>> of course).  This list is as follows:
> >>>>>
> >>>>> 	call_rcu()
> >>>>> 	call_rcu_sched()
> >>>>> 	rcu_read_lock()
> >>>>> 	rcu_read_unlock()
> >>>>>
> >>>>> So, any better ideas?
> >>>> Tracers using RCU should use the _notrace() version of read_lock/unlock.
> >>>> I think the callers should be fixed rather than RCU.
> >>>>
> >>>> Tracepoints have been designed to use the _notrace variant on the
> >>>> instrumentation site. The core of tracepoint management use
> >>>> call_rcu_sched(), which can be traced without any problem.
> >>>>
> >>>> I have not followed the late tracing development as closely though, so
> >>>> errors might have crept in.
> >>> Or I might have inadvertently broken something in a non-obvious (to me,
> >>> anyway) manner.
> >>>
> >>> So, would you be willing to look at commit bc33f24bd in the -tip
> >>> tree and see if there is anything I broke other than the now-fixed
> >>> rcu_read_lock_sched_notrace() and rcu_read_unlock_sched_notrace()?
> >>> And for that matter, whether my alleged fix for these two API members
> >>> really does fix the problem (-tip commit 7c614d6461)?
> >>>
> >>> The -tip tree is at:
> >>>
> >>> 	git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> >>>
> >>> And these patches are on the tip/core/rcu branch.
> >>>
> >> sure, here we go:
> >>
> >>  static inline void rcu_read_lock_sched_notrace(void)
> >>  {
> >>         preempt_disable_notrace();
> >> +       __acquire(RCU_SCHED);
> >> +       rcu_read_acquire();
> >>  }
> >>
> >> and
> >>
> >>
> >>  static inline void rcu_read_unlock_sched_notrace(void)
> >>  {
> >> +       rcu_read_release();
> >> +       __release(RCU_SCHED);
> >>         preempt_enable_notrace();
> >>  }
> >>
> >> will make those _notrace primitives call into lockdep. I don't think
> >> this is correct, and this might be causing your problem.
> >>
> >> rcu_read_acquire/release are calling lock_acquire/release, those should
> >> be removed.
> >>
> >> __acquire() simply seems to be defined to a gcc "context" attribute,
> >> probably for the sparse checker. I think it should be safe to leave them
> >> there.
> > 
> > Thank you for looking this over, Mathieu!!!  Please see below for patch.
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > Remove lockdep annotations from RCU's _notrace() API members.
> > 
> > The lockdep annotations rcu_read_acquire() and rcu_read_release()
> > might lead to infinite looping if called from lockdep.  So this patch
> > removes them.
> > 
> > Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> >  rcupdate.h |    2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 8b4422c..95e0615 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -195,7 +195,6 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
> >  {
> >  	preempt_disable_notrace();
> >  	__acquire(RCU_SCHED);
> > -	rcu_read_acquire();
> >  }
> >  
> >  /*
> > @@ -211,7 +210,6 @@ static inline void rcu_read_unlock_sched(void)
> >  }
> >  static inline notrace void rcu_read_unlock_sched_notrace(void)
> >  {
> > -	rcu_read_release();
> >  	__release(RCU_SCHED);
> >  	preempt_enable_notrace();
> >  }
> 
> I remembered I have suggested this ...

Ah!!!  I understood the "add notrace" suggestion, but was confused into
thinking that "notrace" was going to prevent it from being called the
second time.

> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you!!!

							Thanx, Paul

> Lai Jiangshan wrote:
> > 
> >>  {
> >>  	preempt_disable_notrace();
> >> +	__acquire(RCU_SCHED);
> >> +	rcu_read_acquire();
> >>  }
> >>  
> > 
> > It may cause infinity recursion.
> > rcu_read_acquire() calls rcu_read_lock_sched_notrace()
> > before current->lockdep_recursion is set to 1 when tracing in on,
> > thus infinity recursion occurs.
> > 
> > Lai
> > 
> 
> 
