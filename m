Return-Path: <linux-kernel-owner+w=401wt.eu-S1764121AbYASEif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764121AbYASEif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760143AbYASEi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:38:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYASEi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:38:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=eG/rZ1kqNSMof2CDJLttGbySpxywwfuz43NjqdMNCyDW0PdXW6J6DzR/ZWbMzPoxS
	MTzXBztFzqTGcWDd6vkHw==
Date: Fri, 18 Jan 2008 20:36:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, mingo@elte.hu,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
In-Reply-To: <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com>
Message-ID: <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
References: <20080118183011.354965000@sgi.com>  <20080118183011.527888000@sgi.com> <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Yinghai Lu wrote:

> > +#if MAX_NUMNODES > 256
> > +typedef u16 numanode_t;
> > +#else
> > +typedef u8 numanode_t;
> > +#endif
> > +
> >  #endif /* _LINUX_NUMA_H */
> 
> that is wrong, you can not change pxm_to_node_map from int to u8 or u16.
> 

Yeah, NID_INVAL is negative so no unsigned type will work here, 
unfortunately.  And that reduces the intended savings of your change since 
the smaller type can only be used with a smaller CONFIG_NODES_SHIFT.

> int acpi_map_pxm_to_node(int pxm)
> {
>         int node = pxm_to_node_map[pxm];
> 
>         if (node < 0){
>                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
>                         return NID_INVAL;
>                 node = first_unset_node(nodes_found_map);
>                 __acpi_map_pxm_to_node(pxm, node);
>                 node_set(node, nodes_found_map);
>         }
> 
>         return node;
> }
> 
> node will will be always 255 or 65535
> 

Right.

> please keep that to int.
> 
> I got
> SART: PXM 0 -> APIC 0 -> Node 255
> SART: PXM 0 -> APIC 1 -> Node 255
> SART: PXM 1 -> APIC 2 -> Node 255
> SART: PXM 1 -> APIC 3 -> Node 255
> 

I assume this is a typo and those proximity mappings are actually from the 
SRAT.

		David
