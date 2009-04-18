Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZDRPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZDRPpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZDRPpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:45:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47120 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZDRPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:45:31 -0400
Date: Sat, 18 Apr 2009 18:45:29 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Peter Holik <peter@holik.at>
cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [Resend][PATCH] usb driver for intellon int51x1 based PLC like
      devolo dlan duo
In-Reply-To: <0681089db5bdc5acc805ed52130dc9a5.squirrel@webmail.it-technology.at>
Message-ID: <Pine.LNX.4.64.0904181834210.3691@wrl-59.cs.helsinki.fi>
References: <cb6d2886e87af66d945f1052e6eb8a85.squirrel@webmail.it-technology.at>
    <Pine.LNX.4.64.0904181311470.3600@wrl-59.cs.helsinki.fi>
 <0681089db5bdc5acc805ed52130dc9a5.squirrel@webmail.it-technology.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009, Peter Holik wrote:

> >> +static struct sk_buff *int51x1_tx_fixup(struct usbnet *dev,
> >> +		struct sk_buff *skb, gfp_t flags)
> >> +{
> >> +	int pack_len = skb->len;
> >> +	int headroom = skb_headroom(skb);
> >> +	int tailroom = skb_tailroom(skb);
> >> +	int need_tail = 0;
> >> +	__le16 *len;
> >> +
> >> +	/*
> >> +	 * usbnet would send a ZLP if packetlength mod urbsize == 0 for us,
> >> +	 * but we need to know ourself, because this would add to the length
> >> +	 * we send down to the device...
> >> +	 */
> >> +	if (!((pack_len + INT51X1_HEADER_SIZE) % dev->maxpacket))
> >> +		need_tail = 1;
> >> +
> >> +	/* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
> >> +	if ((pack_len + INT51X1_HEADER_SIZE + need_tail) < dev->maxpacket + 1)
> >> +		need_tail = dev->maxpacket + 1 - pack_len - INT51X1_HEADER_SIZE;
> >
> > This is totally crazy code fragment, first need_tail is used like a
> > boolean? But on the same some +1 scalar trick is being done? Is there some
> > reason why DIV_ROUND_UP (linux/kernel.h) won't do what you want here and
> > then you can trivally find diff = new - old ?
> >
> 
> maybe this version is not so crazy for you?
> 
>         /* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
>         if ((pack_len + INT51X1_HEADER_SIZE) < dev->maxpacket)
>                 need_tail = dev->maxpacket - pack_len - INT51X1_HEADER_SIZE + 1;
>         /*
>          * usbnet would send a ZLP if packetlength mod urbsize == 0 for us,
>          * but we need to know ourself, because this would add to the length
>          * we send down to the device...
>          */
>         else if (!((pack_len + INT51X1_HEADER_SIZE) % dev->maxpacket))
>                 need_tail = 1;

Certainly looks more obvious, having that + need_tail and the related + 1 
on the other side of the condition made the original very hard to read 
(and I failed to read it correctly which was the reason for the wrong 
DIV_ROUND_UP comment I made). This one is much better. I guess adding
a temporary var for pack_len + INT51X1_HEADER_SIZE would also make it 
somewhat nicer looking.


-- 
 i.
