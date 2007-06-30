Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbXF3LZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbXF3LZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 07:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXF3LZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 07:25:37 -0400
Received: from mail.screens.ru ([213.234.233.54]:42810 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbXF3LZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 07:25:36 -0400
Date: Sat, 30 Jun 2007 15:25:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew@wil.cx
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070630112558.GA230@tv-sign.ru>
References: <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629155116.GA422@tv-sign.ru> <20070629162144.GA17709@ms2.inr.ac.ru> <20070629165247.GA457@tv-sign.ru> <20070629170957.GA467@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629170957.GA467@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Oleg Nesterov wrote:
>
> Suppose we have the tasklets T1 and T2, both are scheduled on the
> same CPU. T1 takes some spinlock LOCK.
> 
> Currently it is possible to do
> 
> 	spin_lock(LOCK);
> 	disable_tasklet(T2);
> 
> With this patch, the above code hangs.

I am stupid. Yes, flush_workqueue() is evil and should not be used, but
if we use workqueues, tasklet_disable() becomes might_sleep() anyway.
This is incompatible and unavoidable change.

grep, grep...

	net/bluetooth/hci_core.c:hci_rx_task()

		read_lock(&hci_task_lock)
		hci_event_packet()
			hci_num_comp_pkts_evt()
				tasklet_disable(&hdev->tx_task)

Oleg.

