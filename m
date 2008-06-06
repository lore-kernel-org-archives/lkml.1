Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbYFFUzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbYFFUzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYFFUza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:55:30 -0400
Received: from dmzmta102.na.baesystems.com ([149.32.252.102]:19540 "EHLO
	dmzmta102.na.baesystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYFFUz3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:55:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NET: Proper handling of IPv6 header in tun driver whenTUN_NO_PI is set
Date: Fri, 6 Jun 2008 16:55:20 -0400
Message-ID: <81E1305DE5C9BB4089AF6F74955100D9067CBD8D@blums0017.bluelnk.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NET: Proper handling of IPv6 header in tun driver whenTUN_NO_PI is set
Thread-Index: AcjIFrqfNSOmoG2BSDmrakc4PldB9gAAFZow
References: <4849162D.7000401@nav6.org><48499C32.6070703@qualcomm.com> <20080606134833.3a5a8dc2@extreme>
From: "Zabele, Stephen \(US SSA\)" <steve.zabele@baesystems.com>
To: "Stephen Hemminger" <shemminger@vyatta.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>
Cc: "Ang Way Chuang" <wcang@nav6.org>, "David Miller" <davem@davemloft.net>,
       <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Jun 2008 20:55:21.0290 (UTC) FILETIME=[A24E42A0:01C8C817]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max: Now understand your comment about additional copy_from_user --
yeah, we do not want to make extra function calls if we don't need to.

I do concur with Stephen's comments. 

Also, while we are at it, I guess we could also add in the IPX case --
although I'd bet IPX is OBE at this point. 

Steve

-----Original Message-----
From: Stephen Hemminger [mailto:shemminger@vyatta.com] 
Sent: Friday, June 06, 2008 4:49 PM
To: Max Krasnyanskiy
Cc: Ang Way Chuang; David Miller; Zabele, Stephen (US SSA);
netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: Proper handling of IPv6 header in tun driver
whenTUN_NO_PI is set

On Fri, 06 Jun 2008 13:21:06 -0700
Max Krasnyanskiy <maxk@qualcomm.com> wrote:

> Acked-by: Max Krasnyansky <maxk@qualcomm.com>
> 
> Dave, can you please add this patch to your tree.
> 
> --
> Steve, this is what I meant by "we do not need extra copy_from_user".
We 
> already do copy into the SKB and can parse the header right there.
> 
> Max
> 
> 
> 
> 
> Ang Way Chuang wrote:
> > By default, tun.c running in TUN_TUN_DEV mode will set the protocol
of 
> > packet to IPv4 if TUN_NO_PI is set. My program failed to work when I

> > assumed that the driver will check the first nibble of packet,
determine 
> > IP version and set the appropriate protocol.
> > 
> > The test for this change was conducted on 2.6.24.7 kernel. But the
diff 
> > is produced using git commit
> > c3b25b32e8bef526cca748e1ba023c6bdd705a99. I couldn't test it on
kernel 
> > version greater than 2.6.25 due to out of tree driver failing to 
> > compile. But tun_get_user doesn't change that much between 2.6.24
and 
> > 2.6.26, so it should work, I hope :-D. This patch is trivial because

> > this problem can also be fixed by not using TUN_NO_PI.
> > 
> > Signed-off-by: Ang Way Chuang <wcang@nav6.org>
> > ---
> > 
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 0ce07a3..77964bc 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -313,6 +313,21 @@ static __inline__ ssize_t tun_get_user(struct 
> > tun_struct *tun, struct iovec *iv,
> > 
> >         switch (tun->flags & TUN_TYPE_MASK) {
> >         case TUN_TUN_DEV:
> > +               if (tun->flags & TUN_NO_PI) {
> > +                       switch (skb->data[0] & 0xf0) {

Why the magic constants, instead of proper casts and defines.
> > +                       case 0x40:
> > +                               pi.proto =
__constant_htons(ETH_P_IP);

Use htons() instead of __constant_htons() it is easier to read,
and the compiler already does the right thing.

> > +                               break;
> > +                       case 0x60:
> > +                               pi.proto =
__constant_htons(ETH_P_IPV6);
> > +                               break;
> > +                       default:
> > +                               tun->dev->stats.rx_dropped++;
> > +                               kfree_skb(skb);
> > +                               return -EINVAL;
> > +                       }
> > +               }
> > +
> >                 skb_reset_mac_header(skb);
> >                 skb->protocol = pi.proto;
> >                 skb->dev = tun->dev;
> > 
> > -- 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

