Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYBSWDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYBSWDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYBSWD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:03:26 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:32852 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbYBSWDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:03:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFzhukdMQWRV/2dsb2JhbACBWa1e
Date: Tue, 19 Feb 2008 17:03:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Gautham R Shenoy <ego@in.ibm.com>, linux-rt-users@vger.kernel.org,
       dipankar@in.ibm.com
Subject: Re: Markers: multi-probe locking fun (was: Re: [PATCH 0/2] Markers
	Implementation for RCU Tracing - Ver II)
Message-ID: <20080219220317.GA20682@Krystal>
References: <20071231060911.GB6461@in.ibm.com> <20080103163055.GB27651@Krystal> <20080104105858.GA13865@in.ibm.com> <20080105124632.GA16576@Krystal> <20080107195038.GA5119@in.ibm.com> <47B97E63.3070205@siemens.com> <20080218194825.GF10471@linux.vnet.ibm.com> <47BB037C.6060306@siemens.com> <20080219215428.GI10774@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080219215428.GI10774@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:02:45 up 8 days, 18:03,  4 users,  load average: 1.14, 0.67,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Feb 19, 2008 at 05:27:40PM +0100, Jan Kiszka wrote:
> > Paul E. McKenney wrote:
> > > On Mon, Feb 18, 2008 at 01:47:31PM +0100, Jan Kiszka wrote:
> > >> K. Prasad wrote:
> > >>> Hi Ingo,
> > >>> 	Please accept these patches into the rt tree which convert the
> > >>> existing RCU tracing mechanism for Preempt RCU and RCU Boost into
> > >>> markers.
> > >>>  
> > >>> These patches are based upon the 2.6.24-rc5-rt1 kernel tree.
> > >>>  
> > >>> Along with marker transition, the RCU Tracing infrastructure has also
> > >>> been modularised to be built as a kernel module, thereby enabling
> > >>> runtime changes to the RCU Tracing infrastructure.
> > >>>  
> > >>> Patch [1/2] - Patch that converts the Preempt RCU tracing in
> > >>> rcupreempt.c into markers.
> > >>>  
> > >>> Patch [1/2] - Patch that converts the Preempt RCU Boost tracing in
> > >>> rcupreempt-boost.c into markers.
> > >>>  
> > >> I have a technical problem with marker-based RCU tracing: It causes
> > >> nasty recursions with latest multi-probe marker patches (sorry, no link
> > >> at hand, can be found in latest LTTng, maybe also already in -mm). Those
> > >> patches introduce a marker probe trampoline like this:
> > >>
> > >> void marker_probe_cb(const struct marker *mdata, void *call_private,
> > >> 	const char *fmt, ...)
> > >> {
> > >> 	va_list args;
> > >> 	char ptype;
> > >>
> > >> 	/*
> > >> 	 * rcu_read_lock does two things : disabling preemption to make sure the
> > >> 	 * teardown of the callbacks can be done correctly when they are in
> > >> 	 * modules and they insure RCU read coherency.
> > >> 	 */
> > >> 	rcu_read_lock();
> > >> 	preempt_disable();
> > >> 	...
> > >>
> > >> Can we do multi-probe with pure preempt_disable/enable protection? I
> > >> guess it's fine with classic RCU, but what about preemptible RCU? Any
> > >> suggestion appreciated!
> > > 
> > > If you substitute synchronize_sched() for synchronize_rcu(), this should
> > > work fine.  Of course, this approach would cause RCU tracing to degrade
> > > latencies somewhat in -rt.
> > > 
> > > If tracing is using call_rcu(), we will need to add a call_sched()
> > > or some such.
> > 
> > You mean something like "#define call_sched call_rcu_classic"?
> 
> This would work for Classic RCU.  For preemptible RCU, a bit more
> work is needed.
> 
> > I just learned that there is another reason for killing
> > rcu_read_lock&friends from the marker probes: It can deadlock on -rt
> > with PREEMPT_RCU_BOOST (hit probe inside rq-lock protected region =>
> > rcu_read_unlock triggers unboost => stuck on rq_lock :( ).
> 
> OK, good to know.  Guess we need a call_sched() for -rt and for
> preemptible RCU sooner rather than later...
> 

Yup, I would need call_sched() and sched_barrier().

Thanks,

Mathieu

> 						Thanx, Paul

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
