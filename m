Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZCWUiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZCWUiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCWUiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:38:05 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:39404 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbZCWUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:38:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAGOOx0lMQW1W/2dsb2JhbACBUNBYg34G
Date: Mon, 23 Mar 2009 16:37:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 0/2 v2] Syscalls tracing
Message-ID: <20090323203754.GA29941@Krystal>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <20090313151632.GB9867@nowhere> <20090313164743.GC3354@Krystal> <20090315160132.GD5105@nowhere> <20090323163235.GA22501@Krystal> <20090323192712.GC5988@nowhere> <20090323194020.GA29478@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090323194020.GA29478@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:15:49 up 23 days, 16:42,  1 user,  load average: 0.34, 0.41,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > And actually I don't think two copy_from_user will really change a 
> > lot the tracing throughput.
> 
> Correct. It's already in the CPU cache so it is a performance 
> non-issue and essentially for free. Copy avoidance is only an issue 
> when touchig cache-cold data.
> 
> ( Yes, a few cycles could be shaven off but the beauty of 
>   all-encompassing non-source-code-invasive syscall tracing covering 
>   hundreds of syscalls straight away trumps those concerns. )
> 

I agree. I just wanted to make sure we agreed on the tradeoff here. I
also think hitting data already in cache-lines a second time with
copy_from_user should not be a big concern.

> > The idea would be now to join the syscalls metadata with such 
> > quick handlers. We will have to think about how to join these in a 
> > proper way.
> 
> We could allow per syscall tracepoints via the attribute table. The 
> call signature could be a standard:
> 
>    long sys_call(unsinged long arg1, unsigned long arg2,
> 		 unsigned long arg3, unsigned long arg4,
> 		 unsigned long arg5, unsigned long arg6);
> 
> This would allow interested plugins/tools to install a system call 
> specific callback. (we might allow two tracepoints - one before and 
> one after the syscall)
> 
> The registration API could be driven by the name or by the syscall 
> index - NR_sys_open or so.

Hrm, given the syscalls are defined with their number of arguments
with the SYSCALL_DEFINE* macros, then we could create, in syscalls.h
(example from open.c) :

SYSCALL_DECLARE2(statfs, const char __user *, pathname, struct statfs __user *, buf))

SYSCALL_DECLARE3(statfs64, const char __user *, pathname, size_t, sz, struct statfs64 __user *, buf)

creating SYSCALL_DECLARE0 to 6, which would map to a tracepoint
declaration _and_ a syscall prototype, e.g.

#define __SC_ARGS1(t1, a1)      a1
#define __SC_ARGS2(t2, a2, ...) a2, __SC_ARGS1(__VA_ARGS__)
#define __SC_ARGS3(t3, a3, ...) a3, __SC_ARGS2(__VA_ARGS__)
#define __SC_ARGS4(t4, a4, ...) a4, __SC_ARGS3(__VA_ARGS__)
#define __SC_ARGS5(t5, a5, ...) a5, __SC_ARGS4(__VA_ARGS__)
#define __SC_ARGS6(t6, a6, ...) a6, __SC_ARGS5(__VA_ARGS__)

#define SYSCALL_DECLARE2(name, ...) SYSCALL_DECLAREx(2, _##name, __VA_ARGS__) 

#define SYSCALL_DECLAREx(x, name, ...)				\
	long sys##name(__SC_DECL##x(__VA_ARGS__));		\
	DECLARE_TRACE(sys_##name,				\
			TP_PROTO(__SC_DECL##x(__VA_ARGS__)),	\
				TP_ARGS(__SC_ARGS##x(__VA_ARGS__)))

Those could be declared in a system-wide header (syscalls.h ?) which
would be included by each files using SYSCALL_DEFINE*. Those
declarations would declare the tracepoints and therefore make sure we
spot any SYSCALL_DEFINE* change at compile-time, and we could create a
tracing module which would contain the callbacks that would register on
those syscall tracepoint declarations. This would all be type-safe,
which is a very nice thing to have, even if we don't expect the system
calls to change often at all.

Mathieu

> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
