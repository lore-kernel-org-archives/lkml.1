Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYI3D1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYI3D1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYI3D1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:27:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYI3D1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:27:03 -0400
Message-ID: <48E18389.3030202@cn.fujitsu.com>
Date: Tue, 30 Sep 2008 09:40:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] markers: fix unregister bug and reenter bug
References: <48E08B05.7030802@cn.fujitsu.com> <20080929150320.GA11245@Krystal>
In-Reply-To: <20080929150320.GA11245@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hi Lai,
> 
> I'll have to nack this fix :
> 
> One fix I already posted makes sure every marker unregister callers call
> synchronize_sched() _at some point_ before module unload. It thus makes
> sure we can do batch unregistration without doing multiple
> synchronize_sched calls.

1) the new API marker_synchronize_unregister() is ugly, it separate one thing
   into two steps.
   user have to remember to call marker_synchronize_unregister() and have
   to know what he can do and what he can't do before
   marker_synchronize_unregister().

2) IMO, synchronous code is better than asynchronous in non-critical-path.
   we need synchronize_sched() for free(old).

   you fixes haven't fix the reenter bug.

I recommend my fix.

> 
> Also, there is no need to do the synchronize_sched with the marker mutex
> held. call_rcu_sched takes care of making sure the previous quiescent
> state is over before calling kfree. This means that when we return from
> the register/unregister functions, there may still be markers "in
> flight" using the old markers. Again, why would it be a problem ?
> 
> Thanks,
> 
> Mathieu
> 
> P.S. : I'll send along the patches I am referring to. Ingo, those should
> probably be merged if they are not in -tip already.
> 


