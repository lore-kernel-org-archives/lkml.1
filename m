Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbYDYNRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbYDYNRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 09:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYDYNRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 09:17:22 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:51539 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbYDYNRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 09:17:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEACd3EUhMROPA/2dsb2JhbACBUqp8
Date: Fri, 25 Apr 2008 09:17:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [RFC] system-wide in-kernel syscall tracing
Message-ID: <20080425131717.GA8034@Krystal>
References: <20080424150324.802695381@polymtl.ca> <20080424151407.622943449@polymtl.ca> <20080424230238.GA11699@martell.zuzino.mipt.ru> <y0mve26r874.fsf@ton.toronto.redhat.com> <20080425125607.GC28411@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080425125607.GC28411@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:09:10 up 56 days,  9:20,  5 users,  load average: 0.56, 0.47,
	0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > >
> > > Those which are close enough to system call boundary are essentially
> > > strace(1).
> > 
> > Those may not sound worthwhile to put a marker for, BUT, you're
> > ignoring the huge differences of impact and scope.  A system-wide
> > marker-based trace (filtered a la systemtap if desired) can be done
> > with a tiny fraction of system load and none of the disruption caused
> > by an strace of all the processes.
> > 
> 
> I agree with both ;) Actually we need a low-overhead hook in
> syscall_trace(), so we can perform efficient system-wide tracing of
> system calls. I'll dig in this as soon as I find time.
> 
> Basic ideas :
> 
> - I already have the TIF_KERNEL_TRACE thread flag added to all
>   architectures in another patchset.
> - We add a function called on TIF_KERNEL_TRACE, from do_syscall_trace(),
>   which is architecture-specific. It's basically a big switch() for all
>   system calls. syscalls which takes similar types could be grouped
>   together, but I don't think it would be useful at all. It might be
>   better just to add a trace_mark for each so we extract the syscall
>   fields in the marker string.
> - We perform the page fault (caused by strings and structures) reads on
>   the spot, because we prefer not to do this in atomic context.
> - We put a marker, e.g., for x86_32, a pseudo-code like :
> 
> syscall_trace_enter()
> {
>   ...
>   if (test_thread_flag(TIF_KERNEL_TRACE))
>     do_marker_syscall_trace();
>   ...
> }
> 
> do_marker_syscall_trace()
> {
>   char *tmpbuf;
> 
>   switch(regs->orig_ax) {
> 
>   case SYS_OPEN:
>     tmpbuf = vmalloc(4096); /* what size is needed ? */
>     copy_from_user(tmpbuf, regs->bx);
>     trace_mark(sys_open, "filename %p flags %d mode %d",

Actually, I meant :
     trace_mark(sys_open, "filename %s flags %d mode %d",

and it would be even better to pass the __user pointer directly to the
probe to eliminate the copy. I think this could be done by making sure
the memory is faulted-in and locked when we call the trace_mark. It
could require to think of a way to specify a weird format string type
though, so an automated tracer would use strncpy_from_user in atomic and
al instead of trying to dereference the userspace pointer directly.

Mathieu

>       tmpbuf, regs->cx, regs->dx);
>     vfree(tmpbuf);
>     break;
>   }
> }
> 
> Modulo some optimization, what do you think of this ? If someone is
> willing to implement this, I can provide the patchset for
> TIF_KERNEL_TRACE.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
