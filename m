Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYASVZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYASVZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYASVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:25:39 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751416AbYASVZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:25:38 -0500
Message-ID: <47926ACC.4060707@sgi.com>
Date: Sat, 19 Jan 2008 13:25:32 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
References: <20080118183011.354965000@sgi.com>  <20080118183011.527888000@sgi.com> <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com> <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Fri, 18 Jan 2008, Yinghai Lu wrote:
> 
>>> +#if MAX_NUMNODES > 256
>>> +typedef u16 numanode_t;
>>> +#else
>>> +typedef u8 numanode_t;
>>> +#endif
>>> +
>>>  #endif /* _LINUX_NUMA_H */
>> that is wrong, you can not change pxm_to_node_map from int to u8 or u16.
>>

Thanks for finding this!

> 
> Yeah, NID_INVAL is negative so no unsigned type will work here, 
> unfortunately.  And that reduces the intended savings of your change since 
> the smaller type can only be used with a smaller CONFIG_NODES_SHIFT.
> 

Excuse my ignorance but why wouldn't this work:

static numanode_t pxm_to_node_map[MAX_PXM_DOMAINS]
                                = { [0 ... MAX_PXM_DOMAINS - 1] = NUMA_NO_NODE };
...
>> int acpi_map_pxm_to_node(int pxm)
>> {
>         int node = pxm_to_node_map[pxm];
> 
>         if (node < 0)

	   numanode_t node = pxm_to_node_map[pxm];

	   if (node != NUMA_NO_NODE) {
>>                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
>>                         return NID_INVAL;
>>                 node = first_unset_node(nodes_found_map);
>>                 __acpi_map_pxm_to_node(pxm, node);
>>                 node_set(node, nodes_found_map);
>>         }

or change:
	#define NID_INVAL       (-1)
to
	#define NID_INVAL       ((numanode_t)(-1))
...
	   if (node != NID_INVAL) {
>>                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
>>                         return NID_INVAL;
>>                 node = first_unset_node(nodes_found_map);
>>                 __acpi_map_pxm_to_node(pxm, node);
>>                 node_set(node, nodes_found_map);
>>         }

Though why there two "node invalid" values I'm not sure... ?

>>
>>         return node;
>> }

And btw, shouldn't the pxm value be sized to numanode_t size as well?
Will it ever be larger than the largest node id?

Thanks,
Mike
