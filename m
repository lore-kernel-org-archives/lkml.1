Return-Path: <linux-kernel-owner+w=401wt.eu-S1765225AbYASEnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765225AbYASEnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbYASEne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:43:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:59388 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760956AbYASEnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:43:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jYzniKzRvBqoY6akJAaNOQbHz9JWoEkiGgr5YOe1Fo8S9WKY+DyuMgFxQow9NlaTUvkdYZJFJXRLMEN97sb0xJVsC1mp5zH/hxFy15G8EpE/lE0REP8VTtCDXh6V8Sr3d64bIR/agnSADUzkclaa87d4UuKqwY5TwtVom4fMkxk=
Message-ID: <86802c440801182043l1f36086bq51d1fa0528e6bd74@mail.gmail.com>
Date: Fri, 18 Jan 2008 20:43:33 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
Cc: travis@sgi.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <ak@suse.de>, mingo@elte.hu,
       "Christoph Lameter" <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118183011.354965000@sgi.com>
	 <20080118183011.527888000@sgi.com>
	 <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com>
	 <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 8:36 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 18 Jan 2008, Yinghai Lu wrote:
>
> > > +#if MAX_NUMNODES > 256
> > > +typedef u16 numanode_t;
> > > +#else
> > > +typedef u8 numanode_t;
> > > +#endif
> > > +
> > >  #endif /* _LINUX_NUMA_H */
> >
> > that is wrong, you can not change pxm_to_node_map from int to u8 or u16.
> >
>
> Yeah, NID_INVAL is negative so no unsigned type will work here,
> unfortunately.  And that reduces the intended savings of your change since
> the smaller type can only be used with a smaller CONFIG_NODES_SHIFT.
>
> > int acpi_map_pxm_to_node(int pxm)
> > {
> >         int node = pxm_to_node_map[pxm];
> >
> >         if (node < 0){
> >                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
> >                         return NID_INVAL;
> >                 node = first_unset_node(nodes_found_map);
> >                 __acpi_map_pxm_to_node(pxm, node);
> >                 node_set(node, nodes_found_map);
> >         }
> >
> >         return node;
> > }
> >
> > node will will be always 255 or 65535
> >
>
> Right.
>
> > please keep that to int.
> >
> > I got
> > SART: PXM 0 -> APIC 0 -> Node 255
> > SART: PXM 0 -> APIC 1 -> Node 255
> > SART: PXM 1 -> APIC 2 -> Node 255
> > SART: PXM 1 -> APIC 3 -> Node 255
> >
>
> I assume this is a typo and those proximity mappings are actually from the
> SRAT.

SRAT for processor only have
PXM and APIC id. setup_node(pxm) will get node id for pxm, start from 0...

> >         if (node < 0){
> >                 if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
> >                         return NID_INVAL;
> >                 node = first_unset_node(nodes_found_map);
> >                 __acpi_map_pxm_to_node(pxm, node);
> >                 node_set(node, nodes_found_map);
> >         }

YH
