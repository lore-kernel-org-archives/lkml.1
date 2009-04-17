Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZDQArf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZDQArf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbZDQAnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:43:47 -0400
Received: from gw.goop.org ([64.81.55.164]:44452 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035AbZDQAnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:43:46 -0400
Message-ID: <49E7D0BC.4070700@goop.org>
Date: Thu, 16 Apr 2009 17:43:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
References: <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <49E7C74A.8030100@goop.org> <20090417001317.GB20513@Krystal> <49E7CADE.1060202@goop.org> <20090417002831.GC20513@Krystal>
In-Reply-To: <20090417002831.GC20513@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> "all this code" is actually :
>
>                rcu_read_lock_sched_notrace();                          \
>                 it_func = rcu_dereference((tp)->funcs);                 \
>                 if (it_func) {                                          \
>                         do {                                            \
>                                 ((void(*)(proto))(*it_func))(args);     \
>                         } while (*(++it_func));                         \
>                 }                                                       \
>                 rcu_read_unlock_sched_notrace();                        \
>
> Which does nothing more than disabling preemption and a for loop to
> call all the tracepoint handlers. I don't see the big win in laying out
> the stack to call this code out-of-line; we would just remove the
> preempt disable and the loop, which are minimal compared to most
> call stacks.
>   

Well, look at it from my perspective:  Ingo has been repeatedly beating 
me up for the overhead pvops adds to a native kernel, where it really is 
just a (direct) function call.  I want to instrument each pvop site with 
a tracepoint so I can actually work out which calls are being called how 
frequently to look for new optimisation opportunities.

I would guess the tracepoint code sequence is going to increase the 
impact of each pvop call site by a fair bit, and that's not counting the 
effects the extra register pressure will have.  That's a pile of code to 
add.

And frankly, that's fine by me, because I would expect this degree of 
introspection to have some performance hit.  But it does make the need 
for per-subsystem tracing Kconfig entries fairly important, because I 
don't think this would be acceptable to ship in a non-debug-everything 
kernel build, even though other tracepoints might be.

> So basically, tracepoints are already just doing a function call, with a
> few more bytes for preempt disable and multiple handler support.
>
> About the compiler deciding to put the unlikely branch out-of-line, I've
> never seen any function calls generated just for the sake of saving
> those few bytes, that would be crazy of the part of the compiler.
> However, it can (and should) freely put the stack setup in the coldest
> cache-lines possible, which are reachable by a near jump.
>   

No, it wouldn't generate a call.  But if its going to put the code out 
of line into cold cache-lines, then it may as well generate a call.

Anyway, the important point from my perspective is that tracepoint.h 
have no #include dependencies beyond linux/types.h (compiler.h, etc).

    J
