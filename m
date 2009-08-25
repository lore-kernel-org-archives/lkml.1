Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZHYTvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZHYTvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZHYTvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:51:12 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:58720 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZHYTvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:51:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFACHYk0pMROOX/2dsb2JhbACBU9dAhBoF
Date: Tue, 25 Aug 2009 15:51:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825195111.GB13712@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <20090825194219.GA8215@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825194219.GA8215@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:47:43 up 7 days,  6:37,  2 users,  load average: 0.37, 0.35,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Tue, Aug 25, 2009 at 02:31:19PM -0400, Mathieu Desnoyers wrote:
> > (Well, I do not have time currently to look into the gory details
> > (sorry), but let's try to take a step back from the problem.)
> > 
> > The design proposal for this kthread behavior wrt syscalls is based on a
> > very specific and current kernel behavior, that may happen to change and
> > that I have actually seen proven incorrect. For instance, some
> > proprietary Linux driver does very odd things with system calls within
> > kernel threads, like invoking them with int 0x80.
> > 
> > Yes, this is odd, but do we really want to tie the tracer that much to
> > the actual OS implementation specificities ?
> 
> 
> I really can't see the point in doing this. I don't expect the kernel
> behaviour to change soon and have explicit syscalls interrupts done
> from it. It's not about a current kernel implementation fashion,
> it's about kernel design sanity that is not likely to go backward.
> 
> Is it worth it to trace kernel threads, maintain their tracing
> specificities (such as workarounds with ret_from_fork that implies)
> just because we want to support tracing on some silly proprietary drivers?
> 
> 
> > 
> > That sounds like a recipe for endless breakages and missing bits of
> > instrumentation.
> >
> > So my advice would be: if we want to trace the syscall entry/exit paths,
> > let's trace them for the _whole_ system, and find ways to make it work
> > for corner-cases rather than finding clever ways to diminish
> > instrumentation coverage.
> 
> 
> If developers of out of tree drivers want to implement buggy things
> that would never be accepted after a minimal review here, and then instrument
> their bugs, then I would suggest them to implement their own ad hoc instrumentation,
> really :-/
> 
> What's the point in supporting out of tree bugs?
> 
> Well, the only advantage of doing this would be to support reverse engineering
> in tiny and rare corner cases. Not that worth the effort.
> 
>  
> > Given the ret from fork example happens to be the first event fired
> > after the thread is created, we should be able to deal with this problem
> > by initializing the thread structure used by syscall exit tracing to an
> > initial "ret from fork" value.
> > 
> > Mathieu
> 
> 
> It means we have to support and check this corner case in every archs
> that support syscall tracing, deal with crashes because we omitted it, etc...
> 
> For all the things I've explained above I don't think it's worth the effort.
> 
> But it's just my opinion...
> 

Then we might want to explicitly require that calls to sys_*() system
calls made from within the kernel pass through another instrumentation
mechanism. IMHO, that would make sense. It would cover both system calls
made from kernel threads and system calls made from within a system call
or trap.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
