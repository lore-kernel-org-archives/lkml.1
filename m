Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbZCYNo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbZCYNo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbZCYNn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:43:59 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45872 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761093AbZCYNn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:43:57 -0400
Message-ID: <49CA345B.3070103@cosmosbay.com>
Date: Wed, 25 Mar 2009 14:40:43 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work properly
 in bridge -try2
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090325130443.GG3437@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090325130443.GG3437@psychotron.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 25 Mar 2009 14:40:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko a écrit :
> (resend)
> 
> Hi all.
> 
> The problem is described in following bugzilla:
> https://bugzilla.redhat.com/show_bug.cgi?id=487763
> 
> Basically here's what's going on. In every mode, bonding interface uses the same
> mac address for all enslaved devices. Except for mode balance-alb. When you put
> this kind of bond device into a bridge it will only add one of mac adresses into
> a hash list of mac addresses, say X. This mac address is marked as local. But
> this bonding interface also has mac address Y. Now then packet arrives with
> destination address Y, this address is not marked as local and the packed looks
> like it needs to be forwarded. This packet is then lost which is wrong.
> 
> Notice that interfaces can be added and removed from bond while it is in bridge.
> 
> This patch solves the situation in the bonding without touching bridge code,
> as Patrick suggested. For every incoming frame to bonding it searches the
> destination address in slaves list and if any of slave addresses matches, it
> rewrites the address in frame by the adress of bonding master. This ensures that
> all frames comming thru the bonding in alb mode have the same address.
> 
> Jirka
> 
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 27fb7f5..2838be0 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -1762,6 +1762,26 @@ int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr)
>  	return 0;
>  }
>  
> +void bond_alb_change_dest(struct sk_buff *skb)
> +{
> +	struct net_device *bond_dev = skb->dev;
> +	struct bonding *bond = netdev_priv(bond_dev);
> +	unsigned char *dest = eth_hdr(skb)->h_dest;
> +	struct slave *slave;
> +	int i;
> +
> +	if (!memcmp(dest, bond_dev->dev_addr, ETH_ALEN))
> +		return;
> +	read_lock(&bond->lock);


Its a pity bonding doesnt use RCU and needs this read_lock(&bond->lock)


> +	bond_for_each_slave(bond, slave, i) {
> +		if (!memcmp(slave->dev->dev_addr, dest, ETH_ALEN)) {

compare_ether_addr() (or even better compare_ether_addr_64bits()) instead of memcmp() ?

> +			memcpy(dest, bond_dev->dev_addr, ETH_ALEN);
> +			break;
> +		}
> +	}
> +	read_unlock(&bond->lock);
> +}
> +

