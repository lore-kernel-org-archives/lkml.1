Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbXF0Art@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbXF0Art (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXF0Arj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:47:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:55783 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbXF0Ari convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:47:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Re: [2.6.21.1] soft lockup when removing netconsole module
Date: Tue, 26 Jun 2007 17:46:13 -0700
Message-ID: <7ED098B05D69FE41B380586BF1474DBA441F47@ala-mail08.corp.ad.wrs.com>
In-Reply-To: <20070626160753.f86d8803.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Re: [2.6.21.1] soft lockup when removing netconsole module
Thread-Index: Ace4Rvsp4rIinW+TQZiZwfqEGyAOPgADURlA
From: "Wessel, Jason" <jason.wessel@windriver.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jarek Poplawski" <jarkao2@o2.pl>
Cc: "Folkert van Heusden" <folkert@vanheusden.com>,
       <linux-kernel@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       <stable@kernel.org>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 27 Jun 2007 00:46:13.0802 (UTC) FILETIME=[901E58A0:01C7B854]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> > 
> > Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> > 
> > ---
> > 
> > diff -Nurp 2.6.21-/net/core/netpoll.c 2.6.21/net/core/netpoll.c
> > --- 2.6.21-/net/core/netpoll.c	2007-04-26 
> 15:08:32.000000000 +0200
> > +++ 2.6.21/net/core/netpoll.c	2007-06-12 
> 21:05:23.000000000 +0200
> > @@ -73,7 +73,8 @@ static void queue_process(struct work_st
> >  			netif_tx_unlock(dev);
> >  			local_irq_restore(flags);
> >  
> > -			schedule_delayed_work(&npinfo->tx_work, HZ/10);
> > +			if (atomic_read(&npinfo->refcnt))
> > +				
> schedule_delayed_work(&npinfo->tx_work, HZ/10);
> >  			return;
> >  		}
> >  		netif_tx_unlock(dev);
> > @@ -780,9 +781,15 @@ void netpoll_cleanup(struct netpoll *np)
> >  			if (atomic_dec_and_test(&npinfo->refcnt)) {
> >  				skb_queue_purge(&npinfo->arp_tx);
> >  				skb_queue_purge(&npinfo->txq);
> > -				
> cancel_rearming_delayed_work(&npinfo->tx_work);
> > +				cancel_delayed_work(&npinfo->tx_work);
> >  				flush_scheduled_work();
> >  
> > +				/* clean after last, unfinished work */
> > +				if (!skb_queue_empty(&npinfo->txq)) {
> > +					struct sk_buff *skb;
> > +					skb = 
> __skb_dequeue(&npinfo->txq);
> > +					kfree_skb(skb);
> > +				}
> >  				kfree(npinfo);
> >  			}
> >  		}
> 
> Everything went quiet?
> 
> If this patch has been tested and fixes the bug, can you 
> please send a version which is ready for merging?  (ie: add a 
> suitable description of what it does).
> 
> 

I mailed Jarek separately.

I had tested the patch with netconsole and kgdb and it does in fact fix
the problem that was reported.

Jason. 
