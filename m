Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbXE3W1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbXE3W1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXE3W1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:27:42 -0400
Received: from mail.screens.ru ([213.234.233.54]:33299 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXE3W1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:27:41 -0400
Date: Thu, 31 May 2007 02:27:44 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: + fix-soft-lockup-when-removing-netconsole-module.patch added to -mm tree
Message-ID: <20070530222744.GA347@tv-sign.ru>
References: <20070530210137.GA225@tv-sign.ru> <20070530145123.fe5cb196.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530145123.fe5cb196.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Andrew Morton wrote:
>
> On Thu, 31 May 2007 01:01:37 +0400
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Jason Wessel wrote:
> > >
> > > The netpoll_cleanup handler can hang the kernel if there is no work in the
> > > work queue because a call to cancel_rearming_delayed_work() with no work
> > > goes into an infinite loop.
> > 
> > This should not be true any longer, cancel_rearming_delayed_work() should work
> > correctly in any case.
> > 
> > Could you please clarify?
> 
> We need a 2.6.21.x fix.

Ah, OK, sorry for noise.

> > > @@ -771,30 +771,32 @@ void netpoll_cleanup(struct netpoll *np)
> > >
> > > [...snip...]
> > >
> > > +		if (atomic_dec_and_test(&npinfo->refcnt)) {
> > > +			skb_queue_purge(&npinfo->arp_tx);
> > > +			skb_queue_purge(&npinfo->txq);
> > > +			if (delayed_work_pending(&npinfo->tx_work)) {
> > >  				cancel_rearming_delayed_work(&npinfo->tx_work);
> > >  				flush_scheduled_work();
> > 
> > But this "if (delayed_work_pending())" is racy anyway?
> > 
> 
> I guess so, a bit.

How about this COMPLETELY UNTESTED patch? (it borrows Tejun's double flush
trick).

--- n/net/core/netpoll.c~	2007-05-31 02:12:37.000000000 +0400
+++ n/net/core/netpoll.c	2007-05-31 02:13:39.000000000 +0400
@@ -773,8 +773,16 @@ void netpoll_cleanup(struct netpoll *np)
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
-				cancel_rearming_delayed_work(&npinfo->tx_work);
+
 				flush_scheduled_work();
+				/*
+				 * the next invocation of queue_process() can't
+				 * re-schedule ->tx_work because ->txq is empty
+				 */
+				if (!cancel_delayed_work(&npinfo->tx_work)) {
+					/* may be queued, wait for completion */
+					flush_scheduled_work();
+				}
 
 				kfree(npinfo);
 			}

