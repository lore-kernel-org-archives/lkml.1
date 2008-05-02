Return-Path: <linux-kernel-owner+w=401wt.eu-S964973AbYEBPVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973AbYEBPVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763137AbYEBPVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:21:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:57240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759860AbYEBPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:21:30 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18q1mJ3t0EqwhLyGHv26uij24iCX92RecLe/fB8hE
	C6262FqfGti7jR
Date: Fri, 2 May 2008 17:21:26 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: CPU POSIX timers livelock
Message-ID: <20080502152126.GA3130@atjola.homenet>
References: <1209740741.15210.49.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209740741.15210.49.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Roland McGrath and Frank Mayhar to Cc:, as this sounds similar
enough to what has been discussed here http://lkml.org/lkml/2008/2/6/505]

On 2008.05.02 17:05:41 +0200, Petr Tesarik wrote:
> Hello,
> 
> there seems to be a possible livelock in the CPU timers (actually, we've
> experienced it once already). The analysis lead to the conclusion that
> fixing this properly will be a bit harder.
> 
> Problem Statement
> 
>  1. Any process can set ITIMER_PROF as short as 1 timer tick
>  2. If the process is CPU-bound (e.g. a number-crunching application),
>     the timer will expire with every timer tick
>  3. If the process has N threads and each thread runs on its own
>     CPU, the timer will expire N times per timer tick
> 
> Now, this can become quite interesting on a larger system. For instance,
> with 128 CPUs and a (conservative) setting of HZ 300, any process can
> effectively ask to be sent a SIGPROF every 26 usec (1/300/128 s). Pretty
> fast, but it can get worse if you consider the pitfalls of a NUMA
> architecture.
> 
> Whenever the timer expires, a new expiration time must be computed for
> each thread in the thread group. The values are stored in task_struct of
> each thread, and IIRC those are kept local to the CPU where the thread
> is running (quite logically). Put in another way, walking all threads
> means touching remote memory except for the few task_struct which are
> local to the recomputing CPU. In the 128-CPU example, if each node has 2
> CPUs (think Altix), only 2 accesses are to the local node and 126
> accesses are to remote memory. These are already quite expensive, but it
> gets even worse. The timer interrupt is generated locally for each CPU,
> so if the process is spread over all of them (see above), all CPUs
> recompute the timer (hint: write access), thus constantly invalidating
> local caches of the remote memory.
> 
> And those computations cannot run in parallel, of course, because
> everything is serialized on sighand->siglock (see run_posix_cpu_timers).
> So, each time one CPU finishes walking the threads, there's already a
> queue of all the other CPUs waiting to do the same again. For this kind
> of load, those 26 usec (approx. 41600 CPU cycles on a 1.6 GHz CPU) may
> be well insufficient. Even more so, if somebody else occasionally takes
> write lock on tasklist_lock. It may so happen that the system spends all
> CPU cycles re-computing the profiling timers over and over again and
> never make any progress. Note this is partly caused by the fact that the
> time needed to handle the profiling timer is itself also counted to the
> profiling time.
> 
> This simply does not scale for large systems (and I was not even
> considering those really large 1024p ones).
> 
> Ideas
> 
> Any ideas for improvement? Obviously, storing per-process expiration
> times in one place instead of dividing the interval by the number of
> currently running threads would help here. But it would spoil the fast
> path (when there are no timers at all). Avoiding that multiple threads
> re-compute the same values might also help (although I've got no idea
> how to implement this).
> 
> Any more comments (before I start hacking something you'll NAK)?
> 
> BTW did POSIX really mean to allow an indefinitely small interval for
> the SIGPROF?
> 
> Petr Tesarik
