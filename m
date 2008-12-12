Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYLLOFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYLLOFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYLLOFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:05:03 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45676 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbYLLOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:05:01 -0500
Message-ID: <49426F7F.3040305@ext.bull.net>
Date: Fri, 12 Dec 2008 15:04:47 +0100
From: "Gilles.Carry" <Gilles.Carry@ext.bull.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Ma, Chinang" <chinang.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
Subject: Re: CFS scheduler OLTP perforamnce
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>	 <1229083933.12883.179.camel@twins> <1229089100.25485.5.camel@twins>
In-Reply-To: <1229089100.25485.5.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Fri, 2008-12-12 at 13:12 +0100, Peter Zijlstra wrote:
>> On Thu, 2008-12-11 at 16:25 -0700, Ma, Chinang wrote:
>>> We are evaluating the CFS OLTP performance with 2.6.28-c7 kernel. In
>>> this workload once a database foreground process commit a transaction
>>> it will signal the log writer process to write to the log file.
>>> Foreground processes will wait until log writer finish writing and
>>> wake them up. With hundreds of foreground process running in the
>>> system, it is important that the log writer get to run as soon as data
>>> is available. 
>>>
>>> Here are the experiments we have done with 2.6.28-rc7.
>>> 1. Increase log writer priority "renice -20 <log writer pid>" while
>>> keeping all other processes running in default CFS priority. We get a
>>> baseline performance with log latency (scheduling + i/o) at 7 ms.
>> Is this better or the same than nice-0 ?
>>
>>> 2. To reduce log latency, we set log writer to SCHED_RR with higher
>>> priority. We tried "chrt -p 49  <log writer pid>" and got 0.7% boost
>>> in performance with log latency reduced to 6.4 ms.
> 
> BTW, 6.4ms schedule latency sounds insanely long for a RR task, are you
> running a PREEMPT=n kernel or something?
> 
> How would you characterize the log tasks behaviour?
> 
>  - does it run long/short (any quantization)
>  - does it sleep long/short - how does it compare to its runtime?
>  - does it wake others?
>    - if so, always the one who woke it, or multiple others?
> 

To this, I would add these questions:
- do you have the source code of the DBMS? Are you sure that the 
timestamp you get corresponds to the very beginning of the wakeup time?
- if many foregroud tasks write data onto a buffer which is later read 
by the log writer, there may be locks (mutexes?) involved and the log 
writer is supposed to wait for lower prio tasks to release the lock.

Gilles.
