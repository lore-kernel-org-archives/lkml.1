Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYAPCs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYAPCs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYAPCsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:48:22 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:15790 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbYAPCsU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:48:20 -0500
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 21:48:20 EST
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] lost softirq, 2.6.24-rc7
Date: Tue, 15 Jan 2008 18:17:07 -0800
Message-ID: <884020C16A0AFF4D8A8B7800EA0C98870FD5F6@ussdixms03.am.sony.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] lost softirq, 2.6.24-rc7
Thread-Index: AchX3w/jBsGjl1oDRHqeAsSzSiu1fQABUmMJ
References: <1200435326.4092.9.camel@bx740> <20080116003946.GE30532@goodmis.org>
From: "Rowand, Frank" <frank.rowand@us.sony.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>
X-OriginalArrivalTime: 16 Jan 2008 02:17:08.0385 (UTC) FILETIME=[E528E910:01C857E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steve,

You are totally correct.  I used the wrong words when I said
"ksoftirqd thread runs".  My apologies for very misleading wording.

I have updated the wording in-line below, in the original message to
indicate that it is softirq threads, in the ksoftirqd() function, not
the ksoftirqd thread.

-Frank

-----Original Message-----
From: Steven Rostedt [mailto:rostedt@goodmis.org]
Sent: Tue 1/15/2008 4:39 PM
To: Rowand, Frank
Cc: linux-kernel@vger.kernel.org; mingo@redhat.com
Subject: Re: [PATCH] lost softirq, 2.6.24-rc7
 
On Tue, Jan 15, 2008 at 02:15:26PM -0800, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@am.sony.com>
> 
> (Ingo, there is a question for you after the description, just before the
> patch.)
> 
> When running an interrupt and network intensive stress test with PREEMPT_RT
> enabled, the target system stopped processing received network packets.
> skbs from received packets were being queued by net_rx_action(), but the
> NET_RX_SOFTIRQ softirq was never running to remove the skbs from the queue.
> Since the target system root file system is NFS mounted, the system is now
> effectively hung.
> 
> A pseudocode description of how this state was reached follows.
> Each level of indentation represents a function call from the previous line.
> 
> 
> ethernet driver irq handler receives packet
>    netif_rx()
>       queues skb (qlen == 1), raises NET_RX_SOFTIRQ
> 
> on return from irq
>    ___do_softirq() [ 1 ]
>       Reset the pending bitmask

Frank,

This path should not be hit when running with PREEMPT_RT. The softirqs
are now all separate, and are not run in batch in ksoftirqd. In fact,
ksoftirqd should not be running at all with PREEMPT_RT.

-- Steve

>       net_rx_action()
>          dequeues skb (qlen == 0)
>          jiffies incremented, so
>             break out of processing
>             and raise NET_RX_SOFTIRQ
>             (but don't deassert NAPI_STATE_SCHED)
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>          ksoftirqd thread runs

           ^^^^^^^^^^^^^^^^^^^^^^  should have been:

           the TIMER_SOFTIRQ and RCU_SOFTIRQ softirq threads, which are
           both executing ksoftirqd() run

>             process TIMER_SOFTIRQ
>             process RCU_SOFTIRQ

>             << ksoftirqd sleeps >>

              ^^^^^^^^^^^^^^^^^^^^^^^  should have been:
              the softirq threads, executing in ksoftirqd(), sleep

> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
>          ___do_softirq() [ 2 ]
>             Reset the pending bitmask
>             finds NET_RX_SOFTIRQ raised but already running
>             << ___do_softirq() [ 2 ] completes >>
> 
>       << ___do_softirq() [ 1 ] resumes >>
>       the pending bitmask is empty, so NET_RX_SOFTIRQ is lost
> 
> 
> 



