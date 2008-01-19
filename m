Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbYASEEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbYASEEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbYASED5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:03:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:64754 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbYASED4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KytA3lCNe706BLBIk2Akd5iFakCMzlpOYt6uvHJ8WCnNv4WO1g1RCPCS6mW0OhCNrVbL1NeRai0JKCDw9Rbgip3HtZ+3K1aTNBMQNYD66DIAYQuUczsBb/d7C7IX6z8Cq8Mo8yiSxo2X4bXvOTALRr/6hGs0vZWoaCZPOlnvHxI=
Message-ID: <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com>
Date: Fri, 18 Jan 2008 20:03:54 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: travis@sgi.com
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       mingo@elte.hu, "Christoph Lameter" <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <20080118183011.527888000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118183011.354965000@sgi.com>
	 <20080118183011.527888000@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 10:30 AM,  <travis@sgi.com> wrote:
> Change the size of node ids for X86_64 from 8 bits to 16 bits
> to accomodate more than 256 nodes.
>
> Introduce a "numanode_t" type for x86-generic usage.
>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
> ---
> Fixup:
>
> Size of memnode.embedded_map needs to be changed to
> accomodate 16-bit node ids as suggested by Eric.
>
> V2->V3:
>     - changed memnode.embedded_map from [64-16] to [64-8]
>       (and size comment to 128 bytes)
>
> V1->V2:
>     - changed pxm_to_node_map to u16
>     - changed memnode map entries to u16
> ---
>  arch/x86/mm/numa_64.c       |    2 +-
>  drivers/acpi/numa.c         |    2 +-
>  include/asm-x86/mmzone_64.h |    6 +++---
>  include/linux/numa.h        |    6 ++++++
>  4 files changed, 11 insertions(+), 5 deletions(-)
>
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -88,7 +88,7 @@ static int __init allocate_cachealigned_
>         unsigned long pad, pad_addr;
>
>         memnodemap = memnode.embedded_map;
> -       if (memnodemapsize <= 48)
> +       if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
>                 return 0;
>
>         pad = L1_CACHE_BYTES - 1;
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -38,7 +38,7 @@ ACPI_MODULE_NAME("numa");
>  static nodemask_t nodes_found_map = NODE_MASK_NONE;
>
>  /* maps to convert between proximity domain and logical node ID */
> -static int pxm_to_node_map[MAX_PXM_DOMAINS]
> +static numanode_t pxm_to_node_map[MAX_PXM_DOMAINS]
>                                 = { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
>  static int node_to_pxm_map[MAX_NUMNODES]
>                                 = { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
...>
>  #define MAX_NUMNODES    (1 << NODES_SHIFT)
>
> +#if MAX_NUMNODES > 256
> +typedef u16 numanode_t;
> +#else
> +typedef u8 numanode_t;
> +#endif
> +
>  #endif /* _LINUX_NUMA_H */

that is wrong, you can not change pxm_to_node_map from int to u8 or u16.

int acpi_map_pxm_to_node(int pxm)
{
        int node = pxm_to_node_map[pxm];

        if (node < 0){
                if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
                        return NID_INVAL;
                node = first_unset_node(nodes_found_map);
                __acpi_map_pxm_to_node(pxm, node);
                node_set(node, nodes_found_map);
        }

        return node;
}

node will will be always 255 or 65535

please keep that to int.

I got
SART: PXM 0 -> APIC 0 -> Node 255
SART: PXM 0 -> APIC 1 -> Node 255
SART: PXM 1 -> APIC 2 -> Node 255
SART: PXM 1 -> APIC 3 -> Node 255

YH
