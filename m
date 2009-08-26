Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZHZATK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZHZATK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbZHZATI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:19:08 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36481 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbZHZATF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tepv6P8TJN2pp4A9Fe532R9/jRuBrgA4beys3MJ+ZA57CLIetwlYXfvGloEOTSGZd4
         TBMLCA32u4/LWrRsQRfRRuepW4Hxm24Ny3qbcFeA615VM20ISHI4OgJIJO+3wNZ7RpxT
         q9dTHpykw/sD/mQMZ9pkwYwzYIMeBQnTgB9TA=
Date: Wed, 26 Aug 2009 02:19:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826001902.GC9953@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <20090825194219.GA8215@nowhere> <20090825195111.GB13712@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825195111.GB13712@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:51:11PM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Tue, Aug 25, 2009 at 02:31:19PM -0400, Mathieu Desnoyers wrote:
> > > (Well, I do not have time currently to look into the gory details
> > > (sorry), but let's try to take a step back from the problem.)
> > > 
> > > The design proposal for this kthread behavior wrt syscalls is based on a
> > > very specific and current kernel behavior, that may happen to change and
> > > that I have actually seen proven incorrect. For instance, some
> > > proprietary Linux driver does very odd things with system calls within
> > > kernel threads, like invoking them with int 0x80.
> > > 
> > > Yes, this is odd, but do we really want to tie the tracer that much to
> > > the actual OS implementation specificities ?
> > 
> > 
> > I really can't see the point in doing this. I don't expect the kernel
> > behaviour to change soon and have explicit syscalls interrupts done
> > from it. It's not about a current kernel implementation fashion,
> > it's about kernel design sanity that is not likely to go backward.
> > 
> > Is it worth it to trace kernel threads, maintain their tracing
> > specificities (such as workarounds with ret_from_fork that implies)
> > just because we want to support tracing on some silly proprietary drivers?
> > 
> > 
> > > 
> > > That sounds like a recipe for endless breakages and missing bits of
> > > instrumentation.
> > >
> > > So my advice would be: if we want to trace the syscall entry/exit paths,
> > > let's trace them for the _whole_ system, and find ways to make it work
> > > for corner-cases rather than finding clever ways to diminish
> > > instrumentation coverage.
> > 
> > 
> > If developers of out of tree drivers want to implement buggy things
> > that would never be accepted after a minimal review here, and then instrument
> > their bugs, then I would suggest them to implement their own ad hoc instrumentation,
> > really :-/
> > 
> > What's the point in supporting out of tree bugs?
> > 
> > Well, the only advantage of doing this would be to support reverse engineering
> > in tiny and rare corner cases. Not that worth the effort.
> > 
> >  
> > > Given the ret from fork example happens to be the first event fired
> > > after the thread is created, we should be able to deal with this problem
> > > by initializing the thread structure used by syscall exit tracing to an
> > > initial "ret from fork" value.
> > > 
> > > Mathieu
> > 
> > 
> > It means we have to support and check this corner case in every archs
> > that support syscall tracing, deal with crashes because we omitted it, etc...
> > 
> > For all the things I've explained above I don't think it's worth the effort.
> > 
> > But it's just my opinion...
> > 
> 
> Then we might want to explicitly require that calls to sys_*() system
> calls made from within the kernel pass through another instrumentation
> mechanism. IMHO, that would make sense. It would cover both system calls
> made from kernel threads and system calls made from within a system call
> or trap.
> 
> Mathieu


Well, we can't really set a tracepoint per sys_*() function. Or more
precisely we already have them, automagically generated and relying on
sysenter ptrace path.

But if we want to check which syscalls are called from kernel threads, we have:

- kthread() -> do_exit()


The entry point of every kernel threads (except "kthreadd") is
kthread(). It calls do_exit() in the end.

If we want to trace the exit of a kernel thread, we can put
a tracepoint there instead of do_exit() which results would
be intermixed with sys_exit() tracing.


- kthreadd :: create_kthread() -> kernel_thread() -> do_fork()


A creation of a thread is the result of the kthreadd thread fork().
If we want to trace the creation of kernel threads, we can again do that
in the upper level: kernel_thread().

But does that inform us about who created the thread? All we would see
is kthreadd that forks. This is a very poor information compared
to a userspace fork() that tells us who really created the new process.

Instead what we want is probably to trace kthread_create() which inserts the
job of a thread creation in the kthreadd thread, so that we know
_who_ asked for this thread creation (process that requested it and callsite).
And that's much more rich in information.

Well, you can even climb in an upper layer and look if this is a workqueue,
a kernel/async.c thread, a slow work, etc...


- kernel_execve() -> sys_execve()

We can execute user apps from kernel through call_usermodehelper().
And we can trace kernel_execve() or again in an upper layer
like call_usermodehelper()

- ... I guess there are other examples

The kernel calls syscalls through wrappers, and tracing these wrappers,
depending of the desired level of informations we want (choose your layer),
are much more verbose / rich in informations.

