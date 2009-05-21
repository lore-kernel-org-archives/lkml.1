Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZEUWYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZEUWYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZEUWYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:24:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbZEUWYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:24:40 -0400
Date: Thu, 21 May 2009 15:24:39 -0700 (PDT)
Message-Id: <20090521.152439.79009648.davem@davemloft.net>
To: buytenh@wantstofly.org
Cc: mike@it-loops.com, afleming@freescale.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: [BUG] 2.6.30-rc4: Kernel BUG under network load with gianfar
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090520214734.GA11277@mail.wantstofly.org>
References: <50F164E7-D247-4FD6-B41B-BDAA8681166B@it-loops.com>
	<20090520214734.GA11277@mail.wantstofly.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>
Date: Wed, 20 May 2009 23:47:34 +0200

> gianfar puts skbuffs that are in the rx ring back onto the recycle
> list if there was a receive error, but this breaks the following
> invariant: that all skbuffs on the recycle list have skb->data =
> skb->head + NET_SKB_PAD (NET_SKB_PAD being 32 for you).
> 
> In this case, the skb's ->data will be skb->head + RXBUF_ALIGNMENT
> (where RXBUF_ALIGNMENT is 64) when it is put onto the recycle list.
> And when gfar_new_skb() picks this skb off the recycle list again,
> it'll do:
> 
>         alignamount = RXBUF_ALIGNMENT -
>                 (((unsigned long) skb->data) & (RXBUF_ALIGNMENT - 1));
> 
>         /* We need the data buffer to be aligned properly.  We will reserve
>          * as many bytes as needed to align the data properly
>          */
>         skb_reserve(skb, alignamount);
> 
> So now skb->data will be skb->head + 128, and there won't be enough
> space between skb->head and skb->end to hold a full-sized packet.
> 
> Something like the patch below would fix it.

Let me know when a final, tested, version of this patch is available
and please make sure it makes it to netdev@vger.kernel.org

Thanks.
