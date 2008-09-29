Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbYI2PEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbYI2PEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYI2PDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:03:53 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:47473 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbYI2PDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:03:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAKyI4EhMQWq+/2dsb2JhbACBYro0gWc
Date: Mon, 29 Sep 2008 11:03:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] markers: fix unregister bug and reenter bug
Message-ID: <20080929150351.GB11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080929082722.GB18663@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:03:33 up 116 days, 19:43,  9 users,  load average: 0.33, 0.36,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > unregister bug:
> > 
> > codes using makers are typically calling marker_probe_unregister()
> > and then destroying the data that marker_probe_func needs(or
> > unloading this module). This is bug when the corresponding
> > marker_probe_func is still running(on other cpus),
> > it is using the destroying/ed data.
> > 
> > we should call synchronize_sched() after marker_update_probes().
> > 
> > reenter bug:
> > 
> > marker_probe_register(), marker_probe_unregister() and
> > marker_probe_unregister_private_data() are not reentrant safe
> > functions. these 3 functions release markers_mutex and then
> > require it again and do "entry->oldptr = old; ...", but entry->oldptr
> > maybe is using now for these 3 functions may reenter when markers_mutex
> > is released.
> > 
> > we use synchronize_sched() instead of call_rcu_sched() to fix
> > this bug. actually we can do:
> > "
> > if (entry->rcu_pending)
> > 		rcu_barrier_sched();
> > "
> > after require markers_mutex again. but synchronize_sched()
> > is better and simpler. For these 3 functions are not critical path.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> applied to tip/tracing/markers, thanks!
> 
> Mathieu, i've reactivated tip/tracing/markers for linux-next 
> integration, it propagates into auto-ftrace-next. Tracepoints are what 
> we use in the scheduler/etc. in tip/master, but until there's marker use 
> elsewhere there's no reason not to apply fix patches.
> 

nack for this patch. I'll my fix patchset.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
