Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZDRPde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZDRPde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZDRPdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:33:18 -0400
Received: from mail.it-technology.at ([62.99.145.147]:42973 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZDRPdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:33:17 -0400
Message-ID: <0681089db5bdc5acc805ed52130dc9a5.squirrel@webmail.it-technology.at>
In-Reply-To: <Pine.LNX.4.64.0904181311470.3600@wrl-59.cs.helsinki.fi>
References: <cb6d2886e87af66d945f1052e6eb8a85.squirrel@webmail.it-technology.at>
    <Pine.LNX.4.64.0904181311470.3600@wrl-59.cs.helsinki.fi>
Date: Sat, 18 Apr 2009 17:33:15 +0200 (CEST)
Subject: Re: [Resend][PATCH] usb driver for intellon int51x1 based PLC like 
     devolo dlan duo
From: "Peter Holik" <peter@holik.at>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Netdev" <netdev@vger.kernel.org>,
       linux-usb@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static struct sk_buff *int51x1_tx_fixup(struct usbnet *dev,
>> +		struct sk_buff *skb, gfp_t flags)
>> +{
>> +	int pack_len = skb->len;
>> +	int headroom = skb_headroom(skb);
>> +	int tailroom = skb_tailroom(skb);
>> +	int need_tail = 0;
>> +	__le16 *len;
>> +
>> +	/*
>> +	 * usbnet would send a ZLP if packetlength mod urbsize == 0 for us,
>> +	 * but we need to know ourself, because this would add to the length
>> +	 * we send down to the device...
>> +	 */
>> +	if (!((pack_len + INT51X1_HEADER_SIZE) % dev->maxpacket))
>> +		need_tail = 1;
>> +
>> +	/* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
>> +	if ((pack_len + INT51X1_HEADER_SIZE + need_tail) < dev->maxpacket + 1)
>> +		need_tail = dev->maxpacket + 1 - pack_len - INT51X1_HEADER_SIZE;
>
> This is totally crazy code fragment, first need_tail is used like a
> boolean? But on the same some +1 scalar trick is being done? Is there some
> reason why DIV_ROUND_UP (linux/kernel.h) won't do what you want here and
> then you can trivally find diff = new - old ?
>

maybe this version is not so crazy for you?

        /* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
        if ((pack_len + INT51X1_HEADER_SIZE) < dev->maxpacket)
                need_tail = dev->maxpacket - pack_len - INT51X1_HEADER_SIZE + 1;
        /*
         * usbnet would send a ZLP if packetlength mod urbsize == 0 for us,
         * but we need to know ourself, because this would add to the length
         * we send down to the device...
         */
        else if (!((pack_len + INT51X1_HEADER_SIZE) % dev->maxpacket))
                need_tail = 1;

cu Peter

