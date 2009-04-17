Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZDQA2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZDQA2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZDQA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:28:34 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:47882 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbZDQA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:28:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAANl50lMQW1W/2dsb2JhbACBTs5og30G
Date: Thu, 16 Apr 2009 20:28:31 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
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
Message-ID: <20090417002831.GC20513@Krystal>
References: <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <49E7C74A.8030100@goop.org> <20090417001317.GB20513@Krystal> <49E7CADE.1060202@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49E7CADE.1060202@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:21:03 up 47 days, 20:47,  3 users,  load average: 0.20, 0.47,
	0.56
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>>> Are they?  They're generally considered to be "free", because the 
>>> call  and return are predicted 100% accurately.
>>>
>>>     
>>
>> Adding a simple function call within the tracer fast path, in LTTng, has
>> a very measurable performance impact on the tbench workload. This is why
>> I don't use any function call-based trace clocks in LTTng, but rather my
>> own inline trace clock.
>
> I'm a bit concerned about all the code that tracing puts inline though.   
> It seems it would put quite a lot of icache overhead on the codepath  
> when the tracepoint is disabled, not least because its duplicated in  
> every instance of the tracepoint.  And if the compiler decides to put  
> the unlikely() branch code out of line, then that's the same as making  
> it a function call (except that if it is a function call, all the  
> tracepoints will share the same code, and get a higher likelihood of  
> getting icache hits).
>

"all this code" is actually :

               rcu_read_lock_sched_notrace();                          \
                it_func = rcu_dereference((tp)->funcs);                 \
                if (it_func) {                                          \
                        do {                                            \
                                ((void(*)(proto))(*it_func))(args);     \
                        } while (*(++it_func));                         \
                }                                                       \
                rcu_read_unlock_sched_notrace();                        \

Which does nothing more than disabling preemption and a for loop to
call all the tracepoint handlers. I don't see the big win in laying out
the stack to call this code out-of-line; we would just remove the
preempt disable and the loop, which are minimal compared to most
call stacks.

So basically, tracepoints are already just doing a function call, with a
few more bytes for preempt disable and multiple handler support.

About the compiler deciding to put the unlikely branch out-of-line, I've
never seen any function calls generated just for the sake of saving
those few bytes, that would be crazy of the part of the compiler.
However, it can (and should) freely put the stack setup in the coldest
cache-lines possible, which are reachable by a near jump.

Mathieu

>
>    J
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
