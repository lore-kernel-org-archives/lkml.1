Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYAPAkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYAPAkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYAPAkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:40:25 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:58988 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYAPAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:40:24 -0500
Date: Tue, 15 Jan 2008 19:39:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] lost softirq, 2.6.24-rc7
Message-ID: <20080116003946.GE30532@goodmis.org>
References: <1200435326.4092.9.camel@bx740>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200435326.4092.9.camel@bx740>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
>             process TIMER_SOFTIRQ
>             process RCU_SOFTIRQ
>             << ksoftirqd sleeps >>
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
