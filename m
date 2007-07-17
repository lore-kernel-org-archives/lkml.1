Return-Path: <linux-kernel-owner+w=401wt.eu-S934378AbXGQQ5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbXGQQ5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXGQQ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:57:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51194 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873AbXGQQ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:57:31 -0400
Date: Tue, 17 Jul 2007 18:57:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717165720.GA4386@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707171028.36451.olaf.kirch@oracle.com> <20070717085748.GA32114@elte.hu> <200707171607.08644.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707171607.08644.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> Can you try what happens if you change netif_rx_complete to something 
> like this:
> 
> 	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state)) {
> 		dev->quota = dev->weight;
> 		return;
> 	}
> 
> This is just a hack to make sure that we don't go to insanely negative 
> quotas while sending packets through netpoll.

i've done the patch below, but it did not change the timeouts nor did it 
solve the 'no network' problem. netconsole output hung earlier as well.

i can try other things too. (it would be best if you sent me 
test/debug-patches, instead of letting me hack in the changes - that's 
the surest way of ensuring that i test exactly what you intended.)

	Ingo

------------->
Index: linux/include/linux/netdevice.h
===================================================================
--- linux.orig/include/linux/netdevice.h
+++ linux/include/linux/netdevice.h
@@ -1007,6 +1007,10 @@ static inline int netif_rx_reschedule(st
  */
 static inline void __netif_rx_complete(struct net_device *dev)
 {
+	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state)) {
+		dev->quota = dev->weight;
+		return;
+	}
 	BUG_ON(!test_bit(__LINK_STATE_RX_SCHED, &dev->state));
 	list_del(&dev->poll_list);
 	smp_mb__before_clear_bit();
