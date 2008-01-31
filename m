Return-Path: <linux-kernel-owner+w=401wt.eu-S933319AbYAaKsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbYAaKsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764579AbYAaKrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:47:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764400AbYAaKrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:47:49 -0500
Subject: Re: High wake up latencies with FAIR_USER_SCHED
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, dhaval@linux.vnet.ibm.com
In-Reply-To: <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
	 <20080128023129.GD1044@linux.vnet.ibm.com>
	 <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
	 <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 11:47:41 +0100
Message-Id: <1201776461.28547.289.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 21:13 +0100, Guillaume Chazarain wrote:
> Unfortunately it seems to not be completely fixed, with this script:
> 
> #!/usr/bin/python
> 
> import os
> import time
> 
> SLEEP_TIME = 0.1
> SAMPLES = 5
> PRINT_DELAY = 0.5
> 
> def print_wakeup_latency():
>     times = []
>     last_print = 0
>     while True:
>         start = time.time()
>         time.sleep(SLEEP_TIME)
>         end = time.time()
>         times.insert(0, end - start - SLEEP_TIME)
>         del times[SAMPLES:]
>         if end > last_print + PRINT_DELAY:
>             copy = times[:]
>             copy.sort()
>             print '%f ms' % (copy[len(copy)/2] * 1000)
>             last_print = end
> 
> if os.fork() == 0:
>     if os.fork() == 0:
>         os.setuid(1)
>         while True:
>             pass
>     else:
>         os.setuid(2)
>         while True:
>             pass
> else:
>     os.setuid(1)
>     print_wakeup_latency()
> 
> I get seemingly unpredictable latencies (with or without the patch applied):
> 
> # ./sched.py
> 14.810944 ms
> 19.829893 ms
> 1.968050 ms
> 8.021021 ms
> -0.017977 ms
> 4.926109 ms
> 11.958027 ms
> 5.995893 ms
> 1.992130 ms
> 0.007057 ms
> 0.217819 ms
> -0.004864 ms
> 5.907202 ms
> 6.547832 ms
> -0.012970 ms
> 0.209951 ms
> -0.002003 ms
> 4.989052 ms
> 
> Without FAIR_USER_SCHED, latencies are consistently in the noise.
> Also, I forgot to mention that I'm on a single CPU.
> 
> Thanks for the help.

Does something like this help?


Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -267,8 +267,12 @@ static u64 sched_slice(struct cfs_rq *cf
 {
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
-	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
 
 	return slice;
 }


