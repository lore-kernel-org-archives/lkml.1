Return-Path: <linux-kernel-owner+w=401wt.eu-S1764056AbXEYRtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764056AbXEYRtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbXEYRtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:49:36 -0400
Received: from hydra.ck.polsl.pl ([157.158.1.11]:55515 "EHLO hydra.ck.polsl.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXEYRtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:49:36 -0400
Date: Fri, 25 May 2007 19:49:25 +0200
From: Adam Osuchowski <adwol@zonk.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Bridge] [BUG] Dropping fragmented IP packets within VLAN frames on bridge
Message-ID: <20070525174925.41bd6b2e@zonk.pl>
Reply-To: Adam Osuchowski <adwol@zonk.pl>
References: <20070525081750.5ba4a411@zonk.pl> <20070525085947.12841835@freepuppy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525085947.12841835@freepuppy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> It would be better to account for the tag in the length check.
> Something like
> 	if (skb->protocol == htons(ETH_P_IP) &&
> 	    skb->len > skb->dev->mtu - (IS_VLAN_IP(skb) ? VLAN_HLEN : 0) &&
> 	    !skb_is_gso(skb))
> 		return ip_fragment ...

It isn't good solution because one of IS_VLAN_IP() necessary condition is

    skb->protocol == htons(ETH_P_8021Q)

which is, of course, mutually exclusive with

    skb->protocol == htons(ETH_P_IP)

from br_nf_dev_queue_xmit(). IMHO, one should check length of ETH_P_IP
and ETH_P_8021Q frames separately:

    if (((skb->protocol == htons(ETH_P_IP) && skb->len > skb->dev->mtu) ||
        (IS_VLAN_IP(skb) && skb->len > skb->dev->mtu - VLAN_HLEN)) &&
	!skb_is_gso(skb))
	    return ip_fragment ...
