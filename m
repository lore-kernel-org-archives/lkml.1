Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbZDWTXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbZDWTXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZDWTX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:23:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZDWTX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:23:26 -0400
Date: Thu, 23 Apr 2009 21:22:55 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: stefan novak <lms.brubaker@gmail.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bond interface arp, vlan and trunk / network question
Message-ID: <20090423192254.GA1618@psychotron.englab.brq.redhat.com>
References: <1ef444010904201403s5d583750i1ce3a5da6c6f4059@mail.gmail.com> <13606.1240262581@death.nxdomain.ibm.com> <1ef444010904201439i60f9e918j760d94eeca428ece@mail.gmail.com> <22462.1240272112@death.nxdomain.ibm.com> <1ef444010904220129l24a74f07q8f32edfabe603436@mail.gmail.com> <32563.1240449149@death.nxdomain.ibm.com> <20090423074803.GB29268@psychotron.englab.brq.redhat.com> <12644.1240498781@death.nxdomain.ibm.com> <20090423152005.GI29268@psychotron.englab.brq.redhat.com> <3302.1240511660@death.nxdomain.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3302.1240511660@death.nxdomain.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, Apr 23, 2009 at 08:34:20PM CEST, fubar@us.ibm.com wrote:
>Jiri Pirko <jpirko@redhat.com> wrote:
>>Thu, Apr 23, 2009 at 04:59:41PM CEST, fubar@us.ibm.com wrote:
>>>Jiri Pirko <jpirko@redhat.com> wrote:
>[...]
>>>>>+{
>>>>>+	struct net_device *dev = skb->dev;
>>>>>+	struct net_device *master = dev->master;
>>>>>+
>>>>>+	if (master)
>>>>>+		return bond_handle_frame_hook(skb);
>>>>
>>>>Maybe this hook can be called from netif_receive_skb() directly. You would safe
>>>>at least 2 dereferences, 1 if check. You would also need to add
>>>>"skb->dev->master &&" to if in __vlan_hwaccel_rx() and vlan_gro_common().
>>>
>>>	This won't work, because the VLAN code reassigns skb->dev to the
>>>VLAN device before calling netif_receive_skb.
>>
>>Sure, but bond_should_drop is called before it actually reassigns that. So the
>>check in bond_should_drop tests "original_dev->master".
>>
>>I had on mind something like following:
>>
>>Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>>
>>diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
>>index c67fe6f..87a7334 100644
>>--- a/net/8021q/vlan_core.c
>>+++ b/net/8021q/vlan_core.c
>>@@ -11,7 +11,7 @@ int __vlan_hwaccel_rx(struct sk_buff *skb, struct vlan_group *grp,
>> 	if (netpoll_rx(skb))
>> 		return NET_RX_DROP;
>>
>>-	if (skb_bond_should_drop(skb))
>>+	if (skb->dev->master && bond_handle_frame_hook(skb))
>[...]
>
>	Yah, ok, I see what you mean.  The same could be accomplished by
>turning skb_bond_should_drop back into an inline in the header file, and

Well no exactly. In vlan_x certainly yes but in netif_receive_skb() you safe
something by not checking ->master twice and 2 dereferences. Just noting when I
see the waste...

>hiding the fiddly bits from the calling context.
>
>	It's pretty grotty no matter how it's done; I'd prefer to avoid
>the whole hook business, but I haven't thought of a less bad way.

Yes I agree hooking this sucks :/ Anyway, is there any movement to eliminate
all these hooks from netif_receive_skb() ?

	Jirka
>
>	-J
>
>---
>	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
