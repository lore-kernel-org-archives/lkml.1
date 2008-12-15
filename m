Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYLOUuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYLOUuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYLOUuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:50:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:64743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYLOUuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,226,1228118400"; 
   d="scan'208";a="649994620"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: Henrik Austad <henrik@austad.us>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>
Date: Mon, 15 Dec 2008 13:49:59 -0700
Subject: RE: CFS scheduler OLTP perforamnce
Thread-Topic: CFS scheduler OLTP perforamnce
Thread-Index: Acle1jusks9QatiYRfuryTpVDw0qQwAGXVuQ
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E80030A7DD60C@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
 <1229089100.25485.5.camel@twins>
 <BC02C49EEB98354DBA7F5DD76F2A9E80030A789771@azsmsx501.amr.corp.intel.com>
 <200812141543.06846.henrik@austad.us>
 <BC02C49EEB98354DBA7F5DD76F2A9E80030A7DCC55@azsmsx501.amr.corp.intel.com>
 <20081215165716.GA27776@januz.myftp.org>
In-Reply-To: <20081215165716.GA27776@januz.myftp.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Henrik Austad [mailto:henrik@austad.us]
>Sent: Monday, December 15, 2008 8:57 AM
>To: Ma, Chinang
>Cc: Peter Zijlstra; Ingo Molnar; linux-kernel@vger.kernel.org; Wilcox,
>Matthew R; Van De Ven, Arjan; Styner, Douglas W; Chilukuri, Harita; Wang,
>Peter Xihong; Nueckel, Hubert; Chris Mason; Tripathi, Sharad C
>Subject: Re: CFS scheduler OLTP perforamnce
>

*snip*

>On Mon, Dec 15, 2008 at 08:32:41AM -0700, Ma, Chinang wrote:
>>
>> >Is this really a kernel-scheduler problem? Or is it an error in the way
>the
>> >timestamps are recoreded?
>> >
>> >Does not the time recorded then depend upon how the foreground process
>is
>> >scheduled, and not the log-writer? What happens if you log the time at
>the
>> >start and end of the log-writer function? Then you would get the time-
>delta
>> >between signaling and rr-wakeup, as well as time spent writing buffer to
>> >disk. By using the final timestamp in the foreground process, you'd get
>the
>> >latency for the last foreground-process wakeup as well.
>> >
>> >Or am I completely missing the point here?
>>
>> Since I don't have access to the source code, I cannot make the about
>change to the foreground or log writer.
>
>Aha, then it makes sense :-)
>
>What about, as a test, set the foreground process as rt-prio (not a good
>thing
>for a production environment, but as a test, it should give you an
>indication
>to how long time the wakeup-time is.
>

When setting foreground and log writer to rt-prio, the log latency reduced to 4.8ms. Performance is about 1.5% higher than the CFS result.
  
On a side note, we had been using rt-prio on all DBMS processes and log writer ( in higher priority) for the best OLTP performance. That has worked pretty well until 2.6.25 when the new rt scheduler introduced the pull/push task for lower scheduling latency for rt-task. That has negative impact on this workload, probably due to the more elaborated load calculation/balancing for hundred of foreground rt-prio processes. Also, there is that question of no production environment would run DBMS with rt-prio. That is why I am going back to explore CFS and see whether I can drop rt-prio for good.

>>
>> >
>> >> >How would you characterize the log tasks behaviour?
>> >> >
>> >> > - does it run long/short (any quantization)
>> >>
>> >> There were 371 log writes per second so ~2.7ms per log writer
>execution.
>> >> Out of this we know ~2.13 ms was spent waiting for log file i/o. Log
>> >writer
>> >> was running for (2.7ms - 2.13ms) = 0.57ms
>> >>
>> >> > - does it sleep long/short - how does it compare to its runtime?
>> >>
>> >> With the current throughput, log writer should be constantly writing
>log
>> >> and rarely sleep.
>> >>
>> >> > - does it wake others?
>> >> >   - if so, always the one who woke it, or multiple others?
>> >>
>> >> Log writer wake multiple foreground processes using vector post.
>> >
>> >So, you don't really know if the initial process that recorded the
>> >timestamp
>> >is the one who is awoken - so the time taken could be *very* long?
>> >
>> Yes. If we only look at the timestamp in just one foreground process. The
>reported log latency is an average of the sum of all foreground stats.
>Since this average went down with the log writer set to SCHED_RR, I took
>that as log writer get to do its job sooner.
>
>Ah, I guess the time went down because the writer was scheduler much
>earlier,
>and this lead to decreased time, but as the foreground process needs to be
>waken up and scheduled *after* the writer has finished, you will still see
>some latencies here.
>
>I'm suspecting you record a lot of time waiting for the foreground process
>to be scheduled again.
>
>
>henrik
