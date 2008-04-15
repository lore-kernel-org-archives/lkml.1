Return-Path: <linux-kernel-owner+w=401wt.eu-S1765020AbYDONrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765020AbYDONrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYDONrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:47:09 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:62298 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbYDONrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:47:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEALNOBEhMQWoK/2dsb2JhbACBXqs9
Date: Tue, 15 Apr 2008 09:47:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415134705.GB22351@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080415131744.GA5248@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:26:00 up 46 days,  9:36,  5 users,  load average: 0.11, 0.24,
	0.25
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > Because we extract the field names and types, we can create tracer 
> > > plugins that would hook on field names rather than expect a specific 
> > > number of fields and fixed field types. It makes it possible to 
> > > tolerate missing fields pretty easily. But yes, tracer tools might 
> > > have to be adapted to internal kernel changes, since they must 
> > > follow kernel structure changes. However, staying as close as 
> > > possible to a canonical representation of event fields, staying far 
> > > from the specific implemetation, would help to lessen the 
> > > inter-dependency. On the other hand, it would probably hurt trace 
> > > compactness and efficiency.
> > 
> > See, these tracer tools are my nightmare as member of an enterprise 
> > linux team. They'll make an already hard job even harder, no thanks!
> 
> i'm clearly NAK-ing all futex trace hooks until the true impact of the 
> whole marker facility is better understood. I've tried them for the 
> scheduler and they were a clear failure: too bloated and too persistent.
> 

I have not seen any counter argument for the in-depth analysis of the
instruction cache impact of the optimized markers I've done. Arguing
that the markers are "bloated" based only on "size kernel/sched.o"
output is a bit misleading.

> but more importantly, as things stand today i've yet to see a _any_ 
> bugreport where these 'tracer' tools that are being referred to were 
> actually used in the field to fix something. The latency tracers (and 
> the other tracer variants in -rt) on the other hand have a documented 
> track record of being useful in fixing bugs and instrumenting the 
> kernel.
> 

You will probably be interested in the following paper, which explains
various situations in which using a tracer has solved real problems at
Google, IBM, Autodesk, which are Linux users running large clusters or
Linux systems with soft RT constraints.

Linux Kernel Debugging on Google-sized clusters at Ottawa Linux Symposium 2007 
http://ltt.polymtl.ca/papers/bligh-Reprint.pdf

Now for some performance impact :

Here are some results I have taken comparing the optimized markers
approach with the dynamic ftrace approach. These runs with some ALU work
in tight loops, using clflush() to flush the cache lines pointing to
"global" data (pointer read : current->pid) used in the loop. I also
have the numbers for running the loop without the ALU work, but I leave
them out since they only make the tables harder to read : basically, the
cached impact for running the empty loop with markers or ftrace
instrumentation is about 0 to 3 cycles. It's the uncached impact which
clearly makes the difference between both approaches.

On AMD64, adding the markers or ftrace statement actually accelerates
the runs when executed with an ALU work baseline. It adds 1 to 2 cycles
with executed alone in the loop without any work.

Frank Ch. Eigler is preparing some macrobenchmarks. I hope he will find
time to post them soon.

Results in cycles per loop

baseline :
Cycles for ALU loop                    28.10013
(will be substracted for cached runs)

Cycles for clflush() and ALU loop     230.11087
(will be substracted from non-cached runs)

gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15), -O2

------------------------------------------------------------------------------
|x86 Pentium 4, 3.0GHz, Linux 2.6.25-rc7           |  cached    |  uncached  |
------------------------------------------------------------------------------
|Added cycles for optimized marker                 |  0.002     |   0.07     |
|Added cycles for normal marker                    |  0.004     | 154.7      |
|Added cycles for stack setup + (1+4 bytes) NOPs   |            |            |
|(6 local vars)                                    |  0.035     |   0.6      |
|Added cycles for stack setup + (1+4 bytes) NOPs   |            |            |
|(1 pointer read, 5 local vars)                    |  0.030     | 222.8      |
------------------------------------------------------------------------------

Results in cycles per loop

baseline :
Cycles for ALU and loop                 25.32369
(will be substracted for cached runs)

Cycles for clflush() and ALU loop      118.24227
(will be substracted from non-cached runs)

gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21), -O2

------------------------------------------------------------------------------
|AMD64, 2.0GHz, Linux 2.6.25-rc7                   |  cached    |  uncached  |
------------------------------------------------------------------------------
|Added cycles for optimized marker                 | -1.0       |    0.2     |
|Added cycles for normal marker                    | -0.3       |   41.8     |
|Added cycles for stack setup + (1+4 bytes) NOPs   | -0.5       |    0.01    |
|(6 local vars)                                    |            |            |
|Added cycles for stack setup + (1+4 bytes) NOPs   |  2.7       |   51.8     |
|(1 pointer read, 5 local vars)                    |            |            |
------------------------------------------------------------------------------

test bench at : http://ltt.polymtl.ca/svn/markers-test/

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
