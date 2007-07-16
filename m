Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbXGPUHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbXGPUHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbXGPUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:07:06 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:48124 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760614AbXGPUHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:07:04 -0400
Date: Mon, 16 Jul 2007 16:07:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux@bohmer.net, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070716200700.GA1119@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:53:08 up 9 days,  9:58,  4 users,  load average: 0.20, 0.26, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Remy Bohmer (l.pinguin@gmail.com) wrote:
> Hello,
> 
> I am looking for some tool/kernel machanism that enables me to track
> every schedule change on the CFS scheduler of the RT-kernel for some
> period of time.
> Thus a tool that gives me an overview after some time which task got
> "scheduled in/out" at "which timestamp" and at "which CPU". ( I need
> the raw data)
> 
> In a far past (on Montavista kernels) I used LTT for this to log for
> some time with only the SCHED_CHANGE filter and text output. But, I
> cannot find any LTT(ng) support for any RT-kernel, and support for the
> new CFS (like in 2.6.22.1-rt4) is even harder.
> 
> So I was wondering if anybody knows some tool/kernel mechanism which
> can do this?
> If not, I will build a kernel extension for it myself (new extension
> to 'latency_trace' ?)
> In that case can anybody with in depth CFS scheduler knowledge please
> point me which hooks are safe to use for this?
> 
> I need it to get a detailed insight in my RT-system with its RT and
> non-RT applications.
> Thus to know when a certain task gets scheduled (and to calculate its
> per thread min/max/avg latencies), which task preempts another task,
> and to get a complete overview of what the RT system (and scheduler)
> is doing during time etc.
> 

Hi Remy,

I think Thomas may have worked on a port of recent LTTng to the -RT
kernel.

If not, I think you needs are quite easy to fulfill with a small amount
of work.

Basically, you could take a recent copy of LTTng, which comes in a set
of logically separated patches:

http://ltt.polymtl.ca/lttng/patch-2.6.22-rc4-mm2-lttng-0.9.10.tar.bz2

Follow the Compatibility List to see which other packages you need
(ltt-control and lttv) :
http://ltt.polymtl.ca/svn/ltt/branches/poly/doc/developer/lttng-lttv-compatibility.html

Then, when applying the LTTng patches to the -RT kernel, a few things
must be taken care of:

1 - "instrumentation" patches : you won't care about most of the
rejects, since you only care about the schedule() calls.

2 - You'll have to see how schedule() is instrumented and port that to
the CFS.

3 - Make sure the Linux Kernel Markers (linux/marker.h) _really_ call
preempt_disable()/preempt_enable() (is it a underscored function in
-rt ?). It is used for correct teardown of probe handlers with
synchronize_sched(). Probe sites execute very quickly, do it won't add
significant latency to your system.

4 - Ping me for problematic rejects.

Mathieu

> 
> Kind Regards,
> 
> Remy Böhmer
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
