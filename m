Return-Path: <linux-kernel-owner+w=401wt.eu-S965247AbXIJTBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965247AbXIJTBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbXIJTAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:00:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:35409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbXIJTAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:00:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,232,1186383600"; 
   d="scan'208";a="291985059"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Date: Mon, 10 Sep 2007 11:59:37 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5015DAF57@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070902100215.GB26138@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Thread-Index: AcftSGdlGgFOo0eKTC+dXocJUm9FbAGkhGhw
References: <20070827215611.GA30396@linux-os.sc.intel.com> <p73bqcmvxc6.fsf@bingen.suse.de> <20070902072806.GC5075@elte.hu> <20070902074622.GA16045@one.firstfloor.org> <20070902100215.GB26138@elte.hu>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Sep 2007 19:00:47.0066 (UTC) FILETIME=[E56A6BA0:01C7F3DC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Sunday, September 02, 2007 3:02 AM
>To: Andi Kleen
>Cc: Pallipadi, Venkatesh; Thomas Gleixner; Andrew Morton; linux-kernel
>Subject: Re: [PATCH] Track accurate idle time with 
>tick_sched.idle_sleeptime
>
>
>* Andi Kleen <andi@firstfloor.org> wrote:
>
>> > at least the current out-of-idle code already does what 
>amounts to a 
>> > PM-timer read when exiting from C2 or C3 mode. The
>> 
>> C2/C3 are already slow. I more worry about C1.
>
>C2/C3 are only slow in older CPUs - and they are getting faster and 
>faster. (also, newer systems do less of C1, due to increased energy 
>awareness.)
>
>would be nice to measure the overhead/impact i suspect.
>

Agree with latency concern out of C1. One option I was looking at was to
delay the timer update to do something like this
- C-state idle
- Break out due to interrupt
- Record TSC
- Handle interrupt
- irq_exit do a delayed update to time
  - Look at current TSC and previously recorded TSC and current time and
get the actual idle time

This way, we will not have latency for interrupt handling itself. But,
it is not so clean to do this as there are old systems where TSCs vary
with frequency and it is not a generic solution like ktime_get().

I had tried lmbench before sending out the patch and did not see
increased latency in scheduler or pipe related numbers. Any other
microbenchmark where I can possibly quantify the latency?

Also, this current patch does the accounting only for idle process. But,
going forward, we may need similar accounting even when we are executing
a process, so that scheduler can do the fine grained time slice
management and not account the interrupt handling time to the process.
We will have similar issue at a larger scale then.

Thanks,
Venki  
