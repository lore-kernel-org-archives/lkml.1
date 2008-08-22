Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYHVTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYHVTa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYHVTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:30:06 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:57717 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbYHVTaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:30:05 -0400
Message-ID: <48AF145B.903@opengridcomputing.com>
Date: Fri, 22 Aug 2008 14:32:43 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Karen Xie <kxie@chelsio.com>, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       michaelc@cs.wisc.edu, rdreier@cisco.com, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com,
       leedom@chelsio.com
Subject: Re: [PATCH 2/4 2.6.28] cxgb3 - handle ARP replies for private iSCSI
 IP address
References: <200808221839.m7MId8Sq004410@localhost.localdomain> <20080822121250.55949d3d.akpm@linux-foundation.org>
In-Reply-To: <20080822121250.55949d3d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 22 Aug 2008 11:39:08 -0700
> Karen Xie <kxie@chelsio.com> wrote:
>
>   
>> [PATCH 2/4 2.6.28] cxgb3 - handle ARP replies for private iSCSI IP address
>>
>> From: Karen Xie <kxie@chelsio.com>
>>
>> stg can be tricky ...
>> [adding @adapter in cxgb3_arp_process doxygen header]
>> The accelerated iSCSI traffic uses a private IP address unknown to the OS.
>> The driver has to reply to ARP requests dedicated to the private IP address.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>> ---
>>
>>  drivers/net/cxgb3/sge.c |   71 ++++++++++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 66 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
>> index 1b0861d..d2a9285 100644
>> --- a/drivers/net/cxgb3/sge.c
>> +++ b/drivers/net/cxgb3/sge.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/ip.h>
>>  #include <linux/tcp.h>
>>  #include <linux/dma-mapping.h>
>> +#include <net/arp.h>
>>  #include "common.h"
>>  #include "regs.h"
>>  #include "sge_defs.h"
>> @@ -1859,6 +1860,54 @@ static void restart_tx(struct sge_qset *qs)
>>  }
>>  
>>  /**
>> + *	cxgb3_arp_process - process an ARP request probing a private IP address
>> + *	@adapter: the adapter
>> + *	@skb: the skbuff containing the ARP request
>> + *
>> + *	Check if the ARP request is probing the private IP address
>> + *	dedicated to iSCSI, generate an ARP reply if so.
>> + */
>> +static void cxgb3_arp_process(struct adapter *adapter, struct sk_buff *skb)
>> +{
>> +	struct net_device *dev = skb->dev;
>> +	struct port_info *pi;
>> +	struct arphdr *arp;
>> +	unsigned char *arp_ptr;
>> +	unsigned char *sha;
>> +	u32 sip, tip;
>> +
>> +	if (!dev)
>> +		return;
>>     
>
> Can this happen?
>
>   
>> +	skb_reset_network_header(skb);
>> +	arp = arp_hdr(skb);
>> +
>> +	if (arp->ar_op != htons(ARPOP_REQUEST))
>> +		return;
>> +
>> +	arp_ptr = (unsigned char *)(arp + 1);
>> +	sha = arp_ptr;
>> +	arp_ptr += dev->addr_len;
>> +	memcpy(&sip, arp_ptr, 4);
>> +	arp_ptr += 4;
>> +	arp_ptr += dev->addr_len;
>> +	memcpy(&tip, arp_ptr, 4);
>>     
>
> Should arp_hdr_len() be used here?
>
>   
>> +	pi = netdev_priv(dev);
>> +	if (ntohl(tip) != pi->iscsi_ipaddr)
>> +		return;
>> +
>> +	arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
>> +		 dev->dev_addr, sha);
>> +
>> +}
>> +
>> +static inline int is_arp(struct sk_buff *skb)
>> +{
>> +	return skb->protocol == htons(ETH_P_ARP);
>>     
>
> Other net code uses __constant_htons() for this.
>
> (Dunno why - if it makes a difference, htons() is broken?)
>
>
>   
Doesn't this avoid complaints from sparse endian checking?


