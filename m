Return-Path: <linux-kernel-owner+w=401wt.eu-S932644Ab0AGI1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0AGI1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192Ab0AGI1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:27:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60342 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab0AGI1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wu1wvLA5ZPEVDd/L/B08jU59BUAlcCRXL3hk0yn9FH5jVg5IYrW1WjxbXQA/NWcHon
         DPFw/67v6ZbFhZNTPi/pZCmzAlWkamhv8Fz7HFhxcJqpMwgEVglUEe7IipLFVS9nThr5
         n3TPLNJ0gO7s6ayq8wrSA5bzDnicnVncwqfJ8=
MIME-Version: 1.0
In-Reply-To: <20100106091257.GB599@redhat.com>
References: <4B43AEF6.6050701@nortel.com>
	 <20100105.134218.258781374.davem@davemloft.net>
	 <4B43B989.4010004@nortel.com>
	 <20100105.155150.232916389.davem@davemloft.net>
	 <20100106091257.GB599@redhat.com>
Date: Thu, 7 Jan 2010 09:27:48 +0100
Message-ID: <e2d7436a1001070027u44dbb9abx94541bcf7d7e2418@mail.gmail.com>
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, cfriesen@nortel.com,
       eric.dumazet@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/6 Michael S. Tsirkin <mst@redhat.com>:
> On Tue, Jan 05, 2010 at 03:51:50PM -0800, David Miller wrote:
>> From: "Chris Friesen" <cfriesen@nortel.com>
>> Date: Tue, 05 Jan 2010 16:13:29 -0600
>> > If SOCK_RAW packets are being sent, the protocol number is embedded in
>> > the packet data
>> Where exactly is that protocol value?  Not every link level protocol
>> is ethernet.
>> We support FDDI, HIPPI, wireless, VLAN, PPP, and a host of others.
>> So you can't know for sure unless you assume ethernet, which you
>> can't do.
> You are right.  This is TX though so the socket is bound to a specific
> device, and devices know which link protocol they use.  So we could add a
> get_protocol operation to each device type, and call it if the protocol
> passed is ETH_P_ALL to get the real one.
>
> Like this: except I only added this for ethernet, and I would have to
> add this for the rest of device types. But I would like to hear what
> others think about this before I do the rest of the work for the rest of
> device types.
>
> Does the below look sane?
>
[...]
> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index 205a1c1..3e7761d 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -231,6 +231,17 @@ int eth_header_parse(const struct sk_buff *skb, unsigned char *haddr)
>  EXPORT_SYMBOL(eth_header_parse);
>
>  /**
> + * eth_get_protocol - extract protocol value from packet
> + * @skb: packet to extract protocol from
> + * @dev: source device
> + */
> +__be16 eth_get_protocol(const struct sk_buff *skb, struct net_device *dev)
> +{
> +       const struct ethhdr *eth = eth_hdr(skb);
> +       return eth->h_proto
> +}
[...]

You might want taking fragment of eth_type_trans() for this function
so that 802.2/IPX would be detected too.

Best Regards,
Micha³ Miros³aw
