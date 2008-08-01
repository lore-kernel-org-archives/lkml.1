Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbYHAVUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbYHAVUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761093AbYHAVLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:11:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49959 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761071AbYHAVLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:11:18 -0400
Date: Fri, 1 Aug 2008 14:11:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>
Subject: Re: 2.6.26-rt1
Message-ID: <20080801211114.GC14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:21:10AM +0200, Thomas Gleixner wrote:
> We are pleased to announce the 2.6.26-rt1 tree, which can be
> downloaded from the location:
>   
>    http://rt.et.redhat.com/download/
> 
> Information on the RT patch can be found at:
> 
>    http://rt.wiki.kernel.org/index.php/Main_Page
> 
> The merge was mostly done by Steven Rostedt, I just fixed it up, added
> the fixes from .24-rt17 and tested it on x86 32/64bit.
> 
> This is the first cut of .26-rt, so don't expect it to be perfect.
> 
> I run out of time, so I dropped Peter's cpu-hotplug patches
> completely. The hotplug and rcupreempt code has changed radically, so
> we need to redo that lot. Peter, Paul can you please look into that ?
> 
> I tried to address the non-x86 issues as far as I could, but I had no
> chance to compile test them. So please check the wreckage.
> 
> to build a 2.6.26-rt1 tree, the following patches should be applied:
> 
>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>    http://rt.et.redhat.com/download/patch-2.6.26-rt1.bz2
>   
> And like always, Steven's RT version of Matt Mackall's ketchup will get this
> for you nicely:
> 
>   http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
> 
> As usual the broken out patches are also available.
> 
> I'm going on vacation tomorrow so feel free to blame/curse/flame me,
> but please work with Steven to get it into shape.

Hmmm...  Still quite a few RCU-related patches in there.  Here is my
kneejerk reaction on what to do about them:

o	call_rcu_bh-rename-of-call_rcu.patch should go to mainline.

o	rcu-trace-fix-free.patch should go to mainline.

o	rcu-preempt-fix-bad-dyntick-accounting.patch can be dropped
	from -rt without going to mainline.

o	Some of rcu-hrt-fixups.patch needs to go over, some need to
	come back:

	o	__rcu_process_callbacks() change of local_irq_disable()
		to local_irq_save() should go to mainline.

	o	-rt needs to take the change that dropped the parameter
		for softirq functions.

	o	-rt needs to take the change of rcu_process_callbacks()
		to static (both declaration and definition).

	o	-rt needs to take the deletion of rcu_advance_callbacks()

o	rcu-new-7.patch needs to move over (torture preemptable RCU)
	Ditto for rcu-torture-preempt-update.patch.  But not blazingly
	urgent.

o	RCU boosting needs re-implementation, in the works.

o	preempt_realtime_rcu.patch is mostly about raw_spinlock_t.
	Is mainline's raw_spinlock_t compatible with that of -rt?
	If so, this should go to mainline.

o	rcu-preempt-hotplug-hackaround.patch should be able to be
	dropped at some point (maybe even as of 2.6.26?).

Thoughts?

							Thanx, Paul
