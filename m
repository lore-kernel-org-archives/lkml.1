Return-Path: <linux-kernel-owner+w=401wt.eu-S1423159AbXBPEde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423159AbXBPEde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423154AbXBPEde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:33:34 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:15535 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423159AbXBPEdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:33:33 -0500
Date: Fri, 16 Feb 2007 13:33:22 +0900 (JST)
Message-Id: <20070216.133322.48797866.nemoto@toshiba-tops.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, romieu@fr.zoreil.com, jeff@garzik.org, torvalds@osdl.org,
       akpm@osdl.org, davem@davemloft.net, tglx@linutronix.de
Subject: Re: [patch] net, 8139too.c: fix netpoll deadlock
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070214.113025.126141881.nemoto@toshiba-tops.co.jp>
References: <20061212214939.GA470@electric-eye.fr.zoreil.com>
	<20061213011231.GA6361@elte.hu>
	<20070214.113025.126141881.nemoto@toshiba-tops.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 11:30:25 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > hm, this isnt really about NAPI polling, but about the 
> > netconsole/netpoll/netdump poll_controller() handler.
> > 
> > with netconsole, printk can be called from IRQ context (and is 
> > frequently from IRQ context during bootup or module initialization), so 
> > a BH rule isnt enough for them.
> 
> I see NAPI poll routine might be called with interrupt disabled.
> 
> Many (all?) NAPI drivers call netif_receive_skb() from its poll
> routine (as described in NAPI-HOWTO.txt), but I thought
> netif_receive_skb() cannot be called from irq context or irq disabled.
> So it seems the problem is not solved completely.  Or am I missing
> something?

Any comments for this issue?  If my understanding was correct, I think
add some checking to netif_receive_skb() is better then fixing all
poll routines.  Is this patch acceptable?


Subject: fix irq problem with NAPI + NETPOLL

It seems netif_receive_skb() was designed not to call from irq
context, but NAPI + NETPOLL break this rule.  If netif_receive_skb()
was called from irq context, redirect to netif_rx() instead of
processing the skb in that context.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
--- linux-2.6.20/net/core/dev.c	2007-02-05 03:44:54.000000000 +0900
+++ linux/net/core/dev.c	2007-02-16 13:19:06.000000000 +0900
@@ -1769,8 +1769,15 @@ int netif_receive_skb(struct sk_buff *sk
 	__be16 type;
 
 	/* if we've gotten here through NAPI, check netpoll */
-	if (skb->dev->poll && netpoll_rx(skb))
-		return NET_RX_DROP;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	if (skb->dev->poll && skb->dev->poll_controller) {
+		/* NAPI poll might be called in irq context on NETPOLL */
+		if (in_irq() || irqs_disabled())
+			return netif_rx(skb);
+		if (netpoll_rx(skb))
+			return NET_RX_DROP;
+	}
+#endif
 
 	if (!skb->tstamp.off_sec)
 		net_timestamp(skb);
