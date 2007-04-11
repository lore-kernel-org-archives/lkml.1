Return-Path: <linux-kernel-owner+w=401wt.eu-S1030495AbXDKUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030495AbXDKUl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030735AbXDKUl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:41:28 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:41068 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030495AbXDKUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:41:27 -0400
Date: Wed, 11 Apr 2007 16:41:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] markers-linker-generic
Message-ID: <20070411204125.GB7484@Krystal>
References: <20070410223658.GC7092@Krystal> <20070411074414.GC3752@flint.arm.linux.org.uk> <20070411175110.GA30879@Krystal> <20070411110240.537ee25d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070411110240.537ee25d.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 16:40:59 up 68 days, 10:48,  4 users,  load average: 1.30, 1.16, 1.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 11 Apr 2007 13:51:11 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > What's this marker stuff about?
> > > 
> > 
> > Hi Russel,
> > 
> > Here is an overview :
> 
> I am told that the systemtap developers plan to (or are) using this
> infrastructure.
> 
> If correct: what is their reason for preferring it over kprobes?
> 
> 
> Secondly, the code in -mm has no actual backend for delivering anything to
> userspace or to anywhere else.  Why is this?  Which backends currently
> exist, and which ones are envisaged?  Is there a plan to merge any backend
> into the mainline kernel?
> 

Here is more context around this :


With the increasing complexity of today's user-space application and the
wide deployment of SMP systems, the users need an increasing
understanding of the behavior and performances of a system across
multiple processes/different execution contexts/multiple CPUs. In
applications such as large clusters (Google, IBM), video acquisition
(Autodesk), embedded real-time systems (Wind River, Monta Vista, Sony)
or sysadmin/programmer-type tasks (SystemTAP from Redhat), a tool that
permits tracing of kernel-user space interaction becomes necessary.

Usage of such tools have been made to successfully pinpoint problems such
as : latency issues in a user-space video acquisition application,
slowdown problems in large clusters due to a switch to a different
filesystems with a different cache size, abnormal Linux scheduler latency
(just to name a few that I have personally investigated).

The currently existing solutions does not give a system-wide overview of
what - and when - things are happening on the system. Ptracing a program
works with few processes, but quickly becomes useless when it
comes to keeping track of many processes.

Bugs occuring because of bad interaction of such complex systems can be
very hard to find due to the fact that they occur rarely (sometimes once
a week on hundreds of machines). One can therefore only hope at having
the best conditions to statistically reproduce the bug while extracting
information from the system. Some bugs have been successfully found at
Google using their ktrace tracer only because they could enable it on
production machines and therefore recreate the same context where the
bug happened.

Therefore, it makes sense to offer an instrumentation set of the most
relevant events occurring in the Linux that can have the smallest
performance cost possible when not active while not requiring a reboot
of a production system to activate. This is essentially what the markers
are providing.

Since we cannot limit the growth of the Linux kernel, nor can we
pre-determine each and every "interesting" instrumentation within each
subsystem and driver, it is sensible to let this task to the persons
who knows the best their code. Adding instrumentation should therefore
be as easy as adding and maintaining a "printk" in the kernel code from
the developer's point of view.

Towards a complete tracing mechanism in the Linux kernel, the markers
are only one step forward. The following step is to connect probes to
those markers that will record the tracing information in buffers
exported to user-space, organized in timestamped "events". Probe
callbacks are responsible for serializing the information passed as
parameter to the markers (described by the format string) into the
events. A control mechanism to activate/stop the tracing is required,
as well as a daemon that maps the buffers to write them to disk or send
them through the network.

Keeping track of the events also requires a centralized infrastructure :
the idea is to assign a unique ID to each event so they can be later
recognized in the trace. Keeping in mind that recording the complete
instrumentation site name string for each event would be more that
inefficient, assigning a numeric unique identifier makes sense.

Finally, support for gathering events coming from user-space, with a
minimal performance impact, is very useful to see the interaction
between the system's execution contexts.

The last steps are currently implemented in Linux Trace Toolkit Next
Generation (LTTng).

The SystemTAP project could clearly benefit from such an infrastructure
for tracing. In addition, they would be providing support for dynamic
addition of kernel probes through breakpoints/jumps when possible, with
the associated restrictions (accessing local variables, reentrancy,
speed).

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
