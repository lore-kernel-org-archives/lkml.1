Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbXEZINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbXEZINt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 04:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbXEZINh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 04:13:37 -0400
Received: from stinky.trash.net ([213.144.137.162]:52420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXEZINg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 04:13:36 -0400
Message-ID: <4657EC24.1030407@trash.net>
Date: Sat, 26 May 2007 10:13:24 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adam Osuchowski <adwol@zonk.pl>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Bridge] [BUG] Dropping fragmented IP packets within VLAN frames
 on bridge
References: <20070525081750.5ba4a411@zonk.pl>	<20070525085947.12841835@freepuppy> <20070525174925.41bd6b2e@zonk.pl>
In-Reply-To: <20070525174925.41bd6b2e@zonk.pl>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Osuchowski wrote:
> Stephen Hemminger wrote:
> 
>>It would be better to account for the tag in the length check.
>>Something like
>>	if (skb->protocol == htons(ETH_P_IP) &&
>>	    skb->len > skb->dev->mtu - (IS_VLAN_IP(skb) ? VLAN_HLEN : 0) &&
>>	    !skb_is_gso(skb))
>>		return ip_fragment ...
> 
> 
> It isn't good solution because one of IS_VLAN_IP() necessary condition is
> 
>     skb->protocol == htons(ETH_P_8021Q)
> 
> which is, of course, mutually exclusive with
> 
>     skb->protocol == htons(ETH_P_IP)
> 
> from br_nf_dev_queue_xmit(). IMHO, one should check length of ETH_P_IP
> and ETH_P_8021Q frames separately:
> 
>     if (((skb->protocol == htons(ETH_P_IP) && skb->len > skb->dev->mtu) ||
>         (IS_VLAN_IP(skb) && skb->len > skb->dev->mtu - VLAN_HLEN)) &&
> 	!skb_is_gso(skb))
> 	    return ip_fragment ...


net/8021q ignores the VLAN header overhead, so we should probably do the
same here for consistency. Using IS_VLAN_IP (and IS_PPPOE_IP for current
-rc) looks fine, additionally we should probably also check for
skb->nfct != NULL to make sure that at least without connection tracking
the bridge doesn't perform fragmentation.

