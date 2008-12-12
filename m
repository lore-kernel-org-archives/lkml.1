Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYLLVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYLLVp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYLLVpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:45:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:37574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYLLVpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:45:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,213,1228118400"; 
   d="scan'208";a="649366831"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       Chris Mason <chris.mason@oracle.com>
Date: Fri, 12 Dec 2008 14:45:11 -0700
Subject: RE: CFS scheduler OLTP perforamnce
Thread-Topic: CFS scheduler OLTP perforamnce
Thread-Index: AclcXu8UmHw0LQQaSdyRiwUXQknLtgAPggwg
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E80030A789771@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
	 <1229083933.12883.179.camel@twins> <1229089100.25485.5.camel@twins>
In-Reply-To: <1229089100.25485.5.camel@twins>
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
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Friday, December 12, 2008 5:38 AM
>To: Ma, Chinang
>Cc: Ingo Molnar; linux-kernel@vger.kernel.org; Wilcox, Matthew R; Van De
>Ven, Arjan; Styner, Douglas W; Chilukuri, Harita; Wang, Peter Xihong;
>Nueckel, Hubert
>Subject: Re: CFS scheduler OLTP perforamnce
>
>On Fri, 2008-12-12 at 13:12 +0100, Peter Zijlstra wrote:
>> On Thu, 2008-12-11 at 16:25 -0700, Ma, Chinang wrote:
>> > We are evaluating the CFS OLTP performance with 2.6.28-c7 kernel. In
>> > this workload once a database foreground process commit a transaction
>> > it will signal the log writer process to write to the log file.
>> > Foreground processes will wait until log writer finish writing and
>> > wake them up. With hundreds of foreground process running in the
>> > system, it is important that the log writer get to run as soon as data
>> > is available.
>> >
>> > Here are the experiments we have done with 2.6.28-rc7.
>> > 1. Increase log writer priority "renice -20 <log writer pid>" while
>> > keeping all other processes running in default CFS priority. We get a
>> > baseline performance with log latency (scheduling + i/o) at 7 ms.
>>
>> Is this better or the same than nice-0 ?

I left out one detail of the database processes. There are also data writers that responsible for write back dirty buffers to free up buffer for new transactions. These processes also need to be renice to higher priority (-19). When data writers are left at nice-0, the workload was throttle by the limited number of free buffers and we cannot even fully utilize the system. I had to renice data writer and log writer process.

>>
>> > 2. To reduce log latency, we set log writer to SCHED_RR with higher
>> > priority. We tried "chrt -p 49  <log writer pid>" and got 0.7% boost
>> > in performance with log latency reduced to 6.4 ms.
>
>BTW, 6.4ms schedule latency sounds insanely long for a RR task, are you
>running a PREEMPT=n kernel or something?

The 6.4ms log write latency was measured in the foreground process. It went like this:
1. Foreground progress get start time and post log writer, foreground wait and sleep.
2. log writer was scheduled and collect log data. 
3. log writer write to log file and wait for i/o.
4. Write completed. log writer use vector post to wake up all the waiting foreground process.
5. Foreground process wake up and get end time.

>
>How would you characterize the log tasks behaviour?
>
> - does it run long/short (any quantization)

There were 371 log writes per second so ~2.7ms per log writer execution. Out of this we know ~2.13 ms was spent waiting for log file i/o. Log writer was running for (2.7ms - 2.13ms) = 0.57ms  
	
> - does it sleep long/short - how does it compare to its runtime?


With the current throughput, log writer should be constantly writing log and rarely sleep.

> - does it wake others?
>   - if so, always the one who woke it, or multiple others?
>

Log writer wake multiple foreground processes using vector post.

-Chinang
