Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbYF3RUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbYF3RUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYF3RTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:19:53 -0400
Received: from mail.vyatta.com ([216.93.170.194]:54344 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYF3RTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:19:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.639
Date: Mon, 30 Jun 2008 10:19:48 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add missing skb->dev assignment in Frame Relay RX code
Message-ID: <20080630101948.535496a9@extreme>
In-Reply-To: <m3od5kaqx8.fsf@maximus.localdomain>
References: <m3wsk8aupw.fsf@maximus.localdomain>
	<20080629130420.62d00d59@extreme>
	<m3od5kaqx8.fsf@maximus.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 23:10:11 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Stephen Hemminger <shemminger@vyatta.com> writes:
> 
> >> --- a/drivers/net/wan/hdlc_fr.c
> >> +++ b/drivers/net/wan/hdlc_fr.c
> >> @@ -1008,6 +1008,7 @@ static int fr_rx(struct sk_buff *skb)
> >>  		stats->rx_bytes += skb->len;
> >>  		if (pvc->state.becn)
> >>  			stats->rx_compressed++;
> >> +		skb->dev = dev;
> >>  		netif_rx(skb);
> >>  		return NET_RX_SUCCESS;
> >>  	} else {
> >
> > Better to use netdev_alloc_skb for receive buffers instead.
> > --- a/drivers/net/wan/hdlc_fr.c	2008-06-29 13:02:42.000000000 -0700
> > +++ b/drivers/net/wan/hdlc_fr.c	2008-06-29 13:04:01.000000000 -0700
> > @@ -515,7 +515,7 @@ static void fr_lmi_send(struct net_devic
> >  		}
> >  	}
> >  
> > -	skb = dev_alloc_skb(len);
> > +	skb = netdev_alloc_skb(dev, len);
> >  	if (!skb) {
> >  		printk(KERN_WARNING "%s: Memory squeeze on fr_lmi_send()\n",
> >  		       dev->name);
> 
> Well, no, that's another story - the missing assignment is in fr_rx(),
> in the regular receive path (similar to 802.1q case, ethX ->
> ethX.VLAN_ID transition). I.e., we get incoming packet from a hardware
> driver, with skb->dev pointing to hardware hdlcX device, and we change
> it to point to a logical pvcX device.
> 
> fr_lmi_send() is for control messages (generated locally) only, in TX
> path. IOW we alloc skb and send it through hw driver immediately. Not
> related to the bug.
> 
> That said, perhaps I should indeed use netdev_alloc_skb() for those
> control messages? Or is it RX-only?

netdev_alloc_skb does two things:
  1) it sets skb->dev
  2) on some platforms it can choose memory "closer" to the device.
     but this is really a NUMA issue
