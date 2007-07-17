Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbXGQGGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbXGQGGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXGQGGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:06:05 -0400
Received: from mx2.go2.pl ([193.17.41.42]:35188 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246AbXGQGGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:06:04 -0400
Date: Tue, 17 Jul 2007 08:14:58 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, olaf.kirch@oracle.com,
       davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717061458.GB1640@ff.dom.local>
References: <20070716091236.GA10718@elte.hu> <20070717054639.GA1640@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717054639.GA1640@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 07:46:39AM +0200, Jarek Poplawski wrote:
...
> > static void net_rx_action(struct softirq_action *h)
> > {
> >         struct softnet_data *queue = &__get_cpu_var(softnet_data);
> >         unsigned long start_time = jiffies;
> >         int budget = netdev_budget;
> >         void *have;
> > 
> >         local_irq_disable();
> > 
> >         while (!list_empty(&queue->poll_list)) {
> >                 struct net_device *dev;
> > 
> >                 if (budget <= 0 || jiffies - start_time > 1)
> >                         goto softnet_break;
> > 
> >                 local_irq_enable();
> > 
> >                 dev = list_entry(queue->poll_list.next,
> >                                  struct net_device, poll_list);
> >                 have = netpoll_poll_lock(dev);
> > 
> >                 if (dev->quota <= 0 || dev->poll(dev, &budget)) {
> 
> If after poll_napi dev->quota <= 0 dev->poll is not run and
> __LINK_STATE_RX_SCHED bit (plus dev->poll_list) stays uncleared.

Or, more precisely dev->poll_list will be cleared just after this,
and net_rx_action returns with __LINK_STATE_RX_SCHED bit set.

Jarek P.
