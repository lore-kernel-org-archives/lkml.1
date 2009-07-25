Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbZGYQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbZGYQmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZGYQmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:42:33 -0400
Received: from mga06.intel.com ([134.134.136.21]:60296 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbZGYQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:42:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,269,1246863600"; 
   d="scan'208";a="433307513"
Message-ID: <4A6B35F7.2030804@linux.intel.com>
Date: Sat, 25 Jul 2009 09:42:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] sched: Provide iowait counters
References: <4A64B813.1080506@linux.intel.com>	<20090724212220.afa278ee.akpm@linux-foundation.org>	<4A6A8AFE.1010608@linux.intel.com>	<20090724214006.7380c3b4.akpm@linux-foundation.org>	<4A6A8E96.7050509@linux.intel.com>	<20090724220423.11828b85.akpm@linux-foundation.org>	<1248501946.6987.146.camel@twins> <20090725002148.5524c846.akpm@linux-foundation.org>
In-Reply-To: <20090725002148.5524c846.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> What _is_ Arjan's requirement, anyway?  I don't think it's really been
> spelled out.

ok long description coming ;)

Actually we're building a tool that conceptually is two different tools, that operate at different levels,
and tool two is a zoomed in version of zoom one. I'll describe both below as if they are independent tools,
to not confuse things too much.


Tool One
--------
This can be summarized as "a better bootchart", although it's not (just) for measuring boot.
What the tool provides is a graphical overview of all process activity over a period of time
(the period of time needs to be long enough to cover a system boot, so around 10 seconds).

In this overview, time is the horizontal axis, and processes are on the vertical axis.
This overview is basically a horizontal bar per "process", that shows the name of the process. The
bar starts (X axis) when the process starts, and ends when the process ends. Bars of processes that
either start before the measurement period, or continue to live on after the measurement period
just run to the edge of the graph.

Within these bars, we make "boxes" that cover 1 millisecond (typical) of time, and these boxes get colored
depending on what kind of activity has happened.
* Shade of blue for CPU activity; basically we take the number of nanoseconds that the process executed at the beginning
   and at the end of the box, scale this to the size of the box (1 msec) to get a ratio/percentage, and then make the
   shade of blue represent this percentage. (eg if the process was running for the full msec, it gets very dark blue,
   but if it was only running for 50%, it gets a gray-ish blue)
* Shade of red for "waiting for IO"; we take the io wait nanoseconds at the beginning and end, scale this like we do cpu
   and color the box red appropriately
* Share of yellow for "waiting for the scheduler to give us a time slice"; the kernel exposes the (accumulated) time
   between wakeup and actually running, basically the scheduler delay (due to other processes running etc). Similar to
   cpu and io time, we scale this to a yellow color
(if there is more than one of these during the 1 msec activity, we have an arbitrage algorithm to resolve this)

In addition, we show a system view (at the top of the diagram for now) that shows
* For each logical cpu, how the CPU utilization is. Again in 1 msec bars, we calculate how busy each logical cpu is
   and have a bar for which the height scales with utilization
* We show the amount of IO, in megabytes per second in another bar, so that one can see how well the system is doing
   on IO throughput (we're considering splitting this into a separate display for read and write)

For the process bars to work, we need to track the name of processes as they change (fork+exec first creates a process that shares
the name with the parent process, and then during the exec changes name to the new process for example). The visualization
switches to a new bar when such a process changes name.

This tool is very useful (for us already, but I expect it's not just us) to see what is going on performance wise on a system level.
We can see that process A uses CPU, but causes the dbus process to use CPU which then causes process B to use CPU etc; we can
track performance bottlenecks/costs beyond just a single process.

Right now we're just polling every millisecond various /proc/pid files to collect this information. Will investigate
the task accounting flow to see if we can kill the polling entirely, but if we can't kill this polling entirely we'll likely need
to stick to polling, since otherwise consolidating the two sources of information gets problematic.

The current "bootchart" tool provides this mostly, but it is using the millisecond sampled data, which is so inaccurate
that major things are missed in terms of system activity, and in addition it's so heavy in how it operates that you can't
sample fine grained enough without impacting the system too much.

Tool Two
--------
This is sort of a zoomed in version of Tool One. Tool Two does not show utilization percentages, but shows a time flow
of what happens, nanosecond accurate. The same bars like in tool one, per process etc, but now we don't show boxes that represent a 
millisecond, but we start a box of blue every time a process gets scheduled, that lasts until the process gets unscheduled. Same for the
red/yellow boxes.
Ideally we also get "process A wakes up process B" information, that we can represent as little arrows in our diagram.

Tool Two also gives cpu utilization in a time format rather than in a utilization %age format.

We're using "perf" for collecting this information; for todays mainline we can collect the blue bar (When scheduled in/out) already,
and Peter has been adding the data for iowait etc in an experimental branch.



In case you wonder why you need both tools, and can't just use one: we wondered the same, but it turns out that if you only build
Tool Two, you don't get a good overview of what is going on on a higher level. It's like looking at the world via a microscope all the time,
you just don't get a good feeling what the world is like; you just can't find which areas are interesting to look at (with the microscope)/
So we provide a higher level view tool (Tool One), with the capability to zoom into what happens in minute (well.. nanosecond) detail for 
areas of interest (Tool Two).

[again, while I describe them here as separate tools, that's just for the description, the idea is that the user will see it as just one
unified tool with different zoom levels]
