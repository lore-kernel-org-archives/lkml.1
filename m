Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXEaIkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXEaIkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXEaIj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:39:59 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42608 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbXEaIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:39:58 -0400
Message-ID: <465E85B5.2030106@linux.vnet.ibm.com>
Date: Thu, 31 May 2007 13:52:13 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <465D9739.8070209@openvz.org> <465D9B62.5050507@openvz.org> <20070530144737.56456aaf.akpm@linux-foundation.org>
In-Reply-To: <20070530144737.56456aaf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Wed, 30 May 2007 19:42:26 +0400
> Pavel Emelianov <xemul@openvz.org> wrote:
> 
[snip]
>>
>> +#ifdef CONFIG_RSS_CONTAINER
>> +unsigned long try_to_free_pages_in_container(struct rss_container *cnt)
>> +{
>> +	struct scan_control sc = {
>> +		.gfp_mask = GFP_KERNEL,
>> +		.may_writepage = 1,
>> +		.swap_cluster_max = 1,
>> +		.may_swap = 1,
>> +		.swappiness = vm_swappiness,
>> +		.order = 0, /* in this case we wanted one page only */
>> +		.cnt = cnt,
>> +		.isolate_pages = isolate_pages_in_container,
>> +	};
>> +	int node;
>> +	struct zone **zones;
>> +
>> +	for_each_online_node(node) {
>> +#ifdef CONFIG_HIGHMEM
>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_HIGHMEM].zones;
>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>> +			return 1;
>> +#endif
>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_NORMAL].zones;
>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>> +			return 1;
>> +	}
> 
> Definitely need to handle ZONE_DMA32 and ZONE_DMA (some architectures put
> all memory into ZONE_DMA (or they used to))

Can we iterate from MAX_NR_ZONES-1 to automatically choose the right
zone for the system?

for_each_online_node(node)
	for (i = MAX_NR_ZONES - 1; i >= 0; i--) {
 		zones = NODE_DATA(node)->node_zonelists[i].zones;
		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
			return 1;

The above code works on my PPC64 box where all memory is in ZOME_DMA.

>> +	return 0;
>> +}
>> +#endif
>> +
>>  unsigned long try_to_free_pages(struct zone **zones, int order, gfp_t gfp_mask)
>>  {
>>  	struct scan_control sc = {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
