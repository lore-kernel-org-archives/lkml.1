Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbZIEAzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbZIEAzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933844AbZIEAzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:55:15 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:4203 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933839AbZIEAzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:55:14 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: question on sched-rt group allocation cap: sched_rt_runtime_us
Date: Fri, 4 Sep 2009 17:55:15 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: question on sched-rt group allocation cap: sched_rt_runtime_us
Thread-Index: Acotv57vW6nkRxQOQLuBf8W5yfJIlwAAtMAw
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and rest:

I have been playing around with the sched_rt_runtime_us cap that can be
used to limit the amount of CPU time allocated towards scheduling rt
group threads. I am using 2.6.26 with CONFIG_GROUP_SCHED disabled (we
use only the root user in our embedded setup). I have no other CPU
intensive workloads (RT or otherwise) running on my system. I have
changed no other scheduling parameters from /proc. 

I have written a small test program that:

(a) forks two threads, one SCHED_FIFO and one SCHED_OTHER (this thread
is reniced to -20) and ties both of them to a specific core.
(b) runs both the threads in a tight loop (same number of iterations for
both threads) until the SCHED_FIFO thread terminates.
(c) calculates the number of completed iterations of the regular
SCHED_OTHER thread against the fixed number of iterations of the
SCHED_FIFO thread. It then calculates a percentage based on that.

I am running the above workload against varying sched_rt_runtime_us
values (200 ms to 700 ms) keeping the sched_rt_period_us constant at
1000 ms. I have also experimented a little bit by decreasing the value
of sched_rt_period_us (thus increasing the sched granularity) with no
apparent change in behavior. 

My observations are listed in tabular form: 

Ratio of                  # of completed iterations of reg thread /
sched_rt_runtime_us /     # of iterations of RT thread (in %)
sched_rt_runtime_us       

0.2                      100 % (regular thread completed all its
iterations).
0.3                      73 %
0.4                      45 %
0.5                      17 %
0.6                      0 % (SCHED_OTHER thread completely throttled.
Never ran)
0.7                      0 %

This result kind of baffles me. Even when we cap the RT group to a
fraction of 0.6 of overall CPU time, the rest 0.4 \should\ still be
available for running regular threads. So my SCHED_OTHER \should\ make
some progress as opposed to being completely throttled. Similarly, with
any fraction less than 0.5, the SCHED_OTHER should complete before
SCHED_FIFO.

I do not have an easy way to verify my results over the latest kernel
(2.6.31). Was there any regressions in the scheduling subsystem in
2.6.26? Can this behavior be explained? Do we need to tweak any other
/proc parameters?

Cheers,

Ani

 
      
