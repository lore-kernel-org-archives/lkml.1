Return-Path: <linux-kernel-owner+w=401wt.eu-S934314AbXEVLcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbXEVLcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbXEVLb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:31:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:54243 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755859AbXEVLb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:31:56 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1/DXs04EVzDChydJ6znpP/HhPOjW/u3PnGjK4wl0l
	g/CqrvLOUVuUog
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: Kernel Oops with 2.6.21.1 on an AMD K7 machine
Date: Tue, 22 May 2007 13:26:58 +0200
User-Agent: KMail/1.9.5
References: <20070521222857.87180@gmx.net> <20070521155426.d0ad742b.akpm@linux-foundation.org> <200705221318.39768.uwe.bugla@gmx.de>
In-Reply-To: <200705221318.39768.uwe.bugla@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Ray Lee" <ray-lk@madrabbit.org>, Dave Jones <davej@redhat.com>,
       Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221326.59215.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 22. Mai 2007 13:18 schrieben Sie:
> Am Dienstag, 22. Mai 2007 00:54 schrieben Sie:
> > On Tue, 22 May 2007 00:28:57 +0200
> >
> > "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> > > kernel 2.6.21.1 makes my machine Oops about 20 seconds after KDE 3,5 is
> > > brought up showing its graphical login (kdm):
> >
> > We're completely blind unless we can see that oops info.
>
> Yes.
>
> And I am completely blind if I even once rely on some v4l "maintainer" who:
>
> a. has absolutely ZERO knowledge about DVB issues
> b. is not ready to share power and competence with a second or a third
> maintainer
> c. smashes down democratic votes (there have been 4 traditional highly
> experienced DVB maintainers voting for one person to resolve that issue -
> one of them was the "old rock" Ralph Metzler)
> d. reviews code that he absolutely has no idea about and signs it off
> e. gives stupid replies on specific questions due to his proven
> incompetence
>
> Would you call this man helpful and honest? My answer you can easily guess!
>
> > If it reached
> > /var/log/messages then please send it.
> >
> > If it didn't please set up netconsole
> > (Documentation/networking/netconsole.txt)
> >
> > If for some reason that isn't possible then you couldry switching to
> > the vga concole (alt-ctl-F1) before the ooops and see if the output
> > is visible on the VGA screen.  If it is there, a digital photo will suit
> > (you can email it to me and I can stick it on a server somewhere if
> > you like).  The last option is to write the oops info down with a
> > pencil and type it in again, but that's painful (all the hex addresses
> > in the stack backtrace can be omitted)
> >
> > Thanks.
>
> OK, back to the AMD K7 oops issue now:
>
> I in fact never could believe that a simple buggy NIC driver could ever
> hang up a whole machine!
>
> So, if someone could be kind enough to explain to me in how far that can
> happen I'd be very thankful.
>
> The solution for the 2.6.21.1 oops issue is the following patch, who needs
> to flow into vanilla mainline of 2.6.21.x as quick as possible:
>
> --- a/drivers/net/sis900.c
> +++ b/drivers/net/sis900.c
> @@ -1754,6 +1754,7 @@ static int sis900_rx(struct net_device *
>  			sis_priv->rx_ring[entry].cmdsts = RX_BUF_SIZE;
>  		} else {
>  			struct sk_buff * skb;
> +			struct sk_buff * rx_skb;
>
>  			pci_unmap_single(sis_priv->pci_dev,
>  				sis_priv->rx_ring[entry].bufptr, RX_BUF_SIZE,
> @@ -1787,10 +1788,10 @@ static int sis900_rx(struct net_device *
>  			}
>
>  			/* give the socket buffer to upper layers */
> -			skb = sis_priv->rx_skbuff[entry];
> -			skb_put(skb, rx_size);
> -			skb->protocol = eth_type_trans(skb, net_dev);
> -			netif_rx(skb);
> +			rx_skb = sis_priv->rx_skbuff[entry];
> +			skb_put(rx_skb, rx_size);
> +			rx_skb->protocol = eth_type_trans(rx_skb, net_dev);
> +			netif_rx(rx_skb);
>
>  			/* some network statistics */
>  			if ((rx_status & BCAST) == MCAST)
>
> Lots of thanks for Andrew Morton's helpful explanations how to store oops
> infos. Lots of thanks to all the other people trying to help.
> I love to learn! :)
>
> Best Regards
>
> Uwe

Sorry, I forgot to Cc vger.kernel.org - mea culpa!

