Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXGQFhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXGQFhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXGQFhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:37:46 -0400
Received: from mx10.go2.pl ([193.17.41.74]:34036 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753218AbXGQFhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:37:45 -0400
Date: Tue, 17 Jul 2007 07:46:39 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, olaf.kirch@oracle.com,
       davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717054639.GA1640@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716091236.GA10718@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-07-2007 11:12, Ingo Molnar wrote:
> current -git broke my main testbox. No TCP/IP networking to/from the box 
> and e1000 would time out in xmit:
> 
>  NETDEV WATCHDOG: eth0: transmit timed out
>  e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
...

Olaf, I think this error can trigger in this place:

> static void net_rx_action(struct softirq_action *h)
> {
>         struct softnet_data *queue = &__get_cpu_var(softnet_data);
>         unsigned long start_time = jiffies;
>         int budget = netdev_budget;
>         void *have;
> 
>         local_irq_disable();
> 
>         while (!list_empty(&queue->poll_list)) {
>                 struct net_device *dev;
> 
>                 if (budget <= 0 || jiffies - start_time > 1)
>                         goto softnet_break;
> 
>                 local_irq_enable();
> 
>                 dev = list_entry(queue->poll_list.next,
>                                  struct net_device, poll_list);
>                 have = netpoll_poll_lock(dev);
> 
>                 if (dev->quota <= 0 || dev->poll(dev, &budget)) {

If after poll_napi dev->quota <= 0 dev->poll is not run and
__LINK_STATE_RX_SCHED bit (plus dev->poll_list) stays uncleared.

Regards,
Jarek P.
