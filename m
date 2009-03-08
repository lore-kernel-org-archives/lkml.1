Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZCHXQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZCHXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZCHXQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:16:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:13897 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZCHXQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hlQpnhsMYJu312Tt9jgUv2QuSe/uEHR0GL01tC1BYapkgj5dQ4Q/hP9OsjoChZ1gV2
         nQepQeKdMYhui2VPW5rnIbZdZ9ecDR8BpsvOdcAb0hEN/fVGh2HS77ZLt9DQhk9BOb35
         cdcUzods+eHVt6JENrCH5qzvSrPR47P1gUOS8=
MIME-Version: 1.0
In-Reply-To: <tip-a71edd1f46c8a599509bda478fb4eea27fb0da63@git.kernel.org>
References: <49AE485B.8000902@kernel.org>
	 <tip-a71edd1f46c8a599509bda478fb4eea27fb0da63@git.kernel.org>
Date: Sun, 8 Mar 2009 16:16:14 -0700
X-Google-Sender-Auth: d581b683972e037a
Message-ID: <86802c440903081616j3a50cc97yc4fe374e740f84c1@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86: fix bootmem cross node for 32bit numa
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we may need this one (and two followings one)  to be applied for
stable with 2.6.27, 2.6.28, 2.6.29.

YH

On Wed, Mar 4, 2009 at 1:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Commit-ID:  a71edd1f46c8a599509bda478fb4eea27fb0da63
> Gitweb:     http://git.kernel.org/tip/a71edd1f46c8a599509bda478fb4eea27fb0da63
> Author:     "Yinghai Lu" <yinghai@kernel.org>
> AuthorDate: Wed, 4 Mar 2009 01:22:35 -0800
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 4 Mar 2009 20:55:03 +0100
>
> x86: fix bootmem cross node for 32bit numa
>
> Impact: fix panic on system 2g x4 sockets
>
> Found one system with 4 sockets and every sockets has 2g can not boot
> with numa32 because boot mem is crossing nodes.
>
> So try to have numa version of setup_bootmem_allocator().
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <49AE485B.8000902@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
> ---
>  arch/x86/mm/init_32.c |   46 ++++++++++++++++++++++++++++++++++++++++------
>  arch/x86/mm/numa_32.c |    5 +++--
>  2 files changed, 43 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 917c4e6..67bdb59 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -776,9 +776,37 @@ static void __init zone_sizes_init(void)
>        free_area_init_nodes(max_zone_pfns);
>  }
>
> +#ifdef CONFIG_NEED_MULTIPLE_NODES
> +static unsigned long __init setup_node_bootmem(int nodeid,
> +                                unsigned long start_pfn,
> +                                unsigned long end_pfn,
> +                                unsigned long bootmap)
> +{
> +       unsigned long bootmap_size;
> +
> +       if (start_pfn > max_low_pfn)
> +               return bootmap;
> +       if (end_pfn > max_low_pfn)
> +               end_pfn = max_low_pfn;
> +
> +       /* don't touch min_low_pfn */
> +       bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
> +                                        bootmap >> PAGE_SHIFT,
> +                                        start_pfn, end_pfn);
> +       printk(KERN_INFO "  node %d low ram: %08lx - %08lx\n",
> +               nodeid, start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
> +       printk(KERN_INFO "  node %d bootmap %08lx - %08lx\n",
> +                nodeid, bootmap, bootmap + bootmap_size);
> +       free_bootmem_with_active_regions(nodeid, end_pfn);
> +       early_res_to_bootmem(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
> +
> +       return bootmap + bootmap_size;
> +}
> +#endif
> +
>  void __init setup_bootmem_allocator(void)
>  {
> -       int i;
> +       int nodeid;
>        unsigned long bootmap_size, bootmap;
>        /*
>         * Initialize the boot-time allocator (with low memory only):
> @@ -791,18 +819,24 @@ void __init setup_bootmem_allocator(void)
>                panic("Cannot find bootmem map of size %ld\n", bootmap_size);
>        reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
>
> -       /* don't touch min_low_pfn */
> -       bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
> -                                        min_low_pfn, max_low_pfn);
>        printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
>                 max_pfn_mapped<<PAGE_SHIFT);
>        printk(KERN_INFO "  low ram: %08lx - %08lx\n",
>                 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
> +
> +#ifdef CONFIG_NEED_MULTIPLE_NODES
> +       for_each_online_node(nodeid)
> +               bootmap = setup_node_bootmem(nodeid, node_start_pfn[nodeid],
> +                                       node_end_pfn[nodeid], bootmap);
> +#else
> +       /* don't touch min_low_pfn */
> +       bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
> +                                        min_low_pfn, max_low_pfn);
>        printk(KERN_INFO "  bootmap %08lx - %08lx\n",
>                 bootmap, bootmap + bootmap_size);
> -       for_each_online_node(i)
> -               free_bootmem_with_active_regions(i, max_low_pfn);
> +       free_bootmem_with_active_regions(0, max_low_pfn);
>        early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
> +#endif
>
>        after_init_bootmem = 1;
>  }
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 451fe95..3daefa0 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -416,10 +416,11 @@ void __init initmem_init(unsigned long start_pfn,
>        for_each_online_node(nid)
>                propagate_e820_map_node(nid);
>
> -       for_each_online_node(nid)
> +       for_each_online_node(nid) {
>                memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
> +               NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
> +       }
>
> -       NODE_DATA(0)->bdata = &bootmem_node_data[0];
>        setup_bootmem_allocator();
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
