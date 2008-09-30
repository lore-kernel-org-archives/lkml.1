Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbYI3Diu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbYI3Diu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYI3Dik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:38:40 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:50898 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYI3Dij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:38:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEABs24UhMQWq+/2dsb2JhbACBZLomgWc
Date: Mon, 29 Sep 2008 23:38:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] markers: fix unregister bug and reenter bug
Message-ID: <20080930033836.GA12733@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929150320.GA11245@Krystal> <48E18389.3030202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48E18389.3030202@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:35:05 up 117 days,  8:15, 10 users,  load average: 0.20, 0.30,
	0.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > Hi Lai,
> > 
> > I'll have to nack this fix :
> > 
> > One fix I already posted makes sure every marker unregister callers call
> > synchronize_sched() _at some point_ before module unload. It thus makes
> > sure we can do batch unregistration without doing multiple
> > synchronize_sched calls.
> 
> 1) the new API marker_synchronize_unregister() is ugly, it separate one thing
>    into two steps.
>    user have to remember to call marker_synchronize_unregister() and have
>    to know what he can do and what he can't do before
>    marker_synchronize_unregister().
> 

Hum, yes it does separate unregistration and synchronization in two
steps for a very precise purpose : I don't want unregistration of 100
markers to take ~30 seconds on a heavily loaded machine.

> 2) IMO, synchronous code is better than asynchronous in non-critical-path.
>    we need synchronize_sched() for free(old).
> 

free(old) is only done in call_rcu. the rcu callback is forced by a
rcu_barrier() if two consecutive operations are done on the same
marker.

>    you fixes haven't fix the reenter bug.
> 

I don't see any reentrancy bug here. Have you actually experienced such
an issue ? Can you give me an example of a bogus execution trace
(step-by-step operations) ?

Thanks,

Mathieu

> I recommend my fix.
> 
> > 
> > Also, there is no need to do the synchronize_sched with the marker mutex
> > held. call_rcu_sched takes care of making sure the previous quiescent
> > state is over before calling kfree. This means that when we return from
> > the register/unregister functions, there may still be markers "in
> > flight" using the old markers. Again, why would it be a problem ?
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > P.S. : I'll send along the patches I am referring to. Ingo, those should
> > probably be merged if they are not in -tip already.
> > 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
