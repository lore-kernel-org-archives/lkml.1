Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbXEZPF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbXEZPF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761320AbXEZPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:05:48 -0400
Received: from stinky.trash.net ([213.144.137.162]:60430 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbXEZPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:05:47 -0400
Message-ID: <46584CC6.3020705@trash.net>
Date: Sat, 26 May 2007 17:05:42 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
CC: Adam Osuchowski <adwol@zonk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [Bridge] [BUG] Dropping fragmented IP packets within VLAN frames
 on bridge
References: <20070525081750.5ba4a411@zonk.pl> <20070525174925.41bd6b2e@zonk.pl> <4657EC24.1030407@trash.net> <200705261621.00385.ioe-lkml@rameria.de>
In-Reply-To: <200705261621.00385.ioe-lkml@rameria.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser wrote:
> On Saturday 26 May 2007, Patrick McHardy wrote:
> 
>>net/8021q ignores the VLAN header overhead, so we should probably do the
>>same here for consistency. Using IS_VLAN_IP (and IS_PPPOE_IP for current
>>-rc) looks fine, additionally we should probably also check for
>>skb->nfct != NULL to make sure that at least without connection tracking
>>the bridge doesn't perform fragmentation.
> 
> 
> And could we separe the conditions for that into a static helper function
> explaining each of these conditions? e.g. sth. like that:


The MTU checks are self-explanatory. Just a comment above the function
stating that it tries to find out whether a packet needs to be
refragmented because it was defragmented by IPv4 connection tracking
and exceeds the MTU should be enough.

> static bool br_nf_need_fragment(struct sk_buff *skb)
> {
> 	/* Plain IP packet does not fit in MTU */
> 	if (!(skb->protocol == htons(ETH_P_IP) && skb->len > skb->dev->mtu))
> 		return true;
> 
> 	/* VLAN encapsulated IP packet does not fit in MTU */
> 	if (IS_VLAN_IP(skb) && skb->len > skb->dev->mtu - VLAN_HLEN)
> 		return true;
> 
> 	/* PPPoE encapsulated IP packet does not fit in MTU */
> 	if (IS_PPPOE_IP(skb) && skb->len > skb->dev->mtu - PPPOE_SES_HLEN)
> 		return true;
> 
> 	return false;
> }


As I said, I don't think we should account for the VLAN header overhead,
the VLAN code itself doesn't even do it. And we should exclude packets
that don't have a connection tracking reference attached since we are
only undoing the damage connection tracking did by defragmenting it
and should avoid fragmenting other packets as good as possible.

> and then br_nf_dev_queue_xmit() becomes:
> 
> static int br_nf_dev_queue_xmit(struct sk_buff *skb)
> {
>         if (br_nf_need_fragment(skb) &&  !skb_is_gso(skb))
>                 return ip_fragment(skb, br_dev_queue_push_xmit);
>         else
>                 return br_dev_queue_push_xmit(skb);
> }
> 
> which is much more readable, more documented and doesn't contain a condition monster :-)
> 
> @Patrick: Could you check, wether the PPPoE case is correct?


It looks OK. But there is another problem, ip_fragment doesn't care
about the PPPoE overhead and produces a packet that will be too large
after restoring the PPPoE header. A second __fake_rtable that accounts
for the PPPoE overhead could probably fix that ..

> What do you think? Should I submit a patch for that?


Sure :)
