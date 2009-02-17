Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZBQXPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZBQXPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZBQXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:14:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:57754 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZBQXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:14:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=Uu69qdACngA1XzlZe/uWJcoptcB2pyhjsPVNHgPq2uX9Z9AEawv+3g134EUctkW4t3
         sF1Vbuh+VkFE44l0L1lgdVDMPOJVEHUSvJw4YBYJ0XUf2n/KD3ZdXWf+k66F2zsUEj5z
         RafyqQ9d4i083TQ5edUYdH4BbVLOgP9LKOpJ0=
Date: Wed, 18 Feb 2009 00:12:55 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090217231255.GA3389@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499AB345.3070904@hiramoto.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Hiramoto wrote, On 02/17/2009 01:53 PM:

> Jarek Poplawski wrote:
>> On Tue, Feb 17, 2009 at 12:49:07PM +0100, Karl Hiramoto wrote:
>> ...
>>   
>>> A side note:  so far the original patch i sent works in all cases i have
>>> tested, but fails with tcpdump.   I suspect its because the skb gets cloned.
>>>     
>> If there is something readable from this tcpdump, it should be helpful
>> to see a packet for working and non-working case during such ping
>> (with -nXX option).
>> Jarek P.
>>   
> 
> Note:  I have the patches i sent applied,  plus the  "skb->mac_header -=
> VLAN_HLEN;"   patch from Jarek on 2.6.28.4
> 
> Doing a tcpdump simultaneously  on the atm and eth0.1 on the linux router.

Nice job. Since tcpdump sees corrupted data, and we don't know if it's
before or after hitting the driver I'd suggest to try full skb_copy()
yet. So could you try if with your patch + the patch below tcpdump
still breaks these things?

BTW, I wonder what IXP400 config options do you use (especially
CONFIG_IXP400_ETH_SKB_RECYCLE)?

Jarek P.

--- patch #3 (for debugging only)

 net/core/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a17e006..b822a5d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1346,7 +1346,7 @@ static void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev)
 		if ((ptype->dev == dev || !ptype->dev) &&
 		    (ptype->af_packet_priv == NULL ||
 		     (struct sock *)ptype->af_packet_priv != skb->sk)) {
-			struct sk_buff *skb2= skb_clone(skb, GFP_ATOMIC);
+			struct sk_buff *skb2= skb_copy(skb, GFP_ATOMIC);
 			if (!skb2)
 				break;
 
