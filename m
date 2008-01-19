Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYASWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYASWeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYASWeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:34:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:40512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYASWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:34:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=acoUMKqKYe6zODlF0bEGwEBtPc+7BalGg/oaoHezohVo13Hwkjf2hJelbtHSa2xT6
	AW8qys4B4n8UVl34vDVNA==
Date: Sat, 19 Jan 2008 14:33:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
In-Reply-To: <47926ACC.4060707@sgi.com>
Message-ID: <alpine.DEB.0.9999.0801191415360.28596@chino.kir.corp.google.com>
References: <20080118183011.354965000@sgi.com>  <20080118183011.527888000@sgi.com> <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com> <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com> <47926ACC.4060707@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jan 2008, Mike Travis wrote:

> > Yeah, NID_INVAL is negative so no unsigned type will work here, 
> > unfortunately.  And that reduces the intended savings of your change since 
> > the smaller type can only be used with a smaller CONFIG_NODES_SHIFT.
> > 
> 
> Excuse my ignorance but why wouldn't this work:
> 
> static numanode_t pxm_to_node_map[MAX_PXM_DOMAINS]
>                                 = { [0 ... MAX_PXM_DOMAINS - 1] = NUMA_NO_NODE };
> ...
> >> int acpi_map_pxm_to_node(int pxm)
> >> {
> >         int node = pxm_to_node_map[pxm];
> > 
> >         if (node < 0)
> 
> 	   numanode_t node = pxm_to_node_map[pxm];
> 

Because NUMA_NO_NODE is 0xff on x86.  That's a valid node id for 
configurations with CONFIG_NODES_SHIFT equal to or greater than 8.

> 	   if (node != NUMA_NO_NODE) {

Wrong, this should be

	node == NUMA_NO_NODE

> >>                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
> >>                         return NID_INVAL;
> >>                 node = first_unset_node(nodes_found_map);
> >>                 __acpi_map_pxm_to_node(pxm, node);
> >>                 node_set(node, nodes_found_map);
> >>         }
> 

The net result of this is that if a proximity domain is looked up through 
acpi_map_pxm_to_node() and already has a mapping to node 255 (legal with 
CONFIG_NODES_SHIFT == 8), this function will return NID_INVAL since the 
weight of nodes_found_map is equal to MAX_NUMNODES.

You simply can't use valid node id's to signify invalid or unused node 
ids.

> or change:
> 	#define NID_INVAL       (-1)
> to
> 	#define NID_INVAL       ((numanode_t)(-1))
> ...
> 	   if (node != NID_INVAL) {

You mean

	node == NID_INVAL

> >>                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
> >>                         return NID_INVAL;
> >>                 node = first_unset_node(nodes_found_map);
> >>                 __acpi_map_pxm_to_node(pxm, node);
> >>                 node_set(node, nodes_found_map);
> >>         }
> 

That's the equivalent of your NUMA_NO_NODE code above.  The fact remains 
that (numanode_t)-1 is still a valid node id for MAX_NUMNODES >= 256.

So, as I said in my initial reply, the only way to get the savings you're 
looking for is to use u8 for CONFIG_NODES_SHIFT <= 7 and then convert all 
NID_INVAL users to use NUMA_NO_NODE.

Additionally, Linux has always discouraged typedefs when they do not 
define an architecture-specific size.  The savings from your patch for 
CONFIG_NODES_SHIFT == 7 would be 256 bytes for this mapping.

It's simply not worth it.

> And btw, shouldn't the pxm value be sized to numanode_t size as well?
> Will it ever be larger than the largest node id?
> 

Section 6.2.9 of ACPI 2.0 states that PXM's return an integer, so that 
would be non-conforming to the standard.

Additionally, PXM's are not nodes, so casting them to anything called 
numanode_t shows the semantic flaw in your patch.

		David
