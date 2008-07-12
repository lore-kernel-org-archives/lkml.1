Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYGLTPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYGLTPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 15:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYGLTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 15:15:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbYGLTPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 15:15:45 -0400
Date: Sat, 12 Jul 2008 12:15:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <487880D7.1040608@cn.fujitsu.com>
Message-ID: <alpine.LFD.1.10.0807121201220.2875@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no> <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <487880D7.1040608@cn.fujitsu.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Miao Xie wrote:
> 
> I think Vegard Nossum's patch is not so good because it is not necessary to detach
> all the sched domains when making a cpu offline.

Well, short-term, I'd like to have a minimal fix.

Long-term, I really think that whole CPU notifier thing needs to be 
*fixed*.

It's totally broken to have single callback functions with "flags" 
parameters telling people what to do. I don't understand why people keep 
doing it. It's *always* broken, and the fix is *always* to a structure 
with multiple function pointers - separate functions for separate events.

In the case of those CPU hotplug notifiers, the "freeze" thing could 
probably have been a flag, but CPU_DOWN_PREPARE/DEAD/DYING/UP/xyz should 
likely just be different function callbacks. That way, when we add a 
callback type, it doesn't require changing all existing callbacks that 
don't want to care about the new case. And we wouldn't have these stupid 
and fragile and ugly "switch()" statements with tons of cases all over.

Sadly, people have latched onto a model (that piece-of-sh*t "notifier" 
infrastructure) that encourages - and almost requires - this kind of pure 
crap.

But the CPU hotplug stuff _could_ just use separate notifier chains for 
the different kinds of events. It wouldn't be perfect, but it would be 
better than the mess we have now. Instead of doing

	register_cpu_notifier(..);

and having a single thing that has to handle all cases, we could have

	/* current "ONLINE/ONLINE_FROZEN" cases */
	online = register_cpu_notifier(CPU_ONLINE, online_fn);
	dead = register_cpu_nofitier(CPU_DEAD, dead_fn);

which would allocate the "struct notifier_block" an fill it in, and have 
_separate_ queues for all those cases. That way, *if* you want to share 
the code for multiple cases, you just register the same function. And if 
you only cared about one case, you'd only be called for that one case!

I dunno. Maybe the conversion would be painful. And maybe the end result 
isn't wonderful either. But the current setup for CPU notifiers is just a 
damn disgrace.

			Linus
