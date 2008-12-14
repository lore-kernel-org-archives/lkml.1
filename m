Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYLNOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYLNOnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 09:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYLNOne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 09:43:34 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:58914 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYLNOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 09:43:33 -0500
From: Henrik Austad <henrik@austad.us>
To: "Ma, Chinang" <chinang.ma@intel.com>
Subject: Re: CFS scheduler OLTP perforamnce
Date: Sun, 14 Dec 2008 15:43:06 +0100
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       Chris Mason <chris.mason@oracle.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com> <1229089100.25485.5.camel@twins> <BC02C49EEB98354DBA7F5DD76F2A9E80030A789771@azsmsx501.amr.corp.intel.com>
In-Reply-To: <BC02C49EEB98354DBA7F5DD76F2A9E80030A789771@azsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812141543.06846.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 22:45:11 Ma, Chinang wrote:

*snip*

> >> > We are evaluating the CFS OLTP performance with 2.6.28-c7 kernel. In
> >> > this workload once a database foreground process commit a transaction
> >> > it will signal the log writer process to write to the log file.
> >> > Foreground processes will wait until log writer finish writing and
> >> > wake them up. With hundreds of foreground process running in the
> >> > system, it is important that the log writer get to run as soon as data
> >> > is available.
> >> >
> >> > Here are the experiments we have done with 2.6.28-rc7.
> >> > 1. Increase log writer priority "renice -20 <log writer pid>" while
> >> > keeping all other processes running in default CFS priority. We get a
> >> > baseline performance with log latency (scheduling + i/o) at 7 ms.
> >>
> >> Is this better or the same than nice-0 ?
>
> I left out one detail of the database processes. There are also data
> writers that responsible for write back dirty buffers to free up buffer for
> new transactions. These processes also need to be renice to higher priority
> (-19). When data writers are left at nice-0, the workload was throttle by
> the limited number of free buffers and we cannot even fully utilize the
> system. I had to renice data writer and log writer process.
>
> >> > 2. To reduce log latency, we set log writer to SCHED_RR with higher
> >> > priority. We tried "chrt -p 49  <log writer pid>" and got 0.7% boost
> >> > in performance with log latency reduced to 6.4 ms.

What is the time needed to actually write the data to disk?

> >
> >BTW, 6.4ms schedule latency sounds insanely long for a RR task, are you
> >running a PREEMPT=n kernel or something?
>
> The 6.4ms log write latency was measured in the foreground process. It went
> like this: 
> 1. Foreground progress get start time and post log writer, 
> foreground wait and sleep. 
> 2. log writer was scheduled and collect log 
> data.
> 3. log writer write to log file and wait for i/o.
> 4. Write completed. log writer use vector post to wake up all the waiting
> foreground process. 
> 5. Foreground process wake up and get end time. 

OK, let me see if I got this right:
- You have a foreground process that runs with normal priority (i.e. +19 
to -20)
- This process appends data to a buffer, records the time and signals the 
log-writer to flush the buffer to disk as soon as possible
- The log-writer is awoken, writes the buffer to disk, signals the foreground 
process that the job is done and exits.
- The foregorund process records the time when it is awoken.

Is this really a kernel-scheduler problem? Or is it an error in the way the 
timestamps are recoreded?

Does not the time recorded then depend upon how the foreground process is 
scheduled, and not the log-writer? What happens if you log the time at the 
start and end of the log-writer function? Then you would get the time-delta 
between signaling and rr-wakeup, as well as time spent writing buffer to 
disk. By using the final timestamp in the foreground process, you'd get the 
latency for the last foreground-process wakeup as well.

Or am I completely missing the point here?

> >How would you characterize the log tasks behaviour?
> >
> > - does it run long/short (any quantization)
>
> There were 371 log writes per second so ~2.7ms per log writer execution.
> Out of this we know ~2.13 ms was spent waiting for log file i/o. Log writer
> was running for (2.7ms - 2.13ms) = 0.57ms
>
> > - does it sleep long/short - how does it compare to its runtime?
>
> With the current throughput, log writer should be constantly writing log
> and rarely sleep.
>
> > - does it wake others?
> >   - if so, always the one who woke it, or multiple others?
>
> Log writer wake multiple foreground processes using vector post.

So, you don't really know if the initial process that recorded the timestamp 
is the one who is awoken - so the time taken could be *very* long?

henrik
