Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbZCZXgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbZCZXgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZCZXgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:36:04 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43613 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbZCZXgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:36:03 -0400
Message-ID: <49CC1155.9010409@cosmosbay.com>
Date: Fri, 27 Mar 2009 00:35:49 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Santiago Garcia Mantinan <manty@manty.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: uli526x hangs on 2.6.29, not on rc8
References: <20090326231515.GA6612@dis.manty.net>
In-Reply-To: <20090326231515.GA6612@dis.manty.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 27 Mar 2009 00:35:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santiago Garcia Mantinan a écrit :
> Hi!
> 
> After upgrading from rc8 to final 2.6.29 my machine's network stops working
> after some full speed (100Mb/s) downloads ifdown;ifup, or powering off the
> switch won't solve the problem, however it is solved if I unload the driver
> module and load it again. Tested with another NIC (e1000e based) and
> couldn't reproduce the problem.
> 
> This is happening on final 2.6.29 version but doesn't seem to happen on rc8
> with the same kernel config. Machine is a AMD Athlon 64 running Debian 64
> bits.
> 
> I don't see any changes on the git for uli526x from rc8 to final, but the
> tulip driver on which this one is based had some changes.
> 
> Don't know what else to add, just ask me for whatever data that may help on
> this.
> 
> Regards...

Hi

This is a known problem, and a fix should be available very soon for 2.6.29.1

http://www.spinics.net/lists/netdev/msg92829.html

You can check net/core/dev.c function process_backlog() should get this
updated version :

static int process_backlog(struct napi_struct *napi, int quota)
{
	int work = 0;
	struct softnet_data *queue = &__get_cpu_var(softnet_data);
	unsigned long start_time = jiffies;

	napi->weight = weight_p;
	do {
		struct sk_buff *skb;

		local_irq_disable();
		skb = __skb_dequeue(&queue->input_pkt_queue);
		if (!skb) {
			list_del(&napi->poll_list);
			clear_bit(NAPI_STATE_SCHED, &napi->state);
			local_irq_enable();
			break;
		}
		local_irq_enable();

		napi_gro_receive(napi, skb);
	} while (++work < quota && jiffies == start_time);

	napi_gro_flush(napi);

	return work;
}


