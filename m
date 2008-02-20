Return-Path: <linux-kernel-owner+w=401wt.eu-S1763613AbYBTGwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763613AbYBTGwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbYBTGwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:52:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602AbYBTGwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:52:43 -0500
Date: Wed, 20 Feb 2008 07:52:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mm: fix dma_poor_create
Message-ID: <20080220065230.GG7493@elte.hu>
References: <200802191845.28802.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802191845.28802.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> dev_to_node could return node that without RAM. So check it before use 
> it in kmalloc_node

> -	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
> +	node = dev_to_node(dev);
> +	if (node == -1 || !node_online(node))
> +		node = numa_node_id();
> +
> +	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);

so this is about not crashing during bootup on nodes that have CPUs but 
which have no node-specific memory attached, right?

Shouldnt kmalloc_node() be made more robust instead? I.e. push the same 
code into kmalloc_node() - and make sure it will allocate _something_? 
That would probably also fix a similar bug in net/core/skbuff.c's 
__netdev_alloc_skb(), which too passes a dev_to_node() result to an 
allocator.

	Ingo
