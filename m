Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYEEK7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYEEK7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYEEK7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:59:19 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:35701 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998AbYEEK7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:59:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMFABaFHkhMROPA/2dsb2JhbACBU6g3
Date: Mon, 5 May 2008 06:59:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080505105915.GA26444@Krystal>
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080505065559.GD3350@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:46:19 up 66 days,  6:57,  4 users,  load average: 0.31, 0.56,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Ingo,
> > 
> > I looked at the system call instrumentation present in LTTng lately. I 
> > tried different solutions, e.g. hooking a kernel-wide syscall trace in 
> > do_syscall_trace, but it appears that I ended up re-doing another 
> > syscall table, which consists of specialized functions which extracts 
> > the string and data structure parameters from user-space. Since code 
> > duplication is not exactly wanted, I think that the original approach 
> > taken in my patchset, which is to instrument the kernel code at the 
> > sys_* level (e.g. sys_open), which is the earliest level where the 
> > parameter information is made available to the kernel, is still the 
> > best way to go.
> 
> hm, i'm not sure about this. I've implemented system call tracing in -rt 
> [embedded in the latency tracer] and it only needed changes in entry.S, 
> not in every system call site. Now, granted, that tracer was simpler 
> than what LTTng tries to do, but do we _really_ need more complexity? A 
> trace point that simply expresses:
> 
>    sys_call_event(int sysno, long param1, long param2, long param3,
>                              long param4, long param5, long param6);
> 

That would work for all system calls that doesn't have parameters like
"const char __user *filename".

> would be more than enough in 99% of the cases.

Hrm, not sure about that :

grep asmlinkage include/linux/syscalls.h|wc -l
321

grep -e asmlinkage.*__user include/linux/syscalls.h | wc -l
162

So about 50% of system calls have to get pointers from userspace.


> If you want to extract 
> the strings from the system call table, to make the filtering of these 
> syscall events easier, do it during build time (by for example modifying 
> the __SYSCALL() macros in unistd.h), instead of a parallel syscall 
> table.
> 

The goal of my second syscall table was to call callbacks to extract the
__user parameters, nothing else, really. I currently extract the system
call function names by iterating on the real system call table and by
using kallsyms (it could be turned into a built-time extraction since
the system call table is static to the kernel core).

> OTOH, as long as it's just one simple nonintrusive line per syscall, 
> it's not a big deal - as long as it only traces the parameters as they 
> come from the syscall ABI - we wont change them anyway. I.e. hide the 
> ugly string portion, just turn them into a simple:
> 
>   trace_sys_getpid();
>   trace_sys_time(tloc);
>   trace_sys_gettimeofday(tz, tv);
> 
> (although even such a solution would still need a general policy level 
> buy-in i guess - we dont want half of the syscalls traced, the other 
> half objected to by maintainers. So it's either all or nothing.)
> 

Yup. That's ok with me.


> and the question also arises: why not do this on a debuginfo level? This 
> information can be extracted from the debuginfo. We could change 
> 'asmlinkage' to 'syscall_linkage' to make it clear which functions are 
> syscalls.

Given we already have the syscall table, I am not sure we would need any
supplementary debuginfo support. Plus, the syscall table gives us the
mapping between the syscall number and the symbol of the system call
function, which is exactly what we need. The only thing I dislike in my
current approach is that I depend on kallsyms; it would be good to have
the system call symbols without depending on it.

Mathieu

> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
