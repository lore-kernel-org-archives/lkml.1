Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXCZKt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXCZKt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965047AbXCZKt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:49:56 -0400
Received: from comtv.ru ([217.10.32.17]:43881 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbXCZKtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:49:55 -0400
X-UCL: actv
Date: Mon, 26 Mar 2007 14:49:33 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <200703260957.34798.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org>
 <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org>
 <200703260957.34798.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Con Kolivas wrote:

> On Monday 26 March 2007 09:01, Con Kolivas wrote:
>> On Monday 26 March 2007 03:14, malc wrote:
>>> On Mon, 26 Mar 2007, Con Kolivas wrote:
>>>> On Monday 26 March 2007 01:19, malc wrote:
>>> Erm... i just looked at the code and suddenly it stopped making any sense
>>> at all:
>>>
>>>          p->last_ran = rq->most_recent_timestamp = now;
>>>          /* Sanity check. It should never go backwards or ruin accounting
>>> */ if (unlikely(now < p->last_ran))
>>>                  return;
>>>          time_diff = now - p->last_ran;
>>>
>>> First `now' is assigned to `p->last_ran' and the very next line
>>> compares those two values, and then the difference is taken.. I quite
>>> frankly am either very tired or fail to see the point.. time_diff is
>>> either always zero or there's always a race here.
>>
>> Bah major thinko error on my part! That will teach me to post patches
>> untested at 1:30 am. I'll try again shortly sorry.
>
> Ok this one is heavily tested. Please try it when you find the time.

[..snip..]

Done, works. However there's a problem with accuracy comming from a
different angle.

I have this USB video grabber and also quite efficient way of putting
the pixels to the screen. Video is grabbed using isochronous
transfers, i.e. lots of small(on the order of 1K) chunks of data are
being transferred continously instead of one big burst unlike in, for
instance, PCI setup. With your accounting change idle from
`/proc/stat' is accurate but unfortunatelly top(1)/icewm's monitor/etc
apparently use user+sys+nice+intr+softirq+iowait to show the system
load, so system tools claim that the load is 10-12% while in reality
it is ~3%.

This situation is harder to write a hog-like testcase for. Anyhow it
seems the difference in percentage stems from the `intr' field of
`/proc/stat', which fits. And following patch (which should be applied
on top of yours) seems to help. I wouldn't really know what to do with
softirq and the rest of counts touched by this function, so i left them
alone.

Comments?

diff -ru linux-2.6.21-rc4/include/linux/kernel_stat.h linux-2.6.21-rc4-load/include/linux/kernel_stat.h
--- linux-2.6.21-rc4/include/linux/kernel_stat.h	2007-03-26 14:33:19.000000000 +0400
+++ linux-2.6.21-rc4-load/include/linux/kernel_stat.h	2007-03-26 14:06:21.000000000 +0400
@@ -22,6 +22,7 @@
  	cputime64_t system;
  	cputime64_t softirq;
  	cputime64_t irq;
+	cputime64_t irq_ns;
  	cputime64_t idle;
  	cputime64_t idle_ns;
  	cputime64_t iowait;
diff -ru linux-2.6.21-rc4/kernel/sched.c linux-2.6.21-rc4-load/kernel/sched.c
--- linux-2.6.21-rc4/kernel/sched.c	2007-03-26 14:33:19.000000000 +0400
+++ linux-2.6.21-rc4-load/kernel/sched.c	2007-03-26 14:11:36.000000000 +0400
@@ -3148,9 +3148,14 @@

  	/* Add system time to cpustat. */
  	tmp = cputime_to_cputime64(cputime);
-	if (hardirq_count() - hardirq_offset)
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-	else if (softirq_count())
+	if (hardirq_count() - hardirq_offset) {
+		cpustat->irq_ns = cputime64_add(cpustat->irq_ns, tmp);
+		if (cpustat->irq_ns > JIFFY_NS) {
+			cpustat->irq_ns = cputime64_sub(cpustat->irq_ns,
+							JIFFY_NS);
+			cpustat->irq = cputime64_add(cpustat->irq, 1);
+		}
+	} else if (softirq_count())
  		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
  	else if (p != rq->idle)
  		cpustat->system = cputime64_add(cpustat->system, tmp);

-- 
vale
