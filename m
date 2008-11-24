Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYKXXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYKXXqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYKXXqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:46:14 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64353 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYKXXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:46:13 -0500
Date: Mon, 24 Nov 2008 15:46:09 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH 1/3 v2] softirq: Introduce statistics for softirq
Message-Id: <20081124154609.99deaef2.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20081122142437.57B4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
	<20081121202544.83dcd88f.kobayashi.kk@ncos.nec.co.jp>
	<20081122142437.57B4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 14:36:34 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Statistics for softirq doesn't exist.
> > It will be helpful like statistics for interrupts.
> > This patch introduces counting the number of softirq,
> > which will be exported in /proc/softirqs.
> > 
> > When softirq handler consumes much CPU time,
> > /proc/stat is like the following.
> > 
> > $ while :; do  cat /proc/stat | head -n1 ; sleep 10 ; done
> > cpu  88 0 408 739665 583 28 2 0 0
> > cpu  450 0 1090 740970 594 28 1294 0 0
> >                               ^^^^
> >                              softirq
> > 
> > In such a situation,
> > /proc/softirqs shows us which softirq handler is invoked.
> > We can see the increase rate of softirqs.
> > 
> > <before>
> > $ cat /proc/softirqs
> >                 CPU0       CPU1       CPU2       CPU3
> > HI                 0          0          0          0
> > TIMER         462850     462805     462782     462718
> > NET_TX             0          0          0        365
> > NET_RX          2472          2          2         40
> > BLOCK              0          0        381       1164
> > TASKLET            0          0          0        224
> > SCHED         462654     462689     462698     462427
> > RCU             3046       2423       3367       3173
> > 
> > <after>
> > $ cat /proc/softirqs
> >                 CPU0       CPU1       CPU2       CPU3
> > HI                 0          0          0          0
> > TIMER         463361     465077     465056     464991
> > NET_TX            53          0          1        365
> > NET_RX          3757          2          2         40
> > BLOCK              0          0        398       1170
> > TASKLET            0          0          0        224
> > SCHED         463074     464318     464612     463330
> > RCU             3505       2948       3947       3673
> 
> Maybe, this printing format don't works well on >100 CPUS.
> 
> Do you have any experience of trouble-shooting by this patch?
> Actually, I don't understand this patch usuful working situation.

When reported that CPU TIME of softirq went up,
we had to investigate the cause.
In that case, kind of network looked suspicious.
We added such a function to confirm.

Original patch shows ticks of softirqs.
But /proc/interrups have counts of interrupts.
So we changed from ticks to counts.
 
> Honestly, I think HI and TASKLET are not beneficialness.
> end user can't know what tasklet spent time.
> TIMER also are not so much useful because it always have the same rate.
> 
> So.. guessing...
> 
> ultra band-width networking problem?
> 
> 
<snip>
> 
> >  /*
> >   * Number of interrupts per specific IRQ source, since bootup
> >   */
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index e7c69a7..088e179 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -208,6 +208,7 @@ restart:
> >  	do {
> >  		if (pending & 1) {
> >  			int prev_count = preempt_count();
> > +			kstat_incr_softirqs_this_cpu(h - softirq_vec);
> >  
> >  			h->action(h);
> 
> you should explain this patch don't decrease system performance.

In this pach, only kstat_incr_softirqs_this_cpu() may 
influence system performance.
But this just increments one variable.
I don't think we can detect the decrease in the performance.
