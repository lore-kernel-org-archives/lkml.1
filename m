Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZKCT3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZKCT3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZKCT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:29:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36284 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZKCT3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:29:07 -0500
Date: Tue, 3 Nov 2009 20:28:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clark Williams <williams@redhat.com>, Jon Masters <jcm@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf latency builtin command
Message-ID: <20091103192839.GB21023@elte.hu>
References: <20091101155500.7dd22f19@torg> <20091101155809.191a7ed6@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101155809.191a7ed6@torg>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clark, John,

* Clark Williams <williams@redhat.com> wrote:

> 
> This is the first cut at a 'perf latency' command to manage the
> hwlat_detector kernel module, used to detect hardware induced
> latencies (e.g. SMIs).
> 
> Signed-off-by: Clark Williams <williams@redhat.com>
> ---
>  tools/perf/Documentation/perf-latency.txt |   64 +++++
>  tools/perf/Documentation/perf.txt         |    2 +-
>  tools/perf/Makefile                       |    3 +
>  tools/perf/builtin-latency.c              |  383
> +++++++++++++++++++++++++++++ tools/perf/builtin.h
> |    2 +- tools/perf/command-list.txt               |    1 +
>  6 files changed, 453 insertions(+), 2 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-latency.txt
>  create mode 100644 tools/perf/builtin-latency.c
> 
> diff --git a/tools/perf/Documentation/perf-latency.txt
> b/tools/perf/Documentation/perf-latency.txt new file mode 100644
> index 0000000..f615d08
> --- /dev/null
> +++ b/tools/perf/Documentation/perf-latency.txt
> @@ -0,0 +1,64 @@
> +perf-latency(1)
> +===============
> +
> +NAME
> +----
> +perf-latency - check for hardware latencies
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'per latency' [OPTIONS]
> +
> +DESCRIPTION
> +-----------
> +This command manages the hwlat_detector kernel module, which is used
> +to test the system for hardware induced latencies. The command runs
> +for a specified amount of time (default: 60 seconds) and samples the
> +system Time Stamp Counter (TSC) register, looking for gaps which
> +exceed a threshold. If a gap exceeding the threshold is seen, a
> +timestamp and the gap (in microseconds) is printed to the standard
> +output.
> +
> +OPTIONS
> +-------
> +--duration=<n>{s,m,h,d,w}::
> +	The length of time the test should run. (default: 60 seconds)
> +
> +--window=<n>{us,ms,s,m}::
> +	The sample period for the test. (default 1 second)
> +
> +--width==<n>{us,ms,s,m}::
> +	The test time within the sample window. (default 500
> +	milliseconds)
> +
> +--threshold==<n>{us,ms,s}::
> +	Threshold above which is considered a latency. (default
> 50 microseconds) +
> +--cleanup::
> +	Force unload of hwlat_detector module and umount of debugfs.

I'm wondering whether we could do something perf event based that makes 
'perf latency' self-sufficient and eliminates the debugfs interface.

( We could still merge the first two patches in their current form as 
  they are clear improvements in terms of debugfs access within perf - 
  so no work is lost and progress is possible. )

Basically hwlat_detector is using stop_machine_run() plus a tight rdtsc 
based loop to sample what is happening in the system. Much of 
hwlat_detector.c deals with getting that information (and parameters) 
back and forth between user space and kernel space.

Couldnt we move that functionality a bit closer to perf by creating 
special events in a tight loop that generate a stream of perf events, 
and let the rest of perf events take over the details, and do the 
analysis in the user-space builtin-latency.c code?
 
Also, do we need stop_machine_run() - couldnt we do the measurement on a 
specific CPU with irqs (and NMIs) disabled [but other CPUs still 
running]?

This would all still be possible in the .33 timeframe i suspect, as what 
we need is really just a special event (via TRACE_EVENT() perhaps), and 
a way to trigger it via a 'run this many times' parameter. (i.e. event 
injection - we want to have that kind of support in perf events anyway)

This would simplify and standardize hw-latency detection, without losing 
any utility - and we wouldnt have to go via some special debugfs 
interface to access the hwlat_detect module.

Thoughts?

	Ingo
