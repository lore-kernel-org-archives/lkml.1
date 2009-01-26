Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZAZJ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZAZJ4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZAZJzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:55:54 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:36495 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZAZJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:55:52 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20090121151820.GA23813@elte.hu>
References: <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>
	 <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu>
	 <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
	 <49760E2D.2060109@redhat.com>
	 <1232547932.4895.119.camel@kulgan.wumi.org.au>
	 <49773275.3020203@redhat.com>  <20090121151820.GA23813@elte.hu>
Content-Type: text/plain; charset=UTF-8
Organization: UnitingCare Wesley Bowden
Date: Mon, 26 Jan 2009 20:25:30 +1030
Message-Id: <1232963730.4921.12.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 16:18 +0100, Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
> > It means, a scheduling problem.  Can you run the latency tracer (which 
> > only works with realtime priority), so we can tell if it is (a) kvm 
> > failing to wake up the vcpu properly or (b) the scheduler delaying the 
> > vcpu from running.
> 
> Could we please get an ftrace capture of the incident?
> 
> Firstly, it makes sense to simplify the tracing environment as much as 
> possible: for example single-CPU traces are much easier to interpret.
> 
> Can you reproduce it with just one CPU online? I.e. if you offline all the 
> other cores via:
> 
>   echo 0 > /sys/devices/system/cpu/cpu1/online
> 
>   [etc.]
> 
> and keep CPU#0 only, do the latencies still occur?
> 
> If they do still occur, then please do the traces that way.
> 
> [ If they do not occur then switch back on all CPUs - we'll sort out the
>   traces ;-) ]
> 
> Then please build a function tracer kernel, by enabling:
> 
>   CONFIG_FUNCTION_TRACER=y
>   CONFIG_FUNCTION_GRAPH_TRACER=y
>   CONFIG_DYNAMIC_FTRACE=y
> 
> Once you boot into such a kernel, you can switch on function tracing via:
> 
>   cd /debug/tracing/
> 
>   echo 0 > tracing_enabled
>   echo function_graph > current_tracer
>   echo funcgraph-proc > trace_options 
> 
> It does not run yet, first find a suitable set of functions to trace. For 
> example this will be a pretty good starting point for scheduler+KVM 
> problems:
> 
>   echo ''         > set_ftrace_filter  # clear filter functions
>   echo '*sched*' >> set_ftrace_filter 
>   echo '*wake*'  >> set_ftrace_filter
>   echo '*kvm*'   >> set_ftrace_filter
>   echo 1 > tracing_enabled             # let the tracer go
> 
> You can see your current selection of functions to trace via 'cat 
> set_ftrace_filter', and you can see all functions via 'cat 
> available_filter_functions'.
> 
> You can also trace all functions via:
> 
>   echo '*' > set_ftrace_filter
> 
> Tracer output can be captured from the 'trace' file. It should look like 
> this:
> 
>  15)   cc1-28106    |   0.263 us    |    page_evictable();
>  15)   cc1-28106    |               |    lru_cache_add_lru() {
>  15)   cc1-28106    |   0.252 us    |      __lru_cache_add();
>  15)   cc1-28106    |   0.738 us    |    }
>  15)   cc1-28106    | + 74.026 us   |  }
>  15)   cc1-28106    |               |  up_read() {
>  15)   cc1-28106    |   0.257 us    |    _spin_lock_irqsave();
>  15)   cc1-28106    |   0.253 us    |    _spin_unlock_irqrestore();
>  15)   cc1-28106    |   1.329 us    |  }
> 
> To capture a continuous stream of all trace data you can do:
> 
>   cat trace_pipe > /tmp/trace.txt
> 
> (this will also drain the trace ringbuffers.)
> 
> Note that this can be quite expensive if there are a lot of functions that 
> are traced - so it makes sense to trim down the set of traced functions to 
> only the interesting ones. Which are the interesting ones can be 
> determined from looking at the traces. You should see your KVM threads 
> getting active every second as the ping happens.
> 
> If you get lost events you can increase the trace buffer size via the 
> buffer_size_kb control - the default is around 1.4 MB.
> 
> Let me know if any of these steps is causing problems or if interpreting 
> the traces is difficult.

Just carrying out the steps was okay, but I don't really know what I'm
looking at. I've uploaded the trace here (about 10 seconds worth, I
think):

  http://disenchant.net/tmp/bug-12465/trace-1/

The guest being pinged is process 4353:

kmshanah@flexo:~$ pstree -p 4353
qemu-system-x86(4353)─┬─{qemu-system-x86}(4354)
                      ├─{qemu-system-x86}(4355)
                      └─{qemu-system-x86}(4772)

I guess the larger overhead/duration values are what we are looking for,
e.g.:

kmshanah@flexo:~$ bzgrep -E '[[:digit:]]{6,}' trace.txt.bz2 
 0)   ksoftir-4    | ! 3010470 us |  }
 0)  qemu-sy-4354  | ! 250406.2 us |    }
 0)  qemu-sy-4354  | ! 250407.0 us |  }
 0)  qemu-sy-4354  | ! 362946.3 us |    }
 0)  qemu-sy-4354  | ! 362947.0 us |  }
 0)  qemu-sy-4177  | ! 780480.3 us |  }
 0)  qemu-sy-4354  | ! 117685.7 us |    }
 0)  qemu-sy-4354  | ! 117686.5 us |  }

That ksoftirqd value is a bit strange (> 3 seconds, or is the formatting
wrong?). I guess I still need some guidance to know what I'm looking at
with this trace and/or what to do next.

Cheers,
Kevin.


