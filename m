Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZKRKAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZKRKAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbZKRKAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:00:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48086 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbZKRKAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:00:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CMkMoQR+2LNwlXlNjgU6RvUOTuXfpZ3eN+N1RE9BZAZ+lodTLSkUlccOdxM0SdT6RE
         2MIsuvApIPECQiz4cjsCvjd2codJoAdo2kCbQczbhUPTxXhU521fGsG2S6IcEcRj/JKb
         Tqh0xot5l795wcnNNFyuOsU509Kl2VOl20orw=
MIME-Version: 1.0
In-Reply-To: <1258497551-25959-2-git-send-email-arnd@arndb.de>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de>
	 <1258497551-25959-2-git-send-email-arnd@arndb.de>
Date: Wed, 18 Nov 2009 11:00:57 +0100
Message-ID: <25e057c00911180200w6d732e29q3aba5f1b9d005cbd@mail.gmail.com>
Subject: Re: [PATCH 1/3] macvlan: Reflect macvlan packets meant for other 
	macvlan devices
From: roel kluin <roel.kluin@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:39 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> From: Eric Biederman <ebiederm@xmission.com>
>
> Switch ports do not send packets back out the same port they came
> in on.  This causes problems when using a macvlan device inside
> of a network namespace as it becomes impossible to talk to
> other macvlan devices.
>
> Signed-off-by: Eric Biederman <ebiederm@xmission.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I found a problem:

> @@ -140,20 +145,45 @@ static void macvlan_broadcast(struct sk_buff *skb,
>        }
>  }
>
> +static int macvlan_unicast(struct sk_buff *skb, const struct macvlan_dev *dest)
> +{
> +       struct net_device *dev = dest->dev;
> +
> +       if (unlikely(!dev->flags & IFF_UP)) {

parentheses are missing:

if (unlikely(!(dev->flags & IFF_UP))) {

> +               kfree_skb(skb);
> +               return NET_XMIT_DROP;
> +       }
> +
> +       skb = skb_share_check(skb, GFP_ATOMIC);
> +       if (!skb) {
> +               dev->stats.rx_errors++;
> +               dev->stats.rx_dropped++;
> +               return NET_XMIT_DROP;
> +       }
> +
> +       dev->stats.rx_bytes += skb->len + ETH_HLEN;
> +       dev->stats.rx_packets++;
> +
> +       skb->dev = dev;
> +       skb->pkt_type = PACKET_HOST;
> +       netif_rx(skb);
> +       return NET_XMIT_SUCCESS;
> +}
