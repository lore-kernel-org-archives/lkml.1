Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZIGLBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZIGLBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZIGLBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:01:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34057 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZIGLBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RHdFawpkCk/VWc1lzW2L7flj9wdLN9IDUVfPyAo9v1GkQDP+t98tCoJBMlDXELGyOv
         CvN3d943LnJ8ToMTTYLzay5V35XWHaxxybSUZ2VHo7YamU0fEcKo7EwplWZqvOXJSRAg
         1n3yhpnq17zZ2/0KDWRNP/QRMh/umVy3sqBXY=
Date: Mon, 7 Sep 2009 13:01:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907110146.GB6393@nowhere>
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h81v7t$p6e$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 06:38:36AM +0300, Nikos Chantziaras wrote:
> Unfortunately, I can't come up with any way to somehow benchmark all of  
> this.  There's no benchmark for "fluidity" and "responsiveness". Running 
> the Doom 3 benchmark, or any other benchmark, doesn't say anything about 
> responsiveness, it only measures how many frames were calculated in a 
> specific period of time.  How "stable" (with no stalls) those frames were 
> making it to the screen is not measurable.



That looks eventually benchmarkable. This is about latency.
For example, you could try to run high load tasks in the
background and then launch a task that wakes up in middle/large
periods to do something. You could measure the time it takes to wake
it up to perform what it wants.

We have some events tracing infrastructure in the kernel that can
snapshot the wake up and sched switch events.

Having CONFIG_EVENT_TRACING=y should be sufficient for that.

You just need to mount a debugfs point, say in /debug.

Then you can activate these sched events by doing:

echo 0 > /debug/tracing/tracing_on
echo 1 > /debug/tracing/events/sched/sched_switch/enable
echo 1 > /debug/tracing/events/sched/sched_wake_up/enable

#Launch your tasks

echo 1 > /debug/tracing/tracing_on

#Wait for some time

echo 0 > /debug/tracing/tracing_off

That will require some parsing of the result in /debug/tracing/trace
to get the delays between wake_up events and switch in events
for the task that periodically wakes up and then produce some
statistics such as the average or the maximum latency.

That's a bit of a rough approach to measure such latencies but that
should work.


> If BFS would imply small drops in pure performance counted in  
> instructions per seconds, that would be a totally acceptable regression  
> for desktop/multimedia/gaming PCs.  Not for server machines, of course.  
> However, on my machine, BFS is faster in classic workloads.  When I run 
> "make -j2" with BFS and the standard scheduler, BFS always finishes a bit 
> faster.  Not by much, but still.  One thing I'm noticing here is that BFS 
> produces 100% CPU load on each core with "make -j2" while the normal 
> scheduler stays at about 90-95% with -j2 or higher in at least one of the 
> cores.  There seems to be under-utilization of CPU time.



That also could be benchmarkable by using the above sched events and
look at the average time spent in a cpu to run the idle tasks.

