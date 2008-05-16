Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYEPTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYEPTxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYEPTxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:53:06 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:49152 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYEPTxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:53:05 -0400
Date: Fri, 16 May 2008 16:52:23 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH] Remove argument from open_softirq which is always NULL
Message-ID: <20080516195223.GA5308@beyonder.ift.unesp.br>
Mail-Followup-To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, matthew@wil.cx
References: <20080515141537.GA22826@beyonder.ift.unesp.br> <20080516182807.GA28406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516182807.GA28406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16.May'08 at 11:28:07 -0700, Paul E. McKenney wrote:
> On Thu, May 15, 2008 at 11:15:37AM -0300, Carlos R. Mafra wrote:
> > From 9371c45e92c308425c0aad4794f61acb6fe6d140 Mon Sep 17 00:00:00 2001
> > From: Carlos R. Mafra <crmafra@ift.unesp.br>
> > Date: Wed, 14 May 2008 18:26:06 -0300
> > Subject: [PATCH] Remove argument from open_softirq which is always NULL
> > 
> > As git-grep shows, open_softirq() is always called with the last argument
> > being NULL
> > 
> > block/blk-core.c:       open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
> > kernel/hrtimer.c:       open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
> > kernel/rcuclassic.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
> > kernel/rcupreempt.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
> > kernel/sched.c: open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
> > kernel/softirq.c:       open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
> > kernel/softirq.c:       open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
> > kernel/timer.c: open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
> > net/core/dev.c: open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
> > net/core/dev.c: open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);
> > 
> > This observation has already been made by Matthew Wilcox in June 2002
> > (http://www.cs.helsinki.fi/linux/linux-kernel/2002-25/0687.html)
> > 
> > "I notice that none of the current softirq routines use the data element
> > passed to them."
> > 
> > and the situation hasn't changed since them. So it appears we can safely
> > remove that extra argument to save 128 (54) bytes of kernel data (text).
> 
> Good stuff!!!

Thanks a lot!

> Will there also be a similar set of patches that removes the extra
> argument from the invoked function?  For example:
> 
> 	static void rcu_process_callbacks(struct softirq_action *unused)
> 
> could now become:
> 
> 	static void rcu_process_callbacks(void)

That was my intention at first when I came acroos 
run_hrtimer_softirq(struct softirq_action *h) in hrtimer.c, which then led me to
read more code and notice that I could do the cleanup in this patch.

You've just gave me the motivation I needed to keep cleaning (and learning) further, 
as the original bug which motivated me to look at those things does not
happen anymore in my laptop :-)

I will try to do another patch soon, but I will travel tomorrow so it
may take a few days. 

> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks,
Carlos

