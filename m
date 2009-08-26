Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbZHZAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbZHZAmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932271AbZHZAmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:42:50 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:64488 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155AbZHZAmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:42:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooFAHQelEpMROOX/2dsb2JhbACBU9cEgiiBcgU
Date: Tue, 25 Aug 2009 20:42:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826004248.GA5793@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <20090825194219.GA8215@nowhere> <20090825195111.GB13712@Krystal> <20090826001902.GC9953@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090826001902.GC9953@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:34:27 up 7 days, 11:23,  2 users,  load average: 0.11, 0.37,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Tue, Aug 25, 2009 at 03:51:11PM -0400, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Tue, Aug 25, 2009 at 02:31:19PM -0400, Mathieu Desnoyers wrote:
> > > > (Well, I do not have time currently to look into the gory details
> > > > (sorry), but let's try to take a step back from the problem.)
> > > > 
> > > > The design proposal for this kthread behavior wrt syscalls is based on a
> > > > very specific and current kernel behavior, that may happen to change and
> > > > that I have actually seen proven incorrect. For instance, some
> > > > proprietary Linux driver does very odd things with system calls within
> > > > kernel threads, like invoking them with int 0x80.
> > > > 
> > > > Yes, this is odd, but do we really want to tie the tracer that much to
> > > > the actual OS implementation specificities ?
> > > 
> > > 
> > > I really can't see the point in doing this. I don't expect the kernel
> > > behaviour to change soon and have explicit syscalls interrupts done
> > > from it. It's not about a current kernel implementation fashion,
> > > it's about kernel design sanity that is not likely to go backward.
> > > 
> > > Is it worth it to trace kernel threads, maintain their tracing
> > > specificities (such as workarounds with ret_from_fork that implies)
> > > just because we want to support tracing on some silly proprietary drivers?
> > > 
> > > 
> > > > 
> > > > That sounds like a recipe for endless breakages and missing bits of
> > > > instrumentation.
> > > >
> > > > So my advice would be: if we want to trace the syscall entry/exit paths,
> > > > let's trace them for the _whole_ system, and find ways to make it work
> > > > for corner-cases rather than finding clever ways to diminish
> > > > instrumentation coverage.
> > > 
> > > 
> > > If developers of out of tree drivers want to implement buggy things
> > > that would never be accepted after a minimal review here, and then instrument
> > > their bugs, then I would suggest them to implement their own ad hoc instrumentation,
> > > really :-/
> > > 
> > > What's the point in supporting out of tree bugs?
> > > 
> > > Well, the only advantage of doing this would be to support reverse engineering
> > > in tiny and rare corner cases. Not that worth the effort.
> > > 
> > >  
> > > > Given the ret from fork example happens to be the first event fired
> > > > after the thread is created, we should be able to deal with this problem
> > > > by initializing the thread structure used by syscall exit tracing to an
> > > > initial "ret from fork" value.
> > > > 
> > > > Mathieu
> > > 
> > > 
> > > It means we have to support and check this corner case in every archs
> > > that support syscall tracing, deal with crashes because we omitted it, etc...
> > > 
> > > For all the things I've explained above I don't think it's worth the effort.
> > > 
> > > But it's just my opinion...
> > > 
> > 
> > Then we might want to explicitly require that calls to sys_*() system
> > calls made from within the kernel pass through another instrumentation
> > mechanism. IMHO, that would make sense. It would cover both system calls
> > made from kernel threads and system calls made from within a system call
> > or trap.
> > 
> > Mathieu
> 
> 
> Well, we can't really set a tracepoint per sys_*() function. Or more
> precisely we already have them, automagically generated and relying on
> sysenter ptrace path.
> 
> But if we want to check which syscalls are called from kernel threads, we have:
> 
> - kthread() -> do_exit()
> 
> 
> The entry point of every kernel threads (except "kthreadd") is
> kthread(). It calls do_exit() in the end.
> 
> If we want to trace the exit of a kernel thread, we can put
> a tracepoint there instead of do_exit() which results would
> be intermixed with sys_exit() tracing.
> 
> 
> - kthreadd :: create_kthread() -> kernel_thread() -> do_fork()
> 
> 
> A creation of a thread is the result of the kthreadd thread fork().
> If we want to trace the creation of kernel threads, we can again do that
> in the upper level: kernel_thread().
> 
> But does that inform us about who created the thread? All we would see
> is kthreadd that forks. This is a very poor information compared
> to a userspace fork() that tells us who really created the new process.
> 
> Instead what we want is probably to trace kthread_create() which inserts the
> job of a thread creation in the kthreadd thread, so that we know
> _who_ asked for this thread creation (process that requested it and callsite).
> And that's much more rich in information.
> 
> Well, you can even climb in an upper layer and look if this is a workqueue,
> a kernel/async.c thread, a slow work, etc...
> 
> 
> - kernel_execve() -> sys_execve()
> 
> We can execute user apps from kernel through call_usermodehelper().
> And we can trace kernel_execve() or again in an upper layer
> like call_usermodehelper()
> 
> - ... I guess there are other examples
> 
> The kernel calls syscalls through wrappers, and tracing these wrappers,
> depending of the desired level of informations we want (choose your layer),
> are much more verbose / rich in informations.
> 

What you describe looks a lot like the approach I use in the LTTng tree.
Actually, the main point I am trying to make here is: if we rely only on
tracing at the syscall entry/exit level for, say, monitoring all uses of
e.g. sys_open(), we might be caught offguard by internal sys_open() uses
within the kernel.

sys_open if just an example (and possibly a bad one), but I am just
saying that syscall entry/exit tracing should not be seen as a complete
replacement of tracepoints added within the most important system call
sites if we plan to keep track of the overall kernel activity.

But we can do that incrementally, and it's only partially related to
syscall entry/exit instrumentation. Actually, if we find out that we
have to add instrumentation within the kernel code for a relatively
large quantity of system calls, going through the current effort to
extract the system call arguments might be unnecessary if we eventually
end up extracting those arguments from tracepoints placed in the sys_*()
implementation.

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
