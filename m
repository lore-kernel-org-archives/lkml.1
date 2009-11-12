Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZKLPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZKLPmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZKLPmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:42:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:40655 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZKLPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZVGmvEGP4crxID5D9oLRggwhKpt5H/gw6OptVRCIePfWU9cr3JfpHeSe/1IWC2QsVF
         Jr5jx9oVyq81aNY0oPmVAQeDNnEifJwiaTT/udQcgNY5pYj8Kophw4ERcPccOfzxGDDm
         iUJLhelx/44zAjbxAAuypzqBINEG7QDVvqdIE=
Date: Thu, 12 Nov 2009 16:42:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091112154221.GD5237@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <20091105153404.GB3229@in.ibm.com> <20091105210652.GF4877@nowhere> <20091108173205.GC4465@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108173205.GC4465@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 11:02:05PM +0530, K.Prasad wrote:
> On Thu, Nov 05, 2009 at 10:06:55PM +0100, Frederic Weisbecker wrote:
> > > Can't it be cpumask_t instead of int cpu? Given that per-cpu breakpoints
> > > will be implemented, it should be very different to implement them for a
> > > subset of cpus too.
> > 
> > I can't figure out any usecase where we want to only bind to,
> > say, cpu 1 and 3 or any kind of such strange combination.
> > 
> > Either we want a wide breakpoint, or we want to profile
> > a single cpu, but I don't imagine we need a middle case.
>  
> When we originally had this discussion on LKML, one of the use-cases
> cited was http://lkml.org/lkml/2009/7/29/243. I can't see why such
> need should be restricted to a given CPU only, rather than a subset of
> CPUs (say 'x' is a variable normally read/written-to in the interrupt
> path, and if the said interrupt is has a cpu affinity to a subset of
> cpus only).
>
> Although in the normal case, this feature could be implemented later, in
> case of breakpoints we accept that as input from the user (and hence
> part of the well-defined interface), so it is better to design it for
> a subset of CPUs from start. The logic isn't very different and given that
> there are plenty of helper routines in cpumask.h the implementation is easy too.


Well, if one day someone wants to profile a subset of cpus and then need
this feature, I'll implement it. But I don't think we should anticipate
every possible corner usecases for now.

It's not possible to request that from any user interface anyway
(either ptrace, perf or ftrace). And if it becomes needed for in-kernel
use, then it's trivial to change.

 
> > If we want to lock such path, we probably more likely want a mutex.
> > Registering a breakpoint is not a fastpath and also perf does
> > some sleepable things while creating a counter.
> > 
> > The check to register constraints, which is part of this path,
> > is itself a mutex.
> > 
> > But we'll probably need something NMI safe in the future so
> > that it can be used without any problem by kgdb.
> > 
> 
> I suspect that it will be required for cpu-hotplug handler, where
> previously load_debug_registers() was called from a softirq context.


Nop. There is no register/unregister on cpu hotplug time.
Perf will just reschedule the events on that cpu (through
pmu::enable/disable calls).


 
> > > I'm assuming that there'd be an implementation for system-wide
> > > perf-events (and hence breakpoints) in the forthcoming version(s) of
> > > this patchset.
> > 
> > 
> > If that becomes a necessary feature, then yeah.
> > 
> > 
> 
> Apart from the several benefits of having system-wide perf-events,
> implementing them in the first iteration itself will
> help us fully realise the cost of perf-events + hw-breakpoint
> integration! When implemented, perf-events will also be ready to
> accomodate future users (apart from bp and perf-top) having a
> need for system-wide counter.


For now this is meant to be costly (wrt cross cpu contention)
as I explained you before.

But if the ftrace ring buffer becomes integrated by perf (which
seem to be in the plans), then yeah this may become a very useful
feature because we could use a single counter for wide profiling
without the cost of the cpu contention (ftrace ring buffer is
per cpu and fully lockless).

Thanks.

