Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYI3Pw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYI3Pw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYI3Pwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:52:49 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:55442 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbYI3Pws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:52:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgEALHl4UhMQWq+/2dsb2JhbACBZL0KgWc
Date: Tue, 30 Sep 2008 11:52:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] Markers : fix reentrancy
Message-ID: <20080930155245.GC12623@Krystal>
References: <20080930054151.GA16961@Krystal> <20080930070923.GB30927@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080930070923.GB30927@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:43:02 up 117 days, 20:23,  8 users,  load average: 0.36, 0.38,
	0.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Lai Jiangshan <laijs@cn.fujitsu.com> wrote :
> > > marker_synchronize_unregister must be called _also_ between unregistration
> > > and destruction the data that unregistration-ed probes need to make sure
> > > there is no caller executing a probe when it's data is destroyed.
> > > 
> > 
> > Ah, you're right. I looked again through your patch description and I
> > think using a :
> > 
> > 
> > if (entry->rcu_pending)
> >                 rcu_barrier_sched();
> > 
> > After each time the markers_mutex is taken would keep the fast batch 
> > registration/unregistration and fix the reentrancy problem. The 
> > following patch should address the problem.
> 
> could you please send a delta patch against tip/master? Lai's patch is 
> already applied and is tested. Thanks,
> 
> 	Ingo

Hrm,

Most of Lai "simplifications" to use synchronize_sched() instead of
call_rcu_sched() will make batch registration/unregistration much
slower (very noticeable on ~50 markers on a loaded machine). It also
contains two different fixes in one, one of which has been nacked.

The correct list of changes against tip now becomes :

Revert commit d587284c1d26b796bf52a6e3d3f783db4e462119
Apply patch "Markers : marker_synchronize_unregister()"
Apply patch "Markers : probe example fix teardown"
Apply patch "Markers : documentation fix teardown"
Apply patch "sputrace : use marker_synchronize_unregister()"
Apply patch "Markers : fix reentrancy"

Sorry, but rebasing those marker fixes will just make all those changes
really messy. I think the cleanest way is to just revert. :-/

Mathieu
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
