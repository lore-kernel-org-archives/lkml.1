Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZJMKVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZJMKVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbZJMKVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:21:06 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:53513 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332AbZJMKVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:21:04 -0400
Message-ID: <4AD45447.7030705@gmail.com>
Date: Tue, 13 Oct 2009 12:19:51 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Massimo Cetra <ctrixk@navynet.it>
CC: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera> <20091012.034224.64980795.davem@davemloft.net> <4AD44435.3050703@navynet.it>
In-Reply-To: <4AD44435.3050703@navynet.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 13 Oct 2009 12:19:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Massimo Cetra a écrit :
> David Miller ha scritto:
>> From: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Date: Mon, 12 Oct 2009 00:22:04 +0200 (CEST)
>>
>>  
>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14378
>>> Subject        : Problems with net/core/skbuff.c
>>> Submitter    : Massimo Cetra <mcetra@navynet.it>
>>> Date        : 2009-10-08 14:51 (4 days old)
>>> References    : http://marc.info/?l=linux-kernel&m=125501488220358&w=4
>>>     
>>
>> I don't know what to do about this one.
>>
>> The user indicates that they have the vserver patches applied,
>> so maybe there is some interaction with that stuff.
>>   
> Actually i found another oops which is very similar to the previous one.
> Here, vserver is not involved, and the problem starts at drbd which
> lives in kernel space (the other oops started at ocfs2).
> 
> Both ocfs2 and drbd make heavy use of network I/O so i guess the problem
> is something in the network layer.
> 
> Anything i can do to help to debugging and solving this issue ?
> 
> Thanks
> Max
> 

Problem is kfree_skb() is called from irq context, wich is not allowed.

static void skb_release_head_state(struct sk_buff *skb)
{
...
if (skb->destructor) {
	WARN_ON(in_irq());
	skb->destructor();
}
...
}

virtio_net start_xmit() function calls free_old_xmit_skbs() and 
free_old_xmit_skbs() ultimately calls kfree_skb()

Quick fix would be to use dev_kfree_skb_any() instead,
because netpoll can definitly calls start_xmit()
with irq disabled.

Could you please following patch ?

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d00976..54bf091 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -454,7 +454,7 @@ static unsigned int free_old_xmit_skbs(struct virtnet_info *vi)
 		vi->dev->stats.tx_bytes += skb->len;
 		vi->dev->stats.tx_packets++;
 		tot_sgs += skb_vnet_hdr(skb)->num_sg;
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 	}
 	return tot_sgs;
 }


